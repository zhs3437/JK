@isTest
public class QuoteModelControllerTester {
    static testMethod void myUnitTest() {
        Document doc = TestHelper.createDocument(false);
        doc.Type='png';
        doc.name='nouser';
        insert doc;
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.Id,false);
        opp.Seller__c = 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';
        insert opp;
        Product2 product1                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPriceBookEntry(product1.id);
       
        Quote q                  = TestHelper.createQuote(opp.id);
        QuoteLineItem qLineItem1 = TestHelper.createQuoteLineItem(q.id, pbe1.id,false);
        qLineItem1.Description='ceshishujuceshishujuceshishujuceshishujuceshishujuceshishujuceshishujuceshishujuceshishuju';
        insert qLineItem1; 

        Information_of_Seller__c seller = new Information_of_Seller__c();
        seller.Seller__c = 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';
        insert seller;
        ApexPages.currentPage().getParameters().put('id','id');
        ApexPages.currentPage().getParameters().put('company','company');
        QuoteModelController pdf = new QuoteModelController(new ApexPages.StandardController(q));
        pdf.companyName = 'JinkoSolar (PTY)LTD';
        pdf.companyAdderss	= 'EVANS AVENUE';
        pdf.companyPostcode	='EPPING INDUSTRIA EPPING1';
        pdf.companyTelFax	= 'CAPE TOWN  WESTERN CAPE, SOUTH AFRIAC 7460 AFRICA';
        pdf = new QuoteModelController(new ApexPages.StandardController(q));        
    }
}