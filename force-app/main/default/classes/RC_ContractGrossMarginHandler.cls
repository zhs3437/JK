public without sharing class RC_ContractGrossMarginHandler extends TriggerHandler {

    public override void beforeInsert() {}
    
    public override void beforeUpdate() {
        for (String Id : Trigger.newMap.keySet()) {
            leanx__lg_Contract__c contractOld = (leanx__lg_Contract__c)Trigger.oldMap.get(Id);
            leanx__lg_Contract__c contractNew = (leanx__lg_Contract__c)Trigger.newMap.get(Id);
            if (contractOld.Destination_Region__c != contractNew.Destination_Region__c) RC_CostCenter.containerNeedChangeIds.add(Id);
            if (contractOld.Destination_Port__c != contractNew.Destination_Port__c ||
                contractOld.Trade_Term__c != contractNew.Trade_Term__c ||
                contractOld.Local_Warehouse__c != contractNew.Local_Warehouse__c) RC_CostCenter.oceanNeedChangeIds.add(Id);
            if (contractOld.Destination_Country__c != contractNew.Destination_Country__c ||
                contractOld.Trade_Term__c != contractNew.Trade_Term__c) RC_CostCenter.landNeedChangeIds.add(Id);
        }
    }
    
    public override void beforeDelete() {}
    
    public override void afterInsert() {
        new RC_CostCenter((Map<Id, leanx__lg_Contract__c>)Trigger.newMap);
    }
    
    public override void afterUpdate() {
        new RC_CostCenter((Map<Id, leanx__lg_Contract__c>)Trigger.newMap);
    }
    
    public override void afterDelete() {}
    
    public override void afterUndelete() {}
    
}