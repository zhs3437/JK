trigger LockOrderItem on OrderItem (after delete, after update, before delete, before update) {
	
    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;
	
	Set<id> orderIds = new Set<id>();
	for(OrderItem item : trigger.old){
		orderIds.add(item.OrderId);
	}
	
	map<id,Order> ordMap = new map<id,Order>([SELECT ID,Name,Lock__c FROM Order WHERE Id in: orderIds]);
	
	if(Trigger.isUpdate){ 
		for(OrderItem item : trigger.new){
			Order ord = ordMap.get(item.OrderId);
			if(ord.Lock__c  &&  !userinfo.getProfileId().contains('00e90000000sjac')){
				item.addError(Label.OrderLockException);
			}
		}
	}else if(Trigger.isDelete){
		for(OrderItem item : trigger.old){
			Order ord = ordMap.get(item.OrderId);
			if(ord.Lock__c  &&  !userinfo.getProfileId().contains('00e90000000sjac')){
				item.addError(Label.OrderLockException);
			}
		}
	}

}