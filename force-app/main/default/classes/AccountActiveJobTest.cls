@isTest
public class AccountActiveJobTest {
    static testMethod void deliveryBatch(){
        SchedulableContext sc = null;
        AccountActiveJob dsj = new AccountActiveJob();        
        dsj.execute(sc);
    }
}