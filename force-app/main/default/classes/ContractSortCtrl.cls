public without sharing  class ContractSortCtrl {
    public String requestId {get;set;}
    public String userId {get;set;}
    public List<Contract> conLst{get;set;}
    public String ChangedId{get;set;}
    
    public ContractSortCtrl(ApexPages.StandardSetController sd){
        ChangedId = '';
        requestId = ApexPages.currentPage().getParameters().get('id');
        userId    = UserInfo.getUserId();
        conLst    = new List<Contract>();
        conLst = [Select id,AccountID,Name,CreatedDate,ChangedNo__c,ContractNumber,Contract_NO__c,
                  Total_MW__c,CurrencyIsoCode,Total_Price__c,Status,PO_PI_Date__c,Avg_Price_W__c,Opportunity__c from Contract  where AccountID=:requestId];
        system.debug('conLst'+conLst);
        Integer conNo = 0;
        for(Contract con:conLst){
                con.ChangedNo__c = conNo;
                conNo = conNo + 1;
                system.debug('conNo'+conNo);
            }
    }
    public void UpDataList(){
        system.debug('AAAAA'+ChangedId);
        if(ChangedId != '0'){
           Integer conNo = Integer.valueOf(ChangedId);
        system.debug('conNo'+conNo);
        Integer oppDown = conNo - 1;
        Contract o = conLst[conNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Contract os = conLst[conNo-1];
        os.ChangedNo__c = conNo;
        system.debug('os'+os);
        conLst[conNo] = os;
        conLst[conNo-1] = o;
        update conLst;
        
        system.debug('oppLst'+conLst); 
        }//else if(ChangedId == '0'){
          //  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '已经置顶'));
       // }
        
    }
    public void TopDataList(){
        system.debug('AAAAA'+ChangedId);
        Integer conNo = Integer.valueOf(ChangedId);
        Contract o = conLst[conNo];
        conLst.remove(conNo);
        List<Contract> conRep = new List<Contract>();
        conRep.add(o);
        for(Contract con:conLst){
            conRep.add(con);
        }
        for(integer i =0;i<conLst.size()-1;i++){
            conLst.remove(i);
        }
        conLst = conRep;
        conNo = 0;
        for(Contract con:conLst){
                con.ChangedNo__c = conNo;
                conNo = conNo + 1;
                system.debug('conNo'+conNo);
            }
        update conLst;
    }
    public void DownDataList(){
        if(Integer.valueOf(ChangedId)!= conLst.size()-1){
            system.debug('conLst'+conLst);
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        system.debug('oppNo'+oppNo);
        Integer oppDown = oppNo + 1;
        Contract o = conLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Contract os = conLst[oppNo+1];
        os.ChangedNo__c = oppNo;
        system.debug('os'+os);
        conLst[oppNo] = os;
        conLst[oppNo+1] = o;
        update conLst;
        }//else if(Integer.valueOf(ChangedId)== conLst.size()-1){
          //  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '已经置尾'));
       // }
        
    }
    public void TailDataList(){
        system.debug('AAAAA'+ChangedId);
        Integer conNo = Integer.valueOf(ChangedId);
        Contract o = conLst[conNo];
        conLst.remove(conNo);
        conLst.add(o);
        conNo = 0;
        for(Contract con:conLst){
                con.ChangedNo__c = conNo;
                conNo = conNo + 1;
                system.debug('conNo'+conNo);
            }
        update conLst;
        integer i = 0 ;
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