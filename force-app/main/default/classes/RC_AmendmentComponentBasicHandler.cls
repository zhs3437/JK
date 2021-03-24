public without sharing class RC_AmendmentComponentBasicHandler extends TriggerHandler {
    public List<Amendment_Agreement_Product__c> itemOlds;
    public List<Amendment_Agreement_Product__c> itemNews;
    public List<Amendment_Agreement_Product__c> items;
    public Map<Id, Amendment_Agreement_Product__c> itemOldMap;
    public Map<Id, Amendment_Agreement_Product__c> itemNewMap;
    public Map<Id, leanx__hr_Resource__c> productMap;
    public Map<Id, Amendment_Agreement__c> amendmentMap;
    public RC_AmendmentComponentBasicHandler () {
        itemOlds = new List<Amendment_Agreement_Product__c>((List<Amendment_Agreement_Product__c>) Trigger.old);
        itemNews = new List<Amendment_Agreement_Product__c>((List<Amendment_Agreement_Product__c>) Trigger.new);
        itemOldMap = new Map<Id, Amendment_Agreement_Product__c>();
        if (Trigger.oldMap != null) itemOldMap.putAll((Map<Id, Amendment_Agreement_Product__c>) Trigger.oldMap);
        itemNewMap = new Map<Id, Amendment_Agreement_Product__c>();
        if (Trigger.newMap != null) itemNewMap.putAll((Map<Id, Amendment_Agreement_Product__c>) Trigger.newMap);
    }

    public override void beforeInsert() {
        this.family();
        this.calculate();
    }
    
    public override void beforeUpdate() {
        this.family();
        this.calculate();
    }
    
    public override void beforeDelete() {}
    
    public override void afterInsert() {
        this.family();
        this.updateProject();
    }
    
    public override void afterUpdate() {
        this.family();
        this.updateProject();
    }
    
    public override void afterDelete() {
        this.family();
        this.updateProject();
    }
    
    public override void afterUndelete() {}

    private void family() {
        Set<Id> productIds = new Set<Id>();
        for (Amendment_Agreement_Product__c item : this.itemOlds) {
            productIds.add(item.Product__c);
        }

        for (Amendment_Agreement_Product__c item : this.itemNews) {
            productIds.add(item.Product__c);
        }

        productMap = new Map<Id, leanx__hr_Resource__c>(
            [SELECT Id, Maximum_Power_at_STC_Pmax__c FROM leanx__hr_Resource__c WHERE Id IN :productIds]
        );

        Set<Id> amendmentIds = new Set<Id>();
        for (Amendment_Agreement_Product__c item : itemOlds) {
            amendmentIds.add(item.Amendment_Agreement__c);
        }

        for (Amendment_Agreement_Product__c item : itemNews) {
            amendmentIds.add(item.Amendment_Agreement__c);
        }

        amendmentMap = new Map<Id, Amendment_Agreement__c>([
            SELECT Id,
                   Agreement__c
            FROM Amendment_Agreement__c 
            WHERE Id IN :amendmentIds]
        );
        
        items = new List<Amendment_Agreement_Product__c>([
            SELECT Id,
                   Name,
                   Amendment_Agreement__c,
                   Sales_Price__c,
                   Quantity__c,
                   Guaranteed_Delivery_Date__c,
                   Delivery_Date_Description__c,
                   Product_Grade__c,
                   IsDeleted,
                   Total_Power_W__c
            FROM Amendment_Agreement_Product__c 
            WHERE Amendment_Agreement__c IN :amendmentMap.keySet()
        ]);
    }
    
    // calculate total power, total price
    private void calculate() {
        for (Amendment_Agreement_Product__c item : this.itemNews) {
            leanx__hr_Resource__c product = this.productMap.get(item.Product__c);
            Decimal price = item.Sales_Price__c != null ? item.Sales_Price__c : 0;
            Decimal power = item.Power_W__c;
            Decimal quantity = item.Quantity__c != null ? item.Quantity__c : 0;
            item.Total_Power_W__c = power * quantity;
            item.Total_Price__c = item.Product_Grade__c != 'Degrade' && item.Total_Power_W__c != 0 ? item.Total_Power_W__c * price : quantity * price;
        }
    }

    private void updateProject() {
        TriggerHandler.bypass('RC_AmendmentAgreementBasicHandler');
        // this.getStockOrNot();
        this.resetRollupField();
        // this.resetApprovalStatus();
        update amendmentMap.values();
    }

    // transfer to stock or not
    // private void getStockOrNot() {
    //     Map<Id, Boolean> amendmentIdstockOrNot = new Map<Id, Boolean>();
    //     for (Amendment_Agreement_Product__c item : this.items) {
    //         if (item.Product_Grade__c == 'Sluggish') amendmentIdstockOrNot.put(item.Amendment_Agreement__c, true);
    //     }

    //     for (Amendment_Agreement__c project : amendmentMap.values()) {
    //         if (amendmentIdstockOrNot.containsKey(project.Id)) project.Transfer_To_Stock__c = true;
    //         else project.Transfer_To_Stock__c = false;
    //     }
    // }

    private void checkProjectLock () {
        for (Amendment_Agreement_Product__c item : this.items) {
            if (item.Amendment_Agreement__c != null && Approval.isLocked(item.Amendment_Agreement__c)) item.addError(new QW_Utils.QWException('补充协议已锁定，暂时无法进行产品维护。'));
        }
    }

    // reset project approval atatus
    // private void resetApprovalStatus() {
    //     Set<Id> amendmentIds = new Set<Id>();
    //     for (Id itemId : itemOldMap.keySet()) {
    //         Amendment_Agreement_Product__c itemOld = itemOldMap.get(itemId);
    //         Amendment_Agreement_Product__c itemNew = itemNewMap.get(itemId);
    //         if (itemNew == null) amendmentIds.add(itemOld.Amendment_Agreement__c);
    //         // 数量变更，仅重置合同审批
    //         // else if (itemOld.Quantity__c != itemNew.Quantity__c) amendmentIds.add(itemOld.Amendment_Agreement__c);
    //         else if (itemOld.Sales_Price__c != itemNew.Sales_Price__c) amendmentIds.add(itemOld.Amendment_Agreement__c);
    //     }

    //     for (Id itemId : itemNewMap.keySet()) {
    //         Amendment_Agreement_Product__c itemOld = itemOldMap.get(itemId);
    //         Amendment_Agreement_Product__c itemNew = itemNewMap.get(itemId);
    //         if (itemOld == null) amendmentIds.add(itemNew.Amendment_Agreement__c);
    //     }

    //     // reset
    //     for (Id amendmentId : amendmentIds) {
    //         Amendment_Agreement__c project = amendmentMap.get(amendmentId);
    //         if (project.Stage__c != 'Price Approved') continue;
    //         if (project.RecordType.DeveloperName == 'Project_Bid') {
    //             project.GM_Approval__c = null;
    //             project.Overseas_Sales_Team_GM_Approval__c = null;
    //             project.Cross_Region_GM_Approval__c = null;
    //             project.Stage__c = 'Won Bid';
    //             project.Probability__c = '30%';
    //         } else {
    //             project.GM_Approval__c = null;
    //             project.Overseas_Sales_Team_GM_Approval__c = null;
    //             project.Cross_Region_GM_Approval__c = null;
    //             project.Stage__c = 'Prospecting';
    //             project.Probability__c = '10%';
    //         }
    //     }
    // }

    // reset project rollup field
    private void resetRollupField() {
        Map<Id, List<Amendment_Agreement_Product__c>> amendmentIdItemsMap = new Map<Id, List<Amendment_Agreement_Product__c>>();
        for (Amendment_Agreement_Product__c item : this.items) {
            if (item.IsDeleted) continue; 
            else if (amendmentIdItemsMap.containsKey(item.Amendment_Agreement__c)) amendmentIdItemsMap.get(item.Amendment_Agreement__c).add(item);
            else amendmentIdItemsMap.put(item.Amendment_Agreement__c, new List<Amendment_Agreement_Product__c>{item});
        }

        Map<Id, Id> amendmentIdAgreementIdMap = new Map<Id, Id>();
        for (Id amendmentId : amendmentMap.keySet()) {
            amendmentIdAgreementIdMap.put(amendmentId, amendmentMap.get(amendmentId).Agreement__c);
        }
        
        Map<Id, List<Agreement_Component__c>> agreementIdItemsMap = new Map<Id, List<Agreement_Component__c>>();
        for (Agreement_Component__c item : [
                SELECT Id,
                       Name,
                       Agreement__c,
                       Sales_Price__c,
                       Quantity__c,
                       Guaranteed_Delivery_Date__c,
                       Delivery_Date_Description__c
                FROM Agreement_Component__c
                WHERE Agreement__c IN: amendmentIdAgreementIdMap.values()]) {
            
            if (agreementIdItemsMap.containsKey(item.Agreement__c)) agreementIdItemsMap.get(item.Agreement__c).add(item);
            else agreementIdItemsMap.put(item.Agreement__c, new List<Agreement_Component__c>{item});
        }

        // 计算单价，数量，确认交期，交期描述 字段是否变更
        for (Id amendmentId : amendmentMap.keySet()) {
            Id agreementId = amendmentIdAgreementIdMap.get(amendmentId);
            if (agreementId == null) continue;
            List<Agreement_Component__c> agreementItems = agreementIdItemsMap.containsKey(agreementId) ? 
                agreementIdItemsMap.get(agreementId) : new List<Agreement_Component__c>();
            List<Amendment_Agreement_Product__c> amendmentItems = amendmentIdItemsMap.containsKey(amendmentId) ?
                amendmentIdItemsMap.get(amendmentId) : new List<Amendment_Agreement_Product__c>();

            Set<String> priceOlds = new Set<String>();
            Set<String> deliveryDateOlds = new Set<String>();
            for (Agreement_Component__c item : agreementItems) {
                String name = item.Name;
                Decimal price = item.Sales_Price__c != null ? item.Sales_Price__c : 0;
                Decimal quantity = item.Quantity__c != null ? item.Quantity__c : 0;
                String gdd = item.Guaranteed_Delivery_Date__c != null ? QW_Utils.dateToString(item.Guaranteed_Delivery_Date__c) : '';
                String dds = item.Delivery_Date_Description__c != null ? item.Delivery_Date_Description__c : '';
                priceOlds.add(name + price + quantity);
                deliveryDateOlds.add(name + gdd + dds);
            }

            Set<String> priceNews = new Set<String>();
            Set<String> deliveryDateNews = new Set<String>();
            for (Amendment_Agreement_Product__c item : amendmentItems) {
                if (item.IsDeleted) continue;
                String name = item.Name;
                Decimal price = item.Sales_Price__c != null ? item.Sales_Price__c : 0;
                Decimal quantity = item.Quantity__c != null ? item.Quantity__c : 0;
                String gdd = item.Guaranteed_Delivery_Date__c != null ? QW_Utils.dateToString(item.Guaranteed_Delivery_Date__c) : '';
                String dds = item.Delivery_Date_Description__c != null ? item.Delivery_Date_Description__c : '';
                priceNews.add(name + price + quantity);
                deliveryDateNews.add(name + gdd + dds);
            }

            if (!priceOlds.equals(priceNews)) amendmentMap.get(amendmentId).Price_Changed__c = true;
            else amendmentMap.get(amendmentId).Price_Changed__c = false;
            if (!deliveryDateOlds.equals(deliveryDateNews)) amendmentMap.get(amendmentId).Delivery_Date_Changed__c = true;
            else amendmentMap.get(amendmentId).Delivery_Date_Changed__c = false;
        }
    }
}