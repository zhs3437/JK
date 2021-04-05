@IsTest
private class MOUFrameworkAgreementApprovalCtrlTest {
	@IsTest
	static void frameworkAgreementDate() {
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


		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU').getRecordTypeId();
		Account account = new Account(Name = 'Test');
		insert account;
		Opportunity opp = new Opportunity(
				RecordTypeId = RecordTypeId,
				AccountId = account.Id,
				Name = '4MW-TEST-20200525',
				StageName = 'Price Quote',
				Lock__c = true,
				CloseDate = Date.today(),
            	OwnerId = SalesAustralia.Id,
				Jinko_Parent_Company_Guarantee_needed__c = 'NO'
		);
		insert opp;
		Supplementary_Framework_Agreement__c SFA = new Supplementary_Framework_Agreement__c(
				Lock__c = true,
				Name = 'Test',
				Opportunity__c = opp.Id
		);
		insert SFA;
		Test.startTest();
		MOUFrameworkAgreementApprovalController.MOUFrameworkAgreementApprovalController(SFA.Id);
		Test.stopTest();
	}
}