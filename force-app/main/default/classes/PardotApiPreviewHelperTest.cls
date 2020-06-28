@isTest
private class PardotApiPreviewHelperTest {

    private static PardotApiPreviewHelper helper = new PardotApiPreviewHelper();
    private static User testAdminUser = CommonTester.getLoginUser();

    /**
     * カスタム設定情報取得判定
     * 値なし
     */
    @isTest static void checkPardotApiSettingsTest1() {
        
        System.runAs(testAdminUser) {

            PardotApiSettings__c pardotApiSettings = new PardotApiSettings__c(
                 BaseUrl__c = ''
                ,Email__c = ''
                ,Password__c = ''
                ,UserKey__c = ''
            );

            Test.startTest();
            
            String result = helper.checkPardotApiSettings(pardotApiSettings);
            
            Test.stopTest();

            System.assertEquals(String.isNotEmpty(result), true);
        }
    }

    /**
     * カスタム設定情報取得判定
     * 値あり
     */
    @isTest static void checkPardotApiSettingsTest2() {
        
        System.runAs(testAdminUser) {

            PardotApiSettings__c pardotApiSettings = CommonTester.createPardotApiSettings(true);

            Test.startTest();
            
            String result = helper.checkPardotApiSettings(pardotApiSettings);
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(result), true);
        }
    }

    /**
     * 認証用のPardotAPIキー取得
     */
    @isTest static void getPardotApiLoginResponseTest1() {
        
        System.runAs(testAdminUser) {

            // CalloutMock
            Test.setMock(HttpCalloutMock.class, new Mock());
            // カスタム設定
            PardotApiSettings__c pardotApiSettings = CommonTester.createPardotApiSettings(true);

            Test.startTest();
            
            HttpResponse response = helper.getPardotApiLoginResponse(pardotApiSettings);
            
            Test.stopTest();
            
            Integer statusCode = response.getStatusCode();
            System.assertEquals(statusCode, 200);
        }
    }

    /**
     * ステータスコードチェック
     */
    @isTest static void checkStatusCodeTest1() {
        
        System.runAs(testAdminUser) {

            String prmErrorMsg = 'PardotAPIのリクエストに失敗しました。';

            Test.startTest();
            
            // エラーなし(200)
            String result = helper.checkStatusCode(200, prmErrorMsg);
            System.assertEquals(String.isEmpty(result), true);

            // エラーあり(400)
            result = helper.checkStatusCode(400, prmErrorMsg);
            System.assertEquals(String.isNotEmpty(result), true);
            System.assertEquals(result, prmErrorMsg);
            
            Test.stopTest();
        }
    }

    /**
     * PardotAPIキーの存在チェック
     */
    @isTest static void checkPardoApiKeyValueTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            // エラーなし
            String apiKey = 'xxxxxxxxxxxxxx';
            String result = helper.checkPardoApiKeyValue(apiKey);
            System.assertEquals(String.isEmpty(result), true);

            // エラーあり
            apiKey = '';
            result = helper.checkPardoApiKeyValue(apiKey);
            System.assertEquals(String.isNotEmpty(result), true);
            
            Test.stopTest();
        }
    }

    /**
     * Pardotキャンペーン取得
     */
    @isTest static void getPardotApiCampaignResponseTest1() {
        
        System.runAs(testAdminUser) {
            
            // CalloutMock
            Test.setMock(HttpCalloutMock.class, new Mock());
            // カスタム設定
            PardotApiSettings__c pardotApiSettings = CommonTester.createPardotApiSettings(true);
            String baseUrl = pardotApiSettings.BaseUrl__c;
            String userKey = pardotApiSettings.UserKey__c;
            String apiKey = 'xxxxxxxxxxxxxx';

            Test.startTest();
            
            HttpResponse response = helper.getPardotApiCampaignResponse(baseUrl, userKey, apiKey);
            
            Test.stopTest();
            
            Integer statusCode = response.getStatusCode();
            System.assertEquals(statusCode, 200);
        }
    }

    /**
     * Pardotキャンペーンリスト取得
     * 値なし
     */
    @isTest static void getPardotCampaignListTest1() {
        
        System.runAs(testAdminUser) {

            // CalloutMock
            Test.setMock(HttpCalloutMock.class, new Mock());
            // カスタム設定
            PardotApiSettings__c pardotApiSettings = CommonTester.createPardotApiSettings(true);
            
            Dom.XMLNode xmlNodeCampaign = null;

            Test.startTest();
            
            List<PardotApiPreviewWrapper.ApiCampaignFieldInner> results = helper.getPardotCampaignList(xmlNodeCampaign);
            
            Test.stopTest();

            System.assertEquals(results.isEmpty(), true);
        }
    }

    /**
     * Pardotキャンペーンリスト取得
     * 値あり
     */
    @isTest static void getPardotCampaignListTest2() {
        
        System.runAs(testAdminUser) {

            // CalloutMock
            Test.setMock(HttpCalloutMock.class, new Mock());
            // カスタム設定
            PardotApiSettings__c pardotApiSettings = CommonTester.createPardotApiSettings(true);

            XmlStreamWriter w =new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
            // <rsp>
            w.writeStartElement('', 'rsp', '');
            // <result>
            w.writeStartElement('', 'result', '');
            // <total_results>
            w.writeStartElement('', 'total_results', '');
            w.writeCharacters('2');
            w.writeEndElement();
            // <campaign>
            w.writeStartElement('', 'campaign', '');
            w.writeStartElement('', 'id', '');
            w.writeCharacters('10001');
            w.writeEndElement();
            w.writeStartElement('', 'name', '');
            w.writeCharacters('SampleCampaign1');
            w.writeEndElement();
            w.writeStartElement('', 'crm_fid', '');
            w.writeCharacters('700000001');
            w.writeEndElement();
            w.writeEndElement();
            // <campaign>
            w.writeStartElement('', 'campaign', '');
            w.writeStartElement('', 'id', '');
            w.writeCharacters('10002');
            w.writeEndElement();
            w.writeStartElement('', 'name', '');
            w.writeCharacters('SampleCampaign2');
            w.writeEndElement();
            w.writeStartElement('', 'crm_fid', '');
            w.writeCharacters('700000002');
            w.writeEndElement();
            // </result>
            w.writeEndElement();
            // </rsp>
            w.writeEndElement();
            w.writeEndDocument();
            // 文字列変換
            string xml = w.getXmlString();
            // 処理終了
            w.close();

            Dom.Document doc = new Dom.Document();
            doc.load(xml);
            Dom.XMLNode xmlNodeCampaign = doc.getRootElement();

            Test.startTest();
            
            List<PardotApiPreviewWrapper.ApiCampaignFieldInner> results = helper.getPardotCampaignList(xmlNodeCampaign);
            
            Test.stopTest();

            System.assertEquals(results.isEmpty(), false);
        }
    }

    /**
     * HttpCalloutMock
     */
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // 戻り値
            HTTPResponse res = new HTTPResponse();
            // Endpoint判定
            if (req.getEndpoint().endsWith('login/version/4')) {
                res.setBody(getLoginXml());
                res.setStatusCode(200);
            } else if (req.getEndpoint().endsWith('campaign/version/4/do/query')) {
                res.setBody(getCamppaignXml());
                res.setStatusCode(200);
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
            return res;
        }

        private String getLoginXml() {
            XmlStreamWriter w =new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
            // <rsp>
            w.writeStartElement('', 'rsp', '');
            w.writeAttribute('', '', 'stat', 'ok');
            w.writeAttribute('', '', 'version', '1.0');
            // <api_key>
            w.writeStartElement('', 'api_key', '');
            w.writeCharacters('xxxxxxx-apikey-xxxxxxx');
            w.writeEndElement();
            // <version>
            w.writeStartElement('', 'version', '');
            w.writeCharacters('4');
            w.writeEndElement();
            // </rsp>
            w.writeEndElement();
            w.writeEndDocument();
            // 文字列変換
            string xml = w.getXmlString();
            // 処理終了
            w.close();
    
            System.assertEquals(xml, '<?xml version="1.0" encoding="UTF-8"?><rsp stat="ok" version="1.0"><api_key>xxxxxxx-apikey-xxxxxxx</api_key><version>4</version></rsp>');
    
            return xml;
        }

        private String getCamppaignXml() {
            XmlStreamWriter w =new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
            // <rsp>
            w.writeStartElement('', 'rsp', '');
            w.writeAttribute('', '', 'stat', 'ok');
            w.writeAttribute('', '', 'version', '1.0');
            // <result>
            w.writeStartElement('', 'result', '');
            // <total_results>
            w.writeStartElement('', 'total_results', '');
            w.writeCharacters('2');
            w.writeEndElement();
            // <campaign>
            w.writeStartElement('', 'campaign', '');
            w.writeStartElement('', 'id', '');
            w.writeCharacters('10001');
            w.writeEndElement();
            w.writeStartElement('', 'name', '');
            w.writeCharacters('SampleCampaign1');
            w.writeEndElement();
            w.writeStartElement('', 'crm_fid', '');
            w.writeCharacters('700000001');
            w.writeEndElement();
            w.writeEndElement();
            // <campaign>
            w.writeStartElement('', 'campaign', '');
            w.writeStartElement('', 'id', '');
            w.writeCharacters('10002');
            w.writeEndElement();
            w.writeStartElement('', 'name', '');
            w.writeCharacters('SampleCampaign2');
            w.writeEndElement();
            w.writeStartElement('', 'crm_fid', '');
            w.writeCharacters('700000002');
            w.writeEndElement();
            // </result>
            w.writeEndElement();
            // </rsp>
            w.writeEndElement();
            w.writeEndDocument();
            // 文字列変換
            string xml = w.getXmlString();
            // 処理終了
            w.close();
    
            System.assertEquals(xml, '<?xml version="1.0" encoding="UTF-8"?><rsp stat="ok" version="1.0"><result><total_results>2</total_results><campaign><id>10001</id><name>SampleCampaign1</name><crm_fid>700000001</crm_fid></campaign><campaign><id>10002</id><name>SampleCampaign2</name><crm_fid>700000002</crm_fid></campaign></result></rsp>');
    
            return xml;
        }
    }
}