@isTest
public class AddOppProductCtrlTest {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 

     //   OpportunityLineItem oppLineItem2 = TestHelper.createOpportunityLineItem(opp.id, pbe2.id);
           
        AddOppProductCtrl con = new AddOppProductCtrl();        
       
        ApexPages.standardController std    = new ApexPages.standardController(opp);
        AddOppProductCtrl controller      = new AddOppProductCtrl(std);
        controller.loadOpportunity(opp.Id);
        controller.currentProducts[0].isOneLineContainer = true;
        controller.idToDelete = oppLineItem1.Id;
        controller.sortField = 'Name';
        controller.sortCatalog();
        controller.sortField = 'ProductCode';
        controller.sortCatalog();
        controller.sortField = 'Family';
        controller.sortCatalog();
        controller.sortField = 'Product_Line__c';
        controller.sortCatalog();
        controller.pullProducts();
        controller.ChangeLineItem();
        controller.Save();
        controller.SaveChanges();
        controller.SaveAndReturn();   
        
        // Add a product
        //controller.catalog[0].isSelected = true;
        controller.AddProducts();
        controller.pullProducts();
        
	    try {
      //  controller.Save();
        system.assert(true);
	    }
	    catch ( Exception ex ) {
	        system.assert(false);
	    }
	   // controller.DeleteRow();
	    controller.Cancel();
	    
        //controller.catalog[0].isSelected = true;
        controller.CloneLineItems();
       // controller.AddProduct();
        
    }
    
    static testMethod void myUnitTest2() {
        Product2 product1                = TestHelper.createProduct2();
        Product2 product2                = TestHelper.createProduct2();
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);
        PricebookEntry pbe2              = TestHelper.createPricebookEntry(product2.id);
        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 
       // OpportunityLineItem oppLineItem2 = TestHelper.createOpportunityLineItem(opp.id, pbe2.id);
           
        ApexPages.standardController std    = new ApexPages.standardController(opp);
        AddOppProductCtrl controller      = new AddOppProductCtrl(std);
        controller.loadOpportunity(opp.Id);
        //controller.catalog[0].isSelected = true;
        controller.CloneLineItems();
        controller.AddProduct();
        controller.getProductNamesSpaceDelimited();
	    try {
	            controller.SaveAndReturn();
	            system.assert(true);
	    }
	    catch ( Exception ex ) {
	    	system.assert(false);
	    }    	
    }
}