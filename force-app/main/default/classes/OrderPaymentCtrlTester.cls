/**
 * Create By Jason 20160711
 */
@isTest
private class OrderPaymentCtrlTester {

    static testMethod void myUnitTest() {
    	
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id);
        Payment__c pay = TestHelper.createPayment(opp.Id,false);
		pay.Contract__c  = con.Id;
		pay.CurrencyIsoCode = 'USD';  
		pay.Requested_Number__c = 1111;
		pay.Comments__c = '';
		pay.Credit_Valid__c = true;
		insert pay;
        List<Payment__c> payList = new List<Payment__c>();
        payList.add(pay);
        
        Order ord = TestHelper.createOrder();
        ApexPages.currentPage().getParameters().put('id',ord.Id);
        
        pay.Order__c = ord.Id;
        update pay;
        
        OrderPaymentCtrl opc = new OrderPaymentCtrl(new ApexPages.StandardController(ord));
        
        opc.PaymentModeList();
        opc.savePaymentRequest();
        opc.addPaymentRequest();
        /**
        opc.CancelPaymentRequest();
        opc.editID = pay.Id;
        //opc.saveEditPayment();
        opc.deleteID = pay.Id;
        opc.DeletePay();
       */
    }
}