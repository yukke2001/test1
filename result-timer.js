// result-timer.js - クリア時間表示用JavaScript

function displayGameTime() {
    console.log('=== displayGameTime開始 ===');
    
    // sessionStorageから時間を取得
    const gameTime = sessionStorage.getItem('gameTime');
    const gameTimeMs = sessionStorage.getItem('gameTimeMs');
    
    console.log('保存されたゲーム時間:', gameTime);
    console.log('保存されたゲーム時間(ms):', gameTimeMs);
    
    // デバッグ用：sessionStorage全体を確認
    console.log('sessionStorage全体:');
    for (let i = 0; i < sessionStorage.length; i++) {
        const key = sessionStorage.key(i);
        const value = sessionStorage.getItem(key);
        console.log(`  ${key}: ${value}`);
    }
    
    let displayTime = '記録なし';
    let message = 'ゲームを完了してクリア時間を記録しましょう！';
    let timeClass = 'no-record';
    
    // タイムが記録されている場合
    if (gameTime && gameTime !== '00:00.0' && gameTime !== 'null' && gameTime !== null) {
        displayTime = gameTime;
        message = '素晴らしい記録です！';
        timeClass = 'recorded-time';
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
    timeDisplay.innerHTML = `
        <h2 style="color: #ffd700; margin: 20px 0 10px 0;">⏱️ クリア時間</h2>
        <div class="clear-time ${timeClass}" style="font-size: 2em; font-weight: bold; color: #fff; margin: 10px 0;">${displayTime}</div>
        <div class="clear-message" style="color: #ccc; margin: 10px 0;">${message}</div>
    `;
    
    // 既存のお祝いメッセージの後に挿入
    const celebrationContent = document.querySelector('.celebration-content');
    if (celebrationContent) {
        celebrationContent.appendChild(timeDisplay);
        console.log('✅ タイマー表示追加完了');
    } else {
        console.error('❌ celebration-content要素が見つかりません');
        // 代替手段としてbodyに直接追加
        document.body.appendChild(timeDisplay);
        console.log('⚠️ bodyに直接タイマー表示を追加しました');
    }
    
    console.log('=== displayGameTime完了 ===');
}

// ページ読み込み完了時に実行
document.addEventListener('DOMContentLoaded', function() {
    console.log('result-timer.js DOMContentLoaded');
    setTimeout(displayGameTime, 100);
});

window.addEventListener('load', function() {
    console.log('result-timer.js Window Load');
    setTimeout(displayGameTime, 200);
});

console.log('result-timer.js読み込み完了');
