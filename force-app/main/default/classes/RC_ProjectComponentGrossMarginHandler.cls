public without sharing class RC_ProjectComponentGrossMarginHandler extends TriggerHandler {

    public RC_ProjectComponentGrossMarginHandler() {
        // this.setMaxLoopCount(2);
    }

    public override void beforeInsert() {
        TriggerHandler.bypass('RC_ProjectGrossMarginHandler');
        TriggerHandler.bypass('RC_ProjectComponentGrossMarginHandler');
        new RC_CostCenter((List<leanx__pm_ProjectMember__c>)Trigger.new);
    }
    
    public override void beforeUpdate() {
        for (String Id : Trigger.newMap.keySet()) {
            leanx__pm_ProjectMember__c projectProductOld = (leanx__pm_ProjectMember__c)Trigger.oldMap.get(Id);
            leanx__pm_ProjectMember__c projectProductNew = (leanx__pm_ProjectMember__c)Trigger.newMap.get(Id);
          if (projectProductOld.Quantity__c != projectProductNew.Quantity__c) RC_CostCenter.containerNeedChangeIds.add(projectProductNew.leanx__Project__c);
        }
        TriggerHandler.bypass('RC_ProjectGrossMarginHandler');
        TriggerHandler.bypass('RC_ProjectComponentGrossMarginHandler');
        new RC_CostCenter((List<leanx__pm_ProjectMember__c>)Trigger.new);
    }
}