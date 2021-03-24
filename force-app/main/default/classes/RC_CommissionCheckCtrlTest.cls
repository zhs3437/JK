@isTest
public class RC_CommissionCheckCtrlTest {
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
    Payment__c pay = new Payment__c();
    pay.Days__c = 10;
    pay.Percentage__c = 100;
    pay.Payment_Stage_China__c = '发货款';
    pay.Payment_Method_China__c = '电汇';
    pay.Payment_Term_China__c = '发货前全款';
    pay.PaymentDescription__c = '批次发货，发货前支付100%批次发货款';
    pay.China_Project__c = opp.id;
    insert pay;
    	//Product2 pp = new Product2();
    	//pp.Name = 'JKM255PP-72H'; 
    	//pp.Maximum_Power_at_STC_Pmax__c = 255;
    	//insert pp;
        //leanx__hr_Resource__c product =new leanx__hr_Resource__c();
    	
    	//product.Name = 'JKM255PP-72H';
    	//product.Maximum_Power_At_STC_Pmax__c = 255;
    	//product.Product__c = pp.id;
    	//product.
    	//product.leanx__EmployerNumber__c =pp.id;
    	//insert product;
    	leanx__pm_ProjectMember__c oppMember = new leanx__pm_ProjectMember__c();
    	
    	oppMember.Name = 'JKM255PP-72H';
    	oppMember.Sales_Price__c = 1.5;
    	oppMember.Quantity__c = 50;
    	oppMember.Product_Name__c = '太阳能组件';
    	//oppMember.Product__c = product.id;
    	oppMember.leanx__Project__c = opp.id;  
    	oppMember.Guaranteed_Delivery_Date__c =date.today();
    	//oppMember.
    	insert oppMember;
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
        //con.Delivey_Point__c = '手提';
        con.Seller__c = 'ZHEJIANG JINKO SOLAR CO.,LTD';
        con.Warranty_Insurance__c = 'AR';     
        con.Commission__c = 0.1;
        con.Commission_Type__c = 'Per/W';              
        Insert con;       
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
        //ApexPages.currentPage().getParameters().put('id', con.Id);
    ApexPages.currentPage().getParameters().put('id', opp.Id);
    ApexPages.currentPage().getParameters().put('conid', con.Id);
    	//ApexPages.currentPage()
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);    	
        RC_CommissionCheckCtrl c = new RC_CommissionCheckCtrl(sc);
    	
         
    }
}