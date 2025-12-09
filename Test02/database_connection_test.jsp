<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.DatabaseConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DatabaseConnection修正後テスト</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .result { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
    </style>
</head>
<body>
    <h1>🔧 DatabaseConnection修正後テスト</h1>
    
    <h3>修正されたtestConnection()メソッドのテスト</h3>
    <%
        try {
            boolean result = DatabaseConnection.testConnection();
            if (result) {
    %>
    <div class="result success">
        ✅ <strong>接続テスト成功！</strong><br>
        修正されたtestConnection()メソッドが正常に動作しています。
    </div>
    <%
            } else {
    %>
    <div class="result error">
        ❌ <strong>接続テスト失敗</strong><br>
        まだ問題が残っています。追加の診断が必要です。
    </div>
    <%
            }
        } catch (Exception e) {
    %>
    <div class="result error">
        ❌ <strong>例外エラー</strong><br>
        エラー詳細: <%= e.getMessage() %>
    </div>
    <%
        }
    %>
    
    <h3>接続情報の確認</h3>
    <div class="result info">
        <strong>現在の接続設定:</strong><br>
        <%= DatabaseConnection.getConnectionInfo() %>
    </div>
    
    <h3>次のステップ</h3>
    <div class="result info">
        <strong>修正が成功した場合:</strong><br>
        → <a href="database_test_phase1.jsp">Phase 1テスト</a>に戻って全体テストを実行<br><br>
        
        <strong>まだ失敗する場合:</strong><br>
        → エラー内容をお知らせください。追加の修正を行います。
    </div>
    
    <p><a href="database_test_phase1.jsp">Phase 1テストページに戻る</a></p>
</body>
</html>
