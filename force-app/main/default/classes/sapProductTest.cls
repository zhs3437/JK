@isTest
private class sapProductTest {

    static testMethod void myUnitTest() {
		sapProduct.ZCRM_MATERIAL_MASTERResponse_element Response_element = new sapProduct.ZCRM_MATERIAL_MASTERResponse_element();
		sapProduct.ZCRM_MATERIAL_MASTER_element element = new sapProduct.ZCRM_MATERIAL_MASTER_element();
		sapProduct.TABLE_OF_ZCRM_ZMADA T_ZCRM_ZMADA = new sapProduct.TABLE_OF_ZCRM_ZMADA();
		sapProduct.ZCRM_ZMADA zcrm = new sapProduct.ZCRM_ZMADA();
		T_ZCRM_ZMADA.item.add(zcrm);
		sapProduct.ZCRM_MATERIAL_MASTER tool = new sapProduct.ZCRM_MATERIAL_MASTER();
		tool.ZCRM_MATERIAL_MASTER('','',T_ZCRM_ZMADA);
    }
}