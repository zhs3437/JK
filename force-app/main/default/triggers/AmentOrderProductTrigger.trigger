trigger AmentOrderProductTrigger on Amendment_Order_Product__c (before update) {
    String AmentId;
    system.debug('产品触发器开始');
    if(Trigger.isBefore && Trigger.isupdate){
     for(Amendment_Order_Product__c aop_new : trigger.new){
         AmentId=aop_new.OriginalOrderItem__c;
         }
 system.debug('产品触发器循环开始');
    Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: AmentId');
 for(Amendment_Order_Product__c aop_new : trigger.new){
    for(Amendment_Order_Product__c aop_old : trigger.old){
     if((aop_old.Product_Name__c!=aop_new.Product_Name__c)&& Aord.Submission_Time__c!=null){
         Aord.Product_Change__c=true;
         }
         if((aop_old.Quantity__c!=aop_new.Quantity__c)&& Aord.Submission_Time__c!=null){
         Aord.Delivery_Date_Change__c=true;
         }
        if((aop_old.UnitPrice__c!=aop_new.UnitPrice__c)&& Aord.Submission_Time__c!=null){
         Aord.Delivery_Date_Change__c=true;
         }
         if((aop_old.Guaranteed_Delivery_Date__c!=aop_new.Guaranteed_Delivery_Date__c) && aop_new.Guaranteed_Delivery_Date__c<aop_old.Guaranteed_Delivery_Date__c && aop_old.Guaranteed_Delivery_Date__c.daysBetween(aop_new.Guaranteed_Delivery_Date__c)<0 && Aord.Submission_Time__c!=null){
         Aord.Delivery_Date_Change__c=true;
         
         }
  }
}
    update Aord;
    }
    }