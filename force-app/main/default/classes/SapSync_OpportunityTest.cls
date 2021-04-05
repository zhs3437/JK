@isTest
public class SapSync_OpportunityTest {
    @isTest
    private static void myUnitTest() {
        
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        opp.Customer_Delivery_Date__c=date.today();
        opp.Confirmed_ETD__c=date.today();
        opp.StageName ='Prospecting';
        opp.IsNDA__c=true;
        opp.Warehouse_or_Factory__c='Warehouse';
        opp.Warranty_Insurance__c='No Insurance Required';
        opp.Warranty_On_Material_and_Workmanship__c='None for B grade product';
        opp.Opportunity_Type__c='Frame';
        //opp.Sales_type__c='Utility';
        //opp.Seller__c='Jinko Solar Import and Export Co., Ltd.';
        update opp;
        //Contract con = TestHelper.createContract(acc.Id);
       // con.Opportunity__c=opp.id;
        //update con;
        Order aOrder = TestHelper.createOrder(false);   
        aOrder.Buyer__c = acc.Id;
        aOrder.BillingCountry = 'aaa';
        aOrder.Destination__c ='aaaaaa';
        aOrder.BillingPostalCode = 'bbb';
        aOrder.BillingState = 'ccc';
        aOrder.BillingCity = 'ddd';
        aOrder.CurrencyIsoCode ='USD';
        aOrder.BillingStreet = 'eee';
        aOrder.Contract_No__c = 'MCXXXX13QXtest';
        aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
        aOrder.AccountId = acc.Id;
        aOrder.EffectiveDate = Date.today();
        aOrder.Status = 'Draft';
        aOrder.Pricebook2Id = entry.Pricebook2Id;
        //aOrder.ContractId = con.Id;
        aOrder.Trade_term__c = 'EXW';
        insert aOrder;
        OpportunityLineItem opplineitem = new OpportunityLineItem();
        opplineitem.OpportunityId=opp.Id;
        opplineitem.Amend_Date__c=date.today();
        opplineitem.Back_Sheet__c='123';
        opplineitem.UnitPrice=123;
        opplineitem.Quantity=12;
        opplineitem.Guaranteed_Delivery_Date__c=date.today();
        opplineitem.PricebookEntryId=entry.Id;
        opplineitem.MP__c='Mono';
        opplineitem.Cheetah__c=true;
        opplineitem.Support_mixed_delivery__c=true;
        opplineitem.Stock_age__c='≥6个月';
        insert opplineitem;
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
        //aPayment.Order__c                = aOrder.Id;
        aPayment.Opportunity__c= opp.id;
        
        
        insert aPayment;
        Test.startTest(); 
        SapSync_Opportunity.getOpportunityInfo(opp.id);
                SAPBATCHOPP.getOpportunityInfo(opp.id);
        Test.stopTest();
       // SapSync_Opportunity.getUserInfo();
    }
        @isTest
    private static void myUnitTest2() {
        
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        opp.Customer_Delivery_Date__c=date.today();
        opp.Confirmed_ETD__c=date.today();
        opp.StageName ='Price Quote';
        opp.IsNDA__c=true;
        opp.Warehouse_or_Factory__c='Warehouse';
        opp.Warranty_Insurance__c='No Insurance Required';
        opp.Warranty_On_Material_and_Workmanship__c='None for B grade product';
        opp.Opportunity_Type__c='Single';
        //opp.Seller__c='Jinko Solar Import and Export Co., Ltd.';
        update opp;
        //Contract con = TestHelper.createContract(acc.Id);
       // con.Opportunity__c=opp.id;
        //update con;
        Order aOrder = TestHelper.createOrder(false);   
        aOrder.Buyer__c = acc.Id;
        aOrder.BillingCountry = 'aaa';
        aOrder.Destination__c ='aaaaaa';
        aOrder.BillingPostalCode = 'bbb';
        aOrder.BillingState = 'ccc';
        aOrder.BillingCity = 'ddd';
        aOrder.CurrencyIsoCode ='USD';
        aOrder.BillingStreet = 'eee';
        aOrder.Contract_No__c = 'MCXXXX13QXtest';
        aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
        aOrder.AccountId = acc.Id;
        aOrder.EffectiveDate = Date.today();
        aOrder.Status = 'Draft';
        aOrder.Pricebook2Id = entry.Pricebook2Id;
        //aOrder.ContractId = con.Id;
        aOrder.Trade_term__c = 'EXW';
        insert aOrder;
        OpportunityLineItem opplineitem = new OpportunityLineItem();
        opplineitem.OpportunityId=opp.Id;
        opplineitem.Amend_Date__c=date.today();
        opplineitem.Back_Sheet__c='123';
        opplineitem.UnitPrice=123;
        opplineitem.Quantity=12;
        opplineitem.Guaranteed_Delivery_Date__c=date.today();
        opplineitem.PricebookEntryId=entry.Id;
        opplineitem.MP__c='Mono';
        opplineitem.Cheetah__c=true;
        opplineitem.Support_mixed_delivery__c=true;
        opplineitem.Stock_age__c='≥6个月';
        insert opplineitem;
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
        //aPayment.Order__c                = aOrder.Id;
        aPayment.Opportunity__c= opp.id;
        
        
        insert aPayment;
        Test.startTest(); 
        SapSync_Opportunity.getOpportunityInfo(opp.id);
        SAPBATCHOPP.getOpportunityInfo(opp.id);
        Test.stopTest();
    }
      
   
}