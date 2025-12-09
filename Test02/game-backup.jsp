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
    <meta http-equiv="Expires" content="0">    <!-- CSS読み込み -->    <link rel="stylesheet" type="text/css" href="game.css?v=20241203001">    <!-- シンプルで確実なタイマー機能 -->
    <script src="simple-timer.js?v=20241204004"></script>
    <script>
        // ゲームタイマーオブジェクト
        let gameTimer = {
            startTime: null,
            isRunning: false,
            elapsedTime: 0,
            intervalId: null,
            
            start: function() {
                console.log('=== gameTimer.start() ===');
                if (!this.isRunning) {
                    this.startTime = Date.now() - this.elapsedTime;
                    this.isRunning = true;
                    this.intervalId = setInterval(() => {
                        this.updateDisplay();
                    }, 100);
                    console.log('✅ タイマー開始完了');
                }
            },
            
            stop: function() {
                if (this.isRunning) {
                    this.isRunning = false;
                    if (this.intervalId) {
                        clearInterval(this.intervalId);
                        this.intervalId = null;
                    }
                    const finalTime = this.elapsedTime;
                    sessionStorage.setItem('gameTime', this.formatTime(finalTime));
                    sessionStorage.setItem('gameTimeMs', finalTime.toString());
                    console.log('⏹️ タイマー停止:', this.formatTime(finalTime));
                    return finalTime;
                }
                return 0;
            },
              updateDisplay: function() {
                if (this.isRunning) {
                    this.elapsedTime = Date.now() - this.startTime;
                }
                const display = document.getElementById('timer-display');
                if (display) {
                    const formattedTime = this.formatTime(this.elapsedTime);
                    display.textContent = formattedTime;
                    // デバッグ用：5秒ごとにログ出力
                    if (this.isRunning && Math.floor(this.elapsedTime / 1000) % 5 === 0 && this.elapsedTime % 1000 < 200) {
                        console.log('⏰ タイマー動作中:', formattedTime);
                    }
                } else {
                    console.error('❌ timer-display要素が見つかりません');
                }
            },            formatTime: function(ms) {
                const totalSeconds = Math.floor(ms / 1000);
                const minutes = Math.floor(totalSeconds / 60);
                const seconds = totalSeconds % 60;
                const deciseconds = Math.floor((ms % 1000) / 100);
                
                const minuteStr = minutes.toString().padStart(2, '0');
                const secondStr = seconds.toString().padStart(2, '0');
                const decisecondStr = deciseconds.toString();
                
                return minuteStr + ':' + secondStr + '.' + decisecondStr;
            },
            
            reset: function() {
                this.stop();
                this.elapsedTime = 0;
                this.updateDisplay();
                sessionStorage.removeItem('gameTime');
                sessionStorage.removeItem('gameTimeMs');
            },
            
            init: function() {
                console.log('📝 GameTimer初期化開始');
                this.elapsedTime = 0;
                this.startTime = null;
                this.isRunning = false;
                sessionStorage.removeItem('gameTime');
                sessionStorage.removeItem('gameTimeMs');
                
                const display = document.getElementById('timer-display');
                if (display) {
                    display.textContent = '00:00.0';
                    console.log('✅ タイマー表示初期化完了');
                } else {
                    console.error('❌ timer-display要素が見つかりません');
                }
            }
        };        // カードクリック時の処理
        function flipCard(form) {
            console.log('=== flipCard called ===');
            console.log('gameTimer.isRunning:', gameTimer.isRunning);
            console.log('gameTimer.elapsedTime:', gameTimer.elapsedTime);
            
            // カードクリック時はタイマーを開始しない（自動開始されているため）
            // タイマーは継続して動作させる
            
            const card = form.closest('.card');
            const button = form.querySelector('.card-btn');
            
            if (card) card.classList.add('flipping');
            if (button) {
                button.style.color = '#ffd700';
                button.style.transform = 'scale(1.2)';
                button.style.textShadow = '0 0 15px rgba(255,215,0,0.8)';
            }
            
            setTimeout(function() {
                console.log('🚀 フォーム送信中...');
                form.submit();
            }, 300);
            
            return false;
        }

        // ゲーム終了検出
        function detectGameEnd() {
            const observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if (mutation.type === 'childList') {
                        const nextBtn = document.querySelector('.next-btn');
                        if (nextBtn && gameTimer.isRunning) {
                            console.log('🏁 ゲーム終了検出！');
                            const finalTime = gameTimer.stop();
                            console.log('⏹️ 最終時間:', finalTime);
                        }
                    }
                });
            });
            
            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
        }

        // ページ読み込み完了時の初期化
        window.addEventListener('load', function() {
            console.log('🌟 ページ読み込み完了');
            gameTimer.init();
            detectGameEnd();
            
            // グローバルに関数を設定
            window.flipCard = flipCard;
            window.gameTimer = gameTimer;
            
            console.log('💡 flipCard関数の型:', typeof window.flipCard);
        });
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