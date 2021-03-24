@isTest
public class AddAmendmentOrderCtrlAgainTest {
 static testMethod void myTest2(){
        ApexPages.StandardController sd;
        Account acc         = TestHelper.createAccount();
        Product2 p2          = TestHelper.createProduct2();
        PricebookEntry pbe  = TestHelper.createPricebookEntry(p2.id);
        order lm =TestHelper.createOrder();
        lm.Pricebook2Id =Test.getStandardPriceBookID();
        lm.AccountId=acc.id;
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=10;
        update  lm;
        system.debug('lm-->'+lm);
       

        OrderItem o =	TestHelper.createOrderItem(lm.id,pbe.id);


        ApexPages.currentPage().getParameters().put('id',lm.id);
     
        
        AddAmendmentOrderCtrlAgain ao2 = new AddAmendmentOrderCtrlAgain(sd);
      
       ao2.test();
        
    }
}