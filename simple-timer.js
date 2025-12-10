// simple-timer.js - シンプルで確実なタイマー実装

console.log('simple-timer.js 読み込み開始');

// グローバル変数でタイマー管理
window.timerStartTime = null;
window.timerRunning = false;
window.timerInterval = null;
window.timerInitialized = false; // 初期化重複防止フラグ

// formatTime関数を修正
function formatTime(ms) {
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    const deciseconds = Math.floor((ms % 1000) / 100);
    
    const minuteStr = minutes.toString().padStart(2, '0');
    const secondStr = seconds.toString().padStart(2, '0');
    const decisecondStr = deciseconds.toString();
    
    return minuteStr + ':' + secondStr + '.' + decisecondStr;
}

// タイマー開始関数
window.startGameTimer = function() {
    console.log('=== startGameTimer 呼び出し ===');
    
    if (!window.timerRunning) {
        window.timerStartTime = Date.now();
        window.timerRunning = true;
        
        // セッションストレージに状態を保存（ページ遷移で復元するため）
        sessionStorage.setItem('timerStartTime', window.timerStartTime.toString());
        sessionStorage.setItem('timerRunning', 'true');
          window.timerInterval = setInterval(function() {
            const elapsed = Date.now() - window.timerStartTime;
            const timeStr = formatTime(elapsed);
            
            const display = document.getElementById('timer-display');
            if (display) {
                display.textContent = timeStr;
            }
            
            // 継続的にセッションストレージを更新（ページ遷移対策）
            sessionStorage.setItem('timerStartTime', window.timerStartTime.toString());
            sessionStorage.setItem('timerRunning', 'true');
            
            // 5秒ごとにログ出力
            if (Math.floor(elapsed / 1000) % 5 === 0 && elapsed % 1000 < 100) {
                console.log('⏰ タイマー動作中:', timeStr);
            }
        }, 100);
        
        console.log('✅ タイマー開始完了 - セッション保存済み');
        return true;
    } else {
        console.log('⚠️ タイマーは既に動作中');
    }
    return false;
};

// タイマー停止関数
window.stopGameTimer = function() {
    console.log('=== stopGameTimer 呼び出し ===');
    
    if (window.timerRunning) {
        window.timerRunning = false;
        if (window.timerInterval) {
            clearInterval(window.timerInterval);
            window.timerInterval = null;
        }
        
        const finalTime = Date.now() - window.timerStartTime;
        const timeStr = formatTime(finalTime);
        
        // セッションストレージに最終結果を保存
        sessionStorage.setItem('gameTime', timeStr);
        sessionStorage.setItem('gameTimeMs', finalTime.toString());
        
        // タイマー状態をクリア（ゲーム終了）
        sessionStorage.removeItem('timerStartTime');
        sessionStorage.setItem('timerRunning', 'false');
        
        console.log('⏹️ タイマー停止:', timeStr);
        return timeStr;
    }
    return null;
};

// カードクリック処理 - タイマーリセット防止版
window.flipCard = function(form) {
    console.log('=== flipCard 呼び出し ===');
    console.log('タイマー状況 - 動作中:', window.timerRunning);
    console.log('現在の経過時間:', window.timerStartTime ? (Date.now() - window.timerStartTime) + 'ms' : '未開始');
    
    // 重要：カードクリック時はタイマーに一切触らない
    // タイマーは自動開始されており、継続して動作させる必要がある
    // タイマーの開始・停止・リセットは一切行わない
    
    // カードエフェクト
    const card = form.closest('.card');
    const button = form.querySelector('.card-btn');
    
    if (card) {
        card.classList.add('flipping');
    }
    if (button) {
        button.style.color = '#ffd700';
        button.style.transform = 'scale(1.2)';
        button.style.textShadow = '0 0 15px rgba(255,215,0,0.8)';
    }
    
    // フォーム送信
    setTimeout(function() {
        console.log('🚀 フォーム送信中...');
        form.submit();
    }, 300);
    
    return false;
};

