@isTest
private class sapAccountTest {

    static testMethod void myUnitTest() {
		sapAccount.ZSCRM001_1       ZSCRM001_1 = new sapAccount.ZSCRM001_1();
		sapAccount.TABLE_OF_ZKNVV   TABLE_OF_ZKNVV = new sapAccount.TABLE_OF_ZKNVV();
		sapAccount.ZSCRM001         ZSCRM001 = new sapAccount.ZSCRM001();
		sapAccount.TABLE_OF_ZKNB1   TABLE_OF_ZKNB1 = new sapAccount.TABLE_OF_ZKNB1();
		sapAccount.TABLE_OF_ZSCRM001_1 TABLE_OF_ZSCRM001_1 = new sapAccount.TABLE_OF_ZSCRM001_1();
		sapAccount.ZKNVV ZKNVV = new sapAccount.ZKNVV();
		sapAccount.ZKNB1 ZKNB1 = new sapAccount.ZKNB1();
		sapAccount.ZCRMSDD_CREAT_CUSTOMER_element CUSTOMER_element = new sapAccount.ZCRMSDD_CREAT_CUSTOMER_element();
		sapAccount.ZCRMSDD_CREAT_CUSTOMERResponse_element CUSTOMERResponse_element = new sapAccount.ZCRMSDD_CREAT_CUSTOMERResponse_element();
		sapAccount.ZCRMSDD_CREAT_CUSTOMER tool = new sapAccount.ZCRMSDD_CREAT_CUSTOMER();
		tool.ZCRMSDD_CREAT_CUSTOMER(ZSCRM001, TABLE_OF_ZKNB1, TABLE_OF_ZKNVV, TABLE_OF_ZSCRM001_1);
    }
}