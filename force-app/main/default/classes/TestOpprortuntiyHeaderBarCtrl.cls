@IsTest
public class TestOpprortuntiyHeaderBarCtrl{
	/*
    private static void hasInventer(){
    	test.startTest();
        Account acc = new Account();
    	acc.Name = 'Account Name';
    	insert acc;
    	
        Opportunity opp = new Opportunity(name='2MW-JKM180-20120101',CloseDate = Date.today(), AccountId=acc.id,Region__c = 'Asia Pacific',
        									StageName='Close Won',Probability=100,Local_Warehouse__c = 'shanghai');
      	insert opp;
        
        Opportunity opp1 = new Opportunity(name='2MW-JKM180-20120101',CloseDate = Date.today(), AccountId=acc.id,Region__c = 'Asia Pacific',
        									StageName='Close Won',Probability=100,Local_Warehouse__c = 'beijing' );
	  	insert opp1;
        
        Product2 p1 = new Product2(ProductCode = 'testProduct', Name = 'JKM-260');
        insert p1;
        
        Pricebook2 pb = [Select Id From Pricebook2 Where Name = 'Standard Price Book' limit 1];
        
        PricebookEntry pbe = new PricebookEntry(Product2Id=p1.Id,Pricebook2Id=pb.Id,UnitPrice=10,UseStandardPrice=false,IsActive=true);
        insert pbe;
        
        OpportunityLineItem itemLine = new OpportunityLineItem();
        itemLine.OpportunityId = opp.Id;
        //itemLine.SAP_Materiel_No__c = '111';
        itemLine.Quantity           = 100;
        itemLine.Total_Price__c     = 1000;
        itemLine.TotalPrice       = 1000;
    	itemLine.PricebookEntryId = pbe.Id;
    	System.debug('########Total_Price__c' + itemLine.Total_Price__c);
    	
        insert itemLine;
        
       
        OpportunityLineItem itemLine1 = new  OpportunityLineItem();
        itemLine1.OpportunityId = opp.Id;
        //itemLine1.SAP_Materiel_No__c = '222';
        itemLine1.Quantity           = 20;
        itemLine1.Total_Price__c     = 1000;
        itemLine1.TotalPrice       = 1000;
        itemLine1.PricebookEntryId   = pbe.Id;
        insert itemLine1;
       
        
        Inventory__c inv = new Inventory__c();
        inv.Warehouse2__c        = 'shanghai';
        //inv.SAP_Materiel_No__c   = '111';
        inv.Quantity__c          =  99;
        insert inv;
       
        
        Inventory__c inv1 = new Inventory__c();
        inv1.Warehouse2__c        = 'beijing';
        //inv1.SAP_Materiel_No__c   = '222';
        inv1.Quantity__c          =  99;
        insert inv1;
        
        InventoryHelper.checkInventory('shanghai','111',100);
        InventoryHelper.checkInventory('beijing','222',20);
        
        OpprortuntiyHeaderBarCtrl ctrl =new OpprortuntiyHeaderBarCtrl();
        ctrl.opp = opp;
        
        ctrl.hasInventory();
        System.debug('###################################ctrl.hasInventory();' + ctrl.hasInventory());
        ctrl.hasNotInventory();
        System.debug('###################################ctrl.hasNotInventory();' + ctrl.hasNotInventory());
    	ctrl.hasTransit();
    	System.debug('###################################ctrl.hasTransit();' + ctrl.hasTransit());
    	//ctrl.runTest();
    	test.stopTest();
    }
*/
}