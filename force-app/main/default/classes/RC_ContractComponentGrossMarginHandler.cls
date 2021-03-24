public without sharing class RC_ContractComponentGrossMarginHandler extends TriggerHandler {

    public RC_ContractComponentGrossMarginHandler() {
        // this.setMaxLoopCount(2);
    }

    public override void beforeInsert() {
        TriggerHandler.bypass('RC_ContractGrossMarginHandler');
        TriggerHandler.bypass('RC_ContractComponentGrossMarginHandler');
        new RC_CostCenter((List<Contract_Component__c>)Trigger.new);
    }
    
    public override void beforeUpdate() {
        for (String Id : Trigger.newMap.keySet()) {
            Contract_Component__c contractProductOld = (Contract_Component__c)Trigger.oldMap.get(Id);
            Contract_Component__c contractProductNew = (Contract_Component__c)Trigger.newMap.get(Id);
            if (contractProductOld.Quantity__c != contractProductNew.Quantity__c) RC_CostCenter.containerNeedChangeIds.add(contractProductNew.Contract__c);
        }
        TriggerHandler.bypass('RC_ContractGrossMarginHandler');
        TriggerHandler.bypass('RC_ContractComponentGrossMarginHandler');
        new RC_CostCenter((List<Contract_Component__c>)Trigger.new);
    }
}