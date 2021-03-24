/*
 *  Create by Jason 
 *  批量处理发货信息。
 */

global with sharing class DeliveryBatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<Order> olst=new List<Order>();

    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
           String Query;
                Query = 'Select Id,Total_Quantity__c,SAP_Order_ID__c,CreatedDate,ContractId,Opportunity__c,Contract_Owner__c,Opportunity__r.OwnerId,LastModifiedDate From Order Where SAP_Order_ID__c != null'; 

        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<Order> ordLst)
    {  
          
            Set<ID> fullIds = new Set<ID>();
            List<ID> deliveryIds = new List<ID>();
            for(Order o :OrdLst){
                fullIds.add(o.Id);                
            }
            system.debug('fullIds放入所有Order id');
            List<Delivery__c> lst_full_crm_Delivery = [Select Id,Order__c,Quantity__c From Delivery__c Where Order__c in : fullIds];
            
            system.debug('-------系统中已经同步到SAP的订单数量:  ' + OrdLst.size());
            system.debug('-------系统中已经同步到SAP的订单:  ' + OrdLst);
            system.debug('-------没有重复的已经同步到SAP的订单数量:  ' + fullIds.size());
            system.debug('-------没有重复的已经同步到SAP的订单Id:  ' + fullIds);
            system.debug('-------已经同步到SAP单子的所有发货单数量 : ' + lst_full_crm_Delivery.size());
            //List<Delivery__c> lst_full_crm_Delivery = Database.query(Utils.MakeSelectSql('Delivery__c'));
            Map<Order,List<Delivery__c>>  DeMap =new   Map<Order,List<Delivery__c>>(); 
            for(Order ord:OrdLst){
                List<Delivery__c> Delst =new List<Delivery__c>();
            for(Delivery__c De:lst_full_crm_Delivery){
                       if(De.Order__c==ord.id){
                           Delst.add(De);
                           }
                }
                if(Delst.size()>0){
                    DeMap.put(ord,Delst);
                }
                }
            
            Decimal Q = 0;
            
            for(order ord:OrdLst){
                List<Delivery__c> Dlst=new List<Delivery__c>();
                    Dlst=Demap.get(ord);
                SYSTEM.DEBUG(Dlst);
                if(Dlst!=null){
                    for(Delivery__c d : Dlst ){
                        Q += d.Quantity__c;

                    }
                }                
               
                if(Q >= ord.Total_Quantity__c){
                    fullIds.remove(ord.Id);
                    //sameIds.remove(ord.Id);
                    system.debug('----移除发完货的ID');
                    system.debug('----移除发完货的ID' + ord.Id);
                }				             
                }
List<Order> ordLst2=[Select Id,Total_Quantity__c,SAP_Order_ID__c,CreatedDate,ContractId,Opportunity__c,Contract_Owner__c,Opportunity__r.OwnerId  From Order Where id in:fullIds];
        if(ordLst2!=null && ordLst2.size()>0){
                system.debug('olst');
         DeliveryUtils delivery = new DeliveryUtils();
        delivery.sync(ordLst2);
        }
        system.debug('execute end');
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
}