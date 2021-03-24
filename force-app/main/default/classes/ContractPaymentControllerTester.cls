/**
 *create by Jason 20160711
 */
@isTest
private class ContractPaymentControllerTester {

    static testMethod void myUnitTest() {
    	String requestId;
    	requestId = ApexPages.currentPage().getParameters().get('id');
    	
    	Account acc = TestHelper.createAccount();
    	Opportunity opp = TestHelper.createOpportunity(acc.Id);
    	Payment__c pay = TestHelper.createPayment(opp.Id);
    	List<Payment__c> payList = new List<Payment__c>();
    	payList.add(pay);
    	
    	Contract con = TestHelper.createContract(acc.Id);
    	
    	ContractPaymentController ctrl= new ContractPaymentController();
    	ctrl.runTest();
    }
}