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
                    // シンプルなランキング表示
                    Object rankingObj = request.getAttribute("globalRanking");
                    
                    if (rankingObj != null) {
                        out.print("<p>ランキングデータが利用可能です</p>");
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
        console.log('ホーム画面読み込み完了');
    </script>
</body>
</html>
