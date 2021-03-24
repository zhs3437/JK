public class RC_CommissionCheckCtrl {
    public String requestId{get;set;} 
    public String conId{get;set;} 
    //public leanx__lg_Contract__c con{get;set;}
    public leanx__pm_Project__c opp{get;set;}
    
    public List<Commission_Application2__c> CALst{get;set;}
    public List<Commission_Application2__c> CALst1{get;set;}
    public List<Commission_Application2__c> CALst2{get;set;}
    public List<Commission_Application2__c> CALst3{get;set;}
    public integer CALstnum{get;set;}
    public integer CALstnum1{get;set;}
    public integer CALstnum2{get;set;}
    public integer CALstnum3{get;set;}
    public Commission_Application2__c CA1{get;set;}
    public Commission_Application2__c CA2{get;set;}
    public Commission_Application2__c CA3{get;set;}

    public RC_CommissionCheckCtrl() {}

    public RC_CommissionCheckCtrl(ApexPages.StandardController ctrl){
        requestId = ApexPages.currentPage().getParameters().get('id');
        conId = ApexPages.currentPage().getParameters().get('conid');
        /*if(conId == null || conId == ''){
           conId = 'no'; 
        }*/
        ID mainid    = Schema.SObjectType.Commission_Application2__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        ID secondid  = Schema.SObjectType.Commission_Application2__c.getRecordTypeInfosByName().get('Second').getRecordTypeId();
        ID thirdid   = Schema.SObjectType.Commission_Application2__c.getRecordTypeInfosByName().get('Third').getRecordTypeId();                 
        opp =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.leanx__pm_Project__c) + ' ' +
                            'Where id =: requestId');
        CALst = new List<Commission_Application2__c>();
        CALst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application2__c) + ' ' +
                               'Where Project__c =: requestId');
        CALstnum=CALst.size();
        //system.debug(opp.Commision__c+';'+CALstnum);
        CALst1 = new List<Commission_Application2__c>();
        CALst2 = new List<Commission_Application2__c>();
        CALst3 = new List<Commission_Application2__c>();
        CALst1 = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application2__c) + ' ' +
                                'Where Project__c =: requestId and RecordTypeid =:mainid order by CreatedDate DESC');
        CALstnum1=CALst1.size();
        CA1=new Commission_Application2__c();
        if(CALstnum1>0){
            CA1=CALst1[0];
        }
        CALst2 = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application2__c) + ' ' +
                                'Where Project__c =: requestId and RecordTypeid =:secondid order by CreatedDate DESC');
        CALstnum2=CALst2.size();
        CA2=new Commission_Application2__c();
        if(CALstnum2>0){
            CA2=CALst2[0];
        }
        CALst3 = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application2__c) + ' ' +
                                'Where Project__c =: requestId and RecordTypeid =:thirdid order by CreatedDate DESC');
        CALstnum3=CALst3.size();
        CA3=new Commission_Application2__c();
        if(CALstnum3>0){
            CA3=CALst3[0];
        }   
    }
    
    
    public PageReference Action2(){ 
        return    new PageReference('/apex/RC_Commission_Application?id='+requestId+'&num=1&conid='+conId); 
    }
    public PageReference Action4(){ 
        return    new PageReference('/apex/RC_CommissionCheck?id='+requestId); 
    }
    public PageReference Action5(){ 
        return    new PageReference('/apex/RC_Commission_Application2?id='+requestId+'&num=2&conid='+conId); 
    }
    public PageReference Action6(){ 
        return    new PageReference('/apex/RC_Commission_Application3?id='+requestId+'&num=3&conid='+conId); 
    }
}