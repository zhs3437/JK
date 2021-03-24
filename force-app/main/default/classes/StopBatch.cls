global class StopBatch {
	webservice static String stop(string str){
		CronJobDetail cjdId = [Select c.Name, c.JobType, c.Id From CronJobDetail c where c.Name =: 'SAP_BATCH'];
		CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime,CronJobDetailId  FROM CronTrigger where CronJobDetailId =: cjdId.Id]; 
		System.abortJob(ct.Id);
		return 'success';
	}
}