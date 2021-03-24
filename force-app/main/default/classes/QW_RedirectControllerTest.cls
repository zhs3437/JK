@isTest
public without sharing class QW_RedirectControllerTest {
    
    @isTest static void testMethod1() {
        
        
        QWUser__c qwUser = QW_TestDataFactory.createQWUser();
        List<QWUser__c> listQwuser = new List<QWUser__c>();
        listQwuser.add(qwUser);
        insert listQwuser;
        
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        
        QWConfig__c config = new QWConfig__c();
        config.Name = 'Project';
        config.OwnerId__c = admin.Id;
        config.AccountRecordTypeId__c = Schema.SObjectType.Account.getRecordTypeInfosByName().get('China Account').getRecordTypeId();
        insert config;        
        
        QW_RedirectController qwrc = new QW_RedirectController();
        
        Test.startTest();        
        qwrc.redirect();
		Test.stopTest();
    }
}