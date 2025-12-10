/*
 * 【神経衰弱ゲーム - メインコントローラ】
 * GameServlet.java
 * 
 * 役割：神経衰弱ゲームのビジネスロジックとWebリクエスト処理を担当
 * 
 * 主な機能：
 * 1. ゲーム初期化（カード生成・シャッフル）
 * 2. カードクリック処理（表向き状態管理）
 * 3. ペア判定とゲーム進行制御
 * 4. セッション管理（ゲーム状態の永続化）
 * 5. 画面遷移制御（JSP転送）
 * 
 * 設計パターン：MVCアーキテクチャのController層
 * - Model: カードデータ（List<Map<String, Object>>）
 * - View: game.jsp, result.jsp
 * - Controller: このGameServletクラス
 */
package com.example;

// 標準ライブラリのインポート
import java.io.IOException;           // 入出力例外処理
import java.util.*;                   // コレクション（List、Map等）
import javax.servlet.*;               // サーブレット基本機能
import javax.servlet.http.*;          // HTTPサーブレット機能

/*
 * 【Tomcat バージョン互換性について】
 * 
 * Tomcat9 vs Tomcat10 の重要な違い：
 * - Tomcat9: javax.servlet.* パッケージ使用
 * - Tomcat10: jakarta.servlet.* パッケージ使用
 * 
 * このプロジェクトはTomcat9環境なので javax.servlet.* を使用
 */
/**
 * 【神経衰弱ゲームサーブレットクラス】
 * 
 * このクラスは神経衰弱ゲームの全てのWebリクエストを処理するコントローラです。
 * HttpServletを継承してHTTPの GET/POST リクエストに対応します。
 * 
 * セッション管理：
 * - cards: カードの状態一覧（List<Map<String, Object>>）
 * - opened: 現在表向きになっているカードのインデックス（List<Integer>）
 * - cleared: 消去されたカードの数（Integer）
 */
public class GameServlet extends HttpServlet {
      // 定数定義（重複文字列リテラル問題の解決）
    private static final String ATTR_CARDS = "cards";
    private static final String ATTR_OPENED = "opened";
    private static final String ATTR_CLEARED = "cleared";
    private static final String ATTR_SHOW_NEXT = "showNext";
    private static final String ATTR_START_TIME = "startTime";
    private static final String ATTR_PLAY_TIME = "playTime";
    private static final String CARD_VALUE = "value";
    private static final String CARD_IS_OPEN = "isOpen";
    private static final String CARD_IS_GONE = "isGone";
    private static final String PAGE_GAME = "game.jsp";
    private static final String PAGE_RESULT = "result.jsp";
    private static final String ACTION_RESTART = "restart";
    private static final String ACTION_NEXT = "next";
    private static final String PARAM_INDEX = "index";
    
    /**
     * 【GETリクエスト処理メソッド】
     * 
     * 役割：ゲーム画面への初回アクセス時の処理
     * - ブラウザでURL直接アクセス時
     * - ページリフレッシュ時
     * - 他ページからのリンクアクセス時
     * 
     * 処理フロー：
     * 1. セッションからゲーム状態を取得
     * 2. 初回アクセスの場合はゲーム初期化
     * 3. カードデータをリクエスト属性に設定
     * 4. game.jspに転送
     */
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // セッション取得：ゲーム状態の永続化のため
        HttpSession session = request.getSession();
          // セッションからカードデータを取得
        List<Map<String, Object>> cards = (List<Map<String, Object>>) session.getAttribute(ATTR_CARDS);
          // 初回アクセス判定：カードデータが存在しない場合
        if (cards == null) {
            // ゲーム初期化処理
            cards = initCards();  // 新しいカード配置を生成
            
            // ゲーム開始時間を記録
            long startTime = System.currentTimeMillis();
            
            // セッションにゲーム状態を保存
            session.setAttribute(ATTR_CARDS, cards);                    // カード一覧
            session.setAttribute(ATTR_OPENED, new ArrayList<Integer>());// 表向きカード（空）
            session.setAttribute(ATTR_CLEARED, 0);                      // 消去カード数（0）
            session.setAttribute(ATTR_START_TIME, startTime);           // ゲーム開始時間
        }
          // リクエスト属性設定：JSPに渡すデータ
        request.setAttribute(ATTR_CARDS, cards);      // カードデータ
        request.setAttribute(ATTR_SHOW_NEXT, false);   // 「次へ」ボタン非表示
        
