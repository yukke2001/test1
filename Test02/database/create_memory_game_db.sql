-- PostgreSQL用 memory_game データベース作成スクリプト
-- 実行方法: psql -U postgres -f create_memory_game_db.sql

-- memory_game データベースを作成
CREATE DATABASE memory_game WITH ENCODING 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' TEMPLATE = template0;

-- 作成確認用
\l
