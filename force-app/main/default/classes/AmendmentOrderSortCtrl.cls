public without sharing  class AmendmentOrderSortCtrl {
    public String requestId {get;set;}
    public String userId {get;set;}
    public List<Amendment_Order_Product__c> oppLst{get;set;}
    public String ChangedId{get;set;}
    
    public AmendmentOrderSortCtrl(ApexPages.StandardSetController sd){
        ChangedId = '';
        requestId = ApexPages.currentPage().getParameters().get('id');
        userId    = UserInfo.getUserId();
        oppLst    = new List<Amendment_Order_Product__c>();
        oppLst = [Select id,CreatedDate,ChangedNo__c,Product_Name__c,Quantity__c,Name,UnitPrice__c,Total_MW_Auto__c,TotalPrice_Tax_no_Tran__c,Guaranteed_Delivery_Date__c,SAP_Product_Materiel_No__c,SAPNOcheck__c from Amendment_Order_Product__c where OriginalOrderItem__c=:requestId];
        system.debug('oppLst'+oppLst);
        Integer OppNo = 0;
        for(Amendment_Order_Product__c opp:oppLst){
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
        Amendment_Order_Product__c o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Amendment_Order_Product__c os = oppLst[oppNo-1];
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
        Amendment_Order_Product__c o = oppLst[oppNo];
        oppLst.remove(oppNo);
        List<Amendment_Order_Product__c> oppRep = new List<Amendment_Order_Product__c>();
        oppRep.add(o);
        for(Amendment_Order_Product__c opp:oppLst){
            oppRep.add(opp);
        }
        for(integer i =0;i<oppLst.size()-1;i++){
            oppLst.remove(i);
        }
        oppLst = oppRep;
        OppNo = 0;
        for(Amendment_Order_Product__c opp:oppLst){
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
        Amendment_Order_Product__c o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Amendment_Order_Product__c os = oppLst[oppNo+1];
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
        Amendment_Order_Product__c o = oppLst[oppNo];
        oppLst.remove(oppNo);
        oppLst.add(o);
        OppNo = 0;
        for(Amendment_Order_Product__c opp:oppLst){
                opp.ChangedNo__c = OppNo;
                OppNo = OppNo + 1;
                system.debug('OppNo'+OppNo);
            }
        update oppLst;
    }
    public PageReference doSave(){
        
         return new PageReference('/'+requestId);
          
    }
}