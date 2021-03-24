@isTest
public class RemindAccountInactiveCtrlTest {
    public static testMethod void submitTest(){
         Account acc = TestHelper.createAccount();
        acc.Name='Test';
        update acc;
        Opportunity opp = TestHelper.createOpportunity(acc.Id,true); 
        opp.Land_Freight_China__c = null;
        opp.Land_Freight_Oversea__c =null;
        opp.Ocean_Freight__c = null;
        opp.Trade_Term__c = 'DDP';
        opp.AccountId = acc.id;
       system.debug(opp.id);
          ApexPages.currentPage().getParameters().put('id',opp.Id);
       ApexPages.standardController std    = new ApexPages.standardController(opp);
        RemindAccountInactiveCtrl pctrl =new RemindAccountInactiveCtrl(std);
        
    }
}