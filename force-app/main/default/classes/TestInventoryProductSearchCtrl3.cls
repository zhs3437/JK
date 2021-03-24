/**
* @author huangxy
*/
@isTest
private class TestInventoryProductSearchCtrl3 {

    /**
     * This is a test method for InventoryProductSearchCtrl3.History
     */

    static testMethod void test_History() {
        Test.startTest();

		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();


        Test.stopTest();

    }


    /**
     * This is a test method for hac
     */
    static testMethod void test_hac() {
ApexPages.standardController std    = null;
        InventoryProductSearchCtrl3 controller      = new InventoryProductSearchCtrl3(std);


        Test.startTest();

		Distribution_Stock__c tip = null;
		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
		history.hac(tip);


        Test.stopTest();

    }


    /**
     * This is a test method for InventoryModeList
     */
    static testMethod void test_InventoryModeList() {



        Test.startTest();
        
        Inventory__c iv = new Inventory__c();
     List<Inventory__c> icLst = new List<Inventory__c>();
         if(iv!=null){
             icLst.add(iv);
         }
         Integer dsLstSize = 0;
    
         Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
        aic.Warehouse__c = null;
         aic.Product_Type__c = p.id;
         insert aic;
        Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 10;
        ic.MAKTX__c = null;
        insert ic;
      
          List<Inventory__c> invLst = new List<Inventory__c>();  
    String deleteID = null;
    String bookID = null;
    String editID   =null;
    String requestQuantity  = null;
    Distribution_Stock__c ds = new Distribution_Stock__c();
        ds.Apply_Inventory__c = aic.Id;
         ds.Inventory__c = ic.id;
         ds.Distribution_Quantity__c = 200;
        ds.isSelect_c__c = true;
        ds.Product_Type__c = p.Id;
         insert ds;
          List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>();
             gl.add(ds);

    String Status = null;
     User us = new  User();
     String qua = null;
          InventoryProductSearchCtrl3.History a=new  InventoryProductSearchCtrl3.History();
          a.ID  = '1';
          a.isSelect = true;
         a.hac(ds);
   
		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
	system.debug('aic.Id-->'+aic.Id);
       ApexPages.currentPage().getParameters().put('id', aic.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aic);
        InventoryProductSearchCtrl3 IPS = new InventoryProductSearchCtrl3(sc);
        IPS.InventoryModeList();
        IPS.SyncSAPCreateDN();
        IPS.saveEditPayment();
        Test.stopTest();

    }
    static testMethod void test_goSpilitAndaddItem(){
        
        Inventory__c iv = new Inventory__c();
     List<Inventory__c> icLst = new List<Inventory__c>();
         if(iv!=null){
             icLst.add(iv);
         }
         Integer dsLstSize = 0;
    
         Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
        aic.Warehouse__c = null;
         aic.Product_Type__c = p.id;
         insert aic;
        Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 10;
        ic.MAKTX__c = null;
        insert ic;
      
          List<Inventory__c> invLst = new List<Inventory__c>();  
    String deleteID = null;
    String bookID = null;
    String editID   =null;
    String requestQuantity  = null;
    Distribution_Stock__c ds = new Distribution_Stock__c();
        ds.Apply_Inventory__c = aic.Id;
         ds.Inventory__c = ic.id;
         ds.Distribution_Quantity__c = 200;
        ds.isSelect_c__c = true;
         ds.Product_Type__c = p.Id;
         insert ds;
          List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>();
             gl.add(ds);

    String Status = null;
     User us = new  User();
     String qua = null;
          InventoryProductSearchCtrl3.History a=new  InventoryProductSearchCtrl3.History();
          a.ID  = '1';
          a.isSelect = true;
         a.hac(ds);
   
		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
	system.debug('aic.Id-->'+aic.Id);
       ApexPages.currentPage().getParameters().put('id', aic.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aic);
        InventoryProductSearchCtrl3 IPS = new InventoryProductSearchCtrl3(sc);
        IPS.goSpilit();
        IPS.saveSplitItem();
        IPS.addItem();
    }
    static testMethod void test_SyncSAPChangeStatus(){
        Test.startTest();
        
        Inventory__c iv = new Inventory__c();
     List<Inventory__c> icLst = new List<Inventory__c>();
         if(iv!=null){
             icLst.add(iv);
         }
         Integer dsLstSize = 0;
    
         Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
         aic.Product_Type__c = p.id;
        aic.Warehouse__c = null;
         insert aic;
        Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 10;
        ic.MAKTX__c = null;
        insert ic;
      
          List<Inventory__c> invLst = new List<Inventory__c>();  
    String deleteID = null;
    String bookID = null;
    String editID   =null;
    String requestQuantity  = null;
    Distribution_Stock__c ds = new Distribution_Stock__c();
        ds.Apply_Inventory__c = aic.Id;
         ds.Inventory__c = ic.id;
         ds.Distribution_Quantity__c = 200;
         ds.Product_Type__c = p.Id;
        ds.isSelect_c__c = true;
         insert ds;
          List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>();
             gl.add(ds);

    String Status = null;
     User us = new  User();
     String qua = null;
          InventoryProductSearchCtrl3.History a=new  InventoryProductSearchCtrl3.History();
          a.ID  = '1';
          a.isSelect = true;
         a.hac(ds);
   
		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
	system.debug('aic.Id-->'+aic.Id);
       ApexPages.currentPage().getParameters().put('id', aic.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aic);
        InventoryProductSearchCtrl3 IPS = new InventoryProductSearchCtrl3(sc);
        IPS.SyncSAPChangeStatus();
    }
    static testMethod void test_SyncSAPCancelDN(){
        Inventory__c iv = new Inventory__c();
     List<Inventory__c> icLst = new List<Inventory__c>();
         if(iv!=null){
             icLst.add(iv);
         }
         Integer dsLstSize = 0;
    
         Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
        aic.Product_Type__c = p.id;
        aic.Warehouse__c = null;
         insert aic;
        Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 10;
        ic.MAKTX__c = null;
        insert ic;
      
          List<Inventory__c> invLst = new List<Inventory__c>();  
    String deleteID = null;
    String bookID = null;
    String editID   =null;
    String requestQuantity  = null;
    Distribution_Stock__c ds = new Distribution_Stock__c();
        ds.Apply_Inventory__c = aic.Id;
         ds.Inventory__c = ic.id;
         ds.Distribution_Quantity__c = 200;
         ds.isSelect_c__c = true;
         ds.Product_Type__c = p.Id;
         insert ds;
          List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>();
             gl.add(ds);

    String Status = null;
     User us = new  User();
     String qua = null;
          InventoryProductSearchCtrl3.History a=new  InventoryProductSearchCtrl3.History();
          a.ID  = '1';
          a.isSelect = true;
         a.hac(ds);
   
		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
	system.debug('aic.Id-->'+aic.Id);
       ApexPages.currentPage().getParameters().put('id', aic.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aic);
        InventoryProductSearchCtrl3 IPS = new InventoryProductSearchCtrl3(sc);
        IPS.SyncSAPCancelDN();
    }

