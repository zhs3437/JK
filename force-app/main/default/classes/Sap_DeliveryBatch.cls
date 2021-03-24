global class Sap_DeliveryBatch {
    webservice static String start(string str){
		DeliveryScheduleJob sdsj = new DeliveryScheduleJob();
		String sch = '0 0 * * * ?';   //每小时执行一次
		String jobID = system.schedule('DeliveryScheduleJob', sch, sdsj);
		return 'success';
	}
    webservice static String stop(string str){
		CronJobDetail cjdId = [Select c.Name, c.JobType, c.Id From CronJobDetail c where c.Name =: 'DeliveryScheduleJob'];
		CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime,CronJobDetailId  FROM CronTrigger where CronJobDetailId =: cjdId.Id]; 
		System.abortJob(ct.Id);
		return 'success';
	}

}