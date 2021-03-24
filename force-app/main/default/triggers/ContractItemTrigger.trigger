trigger ContractItemTrigger on Product_Detail__c (before insert, before update) {
    
    // neo
    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;
    
    // neo
    if (Trigger.isBefore) {
        // neo - calculate freight
        OpportunityLineItemGrossMarginHandler handler;
        if (Trigger.isInsert) {
            handler = new OpportunityLineItemGrossMarginHandler(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler = new OpportunityLineItemGrossMarginHandler(Trigger.new);
        }
    }
}