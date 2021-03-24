@isTest
public class BatchOppSendEmailTest {
    static testMethod void deliveryBatch(){
        Account acc = TestHelper.createAccount();
    	Account acc1 = TestHelper.createAccount();
    	
    	Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 3000;
        Date d = Date.valueOf('2020-02-01');
        item.Guaranteed_Delivery_Date__c = d;
        insert item;

        Profile pf = [select id from profile where name='BD' limit 1];
        system.debug('p------>'+pf);
        User user = TestHelper.createUser(Pf.id,'test800208@qq.com',true);
        List<User> list_user = new List<User>();
        list_user.add(user);
        BatchOppSendEmail b = new BatchOppSendEmail();
        SchedulableContext bd;
        b.execute(bd);
        Database.BatchableContext ba;
        b.execute(ba, list_user);
    }
}