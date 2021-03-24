@isTest
public class AmendReviewTest {
  static testMethod void myTest(){
    OrderApprovalCounts oac =new OrderApprovalCounts();
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
        Profile pf = [select id from profile where name='BD' limit 1];
        system.debug('p------>'+pf);
        User user = TestHelper.createUser(Pf.id,'test800208@qq.com',true);
        User user2 = TestHelper.createUser(Pf.id,'test800209@qq.com',true);
        user2.Contract_Approver__c=user.id;
        update user2;
        Amendment__c ad=new Amendment__c();
        ad.Order__c=lm.id;
        ad.Contract_Owner__c=user2.id;
        ad.Account__c=acc.id;
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

        Amendment_Order_Product__c aop =new Amendment_Order_Product__c();
        aop.OriginalOrderItem__c=ad.id;
        aop.id__c=o.id;
        insert aop;
        Amendment_Payment__c pd =new Amendment_Payment__c();
        pd.Amendment_Purchase_Agreement__c=ad.id;
        pd.id__c=p.id;
        
          
        Pd.Percentage__C=100;
        Pd.Down_Balance_Payment__c='Down Payment';
        Pd.Payment_Method__c='T/T';
        Pd.Payment_Term__c='	x% DP X days before the BL/Delivery Date';
        pd.Days__C=30;
        insert pd;
      String str= OrderApprovalCounts.ClickPriceApproval(ad.id);
      SubmitForReview__c sfr2 =new SubmitForReview__c();
      sfr2.user__c=userinfo.getUserId();
      sfr2.ischecked__c=true;
      sfr2.Amendment__c =ad.id;
      insert sfr2;
      ApexPages.StandardController sd=new ApexPages.StandardController( ad );
      AmendReview ar =new AmendReview(sd);
      ar.sendMail();
      ar.SelectAll();
      ar.unSelectAll();
      ar.Addaction();
  }
  }