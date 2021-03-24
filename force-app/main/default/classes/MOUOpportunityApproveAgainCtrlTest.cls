@IsTest
private class MOUOpportunityApproveAgainCtrlTest {
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
				PricebookEntryId = entry.Id,
				Battery_Type__c = 'Normal Cell',
				Bus_bars_of_cell__c = '2-2BB',
				Certification__c = '1-TUV',
				Color_of_Module__c = '3-Black frame and white backsh',
				Grade__c = 'A-Grade A',
				Special_required__c = '0-commonly',
				Type_of_module__c = 'NS-Non smart module',
				Guaranteed_Delivery_Date__c = Date.Today(),
				Trade_Term__c = 'DDU',
				MW__c = 1,
				UnitPrice = 1,
				Product2Id = product2.Id,
				Product_Type__c = 'Eagle Poly'
		);
		insert oppLineItem;

		OpportunityLineItem oppLineItem01 = new OpportunityLineItem(
				OpportunityId = opp.Id,
				Quantity = 100,
				PricebookEntryId = entry.Id,
				Battery_Type__c = 'Normal Cell',
				Bus_bars_of_cell__c = '2-2BB',
				Certification__c = '1-TUV',
				Color_of_Module__c = '3-Black frame and white backsh',
				Grade__c = 'A-Grade A',
				Special_required__c = '0-commonly',
				Type_of_module__c = 'NS-Non smart module',
				Guaranteed_Delivery_Date__c = Date.Today(),
				Trade_Term__c = 'DDU',
				MW__c = 1,
				UnitPrice = 1,
				Product2Id = product2.Id,
				Product_Type__c = 'Eagle Poly'
		);
		insert oppLineItem01;

		Payment__c payment = new Payment__c(
				Opportunity__c = opp.Id,
            Days__c  = 15,
            Payment_Term__c = 'x% OA X days by TT from the BL/Delivery Date',
            Percentage__c = 50,
            Down_Balance_Payment__c = 'Down Payment'
		);
		insert payment;
		Test.startTest();
		ApexPages.currentPage().getParameters().put('Id', opp.Id);
		ApexPages.StandardController standardController = new ApexPages.StandardController(opp);

		MOUOpportunityApproveAgainController MOUApprove = new MOUOpportunityApproveAgainController(standardController);
		MOUApprove.saveAgreement();
		MOUApprove.delCount = 2;
		MOUApprove.delItem();
		MOUApprove.delPayment();
		MOUApprove.editItem();
		MOUApprove.editPayment();
		MOUApprove.saveItem();
		MOUApprove.savePayment();
		MOUApprove.addOpportunityLineItem();
		MOUApprove.delCount = 2;
		MOUApprove.delItem();
		MOUApprove.addOpportunityPayment();
		Test.stopTest();
	}
}