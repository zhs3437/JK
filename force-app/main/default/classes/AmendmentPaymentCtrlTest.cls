@istest
public class AmendmentPaymentCtrlTest {
    static testMethod void myTest(){
        ApexPages.StandardController sd;
        Account acc         = TestHelper.createAccount();
        order lm =TestHelper.createOrder();
        lm.Pricebook2Id =Test.getStandardPriceBookID();
        lm.AccountId=acc.id;
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=10;
        update  lm;
        Amendment__c ad=new Amendment__c();
        ad.Order__c=lm.id;
        insert ad;
        Amendment_Payment__c ap2 =new Amendment_Payment__c();
        ap2.Amendment_Purchase_Agreement__c=ad.id;
               ap2.Percentage__C=100;
        ap2.Down_Balance_Payment__c='Down Payment';
        ap2.Payment_Method__c='T/T';
        ap2.Payment_Term__c='	x% DP X days before the BL/Delivery Date';
        ap2.Days__C=30;
        insert ap2;
        ApexPages.currentPage().getParameters().put('id',ad.id);    
        AmendmentPaymentCtrl ap =new AmendmentPaymentCtrl(sd);
        ap.savePaymentRequest();
        ap.CancelPaymentRequest ();
        ap.addPaymentRequest () ;
        ap.DeletePay();
        
    }
}