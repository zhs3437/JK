@IsTest
public without sharing class RC_OrderDiffCtrlTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        leanx__pm_Project__c project = QW_TestDataFactory.createIProject();
        insert project;
        leanx__pm_ProjectMember__c projectItem = QW_TestDataFactory.createIProjectItemById(project.Id);
        insert projectItem;
        leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract();
        insert contract;
        Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
        insert contractItem;
        Agreement__c agreement = QW_TestDataFactory.createAgreement();
        agreement.Account__c = accounts.Id;
        agreement.Actual_Sales__c = admin.Id;
        insert agreement;
        SAP_Product__c material = new SAP_Product__c(
            Name = '123',
            Product_Code__c = '123'
        );
        insert material;
        Agreement_Component__c agreementItem = QW_TestDataFactory.createAgreementItemById(agreement.Id);
        agreementItem.SAP_Materiel_No__c = material.Id;
        insert agreementItem;
        Amendment_Agreement__c agreement2 = QW_TestDataFactory.createAmendmentAgreement();
        agreement2.Agreement__c = agreement.Id;
        insert agreement2;
        Amendment_Agreement_Product__c agreementItem2 = QW_TestDataFactory.createAmendmentAgreementItemById(agreement2.Id);
        insert agreementItem2;
        Payment__c payment = QW_TestDataFactory.createPayment();
        payment.China_Project__c = project.Id;
        payment.China_Contract__c = contract.Id;
        payment.China_Order__c = agreement.Id;
        payment.Amendment_Agreement__c = agreement2.Id;
        insert payment;
    }    

    @isTest 
    static void test_all() {
        ApexPages.currentPage().getParameters().put('id', [SELECT Id FROM Amendment_Agreement__c][0].Id);
        RC_OrderDiffCtrl ctrl = new RC_OrderDiffCtrl(null);
    }
}