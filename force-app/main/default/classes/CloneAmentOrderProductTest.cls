@isTest
public class CloneAmentOrderProductTest {
    static testMethod void myTest(){
          Account acc         = TestHelper.createAccount();
        Product2 p2          = TestHelper.createProduct2();
        PricebookEntry pbe  = TestHelper.createPricebookEntry(p2.id);
        order lm =TestHelper.createOrder();
        lm.Pricebook2Id =Test.getStandardPriceBookID();
        lm.AccountId=acc.id;
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=20;
        update  lm;
        Amendment__c ad=new Amendment__c();
        ad.Order__c=lm.id;
        ad.Account__c=acc.id;
        insert ad;
        Amendment_Order_Product__c aop =new Amendment_Order_Product__c();
        aop.OriginalOrderItem__c=ad.id;
        //aop.id__c=o.id;
        insert aop;
        List<ID> ids = new List<ID>();
        ids.add(aop.Id);
       // CloneAmentOrderProduct cop = new CloneAmentOrderProduct();
        String str = CloneAmentOrderProduct.AddProduct(ids);
    }

}