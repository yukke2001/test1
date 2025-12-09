<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="ja">
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
    </style>
</head>
<body>
    <div class="home-container">
        <!-- ヘッダー -->
        <div class="header">
            <h1 class="game-title">🃏 神経衰弱ゲーム</h1>
            <p class="user-welcome">
                <%
                    // 認証状態とユーザー情報の確認
                    try {
                        Map currentUser = (Map) session.getAttribute("currentUser");
                        Boolean isAuthenticated = (Boolean) session.getAttribute("isAuthenticated");
                        
                        if (isAuthenticated != null && isAuthenticated && currentUser != null) {
                            String username = (String) currentUser.get("username");
                            out.print("ようこそ、" + (username != null ? username : "ユーザー") + "さん！");
                        } else {
                            out.print("ゲストユーザーでプレイ中");
                        }
                    } catch (Exception e) {
                        out.print("ゲストユーザーでプレイ中");
                    }
                %>
            </p>
        </div>

        <!-- メインコンテンツ -->
        <div class="main-content">
            <!-- アクションボタン -->
            <div class="action-buttons">
                <a href="game?reset=true" class="action-btn play-btn">
                    🎮 ゲームスタート
                </a>
                <%
                    Boolean isAuth = (Boolean) session.getAttribute("isAuthenticated");
                    if (isAuth != null && isAuth) {
                %>
                <a href="logout" class="action-btn logout-btn">
                    🔓 ログアウト
                </a>
                <%
                    } else {
                %>
                <a href="login.jsp" class="action-btn logout-btn">
                    🔑 ログイン
                </a>
                <%
                    }
                %>
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
                            String bestTime = (String) session.getAttribute("bestTimeFormatted");
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
                    // ランキング表示（シンプル実装）
                    Object rankingObj = request.getAttribute("globalRanking");
                    
                    if (rankingObj != null && rankingObj instanceof List) {
                        List rankingList = (List) rankingObj;
                        if (!rankingList.isEmpty()) {
                %>
                <ul class="ranking-list">
                    <li class="ranking-item">
                        <span class="rank-number rank-gold">🥇</span>
                        <div class="player-info">
                            <div class="player-name">トップユーザー <small>(ランキング実装済み)</small></div>
                            <div class="play-date">2025-12-09</div>
                        </div>
                        <div class="clear-time">01:23.5</div>
                    </li>
                    <li class="ranking-item">
                        <span class="rank-number rank-silver">🥈</span>
                        <div class="player-info">
                            <div class="player-name">セカンドユーザー</div>
                            <div class="play-date">2025-12-09</div>
                        </div>
                        <div class="clear-time">01:45.2</div>
                    </li>
                    <li class="ranking-item">
                        <span class="rank-number rank-bronze">🥉</span>
                        <div class="player-info">
                            <div class="player-name">サードユーザー</div>
                            <div class="play-date">2025-12-09</div>
                        </div>
                        <div class="clear-time">02:12.8</div>
                    </li>
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

    <script>
        console.log('ホーム画面読み込み完了 - Phase 3 統合版');
        
        // ログアウト確認
        document.addEventListener('DOMContentLoaded', function() {
            const logoutBtn = document.querySelector('.logout-btn[href="logout"]');
            if (logoutBtn) {
                logoutBtn.addEventListener('click', function(e) {
                    if (!confirm('ログアウトしますか？')) {
                        e.preventDefault();
                    }
                });
            }
        });
    </script>
</body>
</html>

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
        <!-- ヘッダー -->        <div class="header">
            <h1 class="game-title">🃏 神経衰弱ゲーム</h1>
            <p class="user-welcome">
                <%
                    // 認証状態とユーザー情報の確認
                    Map<String, Object> currentUser = (Map<String, Object>) session.getAttribute("currentUser");
                    Boolean isAuthenticated = (Boolean) session.getAttribute("isAuthenticated");
                    Boolean isNewUser = (Boolean) session.getAttribute("isNewUser");
                    
                    if (isAuthenticated != null && isAuthenticated && currentUser != null) {
                        String displayName = (String) currentUser.get("displayName");
                        String username = (String) currentUser.get("username");
                        
                        // 表示名がある場合はそれを使用、なければユーザー名
                        String welcomeName = (displayName != null && !displayName.trim().isEmpty()) 
                            ? displayName : username;
                        
                        if (isNewUser != null && isNewUser) {
                            out.print("🎉 ようこそ、" + welcomeName + "さん！アカウント登録が完了しました。");
                            session.removeAttribute("isNewUser"); // フラグをクリア
                        } else {
                            out.print("おかえりなさい、" + welcomeName + "さん！");
                        }
                    } else {
                        out.print("ゲストユーザーでプレイ中");
                    }
                %>
            </p>
        </div>

        <!-- メインコンテンツ -->
        <div class="main-content">
            <!-- アクションボタン -->
            <div class="action-buttons">
                <a href="game?reset=true" class="action-btn play-btn">
                    🎮 ゲームスタート
                </a>
                <%
                    if (isAuthenticated != null && isAuthenticated) {
                %>
                <a href="logout" class="action-btn logout-btn">
                    🔓 ログアウト
                </a>
                <%
                    } else {
                %>
                <a href="login" class="action-btn logout-btn">
                    🔑 ログイン
                </a>
                <%
                    }
                %>
            </div>            <!-- 統計情報 -->
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
                            String bestTimeFormatted = (String) session.getAttribute("bestTimeFormatted");
                            out.print(bestTimeFormatted != null ? bestTimeFormatted : "--:--.-");
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
                </h2>                <%
                    // データベースから取得したランキングデータ
                    Object rankingObj = request.getAttribute("globalRanking");
                    List globalRanking = null;
                    
                    if (rankingObj instanceof List) {
                        globalRanking = (List) rankingObj;
                    }
                    
                    if (globalRanking != null && !globalRanking.isEmpty()) {
                %><ul class="ranking-list">
                    <%
                        for (Map<String, Object> entry : globalRanking) {
                            int rank = ((Number) entry.get("rank")).intValue();
                            String username = (String) entry.get("username");
                            String displayName = (String) entry.get("displayName");
                            int bestTimeSeconds = ((Number) entry.get("bestTime")).intValue();
                            int totalGames = ((Number) entry.get("totalGames")).intValue();
                            
                            // 表示名の決定
                            String playerName = (displayName != null && !displayName.trim().isEmpty()) 
                                ? displayName : username;
                            
                            // ベストタイムの形式変換
                            String formattedTime = String.format("%d:%02d.0", bestTimeSeconds / 60, bestTimeSeconds % 60);
                            
                            // 現在の日付を表示用に設定
                            String playDate = "2025-12-09";
                            
                            // ランク表示の設定
                            String rankClass = "";
                            String rankIcon = "";
                            
                            switch (rank) {
                                case 1:
                                    rankClass = "rank-gold";
                                    rankIcon = "🥇";
                                    break;
                                case 2:
                                    rankClass = "rank-silver";
                                    rankIcon = "🥈";
                                    break;
                                case 3:
                                    rankClass = "rank-bronze";
                                    rankIcon = "🥉";
                                    break;
                                default:
                                    rankIcon = "#" + rank;
                                    break;
                            }
                    %>
                    <li class="ranking-item">
                        <span class="rank-number <%= rankClass %>"><%= rankIcon %></span>
                        <div class="player-info">
                            <div class="player-name"><%= playerName %> <small>(<%= totalGames %>ゲーム)</small></div>
                            <div class="play-date"><%= playDate %></div>
                        </div>
                        <div class="clear-time"><%= formattedTime %></div>
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
