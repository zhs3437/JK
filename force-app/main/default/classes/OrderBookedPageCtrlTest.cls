@isTest
public class OrderBookedPageCtrlTest {
    public static testMethod void onTestSendMail(){
           Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 
         ApexPages.standardController std    = new ApexPages.standardController(opp);
        OrderBookedPageCtrl op =new OrderBookedPageCtrl();
       
        op.Addaction();

    }
}