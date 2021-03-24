public without sharing  class AccountSortOppCtrl {
    public String requestId {get;set;}
    public String userId {get;set;}
    public List<Opportunity> oppLst{get;set;}
    public String ChangedId{get;set;}
    
    public AccountSortOppCtrl(ApexPages.StandardSetController sd){
        ChangedId = '';
        requestId = ApexPages.currentPage().getParameters().get('id');
        userId    = UserInfo.getUserId();
        oppLst    = new List<Opportunity>();
        oppLst = [Select id,AccountID,Name,CreatedDate,ChangedNo__c,StageName,CloseDate,Total_MW__c,CurrencyIsoCode,Total_Price__c,
                  LastModifiedDate,Sales_manager_approval__c ,Price_Approval_Status__c ,Owner.Alias from Opportunity where AccountID=:requestId];
        system.debug('oppLst'+oppLst);
        Integer OppNo = 0;
        for(Opportunity opp:oppLst){
                opp.ChangedNo__c = OppNo;
                OppNo = OppNo + 1;
                system.debug('OppNo'+OppNo);
            }
    }
    public void UpDataList(){
        system.debug('oppLst'+oppLst);
        system.debug('AAAAA'+ChangedId);
        if(ChangedId != '0'){
           Integer oppNo = Integer.valueOf(ChangedId);
        system.debug('oppNo'+oppNo);
        Integer oppDown = oppNo - 1;
        Opportunity o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Opportunity os = oppLst[oppNo-1];
        os.ChangedNo__c = oppNo;
        system.debug('os'+os);
        oppLst[oppNo] = os;
        oppLst[oppNo-1] = o;
        update oppLst;
        
        system.debug('oppLst'+oppLst); 
        }else if(ChangedId == '0'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '已经置顶'));
        }
        
    }
    public void TopDataList(){
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        Opportunity o = oppLst[oppNo];
        oppLst.remove(oppNo);
        List<Opportunity> oppRep = new List<Opportunity>();
        oppRep.add(o);
        for(Opportunity opp:oppLst){
            oppRep.add(opp);
        }
        for(integer i =0;i<oppLst.size()-1;i++){
            oppLst.remove(i);
        }
        oppLst = oppRep;
        OppNo = 0;
        for(Opportunity opp:oppLst){
                opp.ChangedNo__c = OppNo;
                OppNo = OppNo + 1;
                system.debug('OppNo'+OppNo);
            }
        update oppLst;
    }
    public void DownDataList(){
        if(Integer.valueOf(ChangedId)!= oppLst.size()-1){
            system.debug('oppLst'+oppLst);
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        system.debug('oppNo'+oppNo);
        Integer oppDown = oppNo + 1;
        Opportunity o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Opportunity os = oppLst[oppNo+1];
        os.ChangedNo__c = oppNo;
        system.debug('os'+os);
        oppLst[oppNo] = os;
        oppLst[oppNo+1] = o;
        update oppLst;
        }else if(Integer.valueOf(ChangedId)== oppLst.size()-1){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '已经置尾'));
        }
        
    }
    public void TailDataList(){
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        Opportunity o = oppLst[oppNo];
        oppLst.remove(oppNo);
        oppLst.add(o);
        OppNo = 0;
        for(Opportunity opp:oppLst){
                opp.ChangedNo__c = OppNo;
                OppNo = OppNo + 1;
                system.debug('OppNo'+OppNo);
            }
        update oppLst;
        integer i =0;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
    }
    public PageReference doSave(){
        
         return new PageReference('/'+requestId);
          
    }
}