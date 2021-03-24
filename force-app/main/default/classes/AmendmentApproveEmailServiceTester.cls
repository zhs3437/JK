/**
 *
 *create by Jason20160602s
 * 补充协议 Email Service 测试类
 */
@isTest
private class AmendmentApproveEmailServiceTester {

     static testMethod void myUnitTest() {
    
        User user = new User(Username='u'+System.now().getTime()+'@163.com',
                             Email='jason_trixpro@163.com',
                             FirstName='jason',
                             LastName='jia',
                             Alias='UJia',
                             ProfileId=UserInfo.getProfileId());
        
        
        user.TimeZoneSidKey='Asia/Shanghai';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='ISO-8859-1';
        user.LanguageLocaleKey='en_US';
        insert user;

        //Account acc = TestHelper.createAccount();
        SubmitForReview__c testObj = TestHelper.createSubmitForReview();
    	update testObj;
        
        // Create a new email, envelope object and Attachment
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        AmendmentApproveEmailService testAmendmentApprove = new  AmendmentApproveEmailService();
        
        User userTest = [SELECT ID,EMAIL from User WHERE ID=:'0059000000126GT'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
	    email.subject = '[#RVID:'+ testObj.Id +'#]Please review this opportunity';
	    email.plainTextBody = ' reject \nTest002';
	    testAmendmentApprove.handleInboundEmail( email , env );  
		
        email.plainTextBody = ' yes \nTest001';
	    testAmendmentApprove.handleInboundEmail( email , env );  
		SubmitForReview__c testSub = [SELECT ID From SubmitForReview__c Where ID=:testObj.Id];
         
         
        
    }
}