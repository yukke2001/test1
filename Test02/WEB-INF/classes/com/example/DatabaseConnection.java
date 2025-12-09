/*
 * 【データベース接続管理クラス】
 * DatabaseConnection.java
 * 
 * 役割：PostgreSQLデータベースとの接続を管理する基盤クラス
 * 
 * 主な機能：
 * 1. データベース接続の取得・管理
 * 2. 接続プールの実装（将来拡張）
 * 3. 設定値の管理
 * 4. 接続エラーハンドリング
 * 
 * 設計パターン：Singleton + Factory パターン
 */
package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

/**
 * データベース接続管理クラス
 * 
 * PostgreSQLとの接続を統一的に管理し、
 * アプリケーション全体で安全に使用できる接続を提供します。
 */
public class DatabaseConnection {
      // データベース接続設定（本来はプロパティファイルから読み込み推奨）
    private static final String DB_DRIVER = "org.postgresql.Driver";
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/memory_game";
    private static final String DB_USERNAME = "postgres";
    private static final String DB_PASSWORD = "Pwd20020726";
    
    // 接続タイムアウト設定
    private static final int CONNECTION_TIMEOUT = 30; // 秒
    private static final int SOCKET_TIMEOUT = 60;     // 秒
    
    /**
     * データベース接続を取得するメソッド
     * 
     * @return Connection オブジェクト
     * @throws SQLException データベース接続エラー
     * @throws ClassNotFoundException JDBCドライバーが見つからない
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            // PostgreSQL JDBCドライバーをロード
            Class.forName(DB_DRIVER);
            
            // 接続プロパティの設定
            Properties props = new Properties();
            props.setProperty("user", DB_USERNAME);
            props.setProperty("password", DB_PASSWORD);
            props.setProperty("loginTimeout", String.valueOf(CONNECTION_TIMEOUT));
            props.setProperty("socketTimeout", String.valueOf(SOCKET_TIMEOUT));
            props.setProperty("ssl", "false"); // 開発環境用（本番では適切に設定）
            props.setProperty("tcpKeepAlive", "true");
            
            // データベース接続の確立
            Connection connection = DriverManager.getConnection(DB_URL, props);
            
            // 自動コミットを無効化（トランザクション制御のため）
            connection.setAutoCommit(false);
            
            System.out.println("データベース接続成功: " + DB_URL);
            return connection;
            
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBCドライバーが見つかりません: " + e.getMessage());
            throw e;
        } catch (SQLException e) {
            System.err.println("データベース接続エラー: " + e.getMessage());
            throw e;
        }
    }
      /**
     * 接続テスト用メソッド
     * 
     * @return boolean 接続可能な場合はtrue
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            // テスト専用の接続（自動コミット有効）
            Class.forName(DB_DRIVER);
            
            Properties props = new Properties();
            props.setProperty("user", DB_USERNAME);
            props.setProperty("password", DB_PASSWORD);
            props.setProperty("ssl", "false");
            props.setProperty("loginTimeout", "10");
            
            conn = DriverManager.getConnection(DB_URL, props);
            // テスト用なので自動コミットを有効のまま
            
            // 簡単なクエリテストを実行
            try (PreparedStatement stmt = conn.prepareStatement("SELECT 1")) {
                ResultSet rs = stmt.executeQuery();
                return rs.next();
            }
            
        } catch (Exception e) {
            System.err.println("接続テスト失敗: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("テスト接続クローズエラー: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * 接続を安全に閉じるメソッド
     * 
     * @param connection 閉じる接続
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("データベース接続を閉じました");
                }
            } catch (SQLException e) {
                System.err.println("接続クローズエラー: " + e.getMessage());
            }
        }
    }
    
    /**
     * トランザクションをコミットする
     * 
     * @param connection 対象の接続
     */
    public static void commit(Connection connection) {
        if (connection != null) {
            try {
                connection.commit();
                System.out.println("トランザクションをコミットしました");
            } catch (SQLException e) {
                System.err.println("コミットエラー: " + e.getMessage());
            }
        }
    }
    
    /**
     * トランザクションをロールバックする
     * 
     * @param connection 対象の接続
     */
    public static void rollback(Connection connection) {
        if (connection != null) {
            try {
                connection.rollback();
                System.out.println("トランザクションをロールバックしました");
            } catch (SQLException e) {
                System.err.println("ロールバックエラー: " + e.getMessage());
            }
        }
    }
    
    /**
     * データベース設定情報を取得する（デバッグ用）
     * 
     * @return String 設定情報の文字列
     */
    public static String getConnectionInfo() {
        return String.format(
            "DB_URL: %s, DB_USERNAME: %s, CONNECTION_TIMEOUT: %d秒", 
            DB_URL, DB_USERNAME, CONNECTION_TIMEOUT
        );
    }
}
