global with sharing class productjob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<User> olst=new List<User>();
public List<Product2> p2=new List<Product2>();
    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
        String xx;
        String yy;
         String zz;
           String Query;
                Query =UtilClass.MakeSelectSql(Schema.SObjectType.user);
        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<User> ordLst)
    {  
        system.debug('kaishi');
                     
                            p2=CRMSendCpmd.clickUpdate();  
      
           
    }   
    global void finish(Database.BatchableContext bc)
    {
update p2;
    }
}