<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>神経衰弱ゲーム - ログイン</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            padding: 20px;
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            width: 100%;
        }
        
        .game-title {
            color: #333;
            text-align: center;
            margin-bottom: 10px;
            font-size: 2rem;
        }
        
        .welcome-message {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }
        
        .input-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
        }
        
        .signup-section {
            text-align: center;
            margin-top: 20px;
        }
        
        .signup-btn {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .footer {
            text-align: center;
            margin-top: 20px;
        }
        
        .guest-link {
            color: #667eea;
            text-decoration: none;
        }
        
        .error-message {
            background: #ffe6e6;
            color: #d63384;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- ヘッダー -->
        <div class="header">
            <h1 class="game-title">🃏 神経衰弱ゲーム</h1>
            <p class="welcome-message">ログインしてゲームを始めましょう！</p>
        </div>        <!-- ログインフォーム -->
        <div class="login-form-container">
            <form id="loginForm" method="post" action="home.jsp" class="login-form">
                <input type="hidden" name="action" value="login">
                
                <!-- ユーザーネーム入力 -->
                <div class="input-group">
                    <label for="username">ユーザーネーム</label>
                    <input 
                        type="text" 
                        id="username" 
                        name="username" 
                        required 
                        placeholder="ユーザーネームを入力"
                        maxlength="20"
                    >
                </div>

                <!-- パスワード入力 -->
                <div class="input-group">
                    <label for="password">パスワード</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        required 
                        placeholder="パスワードを入力"
                        minlength="6"
                    >
                </div>

                <!-- ボタングループ -->
                <div class="button-group">
                    <button type="submit" class="login-btn">
                        🔑 ログイン
                    </button>
                </div>
            </form>

            <!-- アカウント作成リンク -->
            <div class="signup-section">
                <p class="signup-text">アカウントをお持ちでない方は</p>
                <a href="register.jsp" class="signup-btn">
                    ➕ アカウント作成
                </a>
            </div>
        </div>        <!-- フッター -->        <div class="footer">
            <p class="footer-text">
                ゲストとしてプレイする場合は 
                <a href="game?reset=true" class="guest-link">こちら</a>
            </p>
        </div>
    </div>

    <script>        // 基本的なフォーム検証とセッション設定
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            
            if (username.length < 3) {
                alert('ユーザーネームは3文字以上で入力してください。');
                e.preventDefault();
                return false;
            }
            
            if (password.length < 6) {
                alert('パスワードは6文字以上で入力してください。');
                e.preventDefault();
                return false;
            }
            
            // ログイン成功時のセッション設定
            sessionStorage.setItem('loggedInUser', username);
            sessionStorage.setItem('loginTime', new Date().toISOString());
            
            // フォーム送信前にユーザー名をhiddenフィールドに設定
            const hiddenUsername = document.createElement('input');
            hiddenUsername.type = 'hidden';
            hiddenUsername.name = 'loggedUsername';
            hiddenUsername.value = username;
            this.appendChild(hiddenUsername);
            
            console.log('ログイン処理:', { username: username, timestamp: new Date().toISOString() });
        });
    </script>
</body>
</html>
