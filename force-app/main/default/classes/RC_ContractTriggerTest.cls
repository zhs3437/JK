@IsTest
public without sharing class RC_ContractTriggerTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract();
        insert contract;
        Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
        insert contractItem;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
    }

    @isTest 
    static 
    void test_Basic() {
        leanx__lg_Contract__c contract = [SELECT Id, Joint_Review_Completed__c, Review_Status_SOC__c, Single_Sign_Approval_Over__c FROM leanx__lg_Contract__c WHERE Joint_Review_Completed__c = false LIMIT 1][0];
        User user1 = [SELECT Id FROM User WHERE Email = 'jiayue.zhang@jinkosolar.com'];
        
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(contract.id);
        req1.setProcessDefinitionNameOrId('Letter_Of_Intent_Joint_Review');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        System.assert(result.isSuccess());
        System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());

        contract.Joint_Review_Completed__c = true;
        contract.Review_Status_SOC__c = 'Pending';
        update contract;
    }

    @isTest 
    static 
    void test_GrossMargin() {
        update [SELECT Id FROM leanx__lg_Contract__c];
    }
}