/**
 *
 *create by Jason 20160621
 *创建补充协议测试class
 */
@isTest
private class CreateAmendmentCtrlTest {

    static testMethod void myUnitTest() {
		Amendment__c am = TestHelper.createAmendment();
		CreateAmendmentCtrl cac = new CreateAmendmentCtrl(new ApexPages.StandardController(am));
		Account acc = TestHelper.createAccount();
		
		Order ord = TestHelper.createOrder(false);
		//ord.AccountId = acc.Name;
		ord.Lock__c = true;
		ord.SEQ__c = 2;
		ord.Previous_Amendment_Generation_Date__c = null;
		insert ord;
		cac.generateAmendment();
        cac.runTest();
    }
}