@isTest
private class sapOrderTest {
	static testMethod void myUnitTest() {
		sapOrder.TABLE_OF_ZSFI_PYTM2      TABLE_OF_ZSFI_PYTM2 = new sapOrder.TABLE_OF_ZSFI_PYTM2();
		sapOrder.ZSDI0003_element         ZSDI0003_element = new sapOrder.ZSDI0003_element();
		sapOrder.ZSFI_PYTM2               ZSFI_PYTM2 = new sapOrder.ZSFI_PYTM2();
		sapOrder.ZSDI0003Response_element ZSDI0003Response_element = new sapOrder.ZSDI0003Response_element();
		sapOrder.TABLE_OF_ZVBAP           TABLE_OF_ZVBAP = new sapOrder.TABLE_OF_ZVBAP();
		sapOrder.ZVBAP                    ZVBAP = new sapOrder.ZVBAP();
		sapOrder.ZVBAK                    ZVBAK = new sapOrder.ZVBAK();
		sapOrder.ZSDI0003A                tool = new sapOrder.ZSDI0003A();
		tool.ZSDI0003(ZVBAK,TABLE_OF_ZSFI_PYTM2,TABLE_OF_ZVBAP);
	}
}