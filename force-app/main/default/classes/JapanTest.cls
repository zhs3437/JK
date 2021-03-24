@isTest
private class JapanTest {
	@IsTest(SeeAllData=true)
    static void TestJapan() {
    	//Contract con = [SELECT ID,Name FROM Contract limit 1];
        Account acc = TestHelper.createAccount();
        Contract con  = TestHelper.createContract(acc.Id, false);
    	con.Payment_Term_Description__c = 'T/T';
    	con.GTAC_No__c = '1111';
    	con.Contract_NO__c = 'MXXXXX';
    	insert con;
    	RemarkExchangeUtils tools = new RemarkExchangeUtils();
    	tools.DDP_Standard_Sino(con);
    	tools.DDP_Linear_Sino(con);
    	tools.EXW_Standard_Sino(con);
    	tools.EXW_Linear_Sino(con);
    	tools.DDP_Standard_NoSino(con);
    	tools.DDP_Linear_NoSino(con);
    	tools.EXW_Standard_NoSino(con);
    	tools.EXW_Linear_NoSino(con);
    	tools.Australia_DDP(con);
    	tools.Australia_EXW(con);
    	tools.GTAC_DDP_Standard_Sino(con);
    	tools.GTAC_DDP_Linear_Sino(con);
    	tools.GTAC_DDP_Standard_NoSino(con);
    	tools.GTAC_DDP_Linear_NoSino(con);
    	tools.GTAC_EXW_Standard_Sino(con);
    	tools.GTAC_EXW_Linear_Sino(con);
    	tools.GTAC_EXW_Standard_NoSino(con);
    	tools.GTAC_EXW_Linear_NoSino(con);
    	
    	//PA_Japan_Ctrl paJapan = new PA_Japan_Ctrl(new ApexPages.StandardController(con));
        //paJapan.runTest();
    }
}