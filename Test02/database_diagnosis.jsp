<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>詳細データベース診断 - Phase 1</title>
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
        
        .warning {
            color: #ffc107;
            font-weight: bold;
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
    </style>
</head>
<body>
    <div class="test-container">
        <div class="header">
            <h1>🔍 詳細データベース診断</h1>
            <p>PostgreSQL接続問題の詳細分析</p>
        </div>
        
        <div class="content">
            
            <!-- 診断1: JDBCドライバー確認 -->
            <div class="test-section">
                <h3>🔧 診断1: JDBCドライバー状態確認</h3>
                <%
                    try {
                        Class.forName("org.postgresql.Driver");
                        Driver driver = DriverManager.getDriver("jdbc:postgresql://localhost:5432/memory_game");
                %>
                <div class="test-result">
                    <span class="success">✅ PostgreSQL JDBCドライバー正常</span><br>
                    <span class="info">ドライバー情報: <%= driver.toString() %></span>
                </div>
                <%
                    } catch (Exception e) {
                %>
                <div class="test-result">
                    <span class="error">❌ JDBCドライバーエラー</span><br>
                    <span class="info">エラー詳細: <%= e.getMessage() %></span>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- 診断2: 詳細接続テスト -->
            <div class="test-section">
                <h3>📊 診断2: 詳細接続テスト</h3>
                <%
                    String DB_URL = "jdbc:postgresql://localhost:5432/memory_game";
                    String DB_USERNAME = "postgres";
                    String DB_PASSWORD = "Pwd20020726";
                    
                    try {
                        // 基本接続テスト
                        Properties props = new Properties();
                        props.setProperty("user", DB_USERNAME);
                        props.setProperty("password", DB_PASSWORD);
                        props.setProperty("ssl", "false");
                        
                        Connection conn = DriverManager.getConnection(DB_URL, props);
                %>
                <div class="test-result">
                    <span class="success">✅ データベース接続成功</span><br>
                    <span class="info">接続URL: <%= DB_URL %></span><br>
                    <span class="info">ユーザー: <%= DB_USERNAME %></span><br>
                    <span class="info">接続状態: <%= conn.isClosed() ? "閉じている" : "開いている" %></span>
                </div>
                
                <%
                        // データベース情報確認
                        DatabaseMetaData metaData = conn.getMetaData();
                %>
                <div class="test-result">
                    <span class="success">🔍 データベース詳細情報</span><br>
                    <span class="info">DBバージョン: <%= metaData.getDatabaseProductVersion() %></span><br>
                    <span class="info">JDBCドライバーバージョン: <%= metaData.getDriverVersion() %></span><br>
                    <span class="info">現在のカタログ: <%= conn.getCatalog() %></span>
                </div>
                
                <%
                        // テーブル存在確認
                        PreparedStatement stmt = conn.prepareStatement(
                            "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
                        );
                        ResultSet rs = stmt.executeQuery();
                        
                        StringBuilder tables = new StringBuilder();
                        while (rs.next()) {
                            tables.append(rs.getString("table_name")).append(", ");
                        }
                %>
                <div class="test-result">
                    <span class="success">🗂️ テーブル存在確認</span><br>
                    <span class="info">作成済みテーブル: <%= tables.length() > 0 ? tables.toString() : "テーブルなし" %></span>
                </div>
                
                <%
                        conn.close();
                    } catch (SQLException e) {
                        String errorCode = "SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode();
                %>
                <div class="test-result">
                    <span class="error">❌ データベース接続失敗</span><br>
                    <span class="info">エラーメッセージ: <%= e.getMessage() %></span><br>
                    <span class="info">エラーコード: <%= errorCode %></span><br>
                    <span class="warning">🔧 可能な原因分析:</span><br>
                    <%
                        if (e.getMessage().contains("password")) {
                    %>
                    <span class="error">・パスワード認証失敗: 'Pwd20020726' が正しくない可能性</span><br>
                    <%
                        }
                        if (e.getMessage().contains("database") && e.getMessage().contains("does not exist")) {
                    %>
                    <span class="error">・データベース未存在: 'memory_game' が作成されていない</span><br>
                    <%
                        }
                        if (e.getMessage().contains("Connection refused")) {
                    %>
                    <span class="error">・PostgreSQLサーバー停止またはポート5432が閉じている</span><br>
                    <%
                        }
                    %>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- 診断3: 代替接続テスト -->
            <div class="test-section">
                <h3>🔄 診断3: 代替データベース接続テスト</h3>
                <%
                    try {
                        // postgresデータベース（デフォルト）への接続テスト
                        String DEFAULT_DB_URL = "jdbc:postgresql://localhost:5432/postgres";
                        Properties props2 = new Properties();
                        props2.setProperty("user", DB_USERNAME);
                        props2.setProperty("password", DB_PASSWORD);
                        props2.setProperty("ssl", "false");
                        
                        Connection conn2 = DriverManager.getConnection(DEFAULT_DB_URL, props2);
                %>
                <div class="test-result">
                    <span class="success">✅ PostgreSQLサーバー正常動作</span><br>
                    <span class="info">デフォルトpostgresデータベースへの接続成功</span><br>
                    <span class="warning">⚠️ 問題: memory_gameデータベースが存在しない可能性</span>
                </div>
                
                <%
                        // memory_gameデータベース存在確認
                        PreparedStatement stmt2 = conn2.prepareStatement(
                            "SELECT datname FROM pg_database WHERE datname = 'memory_game'"
                        );
                        ResultSet rs2 = stmt2.executeQuery();
                        
                        if (rs2.next()) {
                %>
                <div class="test-result">
                    <span class="success">✅ memory_gameデータベースが存在</span><br>
                    <span class="error">❌ しかし接続に失敗 → パスワードまたは権限の問題</span>
                </div>
                <%
                        } else {
                %>
                <div class="test-result">
                    <span class="error">❌ memory_gameデータベースが存在しません</span><br>
                    <span class="warning">📝 解決策: pgAdminでmemory_gameデータベースを作成してください</span>
                </div>
                <%
                        }
                        
                        conn2.close();
                    } catch (SQLException e) {
                %>
                <div class="test-result">
                    <span class="error">❌ PostgreSQLサーバー自体に問題</span><br>
                    <span class="info">エラー: <%= e.getMessage() %></span><br>
                    <span class="warning">🔧 解決策: PostgreSQLサービスの再起動、パスワード確認</span>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- 推奨解決策 -->
            <div class="test-section">
                <h3>🎯 推奨解決策</h3>
                <div class="test-result">
                    <span class="info"><strong>1. pgAdminでの確認事項:</strong></span><br>
                    <span class="info">・左側ツリーで「memory_game」データベースが存在するか</span><br>
                    <span class="info">・PostgreSQL 13サーバーに正しく接続できているか</span><br>
                    <span class="info">・パスワード「Pwd20020726」で接続できるか</span><br><br>
                    
                    <span class="info"><strong>2. データベース作成（存在しない場合）:</strong></span><br>
                    <span class="info">・pgAdminで「Databases」を右クリック → 「Create Database」</span><br>
                    <span class="info">・データベース名: memory_game</span><br>
                    <span class="info">・Owner: postgres</span><br><br>
                    
                    <span class="info"><strong>3. パスワード確認:</strong></span><br>
                    <span class="info">・PostgreSQL管理者パスワードが「Pwd20020726」であることを確認</span><br>
                    <span class="info">・必要に応じてパスワードリセット</span><br>
                </div>
            </div>
            
            <!-- 戻りリンク -->
            <div style="text-align: center;">
                <a href="database_test_phase1.jsp" class="back-link">Phase 1テストに戻る</a>
                <a href="index.jsp" class="back-link">メイン画面に戻る</a>
            </div>
        </div>
    </div>
</body>
</html>
