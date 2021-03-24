public class ContractTimeCtrl {
    // request Id
    public String requestId{get;set;}
    //
    public String UsedTime1{get;set;}
    public String UsedTime{get;set;}
    public Decimal  UHours{get;set;}
    public Decimal  UMinutes{get;set;}
    public Contract con{get;set;}
            public Opportunity opp{get;set;}
    public boolean flag{get;set;}
    public String text{get;set;}
    public DateTime Nowtime{get;set;}
    public Integer count{get;set;}
    public  List<Id> idLst{get;set;}
    public String RegionHeadEmail {get;set;}
    public User us{get;set;}
    public Id  RegionHeadID   {get;set;}      
    public List<Id> GMIds {get;set;}
    public List<User> userLst {get;set;}
    public String PAD {get;set;}
    public String PID {get;set;}
    public String region {get;set;}
    public ContractTimeCtrl(ApexPages.StandardController ctrl){
        requestId = ApexPages.currentPage().getParameters().get('id');
        idLst   = new List<Id>();
        us      = new User();
         GMIds  = new List<Id>();
        PrintPAPI();
        
            opp = [select id,
               RecordType.Name,
                   Account.credit_good__c,
                   Trade_Term__c,
               Total_Price__c,
               Green_Channel_Approval__c,
               Payment_Term_Description__c,
               Local_Warehouse__c,
               Region__c,
                    Destination_Country__c,
                   vn_fast__c,
               ownerid,
               Total_MW__c,
               Total_Power__c,
               BMO_specialist__r.name,
               Total_Quantity__c,
               Total_Opp_MW__c,
               Total_Opp_Power__c,
               Total_Opp_Price__c,
               Total_Opp_Quantity__c,
               faOpportunity__c,
               Opportunity_Type__c,
               Inventory_Approval_Status__c,
                   Payment_1MW_Approve__c
               from Opportunity 
               where id =: con.Opportunity__c];
            flag=opp.Payment_1MW_Approve__c;
            if(opp.Total_MW__c < 2 && (opp.Region__c=='Middle East&Africa'||opp.Region__c=='MENA'||opp.Region__c=='SSA') && opp.Account.credit_good__c==true){
                flag=true;
            }
            list<Payment__c> relatePayments = [Select Down_Balance_Payment__c, 
                                                       Payment_Term__c, 
                                                       Payment_Method__c,  
                                                       Name, Id,  
                                                       Days__c, 
                                                       CurrencyIsoCode,  
                                                       Precise_Day__c,
                                                       Opp_Trade_Term__c,
                                                       Opportunity__c, 
                                                       Percentage__c,
                                                       Amount__c
                                                       From Payment__c 
                                                       Where Opportunity__c =: con.Opportunity__c];
            text='';
            
             if(opp.Total_MW__c>=1 && opp.Region__c!='Middle East&Africa'&&opp.Region__c!='MENA'&&opp.Region__c!='SSA'&& opp.Region__c!='ROA'){
                                      text=text+'总瓦数大于1MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 1 \n';

            }
            if(opp.Total_MW__c>=5 && (opp.Region__c=='Middle East&Africa'||opp.Region__c=='MENA'||opp.Region__c=='SSA')){
                                      text=text+'总瓦数大于5MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 5 \n';

            }
         if(opp.Total_MW__c>=3 && opp.Region__c.contains('EU')){
                                      text=text+'总瓦数大于3MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 3 \n';

            }
            if(opp.Total_MW__c>=5 && opp.Region__c=='ROA'){
                                      text=text+'总瓦数大于5MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 5 \n';

            }
            if(opp.Trade_Term__c=='FCA'){
                                      text=text+'FCA不执行快速流程 \n Reason of why not fast PAPI procedure: Trade Term = FCA \n';

            }
                    if(relatePayments.size()>0){
                         for(Payment__c p:relatePayments){
                               if(!opp.Region__c.contains('EU')){
                                if(p.Payment_Term__c=='x% OA by LC X days'){
                                    if(p.Days__c>90){
                                      text=text+'Payment Term 选择 x% OA by LC X days时 天数小于等于90天,才是快速流程\n';
                                      text=text+'Reason of why not fast PAPI procedure: Because fast PAPI required LC days must be less or euqal than 90 days\n';
                                                                        }
                                    }
                             if(p.Down_Balance_Payment__c=='Balance Payment'){
                                    if(p.Payment_Method__c=='T/T' || p.Payment_Method__c=='T/T (Balance)'){
                                      text=text+'Balance Payment 选择L/C ,才是快速流程\n';
                                      text=text+'Reason of why not fast PAPI procedure: Balance Payment && T/T(Balance) \n';
                                    }
                                    }
                             
                                if(p.Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                    if(p.Days__c<15){
                                      text=text+'Payment Term 选择 x% DP X days before the BL/Delivery Date时 天数大于等于20天,才是快速流程\n';
                                      text=text+'Reason of why not fast PAPI procedure: Because fast PAPI required BL/Delivery Date days must be greater or euqal than 15 days \n';
                                    }
                                    }
                                if(p.Payment_Term__c=='x% DP X days after the Execution Date'){
                                    if(p.Days__c>5){
                                      text=text+'Payment Term 选择 x% DP X days after the Execution Date时 天数小于等于5天,才是快速流程\n';
                                      text=text+'Reason of why not fast PAPI procedure: Because fast PAPI required after execution date must be less or euqal than 5 days \n';
                                      
                                    }
                                    }
                         }  if(opp.Region__c.contains('EU')){
                             if(p.Down_Balance_Payment__c=='Balance Payment'){
                                    if(p.Payment_Method__c=='T/T' || p.Payment_Method__c=='T/T (Balance)'){
                                      text=text+'Balance Payment 选择L/C ,才是快速流程\n';
                                      text=text+'Reason of why not fast PAPI procedure: Balance Payment && T/T(Balance) \n';
                                    }
                                    }
                         }
                                }
                        }
        
        
        
        
    }
        public PageReference PrintPAPI() {
            PID='0';
            PAD='0';
             con=[Select Id,Name,Get_Final_Approved_Time__c,Contract_Active_Time__c,Used_Time__c,RecordTypeName__c,BMO_Dept__c,CMO_Dept__c,Sales_Dept__c,Finance_Dept__c,Technical_Dept__c,Status,
             Sales_Dept_Finish_Time__c,Technical_Dept_Finish_Time__c,Finance_Dept_Finish_Time__c,LegalRepair__c,Regional_Head_Finish_Time__c,BMO_Dept_Finish_Time__c,Region__c,BMO_Dept_New__c,Get_Final_Approved_Time2__c,
             TechnicalRemindCounts__c,RegionalHeadRemindCounts__c,FinanceRemindCounts__c,BMORemindCounts__c,BMORemindTime__c,FinanceRemindTime__c,RegionalHeadRemindTime__c, SendEmailToBMOTime__c,SendEmailToGMTime__c,SendEmailToTechnicalTime__c,SendToFinanceTime__c,LegalRemindCounts__c,LegalRemindTime__c,SendToLegalTime__c,
             TechnicalRemindTime__c,Opportunity__c,
             BMO_Specialist__c,Legal_Dept__c from Contract where Id =:requestId];
            region=con.Region__c;
           //ROA 是否可以打印PA PI 判断 2018/12/19
           if(con.RecordTypeName__c=='Frame Contract'|| con.RecordTypeName__c=='Production Contract' || con.RecordTypeName__c=='Inventory Contract'){
              system.debug('判断'+pid+pad);
               PID='1';
               if( (con.BMO_Dept__c == 'Approved' || con.BMO_Dept_New__c == 'Approved')&& con.Finance_Dept__c == 'Approved' && con.CMO_Dept__c == 'Approved'&&con.LegalRepair__c==true){
                  PAD='1';
               }
               system.debug('判断'+pid+pad);
           }
        if(con.RecordTypeName__c=='1MW Global Standard Contract'){
              if( ((con.CMO_Dept__c == 'Approved' || con.Sales_Dept__c == 'Approved')&& con.BMO_Dept__c == 'Approved' && con.Region__c != 'Middle East&Africa'&&con.Region__c!='MENA'&&con.Region__c!='SSA') || ( con.BMO_Dept__c == 'Approved'&& (con.Region__c == 'Middle East&Africa'||con.Region__c=='MENA'||con.Region__c=='SSA'))){
                  PAD='1';
                  PID='1';
                  }
               }
             system.debug('判断'+pid+pad);
            return null;
        }
    public PageReference incrementCounter() {
        
        con=[Select Id,Name,Get_Final_Approved_Time__c,Contract_Active_Time__c,Used_Time__c,RecordTypeName__c,BMO_Dept__c,CMO_Dept__c,Sales_Dept__c,Finance_Dept__c,Technical_Dept__c,Status,
             Sales_Dept_Finish_Time__c,Technical_Dept_Finish_Time__c,Finance_Dept_Finish_Time__c,Regional_Head_Finish_Time__c,BMO_Dept_Finish_Time__c,Region__c,BMO_Dept_New__c,Get_Final_Approved_Time2__c,
             TechnicalRemindCounts__c,RegionalHeadRemindCounts__c,FinanceRemindCounts__c,BMORemindCounts__c,BMORemindTime__c,FinanceRemindTime__c,RegionalHeadRemindTime__c, SendEmailToBMOTime__c,SendEmailToGMTime__c,SendEmailToTechnicalTime__c,SendToFinanceTime__c,LegalRemindCounts__c,LegalRemindTime__c,SendToLegalTime__c,
             TechnicalRemindTime__c,
             BMO_Specialist__c,Legal_Dept__c from Contract where Id =:requestId];
           //  
           // 
          
           //  TechnicalRemindTime__c from Contract where Id =:requestId];
       
        if(!String.isEmpty(con.Used_Time__c)){
            UHours = Decimal.valueOf(con.Used_Time__c)/60;
            UHours =UHours.intValue();
            if(UHours==0){
                UMinutes = Decimal.valueOf(con.Used_Time__c);
            }else{
                UMinutes = Decimal.valueOf(con.Used_Time__c) - UHours *60;
            }
            
            UsedTime = 'Contract approval is taking:';
            UsedTime1 = UHours+' hours :'+UMinutes+' minutes';
        }

        if(con.Status=='Activated'){
             Integer UpdateCounts = 0;
             Nowtime = datetime.now();
            if(con.RecordTypeName__c=='Frame Contract'|| con.RecordTypeName__c=='Production Contract' || con.RecordTypeName__c=='Inventory Contract' || con.RecordTypeName__c=='Production & Inventory Contract' || con.RecordTypeName__c=='1MW Australia Contract'){
             if((String.isEmpty(con.BMO_Dept__c) || con.BMO_Dept__c=='Pending') && String.isEmpty(String.valueof(con.BMORemindTime__c)) && String.isNotEmpty(String.valueof(con.SendEmailToBMOTime__c))){
                 DateTime Pasttime = con.SendEmailToBMOTime__c;
                 Pasttime = Pasttime.addHours(4);
                 if(Nowtime > Pasttime){
                  if(String.isNotEmpty(con.BMO_Specialist__c)){
                        idLst.add(con.BMO_Specialist__c);
                        con.BMORemindTime__c = datetime.now();
                        UpdateCounts = UpdateCounts+1;
                    }   
                 } 
                }   
            }
            else{
                 if((String.isEmpty(con.BMO_Dept_New__c) || con.BMO_Dept_New__c=='Pending') && String.isEmpty(String.valueof(con.BMORemindTime__c)) && String.isNotEmpty(String.valueof(con.SendEmailToBMOTime__c))){
                 DateTime Pasttime = con.SendEmailToBMOTime__c;
                 Pasttime = Pasttime.addHours(4);
                 if(Nowtime > Pasttime){
                  if(String.isNotEmpty(con.BMO_Specialist__c)){
                        idLst.add(con.BMO_Specialist__c);
                        con.BMORemindTime__c = datetime.now();
                        UpdateCounts = UpdateCounts+1;
                    }   
                 } 
                }   
            }
            
            if((String.isEmpty(con.CMO_Dept__c)|| con.CMO_Dept__c=='Pending') && String.isEmpty(String.valueof(con.RegionalHeadRemindTime__c))  && String.isNotEmpty(String.valueof(con.SendEmailToGMTime__c))){
                 DateTime Pasttime = con.SendEmailToGMTime__c;
                 Pasttime = Pasttime.addHours(4);
                 if(Nowtime > Pasttime){  
                 for(GroupMember gm : [Select gm.UserOrGroupId 
				      from GroupMember gm 
				      where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='All GM Group')]){
                          system.debug('gm.UserOrGroupId-->'+gm.UserOrGroupId);
						GMIds.add(gm.UserOrGroupId);          
				}      
                     if(GMIds.size()>0){
                           userLst =[Select Id,Region__c from User where Id in:GMIds];
                for(User us :userLst){
                   if(us.Region__c ==con.Region__c){
                    idLst.add(us.Id);
                   con.RegionalHeadRemindTime__c = datetime.now();
                   UpdateCounts = UpdateCounts+1;
                 }
                     }
              
        }
                 
            }   
             }
            if(con.RecordTypeName__c=='Frame Contract'|| con.RecordTypeName__c=='Production Contract' || con.RecordTypeName__c=='Inventory Contract' || con.RecordTypeName__c=='Production & Inventory Contract'){
            if((String.isEmpty(con.Technical_Dept__c)|| con.Technical_Dept__c=='Pending') && String.isEmpty(String.valueof(con.TechnicalRemindTime__c))  && String.isNotEmpty(String.valueof(con.TechnicalRemindTime__c))){
                  DateTime Pasttime = con.SendEmailToBMOTime__c;
                 Pasttime = Pasttime.addHours(4);
                 if(Nowtime > Pasttime){  
                for(GroupMember gm : [Select gm.UserOrGroupId 
                                              from GroupMember gm 
                                              where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Shanghai Technical')])
                {                                
                 system.debug('gm--->'+gm);   
                 idLst.add(gm.UserOrGroupId);     
                 }
                  UpdateCounts = UpdateCounts+1;
                  con.TechnicalRemindTime__c = datetime.now();
             }
            }
            if((String.isEmpty(con.Finance_Dept__c)|| con.Finance_Dept__c=='Pending') && String.isEmpty(String.valueof(con.FinanceRemindTime__c))&& String.isNotEmpty(String.valueof(con.SendToFinanceTime__c))){
                DateTime Pasttime = con.SendToFinanceTime__c;
                 Pasttime = Pasttime.addHours(4);
                 if(Nowtime > Pasttime){           
                for(GroupMember gm : [Select gm.UserOrGroupId 
                                              from GroupMember gm 
                                              where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Finance')])
                   {  
                       system.debug('gm--->'+gm);
                       idLst.add(gm.UserOrGroupId);          
                    }
                      UpdateCounts = UpdateCounts+1;
                     con.FinanceRemindTime__c = datetime.now();
                    }
                   }
            if((String.isEmpty(con.Legal_Dept__c)|| con.Legal_Dept__c=='Pending') && String.isEmpty(String.valueof(con.LegalRemindTime__c))&& String.isNotEmpty(String.valueof(con.SendToLegalTime__c))){
                 DateTime Pasttime = con.SendToLegalTime__c;
                 Pasttime = Pasttime.addHours(36);
                      if(Nowtime > Pasttime){           
                for(User gm : [Select Id,Name
                                              from User
                                              where Name =:'Legal Public'])
                   {  
                       system.debug('gm--->'+gm);
                       idLst.add(gm.Id);          
                    }
                      UpdateCounts = UpdateCounts+1;
                     con.FinanceRemindTime__c = datetime.now();
                    }
                   }
                }
            /**
            if( idLst.size()>0){
                    List<String> email = new List<String>();
                    List<User> usLst =[Select id,Email,Name from User where Id in:idLst]; 
                    if(usLst.size()>0){
                      
                        for(User us : usLst){
                           // SendEmailUtils.sendToSomeOneId(con.Id, us.Id, 'Contract_Review_Mail');
                        }
                        	
                    }
                }
           */
            if(UpdateCounts>0){
                    update con;
                }
        }
        
      
        return null;
    }
    
    public String getCount() {
        return UsedTime;
    }
    
    public String getCount1() {
        return UsedTime1;
    }
    
}