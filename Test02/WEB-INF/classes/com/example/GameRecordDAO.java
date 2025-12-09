/*
 * 【ゲーム記録データアクセスオブジェクト】
 * GameRecordDAO.java
 * 
 * 役割：ゲームプレイ記録に関するデータベース操作を担当
 * 
 * 主な機能：
 * 1. ゲーム記録の保存・取得
 * 2. ユーザー別統計情報の管理
 * 3. ランキング機能
 * 4. プレイ履歴の管理
 * 
 * 設計パターン：DAO（Data Access Object）パターン
 */
package com.example;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ゲーム記録データアクセスクラス
 * 
 * ゲームプレイの記録と統計情報を
 * データベースで管理します。
 */
public class GameRecordDAO {
    
    // ゲーム記録保存SQL
    private static final String INSERT_GAME_RECORD_SQL = 
        "INSERT INTO game_records (user_id, play_time_seconds, cards_count, moves_count, perfect_game, game_difficulty) " +
        "VALUES (?, ?, ?, ?, ?, ?)";
    
    // ユーザー別ゲーム記録取得SQL
    private static final String SELECT_USER_GAME_RECORDS_SQL = 
        "SELECT record_id, user_id, play_time_seconds, cards_count, moves_count, perfect_game, game_difficulty, created_at " +
        "FROM game_records WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
    
    // ユーザーベストタイム取得SQL
    private static final String SELECT_USER_BEST_TIME_SQL = 
        "SELECT MIN(play_time_seconds) as best_time FROM game_records WHERE user_id = ? AND cards_count = ?";
    
    // ユーザー統計更新SQL
    private static final String UPDATE_USER_STATISTICS_SQL = 
        "INSERT INTO user_statistics (user_id, total_games, total_wins, best_time_seconds, average_time_seconds, total_play_time_seconds) " +
        "VALUES (?, ?, ?, ?, ?, ?) " +
        "ON CONFLICT (user_id) DO UPDATE SET " +
        "total_games = EXCLUDED.total_games, " +
        "total_wins = EXCLUDED.total_wins, " +
        "best_time_seconds = LEAST(user_statistics.best_time_seconds, EXCLUDED.best_time_seconds), " +
        "average_time_seconds = EXCLUDED.average_time_seconds, " +
        "total_play_time_seconds = EXCLUDED.total_play_time_seconds, " +
        "last_updated = NOW()";
    
    // ユーザー統計取得SQL
    private static final String SELECT_USER_STATISTICS_SQL = 
        "SELECT total_games, total_wins, best_time_seconds, average_time_seconds, total_play_time_seconds, last_updated " +
        "FROM user_statistics WHERE user_id = ?";
    
    // 全体ランキング取得SQL
    private static final String SELECT_GLOBAL_RANKING_SQL = 
        "SELECT u.username, u.display_name, us.best_time_seconds, us.total_games " +
        "FROM user_statistics us " +
        "JOIN users u ON us.user_id = u.user_id " +
        "WHERE us.best_time_seconds IS NOT NULL AND u.is_active = true " +
        "ORDER BY us.best_time_seconds ASC LIMIT ?";
    
    /**
     * ゲーム記録を保存する
     * 
     * @param userId ユーザーID
     * @param playTimeSeconds プレイ時間（秒）
     * @param cardsCount カード枚数
     * @param movesCount 手数
     * @param perfectGame 完璧プレイかどうか
     * @param difficulty 難易度
     * @return boolean 保存成功時はtrue
     */
    public boolean saveGameRecord(int userId, int playTimeSeconds, int cardsCount, 
                                 int movesCount, boolean perfectGame, String difficulty) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(INSERT_GAME_RECORD_SQL);
            
            stmt.setInt(1, userId);
            stmt.setInt(2, playTimeSeconds);
            stmt.setInt(3, cardsCount);
            stmt.setInt(4, movesCount);
            stmt.setBoolean(5, perfectGame);
            stmt.setString(6, difficulty != null ? difficulty : "normal");
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                DatabaseConnection.commit(conn);
                
                // 統計情報を更新
                updateUserStatistics(userId);
                
