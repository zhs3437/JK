@isTest
private class QuoteTest{
    //2015/8/23
    @IsTest(SeeAllData=true)
    static void TestQuote() {
        SendEmailUtils seu = new SendEmailUtils();
        seu.runTest();
        
        QuoteLineItemSync  glis = new QuoteLineItemSync();
        glis.runTest();
        
        //Opportunity opp = [SELECT ID,Name FROM Opportunity limit 1];
        
        //Product2 prod = [SELECT ID,Name FROM Product2 limit 1];
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Product2 prod = TestHelper.createProduct2();
        Apply_Inventory__c inv = new Apply_Inventory__c();
		inv.Quantity__c           = 1000;
		inv.Opportunity__c        = opp.id;
		inv.Product_Type__c       = prod.id;
		inv.ConnectorLine__c      = '';
		inv.Junction_Box_Brand__c = '';
		inv.Wire_Length__c        = '';
		insert inv;        
    }
    
}