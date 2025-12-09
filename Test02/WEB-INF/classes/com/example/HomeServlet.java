/*
 * 【ホーム画面サーブレット】
 * HomeServlet.java
 * 
 * 役割：ホーム画面の統計情報とランキングデータを提供
 * 
 * 主な機能：
 * 1. ユーザー統計情報の取得と表示
 * 2. 全体ランキングの取得と表示
 * 3. 認証状態の管理
 * 
 * Phase 3 - Step 3: ランキングと統計表示の実装
 */
package com.example;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * ホーム画面データ処理サーブレット
 */
public class HomeServlet extends HttpServlet {
    
    private GameRecordDAO gameRecordDAO;
    
    @Override
    public void init() throws ServletException {
        gameRecordDAO = new GameRecordDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 全体ランキング取得（TOP 5）
        List<Map<String, Object>> globalRanking = gameRecordDAO.getGlobalRanking(5);
        request.setAttribute("globalRanking", globalRanking);
        
        // 認証されたユーザーの場合、個人統計を取得
        @SuppressWarnings("unchecked")
        Map<String, Object> currentUser = (Map<String, Object>) session.getAttribute("currentUser");
        Boolean isAuthenticated = (Boolean) session.getAttribute("isAuthenticated");
        
        if (isAuthenticated != null && isAuthenticated && currentUser != null) {
            Object userIdObj = currentUser.get("userId");
            Integer userId = null;
            
            // ユーザーIDの型変換
            if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else if (userIdObj instanceof Long) {
                userId = ((Long) userIdObj).intValue();
            }
            
            if (userId != null) {
                // 個人統計情報を取得
                Map<String, Object> userStats = gameRecordDAO.getUserStatistics(userId);
                if (userStats != null) {
                    session.setAttribute("userStats", userStats);
                    
                    // ベストタイムを秒から分:秒.ミリ秒形式に変換
                    Object bestTimeObj = userStats.get("bestTime");
                    if (bestTimeObj != null) {
                        int bestTimeSeconds = ((Number) bestTimeObj).intValue();
                        String formattedTime = formatTime(bestTimeSeconds);
                        session.setAttribute("bestTimeFormatted", formattedTime);
                    } else {
                        session.setAttribute("bestTimeFormatted", "--:--.-");
                    }
                    
                    // 総プレイ回数
                    session.setAttribute("totalGames", userStats.get("totalGames"));
                    
                    // 勝利回数（現在は総ゲーム数と同じ - 全クリアのみ記録されるため）
                    session.setAttribute("winStreak", userStats.get("totalWins"));
                } else {
                    // 統計がない場合のデフォルト値
                    session.setAttribute("totalGames", 0);
                    session.setAttribute("bestTimeFormatted", "--:--.-");
                    session.setAttribute("winStreak", 0);
                }
                
                // 最近のプレイ履歴を取得
                List<Map<String, Object>> recentGames = gameRecordDAO.getUserGameRecords(userId, 3);
                request.setAttribute("recentGames", recentGames);
            }
        } else {
            // ゲストユーザーのデフォルト値
            session.setAttribute("totalGames", 0);
            session.setAttribute("bestTimeFormatted", "--:--.-");
            session.setAttribute("winStreak", 0);
        }
        
        // ホームページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/home.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * 秒数を "MM:SS.T" 形式に変換
     */
    private String formatTime(int seconds) {
        if (seconds <= 0) return "--:--.-";
        
        int minutes = seconds / 60;
        int remainingSeconds = seconds % 60;
        int tenths = 0; // 秒単位なので小数点以下は0
        
        return String.format("%02d:%02d.%d", minutes, remainingSeconds, tenths);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
