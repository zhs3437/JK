@isTest
public class RefreshStockTest {
       public static testMethod void Test(){
        Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 
        RefreshStock.clickUpdate(opp.id);
           RefreshStock.tool();
           jinkosolarComEccStockResult.IT_OP_element jit =new jinkosolarComEccStockResult.IT_OP_element();
               jit.tool();
       }

}