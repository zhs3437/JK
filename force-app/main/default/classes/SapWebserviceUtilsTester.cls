@isTest
public class SapWebserviceUtilsTester {
    static testMethod void runSap(){
        Account acc = TestHelper.createAccount(false);
        acc.SAP_External_ID__c = '111';
        insert acc;
        Contract con = TestHelper.createContract(acc.Id,false);
        con.SAP_External_ID__c = acc.SAP_External_ID__c;
        insert con;
        
        SapWebserviceUtils.runSap(con.id);
        SapWebserviceUtils.runTest();
    }
}