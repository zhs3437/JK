@isTest
public with sharing class CsvStrTester {
	static testMethod void myUnitTest() {
       CsvStr cs = new CsvStr();
       cs.convertString('targetString', 6);
    }
}