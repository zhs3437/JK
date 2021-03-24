public without sharing class RC_ProjectBasicHandler extends TriggerHandler {
    public List<leanx__pm_Project__c> projectOlds;
    public List<leanx__pm_Project__c> projectNews;
    public Map<Id, leanx__pm_Project__c> projectOldMap;
    public Map<Id, leanx__pm_Project__c> projectNewMap;
    public RC_ProjectBasicHandler () {
        projectOlds = (List<leanx__pm_Project__c>) Trigger.old;
        projectNews = (List<leanx__pm_Project__c>) Trigger.new;
        projectOldMap = (Map<Id, leanx__pm_Project__c>) Trigger.oldMap;
        projectNewMap = (Map<Id, leanx__pm_Project__c>) Trigger.newMap;
    }

    public override void beforeInsert() {
        getSOC();
        getAccountContact();
    }

    public override void beforeUpdate() {
        checkStage();
        updateCommission();
        getAccountContact();
        updateItem();
    }

    // Items
    public void updateItem () {
        Map<Id, String> projectIdCurrencyMap = new Map<Id, String>();
        for (Id projectId : projectNewMap.keySet()) {
            leanx__pm_Project__c projectOld = projectOldMap.get(projectId);
            leanx__pm_Project__c projectNew = projectNewMap.get(projectId);
            if (projectOld.CurrencyIsoCode != projectNew.CurrencyIsoCode) projectIdCurrencyMap.put(projectId, projectNew.CurrencyIsoCode);
        }
        List<leanx__pm_ProjectMember__c> items = [
            SELECT Id,
                   CurrencyIsoCode,
                   Sales_Price__c,
                   leanx__Project__c
            FROM leanx__pm_ProjectMember__c
            WHERE leanx__Project__c IN: projectIdCurrencyMap.keySet()];
        for (leanx__pm_ProjectMember__c item : items) {
            item.CurrencyIsoCode = projectIdCurrencyMap.get(item.leanx__Project__c);
        }
        if (items.size() > 0) update items;
    }

    // SOC
    public void getSOC () {
        Map<Id, User> salesIdMap = new Map<Id, User>();
        for (leanx__pm_Project__c project : this.projectNews) {
            if (project.Actual_Sales__c != null) salesIdMap.put(project.Actual_Sales__c, null);
        }
        for (User sales : [SELECT Id, BMO_specialist__c FROM User WHERE Id IN :salesIdMap.keySet()]) {
            salesIdMap.put(sales.Id, sales);
        }
        User currentUser = [SELECT BMO_specialist__c FROM User WHERE Id = :UserInfo.getUserId()][0];
        for (leanx__pm_Project__c project : this.projectNews) {
            if (project.Actual_Sales__c == null) continue;
            User sales = salesIdMap.get(project.Actual_Sales__c);
            if (project.SOC_Specialist__c == null) project.SOC_Specialist__c = sales != null ? sales.BMO_specialist__c : currentUser.BMO_specialist__c;
        }
    }

    // update Account Contact
    public void getAccountContact() {
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        for (leanx__pm_Project__c project : this.projectNews) {
            if (project.Account_Contact__c == null) {
                accountIds.add(project.leanx__Account__c);
            } else {
                contactIds.add(project.Account_Contact__c);
            }
        }

        Map<Id, Contact> IdMap = new Map<Id, Contact>([SELECT Id, Name, MobilePhone FROM Contact WHERE Id IN :contactIds]);
        for (Contact contact : [SELECT Id, Name, MobilePhone, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
            if (!IdMap.containsKey(contact.AccountId)) IdMap.put(contact.AccountId, contact);
        }

        for (leanx__pm_Project__c project : this.projectNews) {
            if (project.Account_Contact_Name__c != null || project.Account_Contact_Mobile__c != null) continue;
            if (project.Account_Contact__c == null && IdMap.containsKey(project.leanx__Account__c)) {
                project.Account_Contact__c = IdMap.get(project.leanx__Account__c).Id;
                project.Account_Contact_Name__c = IdMap.get(project.leanx__Account__c).Name;
                project.Account_Contact_Mobile__c = IdMap.get(project.leanx__Account__c).MobilePhone;
            } else if (project.Account_Contact__c != null && IdMap.containsKey(project.Account_Contact__c)) {
                project.Account_Contact_Name__c = IdMap.get(project.Account_Contact__c).Name;
                project.Account_Contact_Mobile__c = IdMap.get(project.Account_Contact__c).MobilePhone;
            }
        }
    }

    // update Sales
    // public void getSales() {
    //     Set<Id> userIds = new Set<Id>();
    //     for (leanx__pm_Project__c project : this.projectNews) {
    //         if (project.Actual_Sales__c != null) userIds.add(project.Actual_Sales__c);
    //     }

    //     Map<Id, User> IdMap = new Map<Id, User>([SELECT Id, Name, MobilePhone FROM User WHERE Id IN :userIds]);
        
    //     for (leanx__pm_Project__c project : this.projectNews) {
    //         if (project.Actual_Sales_Name__c != null) continue;
    //         if (project.Actual_Sales__c == null || !IdMap.containsKey(project.Actual_Sales__c)) continue;
    //         project.Actual_Sales_Name__c = IdMap.get(project.Actual_Sales__c).Name;
    //     }
    // }

    //Commission Update
    public void updateCommission(){
        List<id> projectIds = new List<id>();
        for (leanx__pm_Project__c project : this.projectNews) {
            if (project.CFO_Approval_Status__c == 'Approved' && project.CEO_Approval_Status__c == 'Approved' && project.VP_Approval_Status__c == 'Approved' 
                && project.Commission_Type__c == null && project.Commission__c == null){
                projectIds.add(project.Id);
            }
        }
        List<Commission_Application2__c> commissions = [
            SELECT Id,
                   Name,
                   Commission_Per_watt__c,
                   Project__c
            FROM   Commission_Application2__c
            WHERE  Project__c IN: projectIds]; 
        for (leanx__pm_Project__c project : this.projectNews) {
            for(Commission_Application2__c commission : commissions){
                if(project.id == commission.Project__c){
                    project.Commission__c=commission.Commission_Per_watt__c;
                    project.Commission_Type__c='Per/W';
                }
            }
        }
    }

    public void checkStage() {
        Map<String, String> autoStages = new Map<String, String>{
            'Contract Negotiation' => '合同谈判',
            'Contract Signed' => '合同签署',
            'Price Approved' => '价格批准'
        };

        for (Id projectId : projectNewMap.keySet()) {
            leanx__pm_Project__c projectOld = projectOldMap.get(projectId);
            leanx__pm_Project__c projectNew = projectNewMap.get(projectId);
            // if (projectOld.Stage__c != projectNew.Stage__c && autoStages.containsKey(projectNew.Stage__c)) projectNew.addError('\'' + autoStages.get(projectNew.Stage__c) +'\' 阶段不可手动变更');
            if (projectOld.Stage__c != projectNew.Stage__c && 
                projectNew.GM_Approval__c != 'Approved' && 
                autoStages.containsKey(projectNew.Stage__c)) projectNew.addError('\'' + autoStages.get(projectNew.Stage__c) +'\' 阶段需完成价格审批');
        }
    }
}