public without sharing class RC_PaymentBasicHandler extends TriggerHandler {
    public Map<Id, Payment__c> paymentOldMap;
    public Map<Id, Payment__c> paymentNewMap;
    public Map<Id, Payment__c> paymentMap;
    public Map<Id, leanx__pm_Project__c> projectMap;
    public Map<Id, Amendment_Agreement__c> amendmentMap;
    public RC_PaymentBasicHandler () {
        paymentOldMap = new Map<Id, Payment__c>();
        if (Trigger.oldMap != null) paymentOldMap.putAll((Map<Id, Payment__c>) Trigger.oldMap);
        paymentNewMap = new Map<Id, Payment__c>();
        if (Trigger.newMap != null) paymentNewMap.putAll((Map<Id, Payment__c>) Trigger.newMap);
    }

    public override void beforeInsert() {
        checkProjectLock();
    }
    
    public override void beforeUpdate() {
        checkProjectLock();
    }
    
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

    private void family() {
        Set<Id> projectIds = new Set<Id>();
        Set<Id> amendmentIds = new Set<Id>();
        Set<Id> agreementIds = new Set<Id>();
        for (Payment__c payment : paymentOldMap.values()) {
            if (payment.China_Project__c != null) projectIds.add(payment.China_Project__c);
            else if (payment.Amendment_Agreement__c != null) amendmentIds.add(payment.Amendment_Agreement__c);
            else return;
        }

        for (Payment__c payment : paymentNewMap.values()) {
            if (payment.China_Project__c != null) projectIds.add(payment.China_Project__c);
            else if (payment.Amendment_Agreement__c != null) amendmentIds.add(payment.Amendment_Agreement__c);
            else return;
        }

        projectMap = new Map<Id, leanx__pm_Project__c>([
            SELECT  Id, 
                    Total_PercentT__c,
                    RecordType.DeveloperName,
                    GM_Approval__c,
                    Overseas_Sales_Team_GM_Approval__c,
                    Cross_Region_GM_Approval__c,
                    Stage__c,
                    Probability__c
            FROM leanx__pm_Project__c 
            WHERE Id IN :projectIds]
        );

        amendmentMap = new Map<Id, Amendment_Agreement__c>([
            SELECT Id,
                   Agreement__c
            FROM Amendment_Agreement__c 
            WHERE Id IN :amendmentIds]
        );

        for (Amendment_Agreement__c amendment : amendmentMap.values()) {
            if (amendment.Agreement__c != null) agreementIds.add(amendment.Agreement__c);
        }
        
        paymentMap = new Map<Id, Payment__c>([
            SELECT Id, 
                   China_Project__c,
                   China_Order__c,
                   Amendment_Agreement__c,
                   Payment_Stage_China__c,
                   Payment_Method_China__c,
                   Percentage__c,
                   IsDeleted
            FROM Payment__c 
            WHERE China_Project__c IN :projectMap.keySet()
            OR Amendment_Agreement__c IN :amendmentMap.keySet()
            OR China_Order__c IN :agreementIds
        ]);
    }

    private void updateProject() {
        TriggerHandler.bypass('RC_ProjectBasicHandler');
        TriggerHandler.bypass('RC_ProjectGrossMarginHandler');
        TriggerHandler.bypass('RC_AmendmentBasicHandler');
        TriggerHandler.bypass('RC_AmendmentGrossMarginHandler');
        this.resetRollupField();
        this.resetApprovalStatus();
        
        if (this.projectMap != null) update this.projectMap.values();
        if (this.amendmentMap != null) update this.amendmentMap.values();
    }

    private void checkProjectLock () {
        for (Payment__c payment : this.paymentNewMap.values()) {
            if (payment.China_Project__c != null && Approval.isLocked(payment.China_Project__c)) payment.addError(new QW_Utils.QWException('项目已锁定，暂时无法进行付款方式维护。'));
            if (payment.Amendment_Agreement__c != null && Approval.isLocked(payment.Amendment_Agreement__c)) payment.addError(new QW_Utils.QWException('补充协议已锁定，暂时无法进行付款方式维护。'));
        }
    }

    // reset project approval atatus
    private void resetApprovalStatus() {
        Set<Id> projectIds = new Set<Id>();
        for (Id itemId : paymentOldMap.keySet()) {
            Payment__c paymentOld = paymentOldMap.get(itemId);
            Payment__c paymentNew = paymentNewMap.get(itemId);
            if (paymentOld.China_Project__c == null) continue;
            if (paymentNew == null) projectIds.add(paymentOld.China_Project__c);
            else if (paymentOld.Percentage__c != paymentNew.Percentage__c) projectIds.add(paymentOld.China_Project__c);
        }

        for (Id itemId : paymentNewMap.keySet()) {
            Payment__c paymentOld = paymentOldMap.get(itemId);
            Payment__c paymentNew = paymentNewMap.get(itemId);
            if (paymentNew.China_Project__c == null) continue;
            if (paymentOld == null) projectIds.add(paymentNew.China_Project__c);
        } 
        
        // reset
        for (Id projectId : projectIds) {
            leanx__pm_Project__c project = projectMap.get(projectId);
            if (project == null) continue;
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
        Map<Id, List<Payment__c>> projectIdPayments = new Map<Id, List<Payment__c>>();
        if (this.paymentMap == null) return;
        for (Payment__c payment : this.paymentMap.values()) {
            if (payment.IsDeleted) continue;
            else if (payment.China_Project__c != null && projectIdPayments.containsKey(payment.China_Project__c)) projectIdPayments.get(payment.China_Project__c).add(payment);
            else if (payment.China_Project__c != null) projectIdPayments.put(payment.China_Project__c, new List<Payment__c>{payment});
            else if (payment.China_Order__c != null && projectIdPayments.containsKey(payment.China_Order__c)) projectIdPayments.get(payment.China_Order__c).add(payment);
            else if (payment.China_Order__c != null) projectIdPayments.put(payment.China_Order__c, new List<Payment__c>{payment});
            else if (payment.Amendment_Agreement__c != null && projectIdPayments.containsKey(payment.Amendment_Agreement__c)) projectIdPayments.get(payment.Amendment_Agreement__c).add(payment);
            else if (payment.Amendment_Agreement__c != null) projectIdPayments.put(payment.Amendment_Agreement__c, new List<Payment__c>{payment});
        }

        for (String projectId : projectMap.keySet()) {
            leanx__pm_Project__c project = projectMap.get(projectId);
            List<Payment__c> projectPayments = projectIdPayments.get(projectId);
            Decimal totalPercent = 0;
            String paymentSummary = '';
            if (projectPayments == null) {
                project.Total_PercentT__c = 0;
                continue;
            }
            for (Payment__c payment : projectPayments) {
                if (payment.IsDeleted) continue;
                Decimal percent = payment.Percentage__c != null ? payment.Percentage__c : 0;
                totalPercent += percent;
                String stage = payment.Payment_Stage_China__c != null ? payment.Payment_Stage_China__c : '';
                String method = payment.Payment_Method_China__c != null ? payment.Payment_Method_China__c : '';
                paymentSummary += '[' + percent + '% ' + stage + ' ' + method + ']';
            }
            project.Total_PercentT__c = totalPercent;
            project.Payment_Term_Description__c = paymentSummary;
        }

        // 计算 补充协议 百分比、付款阶段、付款方式 字段是否变更
        for (Id amendmentId : amendmentMap.keySet()) {
            Amendment_Agreement__c amendment = amendmentMap.get(amendmentId);
            Id agreementId = amendment.Agreement__c;
            if (agreementId == null) continue;
            List<Payment__c> agreementPayments = projectIdPayments.containsKey(agreementId) ? projectIdPayments.get(agreementId) : new List<Payment__c>{};
            List<Payment__c> amendmentPayments = projectIdPayments.containsKey(amendmentId) ? projectIdPayments.get(amendmentId) : new List<Payment__c>{};

            Set<String> paymentOlds = new Set<String>();
            for (Payment__c payment : agreementPayments) {
                Decimal percent = payment.Percentage__c != null ? payment.Percentage__c : 0;
                String stage = payment.Payment_Stage_China__c != null ? payment.Payment_Stage_China__c : '';
                String method = payment.Payment_Method_China__c != null ? payment.Payment_Method_China__c : '';
                paymentOlds.add(percent + stage + method);
            }

            Set<String> paymentNews = new Set<String>();
            // List<String> paymentSummarys = new List<String>();
            String paymentSummary = '';
            for (Payment__c payment : amendmentPayments) {
                if (payment.IsDeleted) continue;
                Decimal percent = payment.Percentage__c != null ? payment.Percentage__c : 0;
                String stage = payment.Payment_Stage_China__c != null ? payment.Payment_Stage_China__c : '';
                String method = payment.Payment_Method_China__c != null ? payment.Payment_Method_China__c : '';
                // paymentSummarys.add(percent + ' ' + stage + ' ' + method);
                paymentSummary += '[' + percent + '% ' + stage + ' ' + method + ']';
                paymentNews.add(percent + stage + method);
            }

            if (!paymentOlds.equals(paymentNews)) amendment.Payment_Changed__c = true;
            else amendment.Payment_Changed__c = false;
            amendment.Payment_Term_Description__c = paymentSummary;
        }
    }
}