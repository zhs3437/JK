@isTest
public class OA_bookcapacityTest {
    static testMethod void myUnitTest() {
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        Profile pf = [select id from profile where name='BD' limit 1];        
        User user = TestHelper.createUser(Pf.id,'test800208@qq.com',true);
        user.OA_Use_Id__c='ABC';
        update user;
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id);
        Contract con = TestHelper.createContract(acc.Id);
        con.Opportunity__c=opp.id;
        con.Inspection__c='Need';
        update con;
        CapacityReservation__c crcs =new CapacityReservation__c();
        crcs.OwnerId = user.id;
        crcs.state__c = 'Approved';
        crcs.ValidityTerm__c = Date.today();
        crcs.ifdelay__c=false;        
        crcs.change__c = true;
        crcs.contract__c =con.id;                   
        crcs.no__c=123;
        crcs.Number_of_applications__c=1;
        crcs.Opportunity__c=opp.id;          
        crcs.area__c ='ROA';        
        crcs.ApplicationDate__c=date.today();
        crcs.wattage__c=1000;
        crcs.Trade_term__c='CIF';
        INSERT crcs;
        PowerProduct__c ppc =new PowerProduct__c();        
        ppc.Product__c=prod.id;        
        ppc.Production_Description__c='123';
        ppc.Spec__c='123';
        ppc.Guaranteed_Delivery_Date__c=date.today();
        ppc.Guaranteed_Delivery_Date_japan__c=date.today();
        ppc.Unit_Price_Without_Commission__c=120;
        ppc.Commission_Per_W__c=120;       								
        ppc.Cheetah__c=true;
        ppc.Powerbooked__c=crcs.id;       								
        ppc.Quantity__c=100;
        ppc.Unit_Price__c=100;
        ppc.Time_Region__c=null;
        ppc.FOB_Unit_Price__c=100;
        ppc.Total_W__c=123456;
        ppc.Total_Price__c=1234000;
        ppc.Production_Description__c='123';
        ppc.Spec__c='123';
       	ppc.Unit_Price__c=123;
       	
       
        INSERT ppc;
        OA_bookcapacityCtrl2 occ=new OA_bookcapacityCtrl2();
        String result=null;
       result= OA_bookcapacityCtrl2.generateData(crcs.Id);
    }
}