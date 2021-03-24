@IsTest
private class MOUOpportunityNewTest {
	@IsTest
	static void opportunityCreation() {

		Account account = new Account(Name = 'Test');
		insert account;
		Opportunity opportunity = new Opportunity();
		ApexPages.currentPage().getParameters().put('accId', account.Id);
		ApexPages.StandardController standardController = new ApexPages.StandardController(opportunity);
		MOUOpportunityNew mouOpportunityNew = new MOUOpportunityNew(standardController);
		mouOpportunityNew.MainrecordTypeName = '1';
		mouOpportunityNew.clickselect();
		mouOpportunityNew.nextPage();

		mouOpportunityNew.MainrecordTypeName = '2';
		mouOpportunityNew.clickselect();
		mouOpportunityNew.nextPage();
	}
}