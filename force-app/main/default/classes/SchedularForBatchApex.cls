global with sharing class SchedularForBatchApex implements Schedulable {
    global void execute(SchedulableContext sc) {
        ID BatchId = Database.executeBatch(new RunBatchApex (), 200);
    } 
    Public static void SchedulerMethod() {
        string con_exp= '0 0 1 * * ?';
        System.schedule('RunBatchApexTest', con_exp, new SchedularForBatchApex());
    }
}