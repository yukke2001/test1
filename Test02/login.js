// login.js - ログイン画面JavaScript

console.log('🔑 login.js 読み込み開始');

/**
 * ページ読み込み完了時の初期化
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('📄 ログイン画面初期化開始');
    
    initializeLoginForm();
    addInputValidation();
    addFormSubmissionHandler();
    
    console.log('✅ ログイン画面初期化完了');
});

/**
 * ログインフォームの初期化
 */
function initializeLoginForm() {
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    
    // オートフォーカス
    if (usernameInput) {
        usernameInput.focus();
    }
    
    // Enter キーでの送信設定
    [usernameInput, passwordInput].forEach(input => {
        if (input) {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const form = document.getElementById('loginForm');
                    if (validateForm()) {
                        form.submit();
                    }
                }
            });
        }
    });
}

/**
 * 入力値のリアルタイム検証
 */
function addInputValidation() {
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    
    // ユーザーネーム検証
    if (usernameInput) {
        usernameInput.addEventListener('input', function() {
            validateUsername(this.value);
        });
        
        usernameInput.addEventListener('blur', function() {
            validateUsername(this.value, true);
        });
    }
    
    // パスワード検証
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            validatePassword(this.value);
        });
        
        passwordInput.addEventListener('blur', function() {
            validatePassword(this.value, true);
        });
    }
}

/**
 * フォーム送信時の検証
 */
function addFormSubmissionHandler() {
    const form = document.getElementById('loginForm');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            console.log('📋 フォーム送信試行');
            
            if (!validateForm()) {
                e.preventDefault();
                console.log('❌ フォーム検証失敗 - 送信を阻止');
                showError('入力内容を確認してください。');
                return false;
            }
            
            console.log('✅ フォーム検証成功');
            showLoadingState();
        });
    }
}

/**
 * ユーザーネーム検証
 */
function validateUsername(value, showError = false) {
    const input = document.getElementById('username');
    
    // 空文字チェック
    if (!value || value.trim() === '') {
        if (showError) {
            setInputError(input, 'ユーザーネームを入力してください。');
        }
        return false;
    }
    
    // 長さチェック
    if (value.length < 3) {
        if (showError) {
            setInputError(input, 'ユーザーネームは3文字以上で入力してください。');
        }
        return false;
    }
    
    if (value.length > 20) {
        setInputError(input, 'ユーザーネームは20文字以内で入力してください。');
        return false;
    }
    
    // 文字種チェック（英数字とアンダースコアのみ）
    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(value)) {
        if (showError) {
            setInputError(input, '英数字とアンダースコア（_）のみ使用できます。');
        }
        return false;
    }
    
    setInputSuccess(input);
    return true;
}

/**
 * パスワード検証
 */
function validatePassword(value, showError = false) {
    const input = document.getElementById('password');
    
    // 空文字チェック
    if (!value || value.trim() === '') {
        if (showError) {
            setInputError(input, 'パスワードを入力してください。');
        }
        return false;
    }
    
    // 長さチェック
    if (value.length < 6) {
        if (showError) {
            setInputError(input, 'パスワードは6文字以上で入力してください。');
        }
        return false;
    }
    
    if (value.length > 50) {
        setInputError(input, 'パスワードは50文字以内で入力してください。');
        return false;
    }
    
    setInputSuccess(input);
    return true;
}

/**
 * フォーム全体の検証
 */
function validateForm() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    
    const isUsernameValid = validateUsername(username, true);
    const isPasswordValid = validatePassword(password, true);
    
    return isUsernameValid && isPasswordValid;
}

/**
 * 入力フィールドのエラー状態設定
 */
function setInputError(input, message) {
    clearInputStatus(input);
    
    input.style.borderColor = '#e53e3e';
    input.style.backgroundColor = '#fed7d7';
    
    // エラーメッセージ要素を作成/更新
    const errorId = input.id + '-error';
    let errorElement = document.getElementById(errorId);
    
    if (!errorElement) {
        errorElement = document.createElement('div');
        errorElement.id = errorId;
        errorElement.className = 'input-error-message';
        errorElement.style.cssText = `
            color: #c53030;
            font-size: 0.8em;
            margin-top: 4px;
            margin-left: 4px;
        `;
        input.parentNode.appendChild(errorElement);
    }
    
    errorElement.textContent = message;
}

/**
 * 入力フィールドの成功状態設定
 */
function setInputSuccess(input) {
    clearInputStatus(input);
    
    input.style.borderColor = '#38a169';
    input.style.backgroundColor = '#f0fff4';
}

/**
 * 入力フィールドの状態クリア
 */
function clearInputStatus(input) {
    input.style.borderColor = '#e2e8f0';
    input.style.backgroundColor = '#f7fafc';
    
    const errorElement = document.getElementById(input.id + '-error');
    if (errorElement) {
        errorElement.remove();
    }
}

/**
 * エラーメッセージ表示
 */
function showError(message) {
    // 既存のエラーメッセージを削除
    const existingError = document.querySelector('.error-message');
    if (existingError) {
        existingError.remove();
    }
    
    // 新しいエラーメッセージを作成
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.innerHTML = `
        <i class="error-icon">⚠️</i>
        ${message}
    `;
    
    // フォームの前に挿入
    const form = document.getElementById('loginForm');
    form.parentNode.insertBefore(errorDiv, form);
    
    // 3秒後に自動削除
    setTimeout(() => {
        if (errorDiv.parentNode) {
            errorDiv.remove();
        }
    }, 3000);
}

/**
 * ローディング状態表示
 */
function showLoadingState() {
    const submitBtn = document.querySelector('.login-btn');
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `
            <span style="animation: spin 1s linear infinite; display: inline-block;">⏳</span>
            ログイン中...
        `;
        
        // スピンアニメーションのCSS追加
        const style = document.createElement('style');
        style.textContent = `
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);
    }
}

/**
 * デモ用の簡易認証（将来的にサーバーサイドで実装）
 */
function demoAuthenticate(username, password) {
    // 開発用の簡易認証
    const demoUsers = {
        'test': 'password',
        'admin': 'admin123',
        'demo': 'demo123'
    };
    
    return demoUsers[username] === password;
}

console.log('✅ login.js 読み込み完了');
