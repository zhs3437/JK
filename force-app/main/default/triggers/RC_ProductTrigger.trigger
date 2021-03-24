trigger RC_ProductTrigger on leanx__hr_Resource__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // neo
    new RC_ProductBasicHandler().run();
}