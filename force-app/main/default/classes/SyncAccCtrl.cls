public class SyncAccCtrl {
    
    public Account acc {get;set;}
    public String requestId {get;set;}//当前请求订单ID
    public Static Boolean flg {get;set;}
    public Static Boolean isSave {get;set;}
    public Static Boolean isHidden {get;set;}
    Static PageReference page  {get;Set;}
    public SyncAccCtrl(ApexPages.StandardController controller){ 
        requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('=====ID : '+ requestId);
    }
    
    public void modeBasicData(){
        if(requestId != null){ 
            
            acc = [Select id ,Name,
                                Owner.Name,
                                SAP_External_ID__c,
                                OA_External_ID__c,
                                IBAN_Code__c,
                                SWIFT_Code__c,
                                Account_Allocation_Group__c,
                                BillingStreet,
                    billingcountry,
                                billingstate,
                                billingcity,
                                Account_Group__c,
                                Account_Holder__c,
                                Bank_Account__c,
                                Bank_City__c,
                                Bank_Code__c,                                
                                Bank_Country__c,
                                Bank_Name__c,
                                Bank_Region__c,
                                Bank_Street__c,
                                Country__c,
                                SAP_Describe__c,
                                Contract_Currency__c,
                                Distribution_channel__c,
                                Emergency_level__c,
                                Ledger_Name__c,
                                Operate_Type__c,
                                Product_Group__c,
                                Sales_Dept__c,
                                Phone,
                                Sales_Group__c,
                                Sales_Org__c,
                                Sales_Region__c,
                                Search__c,
                                Street_Room_Number__c,
                                CurrencyIsoCode,
                                Subject_Group__c,
                                Taxpayer_Identification_No__c,
                                Title__c,
                                OA_Emergency_level__c,
                                OA_Operate_Type__c,
                                OA_UserName__c,
                                Applicant_Direct_Superior__c,
                                Country_Scope__c,
                                Tax_No__c,
                                BSB_Number__c,
                                CC_No__c,
                                SC_No__c,
                                Routing_Number_ABA__c,
                                GST_Classification_Region__c,
                                VAT_NO__c,
                                Company_Registration_No__c                     
                             From Account 
                             Where Id =: requestId];
	
        }
    }
       
    // Save 
    public PageReference SaveMe(){
        try{
            system.debug('==========Account :' + acc);
            update acc;          
            page = ApexPages.currentPage();
            flg = false;    
            if(String.isEmpty(acc.Title__c) ||  
             String.isEmpty(acc.Subject_Group__c) ||
             String.isEmpty(acc.Search__c) || 
             String.isEmpty(acc.Street_Room_Number__c)|| 
             String.isEmpty(acc.Distribution_channel__c) ||
             String.isEmpty(acc.Product_Group__c) || 
             String.isEmpty(acc.Sales_Region__c) ||  
             String.isEmpty(acc.Sales_Dept__c) || 
             String.isEmpty(acc.Sales_Group__c) ||
             String.isEmpty(acc.Taxpayer_Identification_No__c) ||
             //String.isEmpty(acc.Country_Scope__c) ||
             String.isEmpty(acc.Account_Allocation_Group__c)//||
             //String.isEmpty(acc.Bank_Code__c)||
             //String.isEmpty(acc.Bank_Name__c)
             ){
                flg = true; 
            }else if(String.isEmpty(acc.Country__c)||String.isEmpty(acc.Phone)){
                flg = true;  
            }

            if (flg) {
                system.debug('========acc: '+ acc);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 带有红色标记的字段为必填项，请完善必填项!'));
                return page; 
            }/*else if (acc.Country_Scope__c == '美国'  && String.isEmpty(acc.Routing_Number_ABA__c)) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：美国, 字段 Routing Number ABA 必填 !'));                           
                //return page;
            }else if ((acc.Country_Scope__c == '澳大利亚' || acc.Country_Scope__c  == '新西兰') && String.isEmpty(acc.BSB_Number__c)) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：澳大利亚/新西兰, 字段 BSB Number 必填 !'));                           
                //return page;
            }else if (acc.Country_Scope__c == '英国' && String.isEmpty(acc.SC_No__c)) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：英国, 字段 SC清算号 必填 !'));                           
                //return page;
            }else if (acc.Country_Scope__c == '加拿大' && String.isEmpty(acc.CC_No__c)) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：加拿大, 字段 CC清算号 必填 !'));                           
                //return page;
            }else if (acc.Country_Scope__c == '欧盟' && String.isEmpty(acc.BSB_Number__c)) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：欧盟, 字段 BSB Number 必填 !'));                           
                //return page;
            }else if((acc.Country_Scope__c == '国内' || acc.Country_Scope__c == '通用') && String.isEmpty(acc.SWIFT_Code__c)){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家不分类为：通用或国内, 字段 SWIFT 码 必填 !'));                           
                //return page;
            }*/else{
                return new PageReference('/Apex/SyncAccOutPage');
            }
            
        }catch(TypeException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
            return null;
        }
        
    }

    //Sync
    public void Sync(){
        if(requestId != null ){
            system.debug('==== OA');
            try{
                Account acc = [Select id ,Name,
                                Owner.Name,
                                SAP_External_ID__c,
                                OA_External_ID__c,
                                IBAN_Code__c,
                                SWIFT_Code__c,
                                Account_Allocation_Group__c,
                                BillingStreet,
                                Account_Group__c,
                                Account_Holder__c,
                                Bank_Account__c,
                                Bank_City__c,
                                Bank_Code__c,                                
                                Bank_Country__c,
                                Bank_Name__c,
                                Bank_Region__c,
                                Bank_Street__c,
                                Country__c,
                                SAP_Describe__c,
                                Contract_Currency__c,
                                Distribution_channel__c,
                                Emergency_level__c,
                                Ledger_Name__c,
                                Operate_Type__c,
                                Product_Group__c,
                                Sales_Dept__c,
                                Phone,
                                Sales_Group__c,
                                Sales_Org__c,
                                Sales_Region__c,
                                Search__c,
                                billingcountry,
                                billingstate,
                                billingcity,
                                Street_Room_Number__c,
                                CurrencyIsoCode,
                                Subject_Group__c,
                                Taxpayer_Identification_No__c,
                                Title__c,
                                OA_Emergency_level__c,
                                OA_Operate_Type__c,
                                OA_UserName__c,
                                Applicant_Direct_Superior__c,
                                Country_Scope__c,
                                Tax_No__c,
                                BSB_Number__c,
                                GST_Classification_Region__c,
                                VAT_NO__c,
                                CC_No__c,
                                SC_No__c,
                                Routing_Number_ABA__c,
                                Company_Registration_No__c    
                             From Account 
                             Where Id =: requestId];

                system.debug('==== OA' + acc);  
                              
                    OASync_Acc sa = new OASync_Acc();
                    system.debug('==== OA1');
                 //  system.debug('');
                    sa.generateData(acc);
                    system.debug('==== OA2');
                    sa.sync();
                
                    system.debug('==== OA3'); 

            }catch(TypeException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
            }

        }
    }
    
    
}