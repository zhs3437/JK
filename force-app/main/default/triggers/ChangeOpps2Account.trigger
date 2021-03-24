trigger ChangeOpps2Account on Task (before insert) {
	for(Task t : Trigger.new){
		// this is need grading  or need Input Credit task
		if(t.Subject == 'Need Grading' || t.Subject == 'Please Input Credit'){
			string RelatedToId = t.WhatId;
			// Related To object is opportunity objects
			Integer isOpp=[select count() from Opportunity where id=:t.WhatId];
			if(isOpp >0 ){
				Opportunity opp = [select AccountId 
														from Opportunity 
														where id =:RelatedToId limit 1];
				//set the account id substitute opportunity id
				t.WhatId = opp.AccountId;
			}
		}
	}
}