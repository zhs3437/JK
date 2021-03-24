@isTest
public class SAPIDTriggerTest {
    static testMethod void SAPIDTriggerTest() {
        Order ord = TestHelper.createOrder(false);        
        ord.OA_External_ID__c = '1';
        insert ord;
        
        SAPID__c sapid= new SAPID__c();   
        sapid.Name=ord.OA_External_ID__c;
        sapid.sapde__c='weasda20703201625';
        sapid.SFID__c='20703201625';
        
        insert sapid;
    }
}