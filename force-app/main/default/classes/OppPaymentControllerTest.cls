@isTest
private class OppPaymentControllerTest {
    static testMethod void myUnitTest() {
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Payment__c pay = TestHelper.createPayment(opp.Id,false);
        pay.CurrencyIsoCode = 'USD';  
        pay.Requested_Number__c = 1111;
        pay.Comments__c = '';
        pay.Credit_Valid__c = true;
        insert pay;
        
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        OppPaymentController ctrl = new OppPaymentController(new ApexPages.StandardController(new Opportunity()));
        ctrl.PaymentModeList();
        ctrl.savePaymentRequest();
        ctrl.addPaymentRequest();
        ctrl.CancelPaymentRequest();
        ctrl.deleteID = pay.Id;
        ctrl.DeletePay();
        ctrl.runTest();
    }
}