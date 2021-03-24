@isTest
public class ContractUpdateTester {
    private static testMethod void clickbutton(){ 
        ID AustraliaRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Australia').getRecordTypeId();
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.RecordTypeId =  AustraliaRecordTypeId;
        opp.Payment_Term_Description__c = 'T/T';
        opp.SELLER__c = 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';  
        opp.Trade_term__c = 'DDP' ;
        opp.whether_pick_up_batch__c = 'false' ;
        insert opp;
        
        Contract c = TestHelper.createContract(acc.Id,false);
        c.Opportunity__c = opp.Id;
        c.Contract_NO__c = '111';
        c.Trade_term__c = 'DDP' ;
        insert c;        
    	ContractUpdate.clickUpdate(c.Id);
    }
}