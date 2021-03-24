@isTest
public class ExecuteNDATester {
    private static testMethod void execute(){
        Account acc = TestHelper.createAccount();
        Requested_NDA__c rn = new Requested_NDA__c();
        rn.Account_Name__c = acc.Id;
        insert rn;
        ExecuteNDA.clickNewButton(acc.Id);
    }
 
}