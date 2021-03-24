@IsTest
public without sharing class RC_ContractBasicHandlerTest {
  @testSetup
    static void setup() {
      Account accounts = QW_TestDataFactory.createAccount(); 
      insert accounts; 
      User admin = QW_TestDataFactory.createUser(); 
      insert admin; 
      Product2 product2 = QW_TestDataFactory.createProduct2(); 
      insert product2; 
      leanx__pm_Project__c project = QW_TestDataFactory.createIProject(); 
      project.Actual_Sales__c = admin.Id; 
      insert project; 
      leanx__pm_ProjectMember__c projectItem = QW_TestDataFactory.createIProjectItemById(project.Id); 
      insert projectItem; 
      Id RecordTypeId2 = Schema.SObjectType.leanx__lg_Contract__c.getRecordTypeInfosByDeveloperName().get('Non_Standard_Contract').getRecordTypeId();
      leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract(); 
      contract.Project__c = project.Id; 
      contract.Stage__c   = 'Contract Negotiation';
      contract.RecordTypeId = RecordTypeId2; 
      contract.Sales_Dept__c ='Sales Dept Cross Region';
      contract.Joint_Review_Completed__c = false;
      contract.SOC_Specialist__c = admin.Id;
      insert contract; 
      Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
      insert contractItem;
      ProcessDefinition pd = [SELECT Id, DeveloperName,State  FROM ProcessDefinition WHERE TableEnumOrId = 'leanx__lg_Contract__c' AND DeveloperName =: 'Non_Tem_Contract_Joint_Review_Cross_v2' And State ='Active'][0];
      system.debug('pd.id-->'+pd.id);
      Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setSubmitterId(admin.Id); 
        req1.setObjectId(contract.id);
        req1.setProcessDefinitionNameOrId(pd.DeveloperName);
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
    }

    @isTest 
    static void test_GrossMargin() {
      leanx__lg_Contract__c contract = [Select Id, Joint_Review_Completed__c from leanx__lg_Contract__c limit 1];
      if(contract !=null){
        contract.Joint_Review_Completed__c = true;
        update contract;
      }
    }
}