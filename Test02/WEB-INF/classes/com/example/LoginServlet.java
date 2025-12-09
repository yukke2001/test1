/*
 * 【ログイン認証サーブレット】
 * LoginServlet.java
 * 
 * 役割：ユーザーログイン処理を担当
 * 
 * 主な機能：
 * 1. ログインフォームの表示（GET）
 * 2. ユーザー認証処理（POST）
 * 3. セッション管理
 * 4. 認証失敗時のエラー表示
 * 5. 認証成功時のホーム画面転送
 */
package com.example;

import java.io.IOException;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * ログイン認証サーブレットクラス
 */
public class LoginServlet extends HttpServlet {
    
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String HOME_PAGE = "home.jsp";
    
    /**
     * GETリクエスト処理：ログイン画面表示
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 既にログインしている場合はホーム画面にリダイレクト
        HttpSession session = request.getSession();
        Map<String, Object> user = (Map<String, Object>) session.getAttribute("currentUser");
        
        if (user != null) {
            response.sendRedirect(HOME_PAGE);
            return;
        }
        
        // ログイン画面を表示
        RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
        dispatcher.forward(request, response);
    }
    
    /**
     * POSTリクエスト処理：ログイン認証
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // リクエストパラメータ取得
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String action = request.getParameter("action");
        
        // ログアウト処理
        if ("logout".equals(action)) {
            handleLogout(request, response);
            return;
        }
        
        // 入力検証
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "ユーザー名とパスワードを入力してください。");
            RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            // データベース接続確認
            if (!DatabaseConnection.testConnection()) {
                request.setAttribute("errorMessage", "データベース接続エラーが発生しました。");
                RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
                dispatcher.forward(request, response);
                return;
            }
            
            // ユーザー認証処理
            UserDAO userDAO = new UserDAO();
            String hashedPassword = UserDAO.hashPassword(password);
            
            Map<String, Object> authenticatedUser = userDAO.authenticateUser(username, hashedPassword);
            
            if (authenticatedUser != null) {
                // 認証成功：セッションにユーザー情報を保存
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", authenticatedUser);
                session.setAttribute("isAuthenticated", true);
                session.setAttribute("loginTime", System.currentTimeMillis());
                
                // ゲーム統計情報を取得してセッションに保存
                Long userId = (Long) authenticatedUser.get("userId");
                // TODO: ゲーム統計の実装は後のフェーズで追加
                
                // ホーム画面にリダイレクト
                response.sendRedirect(HOME_PAGE);
                
            } else {
                // 認証失敗
                request.setAttribute("errorMessage", "ユーザー名またはパスワードが正しくありません。");
                request.setAttribute("username", username); // 入力値を保持
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
                dispatcher.forward(request, response);
            }
            
        } catch (Exception e) {
            // システムエラー
            request.setAttribute("errorMessage", "システムエラーが発生しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * ログアウト処理
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // セッションを無効化
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // ログイン画面にリダイレクト（ログアウトメッセージ付き）
        request.setAttribute("successMessage", "ログアウトしました。");
        RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
        dispatcher.forward(request, response);
    }
}
