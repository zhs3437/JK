/**
 * 
 * create by fanzr 20161228
 *
 */
@isTest
private class OrderNoticeControllerTester {
    @isTest(SeeAllData=true)	
    private static void myUnitTest() {
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id);
        Product2 p = TestHelper.createProduct2();
        PricebookEntry pbe = TestHelper.createPriceBookEntry(p.Id);
        
        Order ord = TestHelper.createOrder(false);
        ord.Contract_No__c = con.Id;
        ord.SAP_External_ID__c = '11111';
        ord.Buyer__c = acc.Id;
        ord.Pricebook2Id = pbe.Pricebook2Id;
        insert ord;
        
        OrderItem ordLine = TestHelper.createOrderItem(false);
        ordLine.OrderId = ord.Id;
        ordLine.PricebookEntryId = pbe.Id;
        ordLine.Quantity = 10;
        insert ordLine;
        
        ApexPages.currentPage().getParameters().put('id',ord.Id);
        ApexPages.StandardController std=new ApexPages.StandardController(ord);
        OrderNoticeController onc=new OrderNoticeController(std);
        onc.tod =Date.today();
        onc.requestId = ord.Id;
        onc.orderItemList = Database.query(Utils.MakeSelectSql('OrderItem'));
        onc.runTest();
    }
}