// ultra-simple-timer.js - 超シンプルタイマー（完全修正版）

console.log('🚀 ultra-simple-timer.js 読み込み開始');

// グローバルタイマー変数
window.gameStartTime = null;
window.gameRunning = false;
window.gameInterval = null;

// 時間フォーマット関数
function formatGameTime(ms) {
    const minutes = Math.floor(ms / 60000);
    const seconds = Math.floor((ms % 60000) / 1000);
    const deciseconds = Math.floor((ms % 1000) / 100);
    
    return minutes.toString().padStart(2, '0') + ':' + 
           seconds.toString().padStart(2, '0') + '.' + deciseconds;
}

// タイマー開始（完全版）
window.startTimer = function() {
    console.log('⏰ タイマー開始処理');
    
    if (window.gameRunning) {
        console.log('⚠️ 既に動作中 - スキップ');
        return false;
    }
    
    // セッションストレージから前回の状態を復元
    const saved = sessionStorage.getItem('gameStartTime');
    const savedRunning = sessionStorage.getItem('gameRunning');
    
    console.log('復元チェック:', { 
        saved: saved ? new Date(parseInt(saved)) : null, 
        savedRunning,
        shouldRestore: !!(saved && saved !== 'null' && savedRunning === 'true')
    });
    
    if (saved && saved !== 'null' && savedRunning === 'true') {
        // 継続プレイ：既存の開始時刻を使用
        window.gameStartTime = parseInt(saved);
        const elapsed = Date.now() - window.gameStartTime;
        console.log('🔄 タイマー復元:', {
            startTime: new Date(window.gameStartTime),
            elapsedMs: elapsed,
            formattedTime: formatGameTime(elapsed)
        });
        
        // 表示を即座に更新
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = formatGameTime(elapsed);
            console.log('⚡ 即座に表示更新:', formatGameTime(elapsed));
        }
    } else {
        // 新規開始
        window.gameStartTime = Date.now();
        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
        console.log('🆕 新規タイマー開始:', new Date(window.gameStartTime));
    }
    
    window.gameRunning = true;
    sessionStorage.setItem('gameRunning', 'true');
    
    // 表示更新インターバル
    window.gameInterval = setInterval(function() {
        const elapsed = Date.now() - window.gameStartTime;
        const timeStr = formatGameTime(elapsed);
        
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = timeStr;
        }
        
        // セッションストレージを定期更新（重要！）
        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
        sessionStorage.setItem('gameRunning', 'true');
        
        if (Math.floor(elapsed / 1000) % 5 === 0 && elapsed % 1000 < 200) {
            console.log('⏰ 経過時間:', timeStr);
        }
    }, 100);
    
    console.log('✅ タイマー開始完了');
    return true;
};

// タイマー停止
window.stopTimer = function() {
    console.log('⏹️ タイマー停止処理');
    
    if (!window.gameRunning) {
        console.log('⚠️ 既に停止中');
        return null;
    }
    
    window.gameRunning = false;
    clearInterval(window.gameInterval);
    window.gameInterval = null;
    
    const finalTime = Date.now() - window.gameStartTime;
    const timeStr = formatGameTime(finalTime);
    
    // 結果保存
    sessionStorage.setItem('gameTime', timeStr);
    sessionStorage.setItem('gameTimeMs', finalTime.toString());
    sessionStorage.removeItem('gameStartTime');
    sessionStorage.setItem('gameRunning', 'false');
    
    console.log('✅ 最終時間:', timeStr);
    return timeStr;
};

// タイマーリセット
window.resetTimer = function() {
    console.log('🔄 タイマーリセット');
    
    window.gameRunning = false;
    window.gameStartTime = null;
    
    if (window.gameInterval) {
        clearInterval(window.gameInterval);
        window.gameInterval = null;
    }
    
    const display = document.getElementById('timer-display');
    if (display) {
        display.textContent = '00:00.0';
    }
    
    // セッションストレージクリア
    sessionStorage.removeItem('gameStartTime');
    sessionStorage.removeItem('gameRunning');
    sessionStorage.removeItem('gameTime');
    sessionStorage.removeItem('gameTimeMs');
    
    console.log('✅ リセット完了');
};

