global class CompleteScheduleJob implements Schedulable {
    global void execute(SchedulableContext sc) {
         try{
             List<String> statuslst=new  List<String>();
            List<Distribution_Stock__c> DisStockLst = [Select Id,Account__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Distribution_Quantity__c,ETA__c,ETD__c,Need_Adjust_Quantity__c,Remaining_Quantity__c,Sales__c,Status__c  
                                  From Distribution_Stock__c 
                                  Where Status__c = 'Released' And SAP_Delivery_order_no__c !=null ] ;
              Set<ID> fullIds = new Set<ID>();
            List<ID> deliveryIds = new List<ID>();
            for(Distribution_Stock__c DS :DisStockLst){
                fullIds.add(DS.Id);                
            }
             CompleteInventoryBatch db = new CompleteInventoryBatch(fullIds);
             Database.executeBatch(db,20);
         }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
    }

}