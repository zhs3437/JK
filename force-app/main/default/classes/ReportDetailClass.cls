public class ReportDetailClass {
    public String numbert{get;set;}
    public String mark{get;set;}
     public integer num{get;set;}
   public String Relateditems{get;set;}
   public String Username{get;set;}
   public report_detail__c rd{get;set;}
   public List<Opinion__c> opList{get;set;}
   public String deleteID{get;set;}
    public ReportDetailClass(ApexPages.StandardController sd){
            mark = ApexPages.currentPage().getParameters().get('tp');
        numbert = ApexPages.currentPage().getParameters().get('num');
         num=integer.valueOf(numbert);
        if(mark=='SAP'){
            Relateditems='ERP(SAP) System';
        }
        if(mark=='OA'){
            Relateditems='OA System';
        }
        if(mark=='Concur'){
            Relateditems='Concur System';
        }
        if(mark=='Cloud'){
            Relateditems='Cloud disk';
        }
        if(mark=='CRM'){
            Relateditems='CRM System';
        }
        Username=UserInfo.getName();
        List<report_detail__c> olddate =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.report_detail__c) + ' ' +
                                  'Where name =: Username');
        if(olddate.size()>0){
            rd=olddate[0];
            opList=new List<Opinion__c>();
            String id=olddate[0].id;
            boolean f=false;
            oplist=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opinion__c) + ' ' +
                                  'Where report_detail__c =: id and Related_items__c=:Relateditems and  number__c=:num and isdelete__c=:f');
            if(oplist.size()==0){
                    opList=new List<Opinion__c>();
            }
            
        }else{
            rd= new report_detail__c();
            opList=new List<Opinion__c>();
        }
        
    }
    public void addPayment(){
        opList.add(new Opinion__c(Related_items__c=Relateditems,number__c=num));
                for(Integer i = 1 ; i < opList.size()+1 ; i++ ){
            Opinion__c ao =opList[i-1];
            ao.Request_No__c=i;
        }
    }
    public void SelectDailyDetail(){
                rd.name=Username;
                upsert rd;
        for(Opinion__c op:opList){
            if(op.report_detail__c==null){
                op.Name=String.valueOf(date.today());
            op.report_detail__c=rd.id;
                }
        }
    upsert opList;

        

    }
    
    public void DeletePay(){
        system.debug('id:'+deleteID);
        if(deleteID != null && deleteID != ''){
            Opinion__c op=opList[Integer.valueOf(deleteID)-1];
            op.isdelete__c=true;
            if(op.report_detail__c!=null){
                 upsert op;
                }
           
            
            opList.remove(Integer.valueOf(deleteID)-1);
        }
        for(Integer i = 1 ; i < opList.size()+1 ; i++ ){
            Opinion__c ao =opList[i-1];
            ao.Request_No__c=i;
        }
    }
}