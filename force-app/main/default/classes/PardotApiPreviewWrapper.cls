public with sharing class PardotApiPreviewWrapper {

    // エラーメッセージ
    public String errorMessage {get; set;}
    // PardotApiKeyFieldクラス
    public ApiKeyField apiKeyField {get;set;}
    // PardotCampaignFieldクラス
    public ApiCampaignField apiCampaignField {get; set;}

    /**
     * コンストラクタ
     */
    public PardotApiPreviewWrapper() {
        // エラーメッセージ
        this.errorMessage = '';
        // PardotApiKeyFieldクラス
        this.apiKeyField = new ApiKeyField();
        // PardotCampaignFieldクラス
        this.apiCampaignField = new ApiCampaignField();
    }

    /**
     * ApiKeyFieldクラス
     */
    public class ApiKeyField {
        // ステータス
        public String status {get; set;}
        // ステータスコード
        public Integer statusCode {get; set;}
        // APIキー
        public String apiKey {get; set;}

        /**
         * コンストラクタ
         */
        public ApiKeyField() {
            // ステータス
            this.status = '';
            // ステータスコード
            this.statusCode = null;
            // APIキー
            this.apiKey = '';
        }
    }

    /**
     * ApiCampaignFieldクラス
     */
    public class ApiCampaignField {
        // ステータス
        public String status {get; set;}
        // ステータスコード
        public Integer statusCode {get; set;}
        // リスト件数
        public Integer totalResults {get; set;}
        // キャンペーンリスト
        public List<ApiCampaignFieldInner> campaignList {get; set;}

        /**
         * コンストラクタ
         */
        public ApiCampaignField() {
            // ステータス
            this.status = '';
            // ステータスコード
            this.statusCode = null;
            // リスト件数
            this.totalResults = null;
            // キャンペーンリスト
            this.campaignList = new List<ApiCampaignFieldInner> ();
        }
    }

    /**
     * ApiCampaignFieldInnerインナークラス
     */
    public class ApiCampaignFieldInner {
        // ID
        public String id {get; set;}
        // Name
        public String name {get; set;}
        // Crm fId
        public String crmFId {get; set;}

        /**
         * コンストラクタ
         */
        public ApiCampaignFieldInner() {
            // ID
            this.id = '';
            // Name
            this.name = '';
            // Crm fId
            this.crmFId = '';
        }
    }
}