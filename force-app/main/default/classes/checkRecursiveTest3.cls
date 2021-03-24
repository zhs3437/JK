@isTest
public class checkRecursiveTest3 {
    static testMethod void myUnitTest() {
         boolean run = true;
        checkRecursive.runOnce();
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        opp.OwnerId='00590000000Lgv1';
         opp.Region__c='North Asia';
        upsert opp;
        checkRecursive.EmailSend(1,opp);
         opp.Region__c='ROA';
        opp.Destination_Country__c='Australia';
        upsert opp;
    }
}