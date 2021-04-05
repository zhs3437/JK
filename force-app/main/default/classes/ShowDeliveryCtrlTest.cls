@isTest
private class ShowDeliveryCtrlTest {

    static testMethod void myUnitTest() {
    	
    	Account acc = TestHelper.createAccount();
    	
    	Order aOrder = TestHelper.createOrder(false);   
	    aOrder.Buyer__c = acc.Id;
	    aOrder.Contract_No__c = 'MCXXXX13QXtest';
	    aOrder.AccountId = acc.Id;
	    aOrder.EffectiveDate = Date.today();
	    aOrder.Status = 'Draft';
		insert aOrder;
    	
    	ApexPages.currentPage().getParameters().put('orderid',aOrder.Id);
    	
    	ShowDeliveryCtrl ctrl = new ShowDeliveryCtrl();
    	ctrl.ModeList();
    }
}