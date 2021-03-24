/*
 *  Create by Han
 *  批量处理发货的库存信息。
 */
global with sharing class CompleteInventoryBatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
 global final String Query;
    global final set<ID> idss;
      global CompleteInventoryBatch(set<Id> ids){  
        idss = ids;
        system.debug('----ids' + ids);
        Query = 'Select Id,Account__c,Apply_Inventory__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Distribution_Quantity__c,ETA__c,ETD__c,Payment_Term__c,Product__c,InputNumber__c,SAP_Materiel_No__c,SAP_Message__c,SAP_TYPE__c,'+
                      'SAP_TYPES__c,SAP_BLNO__c,SAP_LGORT__c,SAP_WERKS__c,Status__c,Total_MW__c From Distribution_Stock__c Where id in:idss'; 
        system.debug('-----Query' + Query);
    }
      global Database.QueryLocator start(database.BatchableContext bc )
    {
        system.debug('----ids' + idss);
        system.debug('-----Query' + Query);
        return Database.getQueryLocator(Query);
    }   
    global void execute (Database.BatchableContext bc, List<Distribution_Stock__c> disLst)
    {       
        SapSync_CompleteStatus deliveryComplete = new SapSync_CompleteStatus();
        deliveryComplete.sync(disLst);
        system.debug('execute end');
    }   
    global void finish(Database.BatchableContext bc)
    {
        system.debug('finished');
    }

}