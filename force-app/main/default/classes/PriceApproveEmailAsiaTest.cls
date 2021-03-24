@isTest
private class PriceApproveEmailAsiaTest {
static testMethod void myUnitTest() {
    
        User user = new User(Username='u'+System.now().getTime()+'@163.com',
                             Email='jason_trixpro@163.com',
                             FirstName='jason',
                             LastName='jia',
                             Alias='UJia',
                             ProfileId=UserInfo.getProfileId());
        
        //user.Contract_Approver__c='Anita Li';
        user.TimeZoneSidKey='Asia/Shanghai';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='ISO-8859-1';
        user.LanguageLocaleKey='en_US';
        user.Region__c ='ROA';
        insert user;
        
        Account acc = TestHelper.createAccount();
        Opportunity testObj = TestHelper.createOpportunity(acc.Id);
        //testObj.OwnerId = '005900000014BfH'; // Init Sales :Ali Hamam 
    	//update testObj;
        
        // Create a new email, envelope object and Attachment
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        PriceApproveEmailAsia testPriceApprove = new  PriceApproveEmailAsia();
        
        User userTest = [SELECT ID,EMAIL,Name from User WHERE Name =:'Anita Li'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
	    email.subject = '[#RVID:'+ testObj.Id +'#]Please review this opportunity';
	    email.plainTextBody = ' reject \nTest002';
	    testPriceApprove.handleInboundEmail( email , env );  
		
        email.plainTextBody = ' yes \nTest001';
	    testPriceApprove.handleInboundEmail( email , env );  
		Opportunity testOpp = [SELECT ID, Price_Approval_Status__c From Opportunity Where ID=:testObj.Id];
        
    }

}