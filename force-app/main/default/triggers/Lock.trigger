trigger Lock on Order (after update, before update,before delete) {

    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;
   
    if (Trigger.isUpdate){
        for(Order ord_new : trigger.new){
            for(Order ord_old : trigger.old){
                if(ord_new.Lock__c == ord_old.Lock__c && ord_new.Lock__c && !Userinfo.getProfileId().contains('00e90000000sjac')){
                    ord_new.addError(Label.OrderLockException,false);
                }
            }
        }

        if(Trigger.isbefore){
            system.debug('订单更新接口');
            String oppid;
            for(Order ord : trigger.new){
                oppid=ord.Opportunity__c;
            }
            List<Opportunity> opp =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                          'Where id =: oppid');
            for(Order ord : trigger.new){
                if(opp.size()>0){
                    if(ord.Land_Freight_China__c==null){
                        ord.Land_Freight_China__c=opp[0].Land_Freight_China__c;
                        ord.Land_Freight_Oversea__c=opp[0].Land_Freight_Oversea__c;
                        ord.Local_Warehouse__c=opp[0].Local_Warehouse__c;
                        ord.Logistic_Special_Cost_Per_W__c=opp[0].Logistic_Special_Cost_Per_W__c;
                        ord.Number_of_Containers__c=opp[0].Number_of_Containers__c;
                        ord.Ocean_Freight_China__c=opp[0].Ocean_Freight__c;
                        ord.Ocean_Freight_Oversea__c=opp[0].Ocean_Freight_Oversea__c;
                        ord.Warehouse_Premium__c=opp[0].Warehouse_Premium__c;
                        
                    }
                }
            }
        }
        if(Trigger.isAfter){
        
            for(Order ord : trigger.new){
            
                if(!Test.isRunningTest()){
                    SyncContract.clickorder(ord.id);
                }
                
            }

            new OpportunityLineItemGrossMarginHandler(Trigger.newMap);
        }
    }
    if(Trigger.isDelete){
        for(Order ord : trigger.old){
            SyncContract.deleteorder(ord.id);
        }
    }
}