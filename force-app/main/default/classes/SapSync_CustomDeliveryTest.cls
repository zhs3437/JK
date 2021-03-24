@isTest
public class SapSync_CustomDeliveryTest {
    static testMethod void myTest(){
         Product2 prod = TestHelper.createProduct2();
        
        Inventory__c inven = new Inventory__c();
        inven.Product_Type__c = prod.id;
        insert inven;
        Customer_Book_Inventory__c cbI1 = new  Customer_Book_Inventory__c();
      //  dStock.Apply_Inventory__c = aInventory.Id;
      //  cbI1.Inventory__c = inven.id;
        cbI1.Distribution_Quantity__c = 5;
       // dStock.Order__c = aOrder.id;
        cbI1.Status__c = 'Released';
        cbI1.Date_of_delivery__c = Date.today();
        cbI1.Product__c = prod.id;
        //dStock.SAP_Delivery_order_no__c = '';
        insert cbI1;
        List<Customer_Book_Inventory__c> cbILst = new List<Customer_Book_Inventory__c>();
        cbILst.add(cbI1);
           SapSync_CustomDelivery ss_CD = new SapSync_CustomDelivery();
        
          ss_CD.generateData(cbILst);
        
         ss_CD.sync();
        
        List<String> IDList = new List<String>();
        IDList.add(cbI1.Id);
        SAPCustomDelivery scd = new SAPCustomDelivery();
        SAPCustomDelivery.getDisStockAlone1(IDList);
        SAPCustomDelivery.runTest();
    }

}