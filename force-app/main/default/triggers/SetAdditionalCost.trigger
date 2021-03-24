/*
 * Set additional cost for the contract items
 * Date: 3/2021
 */
trigger SetAdditionalCost on Contract (After update) {
    Set<Id> updateContractIds = new Set<Id>();
    for(Contract thisContract : trigger.new){
        Contract oldContract = trigger.oldMap.get(thisContract.Id);
        if(thisContract.Additional_Cost_PMC__c != oldContract.Additional_Cost_PMC__c){
            updateContractIds.add(thisContract.Id);
        }
    }
    if(updateContractIds.size() > 0)
    {
        OpportunityLineItemGrossMarginHandler handler = new OpportunityLineItemGrossMarginHandler();
        List<Product_Detail__c> contractItems = [select Id, Contract_PO_PI__c,
                   Payment_Cost_Per_W__c,
                   Insurence_Cost_Per_W__c,
                   Freight_Cost_Per_W__c,
                   Technology_Cost_Per_W__c,
                   Product_Cost__c,
                   Commision_Rebate_Cost_Per_W__c,
                   Estimated_Gross_Margin__c,
                   Confirmed_Gross_Margin__c,
                   Total_Gross_Margin__c,
                   Unit_Price__c,
                   CurrencyIsoCode,
                   Unit_WM__c,
                   Quantity__c,
                   Free_Power_W__c,
                   Third_Party_Test_Cost__c,
                   Transfer_Stock_Rate__c,
                   Special_Material_Cost_Per_W__c,
                   Total_W__c,
                   Additional_Cost_Per_W__c, Gross_Margin_Rate_Old__c, Total_Gross_Margin_Old__c, Contract_PO_PI__r.Total_MW__c, Contract_PO_PI__r.Total_W__c, Contract_PO_PI__r.Id, Contract_PO_PI__r.Additional_Cost_PMC__c from Product_Detail__c where Contract_PO_PI__c in :updateContractIds];
        for(Product_Detail__c contractItem : contractItems)
        {
            if(contractItem.Contract_PO_PI__r.Additional_Cost_PMC__c != null && contractItem.Contract_PO_PI__r.Total_MW__c != null && contractItem.Contract_PO_PI__r.Total_MW__c != 0)
            {
                Double rate = handler.getCodeRateMap().containsKey(contractItem.CurrencyIsoCode) ? handler.getCodeRateMap().get(contractItem.CurrencyIsoCode) : 1;
                contractItem.Additional_Cost_Per_W__c = (contractItem.Contract_PO_PI__r.Additional_Cost_PMC__c/(contractItem.Contract_PO_PI__r.Total_W__c))*rate;
                Decimal technologyCost = handler.getTechnologyCostByContractItem(contractItem.Contract_PO_PI__r, contractItem);
                contractItem.Confirmed_Gross_Margin__c = (contractItem.Estimated_Gross_Margin__c != null ? contractItem.Estimated_Gross_Margin__c : 0) - technologyCost - contractItem.Additional_Cost_Per_W__c;
                contractItem.Total_Gross_Margin__c = contractItem.Confirmed_Gross_Margin__c * contractItem.Total_W__c;
            }
            else
            {
                contractItem.Additional_Cost_Per_W__c = 0;
            }
            system.debug('@@' + contractItem.Total_Gross_Margin_Old__c);
            system.debug('@@' + contractItem.Total_Gross_Margin__c);
        }
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        update contractItems;
    }
}