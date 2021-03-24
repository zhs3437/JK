@isTest
public class AddproductAppCtrlTest {
 static testMethod void myUnitTest() {
      Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 

     Product_Application_Detail__c ppp=new Product_Application_Detail__c();
     ppp.Discount__c=1;
     ppp.name='12';
     ppp.Sales_Price__c=1;
     ppp.W__c=1;
     ppp.Guaranteed_Delivery_Date__c=date.today();
     ppp.Kucun__c='Stock';
     insert ppp;
      
       
        ApexPages.standardController std    = new ApexPages.standardController(opp);
             ApexPages.currentPage().getParameters().put('id',opp.id);
     AddproductAppCtrl app =new AddproductAppCtrl(std);
     Product_Application_Detail__c pp=new Product_Application_Detail__c();
     app.sendMail();
     pp.Discount__c=1;
     pp.Sales_Price__c=1;
     pp.W__c=1;
     pp.Guaranteed_Delivery_Date__c=date.today();
      app.ApplyNextStock();
     app.pdList.add(pp);
    
     app.sendMail();
     
     
     app.NewProduct();app.NewStock();
     
     app.ApplyNext();
     pp.IsOrNotCheck__c=true;
      app.paList.add(pp);
        app.ApplyNext();
     
     app.toback();app.toretrun();
     app.ApplyNextStock();
     app.deleteID='1';
     app.CopyPay();
     app.DeletePay();
     app.surchText='12';
     app.NumberSearch();
     app.howManyCheck();
     }
}