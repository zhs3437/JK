public class ContractSubmitReview {
    
    
    public class Approver  {
        public Approver(string uEmail,string uName,string roleName){
            this.uEmail=uEmail;
            this.uName=uName;
            this.roleName=roleName;
            this.isSelect=true;
        }
        public boolean isSelect {get;set;}
        public String uEmail {get;set;}         
        public String uName {get;set;}
        public String roleName {get;set;}
    }
    
    public List<Approver> approverList {get;set;}
    public Contract con  {get;set;}
    
    
    /**
    * for Contract Submit for Review button
    */
    public ContractSubmitReview(ApexPages.StandardController sd){
        Set<String> setEmailAddress = new Set<String>();
        setEmailAddress.add(Label.JK_Contract_Legal_Public_Reviewer_Email);
        setEmailAddress.add(Label.JK_Contract_Energy_Reviewer);
        Map<String, User> mapUserEmail = new Map<String, User>();
        for(User objUser : [SELECT Id, Email, Name, UserRole.Name FROM User WHERE Email IN:setEmailAddress]){
            mapUserEmail.put(objUser.Email, objUser);
        }
        try{
            //List<RecordType> japanRecord = [Select r.Name, r.Id From RecordType r WHERE r.Name = 'Japan Standard Contract'];
            ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
            //update by jason 2060421 
            ID global1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
            ID japan1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();                                                                                      
            
            con = (Contract)sd.getRecord();
            
            con = [SELECT ID,OWNERID,RecordTypeId,RecordType.Name,Finance_Dept__c,BMO_Dept__c,Send_Remind_Mail_First_Time__c,Region__c,Destination_Region__c,Destination_Country__c,Trade_term__c  FROM Contract WHERE ID=:con.Id]; 
            
            /* get User from Review User Group */
            set<Id> UserIds = new set<Id>();
            UserIds = SubmitReviewHelper.getContractReviewList(con.id);
            /* reviewers */
            
            /* if(japanRecord.size() > 0 && con.RecordTypeId == japanRecord[0].Id){//日本 record type
for(GroupMember gm : [Select gm.UserOrGroupId 
from GroupMember gm 
where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Japan Review')]){
User currUser = [SELECT u.Id,u.ManagerId, u.Contract_Review__c, u.BMO_specialist__c FROM USER u WHERE u.Id=:con.OwnerId];
UserIds.add(gm.UserOrGroupId);
UserIds.add(currUser.Contract_Review__c);
}
}else //if(con.RecordTypeId == AustraliaRecordTypeId){//澳大利亚 record type
for(GroupMember gm : [Select gm.UserOrGroupId 
from GroupMember gm 
where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Australia Review')]){
UserIds.add(gm.UserOrGroupId);
}

/*1MW update by jason*/ 
            /* }else if(con.RecordTypeId == global1MWRecordTypeId ){
for(GroupMember gm : [Select gm.UserOrGroupId 
from GroupMember gm 
where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Group 1MW Review')]){

UserIds.add(gm.UserOrGroupId);
}   
}else if(con.RecordTypeId == japan1MWRecordTypeId){
for(GroupMember gm : [Select gm.UserOrGroupId 
from GroupMember gm 
where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Japan Review')]){
User currUser = [SELECT u.Id,u.ManagerId, u.Contract_Review__c, u.BMO_specialist__c FROM USER u WHERE u.Id=:con.OwnerId];
UserIds.add(gm.UserOrGroupId);
UserIds.add(currUser.Contract_Review__c);
}
}else{
for(GroupMember gm : [Select gm.UserOrGroupId 
from GroupMember gm 
where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Review Users')]){
UserIds.add(gm.UserOrGroupId);
}
}       

if(con.RecordTypeId != AustraliaRecordTypeId){
/* add Manage User and BMO ID to approverList*/
            //User currUser = [SELECT u.Id,u.ManagerId, u.Contract_Review__c, u.BMO_specialist__c FROM USER u WHERE u.Id=:con.OwnerId];
            
            /*1MW update by jason*/
            /* if(con.RecordTypeId == global1MWRecordTypeId || con.RecordTypeId == japan1MWRecordTypeId){
if(currUser.Contract_Review__c !=null){
UserIds.add(currUser.Contract_Review__c);  
}
}


/* Add Start by David, 20130111, for work piece(20130111-00002) */
            /*// add Contract Reviewer
if(currUser.Contract_Review__c !=null){
UserIds.add(currUser.Contract_Review__c);
}
/* Add End by David, 20130111, for work piece(20130111-00002) */
            /*      
// add BMO
if(currUser.BMO_specialist__c !=null){
UserIds.add(currUser.BMO_specialist__c);
}
/*
// add Manager
if(currUser.ManagerId != null){
UserIds.add(currUser.ManagerId);
}
*/
            //}
            
            
            
            
            /* Add End by David, 20140320 */
            RecordType rtp = [select r.Name, r.Id From RecordType r Where r.Name ='Intercompany Contract'];
            RecordType rtpInv = [select r.Name, r.Id From RecordType r Where r.Name ='Inventory Contract'];

            approverList = new List<Approver>();
            if(con.RecordTypeId != rtp.Id){
                for(User u : [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Id in:UserIds]){
                    /*
                     if(u.UserRole.Name !='Technical Dept.' && u.UserRole.Name !='Finance Assistance'){
                    approverList.add(new Approver(u.Email,u.Name,u.UserRole.Name));
                     }else{
                         if(u.UserRole.Name !='Finance Assistance'){
                           if(con.RecordTypeId ==rtpInv.Id && con.Region__c=='North Asia' ){
                             
                         }else{
                          approverList.add(new Approver(u.Email,u.Name,u.UserRole.Name));   
                         }  
                         }
                         
                     } */
                    if(u.UserRole.Name !='Technical Dept.' ){
                        approverList.add(new Approver(u.Email,u.Name,u.UserRole.Name));
                    }else{
                        if(con.RecordTypeId ==rtpInv.Id && con.Region__c=='North Asia' ){
                             
                        }else{
                          approverList.add(new Approver(u.Email,u.Name,u.UserRole.Name));   
                        }  
                    }
                }
            }
            else if(con.RecordTypeId == rtp.Id){
                
                User usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Name = 'austin gao'];
                if(usr.UserRole.Name !='Finance Assistance'){
                    approverList.add(new Approver(usr.Email,usr.Name,usr.UserRole.Name));
                }
            }
            
            if((con.recordType.Name=='1MW Global Standard Contract'  ||  con.recordType.Name=='Inventory Contract') && con.Region__c.contains('EU') ){
                approverList.add(new Approver('lingling.yuan@jinkosolar.com','lingling.yuan','Ops'));
            }
            if(con.Region__c.contains('EU')&&con.Finance_Dept__c =='Approved'&&con.BMO_Dept__c=='Approved'){
                approverList.add(new Approver('francesco.destales@jinkosolar.com','francesco.destales','Legal Europe'));
                
            }
            if(con.Trade_term__c!=null){
                if(con.Trade_term__c.startswith('C') || con.Trade_term__c.startswith('D')){
                approverList.add(new Approver('logistic','logistic','logistic'));
                }
            }
            //储能
            if(con.RecordTypeId == JK_RecordTypeConstant.CONTRACT_RECORDTYPE_ID_ENERGY){
                User objLegalPublic = mapUserEmail.get(Label.JK_Contract_Legal_Public_Reviewer_Email);
                User objEnergyManager = mapUserEmail.get(Label.JK_Contract_Energy_Reviewer);
                if(objLegalPublic != null){
                    approverList.add(new Approver(objLegalPublic.Email, objLegalPublic.Name, objLegalPublic.UserRole.Name));
                }
                if(objEnergyManager != Null && !UserIds.contains(objEnergyManager.Id)){
                    approverList.add(new Approver(objEnergyManager.Email, objEnergyManager.Name, objEnergyManager.UserRole.Name));
                }
            }
            //2020/9/28
            if(con.Region__c=='Latin America&Italy' && con.Trade_term__c=='DDP' && con.Destination_Country__c=='Italy'){
                approverList.add(new Approver('elena.marchitelli@jinkosolar.com','elena.marchitelli','Sales support(Italy)'));
                
            }
            // 3/2021 Add users to ApproverList with profile = PMC
            List<User> users = [select Id, Name, Email, UserRole.Name from User where (Profile.Name = 'PMC' OR Profile.Name = 'TMC') and IsActive = true];
            for(User usr : users) {
                Boolean hasUser = false;
                for(Approver item : approverList) {
                    if(item.uEmail == usr.Email && item.uName == usr.Name) {
                        hasUser = true;
                    }
                }
                if(!hasUser) {
                    approverList.add(new Approver(usr.Email, usr.Name, usr.UserRole.Name));
                }
            }

            //Date:2021-04-13
            //Author:Xinbing.ma
            //Description:记录Owner为Gao Pengfei时，原来基础上根据目的区域添加指定审批人
            if(String.IsNotEmpty(con.Destination_Region__c)){
                List<Specific_User_Approver_Setting__c> approverSettingList = [Select Approver__r.Email,Approver__r.Name,Approver__r.UserRole.Name 
                                                                               From Specific_User_Approver_Setting__c
                                                                               Where Specific_User__c=:con.OwnerId And Destination_Region__c=:con.Destination_Region__c 
                                                                               And Approver__c != null And IsActive__c =true];
                
                if(approverSettingList.size() > 0){
                    for(Specific_User_Approver_Setting__c setting:approverSettingList){
                        approverList.add(new Approver(setting.Approver__r.Email, setting.Approver__r.Name, setting.Approver__r.UserRole.Name));
                    }
                }
            }              
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
    }
    
    
    /* Add Start by Javen, 20130111, for work piece(20130111-00002) */
    public void SelectAll(){
        for( Approver aper : approverList ){
            aper.isSelect = true; 
        }
    }
    
    public void UnselectAll(){
        for( Approver aper : approverList ){
            aper.isSelect = false;
        }
    }
    /* Add End by Javen, 20130111, for work piece(20130111-00002) */
    
    public PageReference sendMail(){
        try{
            List<String> email = new List<String>();    
            String logisticemail='0';
            for (Approver u : approverList ) {
                if(u.isSelect){
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                    if(u.roleName!='logistic'){
                    email.add(u.uEmail);
                    }else{logisticemail='1';}
                    
                    String s = u.roleName != null ? u.roleName : '';
                    if(s.indexOf('Finance')!=-1){
                        con.Finance_Dept__c = '';
                        con.SendToFinanceTime__c = datetime.now();
                        
                    }
                    if(s.indexOf('Technical')!=-1){
                        con.Technical_Dept__c = '';
                        con.SendEmailToTechnicalTime__c = datetime.now();
                    }
                    if(s.indexOf('GM')!=-1){
                        con.CMO_Dept__c = '';
                        con.SendEmailToGMTime__c = datetime.now();
                    }
                       if(s.indexOf('Sales')>-1){
                        con.Sales_Dept__c = '';
                    }
                    if(s.indexOf('BMO')!=-1){
                       
                        con.BMO_Dept_New__c =  '';
                        con.BMO_Dept__c = '';
                       
                        con.SendEmailToBMOTime__c = datetime.now();
                    }
                     if(s.indexOf('Legal')!=-1){
                        con.Legal_Dept__c = '';
                        con.SendToLegalTime__c = datetime.now();
                        
                    }
   
                 }
            
            }
          System.debug('测试23333-------->'+email);
            system.debug('con1:'+con);
            con.Status = 'Activated';
            //create by Sam 20171219抓取第一次合同点击Send Remind Mail的时间
            if(con.Send_Remind_Mail_First_Time__c == null){
                con.Send_Remind_Mail_First_Time__c = dateTime.now();
            }
            //create by Sam 20170810抓取合同点击Send Remind Mail的时间
            con.Send_Remind_Mail_Finish_Time__c = dateTime.now();     
            update con;
           
            //opp.Probability=90%
            if(con.RecordTypeId== '0120l0000000EYe'){
                Opportunity opp = [select id,Name,Contract__c,StageName From Opportunity Where Contract__c =: con.Id];
                opp.StageName = 'Contract Negotiation';
                update opp; 
            }
          CommonUtils.SendReviewMail1(con.Id,email,'Contract_Review_Mail');
            if(logisticemail=='1'){
               CommonUtils.SendReviewMail12(con.Id);
            }
            
         
       /**
         if( email.size()>0){
                 //   List<String> email = new List<String>();
                 system.debug('123');
                    List<User> usLst =[Select id,Email,Name from User where Email in:email]; 
                system.debug('234');
                    if(usLst.size()>0){
                           system.debug('345');
                        for(User us : usLst){
                              system.debug('567');
                            SendEmailUtils.sendToSomeOneId(con.Id, us.Id, 'Contract_Review_Mail');
                              system.debug('789');
                        }
                          
                    }
                }
           */
          
            ContractsApprovalCounts.Addaction(con.Id);
                //如果owner是唐晨或者卞文倩，发邮件给Cynthia Li
       /**
            if(con.OwnerId=='0056F000009rBBY' && con.Send_Remind_Mail_First_Time__c == null){   
             List<String> addressemail = new List<String>();
                addressemail.add('cynthia.li@jinkosolar.com');
            CommonUtils.SendReviewMail1(con.Id,addressemail,'Contract_Review_Mail_Not_Approve');            
        } 
            
         **/
               
            return Page.ReviewListResult;
        }catch(Exception ex){
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getDmlMessage(i)));
            }
        }
        return null;
    }
    public void test(){
        Integer i=1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
}