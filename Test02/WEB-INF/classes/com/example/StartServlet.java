/*
 * 【神経衰弱ゲーム - スタート画面コントローラ】
 * StartServlet.java
 * 
 * 役割：ゲーム開始前のスタート画面処理を担当
 * 
 * 主な機能：
 * 1. スタート画面の表示
 * 2. ユーザー名の受け取り
 * 3. セッションへのユーザー情報保存
 * 4. ゲーム画面への転送
 * 5. 将来拡張：DB連携によるユーザー管理
 * 
 * 設計パターン：MVCアーキテクチャのController層
 * - Model: ユーザー情報（セッション管理）
 * - View: index.jsp（スタート画面）
 * - Controller: このStartServletクラス
 */
package com.example;

// 標準ライブラリのインポート
import java.io.IOException;           // 入出力例外処理
import java.util.*;                   // コレクション（List、Map等）
import javax.servlet.*;               // サーブレット基本機能
import javax.servlet.http.*;          // HTTPサーブレット機能

/**
 * 【スタート画面サーブレットクラス】
 * 
 * このクラスはゲーム開始前のスタート画面処理を担当するコントローラです。
 * HttpServletを継承してHTTPの GET/POST リクエストに対応します。
 * 
 * URL マッピング: /start
 * 
 * セッション管理：
 * - playerName: プレイヤー名（String）
 * - gameStartTime: ゲーム開始時刻（Date）
 * - totalGames: プレイ回数（Integer）
 */
public class StartServlet extends HttpServlet {

    /**
     * 【GETリクエスト処理メソッド】
     * 
     * 役割：スタート画面の初期表示
     * - アプリケーションへの初回アクセス時
     * - ゲーム終了後の再開時
     * - 直接URLアクセス時
     * 
     * 処理フロー：
     * 1. セッションから既存のユーザー情報を取得
     * 2. 既存ユーザーの場合は情報を表示用に設定
     * 3. index.jspに転送してスタート画面表示
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // セッション取得：既存のユーザー情報確認のため
        HttpSession session = request.getSession();
        
        // 既存のプレイヤー情報を取得
        String existingPlayerName = (String) session.getAttribute("playerName");
        Integer totalGames = (Integer) session.getAttribute("totalGames");
        
        // 既存プレイヤー情報をリクエスト属性に設定（JSP表示用）
        if (existingPlayerName != null) {
            request.setAttribute("existingPlayerName", existingPlayerName);
        }
        if (totalGames != null) {
            request.setAttribute("totalGames", totalGames);
        } else {
            request.setAttribute("totalGames", 0);
        }
        
        // welcome メッセージの設定
        if (existingPlayerName != null) {
            request.setAttribute("welcomeMessage", "おかえりなさい、" + existingPlayerName + "さん！");
        } else {
            request.setAttribute("welcomeMessage", "神経衰弱ゲームへようこそ！");
        }
        
        // index.jspに転送してスタート画面を表示
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * 【POSTリクエスト処理メソッド】
     * 
     * 役割：ユーザー情報の受け取りとゲーム開始処理
     * - プレイヤー名の入力受け取り
     * - セッションへのユーザー情報保存
     * - ゲーム画面への転送
     * 
     * パラメータ：
     * - playerName: プレイヤー名（必須）
     * - action: 操作種別（start=ゲーム開始、continue=継続）
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // セッション取得
        HttpSession session = request.getSession();
        
        // リクエストパラメータの取得
        String action = request.getParameter("action");
        String playerName = request.getParameter("playerName");
        
        /*
         * 【処理分岐1: 新しいゲーム開始】
         * プレイヤー名を入力してゲーム開始
         */
        if ("start".equals(action) && playerName != null && !playerName.trim().isEmpty()) {
            
            // プレイヤー名の検証と整形
            playerName = playerName.trim();
            if (playerName.length() > 20) {
                // 名前が長すぎる場合は切り詰め
                playerName = playerName.substring(0, 20);
            }
            
            // セッションにユーザー情報を保存
            session.setAttribute("playerName", playerName);
            session.setAttribute("gameStartTime", new Date());
            
            // ゲーム回数の更新
            Integer currentGames = (Integer) session.getAttribute("totalGames");
            if (currentGames == null) {
                currentGames = 0;
            }
            session.setAttribute("totalGames", currentGames + 1);
            
            // ゲーム状態のリセット（新しいゲーム用）
            session.removeAttribute("cards");
            session.removeAttribute("opened");
            session.removeAttribute("cleared");
            
            // GameServletにリダイレクトしてゲーム開始
            response.sendRedirect("game");
            return;
        }
        
        /*
         * 【処理分岐2: 既存プレイヤーでゲーム継続】
         * 既存のプレイヤー情報でゲーム開始
         */
        if ("continue".equals(action)) {
            
            String existingPlayerName = (String) session.getAttribute("playerName");
            if (existingPlayerName != null) {
                
                // ゲーム開始時刻を更新
                session.setAttribute("gameStartTime", new Date());
                
                // ゲーム回数の更新
                Integer currentGames = (Integer) session.getAttribute("totalGames");
                if (currentGames == null) {
                    currentGames = 0;
                }
                session.setAttribute("totalGames", currentGames + 1);
                
                // ゲーム状態のリセット
                session.removeAttribute("cards");
                session.removeAttribute("opened");
                session.removeAttribute("cleared");
                
                // GameServletにリダイレクトしてゲーム開始
                response.sendRedirect("game");
                return;
            }
        }
        
        /*
         * 【エラーハンドリング】
         * 入力エラーの場合はスタート画面に戻る
         */
        String errorMessage = "";
        if (playerName == null || playerName.trim().isEmpty()) {
            errorMessage = "プレイヤー名を入力してください";
        }
        
        // エラーメッセージを設定してスタート画面に戻る
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("inputPlayerName", playerName); // 入力値の保持
        
        // 既存プレイヤー情報も再設定
        String existingPlayerName = (String) session.getAttribute("playerName");
        Integer totalGames = (Integer) session.getAttribute("totalGames");
        
        if (existingPlayerName != null) {
            request.setAttribute("existingPlayerName", existingPlayerName);
        }
        if (totalGames != null) {
            request.setAttribute("totalGames", totalGames);
        } else {
            request.setAttribute("totalGames", 0);
        }
        
        // スタート画面に戻る
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }
}
