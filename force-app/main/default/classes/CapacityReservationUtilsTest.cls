@isTest
public class CapacityReservationUtilsTest {
    static testMethod void myUnitTest() {
       Account acc=TestHelper.createAccount();
        Contract con=TestHelper.createContract(acc.id);

         Product_Detail__c a = new Product_Detail__c();
        a.Contract_PO_PI__c=con.Id;a.Total_Price__c=2;
        a.Quantity__c=2;a.UnitPrice__c=2;a.Junction_Box_Type__c='NS-Non smart module';
        a.Battery_Type__c='Normal Cell';a.Bus_bars_of_cell__c='2-2BB';
        a.Certification__c='0-NO';a.Grade__c='A-Grade A';
        a.Special_required__c='0-commonly';a.Guaranteed_Delivery_Date__c = Date.today();
        insert a;
        Opportunity opp=TestHelper.createOpportunity(acc.id);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
         OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 3000;
        insert item;
        con.Opportunity__c=opp.id;
        update con;
        CapacityReservationUtils.CreatePro(con.id);
        CapacityReservation__c cr =new CapacityReservation__c();
        cr.contract__c=con.id;
        cr.Opportunity__c=opp.id;
        insert cr;
        CapacityReservationUtils.UpdatePro(cr.id);

        ApexPages.standardController std    = new ApexPages.standardController(cr);
        PowerbookHeaderCtrl ph=new PowerbookHeaderCtrl(std);
        PowerbookProductCtrl ppc=new PowerbookProductCtrl();
        ppc.requestId=cr.id;
         List<PowerProduct__c> ppList=ppc.ppList;
        }
    
    static testMethod void myUnitTest2() {
         Account acc=TestHelper.createAccount();
        Contract con=TestHelper.createContract(acc.id);

         Product_Detail__c a = new Product_Detail__c();
        a.Contract_PO_PI__c=con.Id;a.Total_Price__c=2;
        a.Quantity__c=2;a.UnitPrice__c=2;a.Junction_Box_Type__c='NS-Non smart module';
        a.Battery_Type__c='Normal Cell';a.Bus_bars_of_cell__c='2-2BB';
        a.Certification__c='0-NO';a.Grade__c='A-Grade A';
        a.Special_required__c='0-commonly';a.Guaranteed_Delivery_Date__c = Date.today();
        insert a;
        Opportunity opp=TestHelper.createOpportunity(acc.id);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
         OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 3000;
        insert item;
        con.Opportunity__c=opp.id;
        update con;
        CapacityReservationUtils.CreateProInOpp(opp.id);
      

       
    }
}