// カードクリック処理（タイマーに影響しない）
window.flipCard = function(form) {
    console.log('🃏 カードクリック - タイマーに影響なし');
    
    // タイマー状態の確認的ログ
    const elapsed = window.gameStartTime ? Date.now() - window.gameStartTime : 0;
    console.log('現在の状態:', {
        running: window.gameRunning,
        elapsed: elapsed,
        formattedTime: formatGameTime(elapsed)
    });
    
    // カードエフェクト
    const card = form.closest('.card');
    if (card) {
        card.classList.add('flipping');
    }
    
    // フォーム送信前にタイマー状態を保存
    if (window.gameRunning && window.gameStartTime) {
        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
        sessionStorage.setItem('gameRunning', 'true');
        console.log('💾 カードクリック前にタイマー状態保存');
    }
    
    // フォーム送信
    setTimeout(function() {
        console.log('🚀 フォーム送信');
        form.submit();
    }, 300);
    
    return false;
};

// 次へボタンクリック時の処理（タイマー継続保証）
function handleNextButton() {
    console.log('🔄 次へボタン処理 - タイマー状態保存');
    
    if (window.gameRunning && window.gameStartTime) {
        // ページ遷移前に確実に状態を保存
        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
        sessionStorage.setItem('gameRunning', 'true');
        console.log('💾 タイマー状態を確実に保存:', {
            startTime: new Date(window.gameStartTime),
            elapsed: Date.now() - window.gameStartTime
        });
    }
}

// 次へボタンにイベントリスナーを追加
function attachNextButtonHandler() {
    setTimeout(function() {
        const nextBtn = document.querySelector('.next-btn');
        if (nextBtn && !nextBtn.hasAttribute('data-timer-handler')) {
            nextBtn.addEventListener('click', handleNextButton);
            nextBtn.setAttribute('data-timer-handler', 'true');
            console.log('📌 次へボタンにタイマー保存ハンドラーを追加');
        }
    }, 100);
}

// ゲーム終了検出（修正版 - リザルト画面でのみ停止）
function watchGameEnd() {
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                // 「次へ」ボタンの出現を検出
                const nextBtn = document.querySelector('.next-btn');
                if (nextBtn) {
                    console.log('⚠️ 次へボタン検出 - ゲーム継続中（タイマー停止しない）');
                    // 次へボタンハンドラーを追加
                    attachNextButtonHandler();
                }
                
                // 実際のゲーム終了条件：リザルト画面への遷移時のみ
                const celebrationContent = document.querySelector('.celebration-content');
                const isResultPage = window.location.href.includes('result') || 
                                   document.title.includes('ゲームクリア') ||
                                   celebrationContent !== null;
                
                if (isResultPage && window.gameRunning) {
                    console.log('🏁 ゲーム終了検出（リザルト画面）- タイマー停止');
                    const finalTime = window.stopTimer();
                    console.log('📊 最終記録:', finalTime);
                    
                    // 結果表示を即座に実行
                    setTimeout(function() {
                        if (typeof showClearTime === 'function') {
                            console.log('📋 結果表示関数を呼び出し');
                            showClearTime();
                        } else if (typeof window.forceShowTime === 'function') {
                            console.log('🔧 強制結果表示関数を呼び出し');
                            window.forceShowTime();
                        }
                    }, 100);
                }
            }
        });
    });
    
    observer.observe(document.body, { childList: true, subtree: true });
    console.log('👁️ ゲーム終了監視開始（修正版）');
    
    // ページ読み込み時にもリザルト画面チェック
    setTimeout(function() {
        const celebrationContent = document.querySelector('.celebration-content');
        const isResultPage = window.location.href.includes('result') || 
                           document.title.includes('ゲームクリア') ||
                           celebrationContent !== null;
        
        if (isResultPage && window.gameRunning) {
            console.log('🏁 初期読み込み時のゲーム終了検出');
            const finalTime = window.stopTimer();
            console.log('📊 最終記録:', finalTime);
        }
    }, 500);
}

