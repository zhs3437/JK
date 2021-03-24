@isTest
public class DeliveryScheduleJobTester {
    static testMethod void deliveryBatch(){
        SchedulableContext sc = null;
        DeliveryScheduleJob dsj = new DeliveryScheduleJob();        
        dsj.execute(sc);
    }
}