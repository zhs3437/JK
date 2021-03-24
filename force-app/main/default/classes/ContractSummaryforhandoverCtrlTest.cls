@isTest
public class ContractSummaryforhandoverCtrlTest {
    static testMethod void myTest(){
        Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Contract con        = TestHelper.createContract(acc.id);
        String requestId=con.Id;
        
        ApexPages.currentPage().getParameters().put('id',requestId);
        ApexPages.StandardController sd=null;
        ContractSummaryforhandoverCtrl e =new ContractSummaryforhandoverCtrl(sd);
    }
}