@isTest
public class InventoryProductSearchCtrl3Test {
     static testMethod void myTest(){
         ApexPages.standardController std    = null;
        InventoryProductSearchCtrl3 controller      = new InventoryProductSearchCtrl3(std);
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
         String requestId = aic.id;
    String deleteID = null;
    String bookID = null;
    String editID   =null;
    String requestQuantity  = null;
    Distribution_Stock__c ds = new Distribution_Stock__c();
         ds.Apply_Inventory__c = requestId;
         ds.Inventory__c = ic.id;
         ds.Distribution_Quantity__c = 200;
          ds.Product_Type__c = p.id;
         insert ds;
     List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>();
             gl.add(ds);
         update gl;
         
         controller.InventoryModeList();
    String Status = null;
     User us = new  User();
     String qua = null;
          InventoryProductSearchCtrl3.History a=new  InventoryProductSearchCtrl3.History();
          a.ID  = '1';
          a.isSelect = false;
         a.hac(ds);
        
         
         
         
         controller.saveEditPayment();
         controller.CancelPaymentRequest();
         //controller.SyncSAPChangeStatus();
         controller.SyncSAPCompleteStatus();
         //controller.SyncSAPCreateDN();
         //controller.SyncSAPCancelDN();
     }
}