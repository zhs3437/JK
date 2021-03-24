public class NewProjectCtrl {
    public Opportunity opp { get; set; }
    public id oppids{get ; set;}
    public Project__c pj{get ; set;}
    
        public NewProjectCtrl(ApexPages.standardController std) {
        oppids = ApexPages.currentPage().getParameters().get('id');        
            system.debug('opp'+oppids);
        opp = [Select name,id,Region__c,Account.name,Project__c from opportunity where id=:oppids];
        
    }
    public void getLoginTokenfenxiao(){
        RecordType rt = [Select id,name from RecordType where name=:'Distributions'];
        pj = new Project__c(RecordTypeid=rt.id);
    }
    public void getLoginToken(){
        RecordType rt = [Select id,name from RecordType where name=:'Project'];
        pj = new Project__c(RecordTypeid= rt.id);
    }
    public PageReference save(){
        try{
            insert pj;
        system.debug('pj'+pj);
        opp.Project__c = pj.Id;
        update opp;
        system.debug('opp'+opp.Project__c);
         PageReference r = new PageReference('/apex/OppPriceApproval?id='+oppids);
             return r;
        }catch(Exception ex){
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getDmlMessage(i)));
            }
        }
        return null;
    }
     public PageReference save2(){
         try{
             pj.name = opp.name;
             insert pj;
        opp.Project__c = pj.Id;
        update opp;
          PageReference r = new PageReference('/apex/OppPriceApproval?id='+oppids);
                 system.debug('opp'+opp.Project__c);

             return r;
         }catch(Exception ex){
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getDmlMessage(i)));
            }
        }
         return null;
    }
    public PageReference SaveReturn(){
        if(opp.Project__c==null){
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,'没有选择Project Information'));
            return null;
        }else{
             update opp;
        PageReference r = new PageReference('/apex/OppPriceApproval?id='+oppids);
             return r;
        }
       
    }
    public PageReference openwin(){
        PageReference r = new PageReference('/apex/NewProject?id='+oppids);
        system.debug('111');
        return r;
    }
    public PageReference openwinfenxiao(){
        PageReference r = new PageReference('/apex/NewProjectfenxiao?id='+oppids);
        system.debug('111');
        return r;
    }
    
}