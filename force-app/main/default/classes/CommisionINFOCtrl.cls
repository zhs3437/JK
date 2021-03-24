global with sharing class CommisionINFOCtrl {
    global string requestId{get;set;}
    global List<Commission_Application__c> comm{
        get{
            return [Select id,Address_of_Payee__c,
                    Brief_Record_of_the_Discussion__c,
                    CEO_Approval__c,Commission_Payee_Company__c,
                    Commission_Per_watt__c,
                    Contract_Volume__c,
                   Contract_Unit_price__c,
                    
                    Project_Location_Coutry__c
                    from Commission_Application__c where opportunity__c=:requestId];
        }
        set;
    }
}