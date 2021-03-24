@isTest
public class PAUkraineAttachment2_Test {
    public static testMethod void submitTest(){
         Account acc = TestHelper.createAccount();
        acc.Name='Test';
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        User user = new User();
        user.Username = 'c';
        user.LastName = 'cc';
        user.Alias = 'cc';
        user.CommunityNickname = 'c';
        
        user.LocaleSidKey = 'Chinese (China)';
        user.EmailEncodingKey = 'c';

        user.LanguageLocaleKey = 'cc';
        User user1 = new User();   
        user1.Username = 'cc';
        user1.LastName = 'cc';
        user1.Alias = 'c';
        user1.CommunityNickname = 'cc';      
        user1.LocaleSidKey = 'Chinese (China)';
        user1.EmailEncodingKey = 'c';
        
        user1.LanguageLocaleKey = 'c';
        user.Contract_Review__c = user1.Id;
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false); 
        opp.Land_Freight_China__c = null;
        opp.Land_Freight_Oversea__c =null;
        opp.Ocean_Freight__c = null;
        opp.Trade_Term__c = 'DDP';
        /** Print_PA_Date__c,Contract_NO__c,BuyerAccount__r.Name,BuyerAccount__r.BillingAddress,BillingAddress,BuyerAccount__r.VAT_NO__c,BuyerAccount__r.Fax,
               BuyerAccount__r.Company_Email__c,BuyerAccount__r.Phone,SELLER__c,Authorized_Representative__c,Trade_term__c,Destination_port2__c,
               Port_of_Origin__c,CurrencyIsoCode,BankInfo__r.Bank_Name__c,BankInfo__r.Address__c,BankInfo__r.BENEFICIARY_s_Name__c,
               BankInfo__r.BENEFICIARY_s_A_C__c,BankInfo__r.BENEFICIARY_s_Address__c,BankInfo__r.SWIFT__c,Bank_Information_Content__c,
               Product__c,Departure_Port__c,Owner.Phone,Owner.Fax,Owner.Email,BuyerAccount__r.Actual_Sales_Name__c*/
        Contract con = TestHelper.createContract(acc.Id);
        con.OwnerId = user.Id;
        con.Opportunity__c = opp.Id;
        con.SELLER__c = 'Jinko Solar Import and Export Co., Ltd.';
        con.Contract_NO__c = '2333333333';
           
        con.Authorized_Representative__c='cc';
        con.Trade_term__c='cc';    
        con.Port_of_Origin__c='cc';
        con.CurrencyIsoCode='2342342';
        con.Departure_Port__c='34rewr';
        con.Actual_Sales_Name__c='fsegag';
        Information_of_Seller__c ios=new Information_of_Seller__c();
        ios.Seller__c=con.SELLER__c;
        ios.Address__c='2222222222222222222222';
        ios.Seller_VAT_NO__c='222222222222';
        //,Payment_Method__c,DAYs__C,Percentage__c,Down_Balance_Payment__c,Amount__c from Payment__c where Contract__c
        Payment__c ptc= new Payment__c();
        ptc.Payment_Method__c='L/C';
        ptc.Percentage__c=30;
        ptc.Payment_Term__c='OA';
        ptc.Down_Balance_Payment__c='Down Payment';
        ptc.DAYs__C=15;
        ptc.Contract__c=con.Id;
        insert ptc;
        Payment__c ptc2= new Payment__c();
        ptc2.Payment_Method__c='L/C';
        ptc2.Percentage__c=70;
         ptc2.Payment_Term__c='OA';
        ptc2.Down_Balance_Payment__c='Balance Payment';
        ptc2.DAYs__C=15;
        ptc2.Contract__c=con.Id;
insert ptc2;        
          ApexPages.currentPage().getParameters().put('id',con.Id);
       ApexPages.standardController std    = new ApexPages.standardController(con);
        PAUkraineAttachment2_Ctrl pctrl =new PAUkraineAttachment2_Ctrl(std);
        PAUkraineAttachment3_Ctrl pctrl2=new PAUkraineAttachment3_Ctrl(std);
        PAUkrainePurchaseAgreement_Ctrl pap =new PAUkrainePurchaseAgreement_Ctrl(std);
        PIUkraine1_Ctrl pip =new PIUkraine1_Ctrl(std);
        UkrainePreviewctrl UKpreview =new UkrainePreviewctrl(std);
        ukpreview.AddSave();
        ukpreview.SendEmail();
        pap.initialize();
       pctrl.initialize();
        pctrl2.initialize();
        pip.initialize();
    }
}