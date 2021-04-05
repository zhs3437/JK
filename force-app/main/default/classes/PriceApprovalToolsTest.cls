@isTest
public class PriceApprovalToolsTest {
	private static testMethod void submitTest(){
   
        
        
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
				CurrencyIsoCode = 'USD',
            	Total_MW_Framework_Text__c = 1,
				Jinko_Parent_Company_Guarantee_needed__c = 'NO'
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
        
  
		
                 	OpportunityLineItem item =null;
        string recordTypeId2 = null;
    	
    	Account acc2 = TestHelper.createAccount();
        Product2 p2 = TestHelper.createProduct2();
        PriceBookEntry pbe =TestHelper.createPriceBookEntry(p2.id);
		
    	Opportunity opp2 = TestHelper.createOpportunity(acc2.Id,false); 
        opp2.Land_Freight_China__c = null;
        opp2.Land_Freight_Oversea__c = null;
        opp2.Ocean_Freight__c = null;
        opp2.Trade_Term__c = 'DDP';
        opp2.Opportunity_Type__c = 'Under Frame';
        opp2.Frame_Contract_opportunity__c = opp.Id;
        insert opp2;
              OpportunityLineItem oppLineItem2 = new OpportunityLineItem(
				OpportunityId = opp2.Id,
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
        
    PriceApprovalTools.main(opp2.Id);
        PriceApprovalTools.SetPODate(opp.Id);
        opp.Lock__c =false;
        update opp;
        PriceApprovalTools.SetPODate(opp.Id);
        PriceApprovalTools.MouUpdate(opp.Id,oppLineItem01.Trade_Term__c);
        PriceApprovalTools.MouUpdate(opp.Id,'');
    }
}