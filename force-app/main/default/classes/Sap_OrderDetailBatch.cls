global class Sap_OrderDetailBatch {
 webservice static String start(string str){
		OrderDetailJob2 sdsj = new OrderDetailJob2();
		String sch = '0 30 * * * ?';   //每小时执行一次
		String jobID = system.schedule('OrderDetailScheduleJob', sch, sdsj);
		return 'success';
	}
    webservice static String stop(string str){
		CronJobDetail cjdId = [Select c.Name, c.JobType, c.Id From CronJobDetail c where c.Name =: 'OrderDetailScheduleJob'];
		CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime,CronJobDetailId  FROM CronTrigger where CronJobDetailId =: cjdId.Id]; 
		System.abortJob(ct.Id);
		return 'success';
	}

}