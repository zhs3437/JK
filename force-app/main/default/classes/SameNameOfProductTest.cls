/**
 *
 * 
 *create by Fanzr 2107 
 *  
 */
@isTest
public class SameNameOfProductTest {
    static testMethod void myUnitTest() {

        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
        
        Product_Detail__c pd1	= TestHelper.createProductDetail(false);
        pd1.Contract_PO_PI__c	= con.Id;
        insert pd1;
        Product_Detail__c pd2	= TestHelper.createProductDetail(false);
        pd2.Contract_PO_PI__c	= con.Id;
        insert pd2;
        Product_Detail__c pd3	= TestHelper.createProductDetail(false);
        pd3.Contract_PO_PI__c	= con.Id;
        insert pd3;
        
        Component_Task_Book__c ctb		=	TestHelper.createComponentTaskBook(con,false);
        insert ctb;
   
        
        List<Id> ids=new List<Id>();
        ids.add(pd1.Id);
        ids.add(pd2.Id);
        ids.add(pd3.Id);
        SameNameOfProduct.sameNameError(ids);       
    }
}