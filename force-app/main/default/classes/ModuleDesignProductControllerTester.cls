@isTest
public with sharing class ModuleDesignProductControllerTester {
	static testMethod void myUnitTest() {
        
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
        User u = TestHelper.createUser(p.Id, 'u1@qq.com', true);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
       
        Product_Detail__c pd1	= TestHelper.createProductDetail(false);        
        pd1.Contract_PO_PI__c	= con.Id;
        //pd1.				= entry.Id;
        pd1.Quantity__c 					= 100;
        pd1.Certification__c 				= '1-TUV';
        pd1.Color_of_frame_and_backsheet__c = '2-White';
        //pd1.Type_of_module__c 				= 'NS-Non smart module';
        pd1.Grade__c 						= 'A-Grade A';
        pd1.Special_required__c 			= 'J4-Black Silicon Module';
        pd1.Bus_bars_of_cell__c 			= '4-4BB';
        //pd1.UnitPrice						= 1;        
        insert pd1;
        
        Product_Detail__c pd2	= TestHelper.createProductDetail(false);
        pd2.Contract_PO_PI__c	= con.Id;
        //pd2.PricebookEntryId 				= entry.Id;
        pd2.Quantity__c 					= 100;
        pd2.Certification__c 				= '1-TUV';
        pd2.Color_of_frame_and_backsheet__c = '2-White';
        //pd2.Type_of_module__c 				= 'NS-Non smart module';
        pd2.Grade__c 						= 'A-Grade A';
        pd2.Special_required__c 			= 'J4-Black Silicon Module';
        pd2.Bus_bars_of_cell__c 			= '4-4BB';
        //pd2.UnitPrice						= 1;
        insert pd2;
        Product_Detail__c pd3	= TestHelper.createProductDetail(false);
        pd3.Contract_PO_PI__c	= con.Id;
        //pd3.PricebookEntryId 				= entry.Id;
        pd3.Quantity__c 					= 100;
        pd3.Certification__c 				= '1-TUV';
        pd3.Color_of_frame_and_backsheet__c = '2-White';
        //pd3.Type_of_module__c 				= 'NS-Non smart module';
        pd3.Grade__c 						= 'A-Grade A';
        pd3.Special_required__c 			= 'J4-Black Silicon Module';
        pd3.Bus_bars_of_cell__c 			= '4-4BB';
        //pd3.UnitPrice						= 1;
        insert pd3;
        
        List<Product_Detail__c> oiLst = new List<Product_Detail__c>();
        oiLst.add(pd1);
        oiLst.add(pd2);
        oiLst.add(pd3);
                
        //Contract c = TestHelper.createContract(acc.Id,true);
        
        ApexPages.currentPage().getParameters().put('id',con.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id,Name FROM Component_Task_Book__c]));
        ModuleDesignProductController mdpc = new ModuleDesignProductController(ctrl);
        mdpc.orderItem1 = oiLst[0];
        mdpc.orderItem2 = oiLst[1];
        mdpc.orderItem3 = oiLst[2];
        mdpc.currentId = pd1.Contract_PO_PI__c;
        //mdpc.goto();
        
        
    }
}