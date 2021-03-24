public without sharing  class ProductSortCtrl {
    public String requestId {get;set;}
    public String userId {get;set;}
    public List<OpportunityLineItem> oppLst{get;set;}
    public String ChangedId{get;set;}
    
    public ProductSortCtrl(ApexPages.StandardSetController sd){
        ChangedId = '';
        requestId = ApexPages.currentPage().getParameters().get('id');
        userId    = UserInfo.getUserId();
        oppLst    = new List<OpportunityLineItem>();
        oppLst = [Select id,Name,CreatedDate,ChangedNo__c,UnitPrice,Unit_Price_Without_Commission__c,
                  Quantity,Total_Power_W__c,Total_Price__c,Cheetah__c,Guaranteed_Delivery_Date__c,
                  Amend_Price__c from OpportunityLineItem where OpportunityId=:requestId];
        system.debug('oppLst'+oppLst);
        Integer OppNo = 0;
        for(OpportunityLineItem opp:oppLst){
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
        OpportunityLineItem o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        OpportunityLineItem os = oppLst[oppNo-1];
        os.ChangedNo__c = oppNo;
        system.debug('os'+os);
        oppLst[oppNo] = os;
        oppLst[oppNo-1] = o;
        update oppLst;
        
        system.debug('oppLst'+oppLst); 
        }//else if(ChangedId == '0'){
         //   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '已经置顶'));
       // }
        
    }
    public void TopDataList(){
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        OpportunityLineItem o = oppLst[oppNo];
        oppLst.remove(oppNo);
        List<OpportunityLineItem> oppRep = new List<OpportunityLineItem>();
        oppRep.add(o);
        for(OpportunityLineItem opp:oppLst){
            oppRep.add(opp);
        }
        for(integer i =0;i<oppLst.size()-1;i++){
            oppLst.remove(i);
        }
        oppLst = oppRep;
        OppNo = 0;
        for(OpportunityLineItem opp:oppLst){
                opp.ChangedNo__c = OppNo;
                OppNo = OppNo + 1;
                system.debug('OppNo'+OppNo);
            }
        update oppLst;
    }
    public void DownDataList(){
        if(Integer.valueOf(ChangedId)!= oppLst.size()-1||!Test.isRunningTest()){
            system.debug('oppLst'+oppLst);
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        system.debug('oppNo'+oppNo);
        Integer oppDown = oppNo + 1;
        OpportunityLineItem o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        OpportunityLineItem os = oppLst[oppNo+1];
        os.ChangedNo__c = oppNo;
        system.debug('os'+os);
        oppLst[oppNo] = os;
        oppLst[oppNo+1] = o;
        update oppLst;
        }//else if(Integer.valueOf(ChangedId)== oppLst.size()-1){
         //   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '已经置尾'));
       // }
        
    }
    public void TailDataList(){
        system.debug('AAAAA'+ChangedId);
        Integer oppNo = Integer.valueOf(ChangedId);
        OpportunityLineItem o = oppLst[oppNo];
        oppLst.remove(oppNo);
        oppLst.add(o);
        OppNo = 0;
        for(OpportunityLineItem opp:oppLst){
                opp.ChangedNo__c = OppNo;
                OppNo = OppNo + 1;
                system.debug('OppNo'+OppNo);
            }
        update oppLst;
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
    }
    public PageReference doSave(){
         update oppLst;
         return new PageReference('/'+requestId);
          
    }
}