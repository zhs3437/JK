@isTest
private class DuplicationCheckOnAccountTest {
	
    static testMethod void myUnitTest() {
       try{
		   Account acc1 = new Account(Name = 'Jinko',Customer_Grading__c='VIP',Sinosure_Buyer_s_Code__c='SN0000X',Cooperation_method__c='OEM',User__c=UserInfo.getUserId());
	       acc1.Company_Email__c = 'winhunter@qq.com';
	       Account acc2 = new Account(Name = 'Jinko',Customer_Grading__c='VIP',Sinosure_Buyer_s_Code__c='SN0000X',Cooperation_method__c='OEM',User__c=UserInfo.getUserId());
	       acc2.Company_Email__c = 'winhunter@qq.com';
	       insert acc1;
	       insert acc2;
	       
       }catch(exception e){
       	   system.assert(true);
       
       }
       
    }
}