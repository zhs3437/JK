@isTest
public class MDAOppUpdateTest {
    static testMethod void myUnitTest() {
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
        User u = TestHelper.createUser(p.Id, 'u1@qq.com', true);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
       
       
         Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
       
        OpportunityLineItem pd1	= new OpportunityLineItem();        
      		pd1.Opportunity=opp;
        //pd1.				= entry.Id;
       
       
        //pd1.Type_of_module__c 				= 'NS-Non smart module';
        pd1.Grade__c 						= 'A-Grade A';
        pd1.Special_required__c 			= 'J4-Black Silicon Module';
        pd1.Bus_bars_of_cell__c 			= '4-4BB';
        //pd1.UnitPrice						= 1;   
        pd1.OpportunityId =opp.id;
            pd1.Quantity =40;
            pd1.Guaranteed_Delivery_Date__c =Date.today();
        	pd1.TotalPrice=100;
        pd1.PricebookEntryId=entry.id;
        insert pd1;
       
        
        List<OpportunityLineItem> oiLst = new List<OpportunityLineItem>();
        oiLst.add(pd1);
        
        Component_Task_Book__c ctb2 = TestHelper.createComponentTaskBook(Opp,false);
		insert ctb2;
        ctb2.Technical_manager_Shanghai__c ='Approved';
        update ctb2;
        
        
    }


}