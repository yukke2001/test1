<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // デバッグ: URLパラメータでリセット可能にする
    String reset = request.getParameter("reset");
    if ("true".equals(reset)) {
        session.invalidate();
        session = request.getSession(true);
        response.sendRedirect("game");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>神経衰弱 ゲーム画面</title>
    <!-- キャッシュ無効化設定 -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <!-- CSS読み込み -->
    <link rel="stylesheet" type="text/css" href="game.css?v=20241203001">
    
    <!-- シンプルタイマー（外部ファイルのみ使用） -->
    <script src="simple-timer.js?v=20241204006"></script>

    <style>
        @keyframes cardAppear {
            0% {
                opacity: 0;
                transform: translateY(20px) scale(0.9);
            }
            100% {
                opacity: 1;
                transform: translateY(0px) scale(1);
            }
        }
        
        .card {
            transition: all 0.3s ease !important;
        }
        
        .card.flipping {
            filter: brightness(1.3) drop-shadow(0 0 20px rgba(255,215,0,0.7)) !important;
        }
    </style>
</head>
<body>
    <div class="game-header">
        <h1>神経衰弱</h1>
        <div class="timer-container">
            <div class="timer-label">⏱️ 経過時間</div>
            <div class="timer-display" id="timer-display">00:00.0</div>
        </div>
    </div>
    
    <div class="cards">
        <%
            List<Map<String, Object>> cards = (List<Map<String, Object>>)request.getAttribute("cards");
            
            if (cards != null) {
                for (int i = 0; i < cards.size(); i++) {
                    Map<String, Object> card = cards.get(i);
                    
                    boolean isOpen = (Boolean)card.get("isOpen");
                    boolean isGone = (Boolean)card.get("isGone");
                    String value = (String)card.get("value");
                    
                    String cardClass = "card";
                    if (isOpen) cardClass += " open";
                    if (isGone) cardClass += " gone";
        %>
        
        <div class="<%= cardClass %>">
            <% if (isGone) { %>
                <!-- 消去されたカード -->
            <% } else if (isOpen) { %>
                <!-- 表向きのカード -->
                <span><%= value %></span>
            <% } else { %>
                <!-- 裏向きのカード -->
                <form method="post" action="game" onsubmit="return flipCard(this);">
                    <input type="hidden" name="index" value="<%= i %>" />
                    <button type="submit" class="card-btn">?</button>
                </form>
            <% } %>
        </div>
        
        <%
                }
            }
        %>
    </div>
    
    <div class="next-btn-area">
        <%
            Boolean showNext = (Boolean)request.getAttribute("showNext");
            if (showNext != null && showNext) {
        %>
            <form method="post" action="game">
                <input type="hidden" name="action" value="next" />
                <button type="submit" class="next-btn pulse-effect">次へ</button>
            </form>
        <% } %>
    </div>
</body>
</html>
