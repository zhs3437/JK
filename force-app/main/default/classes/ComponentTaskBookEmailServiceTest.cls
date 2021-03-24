/*
 *
 *create By:fanzr 20161229
 *
*/
@isTest
private class ComponentTaskBookEmailServiceTest {

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
        
        Account acc = TestHelper.createAccount();
        
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
        User u = TestHelper.createUser(p.Id, 'u1@qq.com', true);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
        /*
        Order ord = TestHelper.createOrder(false);   
        ord.Pricebook2Id = entry.Pricebook2Id;
        ord.Contract_Owner__c = u.Id;
        insert ord;
        */
        Component_Task_Book__c ctb = TestHelper.createComponentTaskBook(con,false);
        insert ctb;
        
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        ComponentTaskBookEmailService testTechnicalmanagerApprove = new  ComponentTaskBookEmailService();
        
        User userTest = [SELECT ID,EMAIL,Name from User WHERE Name =:'Zhang Huijian'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
	    email.subject = '[#RVID:'+ ctb.Id +'#]Please review this opportunity';
	    email.plainTextBody = ' reject\n Alex \nTest002';
	    testTechnicalmanagerApprove.handleInboundEmail( email , env );  
		
        email.plainTextBody = ' yes \n Alex \n Test001';
	    testTechnicalmanagerApprove.handleInboundEmail( email , env );  
        Component_Task_Book__c testCtb = [SELECT ID, Technical_manager_Shanghai__c ,Signature__c,Technical_manager_Shanghai_Comments__c From Component_Task_Book__c Where ID=:ctb.Id];
        
    }

}