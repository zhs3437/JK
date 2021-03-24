@isTest
public class AmendmentOrderSortCtrlTest {
    static testmethod void test(){
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
        insert aop;
        Amendment_Order_Product__c aop1 =new Amendment_Order_Product__c();
        aop1.OriginalOrderItem__c=ad.id;
        insert aop1;
        Amendment_Order_Product__c aop2 =new Amendment_Order_Product__c();
        aop2.OriginalOrderItem__c=ad.id;
        insert aop2;
        List<Amendment__c> conLst = new List<Amendment__c>();
        conLst.add(ad);
        ApexPages.currentPage().getParameters().put('id',ad.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(conLst);
        AmendmentOrderSortCtrl mdpc = new AmendmentOrderSortCtrl(ctrl);
        mdpc.ChangedId = '0';
        mdpc.UpDataList();
        mdpc.TopDataList();
        mdpc.DownDataList();
        mdpc.TailDataList();
        mdpc.doSave();     
        
       
        }
}