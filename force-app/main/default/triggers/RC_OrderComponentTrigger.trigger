trigger RC_OrderComponentTrigger on Agreement_Component__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    new RC_OrderComponentBasicHandler().run();
}