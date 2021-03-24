@istest
public class OrderUnLockCtrlTest {
    static testMethod void myTest(){
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        Account acc         = TestHelper.createAccount();
        Product2 p2          = TestHelper.createProduct2();
        PricebookEntry pbe  = TestHelper.createPricebookEntry(p2.id);
        Product2 p3          = TestHelper.createProduct2();
        PricebookEntry pbe2  = TestHelper.createPricebookEntry(p3.id);
        Product2 p4          = TestHelper.createProduct2();
        PricebookEntry pbe3  = TestHelper.createPricebookEntry(p4.id);
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        OpportunityLineItemGrossMarginHandler.skipTrigger = false;
        order lm =TestHelper.createOrder();
        lm.AccountId=acc.id;
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=20;
        lm.Pricebook2Id =pbe.Pricebook2Id;
        lm.Opportunity__c = opp.Id;
        update  lm;
        Amendment__c ad=new Amendment__c();
        ad.Order__c=lm.id;
        ad.Account__c=acc.id;
        ad.EffectiveDate__c=date.today();
        ad.Status__c='Draft';
        ad.Lock__c=false;
        insert ad;
        
        Payment__c p =new Payment__c();
        p.Order__c=lm.id;
        P.Percentage__C=1;
        P.Down_Balance_Payment__c='Down Payment';
        P.Payment_Method__c='T/T';
        P.Payment_Term__c='	x% DP X days before the BL/Delivery Date';
        p.Days__C=30;
        insert p;
        
        OrderItem o =	TestHelper.createOrderItem(lm.id,pbe.id);
        OpportunityLineItemGrossMarginHandler.skipTrigger = false;
        update o;
        Amendment_Order_Product__c aop =new Amendment_Order_Product__c();
        aop.OriginalOrderItem__c=ad.id;
        aop.id__c=o.id;
        aop.Order__c=lm.id;
        aop.Quantity__c=8;
        aop.Guaranteed_Delivery_Date__c=date.today();
        aop.Product2__c=p2.id;
        aop.UnitPrice__c=1;
        aop.total_Price__c=1;
        insert aop;
        Amendment_Payment__c pd =new Amendment_Payment__c();
        pd.Amendment_Purchase_Agreement__c=ad.id;
        pd.id__c=p.id;
        pd.Days__c=20;
                Pd.Percentage__C=1;
        Pd.Down_Balance_Payment__c='Down Payment';
        Pd.Payment_Method__c='T/T';
            Pd.Payment_Term__c='	x% DP X days before the BL/Delivery Date';
        pd.Days__C=30;
        insert pd;
        OpportunityLineItemGrossMarginHandler.skipTrigger = false;
        delete o;
        OrderUnLockCtrl.SearchParent(ad.id);

    }
}