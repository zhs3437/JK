public class SyncAccountCtrl {
    
    public Order ord {get;set;}
    public String requestId {get;set;}//当前请求订单ID
    public Static Boolean flg {get;set;}
    public Static Boolean isSave {get;set;}
    public Static Boolean isHidden {get;set;}
    Static PageReference page  {get;Set;}
    public SyncAccountCtrl(ApexPages.StandardController controller){ 
        requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('=====ID : '+ requestId);
    }
    
    public void modeBasicData(){
        if(requestId != null){
            //order = Database.query( Utils.MakeSelectSql('Order')+' WHERE Id =: requestId');
            ord = [Select id ,SAP_External_ID__c,IBAN_Code__c,SWIFT_Code__c,Account_Allocation_Group__c,BillingStreet,
                     Account_Group__c,Account_Holder__c,Bank_Account__c,Bank_City__c,Bank_Code__c,OA_External_ID__c,
                     Bank_Country__c,Bank_Name__c,Bank_Region__c,Bank_Street__c,Buyer__r.Country__c,SAP_Describe__c,
                     Distribution_channel__c,Emergency_level__c,Account_Owner_Sap_Id__c,Buyer__r.Name,SELLER__c,Contract_Owner__c,
                     Ledger_Name__c,Operate_Type__c,Product_Group__c,Sales_Dept__c,Buyer__r.Phone,Region__c,Contract_Owner__r.Name,
                     Sales_Group__c,Sales_Org__c,Sales_Region__c,Search__c,Street_Room_Number__c,CurrencyIsoCode,
                     Subject_Group__c,Taxpayer_Identification_No__c,Account_Title__c,OA_Emergency_level__c,OA_Operate_Type__c,Account.Name,Account.Registration_No__c,Account.VAT_NO__c,
                     Applicant_Direct_Superior__c,Country_Scope__c,Tax_No__c,BSB_Number__c,Destination_Country__c,GST_Classification_Region__c,VAT_NO__c,CC_No__c,SC_No__c,Routing_Number_ABA__c,Company_Registration_No__c
                     From Order 
                     Where Id =: requestId];
            ord.Sales_Dept__c='1000 业务部';
            ord.Product_Group__c ='30 组件';
            if(ord.Sales_Region__c=='EU(Union)'){
                ord.Sales_Group__c = 'EU';
            }else if(ord.Sales_Region__c=='EU(Non-Eu)'){
              ord.Sales_Group__c = 'Non EU';  
            }else{
                ord.Sales_Group__c = ord.Sales_Region__c;
            }
            
            String AccountName = ord.Account.Name;
             AccountName=AccountName.toLowerCase();
            String otherAccountName =  ord.Account.Name;
            if(ord.Account.Registration_No__c !=null && ord.Account.VAT_NO__c==null){
               ord.Taxpayer_Identification_No__c = ord.Account.Registration_No__c;                
            }else if(ord.Account.Registration_No__c ==null && ord.Account.VAT_NO__c!=null){
                 ord.Taxpayer_Identification_No__c = ord.Account.VAT_NO__c; 
            }else if(ord.Account.Registration_No__c !=null && ord.Account.VAT_NO__c!=null){
                 ord.Taxpayer_Identification_No__c = ord.Account.Registration_No__c; 
            }
            if(ord.SELLER__c =='JinkoSolar (Switzerland) AG' && ord.Destination_Country__c=='Switzerland'){
               CheckAccount(AccountName,ord);
            }
            else if((ord.SELLER__c =='JinkoSolar (U.S.) Inc.')&& ord.Destination_Country__c=='America'){
             CheckAccount(AccountName,ord);
            }
              else if(ord.SELLER__c =='JinkoSolar GmbH' && ord.Destination_Country__c=='Germany'){
               CheckAccount(AccountName,ord);
            }
            else if(ord.SELLER__c =='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && ord.Destination_Country__c=='Australia'){
               CheckAccount(AccountName,ord);
            }
             else if(ord.SELLER__c =='JinkoSolar(ITALIA)S.R.L.' && ord.Destination_Country__c=='Italy'){
               CheckAccount(AccountName,ord);
            }
             else if((ord.SELLER__c =='JINKOSOLAR (PTY) LTD' || ord.SELLER__c =='JINKOSOLAR TRADING PRIVATE LIMITED') && ord.Destination_Country__c=='India'){
               CheckAccount(AccountName,ord);
            }
              else if(ord.SELLER__c =='JinkoSolar Canada Co., Ltd.' && ord.Destination_Country__c=='Canada'){
               CheckAccount(AccountName,ord);
            }
               else if(ord.SELLER__c =='ジンコソーラージャパン株式会社' && ord.Destination_Country__c=='Japan'){
               CheckAccount(AccountName,ord);
            }
                else if(ord.SELLER__c =='PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA.' && ord.Destination_Country__c=='Portugal'){
               CheckAccount(AccountName,ord);
            }
             else if(ord.SELLER__c =='JINKO SOLAR TECHNOLOGY SDN.BHD.' && ord.Destination_Country__c=='Malaysia'){
               CheckAccount(AccountName,ord);
            }
            
             else if((ord.SELLER__c =='ZHEJIANG JINKO SOLAR CO.,LTD' || ord.SELLER__c =='Jinko Solar Co., Ltd.' || ord.SELLER__c =='Jinko Solar Import and Export Co., Ltd.'|| 
                      ord.SELLER__c =='JinkoSolar International Limited'|| ord.SELLER__c =='JINKOSOLAR TECHNOLOGY LIMITED')&& 
                     (ord.Destination_Country__c=='China'|| ord.Destination_Country__c=='Hong Kong'||ord.Destination_Country__c=='Taiwan') ){
               CheckAccount(AccountName,ord);
            }
            else{
               if(ord.Account.Name=='ジンコソーラージャパン株式会社' || AccountName.indexof('jinko')>-1 || ord.Account.Name=='PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA.' ){
                    ord.Subject_Group__c ='Z100 关联公司客户';
                    ord.Distribution_channel__c ='20 外销-集团内';
                    ord.Account_Allocation_Group__c ='03 关联方-国外收入';
                }else {
                     ord.Subject_Group__c ='Z002 国外客户';
                    ord.Distribution_channel__c ='10 外销-集团外';
                    ord.Account_Allocation_Group__c ='04 非关联方-国外收入';
                }  
            }
        }
    }
    
    //checkAccount country
    public void CheckAccount(String AccountName,Order ord){
         if(ord.Account.Name=='ジンコソーラージャパン株式会社' || AccountName.indexof('jinko')>-1 || ord.Account.Name=='PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA.' ){
                    ord.Subject_Group__c ='Z100 关联公司客户';
                    ord.Distribution_channel__c ='40 内销-集团内';
                    ord.Account_Allocation_Group__c ='01 关联方-国内收入';
                }else {
                     ord.Subject_Group__c ='Z001 国内客户';
                    ord.Distribution_channel__c ='30 内销-集团外';
                    ord.Account_Allocation_Group__c ='02 非关联方-国内收入';
                }
    }
       
    // Save 
    public PageReference SaveMe(){
        try{
            isSave = false;
            flg = false;
            isHidden = true;
            page = ApexPages.currentPage();
            update ord;
            
            if(String.isEmpty(ord.Account_Title__c) || 
                String.isEmpty(ord.Ledger_Name__c) ||  
                String.isEmpty(ord.Subject_Group__c) || 
                String.isEmpty(ord.Search__c) || 
                String.isEmpty(ord.Street_Room_Number__c) || 
                String.isEmpty(ord.Distribution_channel__c) || 
                String.isEmpty(ord.Product_Group__c) || 
                String.isEmpty(ord.Sales_Region__c) ||
                //String.isEmpty(ord.Country_Scope__c) ||
                String.isEmpty(ord.Sales_Dept__c) || 
                String.isEmpty(ord.Sales_Group__c) || 
                String.isEmpty(ord.Taxpayer_Identification_No__c) || 
                String.isEmpty(ord.Account_Allocation_Group__c) //||
               // String.isEmpty(ord.Bank_Code__c)||
              	//String.isEmpty(ord.Bank_Name__c)
                ){
                flg = true;
            }else if(String.isEmpty(ord.Buyer__r.Country__c)|| String.isEmpty(ord.Buyer__r.Phone )){
                flg = true;
            }

            if(flg){    
                System.debug('====Ord:' + ord);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 有红色标记的字段为必填字段，请完善必填字段!'));                           
                return page;                
            }/*else if (ord.Country_Scope__c == '美国'  && String.isEmpty(ord.Routing_Number_ABA__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：美国, 字段 Routing Number ABA 必填 !'));                           
                return page;
            }else if ((ord.Country_Scope__c == '澳大利亚' || ord.Country_Scope__c  == '新西兰') && String.isEmpty(ord.BSB_Number__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：澳大利亚/新西兰, 字段 BSB Number 必填 !'));                           
                return page;
            }else if (ord.Country_Scope__c == '英国' && String.isEmpty(ord.SC_No__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：英国, 字段 SC清算号 必填 !'));                           
                return page;
            }else if (ord.Country_Scope__c == '加拿大' && String.isEmpty(ord.CC_No__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：加拿大, 字段 CC清算号 必填 !'));                           
                return page;
            }else if (ord.Country_Scope__c == '欧盟' && String.isEmpty(ord.BSB_Number__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家分类为：欧盟, 字段 BSB Number 必填 !'));                           
                return page;
            }else if((ord.Country_Scope__c == '国内' || ord.Country_Scope__c == '通用') && String.isEmpty(ord.SWIFT_Code__c)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Message : 国家不分类为：通用或国内, 字段 SWIFT 码 必填 !'));                           
                return page;
            }*/else{
                system.debug('====order: ' + ord.Buyer__c);
                Account acc = [Select Id,Ledger_Name__c,BillingStreet,Street_Room_Number__c From Account Where id =: ord.Buyer__c];// Database.query( Utils.MakeSelectSql('Account')+' WHERE Id =: '+ord.Buyer__c);
                system.debug('=====Acc: ' + acc);
                Account AccNew = updateAcc(acc);                
                update AccNew;   
                isSave = true;
                return new PageReference('/Apex/SyncAccountOutPage');
            }
            
            
        }catch(TypeException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
            return null;
        }
        
    }
    // Cancel
    /*
public PageReference Cancel(){	        
return new PageReference('/'+requestId);
}
*/    
    //Sync
    public void Sync(){
        if(requestId != null ){
            
            system.debug('==== OA');
            try{
                Order ord = [Select id ,SAP_External_ID__c,IBAN_Code__c,SWIFT_Code__c,Account_Allocation_Group__c,BillingStreet,
                     Account_Group__c,Account_Holder__c,Bank_Account__c,Bank_City__c,Bank_Code__c,OA_External_ID__c,
                     Bank_Country__c,Bank_Name__c,Bank_Region__c,Bank_Street__c,Buyer__r.Country__c,SAP_Describe__c,
                     Distribution_channel__c,Emergency_level__c,Account_Owner_Sap_Id__c,Buyer__r.Name,SELLER__c,Contract_Owner__r.Name,
                     Ledger_Name__c,Operate_Type__c,Product_Group__c,Sales_Dept__c,Buyer__r.Phone,Region__c,Contract_Owner__c,
                     Sales_Group__c,Sales_Org__c,Sales_Region__c,Search__c,Street_Room_Number__c,CurrencyIsoCode,
                     Subject_Group__c,Taxpayer_Identification_No__c,Account_Title__c,OA_Emergency_level__c,OA_Operate_Type__c,
                     Applicant_Direct_Superior__c,Country_Scope__c,Tax_No__c,BSB_Number__c,Destination_Country__c,GST_Classification_Region__c,VAT_NO__c,CC_No__c,SC_No__c,Routing_Number_ABA__c,Company_Registration_No__c
                     From Order 
                     Where Id =: requestId];
                system.debug('==== OA' + ord);                 
                    OASync_Account sa = new OASync_Account();
                    system.debug('==== OA1');
                    sa.generateData(ord);
                    system.debug('==== OA2');
                    sa.sync();
                    system.debug('==== OA3'); 
            }catch(TypeException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
            }
        }
    }
    
    public Account updateAcc(Account acc){
        if(String.isEmpty(acc.BillingStreet)){
            acc.BillingStreet = acc.Street_Room_Number__c;
        }
        //acc.OA_External_ID__c							= order.OA_External_ID__c;
        //acc.SAP_Describe__c							= order.SAP_Describe__c;                
        //acc.SAP_External_ID__c						= order.SAP_External_ID__c;
        acc.IBAN_Code__c							= ord.IBAN_Code__c;
        acc.SWIFT_Code__c							= ord.SWIFT_Code__c;
        acc.Account_Allocation_Group__c				= ord.Account_Allocation_Group__c;
        acc.Account_Group__c						= ord.Account_Group__c;
        acc.Account_Holder__c						= ord.Account_Holder__c;
        acc.Bank_Account__c							= ord.Bank_Account__c;
        acc.Bank_City__c							= ord.Bank_City__c;
        acc.Bank_Code__c							= ord.Bank_Code__c;
        acc.Bank_Country__c							= ord.Bank_Country__c;
        acc.Bank_Name__c							= ord.Bank_Name__c;
        acc.Bank_Region__c							= ord.Bank_Region__c;
        acc.Bank_Street__c							= ord.Bank_Street__c;
        //acc.Country__c								= ord.;
        //acc.Owner.SAP_User_ID__c;
        acc.Distribution_channel__c					= ord.Distribution_channel__c;
        acc.Emergency_level__c						= ord.Emergency_level__c;
        acc.Ledger_Name__c							= ord.Ledger_Name__c;
        //acc.Operate_Type__c;
        //acc.Phone									= ord;
        acc.Product_Group__c						= ord.Product_Group__c;
        acc.Sales_Dept__c							= ord.Sales_Dept__c;
        acc.Sales_Group__c							= ord.Sales_Group__c;
        acc.Sales_Org__c							= ord.Sales_Org__c;
        acc.Sales_Region__c							= ord.Sales_Region__c;
        acc.Search__c								= ord.Search__c;
        acc.Street_Room_Number__c					= ord.Street_Room_Number__c;
        acc.Subject_Group__c						= ord.Subject_Group__c;
        acc.Taxpayer_Identification_No__c 			= ord.Taxpayer_Identification_No__c;
        acc.Title__c 								= ord.Account_Title__c;
        //acc.Applicant_Direct_Superior__c            = ord.Applicant_Direct_Superior__c;
        acc.Country_Scope__c                        = ord.Country_Scope__c;
        acc.Tax_No__c                               = ord.Tax_No__c;                              
        acc.BSB_Number__c                           = ord.BSB_Number__c;
        acc.CC_No__c                                = ord.CC_No__c;
        acc.SC_No__c                                = ord.SC_No__c;
        acc.Routing_Number_ABA__c                   = ord.Routing_Number_ABA__c;
        acc.Company_Registration_No__c              = ord.Company_Registration_No__c; 

        return acc;
    }
    
}