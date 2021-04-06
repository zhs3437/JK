public class OppPriceApprovalCtrl {
    public String requestId{get;set;} 
    Public Opportunity opp{get;set;}
    Public List<Commission_Application__c> CALst{get;set;}
    Public List<Commission_Application__c> CALst1{get;set;}
    Public List<Commission_Application__c> CALst2{get;set;}
    Public List<Commission_Application__c> CALst3{get;set;}
    Public integer CALstnum{get;set;}
    Public integer CALstnum1{get;set;}
    Public integer CALstnum2{get;set;}
    Public integer CALstnum3{get;set;}
    Public Commission_Application__c CA1{get;set;}
    Public Commission_Application__c CA2{get;set;}
    Public Commission_Application__c CA3{get;set;}
    public OppPriceApprovalCtrl(ApexPages.StandardController ctrl){
        requestId=ctrl.getid();
        ID mainid    = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        ID secondid          = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Second').getRecordTypeId();
        ID thirdid     = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Third').getRecordTypeId();
        opp =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                          'Where id =: requestId');
        CALst = new List<Commission_Application__c>();
        CALst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                                          'Where opportunity__c =: requestId');
        CALstnum=CALst.size();
        system.debug(opp.Commision__c+';'+CALstnum);
        CALst1 = new List<Commission_Application__c>();
        CALst2 = new List<Commission_Application__c>();
        CALst3 = new List<Commission_Application__c>();
        CALst1 = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: requestId and RecordTypeid =:mainid order by CreatedDate DESC');
        CALstnum1=CALst1.size();
        CA1=new Commission_Application__c();
        if(CALstnum1>0){
            CA1=CALst1[0];
        }
        CALst2 = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: requestId and RecordTypeid =:secondid order by CreatedDate DESC');
        CALstnum2=CALst2.size();
        CA2=new Commission_Application__c();
        if(CALstnum2>0){
            CA2=CALst2[0];
        }
        CALst3 = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: requestId and RecordTypeid =:thirdid order by CreatedDate DESC');
        CALstnum3=CALst3.size();
        CA3=new Commission_Application__c();
        if(CALstnum3>0){
            CA3=CALst3[0];
        }
        
        
    }
    public void Action1(){ 
        String str= PriceApprove.submit(requestId); 
        if(opp.ApprovalNumbers__c==null){
            opp.ApprovalNumbers__c=1;
        }if(opp.ApprovalNumbers__c!=null){
            opp.ApprovalNumbers__c=opp.ApprovalNumbers__c+1;
        }
        update opp;
        ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.INFO , str));
    }
    public void Action3(){ 
        String str= PriceApprove.submit2NothAisa(requestId); 
        ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.INFO , str));
    }
    public PageReference Action2(){ 
        return    new PageReference('/apex/Commission_Application?id='+requestId+'&num=1'); 
    }
     public PageReference Action4(){ 
        return    new PageReference('/apex/CommissionCheck?id='+requestId); 
    }
     public PageReference Action5(){ 
        return    new PageReference('/apex/Commission_Application2?id='+requestId+'&num=2'); 
    }
     public PageReference Action6(){ 
        return    new PageReference('/apex/Commission_Application3?id='+requestId+'&num=3'); 
    }
}