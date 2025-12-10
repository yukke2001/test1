<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>神経衰弱ゲーム - ホーム</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        
        .home-container {
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
            padding: 30px;
            text-align: center;
        }
        
        .game-title {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .user-welcome {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .main-content {
            padding: 40px;
        }
        
        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .play-btn {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
        }
        
        .logout-btn {
            background: linear-gradient(135deg, #fa709a, #fee140);
            color: white;
        }
        
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .ranking-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-top: 20px;
        }
        
        .ranking-title {
            text-align: center;
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .ranking-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .ranking-item {
            background: white;
            margin-bottom: 10px;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.2s;
        }
        
        .ranking-item:hover {
            transform: translateX(5px);
        }
        
        .rank-number {
            font-size: 1.5rem;
            font-weight: bold;
            color: #667eea;
            min-width: 40px;
        }
        
        .rank-gold { color: #ffd700; }
        .rank-silver { color: #c0c0c0; }
        .rank-bronze { color: #cd7f32; }
        
        .player-info {
            flex-grow: 1;
            margin-left: 15px;
        }
        
        .player-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 3px;
        }
        
        .play-date {
            font-size: 0.8rem;
            color: #666;
        }
        
        .clear-time {
            font-size: 1.3rem;
            font-weight: bold;
            color: #28a745;
        }
        
        .no-records {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 40px;
        }
        
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            display: block;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9rem;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .home-container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .header {
                padding: 20px;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .action-btn {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="home-container">
        <!-- ヘッダー -->
        <div class="header">
            <h1 class="game-title">🃏 神経衰弱ゲーム</h1>            <p class="user-welcome">
                <%
                    String username = (String) session.getAttribute("username");
                    String loggedUsername = request.getParameter("loggedUsername");
                    
                    // リクエストパラメータからユーザー名を取得してセッションに設定
                    if (loggedUsername != null && !loggedUsername.isEmpty()) {
                        session.setAttribute("username", loggedUsername);
                        username = loggedUsername;
                    }
                    
                    if (username != null && !username.isEmpty()) {
                        out.print("ようこそ、" + username + "さん！");
                    } else {
                        out.print("ゲストユーザーでログイン中");
                    }
                %>
            </p>
        </div>

        <!-- メインコンテンツ -->
        <div class="main-content">            <!-- アクションボタン -->            <div class="action-buttons">
                <a href="game?reset=true" class="action-btn play-btn">
                    🎮 ゲームスタート
                </a>
                <a href="login.jsp" class="action-btn logout-btn">
                    🔒 ログアウト
                </a>
            </div>

            <!-- 統計情報 -->
            <div class="stats-section">
                <div class="stat-card">
                    <span class="stat-number">
                        <%
                            Integer totalGames = (Integer) session.getAttribute("totalGames");
                            out.print(totalGames != null ? totalGames : 0);
                        %>
                    </span>
                    <div class="stat-label">総プレイ回数</div>
                </div>
                <div class="stat-card">
                    <span class="stat-number">
                        <%
                            String bestTime = (String) session.getAttribute("bestTime");
                            out.print(bestTime != null ? bestTime : "--:--.-");
                        %>
                    </span>
                    <div class="stat-label">ベストタイム</div>
                </div>
                <div class="stat-card">
                    <span class="stat-number">
                        <%
                            Integer winStreak = (Integer) session.getAttribute("winStreak");
                            out.print(winStreak != null ? winStreak : 0);
                        %>
                    </span>
                    <div class="stat-label">連続クリア</div>
                </div>
            </div>

            <!-- ランキングセクション -->
            <div class="ranking-section">
                <h2 class="ranking-title">
                    🏆 ランキング TOP5
                </h2>

                <%
                    // 仮のランキングデータ（後でデータベースから取得予定）
                    String[][] rankings = {
                        {"1", "speedrunner", "01:23.5", "2025-12-05"},
                        {"2", "cardmaster", "01:45.2", "2025-12-04"},
                        {"3", "memoryking", "02:12.8", "2025-12-03"},
                        {"4", "quickfinish", "02:34.1", "2025-12-02"},
                        {"5", "gamepro", "02:56.7", "2025-12-01"}
                    };
                    
                    if (rankings != null && rankings.length > 0) {
                %>
                <ul class="ranking-list">
                    <%
                        for (int i = 0; i < rankings.length; i++) {
                            String[] ranking = rankings[i];
                            String rankClass = "";
                            String rankIcon = "";
                            
                            switch (ranking[0]) {
                                case "1":
                                    rankClass = "rank-gold";
                                    rankIcon = "🥇";
                                    break;
                                case "2":
                                    rankClass = "rank-silver";
                                    rankIcon = "🥈";
                                    break;
                                case "3":
                                    rankClass = "rank-bronze";
                                    rankIcon = "🥉";
                                    break;
                                default:
                                    rankIcon = "#" + ranking[0];
                                    break;
                            }
                    %>
                    <li class="ranking-item">
                        <span class="rank-number <%= rankClass %>"><%= rankIcon %></span>
                        <div class="player-info">
                            <div class="player-name"><%= ranking[1] %></div>
                            <div class="play-date"><%= ranking[3] %></div>
                        </div>
                        <div class="clear-time"><%= ranking[2] %></div>
                    </li>
                    <%
                        }
                    %>
                </ul>
                <%
                    } else {
                %>
                <div class="no-records">
                    まだランキング記録がありません。<br>
                    ゲームをプレイして記録を作りましょう！
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script>        // ページ読み込み時の処理
        window.addEventListener('DOMContentLoaded', function() {
            console.log('ホーム画面読み込み完了');
            
            // セッションストレージからユーザー名を取得して表示更新
            const loggedUser = sessionStorage.getItem('loggedInUser');
            if (loggedUser) {
                const welcomeElement = document.querySelector('.user-welcome');
                if (welcomeElement) {
                    welcomeElement.textContent = 'ようこそ、' + loggedUser + 'さん！';
                }
                console.log('ログインユーザー:', loggedUser);
            }
            
            // ローカルストレージから統計情報を読み込み（将来の機能拡張用）
            const stats = {
                totalGames: localStorage.getItem('totalGames') || 0,
                bestTime: localStorage.getItem('bestTime') || '--:--.-',
                winStreak: localStorage.getItem('winStreak') || 0
            };
            
            console.log('ユーザー統計:', stats);
        });
        
        // ログアウト確認
        document.querySelector('.logout-btn').addEventListener('click', function(e) {
            if (!confirm('ログアウトしますか？')) {
                e.preventDefault();
            } else {
                // セッションをクリア
                sessionStorage.clear();
                localStorage.removeItem('gameStartTime');
                localStorage.removeItem('gameRunning');
                localStorage.removeItem('gameTime');
                localStorage.removeItem('gameTimeMs');
            }
        });
    </script>
</body>
</html>
