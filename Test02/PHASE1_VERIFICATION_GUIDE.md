# Phase 1 動作確認手順書
# Test02 神経衰弱ゲーム - PostgreSQL連携基盤構築

## 1. PostgreSQLデータベース準備

### 1-1. PostgreSQLサーバー起動確認
```powershell
# PostgreSQLサービス確認
Get-Service postgresql*

# サービス開始（必要に応じて）
Start-Service postgresql-x64-14  # バージョンに応じて調整
```

### 1-2. データベース作成
```powershell
# PostgreSQL管理者でログイン
psql -U postgres

# データベース作成
CREATE DATABASE memory_game WITH ENCODING 'UTF8';

# 作成確認
\l

# データベース接続
\c memory_game
```

### 1-3. テーブル作成
```sql
-- create_tables.sqlを実行
\i C:/Tomcat9/webapps/Test02/database/create_tables.sql

-- テーブル作成確認
\dt

-- テーブル構造確認
\d users
\d game_records
\d user_statistics
```

### 1-4. サンプルデータ挿入（オプション）
```sql
-- sample_data.sqlを実行
\i C:/Tomcat9/webapps/Test02/database/sample_data.sql

-- データ確認
SELECT * FROM users;
SELECT * FROM game_records;
SELECT * FROM user_statistics;
```

## 2. Javaクラスコンパイル

### 2-1. コンパイル実行
```powershell
# Test02ディレクトリに移動
cd C:\Tomcat9\webapps\Test02

# Javaクラスファイルをコンパイル
javac -cp "lib/*;WEB-INF/classes" WEB-INF/classes/com/example/*.java
```

### 2-2. コンパイル確認
```powershell
# .classファイル生成確認
dir WEB-INF\classes\com\example\*.class
```

## 3. Tomcat再起動とテスト

### 3-1. Tomcat再起動
```powershell
# Tomcatサービス再起動
Restart-Service Tomcat9

# または手動再起動
# C:\Tomcat9\bin\shutdown.bat
# C:\Tomcat9\bin\startup.bat
```

### 3-2. 動作確認テスト
```
ブラウザでアクセス:
http://localhost:8080/Test02/database_test_phase1.jsp
```

## 4. 確認項目チェックリスト

### ✅ Phase 1 成功条件
- [ ] PostgreSQLデータベース接続成功
- [ ] Userクラス正常動作
- [ ] UserDAOクラス正常動作  
- [ ] JDBCドライバー読み込み成功
- [ ] 総合結果が「Phase 1 基盤構築完了」表示

### ⚠️ トラブルシューティング

**データベース接続失敗の場合:**
1. PostgreSQLサービス起動確認
2. database/create_tables.sql実行確認
3. データベース名・ユーザー名・パスワード確認

**JDBCドライバーエラーの場合:**
1. lib/postgresql-42.7.7.jar 存在確認
2. Tomcat再起動
3. コンパイルパス確認

**コンパイルエラーの場合:**
1. JAVA_HOME環境変数確認
2. クラスパス設定確認
3. 構文エラー確認

## 5. Phase 2 進行条件

✅ **Phase 1 完了条件:**
- database_test_phase1.jsp で全テストが成功
- 「Phase 1 基盤構築完了」メッセージ表示
- エラーメッセージなし

→ **Phase 2（認証システム実装）に進行可能**

## 補足情報

### データベース設定変更が必要な場合
`WEB-INF/classes/com/example/DatabaseConnection.java` の以下の設定を環境に合わせて変更：

```java
private static final String DB_URL = "jdbc:postgresql://localhost:5432/memory_game";
private static final String DB_USERNAME = "postgres";  // 変更箇所
private static final String DB_PASSWORD = "password";   // 変更箇所
```

変更後は再コンパイルとTomcat再起動が必要です。
