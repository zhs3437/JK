@isTest
public class PriceApprove2Test {
    private static testMethod void submitTest(){
      
        Account acc = TestHelper.createAccount();
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
        Contract con = TestHelper.createContract(acc.Id);
        con.OwnerId = user.Id;
        con.Opportunity__c = opp.Id;
      
        PriceApprove2.submit(con.Id);
        Product_Application__C p2 =new Product_Application__c();
        p2.Destination_Region__c='EU(Union)';
     insert p2;
         Product_Application_Detail__c ppp=new Product_Application_Detail__c();
     ppp.Discount__c=1;
     ppp.name='12';
     ppp.Sales_Price__c=1;
     ppp.W__c=1;
     ppp.Guaranteed_Delivery_Date__c=date.today();
     ppp.Kucun__c='Stock';
     ppp.Product_Application__C=p2.id;
     insert ppp;
         PriceApprove2.Addproduct(p2.Id);
        PriceApprove2.Addproductstock(p2.Id);
        PriceApprove2.Productfastprocess(p2.Id);
    }
 }