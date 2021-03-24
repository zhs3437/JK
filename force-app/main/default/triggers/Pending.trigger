trigger Pending on OpportunityLineItem (after update) {
	/*
	List<ID> ids = new List<ID>();
	for(OpportunityLineItem line_new : trigger.new){
		ids.add(line_new.OpportunityId);
	}
	
	Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>([SELECT ID,Name,Price_Approval_Status__c,Sales_manager_approval__c FROM Opportunity WHERE ID in: ids]);
	List<Opportunity> updateOpp = new List<Opportunity>();
	
	for(OpportunityLineItem line_new : trigger.new){
		for(OpportunityLineItem line_old : trigger.old){
			if((line_new.UnitPrice != line_old.UnitPrice || line_new.Quantity != line_old.Quantity) && oppMap.get(line_new.OpportunityId) != null){
				Opportunity opp = oppMap.get(line_new.OpportunityId);
				opp.Price_Approval_Status__c = 'Pending';
				opp.Sales_manager_approval__c = 'Pending';
				updateOpp.add(opp);
			}
		}
	}
	
	if(updateOpp.size()>0){
		try{
			update updateOpp;
		}catch(Exception e){
			System.debug('------------------> '+String.valueOf(e));
		}
	}
	*/
}