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
    
    <script>        function flipCard(form) {
            console.log('flipCard called'); // デバッグ用
            const card = form.closest('.card');
            const button = form.querySelector('.card-btn');
            
            // カードフリップエフェクト開始
            card.classList.add('flipping');
            if (button) {
                button.style.color = '#ffd700';
                button.style.transform = 'scale(1.2)';
                button.style.textShadow = '0 0 15px rgba(255,215,0,0.8)';
            }
            
            // アニメーション完了後にフォーム送信
            setTimeout(function() {
                console.log('Submitting form'); // デバッグ用
                form.submit();
            }, 300);
            
            return false;
        }
          function initCardEffects() {
            const cards = document.querySelectorAll('.card');
            
            cards.forEach((card, index) => {
                // 初期表示アニメーション
                setTimeout(() => {
                    card.style.animation = 'cardAppear 0.6s ease forwards';
                    card.style.opacity = '1';
                }, index * 50);
                
                // クリック可能なカードのみにホバーエフェクトを適用
                if (!card.classList.contains('open') && !card.classList.contains('gone')) {
                    card.addEventListener('mouseenter', function() {
                        const btn = this.querySelector('.card-btn');
                        if (btn) {
                            btn.style.filter = 'brightness(1.1)';
                        }
                    });
                    
                    card.addEventListener('mouseleave', function() {
                        const btn = this.querySelector('.card-btn');
                        if (btn) {
                            btn.style.filter = '';
                        }
                    });
                }
            });
        }
        
        // ページ読み込み完了時にエフェクトを初期化
        window.addEventListener('load', initCardEffects);
    </script>
    
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