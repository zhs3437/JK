@isTest
public class RC_AddProductVFCCtrlTest {
 static testMethod void myUnitTest() {   
    Product_Application__C p =new Product_Application__c();
     insert p;
         Product_Application_Detail__c ppp=new Product_Application_Detail__c();
     ppp.Discount__c=1;
     ppp.name='12';
     ppp.Sales_Price__c=1;
     ppp.W__c=1;
     ppp.Guaranteed_Delivery_Date__c=date.today();
     ppp.Kucun__c='Stock';
     ppp.Product_Application__C=p.id;
     insert ppp;
         ApexPages.standardController std=new ApexPages.standardController(p);
   RC_AddProductVFCCtrl af2= new RC_AddProductVFCCtrl(std);
   RC_AddProductVFCCtrl af= new RC_AddProductVFCCtrl();
     af.requestId=p.Id;
    af2.save();
     ppp.cost__c=0.002;
     update ppp;
     RC_AddProductVFCCtrl af3= new RC_AddProductVFCCtrl(std);
         af3.save();
     af2.save2();

}
}