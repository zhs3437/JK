@isTest
private class InventoryTest {
	
	@IsTest(SeeAllData=true)
    static void Test() {
    	SAP_Product__c  SapProduct = new SAP_Product__c();
        SapProduct.Certification__c ='0-NO';
        SapProduct.Color_of_Module__c ='1-Black';
        SapProduct.Type_of_module__c ='MCS-MAXIM_C module';
        SapProduct.Grade__c ='A-Grade A';
        SapProduct.Special_required__c ='0-commonly';
        SapProduct.Bus_bars_of_cell__c ='5-5BB';
        SapProduct.Product_Code__c ='24000014';
        SapProduct.Product_Name__c ='24000014';
        SapProduct.Product_Description__c ='';
        insert SapProduct;
    //	testPrepare tp = new testPrepare();
    	
       SapInventorySearchCtrl sisc = new SapInventorySearchCtrl();
       sisc.runTest();
       
       sapInventory si = new sapInventory();
       si.runTest();
       
   //    SapMap.getPlant('Gebze Warehouse');
   //    SapMap.getWH('Gebze Warehouse');
       
       
       ApplyInventoryHeaderBarCtrl aihb = new ApplyInventoryHeaderBarCtrl();
       aihb.runTest();
       
      // ContractPaymentController cpc = new ContractPaymentController();
      // cpc.runTest();
       /**
       Payment__c pay = new Payment__c();
       pay.Days__c = 1;
       pay.Percentage__c = 20;
       pay.Contract__c = tp.c1.ID;
       pay.Payment_Term__c = 'after month-end of of CMR date';
       pay.Payment_Method__c = 'T/T (Balance)';
       pay.Credit_Valid__c = true;
       insert pay;
       
       OppPaymentController opc = new OppPaymentController(new ApexPages.StandardController(pay));
       opc.runTest();
       */
       ApplyInventoryGenerater aig = new ApplyInventoryGenerater();
       aig.runTest();
       
       QuoteLineItemSync qlis = new QuoteLineItemSync();
       qlis.runTest();
       
      // delete pay;
    }
}