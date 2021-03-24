/*
 *  Create by Snake 
 *  批量处理发货信息。
 */

global with sharing class ordjob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<order> olst=new List<order>();

    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
        String xx;
        String yy;
         String zz;
           String Query;
                Query =UtilClass.MakeSelectSql(Schema.SObjectType.order);
        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<order> ordLst)
    {  
            for(order o :OrdLst){
                        Sapbatchorder.clickorder(o.Id);                
            }
           
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
}