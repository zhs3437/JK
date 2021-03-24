public without sharing class RC_OrderComponentBasicHandler extends TriggerHandler {
    
    public List<Agreement_Component__c> itemOlds;
    public List<Agreement_Component__c> itemNews;
    public Map<Id, Agreement_Component__c> itemOldMap;
    public Map<Id, Agreement_Component__c> itemNewMap;
    public RC_OrderComponentBasicHandler () {
        itemOlds = (List<Agreement_Component__c>) Trigger.old;
        itemNews = (List<Agreement_Component__c>) Trigger.new;
        itemOldMap = (Map<Id, Agreement_Component__c>) Trigger.oldMap;
        itemNewMap = (Map<Id, Agreement_Component__c>) Trigger.newMap;
    }

    public override void beforeInsert() {
        TriggerHandler.bypass('RC_OrderComponentBasicHandler');
        setRowNo();
    }

    // get all item from parent order
    // set new row no
    private void setRowNo () {
        Set<Id> orderIds = new Set<Id>();
        List<Agreement_Component__c> itemNeedUpdates = new List<Agreement_Component__c>();
        Map<Id, List<Agreement_Component__c>> orderIdItemsMap = new Map<Id, List<Agreement_Component__c>>();

        for (Agreement_Component__c itemNew : itemNews) {
            orderIds.add(itemNew.Agreement__c);
        }

        for (Agreement_Component__c item : [SELECT Id, 
                                                   RowNo__c,
                                                   Sales_Dept__c,
                                                   Agreement__c
                                            FROM Agreement_Component__c 
                                            WHERE Agreement__c IN :orderIds
                                            ORDER BY CreatedDate]) {
            if (orderIdItemsMap.containsKey(item.Agreement__c)) orderIdItemsMap.get(item.Agreement__c).add(item);
            else orderIdItemsMap.put(item.Agreement__c, new List<Agreement_Component__c>{item});
            if (itemNewMap == null || !itemNewMap.containsKey(item.Id)) itemNeedUpdates.add(item);
        }

        for (Agreement_Component__c itemNew : itemNews) {
            if (orderIdItemsMap.containsKey(itemNew.Agreement__c)) orderIdItemsMap.get(itemNew.Agreement__c).add(itemNew);
            else orderIdItemsMap.put(itemNew.Agreement__c, new List<Agreement_Component__c>{itemNew});
        }

        for (Id orderId : orderIdItemsMap.keySet()) {
            List<Agreement_Component__c> items = orderIdItemsMap.get(orderId);
            for (Integer i = 0; i < items.size(); i ++) {
                items[i].RowNo__c = String.valueOf(i + 1).leftPad(3, '0');
                if (items[i].Sales_Dept__c != 'Sales Oversea') items[i].ExterId__c = orderId + ';' + items[i].RowNo__c;
            }
        }

        // update itemNeedUpdates;
    }
}