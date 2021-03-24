@isTest
public class PriceApproveTest {
    
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

    private static testMethod void submitTestJapanPart(){
		OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        
        Opportunity opp= TestHelper.createOpportunity(acc.Id,false); 
		
		recordTypeId = TestHelper.getRecordTypeId('Opportunity', 'Japan');
        if(string.isNotEmpty(recordTypeId)){
            opp.RecordTypeId = recordTypeId;
        }
		insert opp;      
        PriceApprove.submit(opp.id);
    }
    
    private static testMethod void submitTestAustraliaAustraliaMWPart(){
		OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        
        Opportunity opp= TestHelper.createOpportunity(acc.Id,false); 
        opp.Trade_Term__c = 'DDP';
        opp.Ocean_Freight__c = 100;
        opp.Expect_Price_and_Comments__c = '0.65';
        opp.Payment_1MW_Approve__c = true;
        recordTypeId = TestHelper.getRecordTypeId('Opportunity', 'Australia');
        if(string.isNotEmpty(recordTypeId)){
            opp.RecordTypeId = recordTypeId;
        }
        insert opp;
        item = TestHelper.createOpportunityLineItem(opp.id,pbe.id,false);
        item.Quantity = 2900;
        insert item;
        PriceApprove.submit(opp.id);

    }
            /**
    private static testMethod void submitTestAustraliaAustraliaPart(){
		OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false); 
        opp.Payment_1MW_Approve__c = true;
        opp.Expect_Price_and_Comments__c = '0.65';
        opp.Ocean_Freight__c = '1000';
        opp.Trade_Term__c = 'DDP';
        opp.whether_pick_up_batch__c = 'True';
        recordTypeId = TestHelper.getRecordTypeId('Opportunity', 'Australia');
        if(string.isNotEmpty(recordTypeId)){
            opp.RecordTypeId = recordTypeId;
        }
        insert opp;
        item = TestHelper.createOpportunityLineItem(opp.id,pbe.id,false);
        item.Quantity = 2000;
        insert item;
        PriceApprove.submit(opp.id);
        opp.whether_pick_up_batch__c = 'True';
        opp.Trade_Term__c = 'EXW';
        update opp;
        PriceApprove.submit(opp.id);
        opp.Trade_Term__c = 'CIF';
        update opp;
        PriceApprove.submit(opp.id);

    }

    //美国和欧洲
    private static testMethod void submitTestAustraliaUSAPart(){
		OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        
        Opportunity opp= TestHelper.createOpportunity(acc.Id,false); 
        opp.Region__c = 'EU(Union)';
        opp.Expect_Price_and_Comments__c = '0.65';
        opp.Ocean_Freight__c = '1000';
        insert opp;
        item = TestHelper.createOpportunityLineItem(opp.id,pbe.id,false);
        item.Quantity = 2900;
        insert item;
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
        opp.Ocean_Freight__c = '1000';
        opp.Payment_1MW_Approve__c = true;
        insert opp;      
        PriceApprove.submit(opp.id);

    }

   */
}