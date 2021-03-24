public class PIJapan { 
    public contract con{get;set;}
    public String Description{get;set;}
    public String DescriptionE{get;set;}
    public date now{get;set;}
    public String sellerAdress{get;set;}
    public String sellerTeL{get;set;}
    public String sell{get;set;}
    public String TRADETERM{get;set;}
    public String TRADETERMJP{get;set;}
    public String Currcy{get;set;}
    public String CurrcyJP{get;set;}
    public List<Product_Detail__c> pds{get;set;}
    public integer Nonumber{get;set;}
        public integer Year2{get;set;}
    public integer Month2{get;set;}
    public integer Day2{get;set;}
    public integer Year1{get;set;}
    public integer Month1{get;set;}
    public integer Day1{get;set;}
    public integer Year{get;set;}
    public integer Month{get;set;}
    public integer Day{get;set;}
    public boolean car1{get;set;}
    public boolean car2{get;set;}
    public boolean car3{get;set;}
    public boolean car4{get;set;}
    public boolean car5{get;set;}
    public boolean scar1{get;set;}
    public boolean scar2{get;set;}
    public String viewId{get;set;}
    public String newPaymentTerm{get;set;}
    public String newPy{get;set;}
    public PIJapan(ApexPages.StandardController controller) {
        system.debug('newPy'+newPy);
        viewId=((Contract)controller.getRecord()).Id;
        now = Date.today();
        Day= now.day();
        Month= now.month();
        Year= now.year();
        con = (Contract)[select id,
                         ContractNumber,
                         Name,
                         Status,
                         BuyerAccount__r.BillingCountry,
                         BuyerAccount__r.BillingState,
                         BuyerAccount__r.BillingCity,
                         BuyerAccount__r.BillingStreet,
                         Factory__c,
                         CurrencyIsoCode,
                         Supply_By__c,
                         Destination_port2__c,
                         Governing_Law_FOR_ROA__c,
                         OwnerId,
                         Contact_Name__c,
                         Owner.BMO_specialist__c,
                         Destination__c,
                         Opportunity__c,
                         Region__c,
                         Common_Truck_Type__c,
                         Destination_Country__c,
                         Warranty_Insurance__c,
                         LegalRepair__c,
                         PaymentTermStand__c,
                         ISFOB__c ,
                         Delivery_Date__c,
                         PA_Date__c,
                         Warranty_On_Material_and_Workmanship__c,
                         Delivery_point__c,
                         Buyer_Letter_of_guarantee__c,
                         SELLER__c,
                         SpecialPaymentTerm__c,
                         Payment_Term_Description__c,
                         RecordTypeName__c,
                         Special_Truck_Type__c,
                         Return_Deadline_of_Signed__c,
                         Trade_term__c
                         from Contract
                         where id =:controller.getId()]; 
        system.debug('con'+con.PaymentTermStand__c);
        if(con.Delivery_Date__c!=null){
        Day2= con.Delivery_Date__c.day();
        Month2= con.Delivery_Date__c.month();
        Year2= con.Delivery_Date__c.year();
        }
        if(con.Return_Deadline_of_Signed__c!=null){
            Day1= con.Return_Deadline_of_Signed__c.day();
            Month1= con.Return_Deadline_of_Signed__c.month();
            Year1= con.Return_Deadline_of_Signed__c.year();
        }
        if(con.PA_Date__c!=null){
             Day= con.PA_Date__c.day();
            Month= con.PA_Date__c.month();
            Year= con.PA_Date__c.year();
        }
        pds = [Select Id,Contract_PO_PI__c From Product_Detail__c Where Contract_PO_PI__c =: viewId];
        Nonumber=pds.size()+1;
        Information_of_Seller__c sellerAdresse = [Select id,Address__c,Seller__c from Information_of_Seller__c where  Seller__c=:con.SELLER__c];
        sell = sellerAdresse.Seller__c;
        sellerAdress = sellerAdresse.Address__c;
        List<payment__c> paylst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.payment__c) + ' ' +
                                               'Where Contract__c =: viewId'); 
        String dec ='';
        String decE ='';
        list<Individual_Teams__c> indList = [select id,
                                             Name,
                                             Field_Values__c,
                                             Actual_Values__c,
                                             Type__c,
                                             Contract__c
                                             from Individual_Teams__c 
                                             where Contract__c =:viewId
                                             limit 1000];
                    system.debug('进入'+indList);
        if(indList.size()>0){
            system.debug('进入');
            for(Individual_Teams__c str : indList){
                if(Str.name=='JapanPaymentEN'){
                    DescriptionE =str.actual_Values__c;
                }
                if(Str.name=='JapanPaymentJP'){
                    Description =str.actual_Values__c;
                }
                
            }
            
        }
        else{
            for(payment__c p:paylst){
                if(p.PaymentDescription_Japan__c!=null){
                    if(dec=='' && decE=='' ){
                        dec=p.PaymentDescription_Japan__c;
                        decE=p.PaymentDescription__c;
                    }else{
                    dec=dec+'\n'+p.PaymentDescription_Japan__c;
                    
                    decE=decE+'\n'+p.PaymentDescription__c;
                        }
                }else{
                    if(p.Comments_Japan__c!=null){
                          if(dec=='' && decE=='' ){
                        dec=p.PaymentDescription_Japan__c;
                        decE=p.PaymentDescription__c;
                    }else{
                        dec=dec+'\n'+p.Comments_Japan__c;
                        
                        decE=decE+'\n'+p.Comments_English__c;
                        }
                    }else{
                        dec=dec+'\n'+'没有匹配到相应语句,请手动输入.';
                        
                        decE=decE+'\n'+'没有匹配到相应语句,请手动输入.';
                    }
                }
            }
        
        Description=dec;
        DescriptionE=decE;
            }
        if(con.Trade_term__c=='DDP'){
            TRADETERM='DDP '+con.Destination__c+'	in Japan Free on Truck (under Incoterms 2010)';
            TRADETERMJP='DDP 日本	'+con.Destination__c+' 車上渡し（インコタームズ2010による）';
        }else if(con.Trade_term__c=='CIF'){
            TRADETERM='CIF '+con.Destination__c+' Port in Japan（under Incoterms 2010）';
            TRADETERMJP='CIF 日本 '+con.Destination__c+' 港（インコタームズ2010による）';
        }else if(con.Trade_term__c=='EXW'){
            TRADETERM='EXW Seller’s warehouse at '+con.Destination__c+' in Japan（under Incoterms 2010）';
            TRADETERMJP='EXW 日本　'+con.Destination__c+' に所在する売主の倉庫（インコタームズ２０１０による）';
        }
        
        if(con.CurrencyIsoCode=='JPY'){
            CurrcyJP='日本円';
        }else if(con.CurrencyIsoCode=='USD'){
            CurrcyJP='米ドル';
        }
        if(con.Common_Truck_Type__c!=null){
            if(con.Common_Truck_Type__c.contains('4t flatbed truck')){
                car1=true;
            }
            if(con.Common_Truck_Type__c.contains('4t wing truck')){
                car2=true;
            }
            if(con.Common_Truck_Type__c.contains('10t flatbed truck')){
                car3=true;
            }
            if(con.Common_Truck_Type__c.contains('10t wing truck')){
                car4=true;
            }
            if(con.Common_Truck_Type__c.contains('20t trailer')){
                car5=true;
            }
        }
        if(con.Special_Truck_Type__c!=null){
            if(con.Special_Truck_Type__c.contains('4t unic truck')){
                scar1=true;
            }
            if(con.Special_Truck_Type__c.contains('10t unic truck')){
                scar2=true;
            }
        }
    }
    
    
    
    public PIJapan(){
        
        
    }
    
    
    public PageReference AddSave() { 
         list<Individual_Teams__c> indList = [select id,
                                             Name,
                                             Field_Values__c,
                                             Actual_Values__c,
                                             Type__c,
                                             Contract__c
                                             from Individual_Teams__c 
                                             where Contract__c =:viewId
                                             limit 1000];
        if(indList.size()==0){
        Individual_Teams__c indEN = new Individual_Teams__c();
        Individual_Teams__c indJP = new Individual_Teams__c();
        indEN.name='JapanPaymentEN';
        indJP.name='JapanPaymentJP';
        indEN.Contract__C=viewId;
        indJP.Contract__C=viewId;
        indEN.actual_Values__c=DescriptionE;
        indJP.actual_Values__c=Description;
        
        insert indEN;
        insert indJP;
            }else{
                 for(Individual_Teams__c str : indList){
                if(Str.name=='JapanPaymentEN'){
                    str.actual_Values__c=DescriptionE;
                }
                if(Str.name=='JapanPaymentJP'){
                   str.actual_Values__c=Description;
                }
                
            }
                update indList;
            }
        con.PaymentTermStand__c=DescriptionE+'\n\r'+Description;
        update con;
        system.debug('success'); 
        
        String printPADate = ApexPages.currentPage().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/PAJapan?id='+printPADate);
        return pageRef;
    }
    
    
    
    
    
    
    
    
}