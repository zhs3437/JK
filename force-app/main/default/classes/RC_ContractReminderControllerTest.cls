@IsTest
public without sharing class RC_ContractReminderControllerTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract();
        insert contract;
        Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
        insert contractItem;
        User admin = QW_TestDataFactory.createUser();
        admin.Department = 'BMO';
        admin.IsActive = true;
        insert admin;
        SharePoint_Event__c event = new SharePoint_Event__c(
            ContractId__c = [SELECT Id FROM leanx__lg_Contract__c][0].Id
        );
        insert event;
    }

    @isTest 
    static void test_init() {
        RC_ContractReminderController.init(JSON.serialize(new Map<String, Object>{
            'id' => [SELECT Id FROM leanx__lg_Contract__c][0].Id
        }));
    }

    @isTest 
    static void test_confirmRevise() {
        User admin = [SELECT Id FROM User WHERE Department = 'BMO' AND IsActive = true][0];
        leanx__lg_Contract__c contract = [SELECT Id FROM leanx__lg_Contract__c][0];
        System.runAs(admin){
            RC_ContractReminderController.confirmRevise(JSON.serialize(new Map<String, Object>{
                'id' => contract.Id
            }));
        }
    }

    @isTest 
    static void test_confirmVersion() {
        RC_ContractReminderController.confirmVersion(JSON.serialize(new Map<String, Object>{
            'id' => [SELECT Id FROM leanx__lg_Contract__c][0].Id
        }));
    }

    @isTest 
    static void test_startJoint() {
        RC_ContractReminderController.startJoint(JSON.serialize(new Map<String, Object>{
            'id' => [SELECT Id FROM leanx__lg_Contract__c][0].Id
        }));
    }

    @isTest 
    static void test_deleteFile() {
        Test.setMock(HttpCalloutMock.class, new QW_MockHttpResponseGenerator());
        RC_ContractReminderController.deleteFile(JSON.serialize(new Map<String, Object>{
            'id' => [SELECT Id FROM SharePoint_Event__c][0].Id
        }));
    }
}