public class RC_ContractPDFCtrl {
    public String requestId{get;set;}
    public Boolean needHowManyDaysAfterPayment = True;
    
    public RC_ContractPDFCtrl(ApexPages.StandardController ctrl){
        requestId=ctrl.getid();
        
        
        
    }
    
    public PageReference Action30(){
        String result = printPDFError(requestId);
        if (result !='成功'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , result ));
            return null;
        }
        return new PageReference('/apex/RC_DegradedSalesContract?id='+requestId); 
    }
    public PageReference Action40(){
         String result = printPDFError(requestId);
        if (result !='成功'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , result ));
            return null;
        }
        return new PageReference('/apex/RC_EnergyComponentContract?id='+requestId); 
    }
    public PageReference Action50(){
         String result = printPDFError(requestId);
        if (result !='成功'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , result ));
            return null;
        }
        return new PageReference('/apex/RC_EnergyComponentContractSmall?id='+requestId); 
    }
    
    public PageReference Action10(){
         String result = printPDFError(requestId);
        if (result !='成功'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , result ));
            return null;
        }
        return new PageReference('/apex/RC_ComponentSalesContractExport?id='+requestId); 
    }
    public PageReference Action20(){
         String result = printPDFError(requestId);
        if (result !='成功'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , result ));
            return null;
        }
        return new PageReference('/apex/RC_ComponentSalesContract?id='+requestId); 
    }
    public PageReference Action60(){
        this.needHowManyDaysAfterPayment = false;
        String result = printPDFError(requestId);
        if (result !='成功'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , result ));
            return null;
        }
        return new PageReference('/apex/RC_DegradedSalesContractEnglish?id='+requestId); 
    }
    
    public PageReference Cancal(){        
      
        return new PageReference('/'+requestId); 
    }
    public String printPDFError(String conid){
        String result;
        
        leanx__lg_Contract__c con = [SELECT ID,                                        		
                                     leanx__Account__c,
                                     Contract_NO__c,
                                     Seller__c,                                               
                                     Total_Price__c,
                                     Delivery_Point__c,
                                     Account_Contact_Name__c,
                                     Account_Contact_Mobile__c,
                                     leanx__Account__r.SAP_External_ID__c,
                                     How_Many_Days_After_Payment__c,
                                     Destination_Country__c
                                     FROM   leanx__lg_Contract__c
                                     WHERE  ID = :conid 
                                     LIMIT 1];
        Account buyer =[
            SELECT id,
            Name,
            BillingAddress,
            BillingCountry,
            BillingCity,
            BillingState,
            BillingStreet,
            BillingPostalCode,
            Taxpayer_Identification_No__c,
            Fax,
            Phone,
            Bank_Account__c,                        
            Bank_Code__c,
            Bank_Country__c,
            Bank_Name__c,
            Bank_Region__c,
            Bank_Street__c
            FROM   Account       
            WHERE  id = :con.leanx__Account__c Limit 1
        ];
        List<Contact> contactLst = [
            SELECT id,
            Name,
            AccountId
            FROM   Contact
            WHERE  AccountId = : buyer.Id
        ];
        if (contactLst.size()>0) {
            String contactPeople = contactLst[0].Name;
        }
        result = '';
        if(con.Contract_NO__c == null){
            result += '没有合同编号\n';
            
        }
         if(con.Seller__c == null){
            result += '没有选择卖方\n';
            
        }
        if(buyer.Phone == null){
            result += '没有填写买方电话\n';
            
        }
        /*else if(con.Account_Contact_Name__c == null && con.Account_Contact_Mobile__c == null){
            result = '没有填写联系人';
            return result;
        }*/
        if(con.Delivery_Point__c == null){
            result += '没有填写交货地点\n';
        }
        if(con.How_Many_Days_After_Payment__c == null && this.needHowManyDaysAfterPayment != false){
            result += '没有填写付清货款后多少天发货\n';
            
        }
        if(con.Destination_Country__c == null){
            result += '没有填写目的地国家\n';
            
        }
        if(buyer.Bank_Name__c == null){
            result += '没有填写买方银行名称\n';
            
        }
        if(buyer.Bank_Code__c == null){
            result += '没有填写买方银行卡号';
            
        }
        if(result !=''){
            return result;
        }
        
        return '成功';
    }
    
}