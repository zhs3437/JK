public class RC_AmendmentAgreementBasicHandler extends TriggerHandler{
    public List<Amendment_Agreement__c> amendmentNews;
    public List<Amendment_Agreement__c> amendmentOlds;
    public Map<String,Amendment_Agreement__c> amendmentNewMap;
    public Map<String,Amendment_Agreement__c> amendmentOldMap;
    public Set<Id> updateConCommentsId;
    public Set<Id> updateConStatusId;
    public Set<Id> updateConShareId;
    public RC_AmendmentAgreementBasicHandler () {
        updateConCommentsId = new Set<Id>();
        updateConStatusId = new Set<Id>();
        updateConShareId = new Set<Id>();
        amendmentNewMap = new Map<String,Amendment_Agreement__c>();
        amendmentOldMap = new Map<String,Amendment_Agreement__c>();
        this.amendmentNews = (List<Amendment_Agreement__c>) Trigger.new;
        this.amendmentOlds = (List<Amendment_Agreement__c>) Trigger.old;
        if(amendmentOlds != null & amendmentOlds.size()>0){
            for(Amendment_Agreement__c amendment : (List<Amendment_Agreement__c>) Trigger.old){
                amendmentOldMap.put(amendment.Id,amendment);
            }
        }
        if(amendmentNews != null & amendmentNews.size()>0){
            for(Amendment_Agreement__c amendment : (List<Amendment_Agreement__c>) Trigger.new){
                amendmentNewMap.put(amendment.Id,amendment);
            }
        }
    }

    public override void beforeInsert() {
        // initApprover();
    }

    public override void beforeUpdate() {
        for (Id amendmentId : amendmentNewMap.keySet()) {
            Amendment_Agreement__c amendmentOld = amendmentOldMap.get(amendmentId);
            Amendment_Agreement__c amendmentNew = amendmentNewMap.get(amendmentId);
            if (amendmentOld.Joint_Review_Completed__c != amendmentNew.Joint_Review_Completed__c) updateConCommentsId.add(amendmentNew.Id);
            if (amendmentOld.Review_Status_SOC__c != amendmentNew.Review_Status_SOC__c) updateConStatusId.add(amendmentNew.Id);
            if (amendmentOld.Actual_Sales__c != amendmentNew.Actual_Sales__c ) updateConShareId.add(amendmentNew.Id);
        }
    
        if(updateConCommentsId.size()>0){
            updateComments();
        }
    
        if(updateConCommentsId.size()>0){
            updateStatus();
        }
    
        if(updateConCommentsId.size()>0){
            updateShare();
        }
    }
    
    public override void afterUpdate() {
        // TriggerHandler.bypass('RC_AmendmentComponentBasicHandler');
        updateItem();
    }

    // Items
    public void updateItem () {
        Map<Id, String> amendmentIdCurrencyMap = new Map<Id, String>();
        for (Id amendmentId : amendmentNewMap.keySet()) {
            Amendment_Agreement__c amendmentOld = amendmentOldMap.get(amendmentId);
            Amendment_Agreement__c amendmentNew = amendmentNewMap.get(amendmentId);
            if (amendmentOld.CurrencyIsoCode != amendmentNew.CurrencyIsoCode) amendmentIdCurrencyMap.put(amendmentId, amendmentNew.CurrencyIsoCode);
        }
        List<Amendment_Agreement_Product__c> items = [
            SELECT Id,
                    CurrencyIsoCode,
                    Sales_Price__c,
                    Amendment_Agreement__c
            FROM Amendment_Agreement_Product__c
            WHERE Amendment_Agreement__c IN: amendmentIdCurrencyMap.keySet()];
        for (Amendment_Agreement_Product__c item : items) {
            item.CurrencyIsoCode = amendmentIdCurrencyMap.get(item.Amendment_Agreement__c);
        }
        if (items.size() > 0) update items;
    }

  void updateComments () {
      if(updateConCommentsId.size()>0){
        List<String> imdaApproval = system.label.iAmendment_Agreement.split(';');
        List<ProcessInstance> pro = [
            SELECT Id, 
                   TargetObjectId, 
                   ProcessDefinitionId,
                   ProcessDefinition.Name, 
                   (SELECT Id, 
                           Comments, 
                           StepStatus, 
                           OriginalActorId, 
                           CreatedDate 
                    FROM Steps) 
            FROM ProcessInstance 
            WHERE TargetObjectId IN :updateConCommentsId 
            AND  ProcessDefinitionId IN :imdaApproval 
            ORDER BY CreatedDate DESC limit 1 
        ];
    
        Set<Id> mdaIds = new Set<Id>();
        Set<String> comments = new Set<String>();
        Map<Id,ProcessInstanceStep> maps = new Map<Id,ProcessInstanceStep>();
        Map<Id,Id> mapmdas = new Map<Id,Id>();
        for(ProcessInstance p : pro){    
            for(ProcessInstanceStep ps : p.Steps){       
                mdaIds.add(ps.OriginalActorId);
                maps.put(ps.OriginalActorId,ps);
                mapmdas.put(ps.OriginalActorId,p.TargetObjectId);
                system.debug('Steps' + ps);
            }
        }
        //取中国区简档Id
        String Finance;
        String SOC;
        String Logistic;
        String Legal;
        String Technology;
        
        List<Profile> FinanceprofileIds = [select Id from Profile where Name = 'China - Finance'];
        for(Profile FinanceprofileId : FinanceprofileIds){
            Finance = FinanceprofileId.Id;
        }
        List<Profile> SOCprofileIds = [select Id from Profile where Name = 'China - BMO'];
        for(Profile SOCprofileId : SOCprofileIds){
            SOC = SOCprofileId.Id;
        }
        List<Profile> LogisticprofileIds= [select Id from Profile where Name = 'China - Logistic'];
        for(Profile LogisticprofileId : LogisticprofileIds){
            Logistic = LogisticprofileId.Id;
        }
        List<Profile> LegalprofileIds= [select Id from Profile where Name = 'China - Legal'];
        for(Profile LegalprofileId : LegalprofileIds){
            Legal = LegalprofileId.Id;
        }
        List<Profile> TechnologyprofileIds= [select Id from Profile where Name = 'China - Technical'];
        for(Profile TechnologyprofileId : TechnologyprofileIds){
            Technology = TechnologyprofileId.Id;
        }
        
        system.debug('SOC'+ SOC);
        system.debug('Finance'+ Finance);
        system.debug('Logistic'+ Logistic);
        system.debug('Legal'+ Legal);
        String mdaFinance;
        String mdaSOC;
        String mdaLogistics;
        String mdaLegal;
        String mdaTechnology;
        
        DateTime mdaFinanceFinishTime;
        DateTime mdaSOCFinishTime;
        DateTime mdaLogisticsFinishTime;
        DateTime mdaLegalFinishTime;
        DateTime mdaTechnologyFinishTime;
        
        String mdaFinanceStatus;
        String mdaSOCStatus;
        String mdaLogisticsStatus;
        String mdaLegalStatus;
        String mdaTechnologyStatus;
        
        List<User> user = [select Id, Profile.Id,Department  from User where Id  IN :mdaIds];
        for(User u : user){
            mdaFinance ='';
            mdaFinanceFinishTime =null;
            mdaFinanceStatus ='';
            mdaSOC ='';
            mdaSOCFinishTime =null;
            mdaSOCStatus ='';
            mdaLogistics ='';
            mdaLogisticsFinishTime =null;
            mdaLogisticsStatus ='';

            mdaLegal ='';
            mdaLegalFinishTime =null;
            mdaLegalStatus ='';
            mdaTechnology ='';
            mdaTechnologyFinishTime =null;
            mdaTechnologyStatus ='';
            if(mapmdas.get(u.Id) !=null){
            Id conId = mapmdas.get(u.Id);
          Amendment_Agreement__c amendment = amendmentNewMap.get(conId);
            if(u.ProfileId == Finance || u.Department =='Finance'){
                mdaFinance = maps.get(u.Id).Comments;
                mdaFinanceFinishTime = maps.get(u.Id).CreatedDate;
                mdaFinanceStatus = maps.get(u.Id).StepStatus;

                if(mdaFinance != null) amendment.Review_Comment_Finance__c = mdaFinance;
                if(mdaSOCFinishTime != null) amendment.Review_Finish_Time_SOC__c = mdaSOCFinishTime;
                if(mdaFinanceStatus != null) amendment.Review_Status_Finance__c = mdaFinanceStatus;
            }else if(u.ProfileId == SOC || u.Department =='BMO'){
                mdaSOC = maps.get(u.Id).Comments;
                mdaSOCFinishTime = maps.get(u.Id).CreatedDate;
                mdaSOCStatus = maps.get(u.Id).StepStatus;
                system.debug('SOCID'+u.Id);
                system.debug('SOC评论'+mdaSOC);

                if(mdaSOC != null) amendment.Review_Comment_SOC__c =  mdaSOC;
                if(mdaFinanceFinishTime != null) amendment.Review_Finish_Time_Finance__c = mdaFinanceFinishTime;
                if(mdaSOCStatus != null) amendment.Review_Status_SOC__c = mdaSOCStatus;

            }else if(u.ProfileId == Logistic || u.Department =='Logistic'){
                mdaLogistics = maps.get(u.Id).Comments;
                mdaLogisticsFinishTime = maps.get(u.Id).CreatedDate;
                mdaLogisticsStatus = maps.get(u.Id).StepStatus;

                if(mdaLogistics != null) amendment.Review_Comment_Logistics__c = mdaLogistics;
                if(mdaLogisticsFinishTime != null) amendment.Review_Finish_Time_Logistics__c = mdaLogisticsFinishTime;
                if(mdaLogisticsStatus != null) amendment.Review_Status_Logistics__c = mdaLogisticsStatus;
            }else if(u.ProfileId == Legal || u.Department =='Legal'){
                mdaLegal = maps.get(u.Id).Comments;
                mdaLegalFinishTime = maps.get(u.Id).CreatedDate;
                mdaLegalStatus = maps.get(u.Id).StepStatus;

                if(mdaLegal != null) amendment.Review_Comment_Legal__c = mdaLegal;
                if(mdaLegalFinishTime != null) amendment.Review_Finish_Time_Legal__c = mdaLegalFinishTime;
                if(mdaLegalStatus != null) amendment.Review_Status_Legal__c = mdaLegalStatus;
            }else if(u.ProfileId == Technology || u.Department =='Technical'){
                mdaTechnology = maps.get(u.Id).Comments;
                mdaTechnologyFinishTime = maps.get(u.Id).CreatedDate;
                mdaTechnologyStatus = maps.get(u.Id).StepStatus;

                if(mdaTechnology != null) amendment.Review_Comment_Technology__c = mdaTechnology;
                if(mdaTechnologyFinishTime != null) amendment.Review_Finish_Time_Technology__c = mdaTechnologyFinishTime;
                if(mdaTechnologyStatus != null) amendment.Review_Status_Technology__c = mdaTechnologyStatus;
            }
          }
        }
      }
    }
    
    void updateStatus(){
        this.amendmentNews[0].Review_Pending_Time_SOC__c = System.now();
    }
    
    void updateShare(){
        
    }

}