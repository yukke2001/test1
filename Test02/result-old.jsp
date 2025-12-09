<%-- 
【ゲーム完了画面 - result.jsp】
神経衰弱ゲームのクリア画面を表示するJSPファイル

役割：
1. ゲームクリア時の祝福メッセージ表示
2. 新しいゲームを開始するためのリスタート機能
3. プレイヤーの達成感を演出

遷移元：GameServlet.doPost() で全カードペア成立時
遷移先：「もう一度遊ぶ」ボタンクリックでGameServletに戻る
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
    <title>神経衰弱 ゲームクリア</title>
    
    <%-- 
    外部CSSファイルの読み込み
    result.css: クリア画面専用のスタイル（祝福演出、ボタンデザイン等）
    --%>    <link rel="stylesheet" type="text/css" href="result.css?v=20241202003">
    <!-- 超シンプル結果表示（リセット問題解決版） -->
    <script src="ultra-simple-result.js?v=20241204001"></script>
    <script>
        // タイマー結果表示
        function displayGameTime() {
            console.log('=== displayGameTime開始 ===');
            
            // sessionStorageから時間を取得
            const gameTime = sessionStorage.getItem('gameTime');
            const gameTimeMs = sessionStorage.getItem('gameTimeMs');
            
            console.log('保存されたゲーム時間:', gameTime);
            console.log('保存されたゲーム時間(ms):', gameTimeMs);
            
            let displayTime = '記録なし';
            let message = 'ゲームを完了してクリア時間を記録しましょう！';
            
            // タイムが記録されている場合
            if (gameTime && gameTime !== '00:00.0' && gameTime !== 'null' && gameTime !== null) {
                displayTime = gameTime;
                message = '素晴らしい記録です！';
                console.log('✅ 有効なゲーム時間が見つかりました:', displayTime);
            } else {
                console.log('❌ 記録なし、または無効な時間です');
            }
            
            // 既存の表示要素があれば削除
            const existingDisplay = document.querySelector('.clear-time-display');
            if (existingDisplay) {
                existingDisplay.remove();
            }
            
            // クリア時間表示エリアを作成
            const timeDisplay = document.createElement('div');
            timeDisplay.className = 'clear-time-display';
            timeDisplay.style.cssText = 'text-align: center; margin: 20px 0; color: #fff;';
            
            // 内容を直接作成
            const timeHeader = document.createElement('h2');
            timeHeader.textContent = '⏱️ クリア時間';
            timeHeader.style.cssText = 'color: #ffd700; margin: 20px 0 10px 0; font-size: 1.5em;';
            
            const timeValue = document.createElement('div');
            timeValue.textContent = displayTime;
            timeValue.style.cssText = 'font-size: 2em; font-weight: bold; color: #fff; margin: 10px 0;';
            
            const timeMessage = document.createElement('div');
            timeMessage.textContent = message;
            timeMessage.style.cssText = 'color: #ccc; margin: 10px 0; font-size: 1.1em;';
            
            timeDisplay.appendChild(timeHeader);
            timeDisplay.appendChild(timeValue);
            timeDisplay.appendChild(timeMessage);
            
            // 既存のお祝いメッセージの後に挿入
            const celebrationContent = document.querySelector('.celebration-content');
            if (celebrationContent) {
                celebrationContent.appendChild(timeDisplay);
                console.log('✅ タイマー表示追加完了');
            } else {
                console.error('❌ celebration-content要素が見つかりません');
                document.body.appendChild(timeDisplay);
                console.log('⚠️ bodyに直接タイマー表示を追加しました');
            }
            
            console.log('=== displayGameTime完了 ===');
        }

        // ページ読み込み完了時に実行
        window.addEventListener('load', function() {
            console.log('🎊 result.js ページ読み込み完了');
            setTimeout(displayGameTime, 200);
        });
    </script>
      <!-- 祝福エフェクト用JavaScript -->
    <script>        // タイマー結果表示
        function displayGameTime() {
            console.log('displayGameTime開始');
            
            // sessionStorageから時間を取得
            const gameTime = sessionStorage.getItem('gameTime');
            const gameTimeMs = sessionStorage.getItem('gameTimeMs');
            
            console.log('保存されたゲーム時間:', gameTime);
            console.log('保存されたゲーム時間(ms):', gameTimeMs);
            console.log('セッションストレージ全体:', sessionStorage);
            
            let displayTime = '記録なし';
            let message = 'ゲームを完了してクリア時間を記録しましょう！';
            
            // タイムが記録されている場合
            if (gameTime && gameTime !== '00:00.0') {
                displayTime = gameTime;
                message = '素晴らしい記録です！';
                console.log('有効なゲーム時間が見つかりました:', displayTime);
            } else {
                console.log('記録なし、または無効な時間です');
            }
            
            // クリア時間表示エリアを作成
            const timeDisplay = document.createElement('div');
            timeDisplay.className = 'clear-time-display';
            timeDisplay.innerHTML = `
                <h2>⏱️ クリア時間</h2>
                <div class="clear-time">${displayTime}</div>
                <div class="clear-message">${message}</div>
            `;
            
            // 既存のお祝いメッセージの後に挿入
            const celebrationContent = document.querySelector('.celebration-content');
            if (celebrationContent) {
                celebrationContent.appendChild(timeDisplay);
                console.log('タイマー表示追加完了');
            } else {
                console.error('celebration-content要素が見つかりません');
                // 代替手段としてbodyに直接追加
                document.body.appendChild(timeDisplay);
            }
        }
        
        function createCelebration() {
            // 紙吹雪エフェクト
            const colors = ['#ffd700', '#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#ff9ff3', '#54a0ff'];
            
            for (let i = 0; i < 50; i++) {
                setTimeout(() => {
                    const confetti = document.createElement('div');
                    confetti.style.position = 'fixed';
                    confetti.style.width = Math.random() * 10 + 5 + 'px';
                    confetti.style.height = confetti.style.width;
                    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    confetti.style.borderRadius = '50%';
                    confetti.style.left = Math.random() * window.innerWidth + 'px';
                    confetti.style.top = '-20px';
                    confetti.style.zIndex = '9999';
                    confetti.style.pointerEvents = 'none';
                    confetti.style.animation = `confettiFall ${2 + Math.random() * 3}s linear forwards`;
                    
                    document.body.appendChild(confetti);
                    
                    setTimeout(() => {
                        if (confetti.parentNode) {
                            confetti.parentNode.removeChild(confetti);
                        }
                    }, 5000);
                }, i * 100);
            }
            
            // 花火エフェクト
            for (let j = 0; j < 5; j++) {
                setTimeout(() => {
                    createFirework();
                }, j * 800);
            }
        }
        
        function createFirework() {
            const x = Math.random() * window.innerWidth;
            const y = Math.random() * (window.innerHeight / 2) + 100;
            
            for (let i = 0; i < 15; i++) {
                const spark = document.createElement('div');
                spark.style.position = 'fixed';
                spark.style.width = '4px';
                spark.style.height = '4px';
                spark.style.backgroundColor = '#ffd700';
                spark.style.borderRadius = '50%';
                spark.style.left = x + 'px';
                spark.style.top = y + 'px';
                spark.style.zIndex = '9999';
                spark.style.pointerEvents = 'none';
                
                const angle = (i / 15) * 2 * Math.PI;
                const velocity = 50 + Math.random() * 50;
                spark.style.animation = `firework ${1 + Math.random()}s ease-out forwards`;
                spark.style.setProperty('--dx', Math.cos(angle) * velocity + 'px');
                spark.style.setProperty('--dy', Math.sin(angle) * velocity + 'px');
                
                document.body.appendChild(spark);
                
                setTimeout(() => {
                    if (spark.parentNode) {
                        spark.parentNode.removeChild(spark);
                    }
                }, 2000);
            }
        }
          // ページ読み込み時に祝福エフェクトとタイマー表示開始
        window.addEventListener('load', function() {
            displayGameTime();      // タイマー結果表示
            setTimeout(createCelebration, 500);  // 祝福エフェクト
        });
    </script>
    
    <style>
        @keyframes confettiFall {
            0% {
                transform: translateY(-20px) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }
        
        @keyframes firework {
            0% {
                transform: translate(0, 0);
                opacity: 1;
            }
            100% {
                transform: translate(var(--dx), var(--dy));
                opacity: 0;
            }
        }
          .celebration-text {
            animation: subtle-glow 3s ease-in-out infinite alternate !important;
        }
          @keyframes subtle-glow {
            0% {
                text-shadow: 0 0 10px rgba(255, 215, 0, 0.4);
            }
            100% {
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.6);
            }
        }
    </style>
