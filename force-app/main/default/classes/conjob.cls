/*
 *  Create by Snake 
 *  批量处理发货信息。
 */

global with sharing class conjob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<Contract> olst=new List<Contract>();

    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
        String xx;
        String yy;
         String zz;
           String Query;
                Query =UtilClass.MakeSelectSql(Schema.SObjectType.Contract);
        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<Contract> ordLst)
    {  
            for(Contract o :OrdLst){
                        SAPBATCHCON.clickUpdate(o.Id);                
            }
           
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
}