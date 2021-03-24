@isTest
public class oppjobtest {
    static testMethod void deliveryBatch(){
        SchedulableContext sc = null;
        OPPschedulejob dsj = new OPPschedulejob();        
        dsj.execute(sc);
        conschedulejob dsj2 = new conschedulejob();        
        dsj2.execute(sc);
        MDAschedulejob dsj3 = new MDAschedulejob();        
        dsj3.execute(sc);
         orderschedulejob dsj4 = new orderschedulejob();        
        dsj4.execute(sc);
         BookstockAutoemail dsj5 = new BookstockAutoemail();        
        dsj5.execute(sc);
        
        Sapbatchorder.timechange('29');
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        Contract con = TestHelper.createContract(acc.Id);
        con.Opportunity__c=opp.id;
        update con;
        Order aOrder= new Order();   
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