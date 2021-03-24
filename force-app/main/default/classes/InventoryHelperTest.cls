@isTest
public class InventoryHelperTest {
    private static testMethod void checkInventory(){
        Inventory__c inv1 = TestHelper.createInventory();
        Inventory__c inv2 = TestHelper.createInventory(false);
        inv2.Warehouse2__c = 'Beijing';
        inv2.SAP_Materiel_No__c = '1234';
        inv2.Quantity__c = 10;
        insert inv2;
        system.assertEquals(true, InventoryHelper.checkInventory('Beijing','1234',10));
        system.assertEquals(false, InventoryHelper.checkInventory('Beijing','1234',100));
        system.assertEquals(false, InventoryHelper.checkInventory('Shanghai','1234',5));
    }
    
    private static testMethod void checkTranist(){
        Inventory__c inv1 = TestHelper.createInventory();
        Inventory__c inv2 = TestHelper.createInventory(false);
        inv2.Warehouse2__c          = 'Beijing';
        inv2.SAP_Materiel_No__c     = '1234';
        inv2.Quantity__c            =  10;
        inv2.Special_Stock_No__c    = 'T005';
        insert inv2;
        system.assertEquals(true, InventoryHelper.checkTranist('Beijing','1234',10));
        system.assertEquals(false, InventoryHelper.checkTranist('Beijing','1234',100));
        system.assertEquals(false, InventoryHelper.checkTranist('Shanghai','1234',5));
    }
    
    private static testMethod void getSAPproductCode(){
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Product2 p2 = TestHelper.createProduct2();
        PricebookEntry pbe = TestHelper.createPriceBookEntry(p2.Id);
        OpportunityLineItem oppItem = TestHelper.createOpportunityLineItem(opp.Id, pbe.Id, false);
        oppItem.Certification__c 	= '1-TUV';
        oppItem.Color_of_Module__c 	= '2-White';
        oppItem.Type_of_module__c 	= 'NS-Non smart module';
        oppItem.Grade__c 			= 'A-Grade A';
        oppItem.Special_required__c = 'J4-Black Silicon Module';
        oppItem.Bus_bars_of_cell__c = '4-4BB';
        oppItem.Product_Name__c		= 'JKM280PP-60-J4';
        //oppItem.SAP_Materiel_No__c = '24002820';
        insert oppItem;
        List<OpportunityLineItem> oppItemLst = new List<OpportunityLineItem>();
        oppItemLst.add(oppItem);
        SAP_Product__c sap = new SAP_Product__c();
        sap.Certification__c 		= '1-TUV';
        sap.Color_of_Module__c 		= '2-White';
        sap.Type_of_module__c		= 'NS-Non smart module';
        sap.Grade__c 				= 'A-Grade A';
        sap.Special_required__c 	= 'J4-Black Silicon Module';
        sap.Bus_bars_of_cell__c 	= '4-4BB';
        sap.Product_Code__c 		= '24002820';
        sap.Product_Name__c 		= 'JKM280PP-60-J4';
        sap.Product_Description__c 	= 'JKM280PP-60-J4/4BB/TUV/A';
        insert sap;
        List<SAP_Product__c> sapLst = new List<SAP_Product__c>();
        sapLst.add(sap);
        InventoryHelper.getSAPproductCode(opp.Id);
        //system.assertEquals(true, InventoryHelper.getSAPproductCode(opp.Id));
    }
    
    private static testMethod void getSAPproductCodeOrder(){
        
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        Order aOrder= TestHelper.createOrder(false);   
        aOrder.Pricebook2Id = entry.Pricebook2Id;
        insert aOrder;
        OrderItem ordItem = TestHelper.createOrderItem(false);
        ordItem.OrderId 						= aOrder.Id;
        ordItem.PricebookEntryId 				= entry.Id;
        ordItem.Quantity 						= 100;
        ordItem.Certification__c 				= '1-TUV';
        ordItem.Color_of_frame_and_backsheet__c = '2-White';
        ordItem.Type_of_module__c 				= 'NS-Non smart module';
        ordItem.Grade__c 						= 'A-Grade A';
        ordItem.Special_required__c 			= 'J4-Black Silicon Module';
        ordItem.Bus_bars_of_cell__c 			= '4-4BB';
        //ordItem.Product_Name__c 				= 'JKM280PP-60-J4';
        //ordItem.SAP_Materiel_No__c 			= '24002820';
        ordItem.UnitPrice						= 1;
        insert ordItem;
        
        List<OrderItem> ordItemLst = new List<OrderItem>();
        ordItemLst.add(ordItem);
        SAP_Product__c sap = new SAP_Product__c();
        sap.Certification__c 		= '1-TUV';
        sap.Color_of_Module__c 		= '2-White';
        sap.Type_of_module__c 		= 'NS-Non smart module';
        sap.Grade__c 				= 'A-Grade A';
        sap.Special_required__c 	= 'J4-Black Silicon Module';
        sap.Bus_bars_of_cell__c 	= '4-4BB';
        sap.Product_Code__c 		= '24002820';
        sap.Product_Name__c 		= 'JKM280PP-60-J4';
        sap.Product_Description__c 	= 'JKM280PP-60-J4/4BB/TUV/A';
        insert sap;
        List<SAP_Product__c> sapLst = new List<SAP_Product__c>();
        sapLst.add(sap);
        InventoryHelper.getSAPproductCodeOrder(aOrder.Id);
        //system.assertEquals(true, InventoryHelper.getSAPproductCodeOrder(aOrder.Id));
    }
    
    private static testMethod void autoBookInventory(){
        Account acc = TestHelper.createAccount();
        Product2 p1 = TestHelper.createProduct2();
        Apply_Inventory__c ai1 = TestHelper.createApplyInventory();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        PricebookEntry pbe = TestHelper.createPriceBookEntry(p1.Id);
        OpportunityLineItem line = TestHelper.createOpportunityLineItem(opp.Id, pbe.Id);
        Apply_Inventory__c ai2 = TestHelper.createApplyInventory(false);
        ai2.Status__c          = 'Close';  
        ai2.Material_No__c     = '123';
        ai2.Quantity__c        = 500;
        ai2.Due_Date__c        = Date.today();
        ai2.Reminder_Date__c   = Date.today()- 1;  
        insert ai2;
        List<Apply_Inventory__c> aiLst = new List<Apply_Inventory__c>();
        aiLst.add(ai2);
        system.assertEquals(false, InventoryHelper.autoBookInventory('001'));
        InventoryHelper ih = new InventoryHelper();
        ih.runTest();
    }
}