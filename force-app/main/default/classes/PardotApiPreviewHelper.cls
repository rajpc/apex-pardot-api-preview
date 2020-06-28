public with sharing class PardotApiPreviewHelper {

    /**
     * コンストラクタ
     */
    public PardotApiPreviewHelper() {

    }

    /**
     * カスタム設定情報取得判定
     */
    public String checkPardotApiSettings(PardotApiSettings__c pardotApiSettings) {
        String errorMessage = '';
        // base_url
        if (String.isEmpty(pardotApiSettings.BaseUrl__c)) {
            errorMessage += '・Pardot連携情報の取得に失敗しました。 [' + Schema.sObjectType.PardotApiSettings__c.Fields.BaseUrl__c.Label + ']' + '\n';
        }
        // email
        if (String.isEmpty(pardotApiSettings.Email__c)) {
            errorMessage += '・Pardot連携情報の取得に失敗しました。 [' + Schema.sObjectType.PardotApiSettings__c.Fields.Email__c.Label + ']' + '\n';
        }
        // password
        if (String.isEmpty(pardotApiSettings.Password__c)) {
            errorMessage += '・Pardot連携情報の取得に失敗しました。 [' + Schema.sObjectType.PardotApiSettings__c.Fields.Password__c.Label + ']' + '\n';
        }
        // user_key
        if (String.isEmpty(pardotApiSettings.UserKey__c)) {
            errorMessage += '・Pardot連携情報の取得に失敗しました。 [' + Schema.sObjectType.PardotApiSettings__c.Fields.UserKey__c.Label + ']' + '\n';
        }
        
        return errorMessage;
    }

    /**
     * 認証用のPardotAPIキー取得
     */
    public HttpResponse getPardotApiLoginResponse(PardotApiSettings__c pardotApiSettings) {
        // バイナリー情報作成
        String boundary = '------------' + String.valueOf(DateTime.now().getTime());
        // HTTPリクエストEndpoint情報取得
        String endpoint = pardotApiSettings.BaseUrl__c + 'login/version/4';
        // HTTPリクエストBody情報取得
        String body  = '';
        body += this.create_multi_param(boundary, 'email', pardotApiSettings.Email__c);
        body += this.create_multi_param(boundary, 'password', pardotApiSettings.Password__c);
        body += this.create_multi_param(boundary, 'user_key', pardotApiSettings.UserKey__c);
        body += '--' + boundary + '--\r\n';
        // HTTPリクエスト実行
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'multipart/form-data; boundary='+ boundary);
        request.setBody(body);
        request.setCompressed(false);

        // HTTPレスポンス取得
        HttpResponse response = http.send(request);

        return response;
    }

    /**
     * パラメータ取得
     */
    private String create_multi_param(String boundary, String name, String val){
        String param = '--' + boundary+'\r\n'
        + 'Content-Disposition: form-data; name="' + name + '"'
        + '\r\n\r\n' + val + '\r\n';
        return param;
    }

    /**
     * ステータスコードチェック
     */
    public String checkStatusCode(Integer statusCode, String prmErrorMsg) {
        String errorMessage = '';
        if (statusCode != 200) {
            errorMessage = prmErrorMsg;
        }
        return errorMessage;
    }

    /**
     * PardotAPIキーの存在チェック
     */
    public String checkPardoApiKeyValue(String apiKey) {
        String errorMessage = '';
        if (String.isEmpty(apiKey)) {
            errorMessage = 'PardotAPIキーの取得に失敗しました。';
        }
        return errorMessage;
    }

    /**
     * Pardotキャンペーン取得
     */
    public HttpResponse getPardotApiCampaignResponse(String baseUrl, String userKey, String apiKey) {
        // HTTPリクエストEndpoint情報取得
        String endpoint = baseUrl + 'campaign/version/4/do/query';
        // HTTPリクエスト実行
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Authorization', 'Pardot api_key=' + apiKey + ',user_key=' + userKey);
        request.setCompressed(true);
        // HTTPレスポンス取得
        HttpResponse response = http.send(request);

        return response;
    }

    /**
     * Pardotキャンペーンリスト取得
     */
    public List<PardotApiPreviewWrapper.ApiCampaignFieldInner> getPardotCampaignList(Dom.XMLNode xmlNodeCampaign) {
        List<PardotApiPreviewWrapper.ApiCampaignFieldInner> pardotCampaignList = new List<PardotApiPreviewWrapper.ApiCampaignFieldInner>();

        if (xmlNodeCampaign != null && xmlNodeCampaign.getChildElement('result', null) != null) {
            for(Dom.XMLNode child : xmlNodeCampaign.getChildElement('result', null).getChildElements()) {
                if (child != null && child.getName() == 'campaign') {
                    PardotApiPreviewWrapper.ApiCampaignFieldInner cmp = new PardotApiPreviewWrapper.ApiCampaignFieldInner();
                    cmp.id = (child.getChildElement('id', null) != null) ?  child.getChildElement('id', null).getText() : '';
                    cmp.name = (child.getChildElement('name', null) != null) ? child.getChildElement('name', null).getText() : '';
                    cmp.crmFId = (child.getChildElement('crm_fid', null) != null) ? child.getChildElement('crm_fid', null).getText() : '';
                    // リスト追加
                    pardotCampaignList.add(cmp);
                }
            }
        }

        return pardotCampaignList;
    }
}