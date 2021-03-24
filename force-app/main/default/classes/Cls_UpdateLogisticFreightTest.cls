/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@isTest
private class Cls_UpdateLogisticFreightTest {

	static testMethod void myLogisticTest()
   	{

   		Logistic__c	log= new Logistic__c();
   		log.Departure_Factory__c='HaiNing Factory';
   		log.Departure_Port__c='宁波';
   		log.Box_Amount__c='624';
   		log.Type_of_Shipping__c='公路';
   		log.Box_Size__c='40';
   		log.Freight_Price_Trans__c=300;
   		log.Freight_Price_All__c=200;
   		insert log;

   		Ocean_Freight__c ocean =new Ocean_Freight__c();
   		ocean.Destination_Country__c='Japan';
   		ocean.Destination_Port__c='Toronto';
   		ocean.Freight_Price_Ocean__c=400;
   		ocean.Logistic__c=log.Id;
   		insert ocean;


    	Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
	

        opp.Seller__c='ZHEJIANG JINKO SOLAR CO.,LTD';
        update opp;
        opp.Power__c=325;
        update opp;
        opp.Type_of_Shipping__c='公路';
        update opp;

        Cls_UpdateLogisticFreight ulf =new Cls_UpdateLogisticFreight();
        ulf.runTest();
    }
}