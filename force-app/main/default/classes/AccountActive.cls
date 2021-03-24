/*
 *  Create by Snake
 *  批量处理发货信息。
 */

global with sharing class AccountActive implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<Account> olst=new List<Account>();

    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
           String Query;
                Query = 'Select Id,createdyear__c From Account '; 

        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<Account> ordLst)
    {  
          
            Set<ID> fullIds = new Set<ID>();
            List<ID> deliveryIds = new List<ID>();
            for(Account o :OrdLst){
                fullIds.add(o.Id);                
            }
            system.debug('fullIds放入所有Account id');
            List<order> lst_full_crm_order = [Select Id,createddate,Buyer__c,Total_MW__c From order Where Buyer__c in : fullIds];
            Map<Account,List<order>>  DeMap =new   Map<Account,List<order>>(); 
            for(Account ord :ordLst){
                List<order> Delst =new List<order>();
            for(order De:lst_full_crm_order){
                       if(De.Buyer__c==ord.id){
                           Delst.add(De);
                           }
                }
                if(ord.createdyear__c<365){
                    ord.stage__c='新增';
                    if(delst.size()==0){
                        ord.Roll_up_total_MW__c=0;
                     }
                    decimal MW=0;
                     if(delst.size()>0){
                         for(order o:delst){
                         MW=MW+  o.Total_MW__c;  
                         }
                         }
                    ord.Roll_up_total_MW__c=MW;
                }
              
                if(ord.createdyear__c>=365){
                    if(delst.size()==0){
                       ord.stage__c='丢失';
                        ord.Roll_up_total_MW__c=0;
                     }
                    if(delst.size()>0){
                        datetime lasttiem ;
                            decimal MW=0;
                         for(order o:delst){
                             if(lasttiem==null){
                                 lasttiem=o.createddate;
                             }
                             else if(o.createddate>lasttiem){
                                   lasttiem=o.createddate;
                             }
                               MW=MW+  o.Total_MW__c;  
                         }
                      ord.Roll_up_total_MW__c=MW;
                        integer chazhi=lasttiem.date().daysBetween(date.today());
                        system.debug('jiuzaizheli:'+chazhi);
                        if(ord.createdyear__c>0 && ord.createdyear__c<3*365){
                            if(chazhi<365){
                                
                                ord.stage__c='成长';
                                  
                            }
                             if(chazhi>=365 && chazhi<=2*365){
                                ord.stage__c='游离';
                            }
                            if(chazhi>2*365){
                                ord.stage__c='丢失';
                            }
                        }
                        if(ord.createdyear__c>2*365){
                            if(chazhi<365){
                                ord.stage__c='成熟';
                            }
                             if(chazhi>=365 && chazhi<=2*365){
                                ord.stage__c='游离';
                            }
                            if(chazhi>2*365){
                                ord.stage__c='丢失';
                            }
                            
                        }
                      }
                }
                }
update ordLst;
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
}