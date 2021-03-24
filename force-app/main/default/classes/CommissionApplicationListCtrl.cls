public class CommissionApplicationListCtrl {
    public Commission_Application__c ca{get;set;}  
    public List<Commission_Application__c> calst{get;set;}  
    public String requestId{get;set;} 
    public opportunity opportunity{get;set;}
    Public String num{get;set;}
    
    
    public CommissionApplicationListCtrl(ApexPages.StandardController ctrl){
        requestId=ctrl.getid();
  ID mainid    = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        ID secondid          = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Second').getRecordTypeId();
        ID thirdid     = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Third').getRecordTypeId();        
        calst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where id =: requestId order by CreatedDate DESC');
        String oppid =calst[0].opportunity__c;
        opportunity=[select id,Account.name,Total_MW__c,
                     Trade_Term__c,Total_Price__c
                     from opportunity
                     Where id =: oppid];
        if(calst.size()==0){
            ca =new Commission_Application__c();
            ca.opportunity__c=ctrl.getid();
        }else if(calst.size()==1){
            ca=calst[0];
            if(ca.RecordTypeid==mainid){num='1';}
            if(ca.RecordTypeid==secondid){num='2';}
            if(ca.RecordTypeid==thirdid){num='3';}
        }
    }
   
}