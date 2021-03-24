public without sharing  class ProductDetailContractSortCtrl {
    public String requestId {get;set;}
    public String userId {get;set;}
    public List<Product_Detail__c> oppLst{get;set;}
    public String ChangedId{get;set;}
    
    public ProductDetailContractSortCtrl(ApexPages.StandardSetController sd){
        ChangedId = '';
        requestId = ApexPages.currentPage().getParameters().get('id');
        userId    = UserInfo.getUserId();
        oppLst    = new List<Product_Detail__c>();
        oppLst = [Select id,Name,CreatedDate,ChangedNo__c,Battery_Type__c,Guaranteed_Delivery_Date__c,Quantity__c,Unit_Price__c,Product_Name__c,UnitPrice__c,Total_W__c,Certification__c,Junction_Box_Type__c	 from Product_Detail__c where Contract_PO_PI__c=:requestId];
        system.debug('oppLst'+oppLst);
        Integer OppNo = 0;
        for(Product_Detail__c opp:oppLst){
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
        Product_Detail__c o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Product_Detail__c os = oppLst[oppNo-1];
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
        Product_Detail__c o = oppLst[oppNo];
        oppLst.remove(oppNo);
        List<Product_Detail__c> oppRep = new List<Product_Detail__c>();
        oppRep.add(o);
        for(Product_Detail__c opp:oppLst){
            oppRep.add(opp);
        }
        for(integer i =0;i<oppLst.size()-1;i++){
            oppLst.remove(i);
        }
        oppLst = oppRep;
        OppNo = 0;
        for(Product_Detail__c opp:oppLst){
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
        Product_Detail__c o = oppLst[oppNo];
        o.ChangedNo__c = oppDown;
        system.debug('o'+o);
        Product_Detail__c os = oppLst[oppNo+1];
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
        Product_Detail__c o = oppLst[oppNo];
        oppLst.remove(oppNo);
        oppLst.add(o);
        OppNo = 0;
        for(Product_Detail__c opp:oppLst){
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