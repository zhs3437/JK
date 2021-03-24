@isTest
public class NewProjectCtrlTest {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);

        
        ApexPages.standardController std    = new ApexPages.standardController(opp);
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        NewProjectCtrl controller      = new NewProjectCtrl(std);
        
        controller.getLoginToken();
        controller.getLoginTokenfenxiao();
        controller.openwin();
        controller.openwinfenxiao();
        controller.save();
        controller.save2();
        controller.SaveReturn();
    }
}