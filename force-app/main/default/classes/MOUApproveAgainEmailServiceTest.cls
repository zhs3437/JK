@IsTest
public class MOUApproveAgainEmailServiceTest {
	static testmethod void myUnitTest(){
	
	//finance
	Profile p = [SELECT ID,Name from Profile where name=:'Finance' Limit 1];
		User userFinance =new User(Username ='u'+System.now().getTime()+'@163.com',
					Email = 'erinsun1996@163.com',
					FirstName = 'Alex',
					LastName = 'jiang',
					Alias = 'Alexjian',
					ProfileId = p.id);

		userFinance.TimeZoneSidKey='Asia/Shanghai';
		userFinance.LocaleSidKey='en_US';
		userFinance.EmailEncodingKey='ISO-8859-1';
		userFinance.LanguageLocaleKey='en_US';

		insert userFinance;

	//Technical
	Profile p2 = [SELECT ID,Name from Profile where name=:'Technical' Limit 1];
		User userTechnical =new User(Username ='u'+System.now().getTime()+'@163.com',
				Email = 'sunxiaoxiaoxia2@163.com',
				FirstName = 'tech',
				LastName = '2',
				Alias = 'technic2',
				ProfileId = p2.Id);


		userTechnical.TimeZoneSidKey='Asia/Shanghai';
		userTechnical.LocaleSidKey='en_US';
		userTechnical.EmailEncodingKey='ISO-8859-1';
		userTechnical.LanguageLocaleKey='en_US';

		insert userTechnical;

        //sales
		Profile p3 = [SELECT ID,Name from Profile where name=:'Sales Australia' Limit 1];
		User SalesAustralia =new User(Username ='u'+System.now().getTime()+'@163.com',
				Email = 'erinsun1997@163.com',
				FirstName = 'Verma',
				LastName = 'Alok',
				Alias = 'Verma',
				ProfileId = p3.Id,
               Contract_Approver__c = userFinance.Id,                       
               BMO_specialist__c = userFinance.Id);
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
				OwnerId = SalesAustralia.Id
		);
		insert opp;
		Supplementary_Framework_Agreement__c sfa = new Supplementary_Framework_Agreement__c();
		sfa.Opportunity__c = opp.Id;
		sfa.SOC_Dept__c = 'pending';
		sfa.SOC_Dept_Comments__c = '111';
		sfa.Finance_Price_Approval_Status__c = 'pending';
		sfa.Price_Approval_Feedback_Comments__c = '111';
		sfa.Legal_Dept__c = 'pending';
		sfa.Legal_Dept_Comments__c = '111';
		sfa.GM_approval_Status__c = 'pending';
		sfa.GM_approval_Comments__c = '111';
		sfa.Technical_Dept_Status__c = 'pending';
		sfa.Technical_Dept_Comments__c = '111';
		sfa.Opportunity__c = opp.Id;
		insert sfa;

		Integer intReviewRes = 0;



		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		MOUApproveAgainEmailService mouApproveAgainEmailService = new MOUApproveAgainEmailService();
		User userTest = [SELECT ID,EMAIL from User WHERE ID=:'00590000002T0zz'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
		email.subject = '[#RVID:'+ sfa.Id +'#]Please review this opportunity';

		email.plainTextBody = 'reject\nTest002';
		mouApproveAgainEmailService.handleInboundEmail( email , env );

		email.plainTextBody = 'yes\nTest001';
		mouApproveAgainEmailService.handleInboundEmail( email , env );
		Supplementary_Framework_Agreement__c sfAgreement=[SELECT ID From Supplementary_Framework_Agreement__c Where ID=:sfa.Id];



	}


}