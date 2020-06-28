public with sharing class PardotApiPreviewController {

    private static PardotApiPreviewHelper helper = new PardotApiPreviewHelper();

    /**
     * コンストラクタ
     */
    public PardotApiPreviewController() {
        
    }

    /**
     * 初期処理
     */
    @RemoteAction
    public static PardotApiPreviewWrapper init() {
        PardotApiPreviewWrapper wrapper = new PardotApiPreviewWrapper();

        try {
            // カスタム設定情報取得
            PardotApiSettings__c pardotApiSettings = PardotApiSettings__c.getOrgDefaults();
            // カスタム設定情報取得判定
            wrapper.errorMessage = helper.checkPardotApiSettings(pardotApiSettings);
            // エラー判定
            if (String.isNotEmpty(wrapper.errorMessage)) return wrapper;
            
            // PardotAPIキー取得
            HttpResponse pardotApiLoginResponse = helper.getPardotApiLoginResponse(pardotApiSettings);

            // PardotAPIキー取得結果を格納
            wrapper.apiKeyField.status = pardotApiLoginResponse.getStatus();
            wrapper.apiKeyField.statusCode = pardotApiLoginResponse.getStatusCode();

            // PardotAPI実行結果判定
            wrapper.errorMessage = helper.checkStatusCode(wrapper.apiKeyField.statusCode, 'PardotAPIのリクエストに失敗しました。');
            // エラー判定
            if (String.isNotEmpty(wrapper.errorMessage)) return wrapper;

            // XMLNodeから文字列取得
            Dom.Document docApiKey = pardotApiLoginResponse.getBodyDocument();
            Dom.XMLNode xmlNodeApiKey = docApiKey.getRootElement();

            // APIキーの値をセット
            wrapper.apiKeyField.apiKey = (xmlNodeApiKey.getChildElement('api_key', null) != null)
                                            ? xmlNodeApiKey.getChildElement('api_key', null).getText() : '';

            // PardotAPIキーの存在チェック
            wrapper.errorMessage = helper.checkPardoApiKeyValue(wrapper.apiKeyField.apiKey);
            // エラー判定
            if (String.isNotEmpty(wrapper.errorMessage)) return wrapper;

            // Pardotキャンペーン取得
            HttpResponse pardotApiCampaignResponse = helper.getPardotApiCampaignResponse(pardotApiSettings.BaseUrl__c, pardotApiSettings.UserKey__c, wrapper.apiKeyField.apiKey);

            // Pardotキャンペーン取得処理結果を格納
            wrapper.apiCampaignField.status = pardotApiCampaignResponse.getStatus();
            wrapper.apiCampaignField.statusCode = pardotApiCampaignResponse.getStatusCode();

            // PardotAPI実行結果判定
            wrapper.errorMessage = helper.checkStatusCode(wrapper.apiCampaignField.statusCode, 'PardotAPIのリクエストに失敗しました。');
            // エラー判定
            if (String.isNotEmpty(wrapper.errorMessage)) return wrapper;

            // XMLNodeから文字列取得
            Dom.Document docCampaign = pardotApiCampaignResponse.getBodyDocument();
            Dom.XMLNode xmlNodeCampaign = docCampaign.getRootElement();

            // TotalResults情報取得
            String totalResults = (xmlNodeCampaign.getChildElement('result', null).getChildElement('total_results', null) != null)
                                        ? xmlNodeCampaign.getChildElement('result', null).getChildElement('total_results', null).getText() : '';
            // リストサイズ取得
            wrapper.apiCampaignField.totalResults = String.isNotEmpty(totalResults) ? Integer.valueOf(totalResults) : 0;
            // キャンペーンリスト取得
            wrapper.apiCampaignField.campaignList = helper.getPardotCampaignList(xmlNodeCampaign);

        } catch(Exception e) {
            CommonEmail.sendEmailByExceptionError(e);
            wrapper.errorMessage = e.getMessage();
            return wrapper;
        }

        return wrapper;
    }
}