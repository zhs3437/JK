trigger RC_ProjectTrigger on leanx__pm_Project__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // neo
    new RC_ProjectBasicHandler().run();
    new RC_ProjectGrossMarginHandler().run();
}