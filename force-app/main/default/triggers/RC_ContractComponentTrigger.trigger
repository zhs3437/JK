trigger RC_ContractComponentTrigger on Contract_Component__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // neo
    new RC_ContractComponentGrossMarginHandler().run();
}