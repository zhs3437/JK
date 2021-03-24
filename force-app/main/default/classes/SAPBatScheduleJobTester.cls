@isTest
public class SAPBatScheduleJobTester {
	 static testMethod void inventoryBookReminder(){
        SchedulableContext sc = null;
        SAP_BAT_ScheduleJob ibres = new SAP_BAT_ScheduleJob();
        ibres.execute(sc);
    }
}