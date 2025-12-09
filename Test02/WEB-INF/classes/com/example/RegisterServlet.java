/*
 * 【ユーザー登録サーブレット】
 * RegisterServlet.java
 * 
 * 役割：新規ユーザー登録処理を担当
 * 
 * 主な機能：
 * 1. 登録フォームの表示（GET）
 * 2. ユーザー登録処理（POST）
 * 3. 入力データ検証
 * 4. 重複チェック
 * 5. 登録成功時の自動ログイン
 */
package com.example;

import java.io.IOException;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * ユーザー登録サーブレットクラス
 */
public class RegisterServlet extends HttpServlet {
    
    private static final String REGISTER_PAGE = "register.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String HOME_PAGE = "home.jsp";
    
    /**
     * GETリクエスト処理：登録画面表示
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
        
        // 登録画面を表示
        RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
        dispatcher.forward(request, response);
    }
    
    /**
     * POSTリクエスト処理：ユーザー登録
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // リクエストパラメータ取得
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String displayName = request.getParameter("displayName");
        
        // 入力検証
        String validationError = validateInput(username, email, password, confirmPassword, displayName);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            preserveInputValues(request, username, email, displayName);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            // データベース接続確認
            if (!DatabaseConnection.testConnection()) {
                request.setAttribute("errorMessage", "データベース接続エラーが発生しました。");
                preserveInputValues(request, username, email, displayName);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
                dispatcher.forward(request, response);
                return;
            }
            
            UserDAO userDAO = new UserDAO();
            
            // 重複チェック
            if (userDAO.isUsernameExists(username)) {
                request.setAttribute("errorMessage", "このユーザー名は既に使用されています。");
                preserveInputValues(request, "", email, displayName); // ユーザー名はクリア
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
                dispatcher.forward(request, response);
                return;
            }
            
            if (email != null && !email.trim().isEmpty() && userDAO.isEmailExists(email)) {
                request.setAttribute("errorMessage", "このメールアドレスは既に使用されています。");
                preserveInputValues(request, username, "", displayName); // メールアドレスはクリア
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
                dispatcher.forward(request, response);
                return;
            }
              // ユーザー作成
            String hashedPassword = UserDAO.hashPassword(password);
            User newUser = new User(username, email, hashedPassword, displayName);
            boolean success = userDAO.createUser(newUser);
              if (success) {
                // 登録成功：自動ログイン処理
                Map<String, Object> authenticatedUser = userDAO.authenticateUser(username, hashedPassword);
                
                if (authenticatedUser != null) {
                    // セッションにユーザー情報を保存
                    HttpSession session = request.getSession();
                    session.setAttribute("currentUser", authenticatedUser);
                    session.setAttribute("isAuthenticated", true);
                    session.setAttribute("loginTime", System.currentTimeMillis());
                    session.setAttribute("isNewUser", true); // 新規登録フラグ
                    
                    // ホーム画面にリダイレクト
                    response.sendRedirect(HOME_PAGE);
                } else {
                    // 自動ログイン失敗（通常は発生しない）
                    request.setAttribute("successMessage", "登録が完了しました。ログインしてください。");
                    RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
                    dispatcher.forward(request, response);
                }
                
            } else {
                request.setAttribute("errorMessage", "登録処理に失敗しました。もう一度お試しください。");
                preserveInputValues(request, username, email, displayName);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
                dispatcher.forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "システムエラーが発生しました: " + e.getMessage());
            preserveInputValues(request, username, email, displayName);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher(REGISTER_PAGE);
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * 入力検証
     */
    private String validateInput(String username, String email, String password, 
                                String confirmPassword, String displayName) {
        
        // 必須項目チェック
        if (username == null || username.trim().isEmpty()) {
            return "ユーザー名は必須です。";
        }
        
        if (password == null || password.trim().isEmpty()) {
            return "パスワードは必須です。";
        }
        
        if (confirmPassword == null || !password.equals(confirmPassword)) {
            return "パスワードが一致しません。";
        }
        
        // ユーザー名の形式チェック
        if (!username.matches("^[a-zA-Z0-9_]{3,20}$")) {
            return "ユーザー名は3-20文字の英数字とアンダースコアのみ使用できます。";
        }
        
        // パスワードの強度チェック
        if (password.length() < 6) {
            return "パスワードは6文字以上で入力してください。";
        }
        
        // メールアドレス形式チェック（入力されている場合のみ）
        if (email != null && !email.trim().isEmpty()) {
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                return "メールアドレスの形式が正しくありません。";
            }
        }
        
        // 表示名の長さチェック（入力されている場合のみ）
        if (displayName != null && displayName.length() > 50) {
            return "表示名は50文字以内で入力してください。";
        }
        
        return null; // 検証成功
    }
    
    /**
     * 入力値を保持（エラー時の再表示用）
     */
    private void preserveInputValues(HttpServletRequest request, String username, 
                                   String email, String displayName) {
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("displayName", displayName);
    }
}