// 初期化処理 - タイマー継続版
window.initSimpleTimer = function() {
    console.log('=== initSimpleTimer 開始 ===');
    
    // 重複実行防止
    if (window.timerInitialized) {
        console.log('⚠️ 既に初期化済み - スキップ');
        return;
    }
    
    // URLパラメータでリセット要求があるかチェック
    const urlParams = new URLSearchParams(window.location.search);
    const shouldReset = urlParams.get('resetTimer') === 'true';
    
    console.log('🔍 初期化パラメータチェック:');
    console.log('  - URL:', window.location.href);
    console.log('  - resetTimer パラメータ:', urlParams.get('resetTimer'));
    console.log('  - shouldReset:', shouldReset);
    
    if (shouldReset) {
        console.log('🔄 新ゲーム開始 - タイマーを強制リセット');
        // 強制リセット処理
        window.timerStartTime = null;
        window.timerRunning = false;
        if (window.timerInterval) {
            clearInterval(window.timerInterval);
            window.timerInterval = null;
        }
        
        // セッションストレージをクリア
        sessionStorage.removeItem('timerStartTime');
        sessionStorage.removeItem('timerRunning');
        sessionStorage.removeItem('gameTime');
        sessionStorage.removeItem('gameTimeMs');
        
        // 表示初期化
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = '00:00.0';
        }
        
        window.timerInitialized = true;
        console.log('✅ 新ゲーム：タイマー強制リセット完了');
        return;
    }
    
    // セッションストレージからタイマー状態を復元
    const savedStartTime = sessionStorage.getItem('timerStartTime');
    const savedRunning = sessionStorage.getItem('timerRunning');
    
    console.log('🔍 セッションストレージ状態チェック:');
    console.log('  - savedStartTime:', savedStartTime);
    console.log('  - savedRunning:', savedRunning);
    console.log('  - 復元条件満たす:', !!(savedStartTime && savedRunning === 'true'));
      if (savedStartTime && savedRunning === 'true') {
        // タイマーが既に動作中の場合は継続
        window.timerStartTime = parseInt(savedStartTime);
        window.timerRunning = true;
        
        console.log('🔄 タイマー状態を復元:', {
            startTime: new Date(window.timerStartTime),
            elapsed: Date.now() - window.timerStartTime + 'ms'
        });
        
        // 重要：既存のインターバルをクリアしてから新しく設定
        if (window.timerInterval) {
            clearInterval(window.timerInterval);
        }
        
        // タイマー表示を再開
        window.timerInterval = setInterval(function() {
            const elapsed = Date.now() - window.timerStartTime;
            const timeStr = formatTime(elapsed);
            
            const display = document.getElementById('timer-display');
            if (display) {
                display.textContent = timeStr;
            }
            
            // 状態をセッションストレージに継続的に保存
            sessionStorage.setItem('timerStartTime', window.timerStartTime.toString());
            sessionStorage.setItem('timerRunning', 'true');
            
            // 5秒ごとにログ出力
            if (Math.floor(elapsed / 1000) % 5 === 0 && elapsed % 1000 < 100) {
                console.log('⏰ タイマー動作中（復元）:', timeStr);
            }
        }, 100);
        
        console.log('✅ タイマー復元完了 - インターバル再設定済み');
    } else {
        // 新しいゲームの場合のみリセット
        window.timerStartTime = null;
        window.timerRunning = false;
        if (window.timerInterval) {
            clearInterval(window.timerInterval);
            window.timerInterval = null;
        }
        
        // 表示初期化
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = '00:00.0';
            console.log('✅ 新ゲーム：タイマー表示初期化完了');
        }
        
        // タイマー関連のセッションストレージをクリア（ゲーム時間は保持）
        sessionStorage.removeItem('timerStartTime');
        sessionStorage.removeItem('timerRunning');
          console.log('🆕 新ゲーム：タイマー初期化完了');
    }
    
    // 初期化完了フラグを設定
    window.timerInitialized = true;
    console.log('=== initSimpleTimer 完了 ===');
};

