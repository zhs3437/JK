global class SAP_BATCH {
	
	//private String str = 'SAP_BATCH';
	webservice static String start(string str){
		SAP_BAT_ScheduleJob absj = new SAP_BAT_ScheduleJob();
		String sch = '0 0 * * * ?';   //每小时执行一次
		String jobID = system.schedule('SAP_BATCH', sch, absj);
		return 'success';
	}
	
}