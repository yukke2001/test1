<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>神経衰弱 ゲームクリア</title>
    <link rel="stylesheet" type="text/css" href="result.css?v=20241202003">
    
    <!-- クリア時間表示機能（シンプル版） -->
    <script src="simple-result.js?v=20241204007"></script>
</head>
<body>
    <div class="celebration-background">
        <div class="stars"></div>
        <div class="celebration-content">
            <h1 class="celebration-title">🎉 ゲームクリア！ 🎉</h1>
            <p class="celebration-message">すべてのペアを見つけました！<br>おめでとうございます！</p>
            
            <!-- クリア時間はsimple-result.jsで動的に挿入される -->
            
            <div class="restart-section">
                <form action="game" method="get" style="display: inline-block;">
                    <button type="submit" class="restart-btn">
                        🔄 もう一度遊ぶ
                    </button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