// ゲーム終了検出
window.detectGameEnd = function() {
    console.log('=== detectGameEnd 開始 ===');
    
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                const nextBtn = document.querySelector('.next-btn');
                if (nextBtn && window.timerRunning) {
                    console.log('🏁 ゲーム終了検出！');
                    window.stopGameTimer();
                }
            }
        });
    });
    
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
    console.log('✅ ゲーム終了検出の監視開始');
};

// デバッグ用：タイマー状態確認関数
window.checkTimerStatus = function() {
    console.log('=== タイマー状態確認 ===');
    console.log('timerRunning:', window.timerRunning);
    console.log('timerStartTime:', window.timerStartTime ? new Date(window.timerStartTime) : 'null');
    console.log('timerInitialized:', window.timerInitialized);
    console.log('現在時刻:', new Date());
    console.log('経過時間:', window.timerStartTime ? (Date.now() - window.timerStartTime) + 'ms' : '未開始');
    console.log('timerInterval:', window.timerInterval ? '動作中(ID:' + window.timerInterval + ')' : 'null');
    
    // 表示要素確認
    const display = document.getElementById('timer-display');
    console.log('timer-display要素:', display ? display.textContent : '見つかりません');
    
    // セッションストレージ確認
    console.log('sessionStorage:');
    console.log('  timerStartTime:', sessionStorage.getItem('timerStartTime'));
    console.log('  timerRunning:', sessionStorage.getItem('timerRunning'));
    console.log('  gameTime:', sessionStorage.getItem('gameTime'));
    console.log('  gameTimeMs:', sessionStorage.getItem('gameTimeMs'));
    
    // URLパラメータ確認
    const urlParams = new URLSearchParams(window.location.search);
    console.log('URLパラメータ resetTimer:', urlParams.get('resetTimer'));
    
    return {
        running: window.timerRunning,
        initialized: window.timerInitialized,
        startTime: window.timerStartTime,
        elapsed: window.timerStartTime ? Date.now() - window.timerStartTime : 0,
        intervalActive: !!window.timerInterval
    };
};

// グローバルアクセス用（ブラウザコンソールで使用可能）
window.debugTimer = window.checkTimerStatus;

// ページ離脱時にタイマー状態を確実に保存
window.addEventListener('beforeunload', function() {
    if (window.timerRunning && window.timerStartTime) {
        console.log('📤 ページ離脱 - タイマー状態を保存');
        sessionStorage.setItem('timerStartTime', window.timerStartTime.toString());
        sessionStorage.setItem('timerRunning', 'true');
        console.log('✅ タイマー状態保存完了');
    }
});

// ページ可視性変更時の処理（タブ切り替え対策）
document.addEventListener('visibilitychange', function() {
    if (document.hidden && window.timerRunning && window.timerStartTime) {
        console.log('👁️ ページ非表示 - タイマー状態を保存');
        sessionStorage.setItem('timerStartTime', window.timerStartTime.toString());
        sessionStorage.setItem('timerRunning', 'true');
    }
});

// ページ読み込み完了時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('📄 DOMContentLoaded - simple-timer.js');
    window.initSimpleTimer();
    window.detectGameEnd();
    
    // タイマーが動作していない場合のみ自動開始
    setTimeout(function() {
        if (!window.timerRunning) {
            console.log('🎯 ページ読み込み完了 - タイマー自動開始');
            window.startGameTimer();
        } else {
            console.log('🔄 ページ読み込み完了 - タイマーは既に動作中');
        }
    }, 500);
});

window.addEventListener('load', function() {
    console.log('🌐 Window Load - simple-timer.js');
    // loadイベントでは初期化を重複実行しない
    
    // 最終確認：タイマーが開始されていない場合のみ開始
    setTimeout(function() {
        if (!window.timerRunning && !window.timerInitialized) {
            console.log('🔄 フォールバック - タイマー開始');
            window.initSimpleTimer();
            window.detectGameEnd();
            window.startGameTimer();
        }
    }, 1000);
});

console.log('✅ simple-timer.js 読み込み完了');
