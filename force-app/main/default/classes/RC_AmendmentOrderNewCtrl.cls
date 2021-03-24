public class RC_AmendmentOrderNewCtrl {
    public String requestId{get;set;} 
    public Agreement__c ord{get;set;}
    
    public RC_AmendmentOrderNewCtrl(ApexPages.StandardController ctrl){
        requestId=ctrl.getid();
        System.debug('requestId---------123>'+requestId);
        ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Agreement__c) + 
                            ' ' +
                            'Where id =: requestId');
    }

    public PageReference Action1(){
        // TODO: 待确认逻辑原因
        String result = '0'; // RC_AorderPrintingTime.HaveUnLockAmend(requestId);
        System.debug('result----->' + result);
        if(result=='0'){
            List<Amendment_Agreement__c> amelst = [select id,Name,Agreement__c,RecordTypeId from Amendment_Agreement__c where Agreement__c=:requestId];
            for(Amendment_Agreement__c a : amelst){
                if(a.RecordTypeId=='0122t00000005sN'){//0120p000000Ympk
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This contract has been terminated !'));
                    return null;
                }
            }
            return new PageReference('/apex/RC_AmendmentOrder?id='+requestId); 
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can not create new amendment until last version finished.'));
            return null;
        }
    }
    public PageReference terminateAgreement(){
        List<Amendment_Agreement__c> amelst = [select id,Name,Agreement__c,RecordTypeId from Amendment_Agreement__c where Agreement__c=:requestId];
        for(Amendment_Agreement__c a : amelst){
            if(a.RecordTypeId=='0122t00000005sN'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This contract has been terminated !'));
                return null;
            }
        }
        
        
        return new PageReference('/apex/RC_AmendmentOrderAgain?id='+requestId);
    }
}