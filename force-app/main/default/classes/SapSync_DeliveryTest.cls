@isTest
private class SapSync_DeliveryTest {

    static testMethod void myUnitTest() {
		SapSync_Delivery ssd = new SapSync_Delivery();
		Account acc = TestHelper.createAccount();
		Order aOrder= new Order();   
	    aOrder.Buyer__c = acc.Id;
	    aOrder.BillingCountry = 'aaa';
	    aOrder.BillingPostalCode = 'bbb';
	    aOrder.BillingState = 'ccc';
	    aOrder.BillingCity = 'ddd';
	    aOrder.BillingStreet = 'eee';
	    aOrder.Contract_No__c = 'MCXXXX13QXtest';
	    aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
	    aOrder.AccountId = acc.Id;
	    aOrder.EffectiveDate = Date.today();
	    aOrder.Status = 'Draft';
		insert aOrder;
		
		ssd.generateData(aOrder);
		ssd.sync();
    }
}