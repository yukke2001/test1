-- Test02 神経衰弱ゲーム - サンプルデータ挿入スクリプト
-- PostgreSQL用テストデータSQL
-- 作成日: 2025年12月9日

-- サンプルユーザー挿入
-- パスワード: "password123" のハッシュ値（BCrypt）
-- 実際の運用では適切にハッシュ化されたパスワードを使用

INSERT INTO users (username, email, password_hash, display_name) VALUES
('testuser1', 'test1@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'テストユーザー1'),
('player2', 'player2@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'プレイヤー2'),
('gamemaster', 'gm@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ゲームマスター');

-- サンプルゲーム記録挿入
INSERT INTO game_records (user_id, play_time_seconds, cards_count, moves_count, perfect_game) VALUES
(1, 45, 6, 8, true),   -- testuser1: 45秒, 6枚, 8手, 完璧プレイ
(1, 67, 6, 12, false), -- testuser1: 67秒, 6枚, 12手
(1, 38, 6, 6, true),   -- testuser1: 38秒, 6枚, 6手, 完璧プレイ（最少手数）
(2, 89, 6, 15, false), -- player2: 89秒, 6枚, 15手
(2, 72, 6, 10, false), -- player2: 72秒, 6枚, 10手
(3, 34, 6, 6, true);   -- gamemaster: 34秒, 6枚, 6手, 完璧プレイ

-- ユーザー統計の初期化
INSERT INTO user_statistics (user_id, total_games, total_wins, best_time_seconds, average_time_seconds, total_play_time_seconds) VALUES
(1, 3, 3, 38, 50.00, 150),  -- testuser1の統計
(2, 2, 2, 72, 80.50, 161),  -- player2の統計  
(3, 1, 1, 34, 34.00, 34);   -- gamemasterの統計

-- 確認用クエリ（コメントアウト済み）
/*
-- ユーザー一覧確認
SELECT user_id, username, display_name, created_at FROM users ORDER BY user_id;

-- ゲーム記録確認
SELECT 
    gr.record_id,
    u.username,
    gr.play_time_seconds,
    gr.moves_count,
    gr.perfect_game,
    gr.created_at
FROM game_records gr
JOIN users u ON gr.user_id = u.user_id
ORDER BY gr.created_at DESC;

-- ユーザー統計確認
SELECT 
    us.stat_id,
    u.username,
    us.total_games,
    us.best_time_seconds,
    us.average_time_seconds
FROM user_statistics us
JOIN users u ON us.user_id = u.user_id
ORDER BY us.best_time_seconds ASC;
*/
