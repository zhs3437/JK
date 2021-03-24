@isTest
public class ContractAdditionCostPMCTest
{
    @isTest
    static void test()
    {
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        Product2 product = TestHelper.createProduct2(false);
        product.Product_Module_PM__c = 'R-P-163.75-78TR-M';
        product.Name = 'Test Product';
        insert product;
        PricebookEntry pbe = TestHelper.createPricebookEntry(product.id, false);
        insert pbe;
        Contract contract = TestHelper.createContract([SELECT Id FROM Account LIMIT 1][0].Id, false);
        contract.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Inventory_Contract').getRecordTypeId();
        contract.Land_Freight_China__c = 0.001;
        contract.Ocean_Freight__c = 0.001;
        contract.Land_Freight_Oversea__c = 0.001;
        contract.Region__c = 'North America';
        contract.Destination_Port__c = 'Los Angelas';
        contract.Trade_term__c = 'DAP';
        contract.Warehouse_Premium__c = 0.001;
        contract.Logistic_Special_Cost_Per_W__c = 0.001;
        insert contract;

        Product_Detail__c contractItem = TestHelper.createProductDetail(false);
        contractItem.Contract_PO_PI__c = contract.Id;
        contractItem.Quantity__c = 100;
        contractItem.Unit_Price__c = 0.5;
        contractItem.Estimated_Gross_Margin__c = 0.1;
        contractItem.Product_Cost__c = 0.01;
        contractItem.Total_MW__c = 1.2;
        contractItem.Product__c = product.Id;
        insert contractItem;
        contract.Additional_Cost_PMC__c = 1000000;
        update contract;
    }
}