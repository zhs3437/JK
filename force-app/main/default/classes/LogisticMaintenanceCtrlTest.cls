/**********************************************************************
 * 
 *
 * Creator: Leo Wu 2018/7/9
 *  {
        
    }
*************************************************************************/
@isTest
private class LogisticMaintenanceCtrlTest {
   	static testMethod void myLogisticTest()
   	{
   		Profile profile=[Select Name,Id from Profile where Name='System Administrator'];

   		Logistic__c	log= new Logistic__c();
   		log.Departure_Factory__c='HaiNing Factory';
   		log.Departure_Port__c='ShangHai';
   		log.Box_Amount__c='728';
   		log.Type_of_Shipping__c='铁路';
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

   		LogisticMaintenanceCtrl lmc=new LogisticMaintenanceCtrl();
   		lmc.searchstart();
   		lmc.runTest();
   	}
}