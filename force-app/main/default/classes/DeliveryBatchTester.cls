@isTest(seeAllData=false)
private class DeliveryBatchTester {
    
    static testMethod void myUnitTest() {
        
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
        
		List<Order> ordLst = new List<Order>();
        ordLst.add(aOrder);
        Set<ID> Ids = new Set<ID>();
        Ids.add(aOrder.Id); 
       
        Test.startTest();
        //DataBase.executeBatch(new DeliveryBatch(), 1);
        Test.stopTest();
        //DeliveryBatch.DeliveryBatch(Ids); 
        //Database.BatchableContext bc = new Database.BatchableContext();
        //DeliveryBatch.execute(bc, ordLst);       
    }
}