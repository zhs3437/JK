@isTest
public class Sap_BiDataCtrlTest {
static testMethod void myUnitTest() {
          String name = 'test' + Math.random() + '@example.org';
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
     User u1 = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
        User u = new User();
            u.alias = 'testuser';
            u.email=name;
            u.emailencodingkey='UTF-8';
            u.lastname='Testing';
            u.languagelocalekey='en_US';
            u.localesidkey='en_US';
            u.profileid = p.id;
            u.timezonesidkey='America/Los_Angeles';
            u.username=name;
            u.communityNickname = 'test' + Math.random();
            u.BMO_specialist__c = u1.Id;
        insert u;
     Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
    	RecordType rtt = [select id,name from RecordType where name=:'Order Fulfillment' limit 1];
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        //opp.Actual_Commission__c = 123;
        opp.Commission_Payee__c='123455';
    	opp.RecordTypeId=rtt.id;
        Contract con = TestHelper.createContract(acc.Id);

    	con.OwnerId = u.id;
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
    	aPayment.Opportunity__c = opp.id;
        aPayment.Down_Balance_Payment__c = 'Down Payment';
        aPayment.Percentage__c           =  100;
        aPayment.Days__c                 =  60;
        aPayment.Payment_Method__c       = 'L/C'; 
        aPayment.Payment_Term__c         = 'at sight';
        aPayment.Comments__c             = '';
        aPayment.Credit_Valid__c         = true;
        aPayment.Order__c                = aOrder.Id;
        insert aPayment;
    
    

       
        
        Order ord = TestHelper.createOrder(false);
        ord.Contract_Owner__c = u.Id;
        insert ord;

        //Account acc = TestHelper.createAccount();
        //Contract con = TestHelper.createContract(acc.Id,false);
        //con.Contract_NO__c = '2016101000';
        //insert con;
        Component_Task_Book__c ctb = TestHelper.createComponentTaskBook(con,false);
        insert ctb;
         
    
    Sap_BiDataCtrl abb = new Sap_BiDataCtrl();
   Sap_BiDataCtrl.BiData(con.id);
    abb.test();
    Sap_GetBiData.T_INPUT_element a = new Sap_GetBiData.T_INPUT_element();
    Sap_BiData_Batch sbb = new Sap_BiData_Batch();
    Sap_BiData_execute sbe = new Sap_BiData_execute();
    sbb.test();
    sbe.test();
  }
    static testMethod void myUnitTest2() {
          String name = 'test' + Math.random() + '@example.org';
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
     User u1 = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
        User u = new User();
            u.alias = 'testuser';
            u.email=name;
            u.emailencodingkey='UTF-8';
            u.lastname='Testing';
            u.languagelocalekey='en_US';
            u.localesidkey='en_US';
            u.profileid = p.id;
            u.timezonesidkey='America/Los_Angeles';
            u.username=name;
            u.communityNickname = 'test' + Math.random();
            u.BMO_specialist__c = u1.Id;
        insert u;
     Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
    	RecordType rtt = [select id,name from RecordType where name=:'Order Fulfillment' limit 1];
        Opportunity opp = TestHelper.createOpportunity(acc.id);
    	opp.RecordTypeId=rtt.id;
        Contract con = TestHelper.createContract(acc.Id);
    	con.OwnerId = u.id;
        con.Opportunity__c=opp.id;
        update con;
      
        
      
        
        Payment__c aPayment = new Payment__c();   
    	aPayment.Opportunity__c = opp.id;
        aPayment.Down_Balance_Payment__c = 'Down Payment';
        aPayment.Percentage__c           =  100;
        aPayment.Days__c                 =  60;
        aPayment.Payment_Method__c       = 'L/C'; 
        aPayment.Payment_Term__c         = 'at sight';
        aPayment.Comments__c             = '';
        aPayment.Credit_Valid__c         = true;
       
        insert aPayment;
    
    

       
        
        

        //Account acc = TestHelper.createAccount();
        //Contract con = TestHelper.createContract(acc.Id,false);
        //con.Contract_NO__c = '2016101000';
        //insert con;
        Component_Task_Book__c ctb = TestHelper.createComponentTaskBook(con,false);  
        insert ctb;
         
    
    Sap_BiDataCtrl abb = new Sap_BiDataCtrl();
   Sap_BiDataCtrl.BiData(con.id);
    abb.test();
    Sap_GetBiData.T_INPUT_element a = new Sap_GetBiData.T_INPUT_element();
    Sap_BiData_Batch sbb = new Sap_BiData_Batch();
    Sap_BiData_execute sbe = new Sap_BiData_execute();
    sbb.test();
    sbe.test();
  }
    
}