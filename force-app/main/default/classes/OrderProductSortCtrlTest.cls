@isTest
public class OrderProductSortCtrlTest {
    static testmethod void test(){
        Product2 product = TestHelper.createProduct2();
		PricebookEntry priceBookEntry = TestHelper.createPriceBookEntry(product.Id, true);
		Order ord = TestHelper.createOrder(false);
        ord.Pricebook2Id = priceBookEntry.Pricebook2Id;
        insert ord; 
		OrderItem  ordItem = TestHelper.createOrderItem(false);
        ordItem.OrderId = ord.Id;
        ordItem.Quantity = 100;
        ordItem.Unit_Price__c = 1;
        ordItem.UnitPrice = 1;
        ordItem.PricebookEntryId = priceBookEntry.Id;
        system.debug('pricebookId' + priceBookEntry.Id + 'pricebookID' + ordItem.PricebookEntryId);
        insert ordItem;
        OrderItem  ordItem1 = TestHelper.createOrderItem(false);
        ordItem1.OrderId = ord.Id;
        ordItem1.Quantity = 100;
        ordItem1.Unit_Price__c = 1;
        ordItem1.UnitPrice = 1;
        ordItem1.PricebookEntryId = priceBookEntry.Id;
        system.debug('pricebookId' + priceBookEntry.Id + 'pricebookID' + ordItem.PricebookEntryId);
        insert ordItem1;
        List<order> orderLst = new List<order>();
        orderLst.add(ord);
        ApexPages.currentPage().getParameters().put('id',ord.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(orderLst);
        OrderProductSortCtrl mdpc = new OrderProductSortCtrl(ctrl);
        mdpc.ChangedId = '0';
        mdpc.UpDataList();
        mdpc.TopDataList();
        mdpc.DownDataList();
        mdpc.TailDataList();
        mdpc.doSave();     
        
       
        }
}