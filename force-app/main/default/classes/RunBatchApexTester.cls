@isTest
public class RunBatchApexTester {
	static testMethod void runBatch(){
        Account acc = TestHelper.createAccount(false);
        acc.Name = 'aa';
        insert acc;
        Schema.Account testAcc = [Select Id,Name from Account where id =: acc.Id];
		Test.startTest(); 
        RunBatchApex rba = new RunBatchApex();
        rba.setQry('SELECT id,Name FROM Account limit 1');
        rba.queryString = 'SELECT id,Name FROM Account limit 1';
        ID batchprocessid = Database.executeBatch(rba);
        Test.stopTest();
    }
}