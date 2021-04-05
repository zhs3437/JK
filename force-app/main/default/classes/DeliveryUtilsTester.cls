@isTest
private class DeliveryUtilsTester {
    
    @isTest static void myUnitTest() { 
    //static testMethod void myUnitTest(){
        Account acc = TestHelper.createAccount();
        Order aOrder= TestHelper.createOrder(false);
        aOrder.Buyer__c = acc.Id;
        aOrder.BillingCountry = 'aaa';
        aOrder.BillingPostalCode = 'bbb';
        aOrder.BillingState = 'ccc';
        aOrder.BillingCity = 'ddd';
        aOrder.BillingStreet = 'eee';
        aOrder.Contract_No__c = 'MCXXXX13QXtest';
        aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
        aOrder.AccountId = acc.Id;
        aOrder.EffectiveDate = Date.today();
        aOrder.Status = 'Draft';
        insert aOrder;
        
        List<Order> ordLst = new List<Order>();
        ordLst.add(aOrder);
        
        Test.setMock(WebServiceMock.class, new DeliveryUtilswebServiceTester());
        // Call the method that invokes a callout
        /*
        Double x = 1.0;
        
        Double y = 2.0;
        
        Double result = DeliveryUtils.add(x, y);
        */
        
        DeliveryUtils ssd = new DeliveryUtils();
        ssd.Addaction();
       // ssd.sync(ordLst);
    }
}