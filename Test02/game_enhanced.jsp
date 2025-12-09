<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>神経衰弱 ゲーム画面</title>
    <!-- キャッシュ無効化設定 -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <!-- CSS読み込み -->
    <link rel="stylesheet" type="text/css" href="random_layout.css?v=20241202002">
    <link rel="stylesheet" type="text/css" href="card_effects.css?v=20241202002">
    
    <!-- JavaScript for card flip animations -->
    <script>
        function flipCard(element, index) {
            // カードにフリップクラスを追加
            element.closest('.card').classList.add('flipping');
            
            // 少し遅延してフォーム送信
            setTimeout(function() {
                element.submit();
            }, 300);
        }
        
        function addCardEffects() {
            // ページ読み込み時にカードエフェクトを初期化
            const cards = document.querySelectorAll('.card');
            cards.forEach((card, index) => {
                // 初期状態でランダムな軽い揺れを追加
                setTimeout(() => {
                    card.style.animation = 'cardAppear 0.5s ease forwards';
                }, index * 100);
            });
        }
        
        // ページ読み込み完了時にエフェクトを適用
        window.addEventListener('load', addCardEffects);
    </script>
    
    <style>
        @keyframes cardAppear {
            0% {
                opacity: 0;
                transform: translateY(30px) rotate(0deg) scale(0.8);
            }
            100% {
                opacity: 1;
                transform: translateY(0px) scale(1);
            }
        }
    </style>
</head>
<body>
    <h1>神経衰弱</h1>
    
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
                    if (isOpen) cardClass += " flipped open";
                    if (isGone) cardClass += " gone matched";
        %>
        
        <div class="<%= cardClass %>">
            <% if (isGone) { %>
                <!-- 消去されたカード -->
                <div class="card-back"></div>
                <div class="card-front"></div>
            <% } else if (isOpen) { %>
                <!-- 表向きのカード -->
                <div class="card-back"></div>
                <div class="card-front">
                    <span><%= value %></span>
                </div>
            <% } else { %>
                <!-- 裏向きのカード -->
                <div class="card-back">
                    <form method="post" action="game" style="width: 100%; height: 100%;" onsubmit="flipCard(this, <%= i %>); return false;">
                        <input type="hidden" name="index" value="<%= i %>" />
                        <button type="submit" class="card-btn">?</button>
                    </form>
                </div>
                <div class="card-front">
                    <span><%= value %></span>
                </div>
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
