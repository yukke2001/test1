<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.*" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>簡易データベースクリーンアップ</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; }
        .success { color: #28a745; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .error { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { color: #17a2b8; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .btn { padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 5px; display: inline-block; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-success { background: #28a745; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧹 簡易データベースクリーンアップ</h1>
        
        <%
            String action = request.getParameter("action");
            boolean executed = false;
            String result = "";
            
            if ("cleanup".equals(action)) {
                executed = true;
                try {
                    Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE email = 'test@example.com' OR username = 'testuser001'");
                    int deletedRows = stmt.executeUpdate();
                    conn.commit();
                    conn.close();
                    
                    result = "✅ クリーンアップ完了: " + deletedRows + "件のテストユーザーを削除しました。";
                    
                } catch (Exception e) {
                    result = "❌ エラー: " + e.getMessage();
                }
            }
            
            if ("test".equals(action)) {
                executed = true;
                try {
                    UserDAO userDAO = new UserDAO();
                    String hashedPassword = UserDAO.hashPassword("TestPassword123");
                    User testUser = new User("testuser001", "test@example.com", hashedPassword, "Test User");
                    
                    boolean createResult = userDAO.createUser(testUser);
                    
                    if (createResult) {
                        result = "✅ ユーザー登録テスト成功！";
                    } else {
                        result = "❌ ユーザー登録テストに失敗";
                    }
                    
                } catch (Exception e) {
                    result = "❌ エラー: " + e.getMessage();
                }
            }
        %>
        
        <% if (executed && result.startsWith("✅")) { %>
            <div class="success"><%= result %></div>
        <% } else if (executed) { %>
            <div class="error"><%= result %></div>
        <% } %>
        
        <div class="info">
            <h3>📋 現在の状況</h3>
            <p>メールアドレス 'test@example.com' が既に存在するため、ユーザー登録が失敗しています。</p>
            <p>まず既存のテストデータをクリーンアップしてから、新しいユーザー登録をテストしてください。</p>
        </div>
        
        <div style="margin: 20px 0;">
            <h3>🎯 アクション</h3>
            <a href="?action=cleanup" class="btn btn-danger" onclick="return confirm('テストユーザーを削除しますか？')">
                🧹 テストデータ削除
            </a>
            <a href="?action=test" class="btn btn-success">
                🧪 ユーザー登録テスト
            </a>
        </div>
        
        <div style="margin-top: 30px;">
            <a href="authentication_test.jsp" class="btn btn-success">認証テストページに戻る</a>
            <a href="register.jsp" class="btn btn-success">登録ページをテスト</a>
        </div>
    </div>
</body>
</html>
