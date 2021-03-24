/**
* @author huangxy
*/
@isTest
private class TestInventoryCtrlTest {

    /**
     * This is a test method for TestInventoryProductCtrl.History
     */
    static testMethod void test_History() {

        // PageReference pageRef = Page.TestInventoryProductCtrl.History;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		TestInventoryProductCtrl.History history = new TestInventoryProductCtrl.History();


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for hac
     */
    static testMethod void test_hac() {

        // PageReference pageRef = Page.TestInventoryProductCtrl.History;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		Inventory__c tip = null;
		TestInventoryProductCtrl.History history = new TestInventoryProductCtrl.History();
		history.hac(tip);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for CancelPaymentRequest
     */
    static testMethod void test_CancelPaymentRequest() {

        // PageReference pageRef = Page.TestInventoryProductCtrl.History;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();
        ApexPages.standardController std    = null;
        TestInventoryProductCtrl controller      = new TestInventoryProductCtrl(std);
		TestInventoryProductCtrl.History history = new TestInventoryProductCtrl.History();
		PageReference resultCancelPaymentRequest = controller.CancelPaymentRequest();


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for all
     */
    static testMethod void test_all() {

        // PageReference pageRef = Page.TestInventoryProductCtrl.History;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		//  test TestInventoryProductCtrl.History
		TestInventoryProductCtrl.History history = new TestInventoryProductCtrl.History();

		Inventory__c tip = null;
		//  test hac
		history.hac(tip);

		//  test CancelPaymentRequest
		  ApexPages.standardController std    = null;
        TestInventoryProductCtrl controller      = new TestInventoryProductCtrl(std);
		PageReference resultCancelPaymentRequest = controller.CancelPaymentRequest();



        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }

static testMethod void myTest(){
        Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
       aic.Product_Type__c = p.Id;
        aic.Warehouse__c = null;
        insert aic;
        Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 1;
        ic.MAKTX__c = null;
        ic.InputNumber__c = '2';
        ic.isSelect_c__c = true;
        insert ic;
        Inventory__c ics = new Inventory__c();
        ics.Product_Type__c = p.id;
        ics.Warehouse2__c = 'Kobe';
        ics.BL_NO__c = null;
        ics.Quantity__c = 10;
        ics.MAKTX__c = null;
        ics.InputNumber__c = '2';
        ics.isSelect_c__c = true;
        insert ics;
        
        List<Inventory__c> invLst = new List<Inventory__c>();
            invLst.add(ic);
            invLst.add(ics);        
        system.debug('invLst'+invLst.size());
        String editID = null;
        List<String> keyID = new List<id>();
        String deleteID = null;
        String saveID = null;
        String bookID = null;
    String requestId=opp.Id;
        Distribution_Stock__c ds = new Distribution_Stock__c();
        ds.Apply_Inventory__c = aic.id;
        ds.Inventory__c = ic.Id;
        ds.Distribution_Quantity__c = 200;
        ds.Product_Type__c = p.Id;
        insert ds;
        List<Distribution_Stock__c> dsLst = new List<Distribution_Stock__c>();
        dsLst.add(ds);
        TestInventoryProductCtrl.History a=new  TestInventoryProductCtrl.History();
        a.isSelect = true;
        a.hac(ic);
        Integer invListSize = 0;
        system.debug('a.invList'+a.invList.size());
        if(a.invList.size()>0){
              TestInventoryProductCtrl.History h = new  TestInventoryProductCtrl.History();
            invListSize = a.invList.size();
        }
    TestInventoryProductCtrl.History history = new TestInventoryProductCtrl.History();
	system.debug('aic.Id-->'+aic.Id);
   // String productName = 'JK250P-60';
   // String isSelectwarehouse = 'Kobe';
    
       ApexPages.currentPage().getParameters().put('id', aic.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aic);
        TestInventoryProductCtrl IPS = new TestInventoryProductCtrl(sc);
        IPS.productName = 'JK250P-60';
        IPS.warehouse = 'Kobe';
        //SapSync_Inventory si = new SapSync_Inventory();        
        //Test.setMock(WebServiceMock.class, new TestInventorySAPData());
       // String productName = 'JK250P-60';
        //String warehouse = 'Kobe';
       // TestInventorySAPData tis = new TestInventorySAPData();
        //ApexPages.standardController std    = new ApexPages.standardController(aic);
        //TestInventoryProductCtrl controller      = new TestInventoryProductCtrl(std);
        
        IPS.CancelPaymentRequest();
        IPS.SearchProduct();
        IPS.CancelPaymentRequest();
       delete ds;
        //IPS.Book();
        //IPS.saveEditPayment();
    }

}