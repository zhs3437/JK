@isTest
private class SapIntegrationUtilsTest {

    static testMethod void myUnitTest() {
		SAP_Product__c sapProduct = generateSapProduct();
		
		sapProduct sp = new sapProduct();
		
		sapProduct.ZCRM_ZMADA zcrm = new sapProduct.ZCRM_ZMADA();
		zcrm.MAKTX = 'JKM-260';
		zcrm.MATNR = '000000000024000030';
		zcrm.BISMT = 'A124';
		zcrm.ERSDA = '2014-09-23';
		zcrm.ERNAM = '';
		zcrm.LAEDA = '2016-06-07';
		zcrm.AENAM = '';
		zcrm.ZS01 = 'P';
		zcrm.ZS01T = 'P';
		zcrm.ZS41 = '156';
		zcrm.ZS41T = '156';
		zcrm.ZS42 = '60';
		zcrm.ZS42T = '60';
		zcrm.ZS43 = '1';
		zcrm.ZS43T = '1';
		zcrm.ZS44 = '260';
		zcrm.ZS44T = '260';
		zcrm.ZS45 = 'NS';
		zcrm.ZS45T = 'NS';
		zcrm.ZS46 = 'NP';
		zcrm.ZS46T = 'NP';
		zcrm.ZS47 = 'B';
		zcrm.ZS47T = 'B';
		zcrm.ZS48 = '1';
		zcrm.ZS48T = '1';
		zcrm.ZS49 = '2';
		zcrm.ZS49T = '2';
		zcrm.ZS4A = '0';
		zcrm.ZS4AT = '0';
		zcrm.ZS4B = '2';
		zcrm.ZS4BT = '2';
		
		SapIntegrationUtils.transformSapProduct(sapProduct,zcrm);
		
		sapProductDelete tool_delete = new sapProductDelete();
    }
    
    public static SAP_Product__c generateSapProduct(){
    	SAP_Product__c sapProduct = new SAP_Product__c();
    	sapProduct.Bus_bars_of_cell__c       = '3-3BB';
    	sapProduct.Cell_Len__c               = '156-156';
    	sapProduct.Cell_Number__c            = '60-60';
    	sapProduct.Certification__c          = '1-TUV';
    	sapProduct.Color_of_Module__c	     = '2-White';
    	sapProduct.Grade__c                  = 'A-Grade A';
    	sapProduct.Model_Type__c             = 'P-Polycrystalline';
    	sapProduct.OEM_Flag__c               = '1-JKM';
    	sapProduct.performance__c            = 'P-PID module';
    	sapProduct.Power_W__c                = '245-245';
    	sapProduct.Product_Code__c           = '24000016';
    	sapProduct.Product_Description__c    = 'JKM245PP-60-J/3BB/TUV/A';
    	sapProduct.Product_Name__c           = 'JKM245PP-60-J';
    	sapProduct.Special_required__c       = 'J-Japan';
    	sapProduct.Type_of_module__c         = 'NS-Non smart module';
    	sapProduct.SAP_Last_Modified_By__c   = 'Mone';
    	sapProduct.SAP_Last_Modified_Date__c = '2016-06-07';    
    	insert sapProduct;
    	
    	return sapProduct;
    }
    
}