@isTest
public class OA_SyncOrderNoticeTest {
static testMethod void myUnitTest() {
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        Contract con = TestHelper.createContract(acc.Id);
        con.Opportunity__c=opp.id;
        con.Inspection__c='Need';
        update con;
        Order aOrder= new Order();   
        aOrder.Buyer__c = acc.Id;
        aOrder.BillingCountry = 'aaa';
        aOrder.Destination__c ='aaaaaa';
        aOrder.BillingPostalCode = 'bbb';
        aOrder.BillingState = 'ccc';
        aOrder.BillingCity = 'ddd';
    aorder.Shipping_type__c='Land transportation';
aorder.Special__c=true;
    aorder.Warranty_Insurance__c='PG';
        aOrder.CurrencyIsoCode ='USD';
        aOrder.BillingStreet = 'eee';
        aOrder.Contract_No__c = 'MCXXXX13QXtest';
        aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
        aOrder.AccountId = acc.Id;
        aOrder.EffectiveDate = Date.today();
        aOrder.Status = 'Draft';
        aOrder.Pricebook2Id = entry.Pricebook2Id;
        aOrder.ContractId = con.Id;
        aOrder.Trade_term__c = 'EXW';
        insert aOrder;
        String oid=aOrder.id;
        OA_SyncOrderNotice sso = new OA_SyncOrderNotice();

          OrderItem ordItem = TestHelper.createOrderItem(false);
        ordItem.OrderId = aOrder.Id;
        ordItem.Quantity = 10;
        ordItem.PricebookEntryId = entry.Id;
        ordItem.UnitPrice = 1;
        insert ordItem;
        
        Payment__c aPayment = new Payment__c();   
        aPayment.Down_Balance_Payment__c = 'Down Payment';
        aPayment.Percentage__c           =  100;
        aPayment.Days__c                 =  60;
        aPayment.Payment_Method__c       = 'L/C'; 
        aPayment.Payment_Term__c         = 'at sight';
        aPayment.Comments__c             = '';
        aPayment.Credit_Valid__c         = true;
        aPayment.Order__c                = aOrder.Id;
        insert aPayment;
         OA_SyncOrderNotice.generateData(aOrder.Id);
    con.Inspection__c='No Need';
        update con;
            aorder.Warranty_Insurance__c='AR';
    aorder.Shipping_type__c='Ocean transportation';
    update aOrder;
    OA_SyncOrderNotice.generateData(aOrder.Id);
    aorder.Warranty_Insurance__c='No Insurance Required';
    aorder.Shipping_type__c='Air transportation';
    AORDER.Normal__c=FALSE;
    update aOrder;
    OA_SyncOrderNotice.generateData(aOrder.Id);
    }
}