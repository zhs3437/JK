@isTest
private class TestHelperTest {
	static testMethod void myUnitTest() {
		Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity o       = TestHelper.createOpportunity(acc.id);
	  //  Contract con        = TestHelper.createContract(acc.Id);
        Quote q				= TestHelper.createQuote(o.Id);
        Order ord 			= TestHelper.createOrder();
        TestHelper.createOpportunityLineItem(o.id, pbe.id);
	    TestHelper.createCampaign();
		//TestHelper.createLead();
		TestHelper.createContact();
		TestHelper.createTask();
		User u = TestHelper.createSystemAdminUser();
		
		Product_Detail__c prodtail = TestHelper.createProductDetail(false);
		//prodtail.Contract_PO_PI__c = con.Id;
		//insert prodtail;
		TestHelper.createTradeTermPaymentTerm();
		TestHelper.createApplyInventory();
		TestHelper.createPayment(o.Id);
		TestHelper.createAmendment();
		TestHelper.createSubmitForReview();
		TestHelper.createOrderItem(false);
       // TestHelper.createQuote(o.Id);
        //TestHelper.createQuoteLineItem(q.id, pbe.id);
        //TestHelper.createOrderItem(ord.Id,pbe.Id);
        //TestHelper.createInventory();
        //TestHelper.createComponentTaskBook(ord);
       // TestHelper.createComponentTaskBook(con);
       // TestHelper.createDocument();
	}
}