@isTest
public class ContractDiffCtrlTest {
    static testMethod void myTest(){
        Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Contract con        = TestHelper.createContract(acc.id);
        String requestId=con.Id;
        ContractDiffCtrl.History a =new ContractDiffCtrl.History();
        a.ApprovalNumbers=2;
        a.DiffMW=1;
        a.DiffQuantity=2;
        a.DiffPrice=3;
        a.DiffCommision=4;
        Contract_Difference_Detail__c condiff =new Contract_Difference_Detail__c();
        ContractLineItem_Difference_Detail__c c =new ContractLineItem_Difference_Detail__c();
        Contract_Payment_Difference__c b =new Contract_Payment_Difference__c();
        a.add(condiff);
        a.addOpplinDiff(c);
        a.addpayDiff(b);
        ApexPages.StandardController sd=null;
        List<ContractDiffCtrl.History> HistoryList =new List<ContractDiffCtrl.History>();
        List<Contract_Difference_Detail__c> f=new List<Contract_Difference_Detail__c>();
        List<ContractLineItem_Difference_Detail__c> g=new List<ContractLineItem_Difference_Detail__c>();
         List<Contract_Payment_Difference__c> h=new  List<Contract_Payment_Difference__c>();
        Contract_Difference_Detail__c i =new Contract_Difference_Detail__c();
        HistoryList.add(a);
        ApexPages.currentPage().getParameters().put('id',requestId);
        condiff.Contract__c=requestId;condiff.ApprovalNumbers__c='2';insert condiff;
        c.Contract_Difference_Detail__c=condiff.id;c.ApprovalNumbers__c='2';insert c;
        b.Contract_Difference_Detail__c=condiff.id;b.ApprovalNumbers__c='2';insert b;
        ContractDiffCtrl e =new ContractDiffCtrl(sd);
        e.DiffMW=1;e.DiffPrice=2;e.DiffCommision=3;e.DiffQuantity=4;e.conDiffLst=f;e.conLinDiffLst=g;e.payDiffLst=h;e.condiff=i;e.HistoryList=HistoryList;
    }
}