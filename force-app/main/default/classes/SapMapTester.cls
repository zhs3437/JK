@isTest
private with sharing class SapMapTester {   
    
    static testMethod void coverTypes() {
        SapMap.getAreaCode('China');
        SapMap.getCountryOACode('China');
        SapMap.getWH_Opposite('F002');
        SapMap.getSalesGroup('China');
        SapMap.getWH('F002');
        SapMap.getPlant('Gebze Warehouse');
        SapMap.getCountryCode('China');
        SapMap.getEU('China');
        SapMap.getSellerCode('JinkoSolar GmbH');
        SapMap.getSalesRegion('EU');
        SapMap.getOwnerRegion('EU');
        SapMap.getPickListValue('2-2BB');
    }

}