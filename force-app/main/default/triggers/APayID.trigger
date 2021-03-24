trigger APayID on Amendment_Payment__c (before insert,before update) {
for(Amendment_Payment__c p:trigger.new){
    if(p.ID__c==null){
    p.ID__c=p.id;    
    }
    }
            if(trigger.isbefore){
    if(trigger.isupdate){
        String AmentId;
        for(Amendment_Payment__c ap_new : trigger.new){
        AmentId=ap_new.Amendment_Purchase_Agreement__c;
        }
            
            Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: AmentId');
         for(Amendment_Payment__c ap_new : trigger.new){
    for(Amendment_Payment__c ap_old : trigger.old){
        if((
        ap_new.Payment_Method__c!=ap_old.Payment_Method__c || ap_new.Percentage__c!=ap_old.Percentage__c ||
               ap_new.Payment_Term__c	!=ap_old.Payment_Term__c || ap_new.Down_Balance_Payment__c!=ap_old.Down_Balance_Payment__c ||
            ap_new.Days__c	!=ap_old.Days__c)&& Aord.Submission_Time__c!=null){
                Aord.Payment_Change__c=true;
            }
        
        }
             
             }
    update Aord;
            
            
            }
        
    }
}