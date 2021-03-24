@isTest
private class TestNDATrigger {

    static testMethod void myUnitTest() {
        Requested_NDA__c rn = new Requested_NDA__c();
                                  
        User us = [Select Id,Name, Contract_Approver__c from  User Where id = '0059000000126GT'];
        
        rn.Contract_Approver__c = us.Contract_Approver__c ;
        
        insert rn;         
    }
}