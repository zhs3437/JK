public class AmendmentOrderNewCtrl {
    public String requestId{get;set;} 
    Public Order ord{get;set;}
    
    public AmendmentOrderNewCtrl(ApexPages.StandardController ctrl){
        requestId=ctrl.getid();
        System.debug('requestId---------123>'+requestId);
        ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                            'Where id =: requestId');
    }
    public PageReference Action1(){
        String result= AorderPrintingTime.HaveUnLockAmend(requestId);
        if(result=='0'){
            List<Amendment__c> amelst = [select id,Name,Order__c,RecordTypeId from Amendment__c where Order__c=:requestId];
            for(Amendment__c a : amelst){
                if(a.RecordTypeId=='0122t00000005sN'){//0120p000000Ympk
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,'This contract has been terminated !'));
                    return null;
                }
            }
            return    new PageReference('/apex/AmendmentOrder?id='+requestId); 
        }else{
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,'You can not create new amendment until last version finished.'));
            return null;
        }
    }
    public PageReference terminateAgreement(){
        List<Amendment__c> amelst = [select id,Name,Order__c,RecordTypeId from Amendment__c where Order__c=:requestId];
        for(Amendment__c a : amelst){
            if(a.RecordTypeId=='0122t00000005sN'){
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR,'This contract has been terminated !'));
                return null;
            }
        }
        
        
        return    new PageReference('/apex/AmendmentOrderAgain?id='+requestId);
    }
}