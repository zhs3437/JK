@IsTest
private class MOUOpportunityCreationTest {

	@IsTest
	static void opportunityCreation() {
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU').getRecordTypeId();
        System.debug('RecordTypeId---->'+RecordTypeId);
		Pricebook2 standardPricebook = new Pricebook2(
				IsActive = true,
				Name = 'USDPricebook'
		);
		insert standardPricebook;
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
				Name = '4MW-JKM305P-72-20170101',
				StageName = 'Price Quote',
				CloseDate = Date.today(),
				CurrencyIsoCode = 'USD'
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

		Payment__c payment = new Payment__c(
				Opportunity__c = opp.Id,
            	 Days__c  = 15,
             Payment_Term__c = 'x% OA X days by TT from the BL/Delivery Date',
            Percentage__c = 50,
            Down_Balance_Payment__c = 'Down Payment'
		);
        Payment__c payment2 = new Payment__c(
				Opportunity__c = opp.Id,
            	 Days__c  = 15,
             Payment_Term__c = 'x% OA X days by TT from the BL/Delivery Date',
            Percentage__c = 50,
            Down_Balance_Payment__c = 'Down Payment'
		);
		Test.startTest();
		ApexPages.currentPage().getParameters().put('Id', account.Id);
		ApexPages.currentPage().getParameters().put('recordTypeId', RecordTypeId);
		ApexPages.StandardController standardController = new ApexPages.StandardController(account);

		MOUOpportunityCreation MOUOpportunity = new MOUOpportunityCreation(standardController);
		MOUOpportunity.paymentList.add(payment);
        MOUOpportunity.paymentList.add(payment2);
        system.debug('paymentList---->'+MOUOpportunity.paymentList[0].Percentage__c);
        system.debug('paymentList---->'+MOUOpportunity.paymentList.size());
		MOUOpportunity.addOpportunityPayment();
        
		MOUOpportunity.savePayment();
		MOUOpportunity.editPayment();
		MOUOpportunity.delCount = 1;
		MOUOpportunity.delPayment();
        system.debug('paymentList----22>'+MOUOpportunity.paymentList.size());
		MOUOpportunity.opportunityLineItemList.add(oppLineItem);
		MOUOpportunity.opportunityLineItemList.add(oppLineItem01);
        
		MOUOpportunity.saveItem();
		MOUOpportunity.editItem();
		MOUOpportunity.addOpportunityLineItem();
		MOUOpportunity.delCount = 3;
		MOUOpportunity.delItem();
		MOUOpportunity.MOUOpportunity.CloseDate = Date.today();
		MOUOpportunity.MOUOpportunity.StageName = 'Prospecting';
        /*Payment__c payment2 = new Payment__c(
				Opportunity__c = opp.Id,
            	 Days__c  = 15,
             Payment_Term__c = 'x% OA X days by TT from the BL/Delivery Date',
            Percentage__c = 50,
            Down_Balance_Payment__c = 'Down Payment'
		);
        MOUOpportunity.paymentList.add(payment2);*/
        //MOUOpportunity.initPaymentList.add(payment2);
		MOUOpportunity.saveAll();

		Test.stopTest();
	}

	@IsTest
	static void opportunityEdit() {
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
				CloseDate = Date.today(),
				CurrencyIsoCode = 'USD'
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
            	Days__c  = 5,           
            Percentage__c = 100,
            Down_Balance_Payment__c = 'Down Payment',
            Payment_Term__c = 'x% DP X days after the Execution Date'
		);
		insert payment;
		Test.startTest();
		ApexPages.currentPage().getParameters().put('OppId', opp.Id);
		ApexPages.StandardController standardController = new ApexPages.StandardController(account);

		MOUOpportunityCreation MOUOpportunity = new MOUOpportunityCreation(standardController);
		MOUOpportunity.addOpportunityPayment();
		MOUOpportunity.delCount = 2;
		MOUOpportunity.delPayment();
		MOUOpportunity.delCount = 1;
		MOUOpportunity.savePayment();
		MOUOpportunity.delCount = 1;
		MOUOpportunity.editPayment();

		MOUOpportunity.saveItem();
		MOUOpportunity.editItem();
		MOUOpportunity.delCount = 2;
		MOUOpportunity.delItem();
		MOUOpportunity.saveAll();
		Test.stopTest();
	}
}