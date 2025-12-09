<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // セッションを完全にリセット
    session.invalidate();
    
    // 新しいセッションを作成
    session = request.getSession(true);
    
    // ゲーム画面にリダイレクト
    response.sendRedirect("game");
%>
