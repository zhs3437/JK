@isTest
public without sharing class RC_AdminBatchTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        Product2 product = QW_TestDataFactory.createProduct2();
        insert product;
        leanx__pm_Project__c project = QW_TestDataFactory.createIProject();
        project.Sales_Dept__c = 'Sales Oversea';
        insert project;
        Opportunity opportunity = QW_TestDataFactory.createOpportunity();
        insert opportunity;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
    }

    @isTest 
    static void test_product() {
        Test.startTest();
        RC_AdminBatch batch = new RC_AdminBatch('product');
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    @isTest 
    static void test_SyncReport() {
        Test.startTest();
        RC_AdminBatch batch = new RC_AdminBatch('Sync Report');
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    @isTest 
    static void test_DeleteSyncReport() {
        Test.startTest();
        RC_AdminBatch batch = new RC_AdminBatch('Delete Sync Report');
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    @isTest 
    static void test_SyncMaterial() {
        QW_MockHttpResponseGenerator mock = new QW_MockHttpResponseGenerator();
        RC_ComCrmCrmMaterialsData.DT_MaterialsData_Response result = new RC_ComCrmCrmMaterialsData.DT_MaterialsData_Response();
        RC_ComCrmCrmMaterialsData.ET_MODMAT_element element_mat = new RC_ComCrmCrmMaterialsData.ET_MODMAT_element();
        element_mat.MATNR = 'T001';
        element_mat.MAKTX = 'T001';
        element_mat.BISMT = 'T001';
        element_mat.SATNR = 'T001';
        element_mat.MAKTX_JK = 'T001';
        
        RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element element_matchr = new RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element();
        element_matchr.MATNR = 'T001';
        element_matchr.ATNAM = 'T001';
        element_matchr.ATBEZ = 'T001';
        element_matchr.ATWRT = 'T001';
        element_matchr.ATWTB = 'T001';
        result.ET_MODMAT = new List<RC_ComCrmCrmMaterialsData.ET_MODMAT_element>{
            element_mat
        };
        result.ET_MODMATCHRCT = new List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element>{
            element_matchr
        };
        mock.responseElement = result;
        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();
        RC_AdminBatch batch = new RC_AdminBatch('Sync Material');
        Database.executeBatch(batch);
        Test.stopTest();
    }

    @isTest 
    static void test_Schedule() {
        Test.startTest();
        RC_AdminBatch batch = new RC_AdminBatch('Sync Report');
        System.schedule(
            'test Sync Report Schedule',
            '0 0 0 3 9 ? 2022',
            batch
        );
        Test.stopTest();
    }
}