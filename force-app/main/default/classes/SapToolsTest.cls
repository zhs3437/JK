@isTest
private class SapToolsTest {

    static testMethod void myUnitTest() {
    	
    	// bastic data
    	Product2 prod = TestHelper.createProduct2();
		PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
    	
    	Account acc = TestHelper.createAccount();
    	
    	Contract con = TestHelper.createContract(acc.Id);
    	
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
		insert ordItem;
		
		Payment__c aPayment = new Payment__c();   
	    aPayment.Down_Balance_Payment__c = 'Down Payment';
	    aPayment.Percentage__c           =  100;
	    aPayment.Days__c                 =  60;
	    aPayment.Payment_Method__c       = 'L/C'; 
	    aPayment.Payment_Term__c         = 'at sight';
		aPayment.Comments__c			 = '';
		aPayment.Credit_Valid__c		 = true;
		aPayment.Order__c                = aOrder.Id;
		insert aPayment;
    	
       Apply_Inventory__c aInventory = new Apply_Inventory__c();
        aInventory.Product_Type__c = prod.Id;
        insert aInventory;
        
        Inventory__c inven = new Inventory__c();
        inven.Product_Type__c = prod.id;
        insert inven;
        
        Distribution_Stock__c dStock = new Distribution_Stock__c();
        dStock.Apply_Inventory__c = aInventory.Id;
        dStock.Inventory__c = inven.id;
        dStock.Distribution_Quantity__c = 5;
        dStock.Order__c = aOrder.id;
        dStock.Product_Type__c =  prod.id;
        insert dStock;
        
    	// Log
    	Log__c log = new Log__c();
    	insert log;
        
        list<Log__c> uploadLogList = new list<Log__c>();
        uploadLogList.add(log);
        
        SapTools st = new SapTools();
        
        //SapTools.uploadLogList.add(log);
        SapTools.uploadList();
        system.debug('-2');
        /**
        SapTools.syncOrder(aOrder.Id);
        system.debug('-1');
        SapTools.getDelivery(aOrder.Id);
        system.debug('0');
        acc.SAP_External_ID__c = '123';
        update acc;
        SapTools.syncOrder(aOrder.Id);
        system.debug('1');
        SapTools.getCompleteStatus(aInventory.id);
        system.debug('2');
       // SapTools.getWareHouseChange(aInventory.id);
        SapTools.getSAPCreateDN(aOrder.id);
        system.debug('3');
        SapTools.getSAPCancelDN(aOrder.id);
        system.debug('4');
        
        list<String> idLst = new list<String>();
        idLst.add(dStock.Id);
        SapTools.getSAPNewCreateDN(aOrder.Id,idLst);
        system.debug('5');
      //  SapTools.getSAPNewCancelDN(aOrder.Id,idLst);
        SapTools.OASync(aOrder.Id);
        system.debug('6');
**/
    }
}