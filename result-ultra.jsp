<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>神経衰弱 ゲームクリア</title>
    <link rel="stylesheet" type="text/css" href="result.css?v=20241202003">
    <!-- 超シンプル結果表示（リセット問題解決版） -->
    <script src="ultra-simple-result.js?v=20241204001"></script>
</head>
<body>
    <div class="celebration-content">
        <h1 class="celebration-text">ゲームクリア！🎉</h1>
        <p>おめでとうございます！</p>
        <!-- クリア時間はultra-simple-result.jsで動的追加 -->
    </div>
    
    <div class="button-container">
        <form method="post" action="game" style="display: inline-block; margin-right: 15px;">
            <input type="hidden" name="action" value="restart" />
            <input type="hidden" name="resetTimer" value="true" />
            <button type="submit" class="restart-btn">もう一度遊ぶ</button>
        </form>
        
        <a href="index.jsp" class="start-btn">スタート画面へ</a>
    </div>
</body>
</html>
