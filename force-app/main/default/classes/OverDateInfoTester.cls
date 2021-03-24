@isTest
public class OverDateInfoTester {
	static testMethod void runBatch(){
        Apply_Inventory__c ai = TestHelper.createApplyInventory(false);
        ai.Status__c = 'Book';
        insert ai;
        Schema.Apply_Inventory__c testAI = [Select Id From Apply_Inventory__c Where id =: ai.Id ];
		Test.startTest(); 
        OverDateInfo odi = new OverDateInfo();
        ID batchprocessid = Database.executeBatch(odi);
        Test.stopTest();
    }
}