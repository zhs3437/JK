@isTest
public without sharing class RC_CostCenterTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        Product2 product2 = QW_TestDataFactory.createProduct2();
        // product2.Name = 'Test Product';
        insert product2;
        leanx__hr_Resource__c product = [SELECT Id, Product_Module_PM__c FROM leanx__hr_Resource__c][0];
        // product.Name = 'Test Product';
        // product.leanx__EmployerNumber__c = product2.Id;
        // insert product;
        leanx__pm_Project__c project = QW_TestDataFactory.createIProject();
        insert project;
        leanx__pm_ProjectMember__c projectItem = QW_TestDataFactory.createIProjectItemById(project.Id);
        projectItem.Product_Series__c = 'Test Product';
        projectItem.Product__c = product.Id;
        insert projectItem;
        leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract();
        insert contract;
        Payment__c payment = QW_TestDataFactory.createPayment();
        payment.China_Project__c = project.Id;
        payment.China_Contract__c = contract.Id;
        insert payment;
        Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
        contractItem.Product_Series__c = 'Test Product';
        contractItem.Product__c = product.Id;
        insert contractItem;
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
    }

    @isTest 
    static void test_calculate_project() {
        Test.startTest();        
        leanx__pm_ProjectMember__c item = [SELECT Id FROM leanx__pm_ProjectMember__c LIMIT 1][0];
        update item;
        Test.stopTest();
    }

    @isTest 
    static void test_calculate_contract() {
        Test.startTest();
        Contract_Component__c item = [SELECT Id FROM Contract_Component__c LIMIT 1][0];
        update item;
        Test.stopTest();
    }

    
    @isTest 
    static void test_calculate_technology() {
        Map<String, Object> dataMap = new Map<String, Object>{
            'contractId' => [SELECT Id FROM leanx__lg_Contract__c LIMIT 1][0].Id
        };
        
        Map<String, Object> data = (Map<String, Object>)RC_CostCenter.getProductByContractId(JSON.serialize(dataMap));
        RC_CostCenter.setProductByContractId(JSON.serialize(data.get('data')));
    }
}