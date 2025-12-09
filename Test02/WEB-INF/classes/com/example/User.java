/*
 * 【ユーザーエンティティクラス】
 * User.java
 * 
 * 役割：ユーザー情報を表現するデータモデル
 * 
 * 主な機能：
 * 1. ユーザー情報の格納・取得
 * 2. データベースレコードとJavaオブジェクトの橋渡し
 * 3. 入力検証機能
 * 4. セキュリティ関連機能（パスワード管理等）
 * 
 * 設計パターン：Entity/POJO パターン
 */
package com.example;

import java.sql.Timestamp;

/**
 * ユーザー情報エンティティクラス
 * 
 * データベースのusersテーブルに対応する
 * ユーザー情報を管理するためのモデルクラスです。
 */
public class User {
    
    // フィールド定義（データベーステーブルのカラムに対応）
    private int userId;              // ユーザーID（主キー）
    private String username;         // ログイン用ユーザー名
    private String email;            // メールアドレス
    private String passwordHash;     // ハッシュ化されたパスワード
    private String displayName;      // 表示用ユーザー名
    private Timestamp createdAt;     // アカウント作成日時
    private Timestamp updatedAt;     // 最終更新日時
    private Timestamp lastLogin;     // 最終ログイン日時
    private boolean isActive;        // アカウント有効フラグ
    
    // デフォルトコンストラクタ
    public User() {
        this.isActive = true;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    // ユーザー作成用コンストラクタ
    public User(String username, String email, String passwordHash, String displayName) {
        this();
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.displayName = displayName;
    }
    
    // Getter/Setter メソッド
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Timestamp getLastLogin() {
        return lastLogin;
    }
    
    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        this.isActive = active;
    }
    
    /**
     * 入力検証メソッド
     * 
     * @return boolean 入力が有効な場合はtrue
     */
    public boolean isValid() {
        return username != null && !username.trim().isEmpty() &&
               username.length() >= 3 && username.length() <= 50 &&
               passwordHash != null && !passwordHash.trim().isEmpty() &&
               (email == null || isValidEmail(email));
    }
    
    /**
     * メールアドレス形式検証
     * 
     * @param email 検証するメールアドレス
     * @return boolean 有効な形式の場合はtrue
     */
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
    
    /**
     * 表示用文字列生成
     * 
     * @return String ユーザー情報の文字列表現
     */
    @Override
    public String toString() {
        return String.format(
            "User{userId=%d, username='%s', displayName='%s', email='%s', isActive=%s, createdAt=%s}",
            userId, username, displayName, email, isActive, createdAt
        );
    }
    
    /**
     * オブジェクト比較（主にテスト用）
     * 
     * @param obj 比較対象オブジェクト
     * @return boolean 同一ユーザーの場合はtrue
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        User user = (User) obj;
        return userId == user.userId && 
               username != null && username.equals(user.username);
    }
    
    /**
     * ハッシュコード生成
     * 
     * @return int ハッシュコード
     */
    @Override
    public int hashCode() {
        int result = userId;
        result = 31 * result + (username != null ? username.hashCode() : 0);
        return result;
    }
    
    /**
     * 最終更新日時を現在時刻に更新
     */
    public void updateTimestamp() {
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * 最終ログイン日時を現在時刻に更新
     */
    public void updateLastLogin() {
        this.lastLogin = new Timestamp(System.currentTimeMillis());
    }
}