</head>
<body>    <%-- 
    【クリア祝福メッセージエリア】
    プレイヤーのゲーム完了を祝福する表示
    --%>
    <div class="celebration-content">
        <h1 class="celebration-text">ゲームクリア！🎉</h1>
        <p>おめでとうございます！</p>
        <!-- タイマー表示エリアはJavaScriptで動的に追加される -->
    </div>
      <%-- 
    【ゲーム再開フォーム】
    プレイヤーが新しいゲームを開始するためのフォーム
    
    動作フロー：
    1. 「もう一度遊ぶ」ボタンクリック
    2. POST /game リクエスト送信
    3. action="restart" パラメータ付き
    4. GameServlet.doPost() で受信
    5. ゲームデータ初期化（initCards()）
    6. game.jsp に転送して新しいゲーム開始
    --%>
    <div class="button-container">
        <form method="post" action="game" style="display: inline-block; margin-right: 15px;">
            <%-- 
            【隠しフィールド - アクション指定】
            name="action" value="restart"
            
            目的：GameServletでリクエストの種類を識別
            - action="restart": 新ゲーム開始
            - action="next": ターン進行（ゲーム中）
            - action=null: カードクリック（ゲーム中）            --%>
            <input type="hidden" name="action" value="restart" />
            <input type="hidden" name="resetTimer" value="true" />
            
            <%-- 
            【再開ボタン】
            type="submit": フォーム送信ボタン
            class="restart-btn": result.cssでスタイル適用
            
            クリック時の処理：
            1. POSTリクエストでGameServletに送信
            2. action="restart"でゲーム初期化処理実行
            3. 新しいカード配置でgame.jspに遷移
            --%>
            <button type="submit" class="restart-btn">もう一度遊ぶ</button>
        </form>
        
        <%-- 
        【スタート画面遷移ボタン】
        スタート画面（index.jsp）に戻る機能
        
        動作フロー：
        1. 「スタート画面へ」ボタンクリック
        2. index.jspに直接遷移
        3. プレイヤー選択画面やゲーム説明の表示
        --%>
        <a href="index.jsp" class="start-btn">スタート画面へ</a>
    </div>
</body>
</html>
