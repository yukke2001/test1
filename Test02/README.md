# Test02 - 神経衰弱ゲーム

## プロジェクト概要
このプロジェクトはJSP/Servletを使用した神経衰弱ゲームアプリケーションです。

## プロジェクト構成

### 既存ファイル（削除禁止）
```
Test02/
├── README.md                     # このファイル（プロジェクト説明書）
├── PROJECT_STRUCTURE.md          # 詳細なプロジェクト構成説明
├── DEVELOPMENT_GUIDE.md          # 開発ガイドライン
├── index.jsp                     # メインエントランスページ
├── game.jsp                      # 基本ゲーム画面
├── game_backup.jsp               # バックアップファイル（削除禁止）
├── game_enhanced.jsp             # 拡張機能版ゲーム画面
├── reset.jsp                     # ゲームリセット機能
├── result.jsp                    # ゲーム結果表示
├── game.css                      # 基本スタイル
├── game_6cards.css               # 6枚カード用スタイル
├── game_new.css                  # 新機能用スタイル
├── card_effects.css              # カードエフェクト用スタイル
├── random_layout.css             # ランダムレイアウト用スタイル
├── result.css                    # 結果表示用スタイル
├── start.css                     # スタート画面用スタイル
├── lib/                          # 外部ライブラリ
│   ├── javax.servlet-api-4.0.1.jar
│   └── postgresql-42.7.7.jar
└── WEB-INF/                      # Web設定
    ├── web.xml                   # Web設定ファイル
    └── classes/                  # Javaクラスファイル
```

## 開発ルール

### ⚠️ 重要：既存ファイルの保護
- 上記の既存ファイルは**絶対に削除しない**
- 既存ファイルの名前変更も禁止
- 新機能追加時は新しいファイルを作成する

### 新機能開発時のファイル命名規則
- JSPファイル: `feature_[機能名].jsp`
- CSSファイル: `[機能名].css`
- JavaScriptファイル: `[機能名].js`

### バックアップ戦略
- 重要な変更前は `_backup` サフィックスでファイルコピーを作成
- 例：`game.jsp` を変更前に `game_backup_[日付].jsp` でバックアップ

## 使用技術
- Java (Servlet/JSP)
- HTML5/CSS3
- JavaScript
- PostgreSQL（オプション）

## 最終更新
2025年12月4日
