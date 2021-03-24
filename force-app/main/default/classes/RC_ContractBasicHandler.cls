public without sharing class RC_ContractBasicHandler extends TriggerHandler{
  public List<leanx__lg_Contract__c> contractNews;
  public List<leanx__lg_Contract__c> contractOlds;
  public List<leanx__lg_Contract__c> contractUpdate;
  public Map<String,leanx__lg_Contract__c> contractNewMap;
  public Map<String,leanx__lg_Contract__c> contractOldMap;
  public Map<String,leanx__lg_Contract__c> contractUpdateMap;
  public Set<Id> updateConCommentsId;
  public Set<Id> updateConStatusId;
  public Set<Id> updateConShareId;
  public RC_ContractBasicHandler () {
    updateConCommentsId = new Set<Id>();
      updateConStatusId = new Set<Id>();
      updateConShareId = new Set<Id>();
      contractNewMap = new Map<String,leanx__lg_Contract__c>();
      contractOldMap = new Map<String,leanx__lg_Contract__c>();
      contractUpdateMap = new Map<String,leanx__lg_Contract__c>();
      this.contractNews = (List<leanx__lg_Contract__c>) Trigger.new;
      this.contractOlds = (List<leanx__lg_Contract__c>) Trigger.old;
      if(contractOlds !=null){
        for(leanx__lg_Contract__c con : (List<leanx__lg_Contract__c>) Trigger.old){
          contractOldMap.put(con.Id,con);
        }
      }
      if(contractNews !=null){
      for(leanx__lg_Contract__c con : (List<leanx__lg_Contract__c>) Trigger.new){
        contractNewMap.put(con.Id,con);
      }
    }
  }
    public override void beforeInsert() {
        // initApprover();
    }

    public override void beforeUpdate() {
      for(leanx__lg_Contract__c con : contractNews){
        leanx__lg_Contract__c oldcon = new leanx__lg_Contract__c();
        if(contractOldMap.get(con.Id) !=null){
          if(con.Joint_Review_Completed__c == true && oldcon.Joint_Review_Completed__c == false){
            updateConCommentsId.add(con.Id);
          }
          if(con.Review_Status_SOC__c == 'Pending' && oldcon.Review_Status_SOC__c != 'Pending'){
            updateConStatusId.add(con.Id);
          }
          if(con.Actual_Sales__c != oldcon.Actual_Sales__c ){
            updateConShareId.add(con.Id);
          }
        }
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

    // void initApprover () {
    //     Map<String, ApproverInfo> deptApproverMap = new Map<String, ApproverInfo>{
    //         'Sales Dept 1' => new ApproverInfo('Sales Dept 1', null, null, '0051e000000dPvVAAU'),
    //         'Sales Dept 2' => new ApproverInfo('Sales Dept 2', null, null, '0051e000000dPwsAAE'),
    //         'Sales Dept 3' => new ApproverInfo('Sales Dept 3', null, null, '0051e000000dPwsAAE')
    //     };
    //     Map<String, ApproverInfo> typeApproverMap = new Map<String, ApproverInfo>{
    //         'Project_Bid' => new ApproverInfo(null, 'Project_Bid', null, '0051e000000XESzAAO'),
    //         'Project_Non_bid' => new ApproverInfo(null, 'Project_Non_bid', null, '0051e000000XESzAAO'),
    //         'Distribution' => new ApproverInfo(null, 'Distribution', null, '0051e000000dPKFAA2')
    //     };
    //     Set<Id> projectIds = new Set<Id>();
    //     for (leanx__lg_Contract__c contractNew : this.contractNews) {
    //         projectIds.add(contractNew.Project__c);
    //     }

    //     Map<Id, leanx__pm_Project__c> projectMap = new Map<Id, leanx__pm_Project__c>(
    //         [SELECT Id, RecordType.DeveloperName FROM leanx__pm_Project__c WHERE Id IN :projectIds]
    //     );

    //     for (leanx__lg_Contract__c contractNew : this.contractNews) {
    //         String salesDept = contractNew.Sales_Dept__c == null ? 'Sales Dept 1' : contractNew.Sales_Dept__c;
    //         leanx__pm_Project__c project = projectMap.get(Id.valueOf(contractNew.Project__c));
    //         contractNew.Approver_Finance_Dept__c = deptApproverMap.get(salesDept).user;
    //         contractNew.Approver_Legal_Dept__c = '0051e000000XETEAA4';
    //         contractNew.Approver_Legal_Dept2__c = '0051e000000dPvaAAE';
    //         // contractNew.Approver_Logistics_Dept__c = typeApproverMap.get(project.RecordType.DeveloperName).user;
    //         contractNew.Approver_Logistics_Dept__c = '0051e000000XETJAA4';
    //         contractNew.Approver_SOC_Dept__c = typeApproverMap.get(project.RecordType.DeveloperName).user;
    //     }
    // }

    void updateComments () {
      List<String> icontractApproval = system.label.iContract_Approval.split(';');
      if(updateConCommentsId.size()>0){
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
            AND  ProcessDefinitionId IN :icontractApproval 
            ORDER BY CreatedDate DESC limit 1 
        ];
        System.debug('pro.size()-->'+pro.size());
        Set<Id> contractIds = new Set<Id>();
        Set<String> comments = new Set<String>();
        Map<Id,ProcessInstanceStep> maps = new Map<Id,ProcessInstanceStep>();
        Map<Id,Id> mapContracts = new Map<Id,Id>();
        for(ProcessInstance p : pro){    
            for(ProcessInstanceStep ps : p.Steps){       
                contractIds.add(ps.OriginalActorId);
                maps.put(ps.OriginalActorId,ps);
                mapContracts.put(ps.OriginalActorId,p.TargetObjectId);
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
        String ContractFinance;
        String ContractSOC;
        String ContractLogistics;
        String ContractLegal;
        String ContractTechnology;
        
        DateTime ContractFinanceFinishTime;
        DateTime ContractSOCFinishTime;
        DateTime ContractLogisticsFinishTime;
        DateTime ContractLegalFinishTime;
        DateTime ContractTechnologyFinishTime;
        
        String ContractFinanceStatus;
        String ContractSOCStatus;
        String ContractLogisticsStatus;
        String ContractLegalStatus;
        String ContractTechnologyStatus;
        
        List<User> user = [select Id, Profile.Id,Department from User where Id  IN :contractIds];
        for(User u : user){
          ContractFinance ='';
          ContractFinanceFinishTime =null;
          ContractFinanceStatus ='';
          ContractSOC ='';
          ContractSOCFinishTime =null;
          ContractSOCStatus ='';
          ContractLogistics ='';
          ContractLogisticsFinishTime =null;
          ContractLogisticsStatus ='';

          ContractLegal ='';
          ContractLegalFinishTime =null;
          ContractLegalStatus ='';
          ContractTechnology ='';
          ContractTechnologyFinishTime =null;
          ContractTechnologyStatus ='';
          if(mapContracts.get(u.Id) !=null){
          Id conId = mapContracts.get(u.Id);
          leanx__lg_Contract__c contract = contractNewMap.get(conId);
            if(u.ProfileId == Finance || u.Department =='Finance'){
                ContractFinance = maps.get(u.Id).Comments;
                ContractFinanceFinishTime = maps.get(u.Id).CreatedDate;
                ContractFinanceStatus = maps.get(u.Id).StepStatus;

                if(ContractFinance != null) contract.Review_Comment_Finance__c = ContractFinance;
                if(ContractSOCFinishTime != null) contract.Review_Finish_Time_SOC__c = ContractSOCFinishTime;
                if(ContractFinanceStatus != null) contract.Review_Status_Finance__c = ContractFinanceStatus;
            }else if(u.ProfileId == SOC || u.Department =='BMO'){
                ContractSOC = maps.get(u.Id).Comments;
                ContractSOCFinishTime = maps.get(u.Id).CreatedDate;
                ContractSOCStatus = maps.get(u.Id).StepStatus;
                system.debug('SOCID'+u.Id);
                system.debug('SOC评论'+ContractSOC);

                if(ContractSOC != null) contract.Review_Comment_SOC__c =  ContractSOC;
                if(ContractFinanceFinishTime != null) contract.Review_Finish_Time_Finance__c = ContractFinanceFinishTime;
                if(ContractSOCStatus != null) contract.Review_Status_SOC__c = ContractSOCStatus;

            }else if(u.ProfileId == Logistic || u.Department =='Logistic'){
                ContractLogistics = maps.get(u.Id).Comments;
                ContractLogisticsFinishTime = maps.get(u.Id).CreatedDate;
                ContractLogisticsStatus = maps.get(u.Id).StepStatus;

                if(ContractLogistics != null) contract.Review_Comment_Logistics__c = ContractLogistics;
                if(ContractLogisticsFinishTime != null) contract.Review_Finish_Time_Logistics__c = ContractLogisticsFinishTime;
                if(ContractLogisticsStatus != null) contract.Review_Status_Logistics__c = ContractLogisticsStatus;
            }else if(u.ProfileId == Legal || u.Department =='Legal'){
                ContractLegal = maps.get(u.Id).Comments;
                ContractLegalFinishTime = maps.get(u.Id).CreatedDate;
                ContractLegalStatus = maps.get(u.Id).StepStatus;

                if(ContractLegal != null) contract.Review_Comment_Legal__c = ContractLegal;
                if(ContractLegalFinishTime != null) contract.Review_Finish_Time_Legal__c = ContractLegalFinishTime;
                if(ContractLegalStatus != null) contract.Review_Status_Legal__c = ContractLegalStatus;
            }else if(u.ProfileId == Technology || u.Department =='Technical'){
                ContractTechnology = maps.get(u.Id).Comments;
                ContractTechnologyFinishTime = maps.get(u.Id).CreatedDate;
                ContractTechnologyStatus = maps.get(u.Id).StepStatus;

                if(ContractTechnology != null) contract.Review_Comment_Technology__c = ContractTechnology;
                if(ContractTechnologyFinishTime != null) contract.Review_Finish_Time_Technology__c = ContractTechnologyFinishTime;
                if(ContractTechnologyStatus != null) contract.Review_Status_Technology__c = ContractTechnologyStatus;
            }
          }
        }
        system.debug('ContractSOC' + ContractSOC);
        system.debug('ContractFinance' + ContractFinance);
        system.debug('ContractLogistics' + ContractLogistics);
        system.debug('ContractLegal' + ContractLegal);
      }
    }
    
    void updateStatus(){
        this.contractNews[0].Review_Pending_Time_SOC__c = System.now();
    }
    
    void updateShare(){
        
    }
    
    // public class ApproverInfo {
    //     public String salesDept;
    //     public String projectType;
    //     public String businessType;
    //     public Id user;
    //     public ApproverInfo (String salesDept, String projectType, String businessType, Id user) {
    //         this.salesDept = salesDept;
    //         this.projectType = projectType;
    //         this.businessType = businessType;
    //         this.user = user;
    //     }
    // }
}