// game-timer-fixed.js - 修正済みタイマー機能

// ゲームタイマーオブジェクト
let gameTimer = {
    startTime: null,
    isRunning: false,
    elapsedTime: 0,
    intervalId: null,
    
    start: function() {
        console.log('=== gameTimer.start() ===');
        if (!this.isRunning) {
            this.startTime = Date.now() - this.elapsedTime;
            this.isRunning = true;
            this.intervalId = setInterval(() => {
                this.updateDisplay();
            }, 100);
            console.log('✅ タイマー開始完了');
        }
    },
    
    stop: function() {
        if (this.isRunning) {
            this.isRunning = false;
            if (this.intervalId) {
                clearInterval(this.intervalId);
                this.intervalId = null;
            }
            const finalTime = this.elapsedTime;
            sessionStorage.setItem('gameTime', this.formatTime(finalTime));
            sessionStorage.setItem('gameTimeMs', finalTime.toString());
            console.log('⏹️ タイマー停止:', this.formatTime(finalTime));
            return finalTime;
        }
        return 0;
    },
    
    updateDisplay: function() {
        if (this.isRunning) {
            this.elapsedTime = Date.now() - this.startTime;
        }
        const display = document.getElementById('timer-display');
        if (display) {
            const formattedTime = this.formatTime(this.elapsedTime);
            display.textContent = formattedTime;
            // デバッグ用：5秒ごとにログ出力
            if (this.isRunning && Math.floor(this.elapsedTime / 1000) % 5 === 0 && this.elapsedTime % 1000 < 200) {
                console.log('⏰ タイマー動作中:', formattedTime);
            }
        } else {
            console.error('❌ timer-display要素が見つかりません');
        }
    },
    
    formatTime: function(ms) {
        const totalSeconds = Math.floor(ms / 1000);
        const minutes = Math.floor(totalSeconds / 60);
        const seconds = totalSeconds % 60;
        const deciseconds = Math.floor((ms % 1000) / 100);
        return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${deciseconds}`;
    },
    
    reset: function() {
        this.stop();
        this.elapsedTime = 0;
        this.updateDisplay();
        sessionStorage.removeItem('gameTime');
        sessionStorage.removeItem('gameTimeMs');
    },
    
    init: function() {
        console.log('📝 GameTimer初期化開始');
        this.elapsedTime = 0;
        this.startTime = null;
        this.isRunning = false;
        sessionStorage.removeItem('gameTime');
        sessionStorage.removeItem('gameTimeMs');
        
        const display = document.getElementById('timer-display');
        if (display) {
            display.textContent = '00:00.0';
            console.log('✅ タイマー表示初期化完了');
        } else {
            console.error('❌ timer-display要素が見つかりません');
        }
    }
};

// カードクリック時の処理
function flipCard(form) {
    console.log('=== flipCard called ===');
    console.log('gameTimer.isRunning:', gameTimer.isRunning);
    console.log('gameTimer.elapsedTime:', gameTimer.elapsedTime);
    
    // 最初のカードクリック時にタイマーを開始
    if (!gameTimer.isRunning && gameTimer.elapsedTime === 0) {
        console.log('🟢 タイマーを開始します');
        gameTimer.start();
        
        // タイマー開始直後の確認
        setTimeout(() => {
            console.log('タイマー開始後の状況:');
            console.log('  - isRunning:', gameTimer.isRunning);
            console.log('  - intervalId:', gameTimer.intervalId);
            console.log('  - startTime:', gameTimer.startTime);
            console.log('  - 現在の表示:', document.getElementById('timer-display').textContent);
        }, 200);
    } else {
        console.log('🔵 タイマーは既に動作中またはelapsedTimeが0でない');
    }
    
    const card = form.closest('.card');
    const button = form.querySelector('.card-btn');
    
    if (card) card.classList.add('flipping');
    if (button) {
        button.style.color = '#ffd700';
        button.style.transform = 'scale(1.2)';
        button.style.textShadow = '0 0 15px rgba(255,215,0,0.8)';
    }
    
    setTimeout(function() {
        console.log('🚀 フォーム送信中...');
        form.submit();
    }, 300);
    
    return false;
}

// ゲーム終了検出
function detectGameEnd() {
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                const nextBtn = document.querySelector('.next-btn');
                if (nextBtn && gameTimer.isRunning) {
                    console.log('🏁 ゲーム終了検出！');
                    const finalTime = gameTimer.stop();
                    console.log('⏹️ 最終時間:', finalTime);
                }
            }
        });
    });
    
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
}

// グローバルに関数を設定
window.flipCard = flipCard;
window.gameTimer = gameTimer;

// ページ読み込み完了時の初期化
window.addEventListener('load', function() {
    console.log('🌟 ページ読み込み完了 - game-timer-fixed.js');
    gameTimer.init();
    detectGameEnd();
    
    // グローバルに関数を設定
    window.flipCard = flipCard;
    window.gameTimer = gameTimer;
    
    console.log('💡 flipCard関数の型:', typeof window.flipCard);
});

console.log('📁 game-timer-fixed.js読み込み完了');
