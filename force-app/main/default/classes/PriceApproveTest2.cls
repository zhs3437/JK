@isTest
public class PriceApproveTest2 {
        private static testMethod void submitTest(){
    	
    	OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
		
    	Opportunity opp = TestHelper.createOpportunity(acc.Id,false); 
       opp.Land_Freight_China__c = null;
        opp.Land_Freight_Oversea__c = null;
        opp.Ocean_Freight__c = null;
        opp.Trade_Term__c = 'DDP';
        insert opp;
        PriceApprove.submit(opp.id);
        
        opp.Expect_Price_and_Comments__c = '';
    	opp.Trade_Term__c = 'EXW';
        update opp;      
        PriceApprove.submit(opp.id);
    }
    
    //其他区域 Latin America&Italy
    private static testMethod void submitTestAustraliaOtherPart(){
		OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        
        Opportunity opp= TestHelper.createOpportunity(acc.Id,false); 
        opp.Region__c = 'Latin America&Italy'; 
        opp.Expect_Price_and_Comments__c = '0.65';
        opp.Ocean_Freight__c = 1000;
        opp.Payment_1MW_Approve__c = true;
        insert opp;      
        PriceApprove.submit(opp.id);

    }
  

   

}