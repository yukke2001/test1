/*
 * 【ユーザーデータアクセスオブジェクト】
 * UserDAO.java
 * 
 * 役割：ユーザー情報に関するデータベース操作を担当
 * 
 * 主な機能：
 * 1. ユーザーの作成・読み取り・更新・削除（CRUD）
 * 2. ユーザー認証関連機能
 * 3. ユーザー検索・一覧取得
 * 4. パスワードハッシュ化・検証
 * 
 * 設計パターン：DAO（Data Access Object）パターン
 */
package com.example;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

/**
 * ユーザー情報データアクセスクラス
 * 
 * データベースのusersテーブルに対する
 * すべてのCRUD操作を管理します。
 */
public class UserDAO {
    
    // SQL文定義
    private static final String INSERT_USER_SQL = 
        "INSERT INTO users (username, email, password_hash, display_name, created_at, updated_at) " +
        "VALUES (?, ?, ?, ?, NOW(), NOW())";
    
    private static final String SELECT_USER_BY_ID_SQL = 
        "SELECT user_id, username, email, password_hash, display_name, created_at, updated_at, last_login, is_active " +
        "FROM users WHERE user_id = ? AND is_active = true";
    
    private static final String SELECT_USER_BY_USERNAME_SQL = 
        "SELECT user_id, username, email, password_hash, display_name, created_at, updated_at, last_login, is_active " +
        "FROM users WHERE username = ? AND is_active = true";
    
    private static final String UPDATE_USER_SQL = 
        "UPDATE users SET email = ?, display_name = ?, updated_at = NOW() WHERE user_id = ?";
    
        private static final String UPDATE_LAST_LOGIN_SQL = 
        "UPDATE users SET last_login = NOW() WHERE user_id = ?";
    
    private static final String CHECK_USERNAME_EXISTS_SQL = 
        "SELECT COUNT(*) FROM users WHERE username = ?";
    
    private static final String CHECK_EMAIL_EXISTS_SQL =
        "SELECT COUNT(*) FROM users WHERE email = ?";
    
    /**
     * 新しいユーザーを作成する
     * 
     * @param user 作成するユーザー情報
     * @return boolean 作成成功時はtrue
     * @throws SQLException データベースエラー
     */
    public boolean createUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // 入力検証
            if (!user.isValid()) {
                System.err.println("無効なユーザー情報: " + user);
                return false;
            }
            
            // ユーザー名とメールアドレスの重複チェック
            if (isUsernameExists(conn, user.getUsername())) {
                System.err.println("ユーザー名が既に存在します: " + user.getUsername());
                return false;
            }
            
            if (user.getEmail() != null && isEmailExists(conn, user.getEmail())) {
                System.err.println("メールアドレスが既に存在します: " + user.getEmail());
                return false;
            }
            
