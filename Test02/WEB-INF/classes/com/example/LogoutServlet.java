/*
 * 【ログアウト専用サーブレット】
 * LogoutServlet.java
 * 
 * 役割：ユーザーログアウト処理を担当
 * 
 * 主な機能：
 * 1. セッション無効化
 * 2. ログイン画面へのリダイレクト
 * 3. ログアウトメッセージ表示
 */
package com.example;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * ログアウト専用サーブレットクラス
 */
public class LogoutServlet extends HttpServlet {
    
    private static final String LOGIN_PAGE = "login.jsp";
    
    /**
     * GET/POSTリクエスト処理：ログアウト実行
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    /**
     * ログアウト処理の実装
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 現在のセッションを取得（存在しない場合はnull）
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // セッションを完全に無効化
            session.invalidate();
        }
        
        // ログイン画面にリダイレクト（成功メッセージ付き）
        response.sendRedirect(LOGIN_PAGE + "?logout=success");
    }
}
