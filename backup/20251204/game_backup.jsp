<%-- 
【JSPページディレクティブ】
- language="java": サーバーサイドスクリプト言語をJavaに指定
- contentType: ブラウザに送信するHTTPレスポンスのMIMEタイプと文字エンコーディング
- pageEncoding: JSPファイル自体の文字エンコーディング
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 
【インポートディレクティブ】
java.util.*パッケージをインポートして、List、Mapなどのコレクションクラスを使用可能にする
神経衰弱のカード情報をList<Map<String, Object>>形式で受け取るために必要
--%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>神経衰弱 ゲーム画面</title>
    <%-- キャッシュ無効化設定 - CSS変更を確実に反映させるため --%>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">    <%-- 外部CSSファイルを読み込み、カードのレイアウトやボタンのスタイルを定義 --%>
    <link rel="stylesheet" type="text/css" href="random_layout.css?v=20241202001">
    <%-- カードエフェクト専用CSS - 3Dフリップアニメーション等 --%>
    <link rel="stylesheet" type="text/css" href="card_effects.css?v=20241202001">
</head>
<body>
    <%-- ゲームのタイトル表示 --%>
    <h1>神経衰弱</h1>    <%-- 【カードグリッド領域】CSSで横並び配置される --%>
    <div class="cards">
        <%-- 
        【カードデータ取得】
        Servletから送信されたカード情報を取得
        データ構造：List<Map<String, Object>>
        各カードのMap内容：
        - "isOpen": boolean - カードが表向きかどうか
        - "isGone": boolean - ペア成立で消去されたかどうか  
        - "value": String - カードの値（"A", "K", "Q", "J", "10"等）
        --%>
        <%
            List<Map<String, Object>> cards = (List<Map<String, Object>>)request.getAttribute("cards");
            
            // カードデータが正常に受信できた場合のみ処理
            if (cards != null) {
                // 全カードをインデックス順に処理（0から順番に）
                for (int i = 0; i < cards.size(); i++) {
                    // i番目のカードの情報を取得
                    Map<String, Object> card = cards.get(i);
                    
                    // カードの状態を取得（Booleanオブジェクトからbooleanにアンボクシング）
                    boolean isOpen = (Boolean)card.get("isOpen");   // 表向きフラグ
                    boolean isGone = (Boolean)card.get("isGone");   // 消去フラグ
                    String value = (String)card.get("value");       // カード値
        %>        <%-- Tashironn
                <%
                    List<Map<String, Object>> cards = (List<Map<String, Object>>)request.getAttribute("cards");
                    if (cards != null) {
                        // カード配列をループ処理（通常は12枚のカード）
                        for (int i = 0; i < cards.size(); i++) {
                            Map<String, Object> card = cards.get(i);
                           
                            // 各カードの状態を取得
                            boolean isOpen = (Boolean)card.get("isOpen");     // 表向き状態
                            boolean isGone = (Boolean)card.get("isGone");     // 削除済み状態
                            String value = (String)card.get("value");         // カードの値
                %>    
        
        この部分は、簡単にいうと、何をしているのでしょうか？
        
        GitHub Copilot
        この部分は、簡単に言うと 「Servletから受け取ったカードデータを1枚ずつ取り出して、各カードの状態を調べる処理」 です。
        
        簡単な説明
        やっていることを段階的に説明
        
        【カード表示の3状態分岐】
        1. isGone = true  : ペア成立で消去されたカード → 空要素で非表示
        2. isOpen = true  : 表向き状態のカード → 値を表示、クリック不可
        3. isOpen = false : 裏向き状態のカード → ?ボタン表示、クリック可能
        --%>
        <div class="card">
            <% if (isGone) { %>
                <%-- 【状態1: 消去されたカード】
                     ペア成立により消去されたカードは何も表示しない
                     divは残すがcontent無しで視覚的に空白になる --%>
                <!-- 消えたカードは表示しない -->
            <% } else if (isOpen) { %>
                <%-- 【状態2: 表向きのカード】
                     プレイヤーがクリックして表にしたカード
                     カードの値（A,K,Q,J,数字）を<span>で表示
                     クリック不可状態（フォームなし） --%>
                <span><%= value %></span>
            <% } else { %>
                <%-- 【状態3: 裏向きのカード】
                     まだめくられていない初期状態のカード
                     ?ボタンを表示してクリック可能にする
                     クリック時はPOSTでServletに送信 --%>
                <form method="post" action="game">
                    <%-- カードのインデックス番号をhidden fieldで送信
                         Servletでどのカードがクリックされたかを識別 --%>
                    <input type="hidden" name="index" value="<%= i %>" />
                    <%-- クリック可能な?ボタン。CSSでスタイリングされる --%>
                    <button type="submit" class="card-btn">?</button>
                </form>
            <% } %>
        </div>
        <%       }
            }
        %>
    </div>    <%-- 
    【「次へ」ボタン制御領域】
    2枚のカードをめくった後にのみ表示される重要なゲーム進行ボタン
    --%>
    <div class="next-btn-area">
        <%-- 
        【showNext フラグの判定】
        Servletから送信されるshowNext属性で表示制御
        - null または false: ボタン非表示（初期状態 or 1枚だけめくった状態）
        - true: ボタン表示（2枚めくった状態）
        --%>
        <% Boolean showNext = (Boolean)request.getAttribute("showNext");
           if (showNext != null && showNext) { %>
            <%-- 
            【ゲーム進行フォーム】
            「次へ」ボタンクリック時の処理指定
            action="next" でServletにペア判定とカード状態更新を依頼
            --%>
            <form method="post" action="game">
                <%-- action=nextでServletに次のターン処理を指示 --%>
                <input type="hidden" name="action" value="next" />
                <%-- プレイヤーが押すボタン（CSSでスタイル適用） --%>
                <button type="submit" class="next-btn">次へ</button>
            </form>
        <% } %>
    </div>
</body>
</html>
