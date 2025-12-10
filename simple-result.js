// simple-result.js - シンプルなクリア時間表示

console.log('simple-result.js 読み込み開始');

// クリア時間表示関数
window.showClearTime = function() {
    console.log('=== showClearTime 開始 ===');
    
    // sessionStorageから時間を取得
    const gameTime = sessionStorage.getItem('gameTime');
    const gameTimeMs = sessionStorage.getItem('gameTimeMs');
    
    console.log('保存されたゲーム時間:', gameTime);
    console.log('保存されたゲーム時間(ms):', gameTimeMs);
    
    // sessionStorage全体をログ出力
    console.log('sessionStorage全体:');
    for (let i = 0; i < sessionStorage.length; i++) {
        const key = sessionStorage.key(i);
        const value = sessionStorage.getItem(key);
        console.log(`  ${key}: ${value}`);
    }
    
    let displayTime = '記録なし';
    let message = 'ゲームを完了してクリア時間を記録しましょう！';
    
    // 有効な時間が記録されている場合
    if (gameTime && gameTime !== '00:00.0' && gameTime !== 'null' && gameTime !== null && gameTime !== '') {
        displayTime = gameTime;
        message = '素晴らしい記録です！🎉';
        console.log('✅ 有効なゲーム時間が見つかりました:', displayTime);
    } else {
        console.log('❌ 記録なしまたは無効な時間です');
    }
    
    // 既存の表示を削除
    const existing = document.querySelector('.clear-time-display');
    if (existing) {
        existing.remove();
    }
    
    // 新しい表示を作成
    const container = document.createElement('div');
    container.className = 'clear-time-display';
    container.style.cssText = `
        text-align: center;
        margin: 30px auto;
        padding: 25px;
        background: rgba(0, 0, 0, 0.4);
        border-radius: 15px;
        max-width: 400px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
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
    
    // 挿入位置を探す
    const celebration = document.querySelector('.celebration-content');
    if (celebration) {
        celebration.appendChild(container);
        console.log('✅ celebration-contentに追加しました');
    } else {
        // 代替: bodyに直接追加
        document.body.appendChild(container);
        console.log('⚠️ bodyに直接追加しました');
    }
    
    console.log('=== showClearTime 完了 ===');
};

// ページ読み込み時に実行
document.addEventListener('DOMContentLoaded', function() {
    console.log('📄 simple-result.js DOMContentLoaded');
    setTimeout(window.showClearTime, 100);
});

window.addEventListener('load', function() {
    console.log('🌐 simple-result.js Window Load');
    setTimeout(window.showClearTime, 200);
});

console.log('✅ simple-result.js 読み込み完了');
