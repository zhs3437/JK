global without sharing class turnWareHouseScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        
        try{
            List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c'));
            SapSync_ChangeWareHouse WareHouseChange_tool = new  SapSync_ChangeWareHouse();
            system.debug('start CompleteStatus_tool');
            WareHouseChange_tool.sync(syncDisStockLst);
            system.debug('-------->fanhuichenggong:');
            SapTools.uploadList();
        }catch(Exception e){
            system.debug('Message=======：'+e.getLineNumber());
            system.debug('Message=======：'+e.getMessage());
        }
        
    }

}