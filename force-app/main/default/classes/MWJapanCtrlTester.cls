@isTest
public class MWJapanCtrlTester {
    private static testMethod void myUnitTest(){
        Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'EXW';
		insert opp;
        Contract con = TestHelper.createContract(acc.Id, false);
        con.Opportunity__c = opp.Id;
        insert con;
        MWJapanCtrl ctrl = new MWJapanCtrl(new ApexPages.StandardController(con));
        //MWJapanCtrl mjc = MWJapanCtrl(new ApexPages.Controller(con));
        ctrl = new MWJapanCtrl();		
    }	
}