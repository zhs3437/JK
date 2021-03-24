/*
 * Create By Jason
 */
global class DeliveryScheduleJob implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
  /*           
            List<Order> OrdLst = [Select Id,Total_Quantity__c,SAP_Order_ID__c,CreatedDate,ContractId,Opportunity__c,Contract_Owner__c,Opportunity__r.OwnerId,LastModifiedDate  
                                  From Order 
                                  Where SAP_Order_ID__c != null ] ;
            system.debug('得到了所有已经同步过得Order数据');
            
            Set<ID> fullIds = new Set<ID>();
            List<ID> deliveryIds = new List<ID>();
            for(Order o :OrdLst){
                fullIds.add(o.Id);                
            }
            system.debug('fullIds放入所有Order id');
            List<Delivery__c> lst_full_crm_Delivery = [Select Id,Order__c From Delivery__c Where Order__c in : fullIds];
            
            system.debug('-------系统中已经同步到SAP的订单数量:  ' + OrdLst.size());
            system.debug('-------系统中已经同步到SAP的订单:  ' + OrdLst);
            system.debug('-------没有重复的已经同步到SAP的订单数量:  ' + fullIds.size());
            system.debug('-------没有重复的已经同步到SAP的订单Id:  ' + fullIds);
            system.debug('-------已经同步到SAP单子的所有发货单数量 : ' + lst_full_crm_Delivery.size());
            system.debug('-------已经同步到SAP单子的所有发货单:  ' + lst_full_crm_Delivery);
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
                List<Delivery__c> Dlst=Demap.get(ord);
                if(Dlst.size()>0){
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
            /*
            List<ID> Ids = new List<ID>();
            for(Delivery__c d : lst_full_crm_Delivery){
                Ids.add(d.Order__c);                
            }
             system.debug('Ids放入所有同步过Order下的Delivery ');
            Set<ID> sameIds = new Set<ID>();
            
            for(ID id : Ids){
				sameIds.add(id);            
            }
            system.debug('-------已经同步到SAP单子的所有发货单订单ID数量:  ' + sameIds.size());
            system.debug('-------已经同步到SAP单子的所有发货单订单ID:  ' + sameIds);
            
            List<Order> sameOrdLst = [Select id,Total_Quantity__c From Order Where id in: sameIds];
            system.debug('sameOrdLst是Delivery对应的Order');
            
            for(Order ord :sameOrdLst ){                
                Decimal Q = 0;
                List<Delivery__c> sameDeliveryLst = [Select id,Order__c,Quantity__c From Delivery__c Where Order__c =: ord.Id ];
                
                system.debug('----一个订单下面有多个发货信息： ' + sameDeliveryLst.size() );
                system.debug('----一个订单下面有多个发货信息： ' + sameDeliveryLst );
                
                if(sameDeliveryLst.size()>0){
                    for(Delivery__c d : sameDeliveryLst ){
                        Q += d.Quantity__c;
                        system.debug('----------------------DOrdId: '+ord.Id);
                        system.debug('----------------------OrderQ: '+ord.Total_Quantity__c);
                        system.debug('----------------------DQ: '+Q);
                    }
                }                
                system.debug('------OrdId: '+ord.Id);
                system.debug('------Q: '+ Q);
                system.debug('------ord: '+ ord.Total_Quantity__c);
                if(Q >= ord.Total_Quantity__c){
                    fullIds.remove(ord.Id);
                    //sameIds.remove(ord.Id);
                    system.debug('----移除发完货的ID');
                    system.debug('----移除发完货的ID' + ord.Id);
                }				                	
            }
          
            system.debug('----还未发完货的订单Id： ' +sameIds );
 */
            DeliveryBatch db = new DeliveryBatch();
            Database.executeBatch(db,integer.valueof(label.year2));

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 

}