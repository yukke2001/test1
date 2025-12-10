<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // セッションからログインユーザー情報を取得
    String currentUser = (String) session.getAttribute("username");
    String userType = (currentUser != null && !currentUser.isEmpty()) ? "登録ユーザー" : "ゲスト";
    
    // デバッグ: URLパラメータでリセット可能にする
    String reset = request.getParameter("reset");
    if ("true".equals(reset)) {
        session.invalidate();
        session = request.getSession(true);
        response.sendRedirect("game-enhanced");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>神経衰弱 ゲーム画面</title>
    <!-- キャッシュ無効化設定 -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <!-- CSS読み込み -->
    <link rel="stylesheet" type="text/css" href="game.css?v=20241203001">
    <!-- 超シンプルタイマー -->
    <script src="ultra-simple-timer.js?v=20241205002"></script>

    <style>
        /* 追加スタイル */
        .game-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .enhanced-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .game-title-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-info {
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        
        .timer-container {
            background: rgba(255, 255, 255, 0.15);
            padding: 15px 20px;
            border-radius: 10px;
            text-align: center;
            min-width: 150px;
        }
        
        .timer-label {
            font-size: 0.8rem;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .timer-display {
            font-size: 1.5rem;
            font-weight: bold;
            font-family: 'Courier New', monospace;
        }
        
        .game-content {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 0 0 15px 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .nav-buttons {
            display: flex;
            gap: 10px;
        }
        
        .nav-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .home-btn {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
        }
        
        .restart-btn {
            background: linear-gradient(135deg, #fa709a, #fee140);
            color: white;
        }
        
        .nav-btn:hover {
            transform: translateY(-2px);
        }
        
        .game-status {
            display: flex;
            gap: 20px;
            align-items: center;
            font-size: 0.9rem;
            color: #666;
        }
        
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
            animation: cardAppear 0.5s ease forwards;
        }
        
        .card.flipping {
            filter: brightness(1.3) drop-shadow(0 0 20px rgba(255,215,0,0.7)) !important;
        }
        
        .cards {
            animation-delay: 0.2s;
        }
        
        @media (max-width: 768px) {
            .enhanced-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .game-title-section {
                flex-direction: column;
                gap: 10px;
            }
            
            .action-bar {
                flex-direction: column;
                align-items: stretch;
                text-align: center;
            }
            
            .nav-buttons {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="game-container">
        <!-- 拡張ヘッダー -->
        <div class="enhanced-header">
            <div class="game-title-section">
                <h1>🃏 神経衰弱</h1>
                <div class="user-info">
                    <%= userType %>
                    <% if (currentUser != null && !currentUser.isEmpty()) { %>
                        : <%= currentUser %>
                    <% } %>
                </div>
            </div>
            
            <div class="timer-container">
                <div class="timer-label">⏱️ 経過時間</div>
                <div class="timer-display" id="timer-display">00:00.0</div>
            </div>
        </div>
        
        <!-- ゲームコンテンツ -->
        <div class="game-content">
            <!-- アクションバー -->
            <div class="action-bar">
                <div class="nav-buttons">
                    <% if (currentUser != null && !currentUser.isEmpty()) { %>
                        <a href="home.jsp" class="nav-btn home-btn">🏠 ホームに戻る</a>
                    <% } else { %>
                        <a href="login.jsp" class="nav-btn home-btn">🔑 ログイン画面</a>
                    <% } %>
                    <a href="game-enhanced?reset=true" class="nav-btn restart-btn">🔄 新しいゲーム</a>
                </div>
                
                <div class="game-status">
                    <%
                        List<Map<String, Object>> cards = (List<Map<String, Object>>)request.getAttribute("cards");
                        if (cards != null) {
                            int totalCards = cards.size();
                            int clearedCards = 0;
                            for (Map<String, Object> card : cards) {
                                if ((Boolean)card.get("isGone")) {
                                    clearedCards++;
                                }
                            }
                            int progress = (int)((double)clearedCards / totalCards * 100);
                    %>
                    <span>進捗: <%= clearedCards %>/<%= totalCards %> (<%= progress %>%)</span>
                    <%
                        }
                    %>
                </div>
            </div>
            
            <!-- カードエリア -->
            <div class="cards">
                <%
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
                    } else {
                %>
                <div class="no-game-message">
                    <h2>🎮 ゲームを開始しましょう！</h2>
                    <p>下のボタンをクリックして新しいゲームを始めてください。</p>
                    <a href="game" class="nav-btn restart-btn" style="display: inline-block; margin-top: 15px;">
                        🚀 ゲーム開始
                    </a>
                </div>
                <style>
                    .no-game-message {
                        text-align: center;
                        padding: 60px 20px;
                        color: #666;
                    }
                    .no-game-message h2 {
                        color: #333;
                        margin-bottom: 15px;
                    }
                </style>
                <%
                    }
                %>
            </div>
            
            <!-- 次へボタンエリア -->
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
        </div>
    </div>

    <script>
        // ページ読み込み時の処理
        window.addEventListener('DOMContentLoaded', function() {
            console.log('拡張ゲーム画面読み込み完了');
            
            // セッションストレージからユーザー情報を取得
            const loggedUser = sessionStorage.getItem('loggedInUser');
            if (loggedUser) {
                console.log('ログインユーザー:', loggedUser);
            }
            
            // タイマー開始（既存のタイマーが動いていなければ）
            if (!window.gameRunning) {
                window.startTimer();
                console.log('⏰ ゲームタイマー開始');
            }
            
            // カードアニメーションの遅延設定
            const cards = document.querySelectorAll('.card');
            cards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.05) + 's';
            });
        });
        
        // ゲーム終了確認
        window.addEventListener('beforeunload', function(e) {
            if (window.gameRunning) {
                const confirmationMessage = 'ゲーム進行中です。ページを離れますか？';
                e.returnValue = confirmationMessage;
                return confirmationMessage;
            }
        });
    </script>
</body>
</html>
