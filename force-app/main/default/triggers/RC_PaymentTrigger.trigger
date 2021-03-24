trigger RC_PaymentTrigger on Payment__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    new RC_PaymentBasicHandler().run();
}