@isTest
public class SapSync_CreateDnTest {

    static testMethod void myTest(){
        
        SapSync_CreateDn ss_CD = new SapSync_CreateDn();
        SapEccCreateDn.CreateDn_element SECD_CD_e = new SapEccCreateDn.CreateDn_element();
        list<SapEccCreateDn.CreateDn_element> SECS_CS_eLst = new list<SapEccCreateDn.CreateDn_element>();
        SECS_CS_eLst.add(SECD_CD_e);
        SapEccCreateDn.CreateDnReturn_element[] returnList =  new List<SapEccCreateDn.CreateDnReturn_element>();
        
        Log__c log = new Log__c();
    	insert log;
        list<Log__c> lst_log = new list<Log__c>();
        lst_log.add(log);
        
        Product2 prod = TestHelper.createProduct2();
		PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
    	
    	Account acc = TestHelper.createAccount();
    	
    	Contract con = TestHelper.createContract(acc.Id);
        
        Apply_Inventory__c aInventory = new Apply_Inventory__c();
        aInventory.Product_Type__c = prod.Id;
        insert aInventory;
        
        Inventory__c inven = new Inventory__c();
        inven.Product_Type__c = prod.id;
        insert inven;
        
        
        
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
	    aOrder.Pricebook2Id = entry.Pricebook2Id;
	    aOrder.ContractId = con.Id;
	    aOrder.Trade_term__c = 'EXW';
        aOrder.SAP_Order_ID__c = 'test0001';
		insert aOrder;
        
        OrderItem ordItem = TestHelper.createOrderItem(false);
		ordItem.OrderId = aOrder.Id;
		ordItem.Quantity = 10;
		ordItem.PricebookEntryId = entry.Id;
		ordItem.UnitPrice = 1;
        ordItem.Guaranteed_Delivery_Date__c = Date.today();
		insert ordItem;
        list<OrderItem> oItemLst = new list<OrderItem>();
        oItemLst.add(ordItem);
        
        Distribution_Stock__c dStock = new Distribution_Stock__c();
        dStock.Apply_Inventory__c = aInventory.Id;
        dStock.Inventory__c = inven.id;
        dStock.Distribution_Quantity__c = 5;
        dStock.Order__c = aOrder.id;
        dStock.Status__c = 'Released';
        dStock.Date_of_delivery__c = Date.today();
        dStock.Product_Type__c = prod.id;
        //dStock.SAP_Delivery_order_no__c = '';
        insert dStock;
        
        List<Distribution_Stock__c> syncDisStockLst = new List<Distribution_Stock__c>();
        syncDisStockLst.add(dStock);
        
        String DNStatus ='CA';
        ss_CD.generateData(DNStatus);
        
        
        
        
        
        returnList = ss_CD.sync(syncDisStockLst, oItemLst);
        
    }
}