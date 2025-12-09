// ultra-simple-result.js - 超シンプル結果表示（デバッグ強化版）

console.log('🎊 ultra-simple-result.js 読み込み開始');

// クリア時間表示（デバッグ強化版）
function showClearTime() {
    console.log('🏆 クリア時間表示開始');
    
    // セッションストレージの全体をログ出力
    console.log('=== セッションストレージ全体確認 ===');
    for (let i = 0; i < sessionStorage.length; i++) {
        const key = sessionStorage.key(i);
        const value = sessionStorage.getItem(key);
        console.log(`  ${key}: ${value}`);
    }
    
    const gameTime = sessionStorage.getItem('gameTime');
    const gameTimeMs = sessionStorage.getItem('gameTimeMs');
    
    console.log('取得時間:', { gameTime, gameTimeMs });
    console.log('gameTime詳細:', {
        value: gameTime,
        type: typeof gameTime,
        isNull: gameTime === null,
        isString: gameTime === 'null',
        isEmpty: gameTime === '',
        isZero: gameTime === '00:00.0'
    });
    
    let displayTime = '記録なし';
    let message = 'ゲームを完了してクリア時間を記録しましょう！';
    
    if (gameTime && gameTime !== '00:00.0' && gameTime !== 'null' && gameTime !== null && gameTime !== '') {
        displayTime = gameTime;
        message = '素晴らしい記録です！🎉';
        console.log('✅ 有効な時間:', displayTime);
    } else {
        console.log('❌ 無効な時間または記録なし');
        console.log('判定詳細:', {
            hasGameTime: !!gameTime,
            notZero: gameTime !== '00:00.0',
            notStringNull: gameTime !== 'null',
            notNull: gameTime !== null,
            notEmpty: gameTime !== ''
        });
    }
    
    // 既存表示削除
    const existing = document.querySelector('.clear-time-display');
    if (existing) {
        existing.remove();
        console.log('🗑️ 既存表示を削除');
    }
      // 新しい表示作成
    console.log('🎨 クリア時間表示エリアを作成');
    const container = document.createElement('div');
    container.className = 'clear-time-display';
    container.style.cssText = `
        text-align: center;
        margin: 30px auto;
        padding: 20px;
        background: rgba(0, 0, 0, 0.4);
        border-radius: 15px;
        max-width: 400px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        color: white;
    `;
    
    container.innerHTML = `
        <h2 style="color: #ffd700; margin: 0 0 15px 0; font-size: 2em; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">
            ⏱️ クリア時間
        </h2>
        <div style="font-size: 3em; font-weight: bold; color: #ffffff; margin: 20px 0; text-shadow: 2px 2px 4px rgba(0,0,0,0.7);">
            ${displayTime}
        </div>
        <div style="color: #cccccc; font-size: 1.3em; margin: 15px 0;">
            ${message}
        </div>
    `;
    
    console.log('📝 作成した表示内容:', displayTime);
    
    // 挿入先を探す
    const celebration = document.querySelector('.celebration-content');
    console.log('🎯 挿入先要素:', celebration ? 'found' : 'not found');
    
    if (celebration) {
        celebration.appendChild(container);
        console.log('✅ celebration-contentに表示追加完了');
    } else {
        console.log('⚠️ celebration-contentが見つからないため、bodyに直接追加');
        document.body.appendChild(container);
        console.log('✅ bodyに表示追加完了');
    }
    
    // 追加後の確認
    const addedElement = document.querySelector('.clear-time-display');
    console.log('🔍 追加確認:', addedElement ? 'success' : 'failed');
    if (addedElement) {
        console.log('📍 追加された要素の位置:', addedElement.getBoundingClientRect());
    }
}

// デバッグ用：DOM要素確認
function debugDOM() {
    console.log('=== DOM要素確認 ===');
    console.log('body:', document.body ? 'found' : 'not found');
    console.log('celebration-content:', document.querySelector('.celebration-content') ? 'found' : 'not found');
    console.log('clear-time-display:', document.querySelector('.clear-time-display') ? 'found' : 'not found');
    console.log('document.readyState:', document.readyState);
}

// 時間フォーマット関数（ローカルコピー）
function formatGameTime(ms) {
    const minutes = Math.floor(ms / 60000);
    const seconds = Math.floor((ms % 60000) / 1000);
    const deciseconds = Math.floor((ms % 1000) / 100);
    
    return minutes.toString().padStart(2, '0') + ':' + 
           seconds.toString().padStart(2, '0') + '.' + deciseconds;
}

// ゲームクリア時のタイマー停止処理
function stopGameTimer() {
    console.log('🛑 ゲームクリア時のタイマー停止処理開始');
    
    // セッションストレージから現在の状態を確認
    const startTime = sessionStorage.getItem('gameStartTime');
    const isRunning = sessionStorage.getItem('gameRunning') === 'true';
    
    console.log('タイマー状態確認:', { startTime, isRunning });
    
    if (isRunning && startTime) {
        console.log('⏰ アクティブなタイマーを検出 - 停止処理実行');
        
        const finalTime = Date.now() - parseInt(startTime);
        const timeStr = formatGameTime(finalTime);
        
        // 最終時間をセッションストレージに保存
        sessionStorage.setItem('gameTime', timeStr);
        sessionStorage.setItem('gameTimeMs', finalTime.toString());
        sessionStorage.setItem('gameRunning', 'false');
        
        console.log('✅ タイマー停止完了 - 最終時間:', timeStr);
        console.log('📊 保存されたデータ:', {
            gameTime: timeStr,
            gameTimeMs: finalTime.toString(),
            gameRunning: 'false'
        });
        
        return timeStr;
    } else {
        console.log('⚠️ アクティブなタイマーなし');
        return null;
    }
}

// ページ読み込み時実行（デバッグ強化版）
document.addEventListener('DOMContentLoaded', function() {
    console.log('📄 result DOM読み込み完了');
    
    // まずタイマー停止処理
    stopGameTimer();
    
    debugDOM();
    
    setTimeout(function() {
        console.log('⏰ DOMContentLoaded後のタイマー表示実行');
        showClearTime();
    }, 100);
});

window.addEventListener('load', function() {
    console.log('🌐 result 完全読み込み');
    debugDOM();
    
    setTimeout(function() {
        console.log('⏰ load後のタイマー表示実行');
        showClearTime();
    }, 200);
});

// 強制実行用デバッグ関数
window.forceShowTime = function() {
    console.log('🔧 強制実行: クリア時間表示');
    showClearTime();
};

console.log('✅ ultra-simple-result.js 読み込み完了');
