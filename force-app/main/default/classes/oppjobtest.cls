@isTest
public class oppjobtest {
    static testMethod void testBatch(){
        OPPschedulejob dsj = new OPPschedulejob();        
        dsj.execute(null);
    }
    static testMethod void testBatch2(){
        conschedulejob dsj2 = new conschedulejob();        
        dsj2.execute(null);
    }
    static testMethod void testBatch3(){
        MDAschedulejob dsj3 = new MDAschedulejob();        
        dsj3.execute(null);
    }
    static testMethod void testBatch4(){
        orderschedulejob dsj4 = new orderschedulejob();        
        dsj4.execute(null);
    }
    static testMethod void testBatch5(){
        BookstockAutoemail dsj5 = new BookstockAutoemail();        
        dsj5.execute(null);
    }
    static testMethod void deliveryBatch(){
        
        Sapbatchorder.timechange('29');
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        Contract con = TestHelper.createContract(acc.Id);
        con.Opportunity__c=opp.id;
        update con;
        Order aOrder= TestHelper.createOrder(false);   
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
          Sapbatchorder.clickorder(aOrder.id);
    }
}