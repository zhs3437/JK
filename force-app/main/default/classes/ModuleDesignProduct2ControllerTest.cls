@isTest
public class ModuleDesignProduct2ControllerTest {
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
        
   /**     OpportunityLineItem pd2	= new OpportunityLineItem();
     	pd2.Opportunity=opp;
        //pd2.PricebookEntryId 				= entry.Id;
      
        pd2.Certification__c 				= '1-TUV';
      
        //pd2.Type_of_module__c 				= 'NS-Non smart module';
        pd2.Grade__c 						= 'A-Grade A';
        pd2.Special_required__c 			= 'J4-Black Silicon Module';
        pd2.Bus_bars_of_cell__c 			= '4-4BB';
        //pd2.UnitPrice						= 1;
         pd2.OpportunityId =opp.id;
            pd2.Quantity =40;
            pd2.Guaranteed_Delivery_Date__c =Date.today();
        pd2.TotalPrice=100;
         pd2.PricebookEntryId=entry.id;
        insert pd2;
        OpportunityLineItem pd3	= new OpportunityLineItem();
       	pd3.Opportunity=opp;
        //pd3.PricebookEntryId 				= entry.Id;
     
        pd3.Certification__c 				= '1-TUV';
       
        //pd3.Type_of_module__c 				= 'NS-Non smart module';
        pd3.Grade__c 						= 'A-Grade A';
        pd3.Special_required__c 			= 'J4-Black Silicon Module';
        pd3.Bus_bars_of_cell__c 			= '4-4BB';
         pd3.OpportunityId =opp.id;
            pd3.Quantity =40;
            pd3.Guaranteed_Delivery_Date__c =Date.today();
        pd3.TotalPrice=100;
         pd3.PricebookEntryId=entry.id;
        insert pd3;*/
        
        List<OpportunityLineItem> oiLst = new List<OpportunityLineItem>();
        oiLst.add(pd1);
        //oiLst.add(pd2);
        //oiLst.add(pd3);
                
        //Contract c = TestHelper.createContract(acc.Id,true);
        
        ApexPages.currentPage().getParameters().put('id',con.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id,Name FROM Component_Task_Book__c]));
        ModuleDesignProduct2Controller mdpc = new ModuleDesignProduct2Controller(ctrl);
          mdpc.orderItem1 = oiLst[0];
       // mdpc.orderItem2 = oiLst[1];
        //mdpc.orderItem3 = oiLst[2];
      
        //mdpc.goto();
        
        
    }
}