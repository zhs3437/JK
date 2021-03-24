global class SAP_BAT_ScheduleJob implements Schedulable {
	
	global void execute(SchedulableContext sc) {
        try{
			// 定期执行主数据接口
			SapIntegrationUtils.syncSapProduct();
			
        }catch( Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
	} 

}