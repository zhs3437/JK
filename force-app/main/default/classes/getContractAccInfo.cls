global class getContractAccInfo {
@AuraEnabled
	webservice static String submit(String ordId){
		if(string.isEmpty(ordId))return 'The record does not exist !';
        
        Order ord = [Select id,Street_Room_Number__c,Account_Title__c,Ledger_Name__c,Sales_Region__c,Phone__c,Account_Owner_Sap_Id__c,Buyer__r.Name,
                     			SELLER__c,Region__c,BillingCountry ,BillingCity,BillingPostalCode ,BillingState ,BillingStreet,Search__c
                       			From Order
                       			Where id =: ordId ];	
        
        if(ord != null){
            ord.Account_Title__c = 'CRM新增客户主数据流程-' + ord.Account_Owner_Sap_Id__c + '-' +String.valueOf(Date.today());
            String address = ord.BillingCountry +' '+ ord.BillingPostalCode +' '+ ord.BillingState+' '+ ord.BillingCity  +' '+ ord.BillingStreet; 
            ord.Street_Room_Number__c = String.valueOf(address).replace('null',' ');
            ord.Search__c = ord.Buyer__r.Name;
            ord.Sales_Region__c = ord.Region__c;
            ord.Ledger_Name__c = ord.SELLER__c;
            update ord;
        }
		return 'ok';
	}
@AuraEnabled
    webservice static String submitOA(String accId){
        if(string.isEmpty(accId))return 'The record does not exist !';
        
        Account  acc= [Select id,Street_Room_Number__c,Title__c,Ledger_Name__c,Sales_Region__c,Phone,Name,OA_UserName__c,Owner.BMO_specialist__r.OA_Use_Id__c,
                                BillingCountry ,BillingCity,BillingPostalCode ,BillingState ,BillingStreet,Search__c,Owner.OA_Use_Id__c,RecordTypeId
                                From Account
                                Where id =: accId ];    
        
        if(acc != null){
            acc.Title__c = 'CRM新增客户主数据流程-' + acc.OA_UserName__c + '-' +String.valueOf(Date.today());
            String address = acc.BillingCountry +' '+ acc.BillingPostalCode +' '+ acc.BillingState+' '+ acc.BillingCity  +' '+ acc.BillingStreet; 
            acc.Street_Room_Number__c = String.valueOf(address).replace('null',' ');
            acc.Search__c = acc.Name;
            if(acc.RecordTypeId == '0126F000001j8SxQAI'){
                acc.OA_UserName__c = acc.Owner.OA_Use_Id__c;
            }else{
                acc.OA_UserName__c = acc.Owner.BMO_specialist__r.OA_Use_Id__c;
            }            
            
            //acc.Sales_Region__c = acc.Sales_Region__c;
            //acc.Ledger_Name__c = ord.SELLER__c;
            update acc;
        }
        return 'ok';
    }
}