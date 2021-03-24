@isTest
public class RC_AddproductAppCtrlTest {
    static testMethod void myUnitTest() {
        Product2 product1                = QW_TestDataFactory.createProduct2();
        Product2 product2                = QW_TestDataFactory.createProduct2();
        Account acct                     = QW_TestDataFactory.createAccount();
        leanx__pm_Project__c opp         = QW_TestDataFactory.createIProject();
        insert opp;
        leanx__pm_ProjectMember__c oppLineItem1 = QW_TestDataFactory.createIProjectItemById(opp.id); 
        insert oppLineItem1;
        Product_Application_Detail__c ppp=new Product_Application_Detail__c();
        ppp.Discount__c=1;
        ppp.name='12';
        ppp.Sales_Price__c=1;
        ppp.W__c=1;
        ppp.Guaranteed_Delivery_Date__c=date.today();
        ppp.Kucun__c='Stock';
        insert ppp;
        PageReference retPage = new PageReference('/apex/RC_AddProductType?id=' + opp.Id);
        test.setCurrentPage(retPage);
        ApexPages.standardController std    = new ApexPages.standardController(opp);
        ApexPages.currentPage().getParameters().put('id',opp.id);
        RC_AddproductAppCtrl app =new RC_AddproductAppCtrl(std);
        Product_Application_Detail__c pp=new Product_Application_Detail__c();
        app.sendMail();
        pp.Discount__c=1;
        pp.Sales_Price__c=1;
        pp.W__c=1;
        pp.Guaranteed_Delivery_Date__c=date.today();
        app.pdList.add(pp);
        app.sendMail();
        app.NewProduct();
        app.ApplyNext();
        pp.IsOrNotCheck__c=true;
        app.paList.add(pp);
        app.ApplyNext();
        app.toback();
        app.toretrun();
        app.deleteID='1';
        app.CopyPay();
        app.DeletePay();
        app.surchText='12';
        app.NumberSearch();
        app.howManyCheck();
    }
}