// result-timer-fixed.js - 修正済みクリア時間表示機能

// タイマー結果表示
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
    timeDisplay.style.cssText = 'text-align: center; margin: 20px 0; color: #fff; background: rgba(0,0,0,0.3); padding: 20px; border-radius: 10px;';
    
    // 内容を直接作成
    const timeHeader = document.createElement('h2');
    timeHeader.textContent = '⏱️ クリア時間';
    timeHeader.style.cssText = 'color: #ffd700; margin: 20px 0 10px 0; font-size: 1.8em;';
    
    const timeValue = document.createElement('div');
    timeValue.textContent = displayTime;
    timeValue.style.cssText = 'font-size: 2.5em; font-weight: bold; color: #fff; margin: 15px 0; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);';
    
    const timeMessage = document.createElement('div');
    timeMessage.textContent = message;
    timeMessage.style.cssText = 'color: #ccc; margin: 10px 0; font-size: 1.2em;';
    
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
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎊 result-timer-fixed.js DOMContentLoaded');
    setTimeout(displayGameTime, 100);
});

window.addEventListener('load', function() {
    console.log('🎊 result-timer-fixed.js Window Load');
    setTimeout(displayGameTime, 200);
});

console.log('📁 result-timer-fixed.js読み込み完了');
