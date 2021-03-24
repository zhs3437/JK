@istest
public class OrdPreviewCtrltest {
    static testMethod void testMethod1() {
        Account acc         = TestHelper.createAccount();
        Product2 p2          = TestHelper.createProduct2();
        Contract c2          = TestHelper.createContract(acc.id);
        PricebookEntry pbe  = TestHelper.createPricebookEntry(p2.id);
        order lm =TestHelper.createOrder();
        lm.Pricebook2Id =Test.getStandardPriceBookID();
        lm.AccountId=acc.id;
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=10;
        update  lm;
        system.debug('lm-->'+lm);
        Information_of_Seller__c is = new Information_of_Seller__c();
        is.Seller__c='JinkoSolar GmbH';
        insert is;
        Standard_Template_Teams__c stt=new Standard_Template_Teams__c();
        stt.Name='Trade_term__c';
        stt.Type__c='Equal';
        stt.Field_Values__c='FCA';
        insert stt;
        Amendment__c ad=new Amendment__c();
        ad.name='V1';
        ad.Order__c=lm.id;
        ad.SELLER__c='JinkoSolar GmbH';
        ad.Buyer__c=acc.id;
        ad.Trade_term__c='FCA';
        ad.Contract__c=c2.id;
        ad.Contract_Owner__c=C2.Ownerid;
        insert ad;
        
        Payment__c p =new Payment__c();
        p.Order__c=lm.id;
        P.Percentage__C=1;
        P.Down_Balance_Payment__c='Down Payment';
        P.Payment_Method__c='T/T';
        P.Payment_Term__c='x% DP X days after the Execution Date';
        p.Days__C=30;
        insert p;
        
        OrderItem o =	TestHelper.createOrderItem(lm.id,pbe.id);
        
        Amendment_Order_Product__c aop =new Amendment_Order_Product__c();
        aop.OriginalOrderItem__c=ad.id;
        aop.id__c=o.id;
        insert aop;
        Amendment_Payment__c pd =new Amendment_Payment__c();
        pd.Amendment_Purchase_Agreement__c=ad.id;
        Pd.Down_Balance_Payment__c='Down Payment';
        Pd.Payment_Method__c='T/T';
         Pd.Percentage__C=100;
        Pd.Payment_Term__c='x% DP X days after the Execution Date';
        pd.Days__c=25;
        pd.id__c=p.id;
        insert pd; 
         Order_Differences__c  OrdDiff = new Order_Differences__c();
            OrdDiff.Amendment_Purchase_Agreement__c = ad.Id;
           
            OrdDiff.Trade_term_New__c = 'EXW';
            OrdDiff.Trade_term_Old__c ='CFR';
        insert OrdDiff;
        
        OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                        OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                        OrderLinDiff.Quantity_New__c =20;
           OrderLinDiff.Quantity_Old__c =10;
        insert OrderLinDiff;
         PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Order_Differences__c = OrdDiff.Id;
                       
                        paydiff.Days_New__c = 10;
        paydiff.Days_New__c = 5;
  //      insert paydiff;
        ApexPages.StandardController con =new ApexPages.StandardController(ad);
        ApexPages.currentPage().getParameters().put('id',ad.id);
        OrdPreviewCtrl op=new OrdPreviewCtrl(con);
        op.test();
        ad.SELLER__c='JinkoSolar GmbH1';
     //   update ad;
        is.Seller__c='JinkoSolar GmbH1';
      //  update is;
        op.setIndividualTeam(stt,ad);
        ad.Trade_term__c='JinkoSolar GmbH1';
     //   update ad;
        stt.Field_Values__c='JinkoSolar GmbH1';
        //update stt;
        op.setIndividualTeam(stt,ad);
        ad.Trade_term__c='CFR';
       // update ad;
        stt.Field_Values__c='CFR';
        stt.Type__c='Contain';
        stt.Name='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c';
      //  update stt;
        op.setIndividualTeam(stt,ad);
        ad.Trade_term__c='EXW';
        
     //   update ad;
     //   op.setIndividualTeam(stt,ad);

      //  OrdPreviewCtrl op2=new OrdPreviewCtrl(con);
     //   Amendment_Payment__c pd2 =new Amendment_Payment__c();
     //           Pd2.Percentage__C=100;
//        pd2.Amendment_Purchase_Agreement__c=ad.id;
      //  Pd2.Down_Balance_Payment__c='Down Payment';
     //   Pd2.Payment_Method__c='T/T';
     //   Pd2.Payment_Term__c='x% DP X days before the BL/Delivery Date';
     //   pd2.Days__c=30;
     //   pd2.id__c=p.id;
      //  insert pd2; 
    //    OrdPreviewCtrl op3=new OrdPreviewCtrl(con);
      //  Pd.Payment_Term__c='x% DP X days after the Execution Date';
     //   update pd;

    //    ad.Trade_term__c='EXW';
      //  update ad;
       // OrdPreviewCtrl op5=new OrdPreviewCtrl(con);


    }
}