@isTest
public class TestSAPPassTest {

    static testMethod void myTest(){
        
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
        dStock.Status__c = 'Booked';
        dStock.Status_Old__c = 'Unbook';
        dStock.SAP_W_H__c ='testAddress';
        dStock.BL_No__c = '0000001';
        dStock.Product_Type__c = prod.id;
        dStock.SAP_Materiel_No__c = '00000001';
        
        insert dStock;
        
        list<String> dStockLst = new list<String>();
        dStockLst.add(dStock.id);
        
        SAPPassTest.getDisStock(aInventory.id);
        SAPPassTest.getDisStockAlone1(dStockLst);
        
        List<Distribution_Stock__c> DisStockList = new List<Distribution_Stock__c>();
        DisStockList.add(dStock);
        
        SapNewEccStatusChange.StatusChangeReturn_element sapNESC_SCR = new SapNewEccStatusChange.StatusChangeReturn_element();
        List<SapNewEccStatusChange.StatusChangeReturn_element> SapNewReturn = new  List<SapNewEccStatusChange.StatusChangeReturn_element>();
        SapNewReturn.add(sapNESC_SCR);
        
        SapSync_StatusChange StatusChange_tool = new SapSync_StatusChange();
        Test.setMock(WebServiceMock.class, new SapUnbookWebServiceMock());
        StatusChange_tool.generateData(DisStockList);
        SapNewReturn = StatusChange_tool.sync();
        
    }
}