global with sharing class PowerbookProductCtrl {
global String requestId{get;set;}
global List<PowerProduct__c> ppList {get{
            return [select Product__r.name,Unit_Price__c,Quantity__c,Total_W__c,Certification__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                    Guaranteed_Delivery_Date_japan__c
			from PowerProduct__c
			where Powerbooked__c=:requestId
			];
        }
        set;
    }   
    
}