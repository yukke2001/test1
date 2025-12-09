// timer.js - 神経衰弱ゲーム用タイマー機能

// ゲームタイマーオブジェクト
let gameTimer = {
    startTime: null,
    isRunning: false,
    elapsedTime: 0,
    intervalId: null,
      // タイマー開始
    start: function() {
        console.log('=== gameTimer.start() ===');
        console.log('現在の状況:', this.isRunning, this.elapsedTime);
        
        if (!this.isRunning) {
            this.startTime = Date.now() - this.elapsedTime;
            this.isRunning = true;
            this.intervalId = setInterval(() => {
                this.updateDisplay();
            }, 100);
            
            console.log('✅ タイマー開始完了');
            console.log('  - startTime:', this.startTime);
            console.log('  - intervalId:', this.intervalId);
            console.log('  - isRunning:', this.isRunning);
        } else {
            console.log('⚠️ タイマーは既に開始されています');
        }
    },
    
    // タイマー停止
    stop: function() {
        if (this.isRunning) {
            this.isRunning = false;
            if (this.intervalId) {
                clearInterval(this.intervalId);
                this.intervalId = null;
            }
            const finalTime = this.elapsedTime;
            // 複数の形式で時間を保存
            sessionStorage.setItem('gameTime', this.formatTime(finalTime));
            sessionStorage.setItem('gameTimeMs', finalTime.toString());
            console.log('タイマー停止:', this.formatTime(finalTime));
            return finalTime;
        }
        return 0;
    },
      // 表示更新
    updateDisplay: function() {
        if (this.isRunning) {
            this.elapsedTime = Date.now() - this.startTime;
        }
        const display = document.getElementById('timer-display');
        if (display) {
            const formattedTime = this.formatTime(this.elapsedTime);
            display.textContent = formattedTime;
            
            // 10秒ごとにログ出力
            if (Math.floor(this.elapsedTime / 1000) % 10 === 0) {
                console.log('⏱️ タイマー更新:', formattedTime);
            }
        } else {
            console.error('❌ timer-display要素が見つかりません');
        }
    },
    
    // 時間フォーマット（MM:SS.D形式）
    formatTime: function(ms) {
        const totalSeconds = Math.floor(ms / 1000);
        const minutes = Math.floor(totalSeconds / 60);
        const seconds = totalSeconds % 60;
        const deciseconds = Math.floor((ms % 1000) / 100);
        return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${deciseconds}`;
    },
    
    // タイマーリセット
    reset: function() {
        this.stop();
        this.elapsedTime = 0;
        this.updateDisplay();
        sessionStorage.removeItem('gameTime');
        sessionStorage.removeItem('gameTimeMs');
        console.log('タイマーリセット');
    },
      // 初期化
    init: function() {
        console.log('GameTimer初期化開始');
        
        // ページ読み込み時の初期設定
        this.elapsedTime = 0;
        this.startTime = null;
        this.isRunning = false;
        
        // 既存のゲーム時間をクリア
        sessionStorage.removeItem('gameTime');
        sessionStorage.removeItem('gameTimeMs');
        
        // タイマー表示要素の確認と初期化
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = '00:00.0';
            console.log('タイマー表示初期化完了:', display);
        } else {
            console.error('タイマー表示要素が見つかりません');
            // 代替として要素を探す
            setTimeout(() => {
                const fallbackDisplay = document.getElementById('timer-display');
                if (fallbackDisplay) {
                    fallbackDisplay.textContent = '00:00.0';
                    console.log('遅延初期化でタイマー表示完了');
                }
            }, 500);
        }
        
        console.log('GameTimer初期化完了');
    }
};

// カードクリック時の処理
function flipCard(form) {
    console.log('=== flipCard called ===');
    console.log('Form:', form);
    console.log('gameTimerの状況:');
    console.log('  - isRunning:', gameTimer.isRunning);
    console.log('  - elapsedTime:', gameTimer.elapsedTime);
    console.log('  - startTime:', gameTimer.startTime);
    
    // 最初のカードクリック時にタイマーを開始
    if (!gameTimer.isRunning && gameTimer.elapsedTime === 0) {
        console.log('🟢 タイマーを開始します');
        gameTimer.start();
        
        // タイマー開始直後の状況を確認
        setTimeout(() => {
            console.log('タイマー開始後の確認:');
            console.log('  - isRunning:', gameTimer.isRunning);
            console.log('  - intervalId:', gameTimer.intervalId);
            console.log('  - startTime:', gameTimer.startTime);
        }, 100);
    } else {
        console.log('🔵 タイマーは既に動作中またはelapsedTimeが0でない');
    }
    
    const card = form.closest('.card');
    const button = form.querySelector('.card-btn');
    
    console.log('Card element:', card);
    console.log('Button element:', button);
    
    // カードフリップエフェクト開始
    if (card) {
        card.classList.add('flipping');
        console.log('✅ カードにflippingクラスを追加');
    }
    if (button) {
        button.style.color = '#ffd700';
        button.style.transform = 'scale(1.2)';
        button.style.textShadow = '0 0 15px rgba(255,215,0,0.8)';
        console.log('✅ ボタンエフェクトを適用');
    }
    
    // アニメーション完了後にフォーム送信
    setTimeout(function() {
        console.log('🚀 フォーム送信中...');
        form.submit();
    }, 300);
    
    console.log('=== flipCard完了 ===');
    return false;
}

// カードエフェクトの初期化
function initCardEffects() {
    const cards = document.querySelectorAll('.card');
    
    cards.forEach((card, index) => {
        // 初期表示アニメーション
        setTimeout(() => {
            card.style.animation = 'cardAppear 0.6s ease forwards';
            card.style.opacity = '1';
        }, index * 50);
        
        // クリック可能なカードのみにホバーエフェクトを適用
        if (!card.classList.contains('open') && !card.classList.contains('gone')) {
            card.addEventListener('mouseenter', function() {
                const btn = this.querySelector('.card-btn');
                if (btn) {
                    btn.style.filter = 'brightness(1.1)';
                }
            });
            
            card.addEventListener('mouseleave', function() {
                const btn = this.querySelector('.card-btn');
                if (btn) {
                    btn.style.filter = '';
                }
            });
        }
    });
}

// ゲーム終了の検出
function detectGameEnd() {
    console.log('=== ゲーム終了検出を開始 ===');
    
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                // 「次へ」ボタンが出現したときにゲーム終了とみなす
                const nextBtn = document.querySelector('.next-btn');
                if (nextBtn && gameTimer.isRunning) {
                    console.log('🏁 ゲーム終了検出！「次へ」ボタンが出現しました');
                    const finalTime = gameTimer.stop();
                    console.log('⏹️ タイマー停止、最終時間:', finalTime);
                }
            }
        });
    });
    
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
    console.log('✅ ゲーム終了検出の監視を開始しました');
}

// グローバルスコープでflipCard関数を利用可能にする
window.flipCard = flipCard;
window.gameTimer = gameTimer;

// ページ読み込み完了時の初期化処理
function initTimer() {
    console.log('=== initTimer開始 ===');
    initCardEffects();
    gameTimer.init();
    detectGameEnd();
    
    // 再度グローバル関数を設定
    window.flipCard = flipCard;
    window.gameTimer = gameTimer;
    
    console.log('flipCard関数の型:', typeof window.flipCard);
    console.log('gameTimer:', window.gameTimer);
    console.log('=== initTimer完了 ===');
}

// 即座にグローバル関数を設定
console.log('timer.js: グローバル関数を即座に設定');
window.flipCard = flipCard;
window.gameTimer = gameTimer;

// ページ読み込み完了時に実行
if (typeof window !== 'undefined') {
    // DOMContentLoadedとloadイベントの両方で初期化
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== DOMContentLoaded イベント ===');
        initTimer();
    });
    
    window.addEventListener('load', function() {
        console.log('=== Window Load イベント ===');
        // 確実に初期化するため再実行
        setTimeout(initTimer, 100);
    });
}

console.log('timer.js読み込み完了 - flipCard:', typeof window.flipCard);
