@IsTest
private class MOUOpportunityButtonTest {
	@IsTest
	static void testOpportunityButton() {
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU').getRecordTypeId();
		Account account = new Account(Name = 'Test');
		insert account;
		Opportunity opp = new Opportunity(
				RecordTypeId = RecordTypeId,
				AccountId = account.Id,
				Name = '4MW-TEST-20200525',
				StageName = 'Price Quote',
				Lock__c = true,
				CloseDate = Date.today()
		);
		insert opp;
		opp.SOC_Dept__c = 'Approved';
		opp.Finance_Approval_Status__c = 'Approved';
		opp.GM_approval_Status__c = 'Approved';
		opp.Technical_Dept_Status__c = 'Approved';
		opp.Legal_Dept__c = 'Approved';
		update opp;

		Supplementary_Framework_Agreement__c SFA = new Supplementary_Framework_Agreement__c(
				Name = opp.Name,
				Opportunity__c = opp.Id,
            	StageName__c = 'PO Imminent',
            	Close_Date__c = date.today(),
            	Account__c = account.id
		);
		insert SFA;
		SFA.SOC_Dept__c = 'Approved';
		SFA.Finance_Price_Approval_Status__c = 'Approved';
		SFA.GM_approval_Status__c = 'Approved';
		SFA.Technical_Dept_Status__c = 'Approved';
		SFA.Legal_Dept__c = 'Approved';
		update SFA;

		String lockingJudgment = MOUOpportunityButton.lockingJudgment(opp.Id);
		System.assertEquals(lockingJudgment, '0');
		String cloneJudgment = MOUOpportunityButton.cloneJudgment(opp.Id);
		System.assertEquals(cloneJudgment, '0');
		String approveJudgment = MOUOpportunityButton.approveJudgment(SFA.Id);
		System.assertEquals(approveJudgment, '0');
	}
}