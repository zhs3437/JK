@isTest
public class GenerateQuotePdfTester {

    static testMethod void myUnitTest() {        
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.Id);
        Product2 product1                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPriceBookEntry(product1.id);
        
        Quote q                  = TestHelper.createQuote(opp.id);
        q.Region__c='EU(Union)';
        update q;
         
        QuoteLineItem qLineItem1 = TestHelper.createQuoteLineItem(q.id, pbe1.id); 
        GenerateQuotePdf pdf = new GenerateQuotePdf(new ApexPages.StandardController(q));
        Decimal num= GenerateQuotePdf.getMW(q.id);
        String Fmap= GenerateQuotePdf.getfap(q.id);
        String cmap= GenerateQuotePdf.getcap(q.id);
        String gmap= GenerateQuotePdf.getGMap(q.id);
pdf.runtest();
        List<SelectOption> countryList = pdf.getCountryItems();
        List<SelectOption> formatList = pdf.getFormatItems();
        pdf.doBack();
        pdf.doGenerate();
         q.Region__c='Middle East&Africa';
        update q;
        pdf.getCountryItems();
        q.Region__c='Latin America&Italy';
        update q;
        pdf.getCountryItems();
        q.Region__c='ROA';
        update q;
       
        pdf.getCountryItems();
      
    }
}