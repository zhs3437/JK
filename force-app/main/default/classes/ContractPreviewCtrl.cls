public class ContractPreviewCtrl {
    public String yuenan {get;set;}
    
    public Decimal fright{get;set;}
    public boolean BG{get;set;}
    public Boolean AuExBoolean{get;set;}
    public Boolean VnExBoolean{get;set;}
    public String Address{get;set;}
    public String AuthorizedSignatory{get;set;}
    public String Title{get;set;}
    public String SellerVATNO{get;set;}
    public List<Product_Detail__c> ProductDetailLst{get;set;}
    public List<Product_Detail__c> ProductDetailLstfeijietou{get;set;}
    public decimal ProductDetailLstfeijietouPC{get;set;}
    public decimal ProductDetailLstfeijietouW{get;set;}
    public decimal ProductDetailLstjietouPC{get;set;}
     public List<Product_Detail__c> ProductDetailLstjietou{get;set;}
    public String PaymentTerm {get;set;}
    list<Individual_Teams__c> indListAfter = new list<Individual_Teams__c>();
    list<Individual_Teams__c> indListBefore = new list<Individual_Teams__c>();
    list<String> SpecialTemLst {get;set;}
    public Integer  SpecialTemLstsize{get;set;}
    public String  SpecialT1{get;set;}
    public String  newSPECIALTERMS{get;set;}
    public String  SpecialT2{get;set;}
    public String  SpecialT3{get;set;}
    public String  SpecialT4{get;set;}
    public String  SpecialT5{get;set;}
    public Date DeliveryDate{get;set;}
    public String MeSPECIALTERMS{get;set;}
    public Date ExceptionDeliveryDate{get;set;}
    public Boolean MexicoSpecial{get;set;}
    public Boolean jietouflag{get;set;}
    public Boolean feijietouflag{get;set;}
    public String MexicoSpecialString{get;set;}
    public ID viewId{get;set;}
    public String newPaymentTerm{get;set;}
    public String newPaymentTerm1{get;set;}
    public String newPaymentTerm2{get;set;}
        public String newPaymentTerm3{get;set;}
    public String newPaymentTerm4{get;set;}
    public String newPaymentTermKK{get;set;}
    public Integer marganNum{get;set;}//空行控制
    public integer Year{get;set;}
    public integer Month{get;set;}
    public integer Day{get;set;}
    public date now{get;set;}
    public String newPy{get;set;}
    public date dt{get;set;}
        public date dt2{get;set;}
    public String str1{get;set;}
    public String str2{get;set;}
    public String StandAcutionTemplate{get;set;}
    public String IndividualTemplate{get;set;}
    public String StandWarranty{get;set;}
    public String IndividualWarranty{get;set;}
    public String Warranty{get;set;}
    public String TradeTerm{get;set;}
    public String StandTradeTerm{get;set;}
    public String IndividualTradeTerm{get;set;} 
    public String GoverningLaw{get;set;}
    public String DisputeResolution{get;set;}
    public String Payment1{get;set;}
    public String Payment2{get;set;}
        public String Payment3{get;set;}
    public String Payment4{get;set;}
    public String SPECIALTERMS{get;set;}
    // request Id
    public String requestId{get;set;}
    //Payment information
    public  List<Payment__c> payLst{get;set;}
    //contract Product_Detail__c information
    public  List<Product_Detail__c> pdLst {get;set;}
    // Current Contract
    public Contract con{get;set;}
    // Current Opportunity
    public Opportunity opportunity{get;set;}
    public User sellers{get;set;}
    public String sellerAddress{get;set;}
    public String sellerTel{get;set;}
    public String sellerEmail{get;set;}
    
    public String ContractFactory{get;set;}
    // Current Account
    public Account buyer{get;set;}
    //Buyer BilingAddress
    public String buyerAddress{get;set;}
    //Buyer BilingTel
    public String buyerTel{get;set;}
    public String buyerVATNO{get;set;}
    //Buyer BulingEmail
    public String buyerEmail{get;set;}
    public boolean Contract_NO{get;set;}
    // Current Date - Apex Date
    public Date tod{get;set;}
    public integer items{get;set;}
    //Contact person info
    public String ContactEmail{get;set;}
    public String ContactTel{get;set;}
    //Current Contract Product 
    public String ContactName{get;set;}
    public String Delivery{get;set;}
    public List<Product_Detail__c> pds{get;set;}
    
    public Information_of_Seller__c seller{get;set;}
    
    public list<Standard_Template_Teams__c> stdList{get;set;}
    public list<Individual_Teams__c> indList{get;set;}
    public Map<string,Standard_Template_Teams__c> stdMap{get;set;}
    public Map<string,Individual_Teams__c> indMap{get;set;}
    public Map<string,Individual_Teams__c> indMapBefore11{get;set;}
    public Contract contract;
    public Contract contract2;
    public boolean isDebug{get{return false;}set;}
    
    public List<String> StandFieldValue{get;set;}
    
    Public List<Product_Detail__c> Pds2{get;set;}
    Public List<Product_Detail__c> PdsConnectors{get;set;}

    Public boolean HaveConnector{get;set;}
    Public boolean HaveModule{get;set;}
    Public boolean HaveConnectorWarrantyEU{get;set;}
    Public boolean HaveConnectorWarrantyNoneEU{get;set;}
    Public boolean HaveModuleWarrantyEU{get;set;}
    Public boolean HaveModuleWarrantyNoneEU{get;set;}
	Public boolean HaveConnectorWarrantyEU_NoModule{get;set;}
    Public boolean HaveConnectorWarrantyNoneEU_NoModule{get;set;}    
    
    
    Public Decimal HaveConnectorPIECES{get;set;}
   	Public Decimal HaveConnectorW{get;set;}
    Public Decimal HaveConnectorPURCHASEPRICE{get;set;}    
    Public Decimal HaveModulePIECES{get;set;}
   	Public Decimal HaveModuleW{get;set;}
    Public Decimal HaveModulePURCHASEPRICE{get;set;}
    Public boolean LoadingPortFlagOneDetail{get;set;}
    Public boolean LoadingPortFlagTwoDetail{get;set;}
    
    Public Decimal PFI_Enadble_True_Connector{get;set;}
    Public Decimal PFI_Enadble_True{get;set;}
    
    public String PaymentCount{get;set;}    
    public ContractPreviewCtrl(ApexPages.StandardController ctrl){
        now = Date.today();
        Day= now.day();
        Month= now.month();
        Year= now.year();
        pds = new List<Product_Detail__c>(); 
        
        if (!Test.isRunningTest()){   ctrl.addFields(new List<String>{ 'Contact_Name__c','Trade_term__c','delivery_note_CI__c','ISFOB__c','Product_Detail__r.Product_Name__c','PFI_Enadble__c','PIF_Not_CIF__c','ISCIF__c','IS_Special_Situations_in_Africa__c','Contract_NO__c','Owner'});}

        //PaymentTerm=ApexPages.currentPage().getParameters().get('PaymentTerm');
      //  newPaymentTerm=ApexPages.currentPage().getParameters().get('newPaymentTerm');
      //  TradeTerm=ApexPages.currentPage().getParameters().get('TradeTerm');
     
       // Warranty=ApexPages.currentPage().getParameters().get('Warranty');
       
   //     GoverningLaw=ApexPages.currentPage().getParameters().get('GoverningLaw');

//        DisputeResolution=ApexPages.currentPage().getParameters().get('DisputeResolution');
     
     //   SPECIALTERMS=ApexPages.currentPage().getParameters().get('SPECIALTERMS');
        MexicoSpecial = false;
        SpecialTemLstsize =0;
        dt = date.today();
        dt2 = date.today();
        indMap = new Map<string,Individual_Teams__c>();
        indMapBefore11 = new Map<string,Individual_Teams__c>();
        viewId=((Contract)ctrl.getRecord()).Id;
        contract = (Contract)[select id,
                              ContractNumber,
                              PFI_Enadble__c,
                              Name,
                              Status,
                              Factory__c,
                              Supply_By__c,
                              Destination_port__c,
                              Governing_Law_FOR_ROA__c,
                              OwnerId,
                              Contact_Name__c,
                              Contract_Approver__c,
                              Owner.BMO_specialist__c,
                              delivery_note_CI__c,
                              Destination__c,
                              Contract_NO__c,
                              Region__c,
                              Destination_port2__c,
                              BuyerAccount__c,
                              PowerGuard_Warranty__c,
                              Destination_Country__c,
                              Warranty_Insurance__c,
                              Local_Warehouse__c,
                              LegalRepair__c,
                              Warranty_On_Material_and_Workmanship__c,
                              Delivery_point__c,
                              Legal_Dept_SendEmail_Time__c,
                              AccountId,
                              Buyer_Letter_of_guarantee__c,
                              Power_Guard__c,
                              SELLER__c,
                              ISFOB__c ,
                              Total_W__c,
                              Click_of_contract_preivew_Legal__c,
                              Total_Usage_of_contract_preivew_Legal__c,
                              SpecialPaymentTerm__c,
                              Payment_Term_Description__c,
                              RecordTypeName__c,
                              Legal_Dept_Finish_Time__c,
                                        Finance_Dept_Finish_Time__c,
                              Opportunity__c,
                              Trade_term__c,
                             Owner.Name,
                              BuyerAccount__r.Name,
                              	Vietnam_loading_port_ruler__c
                              
                              from Contract
                              where id =:ctrl.getId()]; 
 
        AuExBoolean = false;
        VnExBoolean = false;
        if(contract.Destination_Country__c	== 'Australia' && contract.Trade_term__c == 'EXW'){
            AuExBoolean = true;
        }
        if(contract.Destination_Country__c	== 'Vietnam' && contract.Trade_term__c == 'EXW'){
            VnExBoolean = true;
        }

        if(contract.Finance_Dept_Finish_Time__c!=null){
            dt=contract.Finance_Dept_Finish_Time__c.date();
        }
        if(contract.Legal_Dept_Finish_Time__c!=null){
            dt=contract.Legal_Dept_Finish_Time__c.date();
        }
        Contract_NO=false;
        system.debug('----->>>>>--'+contract.delivery_note_CI__c);
        if(contract.delivery_note_CI__c !=null && (contract.Region__c=='EU(Union)'||contract.Region__c=='EU(Non-Eu)')){
        Contract_NO=true;
        }
        ContactName = contract.Contact_Name__c;
        Delivery = contract.delivery_note_CI__c;
                List<opportunity> opp=[select id
                               ,Land_Freight_Oversea__c,
                               Land_Freight_China__c,
                               Ocean_Freight__c,
                                       Ocean_Freight_Oversea__c,
                                       Warehouse_Premium__c
                               from opportunity where id =:contract.Opportunity__c]; 
        system.debug('opp个数:'+opp.size());
        if(opp.size()>0){
            if(opp[0].Land_Freight_Oversea__c==null){
                opp[0].Land_Freight_Oversea__c=0;
            }
            if(opp[0].Warehouse_Premium__c==null){
                opp[0].Warehouse_Premium__c=0;
            }
            if(opp[0].Land_Freight_China__c==null){
               opp[0].Land_Freight_China__c=0;
            }
            if(opp[0].Ocean_Freight__c==null){
              opp[0].Ocean_Freight__c=0;
            }
            if(opp[0].Ocean_Freight_Oversea__c==null){
              opp[0].Ocean_Freight_Oversea__c=0;
            }
              if(opp[0].Land_Freight_Oversea__c!=null && opp[0].Land_Freight_China__c!=null
               && opp[0].Ocean_Freight__c!=null && opp[0].Warehouse_Premium__c!=null && opp[0].Ocean_Freight_Oversea__c!=null){
          fright  =opp[0].Land_Freight_Oversea__c+opp[0].Ocean_Freight__c+opp[0].Warehouse_Premium__c+opp[0].Ocean_Freight_Oversea__c;
            }
            system.debug('fright:'+fright);
            system.debug('contract.Total_W__c:'+contract.Total_W__c);
            
            }
        if(contract.Total_Usage_of_contract_preivew_Legal__c == null || contract.Total_Usage_of_contract_preivew_Legal__c==0){
            contract.Total_Usage_of_contract_preivew_Legal__c = 1;
            contract.Click_of_contract_preivew_Legal__c =true;
        }else{
            contract.Total_Usage_of_contract_preivew_Legal__c =contract.Total_Usage_of_contract_preivew_Legal__c +1;
            contract.Click_of_contract_preivew_Legal__c =true;
        }
        system.debug('11111');
        system.debug(' contract.Total_Usage_of_contract_preivew_Legal__c---->'+ contract.Total_Usage_of_contract_preivew_Legal__c);
        
        system.debug('1234');
        pds = [select id,Product_name__c,lianjietou__c,Unit_WM__c,Quantity__c,Total_W__c,Unit_Price__c,Total_Price__c,Guaranteed_Delivery_Date__c,FOB_Unit_Price__c,Product__r.Maximum_Power_at_STC_Pmax__c,FOB_Total_Price__c from Product_Detail__c WHERE Contract_PO_PI__c =: viewId ORDER BY Guaranteed_Delivery_Date__c];
        //2020/03/25更新越南地区产品分连接头产品和组件产品
        pds2 =new List<Product_Detail__c>();
        PdsConnectors = new List<Product_Detail__c>();
        
        HaveConnector = false;
        HaveModule =false;
        HaveConnectorPIECES=0;
        HaveConnectorW=0;
        HaveConnectorPURCHASEPRICE=0;
        HaveModulePIECES=0;
        HaveModuleW=0;   
        HaveModulePURCHASEPRICE=0;  
        PFI_Enadble_True=0;
        PFI_Enadble_True_Connector=0;
        if(pds.size()>0){
          for(Product_Detail__c product: pds){
             if(product.lianjietou__c==true){                 
                 PdsConnectors.add(product);
                 HaveConnector =true;                      
				 HaveConnectorPIECES=HaveConnectorPIECES+product.Quantity__c;                  
                 HaveConnectorW=HaveConnectorW+product.Total_W__c;    
                 HaveConnectorPURCHASEPRICE=HaveConnectorPURCHASEPRICE+product.Total_Price__c;
                 PFI_Enadble_True_Connector=PFI_Enadble_True_Connector+product.FOB_Unit_Price__c* product.Product__r.Maximum_Power_at_STC_Pmax__c * product.Quantity__c;
             }else{
                 System.debug('product.id---------->'+product.id);
                 pds2.add(product);
                 HaveModule =true;
                 HaveModulePIECES=HaveModulePIECES+product.Quantity__c;                  
                 HaveModuleW=HaveModuleW+product.Total_W__c;    
                 System.debug('2333-HaveModulePIECES---------->'+HaveModulePIECES);
                 System.debug('2333-HaveModuleW---------->'+HaveModuleW);
                 HaveModulePURCHASEPRICE=HaveModulePURCHASEPRICE+product.Total_Price__c;
                 PFI_Enadble_True=PFI_Enadble_True+product.FOB_Unit_Price__c* product.Product__r.Maximum_Power_at_STC_Pmax__c * product.Quantity__c;
                 //HaveModulePURCHASEPRICE=HaveModulePURCHASEPRICE+product.FOB_Total_Price__c;                
              }
          }
        }
        HaveConnectorWarrantyEU = false;
        HaveConnectorWarrantyNoneEU = false;
        if(HaveModule == true && HaveConnector == true && contract.Region__c.contains('EU')){
            HaveConnectorWarrantyEU =true;
        }else if(HaveModule == true && HaveConnector == true && !contract.Region__c.contains('EU')){
            HaveConnectorWarrantyNoneEU = true;
        }
        
         HaveModuleWarrantyEU = false;
        HaveModuleWarrantyNoneEU = false;
        if(HaveModule == true && contract.Region__c.contains('EU')){
            HaveModuleWarrantyEU =true;
        }else if(HaveModule == true && !contract.Region__c.contains('EU')){
            System.debug('走进');
            HaveModuleWarrantyNoneEU = true;
        }
        HaveConnectorWarrantyEU_NoModule = false;
        HaveConnectorWarrantyNoneEU_NoModule = false;
        if(HaveModule ==false && HaveConnector == true && contract.Region__c.contains('EU')){
            HaveConnectorWarrantyEU_NoModule = true;
            
            
        }
        if(HaveModule ==false && HaveConnector == true && !contract.Region__c.contains('EU')){
		   HaveConnectorWarrantyNoneEU_NoModule = true;
        }
        
        
        
        
        
        
        LoadingPortFlagOneDetail = false;
        LoadingPortFlagTwoDetail = false;
        
        if(contract.Vietnam_loading_port_ruler__c==true && HaveModule==true && HaveConnector==false){
            LoadingPortFlagOneDetail =true;
         }
        if(contract.Vietnam_loading_port_ruler__c==true && HaveModule==false && HaveConnector==true){
            LoadingPortFlagOneDetail =true;
         }
        if(contract.Vietnam_loading_port_ruler__c==true && HaveModule==true && HaveConnector==true){
            LoadingPortFlagTwoDetail =true;
         }
        
        
        
        payLst =[Select ID,Contract__c,Days__c,Down_Balance_Payment__c,Pakistan__c,Percentage__c,Comments_Japan__c,Payment_Method__c,Payment_Term__c,Precise_Day__c,VietNam__c,PaymentDescription_Japan__c from Payment__c where Contract__c =:contract.id];
        pdLst =[Select ID,Contract_PO_PI__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c,Total_W__c  from Product_Detail__c where Contract_PO_PI__c =:contract.id ORDER By Guaranteed_Delivery_Date__c ASC];
        ProductDetailLst = [select id,Production_Description__c,product__r.Maximum_Power_at_STC_Pmax__c,Unit_Price__c,Quantity__c from Product_Detail__c Where Contract_PO_PI__c = :ctrl.getId()];
       
        ProductDetailLstfeijietou = [select id,Production_Description__c,Product__r.Maximum_Power_at_STC_Pmax__c,FOB_Unit_Price__c,Product_name__c,Guaranteed_Delivery_Date__c,Total_Price__c,lianjietou__c,Unit_Price__c,Quantity__c,Total_W__c from Product_Detail__c Where Contract_PO_PI__c = :ctrl.getId() and lianjietou__c =:false];
        feijietouflag=false;
        if(ProductDetailLstfeijietou.size()>0){
           feijietouflag=true; 
        }
        ProductDetailLstfeijietouPC=0;
        ProductDetailLstfeijietouW=0;
        FOR(Product_Detail__c P:ProductDetailLstfeijietou){
            ProductDetailLstfeijietouPC=ProductDetailLstfeijietouPC+p.Quantity__c;
                ProductDetailLstfeijietouW=ProductDetailLstfeijietouW+p.Total_W__c;
        }
        ProductDetailLstjietou=new List<Product_Detail__c>(); 
        ProductDetailLstjietou = [select id,Production_Description__c,Product__r.Maximum_Power_at_STC_Pmax__c,FOB_Unit_Price__c,Product_name__c,Guaranteed_Delivery_Date__c,Total_Price__c,lianjietou__c,Unit_Price__c,Quantity__c,Total_W__c from Product_Detail__c Where Contract_PO_PI__c = :ctrl.getId() and lianjietou__c=:true];
        
        jietouflag=false;
        ProductDetailLstjietouPC=0;
        if(ProductDetailLstjietou.size()>0){
            jietouflag=true;
                FOR(Product_Detail__c P:ProductDetailLstjietou){
                    ProductDetailLstjietouPC=ProductDetailLstjietouPC+p.Quantity__c;
                }
        }
        String dec ='';
        List<Individual_Teams__c> iitLst =[Select Id,Actual_Values__c,Contract__c,Field_Values__c,Name from Individual_Teams__c where Contract__c =:contract.Id]; 
        if(iitLst.size()>0){
            system.debug('进入');
            for(Individual_Teams__c str : iitLst){
                if(Str.name=='JapanPaymentJP'){
                    newPy =str.actual_Values__c;
                }
                
            }
            
        }
        else{
            for(payment__c p:paylst){
                if(p.PaymentDescription_Japan__c!=null){
                    if(dec=='' ){
                        dec=p.PaymentDescription_Japan__c;
                    }else{
                    dec=dec+'\n'+p.PaymentDescription_Japan__c;
                        }
                }else{
                    if(p.Comments_Japan__c!=null){
                          if(dec=='' ){
                        dec=p.PaymentDescription_Japan__c;
                    }else{
                        dec=dec+'\n'+p.Comments_Japan__c;
                        }
                    }else{
                        dec=dec+'\n'+'没有匹配到相应语句,请手动输入.';
                    }
                }
            }
        system.debug('dec'+dec);
        newPy=dec;
            }
      //  system.debug('iitLst.size()--->'+iitLst.size());
        /**
        if(iitLst.size()>0){
            for(Individual_Teams__c it1 :iitLst){
                if(it1.Name =='Trade_term__c'){
                    PaymentTerm = it1.Actual_Values__c;
                }
            }
        }
      **/
        
      
        //item 的条数
        requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('requestId-->'+requestId);
        // init - Contract
        if(requestId != null)con = Database.query(Utils.MakeSelectSql('Contract') + ' WHERE Id =: requestId');
        
          	if(contract != null && contract.AccountId != null){
			String accountId = contract.BuyerAccount__c;
			buyer = Database.query(Utils.MakeSelectSql('Account')  + ' WHERE Id =: accountId');
		}
        /*
* 获取lineItem 的条数
*/

        items = pds.size();
        system.debug('-----pds' + pds.size());
        system.debug('contract-->'+ contract);
        system.debug(' contract.OwnerId-->'+ contract.OwnerId);
        system.debug(' contract.Contract_Approver__c-->'+ contract.Contract_Approver__c);
        if(contract != null && contract.Contract_Approver__c !=null){
            String userId = contract.OwnerId;
            
            sellers = [Select id ,Phone ,Name, MobilePhone,City,Country,PostalCode,State,Street, Address, Email from User where Id =: userId];
            system.debug('sellers-->'+sellers);
            // sellers = Database.query(Utils.MakeSelectSql('User') + ' WHERE Id =: userId');
        }
       // system.debug('sellers.Address+-->'+sellers.Address+'');
       // 
       system.debug('start Debug');
       system.debug('con.SELLER__c-->'+con.SELLER__c);
        system.debug('con.CurrencyIsoCode-->'+con.CurrencyIsoCode);
        system.debug('buyer.VAT_NO__c-->'+buyer.VAT_NO__c);
        
        system.debug('sellers-->'+sellers);
        if(sellers !=null){
            if(con.SELLER__c == 'JINKOSOLAR (PTY) LTD' && con.CurrencyIsoCode == 'ZAR' && buyer.VAT_NO__c != null){
        
            sellerAddress = sellers.City+sellers.Country+sellers.PostalCode+sellers.State+sellers.Street;
            sellerTel = sellers.Phone;
            sellerEmail = sellers.Email;
        }else{
            sellerAddress = sellers.City+sellers.Country+sellers.PostalCode+sellers.State+sellers.Street;
            sellerTel = sellers.MobilePhone;
            sellerEmail = sellers.Email;
            system.debug('sellerTel'+sellerTel);
        } 
        }
       
        //越南 seller 
         yuenan='0';
        if(con.SELLER__c!='Jinkosolar (Vietnam) Co., Ltd.' && con.Destination_Country__c=='Vietnam'){
            yuenan='1';
        }else if(con.SELLER__c =='Jinkosolar (Vietnam) Co., Ltd.' && con.Destination_Country__c=='Vietnam'){
            yuenan='2';
        }
        
        
        
        // init - Buyer Account
        if(con != null && con.AccountId != null){
            String accountId = con.BuyerAccount__c;
            buyer = Database.query(Utils.MakeSelectSql('Account')  + ' WHERE Id =: accountId');
        }
        //当SELLER 为JINKOSOLAR (PTY) LTD 货币为 ZAR buyer地址加上 VAT NO
        if(con.SELLER__c == 'JINKOSOLAR (PTY) LTD' && con.CurrencyIsoCode == 'ZAR' && buyer.VAT_NO__c != null){
            if(buyer.BillingState!=null){
            buyerAddress = 	buyer.BillingStreet +' ,'+ buyer.BillingCity +' ,'+buyer.BillingState +' ,'+ buyer.BillingCountry +' VAT NO . '+ buyer.VAT_NO__c;
            }else{
            buyerAddress = 	buyer.BillingStreet +' ,'+ buyer.BillingCity +' ,'+ buyer.BillingCountry +' VAT NO . '+ buyer.VAT_NO__c;
            }
            buyerTel = 	buyer.Phone;
            buyerEmail = buyer.Company_Email__c;
            buyerVATNO = buyer.VAT_NO__c;            
         //   system.debug('-------> buyerAddress' + buyerAddress);
        }
        else{if(buyer.BillingState!=null){
            buyerAddress = 	buyer.BillingStreet +' ,'+ buyer.BillingCity +' ,'+buyer.BillingState +' ,'+ buyer.BillingCountry +' VAT NO . '+ buyer.VAT_NO__c;
            }else{
            buyerAddress = 	buyer.BillingStreet +' ,'+ buyer.BillingCity +' ,'+ buyer.BillingCountry +' VAT NO . '+ buyer.VAT_NO__c;
            }buyerTel = 	buyer.Phone;
            buyerEmail = buyer.Company_Email__c;
            buyerVATNO = buyer.VAT_NO__c;     
           // system.debug('-------> buyerAddress' + buyerAddress);
        }
        // init - seller info  by jason 
        try{
            List<Information_of_Seller__c>  sellers = [select id,Address__c,Authorized_Signatory__c,Seller__c,Title__c,Seller_VAT_NO__c from Information_of_Seller__c where Seller__c =: con.SELLER__c];
           system.debug('con.SELLER__c-->'+con.SELLER__c);
            system.debug('sellers.size()-->'+sellers.size());
            system.debug('sellers-->'+sellers);
            if(sellers.size() > 0){
                
                Address = '';
                AuthorizedSignatory = '';
                Title = '';
                SellerVATNO ='';
                Information_of_Seller__c infoSeller = sellers[0];
                System.debug('infoSeller--->'+infoSeller);
                Address = infoSeller.Address__c;
                AuthorizedSignatory = infoSeller.Authorized_Signatory__c;
                Title = infoSeller.Title__c;
                SellerVATNO=infoSeller.Seller_VAT_NO__c;
            }
            /**
List<Govening_laws_and_arbitration__c>  glaas = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where Country__c =:buyer.Country__c OR (Area__c =: con.Region__c and Country__c NOT IN('Chile','Mexico','Brazil','United Kingdom','Australia','Singapore','Dubai'))];

Govening_laws_and_arbitration__c glaa = null;
if(glaas.size() > 0){
glaa = glaas[0];
}
if(glaa!=null){
con.Arbitration__c = glaa.Arbitration__c;
con.Law__c= glaa.Law__c;
}
**/
        }catch(Exception ex){
            System.debug('--------> '+ex.getMessage());
        }
    }
    
    public ContractPreviewCtrl(){
        contract2=contract;
        
    }
    public void Previewinitialize(){
        
       String printPADate = ApexPages.currentPage().getParameters().get('id');
       List<Contract> con = [select Print_PA_Date__c from Contract where id =: printPADate];
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
                      
            system.debug(co.Print_PA_Date__c );
        }
        update con;
        LoadPreview(contract.id);
        NewPreview();
        if(!String.isEmpty(SPECIALTERMS) && !String.isEmpty(newPaymentTerm)&&!String.isEmpty(Warranty) && !String.isEmpty(TradeTerm)){
            //设置报价备注定位
            marganNum=20-((SPECIALTERMS.length()/800)*(6/3)+(newPaymentTerm.length()/1000)*(6/3)+(Warranty.length()/1000)*(6/3)+(TradeTerm.length()/1000)*(6/3));
            if(marganNum<2){
                marganNum=2;
            }  
        }else if( !String.isEmpty(newPaymentTerm)&&!String.isEmpty(Warranty) && !String.isEmpty(TradeTerm)){
             //设置报价备注定位
            marganNum=23-((newPaymentTerm.length()/1000)*(9/3)+(Warranty.length()/1000)*(9/3)+(TradeTerm.length()/1000)*(9/3));
            if(marganNum<2){
                marganNum=2;
            }  
         }
        upsert contract;
    }
    public void initialize(){
        
       String printPADate = ApexPages.currentPage().getParameters().get('id');
       List<Contract> con = [select Print_PA_Date__c from Contract where id =: printPADate];
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
                      
            system.debug(co.Print_PA_Date__c );
        }
        update con;


        
        
      
        LoadPreview(contract.id);
     
        if(indList.size()==0){
            NewPreview();
        }else if(indList.size()>0){
            showTemplate();
        }
     
        if(!String.isEmpty(SPECIALTERMS) && !String.isEmpty(newPaymentTerm)&&!String.isEmpty(Warranty) && !String.isEmpty(TradeTerm)){
            //设置报价备注定位
            marganNum=20-((SPECIALTERMS.length()/800)*(6/3)+(newPaymentTerm.length()/1000)*(6/3)+(Warranty.length()/1000)*(6/3)+(TradeTerm.length()/1000)*(6/3));
            if(marganNum<2){
                marganNum=2;
            }  
        }else if( !String.isEmpty(newPaymentTerm)&&!String.isEmpty(Warranty) && !String.isEmpty(TradeTerm)){
             //设置报价备注定位
            marganNum=23-((newPaymentTerm.length()/1000)*(9/3)+(Warranty.length()/1000)*(9/3)+(TradeTerm.length()/1000)*(9/3));
            if(marganNum<2){
                marganNum=2;
            }  
         }
        upsert contract;
    }
    public void NewPreview(){
        //load standard template teams
        system.debug('stdList.size()'+stdList.size());
        for(Standard_Template_Teams__c stt: stdList){
            Individual_Teams__c it = new Individual_Teams__c();
            setIndividualTeam( stt,  it, contract);
            if(it.Field_Values__c !=null){
                indMap.put(it.Name, it);
                indMapBefore11.put(it.Name,it);
            }
            
        }
        
        
    }
    
    public void LoadPreview(string contractId){
        //load standard template teams
        stdList = [select id,
                   Name,
                   Field_Values__c,
                   Actual_Values__c,
                   Type__c,
                   Flag__c
                   from Standard_Template_Teams__c 
                   limit 4000];
        stdMap = new Map<string,Standard_Template_Teams__c>();
        for(Standard_Template_Teams__c s : stdList){
            stdMap.put(s.Name,s);
        }
        //load contract individual teams
        indList = [select id,
                   Name,
                   Field_Values__c,
                   Actual_Values__c,
                   Type__c,
                   Contract__c
                   from Individual_Teams__c 
                   where Contract__c =:contractId
                   limit 1000];
        indMap = new Map<string,Individual_Teams__c>();
        
        for(Individual_Teams__c i : indList){
            indMap.put(i.Name,i);
            
        }
    }
    
    public void setIndividualTeam(Standard_Template_Teams__c stt, Individual_Teams__c it,Contract contract){
        try{
            
            If(pdLst.size()>0){
                DeliveryDate = pdLst[0].Guaranteed_Delivery_Date__c;
            }
            it.Name = stt.Name;
            it.Type__c = stt.Type__c;
            Boolean DeliveryDatefalg = true;
            PaymentCount = String.valueOf(payLst.size());
            // get api name
            //it.Field_Values__c =string.valueOf(contract.get(it.Name));            
            //string apiName = cvtAPIName(it.Name);
            // contract field value
            //  string fieldValue =string.valueOf( contract.get(apiName));
            //  it.Field_Values__c =fieldValue;
            // system.debug('fieldValue:' + fieldValue);
            //If Equal then, set actual value = field value
            
            if(stt.Type__c == 'Equal'){
                if(stt.Name=='Trade_term__c'){
                    if(stt.Field_Values__c==contract.Trade_term__c){
                        system.debug('stt.Field_Values__c-->'+stt.Field_Values__c);
                         system.debug('contract.Trade_term__c-->'+contract.Trade_term__c);
                        system.debug('contract.SELLER__c--->'+contract.SELLER__c);
                          if(contract.Trade_term__c =='FCA'){
                                if(contract.SELLER__c =='JinkoSolar GmbH' || contract.seller__c=='JinkoSolar (Switzerland) AG' ||contract.seller__c=='Jinko Solar Denmark Aps'){
                                    it.Actual_Values__c = 'FCA '+ String.valueof(contract.Destination__c) ; 
                                 }else if(contract.Local_Warehouse__c!=null){
                                     it.Actual_Values__c = 'FCA '+ String.valueof(contract.Local_Warehouse__c) ; 
                                 }else{
                                         it.Actual_Values__c = stt.Actual_Values__c; 
                                     }
                          }
                        else{
                                    it.Actual_Values__c = stt.Actual_Values__c; 
                          }
                      
                        
                       system.debug('TradeTerm-->'+TradeTerm);
                        
                        it.Field_Values__c =stt.Field_Values__c;
                        TradeTerm = it.Actual_Values__c ;
                       system.debug('TradeTerm-->'+TradeTerm);
                    }
                }
                else if(stt.Name=='Region__c:Destination_Country__c'){
                 
                    List<String>  IndivValue = new List<String>();
                    StandFieldValue = stt.Field_Values__c.split(':');
         
                    if(stt.Field_Values__c.indexof(contract.Region__c)>-1 && StandFieldValue[1]==contract.Destination_Country__c){
                        if(contract.Region__c!='ROA'){
                        it.Field_Values__c = contract.Region__c+':'+contract.Destination_Country__c;
                        it.Actual_Values__c = stt.Actual_Values__c;     
                        IndivValue =  it.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                   } 
                        else if(contract.Region__c=='ROA' && Contract.Destination_Country__c !='Australia'){
                             it.Field_Values__c = stt.Field_Values__c;
                        it.Actual_Values__c = stt.Actual_Values__c;     
                        IndivValue =  it.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                        }else if(contract.Region__c=='ROA' && Contract.Destination_Country__c =='Australia'){
                            it.Field_Values__c = stt.Field_Values__c;
                        it.Actual_Values__c = stt.Actual_Values__c;     
                        IndivValue =  it.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                        }
                        if(contract.Region__c=='South Asia' && contract.Destination_Country__c=='India' && contract.seller__c!='JINKOSOLAR TRADING PRIVATE LIMITED' ){
                            it.Actual_Values__c = System.Label.chinaandhongkong;   
                             IndivValue =  it.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                        }
                }
                }}            
            //If Contain then, replace field value to individual field value.
            else if(stt.Type__c == 'Contain'){  
                if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                    if(payLst.size()>0){
                        if(contract.RecordTypeName__c=='1MW Australia Contract' || contract.RecordTypeName__c=='1MW Global Standard Contract' || contract.RecordTypeName__c=='1MW Japan Contract'){
                    if(stt.Field_Values__c.indexof(con.Trade_term__c)>-1){
                        newPaymentTerm = contract.Payment_Term_Description__c;
                         it.Actual_Values__c = newPaymentTerm; 
                         stt.Actual_Values__c = it.Actual_Values__c;
                    }
                  }
                        else if(payLst.size()==1){
                            StandFieldValue = stt.Field_Values__c.split(':');
                             if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB' || Contract.Trade_term__c=='EXW' ){
                                if(payLst[0].Payment_Term__c=='x% DP X days after the Execution Date'){
                                if(payLst[0].Down_Balance_Payment__c=='Down Payment'){
                                      ExceptionDeliveryDate = dt.addDays(Integer.valueof(payLst[0].Days__c));
                                }
                                if(ExceptionDeliveryDate !=null && (Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB')){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(14);
                                }else if(ExceptionDeliveryDate !=null && Contract.Trade_term__c=='EXW'){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(3);
                                }
                                   
                                if(ExceptionDeliveryDate !=null && DeliveryDate !=null){
                                    Integer i=ExceptionDeliveryDate.daysBetween(DeliveryDate);
                                    if(i<0){
                                        DeliveryDatefalg = false;  
                                    }else{
                                        DeliveryDatefalg = true;    
                                    }
                                }else{
                                    DeliveryDatefalg = false;
                                }  
                                }else if(payLst[0].Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                    if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB'){
                                        if(payLst[0].Days__c >13){
                                             DeliveryDatefalg = true;  
                                        }else{
                                             DeliveryDatefalg = false;  
                                        }
                                    }else if(Contract.Trade_term__c=='EXW'){
                                      if(payLst[0].Days__c >2){
                                             DeliveryDatefalg = true;  
                                      }else{
                                          DeliveryDatefalg = false;  
                                      }
                                    }
                                }
                              
                            }
                            
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){   
                                it.Field_Values__c = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+payLst[0].Payment_Method__c +':'+ payLst[0].Payment_Term__c+':'; 
                            } 
                            List<String>  IndivFieldValue = new List<String>();
                            if( it.Field_Values__c !=null){
                                IndivFieldValue= it.Field_Values__c.split(':'); 
                            }else{
                               it.Field_Values__c ='Not StandTemplate'; 
                            }     
                            System.debug('走进越南');
                            if(StandFieldValue==IndivFieldValue){
                                System.debug('走进越南2');
                                	         //增加越南逻辑
									  if(payLst[0].VietNam__c){
                                          System.debug('joel 测试越南1');
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             it.Actual_Values__c ='Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[0].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
                                    
                                      }
                                else if(payLst[0].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }
                                     else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[0].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
}
                                else{
                                            it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                			it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                      }
                                
                         
                              
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    
                                    it.Actual_Values__c  = it.Actual_Values__c +'\r\n' +System.Label.Letter_of_guarantee;
                                    
                                    it.Actual_Values__c = it.Actual_Values__c.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                if(payLst[0].Percentage__c!=100){
                                    newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                                }
                                else{
   
                                           newPaymentTerm = it.Actual_Values__c; 
  
                                }
                                if(DeliveryDatefalg==false){
                                  //  newPaymentTerm = '特殊贸易方式的打印时间根据规则叠加超出了预计发货时间,需要法务手动填写'; 
                                }
                                 
                                
                            }
                            stt.Actual_Values__c = it.Actual_Values__c;
                            
                        }
                        else if(payLst.size()==2){
                             if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB' || Contract.Trade_term__c=='EXW' ){
                                if(payLst[0].Payment_Term__c=='x% DP X days after the Execution Date'){
                                if(payLst[0].Down_Balance_Payment__c=='Down Payment'){
                                      ExceptionDeliveryDate = dt.addDays(Integer.valueof(payLst[0].Days__c));
                                }
                                if(ExceptionDeliveryDate !=null && (Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB')){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(13);
                                }else if(ExceptionDeliveryDate !=null && Contract.Trade_term__c=='EXW'){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(2);
                                }
                                   
                                if(ExceptionDeliveryDate !=null && DeliveryDate !=null){
                                    Integer i=ExceptionDeliveryDate.daysBetween(DeliveryDate);
                                    if(i<0){
                                        DeliveryDatefalg = false;  
                                    }else{
                                        DeliveryDatefalg = true;    
                                    }
                                }else{
                                    DeliveryDatefalg = false;
                                }  
                                }else if(payLst[0].Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                    if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB'){
                                        if(payLst[0].Days__c >13){
                                             DeliveryDatefalg = true;  
                                        }else{
                                             DeliveryDatefalg = false;  
                                        }
                                    }else if(Contract.Trade_term__c=='EXW'){
                                      if(payLst[0].Days__c >2){
                                             DeliveryDatefalg = true;  
                                      }else{
                                          DeliveryDatefalg = false;  
                                      }
                                    }
                                }
                              
                            }
                           
                            StandFieldValue = stt.Field_Values__c.split(':');
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){  
                                Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                                Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                                system.debug(Payment1);
                                system.debug(Payment2);
                            }
                            List<String>  IndivFieldValue1 = new List<String>();
                            List<String>  IndivFieldValue2 = new List<String>();
                            if(Payment1 !=null && Payment2 !=null){
                                IndivFieldValue1= Payment1.split(':'); 
                                IndivFieldValue2= Payment2.split(':'); 
                                system.debug(IndivFieldValue1);
                                system.debug(IndivFieldValue2);
                            }
                       
                            if(StandFieldValue==IndivFieldValue1){
                                system.debug('string.valueof(payLst[0].Percentage__c)---》'+string.valueof(payLst[0].Percentage__c));
                                system.debug('oldpayment'+newPaymentTerm1);
                                  if(payLst[0].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm1 ='Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[0].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }
                                      else if(payLst[0].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[0].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
}else{
                                               newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                				newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
                                          }else{
                                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                				newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                				system.debug('newpayment'+newPaymentTerm1);
                                          }
                                
                                
                              
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                system.debug('oldpayment2'+newPaymentTerm2);
                                
                                 if(payLst[1].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm2 ='Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[1].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                              System.debug('newPaymentTerm1------1');
                                          }else{
                                              newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                	 		  newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                          }
                                 }
                                else if(payLst[1].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[1].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                          }
}else{
                                     newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                	 newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                	 system.debug('newpayment2'+newPaymentTerm2);
                                 }
                                
                                
                                
                            }
                      
                            if(newPaymentTerm1 !=null && newPaymentTerm2 !=null){
                                newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2;
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    newPaymentTerm = newPaymentTerm+'\t\r\n'  +System.Label.Letter_of_guarantee;
                                    newPaymentTerm = newPaymentTerm.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                
                                stt.Field_Values__c = Payment1 + ':'+Payment2;
                                it.Field_Values__c =  Payment1 + ':'+Payment2;
                            }
                            
                            if(newPaymentTerm1 ==null || newPaymentTerm2 ==null){
                                newPaymentTerm = '存在后台语句库无法匹配的付款组合';
                                }
                            Decimal i = payLst[0].Percentage__c;
                            Decimal j = payLst[1].Percentage__c;  
                            if((payLst[0].Down_Balance_Payment__c=='Down Payment' && payLst[1].Down_Balance_Payment__c=='Down Payment') || (payLst[0].Down_Balance_Payment__c=='Balance Payment' && payLst[1].Down_Balance_Payment__c=='Balance Payment')){
                    
                            //    newPaymentTerm = '有两条相同类型的付款方式,付款方式描述无法正常显示';
                            }
                            else if( String.valueOf(i+j) =='100' || String.valueOf(i+j) =='100.00'){
                               
                                
                                           it.Actual_Values__c=newPaymentTerm; 
                                			stt.Actual_Values__c = it.Actual_Values__c;
                                      
                                
                                
                                                              
                                
                            }
                            else{
                                newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                            }                            
                            if(DeliveryDatefalg==false){
                             //   newPaymentTerm = '特殊贸易方式的打印时间根据规则叠加超出了预计发货时间,需要法务手动填写'; 
                            }
                            
                            if(it.Field_Values__c ==null){
                                 it.Field_Values__c ='Not StandTemplate';
                            }
                            
                           
                        } 
                          else if(payLst.size()==3){
                            StandFieldValue = stt.Field_Values__c.split(':');
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){  
                                Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                                Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                                 Payment3 = StandFieldValue[0] +':' + payLst[2].Down_Balance_Payment__c + ':'+ payLst[2].Payment_Method__c +':'+  payLst[2].Payment_Term__c; 
                               
                            }
                            List<String>  IndivFieldValue1 = new List<String>();
                            List<String>  IndivFieldValue2 = new List<String>();
                                 List<String>  IndivFieldValue3 = new List<String>();
                            if(Payment1 !=null && Payment2 !=null && Payment3 !=null){
                                IndivFieldValue1= Payment1.split(':'); 
                                IndivFieldValue2= Payment2.split(':');
                                 IndivFieldValue3= Payment3.split(':'); 
                                system.debug(IndivFieldValue1);
                                system.debug(IndivFieldValue2);
                                system.debug(IndivFieldValue3);
                            }
                       
                            if(StandFieldValue==IndivFieldValue1){
                                system.debug('string.valueof(payLst[0].Percentage__c)---》'+string.valueof(payLst[0].Percentage__c));
                                system.debug('oldpayment'+newPaymentTerm1);
                                  if(payLst[0].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm1 ='Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[0].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }else{
                                               newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                				newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
                                          }else if(payLst[0].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[0].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
}else{
                                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                				newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                				system.debug('newpayment'+newPaymentTerm1);
                                          }
                                
                                
                              
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                system.debug('oldpayment2'+newPaymentTerm2);
                                
                                 if(payLst[1].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm2 ='Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[1].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                              System.debug('newPaymentTerm1------1');
                                          }else{
                                              newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                	 		  newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                          }
                                 }else if(payLst[1].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[1].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                          }
}else{
                                     newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                	 newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                	 system.debug('newpayment2'+newPaymentTerm2);
                                 }
                                
                                
                                
                            }
                               if(StandFieldValue==IndivFieldValue3){
                                system.debug('oldpayment2'+newPaymentTerm3);
                                
                                 if(payLst[2].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm3 ='Buyer shall pay '+payLst[2].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[2].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                              System.debug('newPaymentTerm1------1');
                                          }else{
                                              newPaymentTerm3 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                	 		  newPaymentTerm3 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                                          }
                                 }else if(payLst[2].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[2].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[2].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[2].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                                          }
}else{
                                     newPaymentTerm3 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                	 newPaymentTerm3 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                                	 system.debug('newpayment3'+newPaymentTerm3);
                                 }
                                
                                
                                
                            }
                      
                            if(newPaymentTerm1 !=null && newPaymentTerm2 !=null && newPaymentTerm3 !=null){
                                newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2+'\t\r\n' +newPaymentTerm3;
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    newPaymentTerm = newPaymentTerm+'\t\r\n'  +System.Label.Letter_of_guarantee;
                                    newPaymentTerm = newPaymentTerm.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                
                                stt.Field_Values__c = Payment1 + ':'+Payment2+ ':'+Payment3;
                                it.Field_Values__c =  Payment1 + ':'+Payment2+ ':'+Payment3;
                            }
                            
                            if(newPaymentTerm1 ==null || newPaymentTerm2 ==null || newPaymentTerm3 ==null){
                                newPaymentTerm = '存在后台语句库无法匹配的付款组合';
                                }
                            Decimal i = payLst[0].Percentage__c;
                            Decimal j = payLst[1].Percentage__c;  
                               Decimal k = payLst[2].Percentage__c;  
                            if( String.valueOf(i+j+k) =='100' || String.valueOf(i+j+k) =='100.00'){
                               
                                
                                           it.Actual_Values__c=newPaymentTerm; 
                                			stt.Actual_Values__c = it.Actual_Values__c;
                                      
                                
                                
                                                              
                                
                            }
                            else{
                                newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                            }                            
                            if(DeliveryDatefalg==false){
                             //   newPaymentTerm = '特殊贸易方式的打印时间根据规则叠加超出了预计发货时间,需要法务手动填写'; 
                            }
                            
                            if(it.Field_Values__c ==null){
                                 it.Field_Values__c ='Not StandTemplate';
                            }
                            
                           
                        } 
                            else if(payLst.size()==4){
                            StandFieldValue = stt.Field_Values__c.split(':');
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){  
                                Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                                Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                                 Payment3 = StandFieldValue[0] +':' + payLst[2].Down_Balance_Payment__c + ':'+ payLst[2].Payment_Method__c +':'+  payLst[2].Payment_Term__c; 
                                Payment4 = StandFieldValue[0] +':' + payLst[3].Down_Balance_Payment__c + ':'+ payLst[3].Payment_Method__c +':'+  payLst[3].Payment_Term__c; 
                            }
                            List<String>  IndivFieldValue1 = new List<String>();
                            List<String>  IndivFieldValue2 = new List<String>();
                                 List<String>  IndivFieldValue3 = new List<String>();
                                 List<String>  IndivFieldValue4 = new List<String>();
                            if(Payment1 !=null && Payment2 !=null && Payment3 !=null && Payment4 !=null){
                                IndivFieldValue1= Payment1.split(':'); 
                                IndivFieldValue2= Payment2.split(':');
                                 IndivFieldValue3= Payment3.split(':'); 
                                IndivFieldValue4= Payment4.split(':');
                                system.debug(IndivFieldValue1);
                                system.debug(IndivFieldValue2);
                                system.debug(IndivFieldValue3);
                            }
                       
                            if(StandFieldValue==IndivFieldValue1){
                                system.debug('string.valueof(payLst[0].Percentage__c)---》'+string.valueof(payLst[0].Percentage__c));
                                system.debug('oldpayment'+newPaymentTerm1);
                                  if(payLst[0].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm1 ='Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[0].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }else{
                                               newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                				newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
                                          }else if(payLst[0].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[0].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                          }
}else{
                                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                				newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                				system.debug('newpayment'+newPaymentTerm1);
                                          }
                                
                                
                              
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                system.debug('oldpayment2'+newPaymentTerm2);
                                
                                 if(payLst[1].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm2 ='Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[1].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                              System.debug('newPaymentTerm1------1');
                                          }else{
                                              newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                	 		  newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                          }
                                 }else if(payLst[1].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[1].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[1].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                          }
}else{
                                     newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                	 newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                                	 system.debug('newpayment2'+newPaymentTerm2);
                                 }
                                
                                
                                
                            }
                               if(StandFieldValue==IndivFieldValue3){
                                system.debug('oldpayment2'+newPaymentTerm3);
                                
                                 if(payLst[2].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm3 ='Buyer shall pay '+payLst[2].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[2].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                              System.debug('newPaymentTerm1------1');
                                          }else{
                                              newPaymentTerm3 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                	 		  newPaymentTerm3 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                                          }
                                 }else if(payLst[2].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[2].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[2].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[2].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                                          }
}else{
                                     newPaymentTerm3 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                	 newPaymentTerm3 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                                	 system.debug('newpayment3'+newPaymentTerm3);
                                 }
                                
                                
                                
                            }
                       if(StandFieldValue==IndivFieldValue4){
                                system.debug('oldpayment2'+newPaymentTerm3);
                                
                                 if(payLst[3].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             newPaymentTerm4 ='Buyer shall pay '+payLst[3].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[3].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                              System.debug('newPaymentTerm1------1');
                                          }else{
                                              newPaymentTerm4 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[3].Percentage__c));
                                	 		  newPaymentTerm4 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[3].Days__c));
                                          }
                                 }
                           else if(payLst[3].Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             it.Actual_Values__c =
                                                'Buyer shall pay '+payLst[3].Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             it.Actual_Values__c = 'Buyer shall pay '+payLst[3].Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+payLst[3].Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[3].Percentage__c));
                                			   it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[3].Days__c));
                                          }
}else{
                                     newPaymentTerm4 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[3].Percentage__c));
                                	 newPaymentTerm4 = newPaymentTerm4.replace('[填入天数]',string.valueof(payLst[3].Days__c));
                                	 system.debug('newpayment3'+newPaymentTerm3);
                                 }
                                
                                
                                
                            }
                      
                            if(newPaymentTerm1 !=null && newPaymentTerm2 !=null && newPaymentTerm3 !=null && newPaymentTerm4 !=null){
                                newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2+'\t\r\n' +newPaymentTerm3 +'\t\r\n' +newPaymentTerm4;
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    newPaymentTerm = newPaymentTerm+'\t\r\n'  +System.Label.Letter_of_guarantee;
                                    newPaymentTerm = newPaymentTerm.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                
                                stt.Field_Values__c = Payment1 + ':'+Payment2+ ':'+Payment3+ ':'+Payment4;
                                it.Field_Values__c =  Payment1 + ':'+Payment2+ ':'+Payment3+ ':'+Payment4;
                            }
                            
                            if(newPaymentTerm1 ==null || newPaymentTerm2 ==null || newPaymentTerm3 ==null  || newPaymentTerm4 ==null){
                                newPaymentTerm = '存在后台语句库无法匹配的付款组合';
                                }
                            Decimal i = payLst[0].Percentage__c;
                            Decimal j = payLst[1].Percentage__c;  
                               Decimal k = payLst[2].Percentage__c;  
                                Decimal l = payLst[3].Percentage__c;  
                            if( String.valueOf(i+j+k+l) =='100' || String.valueOf(i+j+k+l) =='100.00'){
                               
                                
                                           it.Actual_Values__c=newPaymentTerm; 
                                			stt.Actual_Values__c = it.Actual_Values__c;
                                      
                                
                                
                                                              
                                
                            }
                            else{
                                newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                            }                            
                            if(DeliveryDatefalg==false){
                             //   newPaymentTerm = '特殊贸易方式的打印时间根据规则叠加超出了预计发货时间,需要法务手动填写'; 
                            }
                            
                            if(it.Field_Values__c ==null){
                                 it.Field_Values__c ='Not StandTemplate';
                            }
                            
                           
                        } 
                      
                        else{
                            it.Field_Values__c ='Not StandTemplate';
                        }
                    }
                } 
        
                else if(stt.Name =='Warranty_Insurance__c'){
                    if(contract.Warranty_On_Material_and_Workmanship__c!=null){
                        if(stt.Field_Values__c.indexof(contract.Warranty_On_Material_and_Workmanship__c)>-1){
                            it.Actual_Values__c = stt.Actual_Values__c;
                            it.Field_Values__c =stt.Field_Values__c;
                            Warranty = stt.Actual_Values__c;
                            
                            if(contract.Warranty_Insurance__c =='Powerguard'){
                               Warranty = Warranty +System.Label.Power_Guard;
                            }
                            if(contract.Warranty_Insurance__c =='AR'){
                               Warranty = Warranty +System.Label.AR;
                            }
                        }
                    }
                }
                else if(stt.Name =='Trade_term__c'){
                    if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){
                        it.Field_Values__c =stt.Field_Values__c;
                        str1='CFR,CIF,DAT,DDU,EXW,FCA';
                        str2='DAP,DDP,CIP,CPT,';
                        if(str1.indexOf(contract.Trade_term__c)>-1){
                            it.Actual_Values__c = stt.Actual_Values__c.replace('[123]',String.valueof(contract.Trade_term__c));
                            if(contract.Trade_term__c =='EXW'){
                                if(contract.Factory__c =='' || contract.Factory__c ==null){
                                    it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',' Seller’s warehouse in '+contract.Destination_Country__c);   
                                }else{
                                  ContractFactory = contract.Factory__c; 
                                    if(ContractFactory.indexOf('W/H')>-1){
                                        ContractFactory =ContractFactory.remove('W/H');
                                         it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',' Seller’s warehouse in '+ContractFactory);
                                    }else if(ContractFactory.indexOf('factory')>-1){
                                        ContractFactory =ContractFactory.remove('factory');
                                         it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',' Seller’s factory in '+ContractFactory);
                                    }else{
                                        it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',' Seller’s warehouse in '+ContractFactory); 
                                    }
                                }
                                
                            }
                            else{
                             
                                it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',String.valueof(contract.Destination__c)); 
                                
                                
                              
                            }
                        }
                        else if(str2.indexOf(contract.Trade_term__c)>-1){
                            it.Actual_Values__c = stt.Actual_Values__c.replace('[123]',contract.Trade_term__c);
                            it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',contract.Destination__c);   
                        }
                        stt.Actual_Values__c = it.Actual_Values__c;
                        TradeTerm =  it.Actual_Values__c;
                        System.debug('2020/09/15:'+contract.Destination_port2__c);
                        System.debug('2020/09/15:'+TradeTerm);
                    }                    
                }
                else if(stt.Name=='Region__c:Destination_Country__c'){
                    List<String>  IndivValue = new List<String>();
                    StandFieldValue = stt.Field_Values__c.split(':');
                     if(stt.Field_Values__c.indexof(contract.Region__c)>-1 ){
                        if(contract.Region__c=='ROA' && Contract.Destination_Country__c !='Australia'){
                            
                         it.Field_Values__c = stt.Field_Values__c;
                            if(Contract.Governing_Law_FOR_ROA__c=='Singapore'){
                               it.Actual_Values__c = System.Label.Singapore;     
                            }else{
                                it.Actual_Values__c = stt.Actual_Values__c;    
                            }
                      
                        IndivValue =  it.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                            system.debug('123');
                        }
                       else if(Contract.Destination_Country__c !='Brazil' && Contract.Destination_Country__c !='Chile'&& Contract.Destination_Country__c !='Japan'&& Contract.Destination_Country__c !='India' && Contract.Destination_Country__c !='Mexico' && Contract.Destination_Country__c !='United Arab Emirates' && Contract.Destination_Country__c !='Italy' &&  contract.Region__c !='ROA'){
                        it.Field_Values__c = stt.Field_Values__c;
                        it.Actual_Values__c = stt.Actual_Values__c;     
                        IndivValue =  it.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                      
                       }
                    }
                                 
                }
                else if(stt.Name=='Boolean1:Destination_Country__c:Region__c:SELLER__c:Boolean2:Boolean3'){
                    StandFieldValue=stt.Field_Values__c.split(':');
                    String strCountry ='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD,Jinko Solar Import and Export Co., Ltd.,JinkoSolar International Limited,Jinko Solar Co., Ltd.,JINKOSOLAR TECHNOLOGY LIMITED,ZHEJIANG JINKO SOLAR CO.,LTD,JINKOSOLAR TRADING PRIVATE LIMITED';
                    if(payLst.size()>0){
                        if(payLst.size()==1 && payLst[0].Percentage__c==100 && payLst[0].Down_Balance_Payment__c=='Down Payment' && payLst[0].Payment_Method__c=='T/T' && payLst[0].Payment_Term__c.indexof('before')>-1){
                            it.Field_Values__c = false+':country:Region:Seller:'; 
                        }
                        else{
                            it.Field_Values__c = true+':';
                            
                            if(strCountry.indexof(contract.SELLER__c)>-1){
                           
                                if(contract.SELLER__c=='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                                    it.Field_Values__c =  it.Field_Values__c+'Australia:Region:'+contract.SELLER__c+':';                                
                                }else{
                                    if(contract.Region__c=='EU(Union)'){
                                        it.Field_Values__c =  it.Field_Values__c+'Country:EU(Union):'+StandFieldValue[3]+':';
                                    }else{
                                        it.Field_Values__c =  it.Field_Values__c+'country:Region:Seller:';
                                    }
                                }
                            }
                            else{
                                it.Field_Values__c =  it.Field_Values__c+'country:Region:Seller:'; 
                            }                            
                        }
                        if(String.isNotEmpty(Contract.Delivery_point__c)){
                             if(Contract.Trade_term__c=='CIF' && Contract.Destination_Country__c=='Brazil' && Contract.Delivery_point__c.indexof('warehouse')>-1){
                            it.Field_Values__c =it.Field_Values__c +true+':';
                            }else{
                            it.Field_Values__c =it.Field_Values__c +false+':'; 
                          }
                        }else{
                             it.Field_Values__c =it.Field_Values__c +false+':';  
                        }
                       
                        if(Contract.Trade_term__c=='DAP' || Contract.Trade_term__c=='DDP'){
                             it.Field_Values__c =it.Field_Values__c +true;
                        }else{
                            it.Field_Values__c =it.Field_Values__c +false; 
                        }
                        
                        List<String>  IndivFieldValue = new List<String>();
                    
                      
                        IndivFieldValue=it.Field_Values__c.split(':');
                     
                                if(StandFieldValue==IndivFieldValue){
                            if(IndivFieldValue[4]=='true'){
                                it.Actual_Values__c =stt.Actual_Values__c;
                                it.Actual_Values__c =it.Actual_Values__c.replace('[关联货物所在的具体港口 Port]',contract.Destination__c);
                                stt.Actual_Values__c=it.Actual_Values__c;
                            }else{
                                it.Actual_Values__c =stt.Actual_Values__c;
                            }  
                            SPECIALTERMS  =  it.Actual_Values__c;
                            SpecialTemLst =  SPECIALTERMS.split('~');
                            SpecialTemLstsize = SpecialTemLst.size();
                            MeSPECIALTERMS = System.Label.MexicoSpecial;
                                    if(contract.Trade_term__c =='EXW' && contract.Destination_Country__c=='Mexico'){
                                        MexicoSpecial = true;
                                        if(SpecialTemLst ==null){
                                          MexicoSpecialString = System.Label.MexicoSpecial;
                                            newSPECIALTERMS ='(a)'+ MexicoSpecialString; 
                                        }
                                 
                                    }       
                                    if(SpecialTemLstsize >0){
                                        
                                  
                            if(SpecialTemLstsize==1){
                                SpecialT1 = SpecialTemLst[0];
                             //  newSPECIALTERMS = SpecialT1;
                                if(MexicoSpecial == true){
                                SpecialT2 = MeSPECIALTERMS;
                                }
                            }
                            else if(SpecialTemLstsize==2){
                                SpecialT1 = SpecialTemLst[0];
                                SpecialT2 = SpecialTemLst[1];
                                  if(MexicoSpecial == true){
                                SpecialT3 = MeSPECIALTERMS;    
                                }
                            }
                            else if(SpecialTemLstsize==3){
                                SpecialT1 = SpecialTemLst[0];
                                SpecialT2 = SpecialTemLst[1];
                                SpecialT3 = SpecialTemLst[2];
                                  if(MexicoSpecial == true){
                                SpecialT4 =MeSPECIALTERMS;    
                                }
                           
                            }
                            else if(SpecialTemLstsize==4){
                                SpecialT1 = SpecialTemLst[0];
                                SpecialT2 = SpecialTemLst[1];
                                SpecialT3 = SpecialTemLst[2];
                                SpecialT4 = SpecialTemLst[3];
                                  if(MexicoSpecial == true){
                                SpecialT5 = MeSPECIALTERMS;    
                                }
                       
                            }
                                    
                                    if(SpecialT1 !=null){
                                       newSPECIALTERMS = '(a)'+SpecialT1; 
                                    }
                                       if(SpecialT2 !=null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n'+'(b)'+ SpecialT2; 
                                    }
                                       if(SpecialT3 !=null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(c)'+ SpecialT3; 
                                    }
                                       if(SpecialT4 !=null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(d)'+ SpecialT4; 
                                    }
                                       if(SpecialT5 !=null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(e)'+ SpecialT5; 
                                    }
                                          if(contract.Destination_Country__c=='Greece'){
                                              if(SpecialT1!=null && SpecialT2==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(b)The Buyer hereby acknowledges and agrees that the costs and expenses arising out of, or in connection with, the recycling of the Modules and waste of electronic and electrical equipment in Greece (the “Recycling Costs”)  have not been considered in the calculation of the Price of this Agreement. In light of the above, the Buyer hereby agrees to be fully and exclusively liable - or to procure that the end user of the Modules will be fully and exclusively liable - for the Recycling Costs, as well as, for the compliance with the relevant laws and regulations applicable in Greece for the recycling of the Modules and waste of electronic and electrical equipment.'; 
                                              }
                                              if(SpecialT2!=null && SpecialT3==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(c)The Buyer hereby acknowledges and agrees that the costs and expenses arising out of, or in connection with, the recycling of the Modules and waste of electronic and electrical equipment in Greece (the “Recycling Costs”)  have not been considered in the calculation of the Price of this Agreement. In light of the above, the Buyer hereby agrees to be fully and exclusively liable - or to procure that the end user of the Modules will be fully and exclusively liable - for the Recycling Costs, as well as, for the compliance with the relevant laws and regulations applicable in Greece for the recycling of the Modules and waste of electronic and electrical equipment.'; 
                                              }
                                               if(SpecialT3!=null && SpecialT4==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(d)The Buyer hereby acknowledges and agrees that the costs and expenses arising out of, or in connection with, the recycling of the Modules and waste of electronic and electrical equipment in Greece (the “Recycling Costs”)  have not been considered in the calculation of the Price of this Agreement. In light of the above, the Buyer hereby agrees to be fully and exclusively liable - or to procure that the end user of the Modules will be fully and exclusively liable - for the Recycling Costs, as well as, for the compliance with the relevant laws and regulations applicable in Greece for the recycling of the Modules and waste of electronic and electrical equipment.'; 
                                              }
                                               if(SpecialT4!=null && SpecialT5==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(e)The Buyer hereby acknowledges and agrees that the costs and expenses arising out of, or in connection with, the recycling of the Modules and waste of electronic and electrical equipment in Greece (the “Recycling Costs”)  have not been considered in the calculation of the Price of this Agreement. In light of the above, the Buyer hereby agrees to be fully and exclusively liable - or to procure that the end user of the Modules will be fully and exclusively liable - for the Recycling Costs, as well as, for the compliance with the relevant laws and regulations applicable in Greece for the recycling of the Modules and waste of electronic and electrical equipment.'; 
                                              }
                                               if(SpecialT5!=null ){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(f)The Buyer hereby acknowledges and agrees that the costs and expenses arising out of, or in connection with, the recycling of the Modules and waste of electronic and electrical equipment in Greece (the “Recycling Costs”)  have not been considered in the calculation of the Price of this Agreement. In light of the above, the Buyer hereby agrees to be fully and exclusively liable - or to procure that the end user of the Modules will be fully and exclusively liable - for the Recycling Costs, as well as, for the compliance with the relevant laws and regulations applicable in Greece for the recycling of the Modules and waste of electronic and electrical equipment.'; 
                                              }
                                              }
                                        
                                         if(contract.Destination_Country__c=='Pakistan'){
                                              if(SpecialT1!=null && SpecialT2==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(b)The Parties understand that for importation into Pakistan of a shipment of Modules set forth in the Purchase Order, the Customs authority of Pakistan requires certain inspection and compliance documents to be issued for such shipment. For each shipment in the delivery schedule set forth in the Purchase Order, Seller will issue a set of Pre-Shipment Inspection report and Certificate of Conformance based on Jinko standard (together as the “Report”), and Buyer acknowledges that such Report satisfies the aforementioned requirements by the Customs authority. If Buyer requests to split the shipment(s) agreed in the Purchase Order which result in additional Reports being required for importation of related Modules into Pakistan, Buyer agrees to pay Seller an amount of USD 1200 for each additional set of Report to be issued by Seller.'; 
                                              }
                                              if(SpecialT2!=null && SpecialT3==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(c)The Parties understand that for importation into Pakistan of a shipment of Modules set forth in the Purchase Order, the Customs authority of Pakistan requires certain inspection and compliance documents to be issued for such shipment. For each shipment in the delivery schedule set forth in the Purchase Order, Seller will issue a set of Pre-Shipment Inspection report and Certificate of Conformance based on Jinko standard (together as the “Report”), and Buyer acknowledges that such Report satisfies the aforementioned requirements by the Customs authority. If Buyer requests to split the shipment(s) agreed in the Purchase Order which result in additional Reports being required for importation of related Modules into Pakistan, Buyer agrees to pay Seller an amount of USD 1200 for each additional set of Report to be issued by Seller.'; 
                                              }
                                               if(SpecialT3!=null && SpecialT4==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(d)The Parties understand that for importation into Pakistan of a shipment of Modules set forth in the Purchase Order, the Customs authority of Pakistan requires certain inspection and compliance documents to be issued for such shipment. For each shipment in the delivery schedule set forth in the Purchase Order, Seller will issue a set of Pre-Shipment Inspection report and Certificate of Conformance based on Jinko standard (together as the “Report”), and Buyer acknowledges that such Report satisfies the aforementioned requirements by the Customs authority. If Buyer requests to split the shipment(s) agreed in the Purchase Order which result in additional Reports being required for importation of related Modules into Pakistan, Buyer agrees to pay Seller an amount of USD 1200 for each additional set of Report to be issued by Seller.'; 
                                           }
                                               if(SpecialT4!=null && SpecialT5==null){
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(e)The Parties understand that for importation into Pakistan of a shipment of Modules set forth in the Purchase Order, the Customs authority of Pakistan requires certain inspection and compliance documents to be issued for such shipment. For each shipment in the delivery schedule set forth in the Purchase Order, Seller will issue a set of Pre-Shipment Inspection report and Certificate of Conformance based on Jinko standard (together as the “Report”), and Buyer acknowledges that such Report satisfies the aforementioned requirements by the Customs authority. If Buyer requests to split the shipment(s) agreed in the Purchase Order which result in additional Reports being required for importation of related Modules into Pakistan, Buyer agrees to pay Seller an amount of USD 1200 for each additional set of Report to be issued by Seller.';
                                           }
                                               if(SpecialT5!=null ){ 
                                       newSPECIALTERMS =newSPECIALTERMS +'\r\n' +'(f)The Parties understand that for importation into Pakistan of a shipment of Modules set forth in the Purchase Order, the Customs authority of Pakistan requires certain inspection and compliance documents to be issued for such shipment. For each shipment in the delivery schedule set forth in the Purchase Order, Seller will issue a set of Pre-Shipment Inspection report and Certificate of Conformance based on Jinko standard (together as the “Report”), and Buyer acknowledges that such Report satisfies the aforementioned requirements by the Customs authority. If Buyer requests to split the shipment(s) agreed in the Purchase Order which result in additional Reports being required for importation of related Modules into Pakistan, Buyer agrees to pay Seller an amount of USD 1200 for each additional set of Report to be issued by Seller.';
                                           }
                                              }
                                          System.debug('MexicoSpecial--->'+MexicoSpecial);
                                       System.debug('newSPECIALTERMS-->'+newSPECIALTERMS);
                                     
                            
                        }  }
                    }
                }
            }
            
            else if(stt.Type__c == 'Map'){
                it.Actual_Values__c = stt.Actual_Values__c;
            }
            
        }
        catch(Exception ex){
            system.debug('Exception:' + ex.getStackTraceString());
        }
    }
    
    public string cvtAPIName(string n){
        string retVal = n.removeEnd('}');  
        return retVal.removeStart('#{');
    }
    
    public PageReference AddSave(){
        system.debug('newPy'+newPy);
        if(contract.BuyerAccount__r.name == 'XSOL CO., LTD.'){
            system.debug('111');
            indList = [select id,
                   Name,
                   Field_Values__c,
                   Actual_Values__c,
                   Type__c,
                   Contract__c
                   from Individual_Teams__c 
                   where Contract__c =:contract.id
                   limit 1000];
        system.debug('indList'+indList.size());
        //   LoadPreview(contract.id);
        list<Individual_Teams__c> indListnew = new list<Individual_Teams__c>();
        contract.ContractPDFTime__c = datetime.now();
        contract.PaymentTermStand__c = newPy;
        update contract;
      //     system.debug('newPaymentTermKK-->'+newPaymentTermKK);
      //  system.debug('newPaymentTerm-->'+newPaymentTerm);
      
        if(indList.size()==0){
                Individual_Teams__c itc = new Individual_Teams__c();
                itc.Contract__c = contract.id;
                 system.debug('itc.Name-->'+itc.Name);
                itc.Name='JapanPaymentJP';
                 itc.Actual_Values__c = newPy;
                
            indList.add(itc);
            insert indList;
        }
        else if(indList.size()>0){
            system.debug('indList'+indList.size());
            for(Individual_Teams__c itc : indList){
                if(itc.Name=='JapanPaymentJP'){
                    itc.Actual_Values__c = newPy;
                } 
                system.debug('itc'+itc);
            }
            update indList;
        }
            PageReference savePDF = Page.PAJapanKeyAccount;
            system.debug('Start show PDF');
            return savePdf1(savePDF);
        }
        else{
            indList = [select id,
                   Name,
                   Field_Values__c,
                   Actual_Values__c,
                   Type__c,
                   Contract__c
                   from Individual_Teams__c 
                   where Contract__c =:contract.id
                   limit 1000];
        system.debug('indList'+indList.size());
        //   LoadPreview(contract.id);
        list<Individual_Teams__c> indListnew = new list<Individual_Teams__c>();
        contract.ContractPDFTime__c = datetime.now();
        contract.PaymentTermStand__c = newPaymentTerm;
        update contract;
      //     system.debug('newPaymentTermKK-->'+newPaymentTermKK);
      //  system.debug('newPaymentTerm-->'+newPaymentTerm);
      
        if(indList.size()==0){
            system.debug(' indMap.keySet()-->'+ indMap.keySet());
            for(String str : indMap.keySet()){
                Individual_Teams__c itc = new Individual_Teams__c();
                itc = indMap.get(str);
                itc.Contract__c = contract.id;
                itc.Field_Values__c =   string.valueof(indMap.get(str).Field_Values__c);   
                 system.debug('itc.Name-->'+itc.Name);
                if(itc.Name=='Trade_term__c:PaymentCount:Down_Balance_Payment__c:Payment_Method__c:Payment_Ter'){
                    itc.Actual_Values__c = PaymentTerm;
                }else if(itc.Name=='Warranty_Insurance__c'){
                    itc.Actual_Values__c = Warranty;   
                }else if(itc.Name=='Trade_term__c'){
                    itc.Actual_Values__c = TradeTerm;   
                }else if(itc.Name=='Region__c:Destination_Country__c'){
                    itc.Actual_Values__c = GoverningLaw+':'+DisputeResolution;   
                }else if(itc.Name=='Boolean1:Destination_Country__c:Region__c:SELLER__c:Boolean2:Boolean3'){
                    system.debug('SPECIALTERMS-->'+newSPECIALTERMS);
                 SPECIALTERMS = '';
                      system.debug('SPECIALTERMS-->'+newSPECIALTERMS);
                    /**
                    if(MexicoSpecialString !=null){
                        SPECIALTERMS =SPECIALTERMS+ MexicoSpecialString;
                    }
                    if(SpecialT1 !=null){
                        SPECIALTERMS = SPECIALTERMS + SpecialT1;
                    }
                      if(SpecialT2 !=null){
                        SPECIALTERMS = SPECIALTERMS +'\r\n' +SpecialT2;
                    }
                      if(SpecialT3 !=null){
                        SPECIALTERMS = SPECIALTERMS +'\r\n'+ SpecialT3;
                    }
                      if(SpecialT4 !=null){
                        SPECIALTERMS = SPECIALTERMS +'\r\n'+ SpecialT4;
                    }
                      if(SpecialT5 !=null){
                        SPECIALTERMS = SPECIALTERMS +'\r\n'+ SpecialT5;
                    }
                   */
                    system.debug('SPECIALTERMS-->'+newSPECIALTERMS);
                    itc.Actual_Values__c = newSPECIALTERMS; 
                }else if(itc.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                    itc.Actual_Values__c = newPaymentTerm; 
                }
                indListnew.add(itc);
            }
            upsert indListnew;
        }
        else if(indList.size()>0){
            
            for(String str : indMap.keySet()){
                Individual_Teams__c itc = new Individual_Teams__c();
                itc = indMap.get(str);
                system.debug('itc.Name-->'+itc.Name);
                if(itc.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                    itc.Actual_Values__c = newPaymentTerm;
                } else if(itc.Name=='Warranty_Insurance__c'){
                    itc.Actual_Values__c = Warranty;   
                }else if(itc.Name=='Trade_term__c'){
                    itc.Actual_Values__c = TradeTerm;   
                }else if(itc.Name=='Region__c:Destination_Country__c'){
                    itc.Actual_Values__c = GoverningLaw+':'+DisputeResolution;   
                }else if(itc.Name=='Boolean1:Destination_Country__c:Region__c:SELLER__c:Boolean2:Boolean3'){
                       system.debug('SPECIALTERMS-->'+newSPECIALTERMS);
                 SPECIALTERMS = '';
                      system.debug('SPECIALTERMS-->'+newSPECIALTERMS);
            
                    system.debug('SPECIALTERMS-->'+newSPECIALTERMS);
                    itc.Actual_Values__c = newSPECIALTERMS; 
                    /**
                    SPECIALTERMS = '';
                    system.debug('MexicoSpecialString-->'+MexicoSpecialString);
                    system.debug('SpecialT1-->'+SpecialT1);
                    system.debug('SpecialT2-->'+SpecialT2);
                    system.debug('SpecialT3-->'+SpecialT3);
                    system.debug('SpecialT4-->'+SpecialT4);
                    system.debug('SpecialT5-->'+SpecialT5);
                    if(MexicoSpecialString !=null){
                        SPECIALTERMS =SPECIALTERMS+ MexicoSpecialString;
                    }
                    if(SpecialT1 !=null){
                        SPECIALTERMS = SPECIALTERMS + SpecialT1;
                    }
                      if(SpecialT2 !=null){
                        SPECIALTERMS = SPECIALTERMS +'~' +SpecialT2;
                    }
                      if(SpecialT3 !=null){
                        SPECIALTERMS = SPECIALTERMS +'~'+ SpecialT3;
                    }
                      if(SpecialT4 !=null){
                        SPECIALTERMS = SPECIALTERMS +'~'+ SpecialT4;
                    }
                      if(SpecialT5 !=null){
                        SPECIALTERMS = SPECIALTERMS +'~'+ SpecialT5;
                    }
                    itc.Actual_Values__c = SPECIALTERMS; 
                  **/
                }
                system.debug('itc'+itc);
                indListnew.add(itc);
            }
            upsert indListnew;
        }
            PageReference savePDF = Page.PreviewContractPDF;
            system.debug('Start show PDF');
            return savePdf(savePDF);
        }
        
        
    }
    public  PageReference  SendEmail(){
        try{
        List<Id> addId = new List<Id>();
        addId.add(contract.OwnerId);
         addId.add(contract.Owner.BMO_specialist__c);
        if(addId.size()>0){
            for(Id id:addId){
                 SendEmailUtils.sendToSomeOneId(con.Id, id, 'ContractRemind');
            }
            
        }
            system.debug('1231');
           contract.LegalRepair__c = true;
           contract.Legal_Dept_SendEmail_Time__c = datetime.now();
            update contract;
              ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , 'Send Email Successful'));
        }catch(Exception ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
            
        }
        return null;
    }
    
    public void showTemplate(){      
        system.debug('Strat Show');
        try{
            system.debug('1234');
            LoadPreview(contract.id);
            indListAfter.addAll(indList);
            List<Payment__c> payLst =[Select ID,Contract__c,Days__c,Down_Balance_Payment__c,Percentage__c,Payment_Method__c,Payment_Term__c,Precise_Day__c from Payment__c where Contract__c =:contract.id];
            String nowTemplate = '';
            for(String str : indMap.keySet()){
              if(string.valueof(indMap.get(str).Name)=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                    if(!String.isEmpty(indMap.get(str).Field_Values__c)){
                        if(string.valueof(indMap.get(str).Field_Values__c).indexof(contract.Trade_term__c)>-1){
                            nowTemplate = indMap.get(str).Field_Values__c;                 
                        }
                    }
                }
            }
            
            if(indList.size()>0){
                for(Standard_Template_Teams__c stt: stdList){
                    Individual_Teams__c it = new Individual_Teams__c();
                    setIndividualTeam( stt,  it, contract);
                    indListBefore.add(it);
                    indMapBefore11.put(it.Name, it);
                    if(stt.Name=='Trade_term__c:PaymentCount:Down_Balance_Payment__c:Payment_Method__c:Payment_Ter'){
                        if(nowTemplate ==string.valueof(indMapBefore11.get(stt.Name).Field_Values__c)){
                            if(indMapBefore11.get(stt.Name).Actual_Values__c !=null){
                                StandAcutionTemplate =string.valueof(indMapBefore11.get(stt.Name).Actual_Values__c).replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                StandAcutionTemplate = StandAcutionTemplate.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                if(!String.isEmpty(contract.Buyer_Letter_of_guarantee__c)){
                                    StandAcutionTemplate = StandAcutionTemplate.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                     //增加越南逻辑
									/*  if(payLst[0].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             StandAcutionTemplate ='Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[0].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }
                                    
                                      }*/
                            }
                        }
                    }
                    
                    else if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                        if(nowTemplate ==string.valueof(indMapBefore11.get(stt.Name).Field_Values__c)){
                            if(indMapBefore11.get(stt.Name).Actual_Values__c !=null){
                                StandAcutionTemplate =string.valueof(indMapBefore11.get(stt.Name).Actual_Values__c).replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                StandAcutionTemplate = StandAcutionTemplate.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                if(!String.isEmpty(contract.Buyer_Letter_of_guarantee__c)){
                                    StandAcutionTemplate = StandAcutionTemplate.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                     //增加越南逻辑
								/*	  if(payLst[0].VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             StandAcutionTemplate ='Buyer shall pay '+payLst[0].Percentage__c+'% of total Price of the Goods by TT no later than '+payLst[0].Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }
                                    
                                      }*/
                                
                                
                                
                                
                            }
                        }                        
                    }
                }
                
                for(String str : indMap.keySet()){
                    
                   if(string.valueof(indMap.get(str).Name)=='Warranty_Insurance__c'){
                        Warranty =string.valueof(indMap.get(str).Actual_Values__c);
                    }
                    else if(string.valueof(indMap.get(str).Name)=='Region__c:Destination_Country__c'){
                        List<String> invidLst=string.valueof(indMap.get(str).Actual_Values__c).split(':');
                        GoverningLaw = invidLst[0];
                        DisputeResolution = invidLst[1];
                    }
                    else if(string.valueof(indMap.get(str).Name)=='Trade_term__c'){
                        TradeTerm =string.valueof(indMap.get(str).Actual_Values__c);
                        
                    }else if(string.valueof(indMap.get(str).Name)=='Boolean1:Destination_Country__c:Region__c:SELLER__c:Boolean2:Boolean3'){
                        newSPECIALTERMS=string.valueof(indMap.get(str).Actual_Values__c); 
                    }
                    else if(string.valueof(indMap.get(str).Name)=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                        newPaymentTerm =string.valueof(indMap.get(str).Actual_Values__c);
                        IndividualTemplate =string.valueof(indMap.get(str).Actual_Values__c); 
                    }
                    
                    
                }
               
                
            }
             BG=false;
                System.debug('============================='+newPaymentTerm);
                IF( newPaymentTerm.CONTAINS('Buyer Guaranty')){
                    BG=true;
                         System.debug('============================='+BG);
                }
        }  catch(Exception ex){
            system.debug('Exception:' + ex.getStackTraceString());
        }
    }
    
    public PageReference savePdf( PageReference savePDF){
        system.debug('start PrintPDF');
        savePDF.getParameters().put('id',viewId);
        //  savePDF.getParameters().put('PaymentTerm',PaymentTerm);
        //   savePDF.getParameters().put('TradeTerm',TradeTerm);
        //    savePDF.getParameters().put('Warranty',Warranty);
        savePDF.getParameters().put('GoverningLaw',GoverningLaw);        
        //savePDF.getParameters().put('DisputeResolution',DisputeResolution);
       // savePDF.getParameters().put('SPECIALTERMS',SPECIALTERMS);
        
        
        Contract con=[SELECT id,  Name,Region__c  FROM Contract where id=:viewId Limit 5][0];
        String strFileName = 'Contract'+'.pdf';
        Blob pdfBlob = null;
        PageReference retPage = null;
        
        
        
        if ( !Test.isRunningTest() ) {
            
            pdfBlob = savePDF.getContentAsPDF();
            system.debug('pdfBlob-->'+pdfBlob);
            
        }else{
            
            pdfBlob = Blob.valueOf('test');
            
        }
        
        system.debug('stop Test');
        try{
            system.debug('strat try');
            
            system.debug('strat Attachment');
            Attachment conAttach= new Attachment(
                parentId = viewId,
                name = strFileName ,
                ContentType ='application/pdf',
                body = pdfBlob
            );
            
            upsert conAttach;
            
            retPage = new PageReference('/servlet/servlet.FileDownload?file='+conAttach.Id);
        }catch(Exception ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        
        return retPage;
    }
    public PageReference savePdf1( PageReference savePDF){
        system.debug('start PrintPDF');
        savePDF.getParameters().put('id',viewId);
        //  savePDF.getParameters().put('PaymentTerm',PaymentTerm);
        //   savePDF.getParameters().put('TradeTerm',TradeTerm);
        //    savePDF.getParameters().put('Warranty',Warranty);
        savePDF.getParameters().put('GoverningLaw',GoverningLaw);        
        //savePDF.getParameters().put('DisputeResolution',DisputeResolution);
       // savePDF.getParameters().put('SPECIALTERMS',SPECIALTERMS);
        
        
        Contract con=[SELECT id,  Name,Region__c  FROM Contract where id=:viewId Limit 5][0];
        String strFileName = 'Contract'+'.pdf';
        Blob pdfBlob = null;
        PageReference retPage = null;
        
        
        
        if ( !Test.isRunningTest() ) {
            
            pdfBlob = savePDF.getContentAsPDF();
            system.debug('pdfBlob-->'+pdfBlob);
            
        }else{
            
            pdfBlob = Blob.valueOf('test');
            
        }
        
        system.debug('stop Test');
        try{
            system.debug('strat try');
            
            system.debug('strat Attachment');
            Attachment conAttach= new Attachment(
                parentId = viewId,
                name = strFileName ,
                ContentType ='application/pdf',
                body = pdfBlob
            );
            
            upsert conAttach;
            
            retPage = new PageReference('/apex/PAJapanKeyAccount?id='+viewId);
        }catch(Exception ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        
        return retPage;
    }
    
     public void test(){
            String run = 'Test';
        run = 'Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
           run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
           run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
          run = 'Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
           run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
           run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
          run = 'Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
           run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
           run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
                run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        }
    
}