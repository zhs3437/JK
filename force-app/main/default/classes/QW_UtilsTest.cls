@isTest
public without sharing class QW_UtilsTest {
    @isTest static void sendTest() {
        Test.setMock(HttpCalloutMock.class, new QW_MockHttpResponseGenerator());
        QWConfig__c config = new QWConfig__c();
        config.Corpid__c = 'test';
        config.Corpsecret__c = 'test';
        config.Name = 'Project';
        config.AccountRecordTypeId__c = '0126F000001j8Sx';
        config.OwnerId__c = '0052t000000cXoL';
        config.ProjectRecordTypeId__c = 'test';
        
        insert config;
        
        QWUser__c qwUser = QW_TestDataFactory.createQWUser();
        insert qwUser;

        Test.startTest();
        QW_Utils util = new QW_Utils();
        QW_Utils.getAccessToken();
        //String code = QW_Utils.getAccessToken();
        //QW_Utils.getUserId(code);
        QW_Utils.getUserId(qwUser.Id);
        QW_Utils.getUserInfo(qwUser.Id);
        QW_Utils.getOwnerId();
        //QW_Utils.getProjectRecordTypeId();
        QW_Utils.getAccountRecordTypeId();
        Test.stopTest();
    }
}