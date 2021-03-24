@istest
public class OrderDiffCtrlTest {
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
        String requestId= ApexPages.currentPage().getParameters().put('id',ad.id);
        Order_Differences__c ods =new Order_Differences__c();
        ods.Amendment_Purchase_Agreement__c=ad.id;
                ods.Total_Price_New__c=1000;
        ods.ApprovalNumbers__c=0;
        insert ods;
        OrderItem_Difference__c oif=new OrderItem_Difference__c();
        oif.Order_Differences__c=ods.id;
        oif.Total_Price_New__c=1000;
        insert oif;
        PaymentDifference__c pd=new PaymentDifference__c();
        pd.Order_Differences__c=ods.id;
        insert pd;
        OrderDiffCtrl od =new OrderDiffCtrl(sd);
               OrderDiffCtrl.History oh =new    OrderDiffCtrl.History();
        oh.addOrderlinDiff(oif);
       oh.addpayDiff(pd);
        OrderDiffListCtrl od2=new OrderDiffListCtrl();
    }
}