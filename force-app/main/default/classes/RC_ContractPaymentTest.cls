@isTest
public class RC_ContractPaymentTest {
    static testMethod void maninTest() { 
        Account a = new Account();
        a.VAT_NO__c = 'ABC';
        a.Name = 'Jinko SOlar Company';
        a.Phone = '13615827359';
        a.Website = 'www.jinko.com';
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('China_Account').getRecordTypeId();
        System.debug('RecordTypeId----------->'+RecordTypeId);
        a.RecordTypeId = RecordTypeId;
        a.Bank_Account__c = '中国银行';
        a.Bank_City__c = '上海';
        a.Bank_Code__c = '12345';
        a.Bank_Country__c = '中国';
        //a.Bank_Name__c = '虹口支行';
        a.Bank_Region__c = 'CN';
        a.Bank_Street__c = '上海市虹口区密云路2333号';    	
        a.BillingCity = '上海市';
        a.BillingCountry = '中国';
        a.BillingState = 'Test';
        a.BillingStreet = 'Test';
        Insert a;
        Contact cc = new Contact();         
        cc.Phone = '13615827359';
        cc.AccountId = a.id;
        cc.FirstName = 'Guang';
        cc.LastName = 'AWEJ';         
        insert cc;    	    
        leanx__pm_Project__c opp = new leanx__pm_Project__c();
        opp.Expect_Price_And_Comments__c = '12345';       
        opp.Name = '12345'; 
        opp.CurrencyIsoCode = 'CNY';
        opp.leanx__Account__c = a.id;
        opp.Trade_Term__c = 'CIF';                  
        opp.Destination_Country__c = 'China';
        opp.Destination_Region__c = 'CN';       
        opp.Delivery_Point__c = '手提';
        opp.Seller__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        opp.Warranty_Insurance__c = 'AR';     
        opp.Commission__c = 0.1;
        opp.Commission_Type__c = 'Per/W';              
        Insert opp;
        leanx__lg_Contract__c con = new leanx__lg_Contract__c();
        con.How_Many_Days_After_Payment__c = 7;
        con.Delivery_Point__c = 'Shanghai';
        con.Contract_NO__c = 'WWWCSGRWERG';
        con.Stage__c = 'Contract Negotiation';
        con.Project__c = opp.id;
        con.Expect_Price_And_Comments__c = '12345';       
        //con.Name = '12345'; 
        con.CurrencyIsoCode = 'CNY';
        con.leanx__Account__c = a.id;
        con.Trade_Term__c = 'CIF';                  
        con.Destination_Country__c = 'China';
        con.Destination_Region__c = 'CN';
        con.Seller__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        con.Warranty_Insurance__c = 'AR';     
        con.Commission__c = 0.1;
        con.Commission_Type__c = 'Per/W';              
        Insert con;       
        Payment__c pay = new Payment__c();
        pay.Days__c = 10;
        pay.Percentage__c = 100;
        pay.Payment_Stage_China__c = '发货款';
        pay.Payment_Method_China__c = '电汇';
        pay.Payment_Term_China__c = '发货前全款';
        pay.PaymentDescription__c = '批次发货，发货前支付100%批次发货款';
        pay.China_Contract__c = con.id;
        insert pay;    
        List<Payment__c> payList = new List<Payment__c>();
    	payList.add(pay);
        ApexPages.currentPage().getParameters().put('id', con.id);     
        // ApexPages.StandardSetController sc = new ApexPages.StandardSetController(con);
        RC_ContractPaymentController c = new RC_ContractPaymentController();
       	
        c.getPaymentGridData();
        c.setPaymentGridData(payList);
        c.savePaymentRequest();
        c.CancelPaymentRequest();
       
        c.PaymentModeList();        
        c.savePaymentRequest();
        pay.Percentage__c = 95;
       
        c.addPaymentRequest();
       c.getPaymentStatusText();
         c.setRequestId(con.id);
        c.getRequestId();
       
        c.getPaymentInsertFlag();
        c.runTest();
        //c.PaymentInsertFlag =true;
        //c.getPaymentGridData();
    }
}