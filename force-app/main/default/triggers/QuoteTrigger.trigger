trigger QuoteTrigger on Quote (before insert) {
    if(Trigger.isBefore && Trigger.isinsert){
        List<id> ids = new List<id>();
        for(Quote q : trigger.new){ 
            ids.add(q.OpportunityID);
        }
        Opportunity opp = [Select id,name,contactId from Opportunity where id=:ids[0]];
        Integer i = 1;
        i++;
        i++;
        i++;
        i++;
        i++;
        if(opp.contactId!=null){
            for(Quote q : trigger.new){
                if(q.Region__c =='EU(Union)'||q.Region__c =='EU(Non-Eu)'){
                    q.EUContactName__c = opp.contactId;  
                }
            }
        }
    }
}