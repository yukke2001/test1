<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.DatabaseConnection" %>
<%@ page import="com.example.UserDAO" %>
<%@ page import="com.example.User" %>
<%@ page import="java.sql.Connection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>データベース接続テスト - Phase 1 確認</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            color: #333;
        }
        
        .test-container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .content {
            padding: 30px;
        }
        
        .test-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #f9f9f9;
        }
        
        .success {
            color: #28a745;
            font-weight: bold;
        }
        
        .error {
            color: #dc3545;
            font-weight: bold;
        }
        
        .info {
            color: #17a2b8;
        }
        
        .test-result {
            margin: 10px 0;
            padding: 10px;
            border-radius: 4px;
            background: white;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        
        .back-link:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="header">
            <h1>🔍 Phase 1 データベース基盤テスト</h1>
            <p>PostgreSQL接続とクラス動作確認</p>
        </div>
        
        <div class="content">
            <%
                // テスト結果を格納する変数
                boolean allTestsPassed = true;
                StringBuilder testResults = new StringBuilder();
                
                try {
            %>
            
            <!-- テスト1: データベース接続テスト -->
            <div class="test-section">
                <h3>📊 テスト1: データベース接続</h3>
                <%
                    try {
                        boolean connectionTest = DatabaseConnection.testConnection();
                        if (connectionTest) {
                %>
                <div class="test-result">
                    <span class="success">✅ データベース接続成功</span><br>
                    <span class="info">接続情報: <%= DatabaseConnection.getConnectionInfo() %></span>
                </div>
                <%
                        } else {
                            allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ データベース接続失敗</span><br>
                    <span class="info">PostgreSQLサーバーが起動しているか確認してください</span>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ 接続テスト例外エラー</span><br>
                    <span class="info">エラー詳細: <%= e.getMessage() %></span>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- テスト2: Userクラステスト -->
            <div class="test-section">
                <h3>👤 テスト2: Userクラス動作確認</h3>
                <%
                    try {
                        User testUser = new User("testuser", "test@example.com", "hashedpassword", "テストユーザー");
                        
                        if (testUser.isValid()) {
                %>
                <div class="test-result">
                    <span class="success">✅ Userクラス正常動作</span><br>
                    <span class="info">ユーザー情報: <%= testUser.toString() %></span>
                </div>
                <%
                        } else {
                            allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ Userクラス検証失敗</span>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ Userクラスエラー</span><br>
                    <span class="info">エラー詳細: <%= e.getMessage() %></span>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- テスト3: UserDAOクラステスト -->
            <div class="test-section">
                <h3>💾 テスト3: UserDAOクラス動作確認</h3>
                <%
                    try {
                        UserDAO userDAO = new UserDAO();
                        
                        // パスワードハッシュテスト
                        String testPassword = "testpassword123";
                        String hashedPassword = UserDAO.hashPassword(testPassword);
                        
                        if (hashedPassword != null && !hashedPassword.isEmpty()) {
                %>
                <div class="test-result">
                    <span class="success">✅ UserDAOクラス正常動作</span><br>
                    <span class="info">パスワードハッシュ化テスト成功</span><br>
                    <span class="info">元パスワード: <%= testPassword %></span><br>
                    <span class="info">ハッシュ値: <%= hashedPassword.substring(0, 20) %>...</span>
                </div>
                <%
                        } else {
                            allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ UserDAOハッシュ化失敗</span>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ UserDAOクラスエラー</span><br>
                    <span class="info">エラー詳細: <%= e.getMessage() %></span>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- テスト4: JDBCドライバー確認 -->
            <div class="test-section">
                <h3>🔧 テスト4: JDBCドライバー確認</h3>
                <%
                    try {
                        Class.forName("org.postgresql.Driver");
                %>
                <div class="test-result">
                    <span class="success">✅ PostgreSQL JDBCドライバー読み込み成功</span><br>
                    <span class="info">postgresql-42.7.7.jar が正しく配置されています</span>
                </div>
                <%
                    } catch (ClassNotFoundException e) {
                        allTestsPassed = false;
                %>
                <div class="test-result">
                    <span class="error">❌ JDBCドライバー未発見</span><br>
                    <span class="info">lib/postgresql-42.7.7.jar を確認してください</span>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- 総合結果 -->
            <div class="test-section">
                <h3>📋 Phase 1 総合結果</h3>
                <% if (allTestsPassed) { %>
                <div class="test-result">
                    <span class="success">🎉 Phase 1 基盤構築完了！</span><br>
                    <span class="info">すべてのデータベース基盤クラスが正常に動作しています。</span><br>
                    <span class="info">Phase 2（認証システム実装）に進むことができます。</span>
                </div>
                <% } else { %>
                <div class="test-result">
                    <span class="error">⚠️ Phase 1 未完了</span><br>
                    <span class="info">上記のエラーを修正してから Phase 2 に進んでください。</span>
                </div>
                <% } %>
            </div>
            
            <%
                } catch (Exception e) {
            %>
            <div class="test-section">
                <h3>❌ 重大エラー</h3>
                <div class="test-result">
                    <span class="error">システムエラーが発生しました</span><br>
                    <span class="info">エラー詳細: <%= e.getMessage() %></span>
                </div>
            </div>
            <%
                }
            %>
            
            <!-- 戻りリンク -->
            <div style="text-align: center;">
                <a href="index.jsp" class="back-link">メイン画面に戻る</a>
                <a href="home.jsp" class="back-link">ホーム画面へ</a>
            </div>
        </div>
    </div>
</body>
</html>