            stmt = conn.prepareStatement(INSERT_USER_SQL, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getDisplayName());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // 生成されたuser_idを取得
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                }
                
                DatabaseConnection.commit(conn);
                System.out.println("ユーザー作成成功: " + user.getUsername());
                return true;
            }
            
            return false;
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBCドライバーエラー: " + e.getMessage());
            DatabaseConnection.rollback(conn);
            return false;
        } catch (SQLException e) {
            System.err.println("ユーザー作成エラー: " + e.getMessage());
            DatabaseConnection.rollback(conn);
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * ユーザーIDでユーザーを取得する
     * 
     * @param userId ユーザーID
     * @return User ユーザー情報（見つからない場合はnull）
     * @throws SQLException データベースエラー
     */
    public User getUserById(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_USER_BY_ID_SQL);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
            return null;
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBCドライバーエラー: " + e.getMessage());
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * ユーザー名でユーザーを取得する
     * 
     * @param username ユーザー名
     * @return User ユーザー情報（見つからない場合はnull）
     * @throws SQLException データベースエラー
     */
    public User getUserByUsername(String username) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_USER_BY_USERNAME_SQL);
            stmt.setString(1, username);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
            return null;
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBCドライバーエラー: " + e.getMessage());
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * ユーザー情報を更新する
     * 
     * @param user 更新するユーザー情報
     * @return boolean 更新成功時はtrue
     * @throws SQLException データベースエラー
     */
    public boolean updateUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(UPDATE_USER_SQL);
            
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getDisplayName());
            stmt.setInt(3, user.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                DatabaseConnection.commit(conn);
                System.out.println("ユーザー情報更新成功: " + user.getUsername());
                return true;
            }
            
            return false;
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBCドライバーエラー: " + e.getMessage());
            DatabaseConnection.rollback(conn);
            return false;
        } finally {
            if (stmt != null) stmt.close();
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * 最終ログイン時刻を更新する
     * 
     * @param userId ユーザーID
     * @return boolean 更新成功時はtrue
     */
    public boolean updateLastLogin(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(UPDATE_LAST_LOGIN_SQL);
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            DatabaseConnection.commit(conn);
            
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("最終ログイン更新エラー: " + e.getMessage());
            DatabaseConnection.rollback(conn);
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                DatabaseConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("リソースクローズエラー: " + e.getMessage());
            }
        }
    }
    
    /**
     * パスワードを検証する
     * 
     * @param username ユーザー名
     * @param password 平文パスワード
     * @return boolean 認証成功時はtrue
     */
    public boolean validatePassword(String username, String password) {
        try {
            User user = getUserByUsername(username);
            if (user == null) {
                return false;
            }
            
            String hashedPassword = hashPassword(password);
            return user.getPasswordHash().equals(hashedPassword);
            
        } catch (Exception e) {
            System.err.println("パスワード検証エラー: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * パスワードをハッシュ化する（簡易版）
     * 本番環境ではBCryptなどより強固なハッシュ化を推奨
     * 
     * @param password 平文パスワード
     * @return String ハッシュ化されたパスワード
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            
            return sb.toString();
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256アルゴリズムが見つかりません", e);
        }
    }
    
    /**
     * ユーザー名の存在チェック
     */
    private boolean isUsernameExists(Connection conn, String username) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement(CHECK_USERNAME_EXISTS_SQL);
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        return false;
    }
    
    /**
     * メールアドレスの存在チェック
     */
    private boolean isEmailExists(Connection conn, String email) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement(CHECK_EMAIL_EXISTS_SQL);
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        return false;
    }
    
    /**
     * ResultSetからUserオブジェクトを生成する
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setDisplayName(rs.getString("display_name"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setActive(rs.getBoolean("is_active"));
        
        return user;
    }
    
    /**
     * ユーザー認証メソッド
     * 
     * @param username ユーザー名
     * @param hashedPassword ハッシュ化されたパスワード
     * @return 認証成功時はユーザー情報Map、失敗時はnull
     */
    public Map<String, Object> authenticateUser(String username, String hashedPassword) {
        String sql = "SELECT user_id, username, email, display_name, created_at, last_login " +
                    "FROM users WHERE username = ? AND password_hash = ? AND is_active = true";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Map<String, Object> userInfo = new HashMap<>();
                userInfo.put("userId", rs.getLong("user_id"));
                userInfo.put("username", rs.getString("username"));
                userInfo.put("email", rs.getString("email"));
                userInfo.put("displayName", rs.getString("display_name"));
                userInfo.put("createdAt", rs.getTimestamp("created_at"));
                userInfo.put("lastLogin", rs.getTimestamp("last_login"));
                
                // ログイン時刻を更新
                updateLastLogin(conn, rs.getLong("user_id"));
                
                // トランザクションをコミット
                DatabaseConnection.commit(conn);
                
                return userInfo;
            }
            
        } catch (Exception e) {
            System.err.println("ユーザー認証エラー: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null; // 認証失敗
    }
    
    /**
     * ユーザー名の重複チェック（公開メソッド）
     */
    public boolean isUsernameExists(String username) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return isUsernameExists(conn, username);
        } catch (Exception e) {
            System.err.println("ユーザー名重複チェックエラー: " + e.getMessage());
            return true; // エラー時は重複ありと判定（安全側）
        }
    }
    
    /**
     * メールアドレスの重複チェック（公開メソッド）
     */
    public boolean isEmailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false; // 空の場合は重複なし
        }
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            return isEmailExists(conn, email);
        } catch (Exception e) {
            System.err.println("メールアドレス重複チェックエラー: " + e.getMessage());
            return true; // エラー時は重複ありと判定（安全側）
        }
    }
    
    /**
     * 最終ログイン時刻の更新
     */
    private void updateLastLogin(Connection conn, long userId) {
        String sql = "UPDATE users SET last_login = NOW() WHERE user_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("最終ログイン時刻更新エラー: " + e.getMessage());
            // エラーが発生しても認証処理は継続
        }
    }
}
