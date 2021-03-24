/**
 *create By Jason 20160906
 *
 */
@isTest
private class RequestFastProcessEmailServiceTester {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
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
        
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id);
        // Create a new email, envelope object and Attachment
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        RequestFastProcessEmailService requestFastProcess = new  RequestFastProcessEmailService();
        
        User userTest = [SELECT ID,EMAIL,Name from User Limit 1];//WHERE Name =:'Zhang Huijian'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this opportunity';
	    email.plainTextBody = ' reject \nTest002';
	    requestFastProcess.handleInboundEmail( email , env );  
		
        email.plainTextBody = ' yes \nTest001';
	    requestFastProcess.handleInboundEmail( email , env );
	    Contract testCon = [SELECT ID,Finance_approved_orders_Fast_Process__c,BMO_Manager_approved_orders_Fast_Process__c FROM Contract WHERE ID =: con.Id];  
    }
}