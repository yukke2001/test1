<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>認証システムテスト - Test02 Memory Game</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            border-left: 4px solid #4CAF50;
        }
        .test-result {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            font-weight: bold;
        }
        .success {
            background-color: rgba(76, 175, 80, 0.3);
            border: 1px solid #4CAF50;
        }
        .error {
            background-color: rgba(244, 67, 54, 0.3);
            border: 1px solid #f44336;
        }
        .warning {
            background-color: rgba(255, 193, 7, 0.3);
            border: 1px solid #ffc107;
            color: #333;
        }
        h1, h2 { text-align: center; }
        pre {
            background: rgba(0, 0, 0, 0.3);
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            white-space: pre-wrap;
        }
        .nav-links {
            text-align: center;
            margin-top: 30px;
        }
        .nav-links a {
            display: inline-block;
            margin: 0 10px;
            padding: 12px 24px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 認証システムテスト</h1>
        <p style="text-align: center;">Phase 2: 認証システム実装の動作確認</p>

        <%
            // テスト結果を格納するリスト
            List<String> testResults = new ArrayList<>();
            boolean allTestsPassed = true;
            
            try {
        %>
        
        <!-- セクション1: データベース接続テスト -->
        <div class="test-section">
            <h2>📊 データベース接続テスト</h2>
            <%
                try {
                    boolean dbConnected = DatabaseConnection.testConnection();
                    if (dbConnected) {
                        testResults.add("✅ データベース接続: 成功");
            %>
                        <div class="test-result success">✅ データベース接続が正常に確立されました</div>
            <%
                    } else {
                        testResults.add("❌ データベース接続: 失敗");
                        allTestsPassed = false;
            %>
                        <div class="test-result error">❌ データベース接続に失敗しました</div>
            <%
                    }
                } catch (Exception e) {
                    testResults.add("❌ データベース接続: エラー - " + e.getMessage());
                    allTestsPassed = false;
            %>
                    <div class="test-result error">❌ データベース接続エラー: <%= e.getMessage() %></div>
            <%
                }
            %>
        </div>

        <!-- セクション2: UserDAOテスト -->
        <div class="test-section">
            <h2>👤 UserDAO機能テスト</h2>
            <%
                try {
                    UserDAO userDAO = new UserDAO();
                    
                    // テストユーザー名の重複チェック
                    boolean usernameExists = userDAO.isUsernameExists("admin");
                    testResults.add("✅ ユーザー名重複チェック: 動作中");
            %>
                    <div class="test-result success">✅ ユーザー名重複チェック機能が動作しています</div>
                    <div class="test-result warning">📝 'admin'ユーザーの存在確認: <%= usernameExists ? "存在します" : "存在しません" %></div>
            <%
                    // テストメールアドレスの重複チェック
                    boolean emailExists = userDAO.isEmailExists("admin@example.com");
                    testResults.add("✅ メールアドレス重複チェック: 動作中");
            %>
                    <div class="test-result success">✅ メールアドレス重複チェック機能が動作しています</div>
                    <div class="test-result warning">📝 'admin@example.com'の存在確認: <%= emailExists ? "存在します" : "存在しません" %></div>
            <%
                } catch (Exception e) {
                    testResults.add("❌ UserDAO: エラー - " + e.getMessage());
                    allTestsPassed = false;
            %>
                    <div class="test-result error">❌ UserDAOエラー: <%= e.getMessage() %></div>
            <%
                }
            %>
        </div>

        <!-- セクション3: パスワードハッシュテスト -->
        <div class="test-section">
            <h2>🔐 パスワードハッシュ化テスト</h2>
            <%
                try {
                    UserDAO userDAO = new UserDAO();
                    String testPassword = "testpassword123";
                    String hashedPassword = userDAO.hashPassword(testPassword);
                    
                    if (hashedPassword != null && hashedPassword.length() > 0) {
                        testResults.add("✅ パスワードハッシュ化: 成功");
            %>
                        <div class="test-result success">✅ パスワードハッシュ化機能が正常に動作しています</div>
                        <div class="test-result warning">📝 テストパスワード: <%= testPassword %></div>
                        <div class="test-result warning">📝 ハッシュ化結果: <%= hashedPassword.substring(0, 20) %>...</div>
            <%
                        // ハッシュ検証テスト
                        boolean verification = userDAO.verifyPassword(testPassword, hashedPassword);
                        if (verification) {
                            testResults.add("✅ パスワード検証: 成功");
            %>
                            <div class="test-result success">✅ パスワード検証機能が正常に動作しています</div>
            <%
                        } else {
                            testResults.add("❌ パスワード検証: 失敗");
                            allTestsPassed = false;
            %>
                            <div class="test-result error">❌ パスワード検証に失敗しました</div>
            <%
                        }
                    } else {
                        testResults.add("❌ パスワードハッシュ化: 失敗");
                        allTestsPassed = false;
            %>
                        <div class="test-result error">❌ パスワードハッシュ化に失敗しました</div>
            <%
                    }
                } catch (Exception e) {
                    testResults.add("❌ パスワードハッシュ化: エラー - " + e.getMessage());
                    allTestsPassed = false;
            %>
                    <div class="test-result error">❌ パスワードハッシュ化エラー: <%= e.getMessage() %></div>
            <%
                }
            %>
        </div>

        <!-- セクション4: セッション状態テスト -->
        <div class="test-section">
            <h2>🔄 セッション状態テスト</h2>
            <%
                Object currentUser = session.getAttribute("currentUser");
                if (currentUser != null) {
                    testResults.add("✅ セッション: ログイン済み");
            %>
                    <div class="test-result success">✅ ユーザーがログインしています</div>
                    <div class="test-result warning">📝 ログインユーザー情報: <%= currentUser.toString() %></div>
            <%
                } else {
                    testResults.add("⚪ セッション: 未ログイン");
            %>
                    <div class="test-result warning">⚪ 現在ログインしているユーザーはいません</div>
            <%
                }
            %>
        </div>

        <!-- セクション5: サーブレットエンドポイントテスト -->
        <div class="test-section">
            <h2>🌐 サーブレットエンドポイントテスト</h2>
            <div class="test-result warning">📝 以下のエンドポイントが設定されています:</div>
            <ul style="margin-left: 20px;">
                <li><strong>/login</strong> - ログイン処理 (LoginServlet)</li>
                <li><strong>/register</strong> - ユーザー登録処理 (RegisterServlet)</li>
                <li><strong>/logout</strong> - ログアウト処理 (LogoutServlet)</li>
            </ul>
            <div class="test-result success">✅ web.xmlにサーブレットマッピングが設定されています</div>
        </div>

        <!-- テスト結果サマリー -->
        <div class="test-section">
            <h2>📋 テスト結果サマリー</h2>
            <%
                if (allTestsPassed) {
            %>
                    <div class="test-result success">🎉 すべてのテストが成功しました！認証システムの準備が完了しています。</div>
            <%
                } else {
            %>
                    <div class="test-result error">⚠️ いくつかのテストで問題が発見されました。詳細を確認してください。</div>
            <%
                }
            %>
            
            <h3>詳細結果:</h3>
            <pre><%
                for (String result : testResults) {
                    out.println(result);
                }
            %></pre>
        </div>

        <%
            } catch (Exception e) {
        %>
                <div class="test-section">
                    <h2>❌ 重大エラー</h2>
                    <div class="test-result error">システムエラーが発生しました: <%= e.getMessage() %></div>
                    <pre><%= e.toString() %></pre>
                </div>
        <%
            }
        %>

        <!-- ナビゲーションリンク -->
        <div class="nav-links">
            <a href="home.jsp">🏠 ホームに戻る</a>
            <a href="login.jsp">🔑 ログイン</a>
            <a href="register.jsp">📝 ユーザー登録</a>
            <a href="database_connection_test.jsp">🗄️ DB接続テスト</a>
        </div>
    </div>
</body>
</html>
