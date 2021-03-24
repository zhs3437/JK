trigger SubmitPendingTrigger on Amendment__c (after insert,after update) {
    if(Trigger.isAfter){
        
    if(Trigger.isUpdate){
        String AmendmentId='';
        List<SubmitForReview__c> sfrList = new List<SubmitForReview__c>();
        for(Amendment__c ad_new : trigger.new){
                if(ad_new.Payment_Change__c == true || ad_new.Delivery_Date_Change__c == true || ad_new.Product_Change__c == true || ad_new.Header_Change__c == true){
                      AmendmentId = ad_new.Id; 
            }
        }
        if(AmendmentId !=null && AmendmentId !=''){
         sfrList =[Select Id,Status__c,Amendment__c from SubmitForReview__c where Amendment__c =: AmendmentId]; 
        }
        if(sfrList != null && sfrList.size()>0){
           for(SubmitForReview__c sfr : sfrList){
               sfr.Status__c = 'Pending';
        } 
        }
        update sfrList;
        }
    }
}