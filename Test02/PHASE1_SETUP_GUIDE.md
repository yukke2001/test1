# Phase 1 事前準備ガイド

## 🎯 Phase 1 動作確認に必要な事前準備

### **Option A: 最小限の確認（データベースなし）**
**推奨**: まずはこちらで基盤クラスの動作確認

#### 必要な準備
1. **Tomcatサーバーの起動**
   ```powershell
   # Tomcatが起動していることを確認
   # 通常は既に起動済みのはず
   ```

2. **Javaクラスのコンパイル**
   ```powershell
   # Test02ディレクトリで実行
   cd c:\Tomcat9\webapps\Test02\WEB-INF\classes
   javac -cp "../../lib/*" com/example/*.java
   ```

3. **テストページアクセス**
   ```
   http://localhost:8080/Test02/database_test_phase1.jsp
   ```

#### 確認内容
- ✅ Javaクラスの読み込み成功
- ✅ PostgreSQL JDBCドライバーの存在確認
- ⚠️ データベース接続は失敗（正常な状態）

---

### **Option B: 完全な確認（データベースあり）**
**本格運用時**: 実際のDB連携を確認したい場合

#### 1. PostgreSQLのインストール
```powershell
# Chocolatey経由でインストール（推奨）
choco install postgresql

# または公式サイトからダウンロード
# https://www.postgresql.org/download/windows/
```

#### 2. データベースの作成
```powershell
# PostgreSQLに接続
psql -U postgres

# データベース作成
CREATE DATABASE memory_game WITH ENCODING 'UTF8';

# 作成したDBに接続
\c memory_game

# テーブル作成スクリプト実行
\i c:/Tomcat9/webapps/Test02/database/create_tables.sql

# サンプルデータ挿入
\i c:/Tomcat9/webapps/Test02/database/sample_data.sql

# 確認
\dt
```

#### 3. データベース接続設定の確認
```java
// DatabaseConnection.javaで設定されている接続情報
// URL: jdbc:postgresql://localhost:5432/memory_game
// ユーザー: postgres
// パスワード: (環境に応じて設定)
```

---

## 🚀 推奨開始方法

### **ステップ1: 最小限確認から開始**
```powershell
# 1. Javaクラスのコンパイル
cd c:\Tomcat9\webapps\Test02\WEB-INF\classes
javac -cp "../../lib/*" com/example/*.java

# 2. ブラウザでアクセス
# http://localhost:8080/Test02/database_test_phase1.jsp
```

### **期待される結果**
- ✅ **Javaクラス**: 正常読み込み
- ✅ **JDBCドライバー**: 存在確認
- ⚠️ **DB接続**: 失敗（PostgreSQLが未インストールの場合）
- ✅ **基盤構築**: 完了

### **成功判定**
以下のいずれかが表示されれば **Phase 1 成功**:
1. 「🎉 Phase 1 基盤構築完了！」（DB接続成功時）
2. 「⚠️ Phase 1 基盤構築は完了。DB接続のみ保留」（DB未設定時）

---

## 🔧 トラブルシューティング

### **よくあるエラーと対処法**

#### 1. Javaコンパイルエラー
```powershell
# クラスパスを明示的に指定
javac -cp "../../lib/postgresql-42.7.7.jar;../../lib/javax.servlet-api-4.0.1.jar" com/example/*.java
```

#### 2. JDBCドライバーが見つからない
```powershell
# ライブラリファイルの存在確認
ls c:\Tomcat9\webapps\Test02\lib\
```

#### 3. データベース接続エラー
- PostgreSQLサービスの起動確認
- データベース名、ユーザー名、パスワードの確認
- ファイアウォール設定の確認

---

## 📋 次のフェーズへの準備

Phase 1 が成功したら、以下をお知らせください：
1. テストページの表示結果
2. エラーメッセージの有無
3. データベース使用の希望（あり/なし）

**Phase 2**: 認証機能実装に進みます。
