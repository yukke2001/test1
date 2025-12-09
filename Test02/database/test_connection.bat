@echo off
echo PostgreSQL接続テスト開始...

REM PostgreSQL接続テスト
echo Testing PostgreSQL connection...
psql -U postgres -d memory_game -c "SELECT 'Connection Success' as status;"

REM エラー処理
if %ERRORLEVEL% NEQ 0 (
    echo PostgreSQL接続に失敗しました。
    echo 可能な原因:
    echo 1. パスワードが間違っている
    echo 2. memory_gameデータベースが存在しない
    echo 3. PostgreSQLサービスが停止している
    pause
    exit /b 1
)

echo PostgreSQL接続テスト完了
pause
