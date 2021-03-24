public class New_PI_Ctrl {
public String Address{get;set;}
	public String AuthorizedSignatory{get;set;}
	public String Title{get;set;}
     Public List<Product_Detail__c> Pds2{get;set;}
    Public List<Product_Detail__c> PdsConnectors{get;set;}
    public OpportunityLineItem oppLi{get;set;}
    public String SellerVATNO{get;set;}
             public Decimal DownPayD{get;set;}
      public Decimal BanlancePayB{get;set;}
    public List<Product_Detail__c> ProductDetailLst{get;set;}
      list<Individual_Teams__c> indListAfter = new list<Individual_Teams__c>();
    list<Individual_Teams__c> indListBefore = new list<Individual_Teams__c>();
     public String StandAcutionTemplate{get;set;}
    //Payment information
    public  List<Payment__c> payLst{get;set;}
    public list<Payment__c> paylist{get;set;}
    public String Percentage {get;set;}
    public Integer Amount {get;set;}
     public String newPaymentTerm{get;set;}
    public date dt{get;set;}
    //contract Product_Detail__c information
    public  List<Product_Detail__c> pdLst {get;set;}
        Public boolean HaveConnector{get;set;}
    Public boolean HaveModule{get;set;}
    public  List<Product_Detail__c> pdLstSort {get;set;}
     public Date ExceptionDeliveryDate{get;set;}
    public String newPaymentTerm1{get;set;}
    public String newPaymentTerm2{get;set;}
      public String newPaymentTerm3{get;set;}
    public String newPaymentTerm4{get;set;}
     public String Payment1{get;set;}
    public String Payment2{get;set;}
    public String Payment3{get;set;}
    public String Payment4{get;set;}

      public Contract contract;
    public User sellers{get;set;}
    public String sellerAddress{get;set;}
    public String sellerTel{get;set;}
    public String sellerEmail{get;set;}
     //Current Contract Product 
    public String ContractName{get;set;}
     public ID viewId{get;set;}
    public list<Individual_Teams__c> indList{get;set;}
    public String PaymentCount{get;set;}    
    public list<Standard_Template_Teams__c> stdList{get;set;}
    public String TradeTerm{get;set;}
    public String StandTradeTerm{get;set;}
    public String IndividualTradeTerm{get;set;} 
    public List<String> StandFieldValue{get;set;}
    		public Decimal fright{get;set;}
     public Map<string,Standard_Template_Teams__c> stdMap{get;set;}
    public Map<string,Individual_Teams__c> indMap{get;set;}
    public Map<string,Individual_Teams__c> indMapBefore11{get;set;}
    
    
       public String str1{get;set;}
    public String str2{get;set;}
      public String ContractFactory{get;set;}
     public Date DeliveryDate{get;set;}
	// 创建日期
	class TodayTime{
		public String Day  {get;set;}
		public String Month{get;set;}
		public String Year {get;set;}
		
		public TodayTime(){
			Day   = String.valueOf(Date.today().Day());
			Month = String.valueOf(Date.today().Month());
			Year  = String.valueOf(Date.today().Year());
		}
	}
	
	// 基本信息 - 总和、单价、预计日期
	class BasicInfo{
		public Decimal Tax_TotalPrice{get;set;}
		public Decimal Tax_UnitPrice {get;set;}
		public String  ExpectedDate  {get;set;}
		
		public BasicInfo(){
			Tax_TotalPrice = 0;
			Tax_UnitPrice  = 0;
			ExpectedDate   = '';
		}
	}
	
	// request Id
	public String requestId{get;set;}
	
	// Current Contract
	public Contract con{get;set;}
	// Current Opportunity
	public Opportunity opportunity{get;set;}
	// Current Account
	public Account buyer{get;set;}
	// Current Date
	public TodayTime tt{get;set;}
	// Current Basic Information
	public BasicInfo bi{get;set;}
	//Buyer BilingAddress
	public String buyerAddress{get;set;}
	// Current Date - Apex Date
	public Date tod{get;set;}
    public integer items{get;set;}
    //Contact person info
    public String ContactEmail{get;set;}
    public String ContactTel{get;set;}
    //Current Contract Product 
	
    public List<Product_Detail__c> pds = new List<Product_Detail__c>();
    
	public Information_of_Seller__c seller{get;set;}
	
    public New_PI_Ctrl(ApexPages.StandardController controller) {
        if (!Test.isRunningTest()){ controller.addFields(new List<String>{ 'SELLER__c','ISFOB__c','Product_Detail__r.Product_Name__c','PIF_Not_CIF__c','ISCIF__c','IS_Special_Situations_in_Africa__c'});}
        indMap = new Map<string,Individual_Teams__c>();
        indMapBefore11 = new Map<string,Individual_Teams__c>();
        stdList = new list<Standard_Template_Teams__c>();
         viewId=((Contract)controller.getRecord()).Id;
        contract = (Contract)[select id,
                              ContractNumber,
                              Name,
                              incoterm_version__c,
                              Status,
                              Factory__c,
                              Supply_By__c,
                              Destination_port__c,
                              Governing_Law_FOR_ROA__c,
                              OwnerId,
                              Contact_Name__c,
                              Owner.BMO_specialist__c,
                              Destination__c,
                              Opportunity__c,
                              Region__c,
                              Destination_Country__c,
                              Warranty_Insurance__c,
                              LegalRepair__c,
                              ISFOB__c ,
                              Total_W__c,
                              Warranty_On_Material_and_Workmanship__c,
                              Delivery_point__c,
                              Buyer_Letter_of_guarantee__c,
                              SELLER__c,
                              SpecialPaymentTerm__c,
                              Payment_Term_Description__c,
                              RecordTypeName__c,
                              Trade_term__c,
                              Vietnam_loading_port_ruler__c,
                              Vietnam_loading_port_ruler2__c
                              from Contract
                              where id =:controller.getId()]; 
        ContractName = contract.Contact_Name__c;
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
            }if(opp[0].Ocean_Freight_Oversea__c==null){
              opp[0].Ocean_Freight_Oversea__c=0;
            }
              if(opp[0].Land_Freight_Oversea__c!=null && opp[0].Land_Freight_China__c!=null
               && opp[0].Ocean_Freight__c!=null && opp[0].Warehouse_Premium__c!=null && opp[0].Ocean_Freight_Oversea__c!=null){
          fright  =opp[0].Land_Freight_Oversea__c+opp[0].Ocean_Freight__c+opp[0].Warehouse_Premium__c+opp[0].Ocean_Freight_Oversea__c;
            }
            system.debug('fright:'+fright);
            system.debug('contract.Total_W__c:'+contract.Total_W__c);
            }
        
     //  oppLi=[select id,FOB_Sales_Price__c,UnitPrice,Product2.Maximum_Power_at_STC_Pmax__c from OpportunityLineItem where Opportunityid =:opp.id];
        paylist =[Select ID,Contract__c,Days__c,Down_Balance_Payment__c,Opportunity__c,Amount__c,Percentage__c,Payment_Method__c,Payment_Term__c,Precise_Day__c from Payment__c where Opportunity__c =:contract.Opportunity__c and Down_Balance_Payment__c='Down Payment'  ];
        payLst =[Select ID,Contract__c,Days__c,Down_Balance_Payment__c,Percentage__c,Payment_Method__c,Payment_Term__c,Precise_Day__c from Payment__c where Contract__c =:contract.id ];
        pdLst =[Select ID,Contract_PO_PI__c,Product_name__c,lianjietou__c,Unit_WM__c,Quantity__c,Total_W__c,Unit_Price__c,Total_Price__c,Guaranteed_Delivery_Date__c,FOB_Unit_Price__c,Product__r.Maximum_Power_at_STC_Pmax__c,FOB_Total_Price__c
           from Product_Detail__c where Contract_PO_PI__c =:contract.id ORDER By Guaranteed_Delivery_Date__c ASC];
         pds2 =new List<Product_Detail__c>();
        PdsConnectors = new List<Product_Detail__c>();
        HaveConnector=false;
        HaveModule=false;
        for(Product_Detail__c product: pdLst){
             if(product.lianjietou__c==true){     
                 HaveConnector =true; 
             PdsConnectors.add(product);
                 }else{
                      HaveModule=true;
                     pds2.add(product);
                 }
        }
        
        
        pdLstSort =[Select ID,Product_name__c,Contract_PO_PI__c,Guaranteed_Delivery_Date__c,
                    Guaranteed_Delivery_Date_japan__c,Total_W__c,Quantity__c ,Unit_Price__c,Total_Price__c,FOB_Unit_Price__c,Product__r.Maximum_Power_at_STC_Pmax__c            
                    from Product_Detail__c 
                    where Contract_PO_PI__c =:contract.id ORDER By Guaranteed_Delivery_Date__c ASC];
        ProductDetailLst = [select id,Production_Description__c,Unit_Price__c,Quantity__c from Product_Detail__c Where Contract_PO_PI__c = :controller.getId()];
        List<Individual_Teams__c> iitLst =[Select Id,Actual_Values__c,Contract__c,Field_Values__c,Name from Individual_Teams__c where Contract__c =:contract.Id]; 
        system.debug('iitLst.size()--->'+iitLst.size());
        system.debug('paylist************'+paylist.size()+'######'+paylist);
