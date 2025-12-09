<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ユーザー登録デバッグ診断</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .success { color: #28a745; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .error { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { color: #17a2b8; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 ユーザー登録デバッグ診断</h1>
        
        <!-- テスト1: データベース基本接続確認 -->
        <div class="test-section">
            <h3>テスト1: データベース基本接続確認</h3>
            <%
                boolean dbConnected = false;
                String dbMessage = "";
                try {
                    Connection testConn = DatabaseConnection.getConnection();
                    if (testConn != null && !testConn.isClosed()) {
                        dbConnected = true;
                        dbMessage = "データベース接続成功";
                        testConn.close();
                    } else {
                        dbMessage = "接続オブジェクトが null または閉じている";
                    }
                } catch (Exception e) {
                    dbMessage = "例外発生: " + e.getMessage();
                }
            %>
            <% if (dbConnected) { %>
                <div class="success">✅ <%= dbMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= dbMessage %></div>
            <% } %>
        </div>
        
        <!-- テスト2: UserDAOインスタンス作成 -->
        <div class="test-section">
            <h3>テスト2: UserDAOインスタンス作成</h3>
            <%
                boolean userDaoCreated = false;
                String userDaoMessage = "";
                UserDAO userDAO = null;
                try {
                    userDAO = new UserDAO();
                    userDaoCreated = true;
                    userDaoMessage = "UserDAOインスタンス作成成功";
                } catch (Exception e) {
                    userDaoMessage = "例外発生: " + e.getMessage();
                }
            %>
            <% if (userDaoCreated) { %>
                <div class="success">✅ <%= userDaoMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= userDaoMessage %></div>
            <% } %>
        </div>
        
        <!-- テスト3: パスワードハッシュ化テスト -->
        <div class="test-section">
            <h3>テスト3: パスワードハッシュ化テスト</h3>
            <%
                boolean passwordHashSuccess = false;
                String passwordHashMessage = "";
                String hashedPassword = "";
                try {
                    hashedPassword = UserDAO.hashPassword("TestPassword123");
                    if (hashedPassword != null && hashedPassword.length() > 0) {
                        passwordHashSuccess = true;
                        passwordHashMessage = "パスワードハッシュ化成功: " + hashedPassword.substring(0, Math.min(20, hashedPassword.length())) + "...";
                    } else {
                        passwordHashMessage = "ハッシュ値が空または null";
                    }
                } catch (Exception e) {
                    passwordHashMessage = "例外発生: " + e.getMessage();
                }
            %>
            <% if (passwordHashSuccess) { %>
                <div class="success">✅ <%= passwordHashMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= passwordHashMessage %></div>
            <% } %>
        </div>
        
        <!-- テスト4: ユーザー名重複チェック -->
        <div class="test-section">
            <h3>テスト4: ユーザー名重複チェック</h3>
            <%
                boolean usernameCheckSuccess = false;
                String usernameCheckMessage = "";
                if (userDAO != null) {
                    try {
                        boolean exists = userDAO.isUsernameExists("testuser001");
                        usernameCheckSuccess = true;
                        usernameCheckMessage = "ユーザー名 'testuser001' の存在確認: " + (exists ? "存在する" : "存在しない");
                    } catch (Exception e) {
                        usernameCheckMessage = "例外発生: " + e.getMessage();
                    }
                } else {
                    usernameCheckMessage = "UserDAOが作成されていません";
                }
            %>
            <% if (usernameCheckSuccess) { %>
                <div class="info">ℹ️ <%= usernameCheckMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= usernameCheckMessage %></div>
            <% } %>
        </div>
        
        <!-- テスト5: Userオブジェクト作成 -->
        <div class="test-section">
            <h3>テスト5: Userオブジェクト作成</h3>
            <%
                boolean userObjectSuccess = false;
                String userObjectMessage = "";
                User testUser = null;
                try {
                    if (passwordHashSuccess) {
                        testUser = new User("testuser001", "test@example.com", hashedPassword, "Test User");
                        if (testUser != null && testUser.getUsername() != null) {
                            userObjectSuccess = true;
                            userObjectMessage = "Userオブジェクト作成成功 - ユーザー名: " + testUser.getUsername();
                        } else {
                            userObjectMessage = "Userオブジェクトまたはユーザー名が null";
                        }
                    } else {
                        userObjectMessage = "パスワードハッシュ化に失敗したためスキップ";
                    }
                } catch (Exception e) {
                    userObjectMessage = "例外発生: " + e.getMessage();
                }
            %>
            <% if (userObjectSuccess) { %>
                <div class="success">✅ <%= userObjectMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= userObjectMessage %></div>
            <% } %>
        </div>
        
        <!-- テスト6: ユーザー作成テスト（実際の登録処理） -->
        <div class="test-section">
            <h3>テスト6: ユーザー作成テスト</h3>
            <%
                boolean userCreationSuccess = false;
                String userCreationMessage = "";
                
                if (userDAO != null && testUser != null && userObjectSuccess) {
                    try {
                        // まず既存のテストユーザーをクリーンアップ
                        boolean cleanupResult = true; // userDAO.deleteUser("testuser001"); // 存在しない場合は無視
                        
                        boolean createResult = userDAO.createUser(testUser);
                        if (createResult) {
                            userCreationSuccess = true;
                            userCreationMessage = "ユーザー作成成功！";
                        } else {
                            userCreationMessage = "ユーザー作成に失敗（createUserがfalseを返却）";
                        }
                    } catch (Exception e) {
                        userCreationMessage = "例外発生: " + e.getMessage();
                        e.printStackTrace(); // サーバーログに詳細出力
                    }
                } else {
                    userCreationMessage = "前のテストが失敗したためスキップ";
                }
            %>
            <% if (userCreationSuccess) { %>
                <div class="success">✅ <%= userCreationMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= userCreationMessage %></div>
            <% } %>
        </div>
        
        <!-- テスト7: 認証テスト -->
        <div class="test-section">
            <h3>テスト7: 認証テスト</h3>
            <%
                boolean authSuccess = false;
                String authMessage = "";
                
                if (userDAO != null && userCreationSuccess && hashedPassword != null) {
                    try {
                        Map<String, Object> authResult = userDAO.authenticateUser("testuser001", hashedPassword);
                        if (authResult != null && !authResult.isEmpty()) {
                            authSuccess = true;
                            authMessage = "認証成功 - ユーザーID: " + authResult.get("user_id");
                        } else {
                            authMessage = "認証失敗（認証結果が null または空）";
                        }
                    } catch (Exception e) {
                        authMessage = "例外発生: " + e.getMessage();
                    }
                } else {
                    authMessage = "前のテストが失敗したためスキップ";
                }
            %>
            <% if (authSuccess) { %>
                <div class="success">✅ <%= authMessage %></div>
            <% } else { %>
                <div class="error">❌ <%= authMessage %></div>
            <% } %>
        </div>
        
        <!-- 総合結果 -->
        <div class="test-section">
            <h3>📋 総合診断結果</h3>
            <%
                int passedTests = 0;
                int totalTests = 7;
                
                if (dbConnected) passedTests++;
                if (userDaoCreated) passedTests++;
                if (passwordHashSuccess) passedTests++;
                if (usernameCheckSuccess) passedTests++;
                if (userObjectSuccess) passedTests++;
                if (userCreationSuccess) passedTests++;
                if (authSuccess) passedTests++;
                
                String resultClass = (passedTests == totalTests) ? "success" : ((passedTests >= 4) ? "info" : "error");
            %>
            <div class="<%= resultClass %>">
                <h4>テスト結果: <%= passedTests %> / <%= totalTests %> 合格</h4>
                <% if (passedTests == totalTests) { %>
                    <p>🎉 すべてのテストが合格しました！認証システムは正常に動作しています。</p>
                <% } else if (passedTests >= 4) { %>
                    <p>⚠️ 一部のテストが失敗していますが、基本機能は動作している可能性があります。</p>
                <% } else { %>
                    <p>❌ 複数のテストが失敗しています。システムの設定を確認してください。</p>
                <% } %>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="authentication_test.jsp" style="padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px;">認証テストに戻る</a>
            <a href="register.jsp" style="padding: 10px 20px; background: #28a745; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">登録ページ</a>
        </div>
    </div>
</body>
</html>
