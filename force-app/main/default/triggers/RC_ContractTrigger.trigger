trigger RC_ContractTrigger on leanx__lg_Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    new RC_ContractBasicHandler().run();
    new RC_ContractGrossMarginHandler().run();
}