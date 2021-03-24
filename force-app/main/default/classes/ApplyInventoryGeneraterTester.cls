@isTest
public class ApplyInventoryGeneraterTester {
    private static testMethod void generater(){
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe = TestHelper.createPriceBookEntry(p.Id);
        OpportunityLineItem oppLine = TestHelper.createOpportunityLineItem(opp.Id, pbe.Id);
        List<OpportunityLineItem> oppLines = new List<OpportunityLineItem>();
        oppLines.add(oppLine);
          Test.startTest();
        Apply_Inventory__c ai = TestHelper.createApplyInventory();
        List<Apply_Inventory__c> ais = new List<Apply_Inventory__c>();
        ais.add(ai);
        ApplyInventoryGenerater.generate(opp.Id);
        ApplyInventoryGenerater aig = new ApplyInventoryGenerater();
     //   ApplyInventoryGenerater aig1 = new ApplyInventoryGenerater();
       
         Apply_Inventory__c ai1 = TestHelper.createApplyInventory();
        Apply_Inventory__c ai2 = TestHelper.createApplyInventory();
        List<Apply_Inventory__c> ais1 = new List<Apply_Inventory__c>();
        ais1.add(ai1);
        ais1.add(ai2);
        OpportunityLineItem oppLine2 = TestHelper.createOpportunityLineItem(opp.Id, pbe.Id);
         oppLines.add(oppLine2);
        ApplyInventoryGenerater.generate(opp.Id);
        ApplyInventoryGenerater aig2 = new ApplyInventoryGenerater();
      //  ApplyInventoryGenerater aig3 = new ApplyInventoryGenerater();
       // Opportunity opp1 = TestHelper.createOpportunity(acc.Id);
        aig.runTest();
	}
}