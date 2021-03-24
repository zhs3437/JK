@isTest
private class RC_CreatePDFTest {
    static testMethod void ChinaCreatePDFTest() {
        BackInfo__c bank1 = new BackInfo__c();
        bank1.BENEFICIARY_s_Name__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        bank1.BENEFICIARY_s_Address__c = '上海市浦东新区东方路100号';
        bank1.BENEFICIARY_s_A_C__c = '123';            
        bank1.Bank_Name__c = '中国银行';
        bank1.Address__c = '上海市浦东新区东方路100号';
        bank1.SWIFT__c = 'Test SWIFT';
        bank1.CurrencyIsoCode = 'CNY';
        insert bank1;
        Account a = new Account();
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
        a.Bank_Name__c = '虹口支行';
        a.Bank_Region__c = 'CN';
        a.Bank_Street__c = '上海市虹口区密云路2333号';
        a.BillingCity = '上海市';
        a.BillingCountry = '中国';
        a.BillingState = 'Test';
        a.BillingStreet = 'Test';
        Insert a;
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
        con.Project__c = opp.id;
        con.Expect_Price_And_Comments__c = '12345';       
        //con.Name = '12345'; 
        con.CurrencyIsoCode = 'CNY';
        con.leanx__Account__c = a.id;
        con.Trade_Term__c = 'CIF';                  
        con.Destination_Country__c = 'China';
        con.Destination_Region__c = 'CN';       
        //con.Delivey_Point__c = '手提';
        con.Seller__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        con.Warranty_Insurance__c = 'AR';     
        con.Commission__c = 0.1;
        con.Commission_Type__c = 'Per/W';              
        Insert con;
        Information_of_Seller__c seller = new Information_of_Seller__c();
        seller.Address__c = '上海市浦东新区东方路100号';
        seller.Authorized_Signatory__c = '罗玉凤';
        seller.Seller__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        seller.Seller_VAT_NO__c = 'VER49999';
        seller.Title__c = 'CEO';
        seller.Postcode__c = '200909';
        // seller.phone__c = 13;
        seller.Fax__c = 'WA123';
        Insert seller;
        Contract_Component__c cpls = new Contract_Component__c();
        cpls.Total_Power_W__c = 12345;      
            cpls.Contract__c = con.Id;   
            cpls.Product__c = con.Product__c;          
            cpls.Special_Material_Cost_Per_W__c = 123;
            cpls.Total_Price__c = 12345.12;    
            cpls.CurrencyIsoCode = con.CurrencyIsoCode;            
            cpls.Quantity__c = 1234;                       
            cpls.Sales_Price__c = 0.99; 
            cpls.Guaranteed_Delivery_Date__c = date.today();                      
            Insert cpls;
        	
            ApexPages.currentPage().getParameters().put('id', con.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(con);
            RC_PDFController c = new RC_PDFController(sc);
           
         
    }
}