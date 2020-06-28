@isTest
private class PardotApiPreviewControllerTest {

    private static User testAdminUser = CommonTester.getLoginUser();

    /**
     * コンストラクタ
     * 値なし
     */
    @isTest static void PardotApiPreviewControllerTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            PardotApiPreviewController cls = new PardotApiPreviewController();
            
            Test.stopTest();
        }
    }

    /**
     * 初期処理
     */
    @isTest static void initTest1() {
        
        System.runAs(testAdminUser) {

            // CalloutMock
            Test.setMock(HttpCalloutMock.class, new Mock());
            // カスタム設定
            PardotApiSettings__c pardotApiSettings = CommonTester.createPardotApiSettings(true);

            Test.startTest();
            
            PardotApiPreviewWrapper result = PardotApiPreviewController.init();
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(result.errorMessage), true);
            System.assertEquals(result.apiCampaignField.campaignList.size(), 2);
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