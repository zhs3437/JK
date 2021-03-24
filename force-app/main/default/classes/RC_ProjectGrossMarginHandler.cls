public without sharing class RC_ProjectGrossMarginHandler extends TriggerHandler {

    public override void beforeInsert() {}
    
    public override void beforeUpdate() {
        for (String Id : Trigger.newMap.keySet()) {
            leanx__pm_Project__c projectOld = (leanx__pm_Project__c)Trigger.oldMap.get(Id);
            leanx__pm_Project__c projectNew = (leanx__pm_Project__c)Trigger.newMap.get(Id);
            if (projectOld.Destination_Region__c != projectNew.Destination_Region__c) RC_CostCenter.containerNeedChangeIds.add(Id);
            if (projectOld.Destination_Port__c != projectNew.Destination_Port__c ||
                projectOld.Trade_Term__c != projectNew.Trade_Term__c ||
                projectOld.Local_Warehouse__c != projectNew.Local_Warehouse__c) RC_CostCenter.oceanNeedChangeIds.add(Id);
            if (projectOld.Destination_Country__c != projectNew.Destination_Country__c ||
                projectOld.Trade_Term__c != projectNew.Trade_Term__c) RC_CostCenter.landNeedChangeIds.add(Id);
        }
    }
    
    public override void beforeDelete() {}
    
    public override void afterInsert() {
        new RC_CostCenter((Map<Id, leanx__pm_Project__c>)Trigger.newMap);
    }
    
    public override void afterUpdate() {
        new RC_CostCenter((Map<Id, leanx__pm_Project__c>)Trigger.newMap);
    }
    
    public override void afterDelete() {}
    
    public override void afterUndelete() {}
    
}