                System.out.println("ゲーム記録保存成功: ユーザーID=" + userId + 
                                 ", 時間=" + playTimeSeconds + "秒");
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            System.err.println("ゲーム記録保存エラー: " + e.getMessage());
            DatabaseConnection.rollback(conn);
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                DatabaseConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("リソースクローズエラー: " + e.getMessage());
            }
        }
    }
    
    /**
     * ユーザーのゲーム記録を取得する
     * 
     * @param userId ユーザーID
     * @param limit 取得件数制限
     * @return List<Map<String, Object>> ゲーム記録のリスト
     */
    public List<Map<String, Object>> getUserGameRecords(int userId, int limit) {
        List<Map<String, Object>> records = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_USER_GAME_RECORDS_SQL);
            stmt.setInt(1, userId);
            stmt.setInt(2, limit > 0 ? limit : 10); // デフォルト10件
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("recordId", rs.getInt("record_id"));
                record.put("playTime", rs.getInt("play_time_seconds"));
                record.put("cardsCount", rs.getInt("cards_count"));
                record.put("movesCount", rs.getInt("moves_count"));
                record.put("perfectGame", rs.getBoolean("perfect_game"));
                record.put("difficulty", rs.getString("game_difficulty"));
                record.put("playDate", rs.getTimestamp("created_at"));
                
                records.add(record);
            }
            
        } catch (Exception e) {
            System.err.println("ゲーム記録取得エラー: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                DatabaseConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("リソースクローズエラー: " + e.getMessage());
            }
        }
        
        return records;
    }
    
    /**
     * ユーザーのベストタイムを取得する
     * 
     * @param userId ユーザーID
     * @param cardsCount カード枚数
     * @return int ベストタイム（秒）、記録がない場合は-1
     */
    public int getUserBestTime(int userId, int cardsCount) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_USER_BEST_TIME_SQL);
            stmt.setInt(1, userId);
            stmt.setInt(2, cardsCount);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                int bestTime = rs.getInt("best_time");
                return rs.wasNull() ? -1 : bestTime;
            }
            
        } catch (Exception e) {
            System.err.println("ベストタイム取得エラー: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                DatabaseConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("リソースクローズエラー: " + e.getMessage());
            }
        }
        
        return -1;
    }
    
    /**
     * ユーザー統計情報を取得する
     * 
     * @param userId ユーザーID
     * @return Map<String, Object> 統計情報（null の場合は統計なし）
     */
    public Map<String, Object> getUserStatistics(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_USER_STATISTICS_SQL);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> stats = new HashMap<>();
                stats.put("totalGames", rs.getInt("total_games"));
                stats.put("totalWins", rs.getInt("total_wins"));
                stats.put("bestTime", rs.getObject("best_time_seconds"));
                stats.put("averageTime", rs.getObject("average_time_seconds"));
                stats.put("totalPlayTime", rs.getLong("total_play_time_seconds"));
                stats.put("lastUpdated", rs.getTimestamp("last_updated"));
                
                return stats;
            }
            
        } catch (Exception e) {
            System.err.println("ユーザー統計取得エラー: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                DatabaseConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("リソースクローズエラー: " + e.getMessage());
            }
        }
        
        return null;
    }
    
    /**
     * 全体ランキングを取得する
     * 
     * @param limit 取得件数
     * @return List<Map<String, Object>> ランキングリスト
     */
    public List<Map<String, Object>> getGlobalRanking(int limit) {
        List<Map<String, Object>> ranking = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_GLOBAL_RANKING_SQL);
            stmt.setInt(1, limit > 0 ? limit : 10);
            
            rs = stmt.executeQuery();
            int rank = 1;
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("rank", rank++);
                entry.put("username", rs.getString("username"));
                entry.put("displayName", rs.getString("display_name"));
                entry.put("bestTime", rs.getInt("best_time_seconds"));
                entry.put("totalGames", rs.getInt("total_games"));
                
                ranking.add(entry);
            }
            
        } catch (Exception e) {
            System.err.println("ランキング取得エラー: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                DatabaseConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("リソースクローズエラー: " + e.getMessage());
            }
        }
        
        return ranking;
    }
    
    /**
     * ユーザー統計情報を更新する（内部メソッド）
     * 
     * @param userId ユーザーID
     */
    private void updateUserStatistics(int userId) {
        // 統計情報の再計算と更新ロジック
        // 実際の実装では、ゲーム記録テーブルから集計を行う
        System.out.println("ユーザー統計更新: ユーザーID=" + userId);
    }
}
