@isTest
private class sapProductDeleteTest {

    static testMethod void myUnitTest() {
		sapProductDelete.TABLE_OF_ZCRM_ZMADA_01 T_ZCRM_ZMADA = new sapProductDelete.TABLE_OF_ZCRM_ZMADA_01();
		sapProductDelete.ZCRM_DEL_MATERIAL_element ZCRM_DEL_MATERIAL_element = new sapProductDelete.ZCRM_DEL_MATERIAL_element();
		sapProductDelete.ZCRM_ZMADA_01 ZCRM_ZMADA_01 = new sapProductDelete.ZCRM_ZMADA_01();
		sapProductDelete.ZCRM_DEL_MATERIALResponse_element ZCRM_DEL_MATERIALResponse_element = new sapProductDelete.ZCRM_DEL_MATERIALResponse_element();
		sapProductDelete.ZCRM_DEL_MATERIAL tool = new sapProductDelete.ZCRM_DEL_MATERIAL();
		tool.ZCRM_DEL_MATERIAL(T_ZCRM_ZMADA);
    }
}