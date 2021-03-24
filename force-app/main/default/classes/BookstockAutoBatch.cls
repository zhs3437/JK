/*
 *  Create by Snake 
 *  批量处理发货信息。
 */

global with sharing class BookstockAutoBatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<Reserve_inventory_information__c> olst=new List<Reserve_inventory_information__c>();
global Database.QueryLocator start(database.BatchableContext bc )
    {
        String xx;
        String yy;
        String zz;
         String aa;
        String bb;
        String cc;
          String ee;
        String bffb;
        String gg;
         String hh;
        String ii;
        String jj;
        String k;
        String l;
        String m;
        String Query;
        Query =UtilClass.MakeSelectSql(Schema.SObjectType.Reserve_inventory_information__c);
        return Database.getQueryLocator(Query);
      }   
    global void execute (Database.BatchableContext bc, List<Reserve_inventory_information__c> ordLst)
    {  
            for(Reserve_inventory_information__c o :OrdLst){
                system.debug('A:'+o.ZWARNDATE__c);
                system.debug('B:'+timechange(o.now__c.YEAR()+'')+timechange(o.now__c.month()+'')+timechange(o.now__c.day()+''));
                if(o.ZWARNDATE__c==timechange(o.now__c.YEAR()+'')+timechange(o.now__c.month()+'')+timechange(o.now__c.day()+'')){SyncContract.SendEmailY(o); }     
                if(o.ZDUEDATE__c==timechange(o.now__c.YEAR()+'')+timechange(o.now__c.month()+'')+timechange(o.now__c.day()+'')){SyncContract.SendEmailF(o);}     
            }
           
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
    
    
     global String timechange(  String num  ){
        if(num=='1'){return '01';}else if(num=='2'){return '02';}else if(num=='3'){return '03';}else if(num=='4'){return '04';} else if(num=='5'){return '05';}else if(num=='6'){ return '06';}else if(num=='7'){ return '07'; }
        else if(num=='8'){return '08';}else if(num=='9'){return '09'; }else{return num;
        }
    }
}