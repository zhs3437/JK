global class CheckGradingClass implements Schedulable{
    global void execute(SchedulableContext SC){
    	Account[] accs = [Select Id, Name, Grading_Date__c, User__c, Grading_Expiring_Date__c From Account Where Grading_Expiring_Date__c < TODAY];
        CommonUtils.sendMailForGradingAccount(accs); 
    }
    
    static testMethod void onTest(){
		Test.startTest();
		Datetime dt = System.now().addSeconds(1);
		String expression = '20 30 8 10 2 ?';
		String jobId = System.schedule(
			 					'CheckGradingClass', expression,  
			 					 new CheckGradingClass()
					 	);
		system.assert(jobId!=null);
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,  NextFireTime
         						FROM CronTrigger WHERE id = :jobId];
        system.debug(  ct.CronExpression );
		Test.stopTest();
		
		System.assertEquals(expression, ct.CronExpression);
      	//System.assertEquals(0, ct.TimesTriggered);
	}
}