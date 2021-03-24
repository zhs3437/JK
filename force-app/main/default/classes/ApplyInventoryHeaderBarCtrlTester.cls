@isTest
public class ApplyInventoryHeaderBarCtrlTester {
    private static testMethod void myUnitTest() {
        Apply_Inventory__c ai = TestHelper.createApplyInventory();
        //Apply_Inventory__c ai = [Select id From Apply_Inventory__c LIMIT 1];
        ApexPAges.StandardController sc = new ApexPages.StandardController(ai);
        ApplyInventoryHeaderBarCtrl ctrl = new ApplyInventoryHeaderBarCtrl(sc);
        //ctrl.ApplyInventoryHeaderBarCtrl();
        ctrl.runTest();
    }
	
}