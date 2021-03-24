public without sharing class RC_ProjectComponentBasicHandler extends TriggerHandler {
    public List<leanx__pm_ProjectMember__c> itemOlds;
    public List<leanx__pm_ProjectMember__c> itemNews;
    public List<leanx__pm_ProjectMember__c> items;
    public Map<Id, leanx__pm_ProjectMember__c> itemOldMap;
    public Map<Id, leanx__pm_ProjectMember__c> itemNewMap;
    public Map<Id, leanx__hr_Resource__c> productMap;
    public Map<Id, leanx__pm_Project__c> projectMap;
    public RC_ProjectComponentBasicHandler () {
        itemOlds = new List<leanx__pm_ProjectMember__c>((List<leanx__pm_ProjectMember__c>) Trigger.old);
        itemNews = new List<leanx__pm_ProjectMember__c>((List<leanx__pm_ProjectMember__c>) Trigger.new);
        itemOldMap = new Map<Id, leanx__pm_ProjectMember__c>();
        if (Trigger.oldMap != null) itemOldMap.putAll((Map<Id, leanx__pm_ProjectMember__c>) Trigger.oldMap);
        itemNewMap = new Map<Id, leanx__pm_ProjectMember__c>();
        if (Trigger.newMap != null) itemNewMap.putAll((Map<Id, leanx__pm_ProjectMember__c>) Trigger.newMap);
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
        for (leanx__pm_ProjectMember__c item : this.itemOlds) {
            productIds.add(item.Product__c);
        }

        for (leanx__pm_ProjectMember__c item : this.itemNews) {
            productIds.add(item.Product__c);
        }

        productMap = new Map<Id, leanx__hr_Resource__c>(
            [SELECT Id, 
                    Maximum_Power_at_STC_Pmax__c, 
                    Series_Type__c, Series__c 
             FROM leanx__hr_Resource__c 
             WHERE Id IN :productIds]
        );

        Set<Id> projectIds = new Set<Id>();
        for (leanx__pm_ProjectMember__c item : itemOlds) {
            projectIds.add(item.leanx__Project__c);
        }

        for (leanx__pm_ProjectMember__c item : itemNews) {
            projectIds.add(item.leanx__Project__c);
        }

        projectMap = new Map<Id, leanx__pm_Project__c>([
            SELECT  Id, 
                    Total_PercentT__c,
                    Stage__c,
                    RecordType.DeveloperName,
                    GM_Approval__c,
                    Overseas_Sales_Team_GM_Approval__c,
                    Cross_Region_GM_Approval__c,
                    Probability__c
            FROM leanx__pm_Project__c 
            WHERE Id IN :projectIds]
        );
        
        items = new List<leanx__pm_ProjectMember__c>([
            SELECT Id, 
                   leanx__Project__c, 
                   Product_Grade__c,
                   IsDeleted,
                   Total_Power_W__c,
                   Quantity__c
            FROM leanx__pm_ProjectMember__c 
            WHERE leanx__Project__c IN :projectMap.keySet()
        ]);
    }
    
    // calculate total power, total price
    private void calculate() {
        for (leanx__pm_ProjectMember__c item : this.itemNews) {
            Decimal price = item.Sales_Price__c != null ? item.Sales_Price__c : 0;
            // Decimal power = product != null && product.Maximum_Power_at_STC_Pmax__c != null ? product.Maximum_Power_at_STC_Pmax__c : item.Power_W_Manual__c;
            Decimal power = item.Power_W__c;
            Decimal quantity = item.Quantity__c != null ? item.Quantity__c : 0;
            item.Total_Power_W__c = power * quantity;
            item.Total_Price__c = item.Product_Grade__c != 'Degrade' && item.Total_Power_W__c != 0 ? item.Total_Power_W__c * price : quantity * price;

            item.IsMDAPass__c = item.MDA__c != null || item.Product_Grade__c == 'Degrade' || item.Product_Grade__c == 'Sluggish' || item.Product_Name__c != '太阳能组件';
            
            leanx__hr_Resource__c product = this.productMap.get(item.Product__c);
            if (product == null) continue;
            item.Main_Type__c = product.Series_Type__c;
            item.Product_Series__c = product.Series__c;
        }
    }

    private void updateProject() {
        TriggerHandler.bypass('RC_ProjectBasicHandler');
        TriggerHandler.bypass('RC_ProjectGrossMarginHandler');
        this.getStockOrNot();
        this.resetRollupField();
        this.resetApprovalStatus();
        update projectMap.values();
    }

    // transfer to stock or not
    private void getStockOrNot() {
        Map<Id, Boolean> projectIdStockOrNot = new Map<Id, Boolean>();
        for (leanx__pm_ProjectMember__c item : this.items) {
            if (item.Product_Grade__c == 'Sluggish' || item.Product_Grade__c == 'Degrade') projectIdStockOrNot.put(item.leanx__Project__c, true);
        }

        for (leanx__pm_Project__c project : projectMap.values()) {
            if (projectIdStockOrNot.containsKey(project.Id)) project.Transfer_To_Stock__c = true;
            else project.Transfer_To_Stock__c = false;
        }
    }

    private void checkProjectLock () {
        for (leanx__pm_ProjectMember__c item : this.items) {
            if (item.leanx__Project__c != null && Approval.isLocked(item.leanx__Project__c)) item.addError(new QW_Utils.QWException('项目已锁定，暂时无法进行产品维护。'));
        }
    }

    // reset project approval atatus
    private void resetApprovalStatus() {
        Set<Id> projectIds = new Set<Id>();
        for (Id itemId : itemOldMap.keySet()) {
            leanx__pm_ProjectMember__c itemOld = itemOldMap.get(itemId);
            leanx__pm_ProjectMember__c itemNew = itemNewMap.get(itemId);
            if (itemNew == null) projectIds.add(itemOld.leanx__Project__c);
            // 数量变更，仅重置合同审批
            // else if (itemOld.Quantity__c != itemNew.Quantity__c) projectIds.add(itemOld.leanx__Project__c);
            else if (itemOld.Sales_Price__c != itemNew.Sales_Price__c) projectIds.add(itemOld.leanx__Project__c);
        }

        for (Id itemId : itemNewMap.keySet()) {
            leanx__pm_ProjectMember__c itemOld = itemOldMap.get(itemId);
            leanx__pm_ProjectMember__c itemNew = itemNewMap.get(itemId);
            if (itemOld == null) projectIds.add(itemNew.leanx__Project__c);
        }

        // reset
        for (Id projectId : projectIds) {
            leanx__pm_Project__c project = projectMap.get(projectId);
            if (project.Stage__c != 'Price Approved') continue;
            if (project.RecordType.DeveloperName == 'Project_Bid') {
                project.GM_Approval__c = null;
                project.Overseas_Sales_Team_GM_Approval__c = null;
                project.Cross_Region_GM_Approval__c = null;
                project.Stage__c = 'Won Bid';
                project.Probability__c = '30%';
            } else {
                project.GM_Approval__c = null;
                project.Overseas_Sales_Team_GM_Approval__c = null;
                project.Cross_Region_GM_Approval__c = null;
                project.Stage__c = 'Prospecting';
                project.Probability__c = '10%';
            }
        }
    }

    // reset project rollup field
    private void resetRollupField() {
        Map<Id, List<leanx__pm_ProjectMember__c>> projectIdItems = new Map<Id, List<leanx__pm_ProjectMember__c>>();
        for (leanx__pm_ProjectMember__c item : this.items) {
            if (item.IsDeleted) continue; 
            else if (projectIdItems.containsKey(item.leanx__Project__c)) projectIdItems.get(item.leanx__Project__c).add(item);
            else projectIdItems.put(item.leanx__Project__c, new List<leanx__pm_ProjectMember__c>{item});
        }

        for (String projectId : projectMap.keySet()) {
            List<leanx__pm_ProjectMember__c> projectItems = projectIdItems.get(projectId);
            Decimal totalPower = 0;
            if (projectItems == null) {
                projectMap.get(projectId).Total_Power_MWT__c = 0;
                continue;
            }
            for (leanx__pm_ProjectMember__c item : projectItems) {
                if (item.IsDeleted) continue; 
                totalPower += item.Total_Power_W__c;
            }
            projectMap.get(projectId).Total_Power_MWT__c = totalPower.divide(1000000, 6);
        }
    }
}