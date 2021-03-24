@isTest
public without sharing class QW_FormViewControllerTest {
    @testSetup
    static void setup(){
        Project__c project = QW_TestDataFactory.createProject();
        insert project;
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        QWUser__c qwUser = QW_TestDataFactory.createQWUser();
        insert qwUser;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        QWConfig__c config = new QWConfig__c();
        config.Name = 'Project';
        config.OwnerId__c = admin.Id;
        config.AccountRecordTypeId__c = Schema.SObjectType.Account.getRecordTypeInfosByName().get('China Account').getRecordTypeId();
        insert config;        
    }
    
    @isTest static void methodTest1() {
        Test.startTest();
        QW_FormViewController qwForms = new QW_FormViewController();		
        qwForms.verify();
        Map<String, Object> data = new Map<String, Object>{
            'userId' => [SELECT Id FROM QWUser__c LIMIT 1][0].Id,
            'provinceId' => [SELECT Id FROM Account LIMIT 1][0].Id
        };
        QW_FormViewController.getForms(JSON.serialize(data));
        // QW_FormViewController.inputValue('inputValue');
        Test.stopTest();
    }
}