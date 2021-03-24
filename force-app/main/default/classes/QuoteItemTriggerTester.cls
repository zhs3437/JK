@isTest()
public class QuoteItemTriggerTester {
    static testMethod void createQuote(){
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c = 'CIF';
        insert opp;
        Quote q = TestHelper.createQuote(opp.Id);
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe = TestHelper.createPriceBookEntry(p.Id);
        QuoteLineItem qli = TestHelper.createQuoteLineItem(q.Id, pbe.Id);
        
    }
    
    
}