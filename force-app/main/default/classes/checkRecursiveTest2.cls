@isTest
public class checkRecursiveTest2 {
    static testMethod void myUnitTest() {
         boolean run = true;
        checkRecursive.runOnce();
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        opp.OwnerId='00590000000Lgv1';

         opp.Region__c='EU(Union)';
        upsert opp;
        checkRecursive.EmailSend(1,opp);
         opp.Region__c='North America';
        upsert opp;
        checkRecursive.EmailSend(1,opp);
    }
}