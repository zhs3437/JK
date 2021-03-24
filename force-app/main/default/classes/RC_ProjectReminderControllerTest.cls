@IsTest
public without sharing class RC_ProjectReminderControllerTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        leanx__pm_Project__c project = QW_TestDataFactory.createIProject();
        insert project;
        leanx__pm_ProjectMember__c item = QW_TestDataFactory.createIProjectItemById(project.Id);
        insert item;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
    }

    @isTest 
    static void test_init() {
        RC_ProjectReminderController.init(JSON.serialize(new Map<String, Object>{
            'id' => [SELECT Id FROM leanx__pm_Project__c][0].Id
        }));
    }
}