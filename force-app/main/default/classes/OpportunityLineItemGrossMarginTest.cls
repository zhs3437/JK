@isTest
public without sharing class OpportunityLineItemGrossMarginTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        Product2 product = TestHelper.createProduct2(false);
        product.Product_Module_PM__c = 'R-P-163.75-78TR-M';
        product.Name = 'Test Product';
        insert product;
        PricebookEntry pbe = TestHelper.createPricebookEntry(product.id, false);
        insert pbe;
        insert new Port_freight_maintenance__c(
            Name = 'Los Angelas',
            Warehouse_Premium__c = 6666
        );

        insert new Product_Cost_Maintenance__c(
            Name = product.Product_Module_PM__c,
            Start_Date__c = Date.valueOf('2020-01-01'),
            Q1_End_Date_This_Year__c = Date.valueOf('2020-03-01'),
            Q1_This_Year__c = 0.001,
            Q2_End_Date_This_Year__c = Date.valueOf('2020-06-01'),
            Q2_This_Year__c = 0.001,
            Q3_End_Date_This_Year__c = Date.valueOf('2020-09-01'),
            Q3_This_Year__c = 0.001,
            Q4_End_Date_This_Year__c = Date.valueOf('2020-12-01'),
            Q4_This_Year__c = 0.001,
            Q1_End_Date_Next_Year__c = Date.valueOf('2021-03-01'),
            Q1_Next_Year__c = 0.001,
            Q2_End_Date_Next_Year__c = Date.valueOf('2021-06-01'),
            Q2_Next_Year__c = 0.001,
            Q3_End_Date_Next_Year__c = Date.valueOf('2021-09-01'),
            Q3_Next_Year__c = 0.001,
            Q4_End_Date_Next_Year__c = Date.valueOf('2021-12-01'),
            Q4_Next_Year__c = 0.001,
            Cost_Type__c = 'Product'
        );

        insert new Product_Cost_Maintenance__c(
            Name = 'North America',
            Start_Date__c = Date.valueOf('2020-01-01'),
            Q1_End_Date_This_Year__c = Date.valueOf('2020-03-01'),
            Q1_This_Year__c = 0.001,
            Q2_End_Date_This_Year__c = Date.valueOf('2020-06-01'),
            Q2_This_Year__c = 0.001,
            Q3_End_Date_This_Year__c = Date.valueOf('2020-09-01'),
            Q3_This_Year__c = 0.001,
            Q4_End_Date_This_Year__c = Date.valueOf('2020-12-01'),
            Q4_This_Year__c = 0.001,
            Q1_End_Date_Next_Year__c = Date.valueOf('2021-03-01'),
            Q1_Next_Year__c = 0.001,
            Q2_End_Date_Next_Year__c = Date.valueOf('2021-06-01'),
            Q2_Next_Year__c = 0.001,
            Q3_End_Date_Next_Year__c = Date.valueOf('2021-09-01'),
            Q3_Next_Year__c = 0.001,
            Q4_End_Date_Next_Year__c = Date.valueOf('2021-12-01'),
            Q4_Next_Year__c = 0.001,
            Cost_Type__c = 'Region'
        );

        Opportunity opportunity = new Opportunity(
            AccountId = [SELECT Id FROM Account LIMIT 1][0].Id,
            Name = '4MW-JKM305P-72-20170101',
            StageName = 'PO Imminent',
            Trade_Term__c = 'DAP',
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales').getRecordTypeId(),
            CloseDate = Date.valueOf('2022-02-07'),
            Warranty_Insurance__c = 'AR',
            Reason_of_apply_for_insurance__c = '666',
            Destination_Country__c = 'United States',
            Region__c = 'North America',
            Destination_Port__c = 'Los Angelas',
            Commission_Type__c = 'Per/W',
            Commision__c = 0.001,
            Rebate_Type_new__c = '%',
            Rebate_new__c = 1,
            Warehouse_or_Factory__c = 'Warehouse',
            Local_Warehouse__c = 'Mexico Warehouse',
            // required in contract
            delivey_point__c = 'test point',
            Jinko_Parent_Company_Guarantee_needed__c = 'NO'
        );

        insert opportunity;

        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opportunity.id, [SELECT Id FROM PricebookEntry LIMIT 1][0].Id, false);
        // item.Product_Type__c = 'Test Product';
        item.Guaranteed_Delivery_Date__c = Date.valueOf('2021-11-01');
        insert item;
        
        // User admin = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1][0];
        Id recordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Inventory_Contract').getRecordTypeId();
        System.runAs(admin){
            Contract contract = TestHelper.createContract([SELECT Id FROM Account LIMIT 1][0].Id, false);
            contract.RecordTypeId = recordTypeId;
            contract.Opportunity__c = [SELECT Id, Actual_Commission__c FROM Opportunity LIMIT 1][0].Id;
            contract.Land_Freight_China__c = 0.001;
            contract.Ocean_Freight__c = 0.001;
            contract.Land_Freight_Oversea__c = 0.001;
            contract.Region__c = 'North America';
            contract.Destination_Port__c = 'Los Angelas';
            contract.Trade_term__c = 'DAP';
            contract.Warehouse_Premium__c = 0.001;
            contract.Logistic_Special_Cost_Per_W__c = 0.001;
            contract.OwnerId = admin.Id;
            insert contract;

            Product_Detail__c contractItem = TestHelper.createProductDetail(false);
            contractItem.Contract_PO_PI__c = contract.Id;
            contractItem.Quantity__c = 100;
            contractItem.Unit_Price__c = 0.5;
            contractItem.Estimated_Gross_Margin__c = 0.1;
            contractItem.Product_Cost__c = 0.01;
            contractItem.OppProductID__c = contractItem.Id;
            insert contractItem;
       
        Order aOrder = TestHelper.createOrder(false);
        ID AccountId = [SELECT Id FROM Account LIMIT 1][0].Id;
        aOrder.Buyer__c = AccountId;
        aOrder.BillingCountry = 'aaa';
        aOrder.BillingPostalCode = 'bbb';
        aOrder.BillingState = 'ccc';
        aOrder.BillingCity = 'ddd';
        aOrder.BillingStreet = 'eee';
        aOrder.Contract_No__c = 'MCXXXX13QXtest';
        aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
        aOrder.AccountId = AccountId;
        aOrder.EffectiveDate = Date.today();
        aOrder.Status = 'Draft';
        aOrder.MaxRowNo__c = 10;
        aOrder.Pricebook2Id =pbe.Pricebook2Id;
        insert aOrder;
        
        OrderItem ordLine = TestHelper.createOrderItem(false);
        ordLine.OrderId = aOrder.Id;
        ordLine.PricebookEntryId = pbe.Id;
        ordLine.Quantity = 10;
        ordLine.UnitPrice = 1;
        insert ordLine;
        
        List<OrderItem> ordItemLst = new List<OrderItem>();
        ordItemLst.add(ordLine);
        
        }
    }

    @isTest static void test_calculate_opportunity() {
        Test.startTest();
        // Opportunity opportunity = [SELECT Id, Trade_Term__c FROM Opportunity LIMIT 1][0];
        // update opportunity;
        
        OpportunityLineItem item = [SELECT Id FROM OpportunityLineItem LIMIT 1][0];
        update item;
        Test.stopTest();
    }

    @isTest static void test_calculate_contract() {
        Test.startTest();
        // Contract contract = [SELECT Id FROM Contract LIMIT 1][0];
        // update contract;

        Product_Detail__c item = [SELECT Id FROM Product_Detail__c LIMIT 1][0];
        update item;
        Test.stopTest();
    }
    
     @isTest static void test_calculate_Order() {
        Test.startTest();
        // Contract contract = [SELECT Id FROM Contract LIMIT 1][0];
        // update contract;
       
        OrderItem item = [SELECT Id FROM OrderItem LIMIT 1][0];
        update item;
        Test.stopTest();
    }
    
    

    
    @isTest static void test_calculate_technology() {
        Map<String, Object> dataMap = new Map<String, Object>{
            'contractId' => [SELECT Id FROM Contract LIMIT 1][0].Id
        };
        
        Map<String, Object> data = (Map<String, Object>)OpportunityLineItemGrossMarginHandler.getProductByContractId(JSON.serialize(dataMap));
        OpportunityLineItemGrossMarginHandler.setProductByContractId(JSON.serialize(data.get('data')));
    }
}