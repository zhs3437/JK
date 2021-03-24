/**
 *Create By Jason 20160713
 */
@isTest
private class SpilitToolCtrlTester {

    static testMethod void spilitTooltrue() {
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
        list<OrderItem> ordLst = new list<OrderItem>();
        ordLst.add(ordItem);
        
        
        OrderItem  ordItem1 = TestHelper.createOrderItem(false);
        ordItem1.OrderId = ord.Id;
        ordItem1.Quantity = 100;
        ordItem1.Unit_Price__c = 1;
        ordItem1.UnitPrice = 1;
        ordItem1.PricebookEntryId = priceBookEntry.Id;
        system.debug('pricebookId' + priceBookEntry.Id + 'pricebookID' + ordItem1.PricebookEntryId);
        insert ordItem1;
        list<OrderItem> ordLst1 = new list<OrderItem>();
        ordLst1.add(ordItem1);
        
        SpilitToolCtrl stc = new SpilitToolCtrl();
        stc.requestItemId = ordItem.Id;
        stc.orderItemList = ordLst;
        stc.spilitItemList = ordLst1;
        stc.requestPricebookEntryId = priceBookEntry.Id;
        stc.requestQuantity = '3';
        stc.currentItem = ordItem;
        
        stc.goSpilit();
        stc.modeBasicData();
        stc.addItem();
        stc.remove();
        stc.reSelect();
        stc.saveItems();
    }
   
}