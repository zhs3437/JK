@isTest
public class TestChangeOpps2AccountTrigger {
	private testMethod static void DoTest(){
		/*Account a = new Account(Name='TestChangeOpps2AccountTrigger');
		insert a;
		Opportunity opp = new Opportunity(Name='2MW-JKM200-20120304',Account=a,StageName='Price Quote',CloseDate=Date.today(),delivey_point__c='asd');
		insert opp;
		Task t1 = new Task();
		t1.OwnerId = UserInfo.getUserId();
		t1.Subject = 'Need Grading';
		t1.Status = 'Not Started';
		t1.WhatId = opp.id;
		t1.Priority = 'Normal';
		System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
		System.debug(opp.id);
		System.debug(t1.WhatId);
		insert t1;
		Task t = [select WhatId from Task where id =: t1.id limit 1];
		System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
		System.debug(opp.id);
		System.debug(t1.WhatId);
		//System.assertEquals(a.id, t.WhatId);
		Task t2 = new Task();
		t2.OwnerId = UserInfo.getUserId();
		t2.Subject = 'Please Input Credit';
		t2.Status = 'Not Started';
		t2.WhatId = opp.id;
		t2.Priority = 'Normal';
		insert t2;
		t = [select WhatId from Task where id =: t2.id limit 1];
		//System.assertEquals(a.id, t.WhatId);*/
	}
}