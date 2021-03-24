/*
 * Set additional cost for the contract items
 * Date: 3/2021
 */
trigger SetOldAdditionalCost on Product_Detail__c (before update) {
    for(Product_Detail__c contractItem : trigger.new)
    {
        Product_Detail__c oldContractItem = trigger.oldMap.get(contractItem.Id);
        if(contractItem.Additional_Cost_Per_W__c != oldContractItem.Additional_Cost_Per_W__c)
        {
            contractItem.Additional_Cost_Per_W_Old__c = oldContractItem.Additional_Cost_Per_W__c;
        }
        if(contractItem.Total_Gross_Margin__c != oldContractItem.Total_Gross_Margin__c)
        {
            contractItem.Total_Gross_Margin_Old__c = oldContractItem.Total_Gross_Margin__c;
        }
    }
}