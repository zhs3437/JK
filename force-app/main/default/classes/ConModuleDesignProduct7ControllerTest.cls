@isTest
public class ConModuleDesignProduct7ControllerTest {
static testMethod void myUnitTest() {
        
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
        User u = TestHelper.createUser(p.Id, 'u1@qq.com', true);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
       
       
         Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        con.Opportunity__c = opp.id;
        insert con;
    
         Product_Detail__c pd = new Product_Detail__c();
        pd.Contract_PO_PI__c = con.id;
        pd.Product__c = prod.Id;
        insert pd;
       
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
          ModuleDesignParam__c mdp = new ModuleDesignParam__c();
         mdp.OppId__c ='test1';
       mdp.Module_Design_Contract_Id__c ='test44';
      mdp.Module_Design_Order_Id__c ='test55';
       mdp.Module_Design_Product_Name__c ='test2'; 
       mdp.CellType1__c  ='test3'; 
       mdp.Module_Series1__c  ='test4'; 
       mdp.Module_Design_Product_Cell_Quantity__c ='test5'; 
       mdp.ProductCertificate__c ='test6';
       mdp.Additional_Certificate__c ='test7'; 
       mdp.Mandatory_certification__c ='test8'; 
       mdp.Power_Tolerance__c ='test9'; 
       mdp.System_Voltage__c ='test10'; 
       mdp.Additional_power__c ='test11'; 
       mdp.Module_Design_Warranty__c ='test12';
       mdp.Package__c ='test13';
       mdp.Junction_Box_Type__c ='test14';
       mdp.Junction_Box_Cable_Length__c ='test15';
       mdp.Junction_Box_Connector__c ='test16';
       mdp.Rear_cover__c ='test17';
       mdp.Frame_B_side_Height__c ='test18';
       mdp.Frame_Type__c ='test19';
       mdp.EVA__c ='test20';
       mdp.LRF__c ='test21';
       mdp.Project_Type__c ='test22';
       mdp.String_Ribbon__c ='test23';
       mdp.Cell_Color__c ='test24';
       mdp.Current_Sorting__c ='test25';
       mdp.Current_Sorting_Style__c ='test26';
       mdp.Color_Sorting_style__c ='test27';
       mdp.Production_supervision_by_Client_or_3rd__c ='test28';
       mdp.Pre_shipping_Inspection_factory__c ='test29';
       mdp.Special_Approval_for_order_production__c ='test30';
       mdp.Nameplate__c ='test31';
       mdp.Shipping_Mark__c ='test32';
       mdp.Barcode_encoding_principle__c ='test33';
       mdp.Transportation_style__c ='test34';
       mdp.Lab_tests__c ='test35';
       mdp.Regional_customs_clearance_request__c ='test36';
       mdp.Front_Glass__c ='test37';
       mdp.Mandatory_certification__c ='test38';
        insert mdp;
        ApexPages.currentPage().getParameters().put('ConId',con.Id);
     ApexPages.currentPage().getParameters().put('p1',pd.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id,Name FROM Component_Task_Book__c]));
        ConModuleDesignProduct7Controller mdpc = new ConModuleDesignProduct7Controller(ctrl);
        mdpc.pageId ='a0Z/e';
        mdpc.goto();
        
        
    }


}