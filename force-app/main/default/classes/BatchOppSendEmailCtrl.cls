global with sharing class BatchOppSendEmailCtrl {
    global string requestId{get;set;}
    global List<Opportunity> OppLst{
        get{
            DateTime endTimes = dateTime.valueOf('2020-01-01 00:00:00'); 
            return [Select id,name,Earliest_Expected_Delivery_Date__c,Account.name,Owner.name from Opportunity where ownerId=:requestId and stageName!='Closed Won' and stageName!='Closed Lost' and createdtonow__c>90 and Earliest_Expected_Delivery_Date__c != null and createdDate>=:endTimes and RecordTypeId != '0126F0000022Ykj'];
        }
        set;
    }
}