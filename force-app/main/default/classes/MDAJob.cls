/*
 *  Create by Snake 
 *  批量处理发货信息。
 */

global with sharing class MDAJob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<Component_Task_Book__c> olst=new List<Component_Task_Book__c>();

    
    global Database.QueryLocator start(database.BatchableContext bc )
    {String xxx;
        String yyy;
         String zzz;
     String xxxx;
        String yyyy;
         String zzzz;
     String x5;
        String y5;
         String z5;
     String x6;
        String y6;
         String z6;
        String xx;
        String yy;
         String zz;
        String ww;
           String Query;
        Query =UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c);
        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<Component_Task_Book__c> ordLst)
    {  
            for(Component_Task_Book__c o :OrdLst){
                MDASAPBeach.SendOrderNo(o.name);
                }

           
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
}