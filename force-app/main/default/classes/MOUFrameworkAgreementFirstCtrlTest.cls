@IsTest
private class MOUFrameworkAgreementFirstCtrlTest {

	@IsTest
	static void opportunityApproveAgain() {
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU').getRecordTypeId();
		Account account = new Account(Name = 'Test');
		insert account;
		Product2 product2 = new Product2(name = 'Product' + Math.random());
		insert product2;

		PriceBookEntry entry = new PriceBookEntry(
				PriceBook2ID = Test.getStandardPriceBookID(),
				product2ID = product2.id,
				unitPrice = 120,
				UseStandardPrice = false,
				isActive = true
		);
		insert entry;

		Opportunity opp = new Opportunity(
				RecordTypeId = RecordTypeId,
				AccountId = account.Id,
				Name = '4MW-TEST-20200525',
				StageName = 'Price Quote',
				Lock__c = true,
				CloseDate = Date.today()
		);
		insert opp;

		OpportunityLineItem oppLineItem = new OpportunityLineItem(
				OpportunityId = opp.Id,
				Quantity = 100,
				TotalPrice = 120.00,
				PricebookEntryId = entry.Id,
				Battery_Type__c = 'Normal Cell',
				Bus_bars_of_cell__c = '2-2BB',
				Certification__c = '1-TUV',
				Color_of_Module__c = '3-Black frame and white backsh',
				Grade__c = 'A-Grade A',
				Special_required__c = '0-commonly',
				Type_of_module__c = 'NS-Non smart module',
				Guaranteed_Delivery_Date__c = Date.Today()
		);
		insert oppLineItem;

		Payment__c payment = new Payment__c(
				Opportunity__c = opp.Id,
             Percentage__c = 100,
            	Days__c  = 5,
            Down_Balance_Payment__c = 'Down Payment',
            Payment_Term__c = 'x% DP X days after the Execution Date'
           
            
		);
		insert payment;
		Test.startTest();
		MOUFrameworkAgreementFirstCreate.saveFrameworkAgreement(opp.Id);
		Test.stopTest();
	}
}