<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.*" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>データベースクリーンアップ</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .success { color: #28a745; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .error { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { color: #17a2b8; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .warning { color: #856404; background: #fff3cd; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .btn { padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 5px; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .code-block { background: #f8f9fa; padding: 10px; border-radius: 4px; font-family: monospace; white-space: pre-wrap; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧹 データベースクリーンアップ & ユーザー登録テスト</h1>
        
        <%
            String action = request.getParameter("action");
            boolean cleanupExecuted = false;
            boolean testExecuted = false;
            String cleanupResult = "";
            String testResult = "";
        %>
        
        <!-- 現在のデータベース状況表示 -->
        <div style="margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px;">
            <h3>📊 現在のデータベース状況</h3>
            <%
                try {
                    Connection conn = DatabaseConnection.getConnection();
                    
                    // 全ユーザー数を取得
                    PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM users");
                    ResultSet countRs = countStmt.executeQuery();
                    countRs.next();
                    int totalUsers = countRs.getInt(1);
                    
                    // テスト関連ユーザーを取得
                    PreparedStatement testStmt = conn.prepareStatement(
                        "SELECT user_id, username, email, created_at FROM users WHERE username LIKE 'test%' OR email LIKE '%test%' OR email = 'test@example.com'"
                    );
                    ResultSet testRs = testStmt.executeQuery();
                    
                    StringBuilder testUsers = new StringBuilder();
                    int testUserCount = 0;
                    while (testRs.next()) {
                        testUserCount++;
                        testUsers.append("ID: ").append(testRs.getInt("user_id"))
                               .append(" | ユーザー名: ").append(testRs.getString("username"))
                               .append(" | メール: ").append(testRs.getString("email"))
                               .append(" | 作成日: ").append(testRs.getTimestamp("created_at"))
                               .append("\n");
                    }
                    
                    conn.close();
            %>
            <div class="code-block">総ユーザー数: <%= totalUsers %>
テスト関連ユーザー数: <%= testUserCount %>

テスト関連ユーザー一覧:
<%= testUsers.length() > 0 ? testUsers.toString() : "なし" %></div>
            <%
                } catch (Exception e) {
            %>
            <div class="error">❌ データベース状況取得エラー: <%= e.getMessage() %></div>
            <%
                }
            %>
        </div>
        
        <!-- クリーンアップ実行 -->
        <%
            if ("cleanup".equals(action)) {
                cleanupExecuted = true;
                try {
                    Connection conn = DatabaseConnection.getConnection();
                    
                    // テスト用ユーザーを削除
                    PreparedStatement deleteStmt = conn.prepareStatement(
                        "DELETE FROM users WHERE username LIKE 'test%' OR email LIKE '%test%' OR email = 'test@example.com'"
                    );
                    int deletedRows = deleteStmt.executeUpdate();
                    
                    conn.commit();
                    conn.close();
                    
                    cleanupResult = "✅ クリーンアップ完了: " + deletedRows + "件のテスト用ユーザーを削除しました。";
                    
                } catch (Exception e) {
                    cleanupResult = "❌ クリーンアップエラー: " + e.getMessage();
                }
            }
        %>
        
        <!-- ユーザー登録テスト実行 -->
        <%
            if ("test".equals(action)) {
                testExecuted = true;
                try {
                    UserDAO userDAO = new UserDAO();
                    String hashedPassword = UserDAO.hashPassword("TestPassword123");
                    User testUser = new User("testuser001", "test@example.com", hashedPassword, "Test User");
                    
                    boolean createResult = userDAO.createUser(testUser);
                    
                    if (createResult) {
                        // 認証テスト
                        Map<String, Object> authResult = userDAO.authenticateUser("testuser001", hashedPassword);
                        if (authResult != null) {
                            testResult = "✅ ユーザー登録・認証テスト成功！\n";
                            testResult += "生成されたユーザーID: " + authResult.get("user_id");
                        } else {
                            testResult = "⚠️ ユーザー登録成功、但し認証テストに失敗";
                        }
                    } else {
                        testResult = "❌ ユーザー登録テストに失敗";
                    }
                    
                } catch (Exception e) {
                    testResult = "❌ テスト実行エラー: " + e.getMessage();
                }
            }
        %>
        
        <!-- 結果表示 -->
        <% if (cleanupExecuted) { %>
        <div style="margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px;">
            <h3>🧹 クリーンアップ結果</h3>
            <% if (cleanupResult.startsWith("✅")) { %>
                <div class="success"><%= cleanupResult %></div>
            <% } else { %>
                <div class="error"><%= cleanupResult %></div>
            <% } %>
        </div>
        <% } %>
        
        <% if (testExecuted) { %>
        <div style="margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px;">
            <h3>🧪 ユーザー登録テスト結果</h3>
            <% if (testResult.startsWith("✅")) { %>
                <div class="success"><%= testResult %></div>
            <% } else if (testResult.startsWith("⚠️")) { %>
                <div class="warning"><%= testResult %></div>
            <% } else { %>
                <div class="error"><%= testResult %></div>
            <% } %>
        </div>
        <% } %>
        
        <!-- アクションボタン -->
        <div style="margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px;">
            <h3>🎯 アクション</h3>
            
            <div class="warning">
                <strong>⚠️ 注意:</strong> クリーンアップはテスト用のユーザーのみを削除します（ユーザー名が'test'で始まるもの、またはメールに'test'が含まれるもの）
            </div>
            
            <div style="margin-top: 15px;">
                <a href="?action=cleanup" class="btn btn-danger" onclick="return confirm('テスト用ユーザーを削除しますか？')">
                    🧹 テストデータをクリーンアップ
                </a>
                
                <a href="?action=test" class="btn btn-success">
                    🧪 ユーザー登録テスト実行
                </a>
                
                <a href="detailed_user_debug.jsp" class="btn btn-primary">
                    🔍 詳細デバッグに戻る
                </a>
            </div>
        </div>
        
        <!-- 手順ガイド -->
        <div style="margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px;">
            <h3>📝 推奨手順</h3>
            <div class="info">
                <ol>
                    <li><strong>クリーンアップ実行</strong>: 既存のテストデータを削除</li>
                    <li><strong>ユーザー登録テスト実行</strong>: 新しいユーザーの作成と認証をテスト</li>
                    <li><strong>認証システム確認</strong>: 実際の登録・ログインフローをブラウザでテスト</li>
                </ol>
            </div>
        </div>
    </div>
</body>
</html>
