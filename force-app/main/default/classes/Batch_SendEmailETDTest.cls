@isTest
private class Batch_SendEmailETDTest {
    static testMethod void testMethod1() {

       Batch_SendEmailETD bse=new Batch_SendEmailETD();
       bse.test();
       Schedule_SendEmailETD sse=new Schedule_SendEmailETD();
       sse.runtest();
    }
}