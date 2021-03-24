public class AddproductAppCtrl {
    public Opportunity opp { get; set; }
    public Product_Application__c pa{ get; set; }
    public String oppAppName{ get; set; }
    public id oppids{get ; set;}
    public String item{get;set;}
    public List<OpportunityLineItem> oppProList{get;set;}
    public List<Product_Application_Detail__c> paList{get;set;}
    public List<Product_Application_Detail__c> pstockList{get;set;}
    public List<String> paDetailList{get;set;}
    public String deleteID {get;set;}
    public List<Product_Application_Detail__c> pdList{get;set;}
    public String prod{get;set;}
    public String surchText{get;set;}
    public String code{get;set;}
    public List<OpportunityLineItem> oppLineList{ get; set; }
    public AddproductAppCtrl(ApexPages.standardController std) {
                system.debug('deleteID:'+deleteID);

        pdList = new List<Product_Application_Detail__c>();
        paList = [Select id,name,Kucun__c,Fast_Date__c,IsOrNotCheck__c,Module_size__c from Product_Application_Detail__c where Kucun__c = :'New Product'];
        //pstockList = new List<Product_Application_Detail__c>();
        pstockList=[Select id,name,Kucun__c,IsOrNotCheck__c from Product_Application_Detail__c where Kucun__c = :'Stock'];       
        oppids = ApexPages.currentPage().getParameters().get('id');        
        system.debug('opp'+oppids);
        opp = [Select name,id,Region__c,Account.name,currencyisocode,owner.BMO_specialist__c from opportunity where id=:oppids];
        code =opp.currencyisocode;
        pa = new Product_Application__c();
        List<String> proName = new List<String>();
        for(Product_Application_Detail__c pron:pstockList){
            proName.add(pron.name);
        }
        for(integer i=0;i<proName.size();i++){
            if(prod==null){
                prod = proName.get(i);
            }else{
                prod =prod+','+proName.get(i);
            }
            
        }
        oppLineList = [Select id,name,UnitPrice,Main_Type__c,Unit_Price_Without_Commission__c,Quantity,Total_Power_W__c,Total_Price__c,Guaranteed_Delivery_Date__c,Opp_Description__c,ChangedNo__c from OpportunityLineItem where OpportunityId = :oppids];
    }
    
    public PageReference sendMail(){
        if(pdList.size()>0){
             for(Product_Application_Detail__c p:pdList){
                 if(p.Discount__c==null || p.Guaranteed_Delivery_Date__c==null || p.Sales_Price__c==null || p.W__c==null){
                       Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete the content.'));
                return null;
                 }
                 }
            pa = new Product_Application__c();
        pa.Destination_Region__c = opp.Region__c;  
            pa.SOC__c=opp.owner.BMO_specialist__c;
        pa.Account__c = opp.Account.Name;
        pa.Name = opp.name;
        pa.Opportunity__c = oppids;
            pa.currencyisocode=code;
       RecordType rt = [Select id,name from RecordType where name=:'Product' and sobjecttype=:'Product_Application__c'];
        pa.RecordTypeId = rt.Id;
        insert pa;
        system.debug('paList'+paList);
        system.debug('pdList'+pdList);
        for(Product_Application_Detail__c p:pdList){
            p.Product_Application__c = pa.Id;
            p.currencyisocode=code;
        }
        insert pdList;
        
        PageReference r = new PageReference('/' + pa.Id);
        return r;
        }else{
              Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one product'));
                return null;
        }
    }
    
    public PageReference NewProduct(){
        PageReference r = Page.AddProductName;
        return r;
    }
    public PageReference NewStock(){
        PageReference r = Page.AddProductStock;
        return r;
    }
    public PageReference ApplyNext(){
        List<Product_Application_Detail__c> pdsList = new List<Product_Application_Detail__c>();

        system.debug('paList.size'+paList.size());
        for(Integer i = 1 ; i < paList.size()+1 ; i++){
            Product_Application_Detail__c pas = paList[i-1];
            Product_Application_Detail__c p = new Product_Application_Detail__c();
            if(pas.IsOrNotCheck__c == true){
                p.name = pas.Name;
                p.Fast_Date__c =pas.Fast_Date__c;
                p.Module_size__c=pas.Module_size__c;
                system.debug('p'+p);
                system.debug('p'+p);
                pdsList.add(p);
            }
        }
        if(pdsList.size()>0){
           pdList=new List<Product_Application_Detail__c>();
        for(Integer i = 1 ; i < pdsList.size()+1 ; i++){
            Product_Application_Detail__c pas = pdsList[i-1];
            pas.name = pas.Name;
            pas.Request_No__c = i;
            pdList.add(pas);
        }
        PageReference r = Page.AddProductDetail;
        return r;
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one product'));
                return null;
            }
    }
      public PageReference toback(){
        return new PageReference('/apex/AddProductType?id='+opp.id);
    } 
    public PageReference toretrun(){
        return new PageReference('/apex/AddProductname?id='+opp.id);
    }
    
    public void ApplyNextStock(){
       if(pdList.size()>0){
        pa = new Product_Application__c();
        pa.Destination_Region__c = opp.Region__c;
           pa.SOC__c=opp.owner.BMO_specialist__c;
        pa.Account__c = opp.Account.Name;
        pa.Name = opp.name;
        pa.Opportunity__c = oppids;
            RecordType rt = [Select id,name from RecordType where name=:'Stock' and sobjecttype=:'Product_Application__c'];
           pa.RecordTypeId=rt.Id;
        insert pa;
        system.debug('pa.id'+pa.Id);
        List<Product_Application_Detail__c> pdsList = new List<Product_Application_Detail__c>();
        system.debug('paList.size'+pdList.size());
        for(Product_Application_Detail__c pc:pdList){
                 Product_Application_Detail__c p = new Product_Application_Detail__c();
                p.name = pc.Name;
                p.Product_Application__c = pa.id;
                pdsList.add(p);
                system.debug('1'+pdList);
           
        }
        system.debug('pdList'+pdList);
        insert pdsList;
           PriceApprove2.Addproductstock(pa.id);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'The email is sent successfully and the system administrator will add it.Please close the page.'));
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one product'));
            }
    }
    public void DeletePay(){
        system.debug('id:'+deleteID);
        if(deleteID != null && deleteID != ''){
            pdList.remove(Integer.valueOf(deleteID)-1);
        }
        for(Integer i = 1 ; i < pdList.size()+1 ; i++ ){
            Product_Application_Detail__c ao =pdList[i-1];
            ao.Request_No__c=i;
        }
    }
    public void CopyPay(){
        system.debug('id:'+deleteID);
        Product_Application_Detail__c ao = new Product_Application_Detail__c();
        if(deleteID != null && deleteID != ''){
            ao.Name = pdList[Integer.valueOf(deleteID)-1].name;
            pdList.add(ao);
            ao.Request_No__c = pdList.size();
        }
        
    }
    public void NumberSearch(){
        system.debug(surchText);
        if(surchText != ''){
            system.debug('1');
            system.debug('pstockList'+pstockList);
            List<Product_Application_Detail__c> ppList=[Select id,name,Kucun__c,IsOrNotCheck__c from Product_Application_Detail__c where Kucun__c = :'Stock' and name=:surchText];
          
            for(Product_Application_Detail__c newp :ppList){
                  String flag1='0';
                for(Product_Application_Detail__c oldp :pdList){
                    if(oldp.name==newp.name){
                        flag1='1';
                    }
                    }
                if(flag1=='0'){
                      for(Product_Application_Detail__c s:ppList){
                s.IsOrNotCheck__c = true;
                             Product_Application_Detail__c p = new Product_Application_Detail__c();
                p.name = s.Name;
                pdList.add(p);
            }
            for(Product_Application_Detail__c pd:pstockList){
                if(pd.Name == surchText ){
                  pd.IsOrNotCheck__c = true;
                }
            }
                }
            }
          
        }
        if(pstockList.size()<=0){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The product could not be found.'));
        } 
        for(Integer i = 1 ; i < pdList.size()+1 ; i++ ){
            Product_Application_Detail__c ao =pdList[i-1];
            ao.Request_No__c=i;
        }
    }
    public void howManyCheck(){
        system.debug('111');
        for(Product_Application_Detail__c pc:pstockList){
            system.debug('600');
            if(pc.IsOrNotCheck__c == true){
                system.debug('pc'+pc);
                 Product_Application_Detail__c p = new Product_Application_Detail__c();
                p.name = pc.Name;
                   String flag1='0';
                for(Product_Application_Detail__c c:pdList){
                    if(c.name==p.name){
                        flag1='1';
                        pc.IsOrNotCheck__c = false;
                    }
                     }
                if(flag1=='0'){
                    pc.IsOrNotCheck__c = false;
                 pdList.add(p);
                }
                system.debug('1'+pdList);
            }
        }
        for(Integer i = 1 ; i < pdList.size()+1 ; i++ ){
            Product_Application_Detail__c ao =pdList[i-1];
            ao.Request_No__c=i;
        }
    }
}