<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>神経衰弱ゲーム - アカウント登録</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            padding: 20px;
        }
        
        .register-container {
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
            border-color: #764ba2;
        }
        
        .register-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #764ba2, #667eea);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .register-btn:hover {
            transform: translateY(-2px);
        }
        
        .login-section {
            text-align: center;
            margin-top: 20px;
        }
        
        .login-link {
            color: #764ba2;
            text-decoration: none;
            font-weight: 500;
        }
        
        .footer {
            text-align: center;
            margin-top: 20px;
        }
        
        .guest-link {
            color: #764ba2;
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
        
        .success-message {
            background: #e6f7ff;
            color: #1890ff;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        .password-match {
            font-size: 12px;
            margin-top: 5px;
        }
        
        .password-match.valid {
            color: #28a745;
        }
        
        .password-match.invalid {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <!-- ヘッダー -->
        <div class="header">
            <h1 class="game-title">🃏 神経衰弱ゲーム</h1>
            <p class="welcome-message">アカウントを作成してゲームを始めましょう！</p>
        </div>

        <!-- エラー・成功メッセージ表示エリア -->
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
            
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <div class="error-message">
            ⚠️ <%= errorMessage %>
        </div>
        <%
            }
            
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
        <div class="success-message">
            ✅ <%= successMessage %>
        </div>
        <%
            }
        %>        <!-- 登録フォーム -->
        <div class="register-form-container">
            <form id="registerForm" method="post" action="register" class="register-form">
                <!-- ユーザーネーム入力 -->
                <div class="input-group">
                    <label for="username">ユーザーネーム</label>
                    <input 
                        type="text" 
                        id="username" 
                        name="username" 
                        required 
                        placeholder="ユーザーネームを入力（3-20文字）"
                        maxlength="20"
                        minlength="3"
                        value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                        pattern="[a-zA-Z0-9_]+"
                        title="英数字とアンダースコアのみ使用可能です"
                    >
                    <div class="password-requirements">
                        ※ 3-20文字の英数字とアンダースコア(_)のみ使用可能
                    </div>
                </div>

                <!-- メールアドレス入力 -->
                <div class="input-group">
                    <label for="email">メールアドレス（任意）</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        placeholder="メールアドレスを入力"
                        maxlength="100"
                        value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                    >
                    <div class="password-requirements">
                        ※ パスワードリセット等に使用（任意項目）
                    </div>
                </div>

                <!-- 表示名入力 -->
                <div class="input-group">
                    <label for="displayName">表示名（任意）</label>
                    <input 
                        type="text" 
                        id="displayName" 
                        name="displayName" 
                        placeholder="ゲーム内で表示される名前"
                        maxlength="50"
                        value="<%= request.getAttribute("displayName") != null ? request.getAttribute("displayName") : "" %>"
                    >
                    <div class="password-requirements">
                        ※ 50文字以内。未入力の場合はユーザー名が使用されます
                    </div>
                </div>

                <!-- パスワード入力 -->
                <div class="input-group">
                    <label for="password">パスワード</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        required
                        placeholder="パスワードを入力（6文字以上）"
                        minlength="6"
                    >
                    <div class="password-requirements">
                        ※ 6文字以上で入力してください
                    </div>
                </div>

                <!-- パスワード確認入力 -->
                <div class="input-group">
                    <label for="confirmPassword">パスワード確認</label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        required 
                        placeholder="パスワードを再度入力"
                    >
                    <div id="passwordMatch" class="password-match"></div>
                </div>

                <!-- ボタングループ -->
                <div class="button-group">
                    <button type="submit" class="register-btn">
                        ➕ アカウント登録
                    </button>
                </div>
            </form>            <!-- ログインリンク -->
            <div class="login-section">
                <p class="login-text">すでにアカウントをお持ちの方は</p>
                <a href="login" class="login-link">
                    🔑 ログイン画面へ
                </a>
            </div>
        </div>        <!-- フッター -->        <div class="footer">
            <p class="footer-text">
                ゲストとしてプレイする場合は 
                <a href="game?reset=true" class="guest-link">こちら</a>
            </p>
        </div>
    </div>

    <script>
        // パスワードの一致確認
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword === '') {
                matchDiv.textContent = '';
                matchDiv.className = 'password-match';
                return;
            }
            
            if (password === confirmPassword) {
                matchDiv.textContent = '✓ パスワードが一致しています';
                matchDiv.className = 'password-match valid';
            } else {
                matchDiv.textContent = '✗ パスワードが一致しません';
                matchDiv.className = 'password-match invalid';
            }
        }
        
        // リアルタイムパスワード一致確認
        document.getElementById('password').addEventListener('input', checkPasswordMatch);
        document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
        
        // フォーム送信時の検証
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // ユーザーネーム検証
            if (username.length < 3 || username.length > 20) {
                alert('ユーザーネームは3文字以上20文字以下で入力してください。');
                e.preventDefault();
                return false;
            }
            
            // パスワード検証
            if (password.length < 6) {
                alert('パスワードは6文字以上で入力してください。');
                e.preventDefault();
                return false;
            }
              // パスワード一致確認
            if (password !== confirmPassword) {
                alert('パスワードが一致しません。確認してください。');
                e.preventDefault();
                return false;
            }
            
            // 登録成功時のセッション設定
            sessionStorage.setItem('loggedInUser', username);
            sessionStorage.setItem('registerTime', new Date().toISOString());
            
            // フォーム送信前にユーザー名をhiddenフィールドに設定
            const hiddenUsername = document.createElement('input');
            hiddenUsername.type = 'hidden';
            hiddenUsername.name = 'loggedUsername';
            hiddenUsername.value = username;
            this.appendChild(hiddenUsername);
            
            console.log('アカウント登録処理:', { username: username, timestamp: new Date().toISOString() });
            
            // 全て正常な場合
            return true;
        });
    </script>
</body>
</html>
