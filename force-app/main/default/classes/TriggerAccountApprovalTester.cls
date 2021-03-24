@isTest
private class TriggerAccountApprovalTester {

    static testMethod void myUnitTest() {
    	
		
		User usr = new User(ID=UserInfo.getUserId());
		usr.Country_Range__c = 'China,US';
		update usr;
		    	
    	Account acc = new Account(Name = 'TestData_0125',Customer_Grading__c='VIP',Company_Email__c = 'test_0125@account.dev',
    							  Sinosure_Buyer_s_Code__c='SN0000X',Cooperation_method__c='OEM',User__c=UserInfo.getUserId(),
    							  Regions_Approve__c='' , Country__c='China');
        insert acc;
        
        acc.Country__c = 'Japen';
 		update acc;       
    }
}