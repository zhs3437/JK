/**
* create By jason 20160923
*/
@isTest
private class OpprortuntiyHeaderBarCtrlTester {
    @isTest(SeeAllData=true)
    private static  void hasInventer() {
        
        Account acc = TestHelper.createAccount(false);
        acc.Name = 'Account Name';
        insert acc;
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        opp.Name = '2MW-JKM180-20120101';
        opp.CloseDate = Date.today();
        opp.AccountId=acc.id;
        opp.Region__c = 'North Asia';
        opp.StageName='Close Won';
        opp.Probability=100;
        opp.Local_Warehouse__c = 'shanghai';
        insert opp;
        
        Opportunity opp1 = TestHelper.createOpportunity(acc.Id, false);
        opp1.name='2MW-JKM180-20120101';
        opp1.CloseDate = Date.today();
        opp1.AccountId=acc.id;
        opp1.Region__c = 'North Asia';
        opp1.StageName='Close Won';
        opp1.Probability=100;
        opp1.Local_Warehouse__c = 'beijing';
        insert opp1;
        
        Product2 p1 = TestHelper.createProduct2(false);
        p1.ProductCode = 'testProduct';
        p1.Name = 'JKM-260';
        insert p1;
  
        Pricebook2 pb = [Select Id From Pricebook2 Where id =: '01s90000000KiqiAAC'];//Name = 'Standard Price Book' limit 1];
           
        PricebookEntry pbe = TestHelper.createPriceBookEntry(p1.Id, false);
        pbe.Product2Id=p1.Id;
        pbe.Pricebook2Id=pb.Id;
        pbe.UnitPrice=10;
        pbe.UseStandardPrice=false;
        pbe.IsActive=true;
        insert pbe;
               /**
        OpportunityLineItem oppLine = TestHelper.createOpportunityLineItem(opp.Id, pbe.Id, false);
        oppLine.OpportunityId 		= opp.Id;
        oppLine.Quantity			= 100;
        oppLine.Total_Price__c		= 1000;
        oppLine.TotalPrice       	= 1000;
        oppLine.PricebookEntryId 	= pbe.Id;
        insert oppLine;
        
        OpportunityLineItem oppLine1 = TestHelper.createOpportunityLineItem(opp1.Id, pbe.Id, false); 
        oppLine1.OpportunityId 		= opp.Id;
        oppLine1.Quantity           = 20;
        oppLine1.Total_Price__c     = 1000;
        oppLine1.TotalPrice       	= 1000;
        oppLine1.PricebookEntryId   = pbe.Id;
        insert oppLine1;
          */
        Inventory__c inv = TestHelper.createInventory(false);
        inv.Warehouse2__c        = 'shanghai';
        inv.Quantity__c          =  99;
        insert inv;
        
        Inventory__c inv1 = TestHelper.createInventory(false);
        inv1.Warehouse2__c        = 'beijing';
        inv1.Quantity__c          =  99;
        insert inv1;
  
       InventoryHelper.checkInventory('shanghai','111',10);
        InventoryHelper.checkInventory('beijing','222',2);
        //ID id = Apexpages.currentPage().getParameters(opp.id); 
        //Apexpages.StandardSetControlle ohbc = new Apexpages.StandardSetControlle(id);
        OpprortuntiyHeaderBarCtrl ctrl =new OpprortuntiyHeaderBarCtrl();
        ctrl.opp = opp;
        ctrl.hasInventory();
        ctrl.hasNotInventory();
        ctrl.hasTransit();
        ctrl.hasNoProductCode();
        ctrl.submitTransit();
        ctrl.runTest();
        
    }
}