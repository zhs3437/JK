@IsTest
public class RC_AmendmentAgreementBasicHandlerTest {
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
      leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract(); 
      contract.Project__c = project.Id; 
      contract.Stage__c   = 'Contract Negotiation';
      insert contract; 
      Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
      insert contractItem;
      Id RecordTypeId2 = Schema.SObjectType.Amendment_Agreement__c.getRecordTypeInfosByDeveloperName().get('Amendment_Agreement_China').getRecordTypeId();
        Amendment_Agreement__c amendment = new Amendment_Agreement__c();
        amendment.Account__c =accounts.id;
        amendment.Seller__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        amendment.RecordTypeId = RecordTypeId2;
        amendment.Stage__c = 'Pending';
        amendment.Sales_Dept__c = 'Sales Dept 3';
        amendment.SOC_Specialist__c = admin.Id;
        insert amendment;
        Amendment_Agreement_Product__c amendmentProduct = new Amendment_Agreement_Product__c();
        amendmentProduct.Total_Power_W__c = 12345;      
        amendmentProduct.Amendment_Agreement__c = amendment.id;
        amendmentProduct.Product__c = contract.Product__c;          
        amendmentProduct.Special_Material_Cost_Per_W__c = 123;
        amendmentProduct.Total_Price__c = 12345.12;    
        amendmentProduct.CurrencyIsoCode = contract.CurrencyIsoCode;            
        amendmentProduct.Quantity__c = 1234;                       
        amendmentProduct.Sales_Price__c = 0.99; 
        amendmentProduct.Guaranteed_Delivery_Date__c = date.today();  
        insert amendmentProduct;  
        List<String> imdaApproval = system.label.iAmendment_Agreement.split(';');
      ProcessDefinition pd = [SELECT Id, DeveloperName FROM ProcessDefinition WHERE TableEnumOrId = 'Amendment_Agreement__c' AND Id IN: imdaApproval][0];
      system.debug('pd.id-->'+pd.id);
      Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setSubmitterId(admin.Id); 
        req1.setObjectId(amendment.id);
        req1.setProcessDefinitionNameOrId(pd.DeveloperName);
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
    }

    @isTest 
    static void test_GrossMargin() {
      Amendment_Agreement__c contract = [Select Id, Joint_Review_Completed__c from Amendment_Agreement__c limit 1];
      if(contract !=null){
        contract.Joint_Review_Completed__c = true;
        update contract;
      }
    }

}