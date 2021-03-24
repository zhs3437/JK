@IsTest
public without sharing class RC_MDATriggerTest {
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
        Component_Task_Book__c mda = QW_TestDataFactory.createComponentTaskBook();
        mda.iProject__c = project.Id;
        insert mda;
    }

    @isTest 
    static void test_Basic() {
        update [SELECT Id FROM Component_Task_Book__c];
    }

    @isTest 
    static void test_Reassign() {
        update [SELECT Id FROM Component_Task_Book__c];
        TriggerHandler.clearBypass('RC_MDAReassignHandler');
        delete [SELECT Id FROM Component_Task_Book__c];
    }
}