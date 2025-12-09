<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>詳細ユーザー作成デバッグ</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .success { color: #28a745; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .error { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { color: #17a2b8; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .code-block { background: #f8f9fa; padding: 10px; border-radius: 4px; font-family: monospace; white-space: pre-wrap; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 詳細ユーザー作成デバッグ</h1>
        
        <%
            // テストデータ準備
            String testUsername = "testuser001";
            String testEmail = "test@example.com";
            String testPassword = "TestPassword123";
            String testDisplayName = "Test User";
            
            UserDAO userDAO = new UserDAO();
            String hashedPassword = UserDAO.hashPassword(testPassword);
            User testUser = new User(testUsername, testEmail, hashedPassword, testDisplayName);
        %>
        
        <!-- ユーザーオブジェクト詳細検査 -->
        <div class="test-section">
            <h3>📋 ユーザーオブジェクト詳細検査</h3>
            <div class="code-block">ユーザー名: <%= testUser.getUsername() %>
メール: <%= testUser.getEmail() %>
表示名: <%= testUser.getDisplayName() %>
パスワードハッシュ: <%= testUser.getPasswordHash() != null ? testUser.getPasswordHash().substring(0, Math.min(20, testUser.getPasswordHash().length())) + "..." : "NULL" %>
パスワードハッシュ長: <%= testUser.getPasswordHash() != null ? testUser.getPasswordHash().length() : "NULL" %>
ユーザーID: <%= testUser.getUserId() %>
アクティブ状態: <%= testUser.isActive() %></div>
        </div>
        
        <!-- isValid()詳細チェック -->
        <div class="test-section">
            <h3>🔍 isValid()詳細チェック</h3>
            <%
                boolean isValidResult = testUser.isValid();
                boolean usernameValid = testUser.getUsername() != null && !testUser.getUsername().trim().isEmpty() &&
                                      testUser.getUsername().length() >= 3 && testUser.getUsername().length() <= 50;
                boolean passwordHashValid = testUser.getPasswordHash() != null && !testUser.getPasswordHash().trim().isEmpty();
                boolean emailValid = testUser.getEmail() == null || testUser.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$");
            %>
            <div class="code-block">総合 isValid() 結果: <%= isValidResult %>

個別検証結果:
- ユーザー名検証: <%= usernameValid %>
  - null でない: <%= testUser.getUsername() != null %>
  - 空でない: <%= testUser.getUsername() != null && !testUser.getUsername().trim().isEmpty() %>
  - 長さ 3-50: <%= testUser.getUsername() != null && testUser.getUsername().length() >= 3 && testUser.getUsername().length() <= 50 %>
  - 実際の長さ: <%= testUser.getUsername() != null ? testUser.getUsername().length() : "NULL" %>

- パスワードハッシュ検証: <%= passwordHashValid %>
  - null でない: <%= testUser.getPasswordHash() != null %>
  - 空でない: <%= testUser.getPasswordHash() != null && !testUser.getPasswordHash().trim().isEmpty() %>

- メール検証: <%= emailValid %>
  - メール: <%= testUser.getEmail() %>
  - パターンマッチ: <%= testUser.getEmail() != null && testUser.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$") %></div>
        </div>
        
        <!-- 重複チェック詳細 -->
        <div class="test-section">
            <h3>🔄 重複チェック詳細</h3>
            <%
                boolean usernameExists = false;
                boolean emailExists = false;
                String duplicateCheckMessage = "";
                
                try {
                    usernameExists = userDAO.isUsernameExists(testUsername);
                    emailExists = userDAO.isEmailExists(testEmail);
                    duplicateCheckMessage = "重複チェック正常完了";
                } catch (Exception e) {
                    duplicateCheckMessage = "重複チェック例外: " + e.getMessage();
                }
            %>
            <div class="code-block">重複チェック結果:
- ユーザー名 '<%= testUsername %>' 存在: <%= usernameExists %>
- メール '<%= testEmail %>' 存在: <%= emailExists %>
- チェック状態: <%= duplicateCheckMessage %></div>
        </div>
        
        <!-- データベーステーブル構造確認 -->
        <div class="test-section">
            <h3>🗄️ データベーステーブル構造確認</h3>
            <%
                String tableStructure = "";
                try {
                    Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(
                        "SELECT column_name, data_type, is_nullable, column_default " +
                        "FROM information_schema.columns " +
                        "WHERE table_name = 'users' AND table_schema = 'public' " +
                        "ORDER BY ordinal_position"
                    );
                    ResultSet rs = stmt.executeQuery();
                    
                    StringBuilder structure = new StringBuilder();
                    while (rs.next()) {
                        structure.append("列名: ").append(rs.getString("column_name"))
                                .append(" | 型: ").append(rs.getString("data_type"))
                                .append(" | NULL許可: ").append(rs.getString("is_nullable"))
                                .append(" | デフォルト: ").append(rs.getString("column_default"))
                                .append("\n");
                    }
                    tableStructure = structure.toString();
                    
                    conn.close();
                } catch (Exception e) {
                    tableStructure = "エラー: " + e.getMessage();
                }
            %>
            <div class="code-block"><%= tableStructure %></div>
        </div>
        
        <!-- 実際のSQL実行テスト -->
        <div class="test-section">
            <h3>💾 実際のSQL実行テスト</h3>
            <%
                String sqlTestResult = "";
                boolean sqlSuccess = false;
                
                if (isValidResult && !usernameExists && !emailExists) {
                    try {
                        Connection conn = DatabaseConnection.getConnection();
                        
                        // INSERT_USER_SQLの内容を確認
                        String insertSql = "INSERT INTO users (username, email, password_hash, display_name, created_at, updated_at, is_active) " +
                                         "VALUES (?, ?, ?, ?, NOW(), NOW(), true)";
                        
                        PreparedStatement stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                        stmt.setString(1, testUser.getUsername());
                        stmt.setString(2, testUser.getEmail());
                        stmt.setString(3, testUser.getPasswordHash());
                        stmt.setString(4, testUser.getDisplayName());
                        
                        sqlTestResult += "実行SQL: " + insertSql + "\n";
                        sqlTestResult += "パラメータ:\n";
                        sqlTestResult += "1: " + testUser.getUsername() + "\n";
                        sqlTestResult += "2: " + testUser.getEmail() + "\n";
                        sqlTestResult += "3: " + testUser.getPasswordHash().substring(0, Math.min(20, testUser.getPasswordHash().length())) + "...\n";
                        sqlTestResult += "4: " + testUser.getDisplayName() + "\n\n";
                        
                        int rowsAffected = stmt.executeUpdate();
                        sqlTestResult += "影響を受けた行数: " + rowsAffected + "\n";
                        
                        if (rowsAffected > 0) {
                            ResultSet generatedKeys = stmt.getGeneratedKeys();
                            if (generatedKeys.next()) {
                                int generatedId = generatedKeys.getInt(1);
                                sqlTestResult += "生成されたID: " + generatedId + "\n";
                            }
                            sqlSuccess = true;
                            sqlTestResult += "SQL実行成功！";
                        } else {
                            sqlTestResult += "警告: 行が挿入されませんでした";
                        }
                        
                        conn.close();
                        
                    } catch (Exception e) {
                        sqlTestResult += "SQL実行エラー: " + e.getMessage() + "\n";
                        sqlTestResult += "エラータイプ: " + e.getClass().getSimpleName();
                        e.printStackTrace();
                    }
                } else {
                    sqlTestResult = "前提条件が満たされていないためスキップ:\n";
                    sqlTestResult += "- isValid: " + isValidResult + "\n";
                    sqlTestResult += "- ユーザー名重複なし: " + (!usernameExists) + "\n";
                    sqlTestResult += "- メール重複なし: " + (!emailExists);
                }
            %>
            <% if (sqlSuccess) { %>
                <div class="success">✅ SQL実行成功</div>
            <% } else { %>
                <div class="error">❌ SQL実行失敗または未実行</div>
            <% } %>
            <div class="code-block"><%= sqlTestResult %></div>
        </div>
        
        <!-- 総合診断 -->
        <div class="test-section">
            <h3>📋 問題診断と推奨対処法</h3>
            <%
                String diagnosis = "";
                
                if (!isValidResult) {
                    diagnosis += "❌ 主要問題: User.isValid()がfalseを返している\n";
                    if (!usernameValid) {
                        diagnosis += "  - ユーザー名検証失敗\n";
                    }
                    if (!passwordHashValid) {
                        diagnosis += "  - パスワードハッシュ検証失敗\n";
                    }
                    if (!emailValid) {
                        diagnosis += "  - メール形式検証失敗\n";
                    }
                } else if (usernameExists || emailExists) {
                    diagnosis += "❌ 主要問題: データの重複\n";
                    if (usernameExists) {
                        diagnosis += "  - ユーザー名が既に存在\n";
                    }
                    if (emailExists) {
                        diagnosis += "  - メールアドレスが既に存在\n";
                    }
                } else if (!sqlSuccess) {
                    diagnosis += "❌ 主要問題: SQL実行エラー\n";
                    diagnosis += "  - データベース制約またはSQL構文の問題の可能性\n";
                } else {
                    diagnosis += "✅ 全ての検証に合格\n";
                    diagnosis += "  - ユーザー作成が成功するはずです\n";
                }
                
                diagnosis += "\n推奨対処法:\n";
                if (!isValidResult) {
                    diagnosis += "1. User.isValid()の各条件を個別に確認\n";
                    diagnosis += "2. ユーザーオブジェクトの初期化方法を見直し\n";
                } else if (usernameExists || emailExists) {
                    diagnosis += "1. データベースの既存データをクリーンアップ\n";
                    diagnosis += "2. テスト用の一意なデータを使用\n";
                } else {
                    diagnosis += "1. Tomcatサーバーログでより詳細なエラーを確認\n";
                    diagnosis += "2. データベース制約を確認\n";
                }
            %>
            <div class="code-block"><%= diagnosis %></div>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="user_registration_debug.jsp" style="padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px;">基本テストに戻る</a>
        </div>
    </div>
</body>
</html>
