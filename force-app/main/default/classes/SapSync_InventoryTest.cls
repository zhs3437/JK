@isTest
public class SapSync_InventoryTest {

    static testMethod void Mytest(){
        
        SapSync_Inventory sy_inven = new SapSync_Inventory();
        Inventory__c inven = new Inventory__c();
        insert inven;
        list<Inventory__c> invenLst = new list<Inventory__c>();
        //invenLst.add(inven);
        List<sapEccUnbook.UnbookReturn_element> unbookList = new List<sapEccUnbook.UnbookReturn_element>();
        sapEccUnbook.Unbook_element[] book = new list<sapEccUnbook.Unbook_element>();
        sapEccUnbook.UnbookReturn_element[] returnList  = new list<sapEccUnbook.UnbookReturn_element>();
        Map<String, List<Inventory__c>> InventoryMap = new Map<String, List<Inventory__c>>();
        
        String productName = 'JKM260P-60';
        String SelectWarehouse = 'Transit';
        
        sy_inven.generateData(productName,SelectWarehouse);
        invenLst = sy_inven.sync(productName,SelectWarehouse);
    }
}