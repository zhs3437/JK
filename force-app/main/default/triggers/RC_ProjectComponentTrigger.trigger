trigger RC_ProjectComponentTrigger on leanx__pm_ProjectMember__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    // neo
    new RC_ProjectComponentBasicHandler().run();
    new RC_ProjectComponentGrossMarginHandler().run();
}