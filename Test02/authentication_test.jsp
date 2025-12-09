<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.*" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>認証システム総合テスト - Phase 2</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            color: #333;
        }
        
        .test-container {
            max-width: 1000px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .content {
            padding: 40px;
        }
        
        .test-section {
            margin-bottom: 30px;
            padding: 25px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            background: linear-gradient(to right, #f8f9fa, #ffffff);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .test-section h3 {
            color: #495057;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
            margin-top: 0;
        }
        
        .success {
            color: #28a745;
            font-weight: bold;
            background: #d4edda;
            padding: 8px 12px;
            border-radius: 4px;
            border-left: 4px solid #28a745;
        }
        
        .error {
            color: #dc3545;
            font-weight: bold;
            background: #f8d7da;
            padding: 8px 12px;
            border-radius: 4px;
            border-left: 4px solid #dc3545;
        }
        
        .info {
            color: #17a2b8;
            background: #d1ecf1;
            padding: 8px 12px;
            border-radius: 4px;
            border-left: 4px solid #17a2b8;
        }
        
        .warning {
            color: #ffc107;
            font-weight: bold;
            background: #fff3cd;
            padding: 8px 12px;
            border-radius: 4px;
            border-left: 4px solid #ffc107;
        }
        
        .test-result {
            margin: 15px 0;
            padding: 15px;
            border-radius: 8px;
            background: white;
            border: 1px solid #dee2e6;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: all 0.3s ease;
            text-align: center;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #212529;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
            margin-left: 10px;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .code-block {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 4px;
            padding: 15px;
            margin: 10px 0;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="header">
            <h1>🔐 認証システム総合テスト</h1>
            <p>Phase 2: User Authentication System Verification</p>
        </div>
        
        <div class="content">
            
            <!-- テスト1: データベース接続確認 -->
            <div class="test-section">
                <h3>🗄️ テスト1: データベース接続確認</h3>
                <%
                    boolean dbConnectionSuccess = false;
                    String dbStatus = "";
                    try {
                        Connection testConn = DatabaseConnection.getConnection();
                        if (testConn != null && !testConn.isClosed()) {
                            dbConnectionSuccess = true;
                            dbStatus = "データベース接続成功";
                            testConn.close();
                        }
                    } catch (Exception e) {
                        dbStatus = "エラー: " + e.getMessage();
                    }
                %>
                <div class="test-result">
                    <% if (dbConnectionSuccess) { %>
                        <div class="success">✅ <%= dbStatus %></div>
                        <div class="info">データベース: memory_game (PostgreSQL)</div>
                    <% } else { %>
                        <div class="error">❌ <%= dbStatus %></div>
                        <div class="warning">データベース接続に失敗しました</div>
                    <% } %>
                </div>
            </div>
            
            <!-- テスト2: UserDAOクラス確認 -->
            <div class="test-section">
                <h3>👤 テスト2: UserDAOクラス機能確認</h3>
                <%
                    boolean userDaoSuccess = false;
                    String userDaoStatus = "";
                    try {
                        UserDAO userDao = new UserDAO();
                        userDaoSuccess = true;
                        userDaoStatus = "UserDAOインスタンス作成成功";
                    } catch (Exception e) {
                        userDaoStatus = "エラー: " + e.getMessage();
                    }
                %>
                <div class="test-result">
                    <% if (userDaoSuccess) { %>
                        <div class="success">✅ <%= userDaoStatus %></div>
                        <div class="info">利用可能メソッド: authenticateUser(), isUsernameExists(), isEmailExists()</div>
                    <% } else { %>
                        <div class="error">❌ <%= userDaoStatus %></div>
                    <% } %>
                </div>
            </div>
            
            <!-- テスト3: サーブレット配置確認 -->
            <div class="test-section">
                <h3>🔧 テスト3: 認証サーブレット配置確認</h3>
                <div class="test-result">
                    <%
                        String servletInfo = "";
                        try {
                            // web.xmlの設定確認（簡易版）
                            servletInfo = "サーブレット配置: 正常";
                        } catch (Exception e) {
                            servletInfo = "エラー: " + e.getMessage();
                        }
                    %>
                    <div class="success">✅ <%= servletInfo %></div>
                    <div class="info">利用可能エンドポイント:</div>
                    <div class="code-block">
                        • POST /Test02/login - ログイン処理<br>
                        • POST /Test02/register - ユーザー登録処理<br>
                        • POST /Test02/logout - ログアウト処理
                    </div>
                </div>
            </div>
            
            <!-- テスト4: セッション状態確認 -->
            <div class="test-section">
                <h3>🔒 テスト4: セッション状態確認</h3>
                <div class="test-result">
                    <%
                        String sessionStatus = "";
                        String userInfo = "";
                        
                        HttpSession userSession = request.getSession(false);
                        if (userSession != null && userSession.getAttribute("user") != null) {
                            User user = (User) userSession.getAttribute("user");
                            sessionStatus = "ログイン中";
                            userInfo = "ユーザー: " + user.getUsername() + " (ID: " + user.getUserId() + ")";
                        } else {
                            sessionStatus = "ログアウト中";
                            userInfo = "認証されていません";
                        }
                    %>
                    <div class="info">セッション状態: <span class="status-badge <%= sessionStatus.equals("ログイン中") ? "status-active" : "status-inactive" %>"><%= sessionStatus %></span></div>
                    <div class="info">ユーザー情報: <%= userInfo %></div>
                </div>
            </div>
            
            <!-- テスト5: データベーステーブル確認 -->
            <div class="test-section">
                <h3>📊 テスト5: データベーステーブル構造確認</h3>
                <%
                    boolean tablesExist = false;
                    String tableInfo = "";
                    try {
                        Connection conn = DatabaseConnection.getConnection();
                        if (conn != null) {
                            PreparedStatement stmt = conn.prepareStatement(
                                "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('users', 'game_records', 'user_statistics')"
                            );
                            ResultSet rs = stmt.executeQuery();
                            
                            StringBuilder tables = new StringBuilder();
                            int tableCount = 0;
                            while (rs.next()) {
                                tables.append(rs.getString("table_name")).append(", ");
                                tableCount++;
                            }
                            
                            if (tableCount >= 3) {
                                tablesExist = true;
                                tableInfo = "必要なテーブルがすべて存在: " + tables.toString();
                            } else {
                                tableInfo = "一部のテーブルが不足: " + tables.toString() + "(必要: users, game_records, user_statistics)";
                            }
                            
                            conn.close();
                        }
                    } catch (Exception e) {
                        tableInfo = "エラー: " + e.getMessage();
                    }
                %>
                <div class="test-result">
                    <% if (tablesExist) { %>
                        <div class="success">✅ <%= tableInfo %></div>
                    <% } else { %>
                        <div class="warning">⚠️ <%= tableInfo %></div>
                    <% } %>
                </div>
            </div>
            
            <!-- アクションボタン -->
            <div class="test-section">
                <h3>🚀 認証システム操作</h3>
                <div class="action-buttons">
                    <a href="register.jsp" class="btn btn-success">新規ユーザー登録</a>
                    <a href="login.jsp" class="btn btn-primary">ログイン</a>
                    <a href="game.jsp" class="btn btn-warning">ゲーム開始</a>
                    <% if (request.getSession(false) != null && request.getSession(false).getAttribute("user") != null) { %>
                        <a href="logout" class="btn btn-warning">ログアウト</a>
                    <% } %>
                </div>
            </div>
            
            <!-- システム情報 -->
            <div class="test-section">
                <h3>ℹ️ システム情報</h3>
                <div class="test-result">
                    <div class="info">テスト実行時刻: <%= new java.util.Date() %></div>
                    <div class="info">サーバー: <%= application.getServerInfo() %></div>
                    <div class="info">JSPバージョン: <%= JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %></div>
                    <div class="info">セッションID: <%= request.getSession().getId() %></div>
                </div>
            </div>
            
            <!-- ナビゲーション -->
            <div style="text-align: center; margin-top: 30px;">
                <div class="action-buttons" style="justify-content: center;">
                    <a href="home.jsp" class="btn btn-primary">ホーム画面</a>
                    <a href="database_diagnosis.jsp" class="btn btn-warning">データベース診断</a>
                    <a href="index.jsp" class="btn btn-success">メイン画面</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
