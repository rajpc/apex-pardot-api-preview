@isTest
private class PardotApiPreviewWrapperTest {

    private static User testAdminUser = CommonTester.getLoginUser();

    /**
     * コンストラクタ
     */
    @isTest static void PardotApiPreviewWrapperTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            PardotApiPreviewWrapper wrapper = new PardotApiPreviewWrapper();
            
            Test.stopTest();
        }
    }

    /**
     * ApiKeyFieldクラス
     */
    @isTest static void PardotApiPreviewWrapperTest2() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            PardotApiPreviewWrapper.ApiKeyField wrapper = new PardotApiPreviewWrapper.ApiKeyField();
            
            Test.stopTest();
        }
    }

    /**
     * ApiCampaignFieldクラス
     */
    @isTest static void PardotApiPreviewWrapperTest3() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            PardotApiPreviewWrapper.ApiCampaignField wrapper = new PardotApiPreviewWrapper.ApiCampaignField();
            
            Test.stopTest();
        }
    }

    /**
     * ApiCampaignFieldInnerクラス
     */
    @isTest static void PardotApiPreviewWrapperTest4() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            PardotApiPreviewWrapper.ApiCampaignFieldInner wrapper = new PardotApiPreviewWrapper.ApiCampaignFieldInner();
            
            Test.stopTest();
        }
    }
}