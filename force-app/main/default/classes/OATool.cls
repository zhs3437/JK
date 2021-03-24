global class OATool {
    
    global OATool(){}
    
    webservice static void OASync(string ordId){
        if(ordId != null){	
            system.debug('-----Sync OA : ' + ordId);
            /*
             Account acc = [Select id,Name,SAP_External_ID__c,IBAN_Code__c,SWIFT_Code__c,Account_Allocation_Group__c,
                       Account_Group__c,Account_Holder__c,Bank_Account__c,Bank_City__c,Bank_Code__c,
                       Bank_Country__c,Bank_Name__c,Bank_Region__c,Bank_Street__c,Contract_Currency__c,
                       Country__c,Owner.SAP_User_ID__c,Distribution_channel__c,Emergency_level__c,
                       Ledger_Name__c,Operate_Type__c,Owner.Name,Phone,Product_Group__c,Sales_Dept__c,
                       Sales_Group__c,Sales_Org__c,Sales_Region__c,Search__c,Street_Room_Number__c,CurrencyIsoCode,
                       Subject_Group__c,Taxpayer_Identification_No__c,Title__c,OA_Emergency_level__c,OA_Operate_Type__c
                       From Account Where id =: accountId ];
            */
           Order ord = [Select id ,SAP_External_ID__c,IBAN_Code__c,SWIFT_Code__c,Account_Allocation_Group__c,
                       Account_Group__c,Account_Holder__c,Bank_Account__c,Bank_City__c,Bank_Code__c,Contract_Owner__r.Name,
                       Bank_Country__c,Bank_Name__c,Bank_Region__c,Bank_Street__c,Buyer__r.Country__c,Contract_Owner__c,
                       Distribution_channel__c,Emergency_level__c,Account_Owner_Sap_Id__c,Buyer__r.Name,
                       Ledger_Name__c,Operate_Type__c,Product_Group__c,Sales_Dept__c,Buyer__r.Phone,
                       Sales_Group__c,Sales_Org__c,Sales_Region__c,Search__c,Street_Room_Number__c,CurrencyIsoCode,
                       Subject_Group__c,Taxpayer_Identification_No__c,Account_Title__c,OA_Emergency_level__c,OA_Operate_Type__c
                       From Order Where id =: ordId];         
           OASync_Account sa = new OASync_Account();
           sa.generateData(ord);
           sa.sync();
           system.debug('-----Sync OA End : ');
        }
    } 
}