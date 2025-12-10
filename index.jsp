<%-- 
【神経衰弱ゲーム - スタート画面】
index.jsp

役割：
1. ゲーム開始前のウェルカム画面表示
2. プレイヤー名の入力受け取り
3. 既存プレイヤーの継続プレイ対応
4. 将来のDB連携に向けた基盤構築

遷移元：StartServlet.doGet() でスタート画面表示
遷移先：StartServlet.doPost() でプレイヤー情報処理後、ゲーム画面へ
--%>

<%-- 
【JSPページディレクティブ】
- language="java": サーバーサイドスクリプト言語をJavaに指定
- contentType: ブラウザへのHTTPレスポンス形式（UTF-8エンコーディングのHTML）
- pageEncoding: JSPファイル自体の文字エンコーディング
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <%-- ページタイトル：ブラウザのタブに表示される --%>
    <title>神経衰弱ゲーム - スタート</title>
    
    <%-- キャッシュ無効化設定 --%>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <%-- 
    外部CSSファイルの読み込み
    start.css: スタート画面専用のスタイル（アニメーション、フォーム等）
    --%>
    <link rel="stylesheet" type="text/css" href="start.css?v=20241202001">
    
    <%-- レスポンシブ対応のためのビューポート設定 --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="container">
        <%-- 
        【メインタイトルエリア】
        ゲーム名とキャッチフレーズの表示
        --%>
        <header class="game-header">
            <h1 class="game-title">🧠 神経衰弱ゲーム 🎴</h1>
            <p class="game-subtitle">記憶力を鍛えよう！16枚のカードでチャレンジ</p>
        </header>

        <%-- 
        【ウェルカムメッセージエリア】
        StartServletから渡されるメッセージを表示
        --%>
        <section class="welcome-section">
            <div class="welcome-message">
                <h2>
                    <%= request.getAttribute("welcomeMessage") != null 
                        ? request.getAttribute("welcomeMessage") 
                        : "神経衰弱ゲームへようこそ！" %>
                </h2>
            </div>
            
            <%-- 既存プレイヤーの統計情報表示 --%>
            <% if (request.getAttribute("existingPlayerName") != null) { %>
                <div class="player-stats">
                    <p class="stats-info">
                        🎮 プレイ回数: <span class="stats-number"><%= request.getAttribute("totalGames") %></span>回
                    </p>
                </div>
            <% } %>
        </section>        <%-- 
        【エラーメッセージ表示】
        入力エラーがある場合のメッセージ表示エリア
        --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                ⚠️ <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <%-- 
        【ログインオプション】
        アカウントを持つプレイヤー向けのログインセクション
        --%>
        <section class="auth-section">
            <div class="auth-container">
                <h3 class="auth-title">👤 アカウントをお持ちの方</h3>
                <div class="auth-buttons">
                    <a href="login.jsp" class="login-button">
                        🔑 ログイン
                    </a>
                    <a href="register.jsp" class="register-button">
                        ➕ 新規登録
                    </a>
                </div>
            </div>
            
            <div class="divider-container">
                <div class="divider-line"></div>
                <span class="divider-text">または</span>
                <div class="divider-line"></div>
            </div>
        </section>

        <%-- 
        【プレイヤー登録フォーム】
        新規プレイヤー用のプレイヤー名入力フォーム（ゲストプレイ）
        --%>
        <section class="player-form-section">
            <form method="post" action="start" class="player-form">
                <%-- アクション種別の指定 --%>
                <input type="hidden" name="action" value="start" />
                
                <div class="form-group">
                    <label for="playerName" class="form-label">
                        👤 プレイヤー名を入力してください
                    </label>
                    <input 
                        type="text" 
                        id="playerName" 
                        name="playerName" 
                        class="form-input"
                        placeholder="例：やまだ太郎"
                        maxlength="20"
                        value="<%= request.getAttribute("inputPlayerName") != null ? request.getAttribute("inputPlayerName") : "" %>"
                        required
                    />
                    <div class="input-hint">※ 20文字以内で入力してください</div>
                </div>
                
                <button type="submit" class="start-button">
                    🚀 ゲーム開始
                </button>
            </form>
        </section>

        <%-- 
        【既存プレイヤー継続エリア】
        既にプレイヤー名が登録されている場合の継続プレイボタン
        --%>
        <% if (request.getAttribute("existingPlayerName") != null) { %>
            <section class="continue-section">
                <div class="section-divider">
                    <span class="divider-text">または</span>
                </div>
                
                <form method="post" action="start" class="continue-form">
                    <input type="hidden" name="action" value="continue" />
                    <button type="submit" class="continue-button">
                        🎯 <%= request.getAttribute("existingPlayerName") %>さんで続ける
                    </button>
                </form>
            </section>
        <% } %>

        <%-- 
        【ゲーム説明エリア】
        ルール説明と遊び方の案内
        --%>
        <section class="game-info-section">
            <details class="game-rules">
                <summary class="rules-summary">📖 ゲームルールを見る</summary>
                <div class="rules-content">
                    <h3>🎯 ゲームの目標</h3>
                    <p>16枚のカードから同じ絵柄のペアを見つけて、すべてのカードを消去する</p>
                    
                    <h3>🎮 遊び方</h3>
                    <ol>
                        <li>裏向きのカードを2枚選んでクリック</li>
                        <li>2枚とも表になったら「次へ」ボタンをクリック</li>
                        <li>同じ絵柄なら消去、違ったら再び裏向きに</li>
                        <li>すべてのペアを見つけるとクリア！</li>
                    </ol>
                    
                    <h3>💡 コツ</h3>
                    <p>カードの位置と絵柄をしっかり記憶することが重要です</p>
                </div>
            </details>
        </section>

        <%-- 
        【フッター情報】
        将来のDB連携や追加機能の案内エリア
        --%>
        <footer class="game-footer">
            <p class="footer-text">🎴 Memory Card Game - Ver 2.0</p>
            <p class="footer-hint">近日公開：ランキング機能・タイム計測</p>
        </footer>
    </div>

    <%-- 
    【JavaScriptによるユーザビリティ向上】
    フォーム入力の改善とアニメーション効果
    --%>
    <script>
        // プレイヤー名入力フィールドにフォーカス
        document.addEventListener('DOMContentLoaded', function() {
            const playerNameInput = document.getElementById('playerName');
            if (playerNameInput && !playerNameInput.value) {
                playerNameInput.focus();
            }
        });

        // Enterキーでフォーム送信
        document.getElementById('playerName').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.querySelector('.player-form').submit();
            }
        });

        // 入力文字数リアルタイム表示
        document.getElementById('playerName').addEventListener('input', function(e) {
            const currentLength = e.target.value.length;
            const maxLength = 20;
            const hint = document.querySelector('.input-hint');
            
            if (currentLength > 15) {
                hint.style.color = '#ff6b6b';
                hint.textContent = `※ あと${maxLength - currentLength}文字入力可能`;
            } else {
                hint.style.color = '#666';
                hint.textContent = '※ 20文字以内で入力してください';
            }
        });

        // ボタンクリック時のアニメーション
        document.querySelectorAll('button[type="submit"]').forEach(button => {
            button.addEventListener('click', function(e) {
                this.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 150);
            });
        });
    </script>
</body>
</html>
