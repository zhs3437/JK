@isTest
public class BookStockSendEmailTest {
     static testMethod void myTest(){
          Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
         User user1 = TestHelper.createSystemAdminUser();
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
        aic.Warehouse__c = null;
        aic.OwnerId = user1.Id;
        insert aic;
       BookStockSendEmail.submit(aic.Id);
    }

}