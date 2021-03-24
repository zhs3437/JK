trigger RC_AmendmentComponentTrigger on Amendment_Agreement_Product__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    // neo
    new RC_AmendmentComponentBasicHandler().run();
}