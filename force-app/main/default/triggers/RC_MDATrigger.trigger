trigger RC_MDATrigger on Component_Task_Book__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // neo
    new RC_MDABasicHandler().run();
    new RC_MDAReassignHandler().run();
}