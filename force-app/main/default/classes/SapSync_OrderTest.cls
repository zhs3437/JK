@isTest
public without sharing class SapSync_OrderTest {

    static testMethod void myUnitTest() {
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        Order aOrder;
        System.runAs(admin){
            Product2 prod = QW_TestDataFactory.createProduct2();
            insert prod;
            SAP_Product__c sapproduct = QW_TestDataFactory.createSAPProduct();
            sapproduct.Product_Name__c = prod.Name;
            insert sapproduct;

            PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
            
            Account acc = TestHelper.createAccount();
            Opportunity opp = TestHelper.createOpportunity(acc.id);
            Contract con = TestHelper.createContract(acc.Id);
            con.Opportunity__c=opp.id;
            update con;

            aOrder = TestHelper.createOrder(false);   
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
            aOrder.ContractId = con.Id;
            aOrder.Trade_term__c = 'EXW';
            insert aOrder;
            
            OrderItem ordItem = TestHelper.createOrderItem(false);
            ordItem.OrderId = aOrder.Id;
            ordItem.Quantity = 10;
            ordItem.PricebookEntryId = entry.Id;
            ordItem.UnitPrice = 1;
            insert ordItem;
            
            Component_Task_Book__c ctb2 = TestHelper.createComponentTaskBook(con,false);
            ctb2.Order__c = aOrder.Id;
            ctb2.ModuleType1__c = prod.Id;
            ctb2.Frame_B_side_Height__c = '30mm frame';
            ctb2.Frame_Color__c = 'Silver';
            ctb2.Module_Level__c = 'A级';
            TriggerHandler.clearBypass('RC_MDABasicHandler');
            TriggerHandler.clearBypass('RC_MDAReassignHandler');
            insert ctb2;
            
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
        }
        Test.startTest();
        SapSync_Order sso = new SapSync_Order();
        sso.generateData(aOrder);
        sso.sync('msg');
    }
}