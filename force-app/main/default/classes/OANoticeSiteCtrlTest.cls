@isTest
public class OANoticeSiteCtrlTest {
    static testMethod void myUnitTest() {
         Log__c log = new Log__c(
            Type__c='Order',
            StartTime__c = System.now()
        ); 
        
        string oasta = 'Success';   //OA审批订单状态         
            
         Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        Contract conn = TestHelper.createContract(acc.Id);
        conn.Opportunity__c=opp.id;
        conn.Inspection__c='Need';
        update conn;
        Order aOrder= TestHelper.createOrder(false);   
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
        aOrder.ContractId = conn.Id;
        aOrder.Trade_term__c = 'EXW';
        aOrder.OA_Notice_NO__c= '100037';
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
        string con = aOrder.OA_Notice_NO__c;  
        OANoticeSiteCtrl oc =new OANoticeSiteCtrl();
        oc.createObj();
    }
    static testMethod void myUnitTest2() {
        
        
        string oasta = 'Success';   //OA审批订单状态         
            
         Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        Contract conn = TestHelper.createContract(acc.Id);
        conn.Opportunity__c=opp.id;
        conn.Inspection__c='Need';
        update conn;
        Order aOrder= TestHelper.createOrder(false);   
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
        aOrder.ContractId = conn.Id;
        aOrder.Trade_term__c = 'EXW';
        aOrder.OA_Notice_NO__c= '100037';
        aOrder.OA_Notice_Status__c='';
        
        insert aOrder;
       
        string con = '100037';  
        ApexPages.currentPage().getParameters().put('con','a'); 
        OANoticeSiteCtrl oc =new OANoticeSiteCtrl();
        oc.createObj();
    }
}