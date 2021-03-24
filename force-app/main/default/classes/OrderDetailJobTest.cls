@istest
public class OrderDetailJobTest {
    static testMethod void myTest(){
        Product2 product = TestHelper.createProduct2();
        PricebookEntry priceBookEntry = TestHelper.createPriceBookEntry(product.Id);
        order lm =TestHelper.createOrder();
        lm.Pricebook2Id =Test.getStandardPriceBookID();
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=10;
        
        update  lm;
        OrderItem oi =	TestHelper.createOrderItem(lm.id,priceBookEntry.id);
        oi.Guaranteed_Delivery_Date__c=Date.newInstance(2018,1,26);
        update  oi;
        Delivery__c a =new Delivery__c();
        a.order__C=lm.id;
        A.Delivery_Date__c=Date.newInstance(2018,1,26);
        insert a;
        OrderDetail__c od2= new OrderDetail__c();
        insert od2;
        OrderDetailJob2 od =new OrderDetailJob2();
        SchedulableContext sc;
        
        
        od.execute(sc);
    }
}