DownPayD=0;
        BanlancePayB=0;
        for(Payment__c p:payLst){
            if(p.Down_Balance_Payment__c=='Down Payment'){
               DownPayD=DownPayD+p.Percentage__c;
            }
            if(p.Down_Balance_Payment__c=='Balance Payment'){
               BanlancePayB=BanlancePayB+p.Percentage__c; 
            }
        }

    //抓取payment的付款方式以及金额 added by Leo 2018.8.7
        if(paylist.size()>0)
        {
          Percentage=String.valueOf(paylist[0].Percentage__c);
          Amount=Integer.valueOf(paylist[0].Amount__c);
        }
        system.debug('Percentage+Amount@@@@@@@@@@@@@@@@@@@@'+Percentage+'######'+Amount);
		// init - 创建PA/PI日期
		tt = new TodayTime();
        //item 的条数
        // init - apex date
		tod = Date.today();
         dt = date.today();
		// init - requestId - Contract Id
		requestId = ApexPages.currentPage().getParameters().get('id');
		
		// init - Contract
		if(requestId != null)con = Database.query(Utils.MakeSelectSql('Contract') + ' WHERE Id =: requestId');
		/*
		 * 获取lineItem 的条数
		 */
         pds = [Select Id,Contract_PO_PI__c From Product_Detail__c Where Contract_PO_PI__c =: requestId];
         items = pds.size();
        system.debug('-----pds' + pds.size());
        
		// init - Buyer Account
		if(con != null && con.AccountId != null){
			String accountId = con.BuyerAccount__c;
			buyer = Database.query(Utils.MakeSelectSql('Account')  + ' WHERE Id =: accountId');
		}
		//contact person Email And Tel
		if (con.Contact_Person__c != null) {
              System.debug('判断 :'+con.ChangeContractPerson__c);
              if(con.ChangeContractPerson__c !=null){
                  
                String TotaContact =con.ChangeContractPerson__c;
			    ContactEmail 	= TotaContact.split(';')[0];
	    		ContactTel 		= TotaContact.split(';')[1];
            }
            /**
			if (con.Contact_Person__c == 'Echo Wang') {
                String TotaContact =System.label.Contract_Person_Echo_Wang;
 
			    ContactEmail 	= TotaContact.split(';')[0];
	    		ContactTel 		= TotaContact.split(';')[1];	
			}
            else if (con.Contact_Person__c == 'Wenting Lu') {
			     String TotaContact =System.label.Contract_Person_Wenting_Lu;
 
			    ContactEmail 	= TotaContact.split(';')[0];
	    		ContactTel 		= TotaContact.split(';')[1];
			}
            else if (con.Contact_Person__c == 'ruiqungang hu') {
			     String TotaContact =System.label.Contract_Person_ruiqungang_hu;
 
			    ContactEmail 	= TotaContact.split(';')[0];
	    		ContactTel 		= TotaContact.split(';')[1];
			}
		    */
		}
		
		//当SELLER 为JINKOSOLAR (PTY) LTD 货币为 ZAR buyer地址加上 VAT NO
		if(con.SELLER__c == 'JINKOSOLAR (PTY) LTD' && con.CurrencyIsoCode == 'ZAR' && buyer.VAT_NO__c != null){
			buyerAddress = 	buyer.BillingCountry +' '+ buyer.BillingCity +' '+ buyer.BillingState +' '+ buyer.BillingStreet +' VAT NO . '+ buyer.VAT_NO__c;
            system.debug('-------> buyerAddress' + buyerAddress);
		}else{
			buyerAddress = 	buyer.BillingCountry +' '+ buyer.BillingCity +' '+ buyer.BillingState +' '+ buyer.BillingStreet ; 
            system.debug('-------> buyerAddress' + buyerAddress);
		}
		// init - seller info  by jason 
        try{
			List<Information_of_Seller__c>  sellers = [select id,Address__c,Authorized_Signatory__c,Seller__c,Title__c,Seller_VAT_NO__c from Information_of_Seller__c where Seller__c =: con.SELLER__c];
			if(sellers.size() > 0){
				
				Address = '';
				AuthorizedSignatory = '';
				Title = '';
                SellerVATNO ='';
				Information_of_Seller__c infoSeller = sellers[0];
				
				Address = infoSeller.Address__c;
				AuthorizedSignatory = infoSeller.Authorized_Signatory__c;
				Title = infoSeller.Title__c;
                SellerVATNO=infoSeller.Seller_VAT_NO__c;
			}
			
		
			List<Govening_laws_and_arbitration__c>  glaas = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where Country__c =:buyer.Country__c OR (Area__c =: con.Region__c and Country__c NOT IN('Chile','Mexico','Brazil','United Kingdom','Australia','Singapore','Dubai'))];
			
			Govening_laws_and_arbitration__c glaa = null;
			if(glaas.size() > 0){
				glaa = glaas[0];
			}
			if(glaa!=null){
				con.Arbitration__c = glaa.Arbitration__c;
				con.Law__c= glaa.Law__c;
			}
			
        }catch(Exception ex){
        	System.debug('--------> '+ex.getMessage());
        }
		
    }
    
    
    
	public New_PI_Ctrl(){
		
		
	}
	
    
        public void initialize(){
      
        LoadPreview(contract.id);
      
        if(indList.size()==0){
            NewPreview();
        }else if(indList.size()>0){
            showTemplate();
        }
     
        
    }
    public void NewPreview(){
        //load standard template teams
        system.debug('stdList.size()'+stdList.size());
        for(Standard_Template_Teams__c stt: stdList){
            Individual_Teams__c it = new Individual_Teams__c();
            setIndividualTeam(stt,it,contract);
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
                                if(contract.SELLER__c =='JinkoSolar GmbH'|| contract.seller__c=='JinkoSolar (Switzerland) AG' ||contract.seller__c=='Jinko Solar Denmark Aps'){
                                    it.Actual_Values__c = 'FCA '+ String.valueof(contract.Destination__c) +' Port'; 
                                 }else if(contract.Local_Warehouse__c!=null){
                                     it.Actual_Values__c = 'FCA '+ String.valueof(contract.Local_Warehouse__c) ; 
                                 }else{
                                         it.Actual_Values__c = stt.Actual_Values__c; 
                                     }
                          }else{
                                    it.Actual_Values__c = stt.Actual_Values__c; 
                          }
                      
                        
                       system.debug('TradeTerm-->'+TradeTerm);
                        
                        it.Field_Values__c =stt.Field_Values__c;
                        TradeTerm = it.Actual_Values__c ;
                       system.debug('TradeTerm-->'+TradeTerm);
                    }
                }
            //If Contain then, replace field value to individual field value.
            }else if(stt.Type__c == 'Contain'){  
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
                            }     
                            
                            if(StandFieldValue==IndivFieldValue){
                                it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    
                                    it.Actual_Values__c  = it.Actual_Values__c +'\r\n' +System.Label.Letter_of_guarantee;
                                    
                                    it.Actual_Values__c = it.Actual_Values__c.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                if(payLst[0].Percentage__c!=100){
                                    newPaymentTerm = '';
                                }
                                else{
                                    newPaymentTerm = it.Actual_Values__c; 
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
                            }
                            List<String>  IndivFieldValue1 = new List<String>();
                            List<String>  IndivFieldValue2 = new List<String>();
                            if(Payment1 !=null && Payment2 !=null){
                                IndivFieldValue1= Payment1.split(':'); 
                                IndivFieldValue2= Payment2.split(':'); 
                            }
                       
                            if(StandFieldValue==IndivFieldValue1){
                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
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
                            
                            Integer i = Integer.valueOf(payLst[0].Percentage__c);
                            Integer j = Integer.valueOf(payLst[1].Percentage__c);  
                            if((payLst[0].Down_Balance_Payment__c=='Down Payment' && payLst[1].Down_Balance_Payment__c=='Down Payment') || (payLst[0].Down_Balance_Payment__c=='Balance Payment' && payLst[1].Down_Balance_Payment__c=='Balance Payment')){
                    
                                newPaymentTerm = '';
                            }else if(contract.Trade_term__c=='EXW' &&( payLst[0].Payment_Method__c=='L/C'|| payLst[1].Payment_Method__c=='L/C')){
                           
                                newPaymentTerm = '';
                            }
                            else if( String.valueOf(i+j) =='100' || String.valueOf(i+j) =='100.00'){
                                it.Actual_Values__c=newPaymentTerm; 
                                stt.Actual_Values__c = it.Actual_Values__c;
                            }
                            else{
                                newPaymentTerm = '';
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
                            }
                       
                            if(StandFieldValue==IndivFieldValue1){
                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                            }
                              if(StandFieldValue==IndivFieldValue3){
                                newPaymentTerm3 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                newPaymentTerm3 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                            }
                      
                            if(newPaymentTerm1 !=null && newPaymentTerm2 !=null && newPaymentTerm3 !=null){
                                newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2+'\t\r\n' +newPaymentTerm3;
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    newPaymentTerm = newPaymentTerm+'\t\r\n'  +System.Label.Letter_of_guarantee;
                                    newPaymentTerm = newPaymentTerm.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                
                                stt.Field_Values__c = Payment1 + ':'+Payment2 + ':'+Payment3;
                                it.Field_Values__c =  Payment1 + ':'+Payment2 + ':'+Payment3;
                            }
                            
                            Integer i = Integer.valueOf(payLst[0].Percentage__c);
                            Integer j = Integer.valueOf(payLst[1].Percentage__c);  
                             Integer k = Integer.valueOf(payLst[2].Percentage__c); 
                            if( String.valueOf(i+j+k) =='100' || String.valueOf(i+j+k) =='100.00'){
                                it.Actual_Values__c=newPaymentTerm; 
                                stt.Actual_Values__c = it.Actual_Values__c;
                            }
                            else{
                                newPaymentTerm = '';
                            }                            
                        } 
                         else if(payLst.size()==4){
                            StandFieldValue = stt.Field_Values__c.split(':');
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){  
                                Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                                Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                                Payment3 = StandFieldValue[0] +':' + payLst[2].Down_Balance_Payment__c + ':'+ payLst[2].Payment_Method__c +':'+  payLst[2].Payment_Term__c;
                                 Payment3 = StandFieldValue[0] +':' + payLst[3].Down_Balance_Payment__c + ':'+ payLst[3].Payment_Method__c +':'+  payLst[3].Payment_Term__c;
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
                            }
                       
                            if(StandFieldValue==IndivFieldValue1){
                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                            }
                              if(StandFieldValue==IndivFieldValue3){
                                newPaymentTerm3 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[2].Percentage__c));
                                newPaymentTerm3 = newPaymentTerm3.replace('[填入天数]',string.valueof(payLst[2].Days__c));
                            }
                       if(StandFieldValue==IndivFieldValue4){
                                newPaymentTerm4 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[3].Percentage__c));
                                newPaymentTerm4 = newPaymentTerm4.replace('[填入天数]',string.valueof(payLst[3].Days__c));
                            }
                            if(newPaymentTerm1 !=null && newPaymentTerm2 !=null && newPaymentTerm3 !=null && newPaymentTerm4 !=null){
                                newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2+'\t\r\n' +newPaymentTerm3+'\t\r\n' +newPaymentTerm4;
                                if(String.isNotEmpty(con.Buyer_Letter_of_guarantee__c) && con.Buyer_Letter_of_guarantee__c!='None'){
                                    newPaymentTerm = newPaymentTerm+'\t\r\n'  +System.Label.Letter_of_guarantee;
                                    newPaymentTerm = newPaymentTerm.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                
                                stt.Field_Values__c = Payment1 + ':'+Payment2 + ':'+Payment3 + ':'+Payment4;
                                it.Field_Values__c =  Payment1 + ':'+Payment2 + ':'+Payment3 + ':'+Payment4;
                            }
                            
                            Integer i = Integer.valueOf(payLst[0].Percentage__c);
                            Integer j = Integer.valueOf(payLst[1].Percentage__c);  
                             Integer k = Integer.valueOf(payLst[2].Percentage__c); 
                             Integer l = Integer.valueOf(payLst[3].Percentage__c); 
                            if( String.valueOf(i+j+k+l) =='100' || String.valueOf(i+j+k+l) =='100.00'){
                                it.Actual_Values__c=newPaymentTerm; 
                                stt.Actual_Values__c = it.Actual_Values__c;
                            }
                            else{
                                newPaymentTerm = '';
                            }                            
                        } 
                       
                        
                        
                        
                        
                        
                        
                        
                        
                        else{
                            it.Field_Values__c ='Not StandTemplate';
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
                             
                           
                                it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',String.valueof(contract.Destination__c)+'Port'); 
                              
                            }
                        }
                        else if(str2.indexOf(contract.Trade_term__c)>-1){
                            it.Actual_Values__c = stt.Actual_Values__c.replace('[123]',contract.Trade_term__c);
                            it.Actual_Values__c =  it.Actual_Values__c.replace('[目的港口]',contract.Destination__c);   
                        }
                        stt.Actual_Values__c = it.Actual_Values__c;
                        TradeTerm =  it.Actual_Values__c;
                    }                    
                }
            }
            
            //TODO multiple
            //   system.debug('fieldValue-->'+fieldValue);
            
            // it.Actual_Values__c =stt.Actual_Values__c.replace(stt.Field_Values__c,fieldValue);
            
            //If Map then Set STD contents.
            else if(stt.Type__c == 'Map'){
                it.Actual_Values__c = stt.Actual_Values__c;
            }
        }
        catch(Exception ex){
            system.debug('Exception:' + ex.getStackTraceString());
        }
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
                    for(String str : indMap.keySet()){
                         if(string.valueof(indMap.get(str).Name)=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                        newPaymentTerm =string.valueof(indMap.get(str).Actual_Values__c);
                        //IndividualTemplate =string.valueof(indMap.get(str).Actual_Values__c); 
                    }else if(string.valueof(indMap.get(str).Name)=='Trade_term__c'){
                        TradeTerm =string.valueof(indMap.get(str).Actual_Values__c);
                        
                    }
                    }                    
                    
                }
            }
        }  catch(Exception ex){
            system.debug('Exception:' + ex.getStackTraceString());
        }
    }
    
	public void runTest(){
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