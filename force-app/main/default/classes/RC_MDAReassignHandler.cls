public without sharing class RC_MDAReassignHandler extends TriggerHandler {
    public List<Component_Task_Book__c> mdaOlds;
    public List<Component_Task_Book__c> mdaNews;
    public List<Component_Task_Book__c> mdas;
    public Map<Id, Component_Task_Book__c> mdaOldMap;
    public Map<Id, Component_Task_Book__c> mdaNewMap;
    public RC_MDAReassignHandler () {
        mdaOlds = new List<Component_Task_Book__c>((List<Component_Task_Book__c>) Trigger.old);
        mdaNews = new List<Component_Task_Book__c>((List<Component_Task_Book__c>) Trigger.new);
        mdaOldMap = new Map<Id, Component_Task_Book__c>();
        if (Trigger.oldMap != null) mdaOldMap.putAll((Map<Id, Component_Task_Book__c>) Trigger.oldMap);
        mdaNewMap = new Map<Id, Component_Task_Book__c>();
        if (Trigger.newMap != null) mdaNewMap.putAll((Map<Id, Component_Task_Book__c>) Trigger.newMap);
    }
    
    public override void afterInsert() {
        skipTrigger();
        family();
        assignItem();
    }
    
    public override void afterUpdate() {
        skipTrigger();
        family();
        assignItem();
    }
    
    public override void afterDelete() {
        skipTrigger();
        family();
        assignItem();
    }
    
    private void family() {
        List<String> parentIds = new List<String>();
        String clause = null;
        for (Component_Task_Book__c mda : mdaOlds) {
            for (String parentFieldName : parentFieldItemsMap.keySet()) {
                String parentId = (String) mda.get(parentFieldName);
                if (parentId != null) parentIds.add(parentId);
                if (clause == null) clause = parentFieldName + ' IN :parentIds';
                else clause += ' OR ' + parentFieldName + ' IN :parentIds';
            }
        }
        for (Component_Task_Book__c mda : mdaNews) {
            for (String parentFieldName : parentFieldItemsMap.keySet()) {
                String parentId = (String) mda.get(parentFieldName);
                if (parentId != null) parentIds.add(parentId);
                if (clause == null) clause = parentFieldName + ' IN :parentIds';
                else clause += ' OR ' + parentFieldName + ' IN :parentIds';
            }
        }
        mdas = (List<Component_Task_Book__c>) Database.query(
            QW_Utils.getQueryBySObjectType('Component_Task_Book__c') + 
            ' WHERE ' + '(' + clause + ')' + 
            ' ORDER BY CreatedDate DESC');
    }

    // key : parent Name, value : product 1 name, product 2 name, product 3 name
    static Map<String, List<String>> parentFieldItemsMap = new Map<String, List<String>>{
        'iProject__c' => new List<String>{'iProject__c', 'iModule_Type1__c', 'iModule_Type2__c', 'iModule_Type3__c'},
        'iContract__c' => new List<String>{'iContract__c', 'iModule_Type1__c', 'iModule_Type2__c', 'iModule_Type3__c'},
        'iOrder__c' => new List<String>{'iOrder__c', 'iModule_Type1__c', 'iModule_Type2__c', 'iModule_Type3__c'},
        'iAmendment_Agreement__c' => new List<String>{'iAmendment_Agreement__c', 'iModule_Type1__c', 'iModule_Type2__c', 'iModule_Type3__c'},
        // 'Opportunity__c' => new List<String>{'Opportunity__c', 'ModuleType1__c', 'Module_Type2__c', 'Module_Type3__c'},
        // 'Contract__c' => new List<String>{'Contract__c', 'ModuleType1__c', 'Module_Type2__c', 'Module_Type3__c'},
        'Order__c' => new List<String>{'Order__c', 'ModuleType1__c', 'Module_Type2__c', 'Module_Type3__c'}
        // 'Amendment_Purchase_Agreement__c' => new List<String>{'Amendment_Purchase_Agreement__c', 'ModuleType1__c', 'Module_Type2__c', 'Module_Type3__c'}
    };

    // key : itemObject Name, value : itemObject Name, parent field Name, item key field Name, mda field Name
    static Map<String, List<String>> itemParentFieldNameMap = new Map<String, List<String>>{
        'leanx__pm_ProjectMember__c' => new List<String>{'leanx__pm_ProjectMember__c', 'leanx__Project__c', 'Product__c', 'MDA__c'},
        'Contract_Component__c' => new List<String>{'Contract_Component__c', 'Contract__c', 'Product__c', 'MDA__c'},
        'Agreement_Component__c' => new List<String>{'Agreement_Component__c', 'Agreement__c', 'Product__c', 'MDA__c'},
        'Amendment_Agreement_Product__c' => new List<String>{'Amendment_Agreement_Product__c', 'Amendment_Agreement__c', 'Product__c', 'MDA__c'},
        // 'OpportunityLineItem' => new List<String>{'OpportunityLineItem', 'OpportunityId', 'Product2Id', 'MDA__c'},
        // 'Product_Detail__c' => new List<String>{'Product_Detail__c', 'Contract_PO_PI__c', 'Product__c', 'MDA__c'},
        'OrderItem' => new List<String>{'OrderItem', 'OrderId', 'Product2Id', 'MDA__c'}
        // 'Amendment_Order_Product__c' => new List<String>{'Amendment_Order_Product__c', 'OriginalOrderItem__c', 'Product2__c', 'MDA__c'}
    };

    private void assignItem() {
        List<String> parentIds = new List<String>();
        Map<String, Map<String, Component_Task_Book__c>> parentItemMDAMaps = new Map<String, Map<String, Component_Task_Book__c>>();
        for (Component_Task_Book__c mda : mdas) {
            for (String parentFieldName : parentFieldItemsMap.keySet()) {
                String parentId = (String) mda.get(parentFieldName);
                if (parentId != null) parentIds.add(parentId);
                else continue;
                Map<String, Component_Task_Book__c> itemMDAMaps = parentItemMDAMaps.containsKey(parentId) ?
                    parentItemMDAMaps.get(parentId) : new Map<String, Component_Task_Book__c>();
                if ((String) mda.get(parentFieldItemsMap.get(parentFieldName)[1]) != null) itemMDAMaps.put((String) mda.get(parentFieldItemsMap.get(parentFieldName)[1]), (Component_Task_Book__c) mda);
                if ((String) mda.get(parentFieldItemsMap.get(parentFieldName)[2]) != null) itemMDAMaps.put((String) mda.get(parentFieldItemsMap.get(parentFieldName)[2]), (Component_Task_Book__c) mda);
                if ((String) mda.get(parentFieldItemsMap.get(parentFieldName)[3]) != null) itemMDAMaps.put((String) mda.get(parentFieldItemsMap.get(parentFieldName)[3]), (Component_Task_Book__c) mda);
                if (parentId != null) parentItemMDAMaps.put(parentId, itemMDAMaps);
            }
        }

        List<SObject> items = new List<SObject>();
        for (Integer i = 0; i < itemParentFieldNameMap.values().size(); i ++) {
            items.addAll(Database.query(
                QW_Utils.getQueryBySObjectType(itemParentFieldNameMap.values()[i][0]) + 
                ' WHERE ' + itemParentFieldNameMap.values()[i][1] + ' IN :parentIds'));
        }

        for (SObject item : items){
            String itemObjectName = item.getSObjectType().getDescribe().getName();
            String parentId = (String) item.get(itemParentFieldNameMap.get(itemObjectName)[1]);
            String itemKey = (String) item.get(itemParentFieldNameMap.get(itemObjectName)[2]);
            String mdaFieldName = itemParentFieldNameMap.get(itemObjectName)[3];
            if (parentItemMDAMaps.get(parentId).containsKey(itemKey)) item.put(mdaFieldName, parentItemMDAMaps.get(parentId).get(itemKey).Id);
            else item.put(mdaFieldName, null);
            System.debug('item-->'+item);
        }
        
        update items;
    }



    private void skipTrigger() {
        TriggerHandler.bypass('RC_MDAReassignHandler');
        TriggerHandler.bypass('RC_MDABasicHandler');
        TriggerHandler.bypass('RC_ProjectBasicHandler');
        // TriggerHandler.bypass('RC_ProjectComponentBasicHandler');
        TriggerHandler.bypass('RC_ContractBasicHandler');
        TriggerHandler.bypass('RC_ContractComponentBasicHandler');
        TriggerHandler.bypass('RC_ContractComponentGrossMarginHandler');
        TriggerHandler.bypass('RC_OrderComponentBasicHandler');
        TriggerHandler.bypass('RC_AmendmentComponentBasicHandler');
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
    }
}