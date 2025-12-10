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
    <link rel="stylesheet" type="text/css" href="game.css?v=20241203001">    <!-- 超シンプルタイマー（リセット問題解決版） -->
    <script src="ultra-simple-timer.js?v=20241205002"></script>    <style>
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
        
        /* ゲームコントロールボタンのスタイル */
        .game-header {
            position: relative;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            padding: 20px;
        }
        
        .game-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .control-btn {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .pause-btn {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            color: #2d3436;
        }
        
        .pause-btn:hover {
            background: linear-gradient(135deg, #fdcb6e, #e17055);
            transform: translateY(-2px);
        }
        
        .pause-btn.paused {
            background: linear-gradient(135deg, #55a3ff, #3742fa);
            color: white;
        }
        
        .home-btn {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
        }
        
        .home-btn:hover {
            background: linear-gradient(135deg, #0984e3, #2d3436);
            transform: translateY(-2px);
        }
        
        .pause-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        
        .pause-message {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .pause-message h2 {
            margin-bottom: 15px;
            color: #333;
        }
        
        .pause-message p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .resume-btn {
            background: linear-gradient(135deg, #00b894, #00cec9);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: transform 0.2s;
        }
        
        .resume-btn:hover {
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .game-header {
                flex-direction: column;
                text-align: center;
            }
            
            .game-controls {
                order: -1;
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>    <div class="game-header">
        <h1>神経衰弱</h1>
        <div class="timer-container">
            <div class="timer-label">⏱️ 経過時間</div>
            <div class="timer-display" id="timer-display">00:00.0</div>
        </div>
        
        <!-- ゲームコントロールボタン -->
        <div class="game-controls">
            <button id="pauseBtn" class="control-btn pause-btn" onclick="togglePause()">
                <span class="pause-icon">⏸️</span>
                <span class="pause-text">一時停止</span>
            </button>
            <a href="home.jsp" class="control-btn home-btn" onclick="return confirmReturn()">
                <span class="home-icon">🏠</span>
                <span class="home-text">ホーム</span>
            </a>
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
            </form>        <% } %>
    </div>

    <!-- 一時停止オーバーレイ -->
    <div id="pauseOverlay" class="pause-overlay">
        <div class="pause-message">
            <h2>⏸️ ゲーム一時停止中</h2>
            <p>再開ボタンを押してゲームを続行してください</p>
            <button class="resume-btn" onclick="togglePause()">▶️ 再開</button>
        </div>
    </div>

    <script>
        // 一時停止状態の管理
        let isPaused = false;
        let pausedTime = 0;
        let pauseStartTime = 0;

        // 一時停止機能
        function togglePause() {
            const pauseBtn = document.getElementById('pauseBtn');
            const pauseOverlay = document.getElementById('pauseOverlay');
            const pauseIcon = pauseBtn.querySelector('.pause-icon');
            const pauseText = pauseBtn.querySelector('.pause-text');
            
            if (!isPaused) {
                // 一時停止開始
                isPaused = true;
                pauseStartTime = Date.now();
                
                // タイマー一時停止
                if (window.gameRunning && window.gameInterval) {
                    clearInterval(window.gameInterval);
                    window.gameInterval = null;
                    pausedTime = Date.now() - window.gameStartTime;
                    console.log('⏸️ タイマー一時停止:', formatGameTime(pausedTime));
                }
                
                // UI更新
                pauseBtn.classList.add('paused');
                pauseIcon.textContent = '▶️';
                pauseText.textContent = '再開';
                pauseOverlay.style.display = 'flex';
                
                // カードクリックを無効化
                disableCards();
                
                console.log('🛑 ゲーム一時停止');
                
            } else {
                // 一時停止解除
                isPaused = false;
                
                // タイマー再開
                if (window.gameRunning && pausedTime > 0) {
                    window.gameStartTime = Date.now() - pausedTime;
                    window.gameInterval = setInterval(function() {
                        const elapsed = Date.now() - window.gameStartTime;
                        const timeStr = formatGameTime(elapsed);
                        
                        const display = document.getElementById('timer-display');
                        if (display) {
                            display.textContent = timeStr;
                        }
                        
                        // セッションストレージを定期更新
                        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
                        sessionStorage.setItem('gameRunning', 'true');
                    }, 100);
                    console.log('▶️ タイマー再開:', formatGameTime(pausedTime));
                }
                
                // UI更新
                pauseBtn.classList.remove('paused');
                pauseIcon.textContent = '⏸️';
                pauseText.textContent = '一時停止';
                pauseOverlay.style.display = 'none';
                
                // カードクリックを有効化
                enableCards();
                
                console.log('✅ ゲーム再開');
            }
        }

        // カード無効化
        function disableCards() {
            const cardButtons = document.querySelectorAll('.card-btn');
            cardButtons.forEach(btn => {
                btn.disabled = true;
                btn.style.cursor = 'not-allowed';
                btn.style.opacity = '0.5';
            });
        }

        // カード有効化
        function enableCards() {
            const cardButtons = document.querySelectorAll('.card-btn');
            cardButtons.forEach(btn => {
                btn.disabled = false;
                btn.style.cursor = 'pointer';
                btn.style.opacity = '1';
            });
        }

        // ホーム画面への遷移確認
        function confirmReturn() {
            if (window.gameRunning && !isPaused) {
                return confirm('ゲーム進行中です。ホーム画面に戻りますか？\n（ゲームの進行状況は保存されません）');
            }
            return true;
        }

        // 時間フォーマット関数
        function formatGameTime(ms) {
            const minutes = Math.floor(ms / 60000);
            const seconds = Math.floor((ms % 60000) / 1000);
            const deciseconds = Math.floor((ms % 1000) / 100);
            
            return minutes.toString().padStart(2, '0') + ':' + 
                   seconds.toString().padStart(2, '0') + '.' + deciseconds;
        }

        // キーボードショートカット
        document.addEventListener('keydown', function(e) {
            // スペースキーで一時停止/再開
            if (e.code === 'Space' && e.target.tagName !== 'BUTTON' && e.target.tagName !== 'INPUT') {
                e.preventDefault();
                togglePause();
            }
            
            // Escキーで一時停止のみ
            if (e.code === 'Escape' && !isPaused) {
                togglePause();
            }
        });        // ページ読み込み時の初期化
        window.addEventListener('DOMContentLoaded', function() {
            console.log('🎮 ゲームコントロール機能初期化完了');
            console.log('💡 ショートカット: スペースキー = 一時停止/再開, Escキー = 一時停止');
        });

        // ページ離脱防止のフラグ
        let isFormSubmitting = false;
        let isNavigatingWithinGame = false;

        // フォーム送信前にフラグを設定
        document.addEventListener('submit', function(e) {
            console.log('📝 フォーム送信開始');
            isFormSubmitting = true;
            
            // フォーム送信後にフラグをリセット（少し遅延させる）
            setTimeout(function() {
                isFormSubmitting = false;
                console.log('📝 フォーム送信完了');
            }, 1000);
        });

        // ゲーム内ナビゲーション（次へボタンなど）にフラグを設定
        document.addEventListener('click', function(e) {
            const target = e.target;
            
            // ゲーム内の操作（次へボタン、カード送信など）の場合
            if (target.classList.contains('next-btn') || 
                target.classList.contains('card-btn') || 
                target.closest('form[action="game"]')) {
                console.log('🎮 ゲーム内操作');
                isNavigatingWithinGame = true;
                
                // 操作後にフラグをリセット
                setTimeout(function() {
                    isNavigatingWithinGame = false;
                }, 500);
            }
        });

        // ページ離脱時の警告（真の離脱時のみ）
        window.addEventListener('beforeunload', function(e) {
            // 以下の場合は警告を表示しない：
            // 1. フォーム送信中
            // 2. ゲーム内ナビゲーション中
            // 3. 一時停止中
            // 4. ゲームが動作していない
            if (isFormSubmitting || isNavigatingWithinGame || isPaused || !window.gameRunning) {
                console.log('🚫 離脱警告をスキップ（ゲーム内操作）');
                return;
            }
            
            console.log('⚠️ ページ離脱警告を表示');
            const confirmationMessage = 'ゲーム進行中です。ページを離れますか？';
            e.returnValue = confirmationMessage;
            return confirmationMessage;
        });
    </script>
</body>
</html>