// 初期化（改良版）
function initTimer() {
    console.log('🎯 タイマー初期化開始');
    console.log('現在のURL:', window.location.href);
    
    // URLでリセット要求チェック
    const params = new URLSearchParams(window.location.search);
    const resetRequested = params.get('resetTimer') === 'true';
    
    console.log('リセット要求:', resetRequested);
    
    if (resetRequested) {
        console.log('🔄 強制リセット要求');
        window.resetTimer();
        // リセット後は新規タイマーを開始
        setTimeout(function() {
            if (!window.gameRunning) {
                console.log('🆕 リセット後の新規タイマー開始');
                window.startTimer();
            }
        }, 500);
        return;
    }
    
    // セッションストレージから状態確認
    const savedTime = sessionStorage.getItem('gameStartTime');
    const savedRunning = sessionStorage.getItem('gameRunning');
    
    console.log('保存状態:', { 
        savedTime: savedTime ? new Date(parseInt(savedTime)) : null, 
        savedRunning: savedRunning,
        isValidSaved: !!(savedTime && savedRunning === 'true')
    });
    
    if (savedTime && savedRunning === 'true') {
        console.log('🔄 前回の状態から復元');
        window.startTimer();
    } else {
        console.log('🆕 新規ゲーム準備');
        // 新規ゲームの場合は表示のみ初期化
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = '00:00.0';
            console.log('✅ 表示初期化: 00:00.0');
        }
        
        // 自動開始
        setTimeout(function() {
            if (!window.gameRunning) {
                console.log('🎬 新規タイマー自動開始');
                window.startTimer();
            }
        }, 500);
    }
}

// デバッグ関数（改良版）
window.timerDebug = function() {
    console.log('=== タイマーデバッグ ===');
    console.log('running:', window.gameRunning);
    console.log('startTime:', window.gameStartTime ? new Date(window.gameStartTime) : null);
    console.log('elapsed:', window.gameStartTime ? Date.now() - window.gameStartTime : 0);
    console.log('formattedElapsed:', window.gameStartTime ? formatGameTime(Date.now() - window.gameStartTime) : '00:00.0');
    console.log('interval:', window.gameInterval ? 'active' : 'inactive');
    
    console.log('sessionStorage:', {
        gameStartTime: sessionStorage.getItem('gameStartTime'),
        gameRunning: sessionStorage.getItem('gameRunning'),
        gameTime: sessionStorage.getItem('gameTime')
    });
    
    const display = document.getElementById('timer-display');
    console.log('display:', display ? display.textContent : 'not found');
    
    const nextBtn = document.querySelector('.next-btn');
    console.log('nextBtn:', nextBtn ? 'present' : 'not found');
    
    return { 
        running: window.gameRunning, 
        elapsed: window.gameStartTime ? Date.now() - window.gameStartTime : 0,
        formattedTime: window.gameStartTime ? formatGameTime(Date.now() - window.gameStartTime) : '00:00.0'
    };
};

// ページ読み込み時処理（改良版）
document.addEventListener('DOMContentLoaded', function() {
    console.log('📄 DOM読み込み完了');
    initTimer();
    watchGameEnd();
    
    // 次へボタンの監視を開始
    attachNextButtonHandler();
    
    // 次へボタンの動的追加も監視
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                attachNextButtonHandler();
            }
        });
    });
    
    observer.observe(document.body, { childList: true, subtree: true });
    console.log('👁️ 次へボタンの動的追加も監視開始');
});

// ページ離脱時の保存（強化版）
window.addEventListener('beforeunload', function() {
    if (window.gameRunning && window.gameStartTime) {
        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
        sessionStorage.setItem('gameRunning', 'true');
        console.log('💾 状態保存（ページ離脱時）');
    }
});

// ページ可視性変更時の保存
document.addEventListener('visibilitychange', function() {
    if (document.hidden && window.gameRunning && window.gameStartTime) {
        sessionStorage.setItem('gameStartTime', window.gameStartTime.toString());
        sessionStorage.setItem('gameRunning', 'true');
        console.log('💾 状態保存（ページ非表示時）');
    }
});

console.log('✅ ultra-simple-timer.js 読み込み完了');
