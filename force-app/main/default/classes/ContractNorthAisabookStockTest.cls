@isTest
public class ContractNorthAisabookStockTest {
    private static testMethod void submitTest(){
        Account acc = TestHelper.createAccount();
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p.id);
        User user = new User();
        // user.Name ='Emily Yuan';
        user.Username = 'Emliy';
        user.LastName = 'Yuan';
        user.Alias = 'cc';
        user.CommunityNickname = 'c';
        
        user.LocaleSidKey = 'Chinese (China)';
        user.EmailEncodingKey = 'c';
        
        user.LanguageLocaleKey = 'cc';
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false); 
        opp.Land_Freight_China__c = null;
        opp.Land_Freight_Oversea__c = null;
        opp.Ocean_Freight__c = null;
        opp.Trade_Term__c = 'DDP';
        Contract con = TestHelper.createContract(acc.Id);
        con.OwnerId = user.Id;
        con.Opportunity__c = opp.Id;
        Apply_Inventory__c aic = new Apply_Inventory__c();
        aic.Opportunity__c = opp.id;
        aic.Product__c = p.id;
        aic.Warehouse__c = null;
        aic.Product_Type__c = p.id;
        insert aic;
        Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 10;
        ic.MAKTX__c = null;
        insert ic;
        List<Inventory__c> invLst = new List<Inventory__c>();  
        String requestId = aic.id;
        String deleteID = null;
        String bookID = null;
        String editID   =null;
        String requestQuantity  = null;
        Distribution_Stock__c ds = new Distribution_Stock__c();
        ds.Apply_Inventory__c = requestId;
        ds.Inventory__c = ic.id;
        ds.Distribution_Quantity__c = 200;
        ds.Product_Type__c = p.id;
        insert ds;
        List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>();
        gl.add(ds);
        update gl;
        List<String> glId = new List<String>();
        glId.add(ds.id);
        String conID = con.id;
        ContractNorthAisabookStock.SendEmail(conID,glId);
    }
    
}