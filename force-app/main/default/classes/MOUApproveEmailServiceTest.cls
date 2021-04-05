@IsTest
public class MOUApproveEmailServiceTest {
	static testmethod void myUnitTest(){
		
		//finance
		Profile p = [SELECT ID,Name from Profile where name=:'Finance' Limit 1];
		User userFinance =new User(Username ='u'+System.now().getTime()+'@163.com',
				Email = 'erinsun1996@163.com',
				FirstName = 'Alex',
				LastName = 'jiang',
				Alias = 'Alexjian',
				ProfileId = p.Id);

		userFinance.TimeZoneSidKey='Asia/Shanghai';
		userFinance.LocaleSidKey='en_US';
		userFinance.EmailEncodingKey='ISO-8859-1';
		userFinance.LanguageLocaleKey='en_US';

		insert userFinance;

//		//Technical
//		User userTechnical =new User(Username ='u'+System.now().getTime()+'@163.com',
//				Email = 'sunxiaoxiaoxia2@163.com',
//				FirstName = 'tech',
//				LastName = '2',
//				Alias = 'technic2',
//				ProfileId = '00e90000000NxtY');
//
//
//		userTechnical.TimeZoneSidKey='Asia/Shanghai';
//		userTechnical.LocaleSidKey='en_US';
//		userTechnical.EmailEncodingKey='ISO-8859-1';
//		userTechnical.LanguageLocaleKey='en_US';
//
//		insert userTechnical;
//		
		//Technical
	Profile p3 = [SELECT ID,Name from Profile where name=:'Technical' Limit 1];
		User userTechnical =new User(Username ='u'+System.now().getTime()+'@163.com',
				Email = 'sunxiaoxiaoxia2@163.com',
				FirstName = 'tech',
				LastName = '2',
				Alias = 'technic2',
				ProfileId = p3.Id);


		userTechnical.TimeZoneSidKey='Asia/Shanghai';
		userTechnical.LocaleSidKey='en_US';
		userTechnical.EmailEncodingKey='ISO-8859-1';
		userTechnical.LanguageLocaleKey='en_US';

		insert userTechnical;
		
		//sales
		Profile p2 = [SELECT ID,Name from Profile where name=:'Sales Australia' Limit 1];
		User SalesAustralia =new User(Username ='u'+System.now().getTime()+'@163.com',
				Email = 'erinsun1997@163.com',
				FirstName = 'Verma',
				LastName = 'Alok',
				Alias = 'Verma',
				ProfileId = p2.Id,
                Contract_Approver__c = userFinance.Id,
                BMO_specialist__c = userFinance.Id );
        SalesAustralia.TimeZoneSidKey='Asia/Shanghai';
		SalesAustralia.LocaleSidKey='en_US';
		SalesAustralia.EmailEncodingKey='ISO-8859-1';
		SalesAustralia.LanguageLocaleKey='en_US';

        insert SalesAustralia;

		Account account = new Account(Name = 'Test');
		insert account;

		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU').getRecordTypeId();
		Opportunity opp = new Opportunity(
				RecordTypeId = RecordTypeId,
				AccountId = account.Id,
				Name = '4MW-TEST-20200525',
				StageName = 'Price Quote',
				CloseDate = Date.today(),
				SOC_Dept__c = 'pending',
				SOC_Dept_Comments__c = '111',
				Finance_Approval_Status__c = 'pending',
				Finance_Dept_Comments__c = '111',
				GM_approval_Status__c = 'pending',
				Technical_Dept_Status__c = 'pending',
				Legal_Dept__c = 'pending',
				OwnerId = SalesAustralia.Id,
				Jinko_Parent_Company_Guarantee_needed__c = 'NO'

		);
		insert opp;


		Integer intReviewRes = 0;



		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		MOUApproveEmailService mouApproveEmailService = new MOUApproveEmailService();
		User userTest = [SELECT ID,EMAIL from User WHERE ID=:'00590000002T0zz'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
		email.subject = '[#RVID:'+ opp.Id +'#]Please review this opportunity';

		email.plainTextBody = 'reject\nTest002';
		mouApproveEmailService.handleInboundEmail( email , env );

		email.plainTextBody = 'yes\nTest001';
		mouApproveEmailService.handleInboundEmail( email , env );



	}


}