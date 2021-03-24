@isTest
public class AddAmendmentOrderCtrlTest {
    static testMethod void myTest(){
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
        Payment__c p =new Payment__c();
        p.Order__c=lm.id;
        P.Percentage__C=100;
        P.Down_Balance_Payment__c='Down Payment';
        P.Payment_Method__c='T/T';
            P.Payment_Term__c='	x% DP X days before the BL/Delivery Date';
        p.Days__C=30;
        insert p;

        OrderItem o =	TestHelper.createOrderItem(lm.id,pbe.id);


        ApexPages.currentPage().getParameters().put('id',lm.id);
        AddAmendmentOrderCtrl ao=new AddAmendmentOrderCtrl(sd);
        ao.Cancel();
        ao.addOrderItem();

        ao.SelectDailyDetail();
                ao.addPayment();
        ao.DeletePay();
        ao.DeleteiTEM();
    }
}