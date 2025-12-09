-- pgAdmin用 テーブル作成SQLスクリプト
-- memory_gameデータベースのQuery Toolで実行してください

-- 既存テーブル削除（クリーンアップ）
DROP TABLE IF EXISTS user_statistics CASCADE;
DROP TABLE IF EXISTS game_records CASCADE; 
DROP TABLE IF EXISTS users CASCADE;

-- ユーザー情報テーブル
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- ゲーム記録テーブル
CREATE TABLE game_records (
    record_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    play_time_seconds INT NOT NULL,
    cards_count INT NOT NULL DEFAULT 6,
    moves_count INT NOT NULL DEFAULT 0,
    perfect_game BOOLEAN DEFAULT FALSE,
    game_difficulty VARCHAR(20) DEFAULT 'normal',
    created_at TIMESTAMP DEFAULT NOW()
);

-- ユーザー統計テーブル（集計用）
CREATE TABLE user_statistics (
    stat_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    total_games INT DEFAULT 0,
    total_wins INT DEFAULT 0,
    best_time_seconds INT,
    average_time_seconds DECIMAL(8,2),
    total_play_time_seconds BIGINT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW()
);

-- インデックス作成（パフォーマンス向上）
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_game_records_user_id ON game_records(user_id);
CREATE INDEX idx_game_records_created_at ON game_records(created_at);
CREATE INDEX idx_user_statistics_user_id ON user_statistics(user_id);

-- テーブルにコメント追加
COMMENT ON TABLE users IS 'ユーザー情報テーブル';
COMMENT ON TABLE game_records IS 'ゲームプレイ記録テーブル';
COMMENT ON TABLE user_statistics IS 'ユーザー統計情報テーブル';

COMMENT ON COLUMN users.user_id IS 'ユーザーID（主キー）';
COMMENT ON COLUMN users.username IS 'ログイン用ユーザー名（一意）';
COMMENT ON COLUMN users.password_hash IS 'ハッシュ化されたパスワード';
COMMENT ON COLUMN users.display_name IS '表示用ユーザー名';

COMMENT ON COLUMN game_records.play_time_seconds IS 'プレイ時間（秒）';
COMMENT ON COLUMN game_records.cards_count IS 'カード枚数（6枚など）';
COMMENT ON COLUMN game_records.moves_count IS '手数（カードをめくった回数）';
COMMENT ON COLUMN game_records.perfect_game IS '完璧プレイ（最少手数でクリア）';

-- サンプルユーザーデータ投入
INSERT INTO users (username, email, password_hash, display_name) VALUES
('testuser', 'test@example.com', 'b55c8792d1ce458e2793a1c7f9b7e99c7c9b4c1a2b3d4e5f6789abcdef123456', 'テストユーザー'),
('admin', 'admin@example.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '管理者');

-- サンプル統計データ投入
INSERT INTO user_statistics (user_id, total_games, total_wins, best_time_seconds) VALUES
(1, 0, 0, NULL),
(2, 0, 0, NULL);

-- 作成確認クエリ
SELECT 'テーブル作成完了' as status;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
SELECT COUNT(*) as user_count FROM users;
SELECT username, display_name FROM users;
