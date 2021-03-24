/**
 *create by： Jason
 *create date : 20160420
 *Description: 当业务机会中 Payment 信息更改时 本业务机会对应的 Payment_Term_Description__c 信息随之改变
 *
 */
@isTest
private class PaymentDescriptionTest {

    static testMethod void paymentIsEmpty() {
		Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'EXW';
		insert opp;
		Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm();
		Payment__c pay = TestHelper.createPayment(opp.Id);
		Opportunity opp2 = [select id,Payment_Term_Description__c,Payment_1MW_Approve__c from Opportunity where id =: opp.Id];
		//system.assert(opp2.Payment_1MW_Approve__c);
		delete pay;
		Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.id;
        insert con;
		pay = TestHelper.createPayment(opp.Id,false);
        pay.Contract__c = con.id;
        insert pay;
    }
    static testMethod void payment1() {
		Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'CIF';
		insert opp;
		Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm();
		Payment__c pay = TestHelper.createPayment(opp.Id);
		Opportunity opp2 = [select id,Payment_Term_Description__c,Payment_1MW_Approve__c from Opportunity where id =: opp.Id];
		//system.assert(opp2.Payment_1MW_Approve__c);
		delete pay;
		Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.id;
        insert con;
		pay = TestHelper.createPayment(opp.Id,false);
        pay.Contract__c = con.id;
        insert pay;
      
    }
     static testMethod void payment2() {
		Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'CIF';
        insert opp;
		Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm();
		Payment__c pay = TestHelper.createPayment(opp.Id);
		Opportunity opp2 = [select id,Payment_Term_Description__c,Payment_1MW_Approve__c from Opportunity where id =: opp.Id];
		delete pay;
         
		Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.id;
        insert con;
		pay = TestHelper.createPayment(opp.Id,false);
        pay.Contract__c = con.id;
        insert pay;
        list<Payment__c> payLst = new list<Payment__c>();
        payLst.add(pay);
        opp.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription(payLst);
        update opp;
    }
    static testMethod void orderPayment() {
        Order ord = TestHelper.createOrder();
		Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm();
        Payment__c pay = new Payment__c();   
        pay.Down_Balance_Payment__c = 'Down Payment';
        pay.Percentage__c           =  100;
        pay.Days__c                 =  60;
        pay.Payment_Method__c       = 'L/C'; 
        pay.Payment_Term__c         = 'at sight';
        pay.Order__c          		= ord.Id; 
        pay.Comments__c				= '';
        pay.Credit_Valid__c		 	= true;
        insert pay;
        Order ord1 = [Select id From Order Where id =: ord.Id];
        delete pay; 
		Payment__c pay1 = new Payment__c();
        pay1.Down_Balance_Payment__c = 'Down Payment';
        pay1.Percentage__c           =  100;
        pay1.Days__c                 =  60;
        pay1.Payment_Method__c       = 'L/C'; 
        pay1.Payment_Term__c         = 'at sight';
        pay1.Order__c          		= ord.Id; 
        pay1.Comments__c				= '';
        pay1.Credit_Valid__c		 	= true;
        pay1.Order__c = ord.Id;
        insert pay1;
        list<Payment__c> payLst = new list<Payment__c>();
        payLst.add(pay1);
        ord.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription(payLst);
        update ord;
    }
}