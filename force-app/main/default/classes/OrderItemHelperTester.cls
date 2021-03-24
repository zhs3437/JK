/**
 *Create By Jason 20160918
 */
@isTest
private class OrderItemHelperTester {
    @isTest(SeeAllData=true)
    private static void myUnitTest() {

        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe = TestHelper.createPriceBookEntry(p.Id);
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
        
        Order ord = TestHelper.createOrder(false);
        ord.MaxRowNo__c = 10;
        ord.Pricebook2Id =pbe.Pricebook2Id;
        insert ord;
        
        OrderItem ordLine = TestHelper.createOrderItem(false);
        ordLine.OrderId = ord.Id;
        ordLine.PricebookEntryId = pbe.Id;
        ordLine.Quantity = 10;
        ordLine.UnitPrice = 1;
        insert ordLine;
        
        List<OrderItem> ordItemLst = new List<OrderItem>();
        ordItemLst.add(ordLine);
        
        OrderItemHelper.setRowNo(ordItemLst);
    }
}