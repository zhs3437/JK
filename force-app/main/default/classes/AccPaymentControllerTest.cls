@isTest
private class AccPaymentControllerTest {
	static testMethod void myUnitTest() {
		
		Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Payment__c pay = TestHelper.createPayment(opp.Id,false);
		pay.CurrencyIsoCode = 'USD';  
		pay.Requested_Number__c = 1111;
		pay.Comments__c = '';
		pay.Credit_Valid__c = true;
		insert pay;
		
		ApexPages.currentPage().getParameters().put('id',acc.Id);
		AccPaymentController ctrl = new AccPaymentController(new ApexPages.StandardController(new Account()));
		ctrl.PaymentModeList();
		ctrl.savePaymentRequest();
		ctrl.addPaymentRequest();
		ctrl.CancelPaymentRequest();
		ctrl.deleteID = pay.Id;
		ctrl.DeletePay();
		ctrl.runTest();
	}
}