@isTest
public without sharing class QW_FormDetailControllerTest {
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

    @isTest static void test_form() {
        Account account = [SELECT Id FROM Account LIMIT 1][0];
        Project__c project = [SELECT Id FROM Project__c LIMIT 1][0];
        QWUser__c user = [SELECT Id FROM QWUser__c LIMIT 1][0];
        Map<String, Object> dataMap = new Map<String, Object>{
            'action' => 'new',
            'userId' => user.Id,
            'form' => project,
            'id' => project.Id
        };
        Test.startTest();
        new QW_FormDetailController().verify();
        QW_FormDetailController.getForm(JSON.serialize(dataMap));
        String id = project.Id;
        project.Id = null;
        QW_FormDetailController.setForm(JSON.serialize(dataMap));
        QW_FormDetailController.getUser(user.Id);
        project.Id = id;
        QW_FormDetailController.deleteForm(JSON.serialize(project));

        Test.stopTest();
    }
    @isTest static void test_account() {
        Account account = [SELECT Id, Name FROM Account LIMIT 1][0];
        QWUser__c user = [SELECT Id FROM QWUser__c LIMIT 1][0];

        Map<String, Object> dataMap = new Map<String, Object>{
            'action' => 'new',
            'userId' => user.Id,
            'account' => account,
            'id' => account.Id
        };
        Test.startTest();
        new QW_FormDetailController().verify();
        QW_FormDetailController.getAccounts();
        QW_FormDetailController.getAccount(JSON.serialize(dataMap));
        String id = account.Id;
        account.Id = null;
        QW_FormDetailController.setAccount(JSON.serialize(dataMap));
        account.Id = id;
        QW_FormDetailController.deleteAccoount(JSON.serialize(account));

        Test.stopTest();
    }
}