        // タイマー表示用の開始時間をJSPに渡す
        Long startTime = (Long) session.getAttribute(ATTR_START_TIME);
        if (startTime != null) {
            request.setAttribute(ATTR_START_TIME, startTime);
        }
        
        // game.jspに転送
        RequestDispatcher dispatcher = request.getRequestDispatcher(PAGE_GAME);
        dispatcher.forward(request, response);
    }    /**
     * 【POSTリクエスト処理メソッド】
     * 
     * 役割：ユーザーのゲーム操作に対する処理
     * - カードクリック処理
     * - 「次へ」ボタン処理（ペア判定・カード状態更新）
     * - ゲームリスタート処理
     * 
     * パラメータ解析：
     * - action="restart": ゲーム再開
     * - action="next": ターン進行（ペア判定実行）
     * - index="数値": カードクリック（カード番号指定）
     */
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          // セッションからゲーム状態を取得
        HttpSession session = request.getSession();
        List<Map<String, Object>> cards = (List<Map<String, Object>>) session.getAttribute(ATTR_CARDS);
        List<Integer> opened = (List<Integer>) session.getAttribute(ATTR_OPENED);
        int cleared = (Integer) session.getAttribute(ATTR_CLEARED);
        
        // リクエストパラメータから操作種別を取得
        String action = request.getParameter("action");
        
        /*
         * 【処理分岐1: ゲーム再開処理】
         * result.jsp の「もう一度遊ぶ」ボタンクリック時
         */
        if (action != null && action.equals(ACTION_RESTART)) {
            handleRestart(request, response, session);
            return;
        }        /*
         * 【処理分岐2: テストクリア機能】
         * テスト用の強制クリア機能
         */
        if (action != null && action.equals("testclear")) {
            System.out.println("=== テストクリア開始 ===");
            System.out.println("PAGE_RESULT: " + PAGE_RESULT);
            try {
                RequestDispatcher dispatcher = request.getRequestDispatcher(PAGE_RESULT);
                System.out.println("RequestDispatcher作成成功: " + dispatcher);
                dispatcher.forward(request, response);
                System.out.println("フォワード成功");
                return;
            } catch (Exception e) {
                System.out.println("フォワードエラー: " + e.getMessage());
                e.printStackTrace();
                throw e;
            }
        }
        
        /*
         * 【処理分岐3: ターン進行処理】
         * game.jsp の「次へ」ボタンクリック時
         */        if (action != null && action.equals(ACTION_NEXT)) {
            handleNext(request, response, session, cards, opened, cleared);
            return;
        }
        
        /*
         * 【処理分岐3: カードクリック処理】
         * game.jsp の「?」ボタンクリック時
         */
        handleCardClick(request, response, cards, opened);
    }
    
    /**
     * 【ゲーム再開処理メソッド】
     */
    private void handleRestart(HttpServletRequest request, HttpServletResponse response, 
                              HttpSession session) throws ServletException, IOException {
        // 新しいゲームを初期化
        List<Map<String, Object>> cards = initCards();
        
        // セッション状態をリセット
        session.setAttribute(ATTR_CARDS, cards);
        session.setAttribute(ATTR_OPENED, new ArrayList<Integer>());
        session.setAttribute(ATTR_CLEARED, 0);
        
        // JSPに転送
        request.setAttribute(ATTR_CARDS, cards);
        request.setAttribute(ATTR_SHOW_NEXT, false);
        RequestDispatcher dispatcher = request.getRequestDispatcher(PAGE_GAME);
        dispatcher.forward(request, response);
    }
    
    /**
     * 【ターン進行処理メソッド】
     */
    private void handleNext(HttpServletRequest request, HttpServletResponse response,
                           HttpSession session, List<Map<String, Object>> cards,
                           List<Integer> opened, int cleared) throws ServletException, IOException {
        if (opened.size() == 2) {
            int idx1 = opened.get(0);
            int idx2 = opened.get(1);
            
            String v1 = (String) cards.get(idx1).get(CARD_VALUE);
            String v2 = (String) cards.get(idx2).get(CARD_VALUE);
              if (v1.equals(v2)) {
                cards.get(idx1).put(CARD_IS_GONE, true);
                cards.get(idx2).put(CARD_IS_GONE, true);
                cleared += 2;
                session.setAttribute(ATTR_CLEARED, cleared);
                
                // ゲームクリア判定（マッチした後にのみチェック）
                if (cleared == cards.size()) {
                    RequestDispatcher dispatcher = request.getRequestDispatcher(PAGE_RESULT);
                    dispatcher.forward(request, response);
                    return; // ゲームクリア時はここで処理終了
                }
            }
            
            for (Map<String, Object> card : cards) {
                card.put(CARD_IS_OPEN, false);
            }
            opened.clear();
        }
        
        request.setAttribute(ATTR_CARDS, cards);
        request.setAttribute(ATTR_SHOW_NEXT, false);
        RequestDispatcher dispatcher = request.getRequestDispatcher(PAGE_GAME);
        dispatcher.forward(request, response);
    }
    
    /**
     * 【カードクリック処理メソッド】
     */
    private void handleCardClick(HttpServletRequest request, HttpServletResponse response,
                                List<Map<String, Object>> cards, List<Integer> opened) 
                                throws ServletException, IOException {
        String indexStr = request.getParameter(PARAM_INDEX);
        if (indexStr != null && opened.size() < 2) {
            int idx = Integer.parseInt(indexStr);
            
            boolean isGone = (Boolean) cards.get(idx).get(CARD_IS_GONE);
            boolean alreadyOpened = opened.contains(idx);
            
            if (!isGone && !alreadyOpened) {
                cards.get(idx).put(CARD_IS_OPEN, true);
                opened.add(idx);
            }
        }
        
        boolean showNext = (opened.size() == 2);
        request.setAttribute(ATTR_CARDS, cards);
        request.setAttribute(ATTR_SHOW_NEXT, showNext);
        RequestDispatcher dispatcher = request.getRequestDispatcher(PAGE_GAME);
        dispatcher.forward(request, response);
    }    /**
     * 【カード初期化メソッド】
     * 
     * 役割：新しいゲーム開始時のカードデータ生成
     * 
     * 処理内容：
     * 1. ペアのカード値を定義（3ペア = 6枚）
     * 2. カード配置をランダムシャッフル
     * 3. 各カードの初期状態を設定（全て裏向き、未消去）
     * 4. List<Map<String, Object>>形式でカードデータを生成
     * 
     * 戻り値：初期化されたカードデータ
     * - Map要素: "value"（カード値）、"isOpen"（表向きフラグ）、"isGone"（消去フラグ）
     */
    private List<Map<String, Object>> initCards() {
        // 【変更】3ペア6枚のカード構成に変更
        // ペアカードの値を定義（3ペア = 6枚構成）
        List<String> values = Arrays.asList(
            "🎭", "🎭",   // 演劇マスク
            "🎨", "🎨",   // パレット  
            "🎵", "🎵"    // 音符
        );
        
        // カード配置をランダムシャッフル（毎回異なるゲームに）
        Collections.shuffle(values);
        
        // カードデータリストを初期化
        List<Map<String, Object>> cards = new ArrayList<>();
        
        // 各カード値に対してMapオブジェクトを生成
        for (String v : values) {
            Map<String, Object> card = new HashMap<>();
            card.put(CARD_VALUE, v);         // カードの値（絵文字）
            card.put(CARD_IS_OPEN, false);    // 初期状態：裏向き
            card.put(CARD_IS_GONE, false);    // 初期状態：未消去
            cards.add(card);              // カードリストに追加
        }
        
        return cards;  // 初期化されたカードデータを戻す
    }
}
