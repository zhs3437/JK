@IsTest
private class MOUOpportunityVersionUpdateCtrlTest {
	@IsTest
	static void testVersionUpdate() {
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
            	Days__c  = 15,
             Payment_Term__c = 'x% OA X days by TT from the BL/Delivery Date',
            Percentage__c = 50,
            Down_Balance_Payment__c = 'Down Payment'
		);
		insert payment;

		Supplementary_Framework_Agreement__c SFA = new Supplementary_Framework_Agreement__c(
				Opportunity__c = opp.Id,
				Account__c = account.Id,
				StageName__c  = 'Price Quote',
				Close_Date__c = Date.today()
		);
		insert SFA;
		Framework_Agreement_Payment__c FAPay01 = new Framework_Agreement_Payment__c(
				Supplementary_framework_agreement__c = SFA.Id
		);
		//insert FAPay01;
		Framework_Agreement_Payment__c FAPay02 = new Framework_Agreement_Payment__c(
				Supplementary_framework_agreement__c = SFA.Id,
				MOU_Opportunity_Payment_Id__c = payment.Id
		);
		//insert FAPay02;
		Framework_Agreement_Product__c FAPro01 = new Framework_Agreement_Product__c(
				Supplementary_framework_agreement__c = SFA.Id,
				Quantity__c = 10,
				Sales_Price__c = 120,
				Product2__c = product2.Id,
            Guaranteed_Delivery_Date__c = date.today()
		);
		//insert FAPro01;
		Framework_Agreement_Product__c FAPro02 = new Framework_Agreement_Product__c(
				Supplementary_framework_agreement__c = SFA.Id,
				Quantity__c = 10,
				Sales_Price__c = 120,
				Product2__c = product2.Id,
				MOU_Opportunity_Product_Id__c = oppLineItem.Id,
             Guaranteed_Delivery_Date__c = date.today()
		);
		//insert FAPro02;
		MOUOpportunityVersionUpdateController.turnaroundMOUFiled(SFA.Id);
	}
}