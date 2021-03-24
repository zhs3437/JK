@isTest
public class checkRecursiveTest {
    static testMethod void myUnitTest() {
         boolean run = true;
        checkRecursive.runOnce();
        checkRecursive.runOnce2();
        checkRecursive.runOnce3();
        checkRecursive.runOnce4();
        checkRecursive.runOnce5();
        checkRecursive.runOnce6();
        checkRecursive.runOnce7();
        checkRecursive.runOnce8();
        checkRecursive.runOnce9();
        checkRecursive.runOnce10();
         checkRecursive.runOnce11();
         checkRecursive.runOnce12();
         checkRecursive.runOnce13();
         checkRecursive.runOnce14();
         checkRecursive.runOnce15();
         checkRecursive.runOnce16();
         checkRecursive.runOnce17();
        checkRecursive.runOnce18();
         checkRecursive.runOnce19();
         checkRecursive.runOnce20();
         checkRecursive.runOnce21();
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        opp.OwnerId='00590000000Lgv1';

        checkRecursive.EmailSend(1,opp);
                opp.Region__c='ROA';
        opp.Destination_Country__c='Australia';
        upsert opp;
        checkRecursive.EmailSend(1,opp);
                opp.Region__c='Latin America&Italy';
        upsert opp;
        checkRecursive.EmailSend(1,opp);

        
    }
}