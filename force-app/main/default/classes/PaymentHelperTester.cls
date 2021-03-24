@isTest
private class PaymentHelperTester {
	//@IsTest(SeeAllData=true)
    static testMethod void retrivePaymentDescription1() {
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c = 'CIF';
        insert opp;
        Payment__c pay = TestHelper.createPayment(opp.Id, false);
        pay.Down_Balance_Payment__c = 'Down Payment';
        pay.Percentage__c           =  100;
        pay.Days__c                 =  60;
        pay.Payment_Method__c       = 'L/C'; 
        pay.Payment_Term__c         = 'at sight';
        pay.Comments__c				= '';
        pay.Credit_Valid__c		 	= true;
        insert pay;
        List<Payment__c> payList = new List<Payment__c>();
        payList.add(pay);
        Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm(false);
        ttapt.Guaranteed_Delivery_Date__c = 'Date.today()';
        insert ttapt;
        
        PaymentHelper.retrivePaymentDescription(payList, pay.Opp_Trade_Term__c, true);
        pay.Down_Balance_Payment__c = 'Balance Payment';
        pay.Payment_Term__c         = 'before delivery from seller’s  warehouse';
        update pay;
        payList.add(pay);
        PaymentHelper.retrivePaymentDescription(payList, pay.Opp_Trade_Term__c, true);
    }
    static testMethod void retrivePaymentDescription2() {
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c = 'CIF';
        insert opp;
        Payment__c pay1 = TestHelper.createPayment(opp.Id, false);
        pay1.Down_Balance_Payment__c = 'Down Payment';
        pay1.Percentage__c           =  90;
        pay1.Days__c                 =  60;
        pay1.Payment_Method__c       = 'L/C'; 
        pay1.Payment_Term__c         = 'at sight';
        pay1.Comments__c			 = '';
        pay1.Credit_Valid__c		 = true;
        insert pay1;
        Payment__c pay2 = TestHelper.createPayment(opp.Id, false);
        pay2.Down_Balance_Payment__c = 'Down Payment';
        pay2.Percentage__c           =  10;
        pay2.Days__c                 =  60;
        pay2.Payment_Method__c       = 'L/C'; 
        pay2.Payment_Term__c         = 'at sight';
        pay2.Comments__c			 = '';
        pay2.Credit_Valid__c		 = true;
        insert pay2;
        List<Payment__c> payLists = new List<Payment__c>();
        payLists.add(pay1);
        payLists.add(pay2);
        Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm(false);
        ttapt.Guaranteed_Delivery_Date__c = 'Date.today()';
        insert ttapt;
        PaymentHelper.retrivePaymentDescription(payLists, pay1.Opp_Trade_Term__c, true);
        pay2.Down_Balance_Payment__c = 'Balance Payment';
        pay2.Payment_Method__c		 = 'L/C';
         pay2.Payment_Term__c        = 'at sight';
        pay2.Days__c				 = 10;
        pay2.Payment_Term__c		 = 'before delivery from seller’s  warehouse';
        update pay2;
        payLists.add(pay2);
		PaymentHelper.retrivePaymentDescription(payLists, pay1.Opp_Trade_Term__c, true); 
        pay2.Down_Balance_Payment__c = 'Balance Payment';
        pay2.Payment_Method__c		 = 'T/T (Balance)';
        pay2.Days__c				 = 10;
        pay2.Payment_Term__c		 = 'before ETD';
        update pay2;
        payLists.add(pay2);
		PaymentHelper.retrivePaymentDescription(payLists, pay1.Opp_Trade_Term__c, true); 
        
        
    }
    static testMethod void retrivePaymentDescription3() {
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c = 'CIF';
        insert opp;
        Payment__c pay1 = TestHelper.createPayment(opp.Id, false);
        pay1.Down_Balance_Payment__c = 'Balance Payment';
        pay1.Percentage__c           =  90;
        pay1.Days__c                 =  60;
        pay1.Payment_Method__c       = 'L/C'; 
        pay1.Payment_Term__c         = 'at sight';
        pay1.Comments__c			 = '';
        pay1.Credit_Valid__c		 = true;
        insert pay1;
        Payment__c pay2 = TestHelper.createPayment(opp.Id, false);
        pay2.Down_Balance_Payment__c = 'Down Payment';
        pay2.Percentage__c           =  10;
        pay2.Days__c                 =  60;
        pay2.Payment_Method__c       = 'L/C'; 
        pay2.Payment_Term__c         = 'at sight';
        pay2.Comments__c			 = '';
        pay2.Credit_Valid__c		 = true;
        insert pay2;
        List<Payment__c> payLists = new List<Payment__c>();
        payLists.add(pay1);
        payLists.add(pay2);
        Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm(false);
        ttapt.Guaranteed_Delivery_Date__c = 'Date.today()';
        insert ttapt;
        PaymentHelper.retrivePaymentDescription(payLists, pay1.Opp_Trade_Term__c, true);
        pay2.Down_Balance_Payment__c = 'Balance Payment';
        update pay2;
        payLists.add(pay2);
        PaymentHelper.retrivePaymentDescription(payLists, pay1.Opp_Trade_Term__c, true);
        PaymentHelper.retriveGuaranteedDeliveryDate(pay1.Opp_Trade_Term__c);
    }
}