    /**
     * This is a test method for CancelPaymentRequest
     */
    static testMethod void test_CancelPaymentRequest() {
ApexPages.standardController std    = null;
        InventoryProductSearchCtrl3 controller      = new InventoryProductSearchCtrl3(std);
        Test.startTest();

		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
		PageReference resultCancelPaymentRequest = controller.CancelPaymentRequest();


        Test.stopTest();


    }


    /**
     * This is a test method for SyncSAPCompleteStatus
     */
    static testMethod void test_SyncSAPCompleteStatus() {
ApexPages.standardController std    = null;
        InventoryProductSearchCtrl3 controller      = new InventoryProductSearchCtrl3(std);
        Test.startTest();

		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
		PageReference resultSyncSAPCompleteStatus = controller.SyncSAPCompleteStatus();


        Test.stopTest();


    }
/**
    static testMethod void test_SyncSAPWareHouseStatus() {
      ApexPages.standardController std    = null;
        InventoryProductSearchCtrl3 controller      = new InventoryProductSearchCtrl3(std);


        Test.startTest();

		InventoryProductSearchCtrl3.History history = new InventoryProductSearchCtrl3.History();
		PageReference resultSyncSAPWareHouseStatus = controller.SyncSAPWareHouseStatus();


        Test.stopTest();

    }
*/



  

}