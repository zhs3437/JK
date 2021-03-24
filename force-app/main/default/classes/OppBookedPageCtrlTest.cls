@isTest
public class OppBookedPageCtrlTest {
    public static testMethod void onTestSendMail(){
        Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 
         ApexPages.standardController std    = new ApexPages.standardController(opp);
        OppBookedPageCtrl op =new OppBookedPageCtrl(std);
        op.add();
        op.Sync();
        op.book();
        op.Addaction();
        SyncStockQuery.I_QUERY_PARA_element si =new SyncStockQuery.I_QUERY_PARA_element();
        si.tool();
        jinkosolarComEccStockBook.DT_StockBook_Request jd =new jinkosolarComEccStockBook.DT_StockBook_Request();
        jd.tool();
        jinkosolarComCrmStockBook.HTTPS_Port jh = new jinkosolarComCrmStockBook.HTTPS_Port();
        jh.tool();
    }
}