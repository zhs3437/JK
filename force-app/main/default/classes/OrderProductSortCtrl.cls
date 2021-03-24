public without sharing  class OrderProductSortCtrl {
    public String requestId {get;set;}
    public String userId {get;set;}
    public List<OrderItem> oppLst{get;set;}
    public String ChangedId{get;set;}
    
    public OrderProductSortCtrl(ApexPages.StandardSetController sd){
        ChangedId = '';
        requestId = ApexPages.currentPage().getParameters().get('id');
        userId    = UserInfo.getUserId();
        oppLst    = new List<OrderItem>();
        oppLst = [Select id,CreatedDate,ChangedNo__c,Product_Name__c,Quantity,UnitPrice,Total_MW__c,Total_Price__c,Certification__c,Guaranteed_Delivery_Date__c,SAP_Product_Materiel_No__c,Type_of_module__c from OrderItem where OrderID=:requestId];
        system.debug('oppLst'+oppLst);
        Integer OppNo = 0;
        for(OrderItem opp:oppLst){
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
        OrderItem o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        OrderItem os = oppLst[oppNo-1];
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
        OrderItem o = oppLst[oppNo];
        oppLst.remove(oppNo);
        List<OrderItem> oppRep = new List<OrderItem>();
        oppRep.add(o);
        for(OrderItem opp:oppLst){
            oppRep.add(opp);
        }
        for(integer i =0;i<oppLst.size()-1;i++){
            oppLst.remove(i);
        }
        oppLst = oppRep;
        OppNo = 0;
        for(OrderItem opp:oppLst){
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
        OrderItem o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        OrderItem os = oppLst[oppNo+1];
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
        OrderItem o = oppLst[oppNo];
        oppLst.remove(oppNo);
        oppLst.add(o);
        OppNo = 0;
        for(OrderItem opp:oppLst){
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