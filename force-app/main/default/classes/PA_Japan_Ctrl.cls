public class PA_Japan_Ctrl {
	 //PAY
    public List<Payment__c> pay{get;set;}
    public Decimal Percentage1{get;set;}
    public String DownPay{get;set;}
      public String BanlancePay{get;set;}
    public Decimal 	AmountD{get;set;}
    public Decimal 	AmountB{get;set;}
    
    
    
	public String Address{get;set;}
	public String AuthorizedSignatory{get;set;}
	public String Title{get;set;}
    public String SellerVATNO{get;set;}
    
     public Decimal DownPayDecimal{get;set;}
    public Decimal BanlancePayDecimal{get;set;}
    public Boolean DownPayBoolean{get;set;}
    public Boolean BanlancePayBoolean{get;set;}
    public Boolean AuExBoolean{get;set;}
    public Boolean VnExBoolean{get;set;}
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
	 public Decimal fright{get;set;}
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
	
    public List<Product_Detail__c> pds {get;set;}
        public String yuenan {get;set;}
	public Information_of_Seller__c seller{get;set;}
	
    public PA_Japan_Ctrl(ApexPages.StandardController controller) {
       pds = new List<Product_Detail__c>();
         if (!Test.isRunningTest()){ controller.addFields(new List<String>{ 'ISCIF__c','Trade_term__c','PFI_Enadble__c','PIF_Not_CIF__c','Total_Freight__c','Insurance_for_CIF__c','Tax_Rate__c','Destination_Country__c','Destination_port2__c','IS_Special_Situations_in_Africa__c'});}
		// init - 创建PA/PI日期
		tt = new TodayTime();
        //item 的条数
		
        
        // init - apex date
		tod = Date.today();
		// init - requestId - Contract Id
		requestId = ApexPages.currentPage().getParameters().get('id');
		
		// init - Contract
		if(requestId != null)con = Database.query(Utils.MakeSelectSql('Contract') + ' WHERE Id =: requestId');
        AuExBoolean = false;
        VnExBoolean = false;
        if(con.Destination_Country__c	== 'Australia' && con.Trade_term__c == 'EXW'){
            AuExBoolean = true;
        }
         if(con.Destination_Country__c	== 'Vietnam' && con.Trade_term__c == 'EXW'){
            VnExBoolean = true;
        }
        yuenan='0';
        if(con.SELLER__c!='Jinkosolar (Vietnam) Co., Ltd.' && con.Destination_Country__c=='Vietnam'){
            yuenan='1';
        }else if(con.SELLER__c =='Jinkosolar (Vietnam) Co., Ltd.' && con.Destination_Country__c=='Vietnam'){
            yuenan='2';
        }
                List<opportunity> opp=[select id
                               ,Land_Freight_Oversea__c,
                               Land_Freight_China__c,
                               Ocean_Freight__c,
                                       Ocean_Freight_Oversea__c,
                                        Warehouse_Premium__c
                               from opportunity where id =:con.Opportunity__c]; 
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
            }
		/*
		 * 获取lineItem 的条数
		 */
         //pds = Database.query(Utils.MakeSelectSql('Product_Detail__c') + ' WHERE Contract_PO_PI__c =: requestId ORDER BY Guaranteed_Delivery_Date__c'); 
         pds = [select id,Product_name__c,lianjietou__c,Quantity__c,Total_MW__c ,Total_W__c,Unit_Price__c,Total_Price__c,Guaranteed_Delivery_Date__c,FOB_Unit_Price__c,Product__r.Maximum_Power_at_STC_Pmax__c,FOB_Total_Price__c from Product_Detail__c WHERE Contract_PO_PI__c =: requestId ORDER BY Guaranteed_Delivery_Date__c];
         items = pds.size();
        system.debug('-----pds' + pds.size());
        
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
        if(HaveModule == true && HaveConnector == true && con.Region__c.contains('EU')){
            HaveConnectorWarrantyEU =true;
        }else if(HaveModule == true && HaveConnector == true && !con.Region__c.contains('EU')){
            HaveConnectorWarrantyNoneEU = true;
        }
        
         HaveModuleWarrantyEU = false;
        HaveModuleWarrantyNoneEU = false;
        if(HaveModule == true && con.Region__c.contains('EU')){
            HaveModuleWarrantyEU =true;
        }else if(HaveModule == true && !con.Region__c.contains('EU')){
            System.debug('走进');
            HaveModuleWarrantyNoneEU = true;
        }
        HaveConnectorWarrantyEU_NoModule = false;
        HaveConnectorWarrantyNoneEU_NoModule = false;
        if(HaveModule ==false && HaveConnector == true && con.Region__c.contains('EU')){
            HaveConnectorWarrantyEU_NoModule = true;
            
            
        }
        if(HaveModule ==false && HaveConnector == true && !con.Region__c.contains('EU')){
		   HaveConnectorWarrantyNoneEU_NoModule = true;
        }
        
		// init - Buyer Account
		if(con != null && con.AccountId != null){
			String accountId = con.BuyerAccount__c;
			buyer = Database.query(Utils.MakeSelectSql('Account')  + ' WHERE Id =: accountId');
		}
		//contact person Email And Tel
		if (con.Contact_Person__c != null) {
            
            if(con.ChangeContractPerson__c !=null || con.ChangeContractPerson__c !=''){
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
			
		
			List<Govening_laws_and_arbitration__c>  glaas = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where Country__c =:buyer.Country__c ];
			system.debug('buyer.Country__c+++++++++++++++'+buyer.Country__c);
			system.debug('glass++++++++++++++++'+glaas);
		  //Govening_laws_and_arbitration__c glaa = null;
			if(glaas.size()>0)
			{
				
					con.Arbitration__c = glaas[0].Arbitration__c;
					con.Law__c= glaas[0].Law__c;

					system.debug('con.Arbitration__c+++++++++'+con.Arbitration__c);
					system.debug('con.LAW__c+++++++++++++++'+con.LAW__c);

			}else
			{
				List<Govening_laws_and_arbitration__c>  glaa = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where Area__c =: con.Region__c and Country__c like '%countries%'];
				system.debug('glaa++++++++++++++++'+glaa);
				if( glaa.size()>0)
				{
					con.Arbitration__c = glaa[0].Arbitration__c;
					con.Law__c= glaa[0].Law__c;

					system.debug('con.Arbitration__c+++++++++'+con.Arbitration__c);
					system.debug('con.LAW__c+++++++++++++++'+con.LAW__c);
				}
			}

if(con.Govening_laws_change__c!=null){
    if(con.Govening_laws_change__c=='China'){
        
				List<Govening_laws_and_arbitration__c>  glaa = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where Area__c =: 'ROA' and Country__c =:'Other countries in Asia Pacific'];
				system.debug('glaa++++++++++++++++'+glaa);
				if( glaa.size()>0)
				{
					con.Arbitration__c = glaa[0].Arbitration__c;
					con.Law__c= glaa[0].Law__c;

					system.debug('con.Arbitration__c+++++++++'+con.Arbitration__c);
					system.debug('con.LAW__c+++++++++++++++'+con.LAW__c);
				}
    }
    if(con.Govening_laws_change__c=='Singapore'){
        
				List<Govening_laws_and_arbitration__c>  glaa = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where  Country__c =: 'Singapore'];
				system.debug('glaa++++++++++++++++'+glaa);
				if( glaa.size()>0)
				{
					con.Arbitration__c = glaa[0].Arbitration__c;
					con.Law__c= glaa[0].Law__c;

					system.debug('con.Arbitration__c+++++++++'+con.Arbitration__c);
					system.debug('con.LAW__c+++++++++++++++'+con.LAW__c);
				}
    }
    
    if(con.Govening_laws_change__c=='Vietnam'){
        
				List<Govening_laws_and_arbitration__c>  glaa = [select id,Arbitration__c,Area__c,Country__c,Law__c from Govening_laws_and_arbitration__c where  Country__c =: 'Vietnam'];
				system.debug('glaa++++++++++++++++'+glaa);
				if( glaa.size()>0)
				{
					con.Arbitration__c = glaa[0].Arbitration__c;
					con.Law__c= glaa[0].Law__c;

					system.debug('con.Arbitration__c+++++++++'+con.Arbitration__c);
					system.debug('con.LAW__c+++++++++++++++'+con.LAW__c);
				}
    }
    
    
}





			
		/*	if(glaas.size() > 0){
				glaa = glaas[0];
			}
			if(glaa!=null){
				con.Arbitration__c = glaa.Arbitration__c;
				con.Law__c= glaa.Law__c;

				system.debug('con.Arbitration__c+++++++++'+con.Arbitration__c);
				system.debug('con.LAW__c+++++++++++++++'+con.LAW__c);
			} */
			
        }catch(Exception ex){
        	System.debug('--------> '+ex.getMessage());
        }
		
    }
    
	public PA_Japan_Ctrl(){
		
		
	}
	
	public void runTest(){
		String run = 'Test';
        run = 'Test';
	}
    
     public void Prite(){
        
        String printPADate = ApexPages.currentPage().getParameters().get('id');
       List<Contract> con = [select Print_PA_Date__c from Contract where id =: printPADate];
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
                      
            system.debug(co.Print_PA_Date__c );
        }
        update con;

        
    }
    
     public void PritePADate(){
        
       String printPADate = ApexPages.currentPage().getParameters().get('id');
       List<Contract> con = [select Print_PA_Date__c from Contract where id =: printPADate];
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
                      
            system.debug(co.Print_PA_Date__c );
        }
        update con;
         }
    
    
        public void initializeMea(){
        DownPayBoolean =false;
        BanlancePayBoolean =false;
        
          String printPADate = ApexPages.currentPage().getParameters().get('id');   
            //payment term
		 pay = [select id,Name,Payment_Method__c,DAYs__C,Payment_Term__c,Percentage__c,Down_Balance_Payment__c,Amount__c from Payment__c where Contract__c =:printPADate ORDER BY Down_Balance_Payment__c asc ,Percentage__c asc];
Decimal D=0;
            Decimal B=0;
            Percentage1=0;
            AmountD=0;
                AmountB=0;
         DownPayDecimal =0;
            BanlancePayDecimal =0;
        for(Payment__c p:pay){
            p.Comments__c=p.Payment_Term__c.replace('x%',p.Percentage__c+'%');
             p.Comments__c= p.Comments__c.replace('X%',p.Percentage__c+'%');
             p.Comments__c= p.Comments__c.replace('X days',p.DAYs__C+' days');  
             p.Comments__c= p.Comments__c.replace('x days',p.DAYs__C+' days');
            if(p.Down_Balance_Payment__c=='Down Payment'){
                DownPayBoolean = true;
                D=D+p.Percentage__c;
                Percentage1=Percentage1+p.Percentage__c;
                AmountD=AmountD+p.Amount__c;
            }else if(p.Down_Balance_Payment__c=='Balance Payment'){
                BanlancePayBoolean=true;
                B=B+p.Percentage__c;
                AmountB=AmountB+p.Amount__c;
                
            }
        }
              DownPay=String.valueOf(D);
              BanlancePay=String.valueOf(B);
            //Product Detail
            DownPayDecimal =D;
            BanlancePayDecimal =B;
            
        
    }
    
	
}