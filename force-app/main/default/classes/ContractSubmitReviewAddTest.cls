@isTest
public class ContractSubmitReviewAddTest {
    static testMethod void myTest(){
        User u = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
        /*
        Order ord = TestHelper.createOrder(false);
        ord.Contract_Owner__c = u.Id;
        insert ord;
        */
        
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        RecordType rt = [select id,name from RecordType where name=:'Inventory Contract'];
        con.RecordTypeId = rt.id;
        insert con;
        Component_Task_Book__c ctb2 = TestHelper.createComponentTaskBook(con,false);
        insert ctb2;
        ContractSubmitReviewAdd.HaveUnLockAmend(con.Id);
    }
        static testMethod void myTest1(){
        RecordType rt = [select id,name from RecordType where name=:'Inventory Contract'];
        Account acc1 = TestHelper.createAccount();
        Opportunity opp1 = TestHelper.createOpportunity(acc1.Id, false);
        opp1.Sales_type__c = 'DG Market-Industrial&Commercial';
        insert opp1;
        Contract con1 = TestHelper.createContract(acc1.Id,false);
        con1.Opportunity__c = opp1.id;
        con1.Contract_NO__c = '2016101001';
        con1.Region__c = 'North America';
        con1.RecordTypeId = rt.id;
        con1.InventoryArea__c = 'Own inventory';
        insert con1;
		Component_Task_Book__c ctb = TestHelper.createComponentTaskBook(con1,false);
        insert ctb;
        Product_Detail__c pd = new Product_Detail__c();
        pd.Contract_PO_PI__c = con1.id;
        insert pd;  
        ContractSubmitReviewAdd.HaveUnLockAmend(con1.Id);

        }
        
    static testMethod void myTest3(){
        RecordType rt = [select id,name from RecordType where name=:'Inventory Contract'];
        Account acc3 = TestHelper.createAccount();
        Opportunity opp3 = TestHelper.createOpportunity(acc3.Id, false);
        opp3.Sales_type__c = 'DG Market-Industrial&Commercial';
        insert opp3;
        Contract con3 = TestHelper.createContract(acc3.Id,false);
        con3.Opportunity__c = opp3.id;
        con3.Contract_NO__c = '2016101002';
        con3.Region__c = 'North America';
        con3.RecordTypeId = rt.id;
        con3.InventoryArea__c = 'Other regions';
        insert con3;
		Component_Task_Book__c ctb3 = TestHelper.createComponentTaskBook(con3,false);
        insert ctb3;
        product2 p = new product2();
        p.name = 'test';
        insert p;
        Product_Detail__c pd3 = new Product_Detail__c();
        pd3.Contract_PO_PI__c = con3.id;
        pd3.Product__c = p.id;
        insert pd3;
        ContractSubmitReviewAdd.HaveUnLockAmend(con3.Id);

    }
        
    static testMethod void myTest4(){
        RecordType rt1 = [select id,name from RecordType where name=:'1MW Australia Contract'];
        Account acc4 = TestHelper.createAccount();
        Opportunity opp4 = TestHelper.createOpportunity(acc4.Id, false);
        opp4.Sales_type__c = 'DG Market-Industrial&Commercial';
        insert opp4;
        Contract con4 = TestHelper.createContract(acc4.Id,false);
        con4.Opportunity__c = opp4.id;
        con4.Contract_NO__c = '2016101004';
        con4.RecordTypeId = rt1.id;
        insert con4;
		Component_Task_Book__c ctb4 = TestHelper.createComponentTaskBook(con4,false);
        insert ctb4;
        product2 p4 = new product2();
        p4.name = 'test';
        insert p4;
        Product_Detail__c pd4 = new Product_Detail__c();
        pd4.Contract_PO_PI__c = con4.id;
        pd4.Product__c = p4.id;
        insert pd4;
        ContractSubmitReviewAdd.HaveUnLockAmend(con4.Id);
    }       
    
    static testMethod void myTest5(){
RecordType rt2 = [select id,name from RecordType where name=:'Inventory Contract'];
        Account acc5 = TestHelper.createAccount();
        Opportunity opp5 = TestHelper.createOpportunity(acc5.Id, false);
        opp5.Sales_type__c = 'DG Market-Industrial&Commercial';
        insert opp5;
        Contract con5 = TestHelper.createContract(acc5.Id,false);
        con5.Opportunity__c = opp5.id;
        con5.InventoryArea__c = 'Other regions';
        con5.Contract_NO__c = '2016101005';
        con5.RecordTypeId = rt2.id;
        insert con5;
		Component_Task_Book__c ctb5 = TestHelper.createComponentTaskBook(con5,false);
        insert ctb5;
        product2 p5 = new product2();
        p5.name = 'test';
        insert p5;
        Product_Detail__c pd5 = new Product_Detail__c();
        pd5.Contract_PO_PI__c = con5.id;
        pd5.Product__c = p5.id;
        insert pd5;
        
        ContractSubmitReviewAdd.HaveUnLockAmend(con5.Id);
    }
            
    
}