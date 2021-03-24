@isTest
public class SapSync_CompleteStatusTest {

    static testMethod void myTest(){
        SapSync_CompleteStatus ss_CS = new SapSync_CompleteStatus();
        SapEccCompleteStatus.CompleteStatus_element SECS_CS_e = new SapEccCompleteStatus.CompleteStatus_element();
        list<SapEccCompleteStatus.CompleteStatus_element> SECS_CS_eLst = new list<SapEccCompleteStatus.CompleteStatus_element>();
        SECS_CS_eLst.add(SECS_CS_e);
        SapEccCompleteStatus.CompleteStatusReturn_element[] returnList =  new List<SapEccCompleteStatus.CompleteStatusReturn_element>();
        SapEccCompleteStatus.Item_element[] ItemLst = new List<SapEccCompleteStatus.Item_element>();
        
      

        
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
        
        Distribution_Stock__c dStock = new Distribution_Stock__c();
        dStock.Apply_Inventory__c = aInventory.Id;
        dStock.Inventory__c = inven.id;
        dStock.Distribution_Quantity__c = 5;
        dStock.Order__c = aOrder.id;
        dStock.Product_Type__c =  prod.Id;
        insert dStock;
        
        List<Distribution_Stock__c> syncDisStockLst = new List<Distribution_Stock__c>();
        syncDisStockLst.add(dStock);
        
        ss_CS.generateData();
        ss_CS.sync(syncDisStockLst);
    }
}