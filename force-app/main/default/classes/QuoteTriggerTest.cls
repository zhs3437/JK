@isTest
public class QuoteTriggerTest {
    static testMethod void myUnitTest() {
        Contact cont = TestHelper.createContact(true);
        OpportunityLineItem item =null;
        string recordTypeId = null;
    	
    	Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        
        Opportunity opp= TestHelper.createOpportunity(acc.Id,true); 
        //opp.contactId = cont.id;
        //update opp;
        Quote q                  = TestHelper.createQuote(opp.id);        
    }
}