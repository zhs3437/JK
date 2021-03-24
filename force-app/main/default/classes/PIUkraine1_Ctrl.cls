public class PIUkraine1_Ctrl {
     public List<Payment__c> pay{get;set;}
    public String DownPay{get;set;}
      public String BanlancePay{get;set;}
        public Decimal DownPayD{get;set;}
      public Decimal BanlancePayB{get;set;}
    public Decimal 	AmountD{get;set;}
    public Decimal 	AmountB{get;set;}
    
  public String DownPay2{get;set;}
      public String BanlancePay2{get;set;}
        public Decimal DownPayD2{get;set;}
      public Decimal BanlancePayB2{get;set;}
    public Decimal 	AmountD2{get;set;}
    public Decimal 	AmountB2{get;set;}    
    
    
    
    
public String Address{get;set;}
	public String AuthorizedSignatory{get;set;}
	public String Title{get;set;}
    public String SellerVATNO{get;set;}
     public String Day  {get;set;}
    public String Month{get;set;}
    public String Year {get;set;}
         public String Daylog  {get;set;}
    public String Monthlog{get;set;}
    public String Yearlog {get;set;}
    public String printtime{get;set;}
    public String printtimeUK{get;set;}
    public Decimal T_PCS{get;set;}
    public Decimal T_WPS{get;set;}
    public Decimal T_PurchasePrice{get;set;}
    public String CellNumber{get;set;}
     public List<Account> Orderlst{get;set;}
    public String BillingCity{get;set;}
    public String BillingCountry{get;set;}
    public String BillingPostalCode{get;set;}
    public String BillingState{get;set;}
    public String BillingStreet{get;set;}
    //Buyer BilingAddress
    public String buyerAddress{get;set;}
	 public String GuaranteedDeliveryDate{get;set;}
	 public String GDay  {get;set;}
    public String GMonth{get;set;}
    public String GYear {get;set;}
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
    public Contract coo{get;set;}
    public List<Contract> con{get;set;}
	// Current Opportunity
	public Opportunity opportunity{get;set;}
	// Current Account
	public Account buyer{get;set;}
	// Current Date
	 public Decimal fright{get;set;}
	
	// Current Basic Information
	public BasicInfo bi{get;set;}
	
	// Current Date - Apex Date
	public Date tod{get;set;}
    public integer items{get;set;}
    //Contact person info
    public String ContactEmail{get;set;}
    public String ContactTel{get;set;}
    //Current Contract Product 
	
    public List<Product_Detail__c> pds{get;set;}
    public Product_Detail__c pd {get;set;}
    public List<Component_Task_Book__c> ctbs{get;set;}
    public List<Information_of_Seller__c> ioss{get;set;}  
    public Information_of_Seller__c ios{get;set;}
    
    
    
    
	
    public PIUkraine1_Ctrl(ApexPages.StandardController controller) {
  
    

	

    }
    
    public void initialize(){
         String printPADate = ApexPages.currentPage().getParameters().get('id');
        con = [select Print_PA_Date__c,PA_Date__c,Contract_NO__c,BuyerAccount__r.Name,BuyerAccount__r.BillingAddress,BillingAddress,BuyerAccount__r.VAT_NO__c,BuyerAccount__r.Fax,
               BuyerAccount__r.Company_Email__c,BuyerAccount__r.Phone,SELLER__c,Authorized_Representative__c,Trade_term__c,Destination_port2__c,Destination_Country__c,
               Port_of_Origin__c,CurrencyIsoCode,BankInfo__r.Bank_Name__c,Legal_Dept_Finish_Time__c,BankInfo__r.Address__c,BankInfo__r.BENEFICIARY_s_Name__c,
               BankInfo__r.BENEFICIARY_s_A_C__c,Invoice_No__c,BankInfo__r.BENEFICIARY_s_Address__c,BankInfo__r.SWIFT__c,Bank_Information_Content__c,
               Product__c,Payment_Term_Description__c
               from Contract where id =: printPADate];
           if(con[0].PA_Date__c==null){
        Day   = String.valueOf(Date.today().Day());
        }
        else{
            Day   = String.valueOf(con[0].PA_Date__c.Day());
        }
         if(Day=='1'){
            Day=Day+'st';
        }else if(Day=='2'){
            Day=Day+'nd';
        }else if(Day=='3'){
            Day=Day+'rd';
        }else if(Day=='21'){
            Day=Day+'st';            
        }else if(Day=='22'){
            Day=Day+'nd';
        }else if(Day=='23'){
            Day=Day+'rd';
        }else if(Day=='31'){
            Day=Day+'st';
        }else{
            Day=Day+'th';
        }
          if(con[0].PA_Date__c==null){
        Month   = String.valueOf(Date.today().Month());
        }
        else{
            Month   = String.valueOf(con[0].PA_Date__c.Month());
        }
        system.debug('月份-------------------->'+Month);
        
        if(Month=='1'){
            Month='Jan.';
        }else if(Month=='2'){
            Month='Feb.';
        }else if(Month=='3'){
            Month='Mar.';
        }else if(Month=='4'){
            Month='Apr.';
        }else if(Month=='5'){
            Month='May';
        }else if(Month=='6'){
            Month='Jun.';
        }else if(Month=='7'){
            Month='Jul.';
        }else if(Month=='8'){
            Month='Aug.';
        }else if(Month=='9'){
            Month='Sep.';
        }else if(Month=='10'){
            Month='Oct.';
        }else if(Month=='11'){
            Month='Nov.';
        }else if(Month=='12'){
            Month='Dec.';
        }
        if(con[0].PA_Date__c==null){
        Year   = String.valueOf(Date.today().Year());
        }
        else{
            Year   = String.valueOf(con[0].PA_Date__c.Year());
        }
        printtime=String.valueOf(Month+'\t'+Day+','+Year);
        if(Month=='1'){
            Month='січня';
        }else if(Month=='2'){
            Month='лютого';
        }else if(Month=='3'){
            Month='березня';
        }else if(Month=='4'){
            Month='квітня';
        }else if(Month=='5'){
            Month='травня';
        }else if(Month=='6'){
            Month='червня';
        }else if(Month=='7'){
            Month='липня';
        }else if(Month=='8'){
            Month='серпня';
        }else if(Month=='9'){
            Month='вересня';
        }else if(Month=='10'){
            Month='жовтня';
        }else if(Month=='11'){
            Month='листопада';
        }else if(Month=='12'){
            Month='грудня';
        }
        printtimeUK=String.valueOf(Day +'\t'+Month+'\t'+Year);
        system.debug('开始');
        String seller;
       
        if(con.size()>0){
             for( Contract co:con){
            co.Print_PA_Date__c =date.today();
            seller=co.SELLER__c;         
            system.debug(co.Print_PA_Date__c );
        }
        update con;
        coo=con[0];
        system.debug('coo:'+coo);
            
            if(coo.Legal_Dept_Finish_Time__c!=null){
                
                 Daylog   = String.valueOf(coo.Legal_Dept_Finish_Time__c.Day());
        if(Daylog=='1'){
            Daylog=Daylog+'st';
        }else if(Daylog=='2'){
            Daylog=Daylog+'nd';
        }else if(Daylog=='3'){
            Daylog=Daylog+'rd';
        }else if(Daylog=='11'){
            Daylog=Daylog+'st';
        }else if(Daylog=='12'){
            Daylog=Daylog+'nd';
        }else if(Daylog=='13'){
            Daylog=Daylog+'rd';
        }else if(Daylog=='21'){
            Daylog=Daylog+'st';            
        }else if(Daylog=='22'){
            Daylog=Daylog+'nd';
        }else if(Daylog=='23'){
            Daylog=Daylog+'rd';
        }else if(Daylog=='31'){
            Daylog=Daylog+'st';
        }else{
            Daylog=Daylog+'th';
        }
        Monthlog = String.valueOf(coo.Legal_Dept_Finish_Time__c.Month());
        
        if(Monthlog=='1'){
            Monthlog='Jan';
        }else if(Monthlog=='2'){
            Monthlog='Feb';
        }else if(Monthlog=='3'){
            Monthlog='Mar';
        }else if(Monthlog=='4'){
            Monthlog='Apr';
        }else if(Monthlog=='5'){
            Monthlog='May';
        }else if(Monthlog=='6'){
            Monthlog='Jun';
        }else if(Monthlog=='7'){
            Monthlog='Jul';
        }else if(Monthlog=='8'){
            Monthlog='Aug';
        }else if(Monthlog=='9'){
            Monthlog='Sep';
        }else if(Monthlog=='10'){
            Monthlog='Oct';
        }else if(Monthlog=='11'){
            Monthlog='Nov';
        }else if(Monthlog=='12'){
            Monthlog='Dec';
        }
        
        Yearlog  = String.valueOf(coo.Legal_Dept_Finish_Time__c.Year());
            }
        }
       
        ioss = [SELECT Seller__c,Address__c,Seller_VAT_NO__c FROM Information_of_Seller__c WHERE Seller__c=:seller];
        if(ioss.size()>0){
        ios=ioss[0];
        }
        
        pds = [Select Id,Contract_PO_PI__c,Quantity__c,Total_W__c,	Product_Name__c,Unit_WM__c,Total_Price__c,Unit_Price_Without_Commission__c,
               Battery_Type__c,Unit_Price__c,Guaranteed_Delivery_Date__c,GuaranteedDeliveryDateAuto2__c 
               From Product_Detail__c Where Contract_PO_PI__c =: printPADate];
        if(pds.size()>0){
            GDay   = String.valueOf(pds[0].Guaranteed_Delivery_Date__c.Day());
        
         if(GDay=='1'){
            GDay=GDay+'st';
        }else if(GDay=='2'){
            GDay=GDay+'nd';
        }else if(GDay=='3'){
            GDay=GDay+'rd';
        }else if(GDay=='11'){
            GDay=GDay+'st';
        }else if(GDay=='12'){
            GDay=GDay+'nd';
        }else if(GDay=='13'){
            GDay=GDay+'rd';
        }else if(GDay=='21'){
            GDay=GDay+'st';            
        }else if(GDay=='22'){
            GDay=GDay+'nd';
        }else if(GDay=='23'){
            GDay=GDay+'rd';
        }else if(GDay=='31'){
            GDay=GDay+'st';
        }else{
            GDay=GDay+'th';
        }
        GMonth = String.valueOf(pds[0].Guaranteed_Delivery_Date__c.Month());
        system.debug('月份-------------------->'+Month);
        
        if(GMonth=='1'){
            GMonth='Jan.';
        }else if(GMonth=='2'){
            GMonth='Feb.';
        }else if(GMonth=='3'){
            GMonth='Mar.';
        }else if(GMonth=='4'){
            GMonth='Apr.';
        }else if(GMonth=='5'){
            GMonth='May';
        }else if(GMonth=='6'){
            GMonth='Jun.';
        }else if(GMonth=='7'){
            GMonth='Jul.';
        }else if(GMonth=='8'){
            GMonth='Aug.';
        }else if(GMonth=='9'){
            GMonth='Sep.';
        }else if(Month=='10'){
            GMonth='Oct.';
        }else if(GMonth=='11'){
            GMonth='Nov.';
        }else if(GMonth=='12'){
            GMonth='Dec.';
        }
        
        GYear  = String.valueOf(pds[0].Guaranteed_Delivery_Date__c.Year());
        GuaranteedDeliveryDate=String.valueOf(GMonth+'\t'+GDay+','+GYear);
        }
        
        
        ctbs=[Select Id,Contract__c,Cell_Quantity1__c From Component_Task_Book__c Where Contract__c=:printPADate];
        //取电池数量
        if(ctbs.size()>0){
            
            CellNumber=ctbs[0].Cell_Quantity1__c;
            
            
            
            
        }
        
        
        //初始化总价
        T_PCS=0;
        T_WPS=0;
        T_PurchasePrice=0;
        //计算总价
        if(pds.size()>0){
            pd=pds[0];
            
            for(Product_Detail__c total:pds){
                if(total.Quantity__c==null){
                    total.Quantity__c=0;
                }
                if(total.Total_Price__c==null){
                    total.Total_Price__c=0;
                }
                
                T_PCS =(Decimal)total.Quantity__c+T_PCS;
                T_WPS =(Decimal)total.Total_W__c+T_WPS;
                T_PurchasePrice =(Decimal)total.Total_Price__c+T_PurchasePrice;
                
            }
        }
        //买放地址拼接
          Orderlst=[Select Id,Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet From Account Where Id=:coo.BuyerAccount__c];
        if(Orderlst.size()>0){
            BillingCity=Orderlst[0].BillingCity;
            BillingCountry=Orderlst[0].BillingCountry;
            BillingPostalCode=Orderlst[0].BillingPostalCode;
            BillingState=Orderlst[0].BillingState;
            BillingStreet=Orderlst[0].BillingStreet;
        }
        if(BillingState !=null){
            buyerAddress=BillingStreet+','+BillingCity+'\n'+BillingState+','+BillingPostalCode+','+BillingCountry;
        }else{
            buyerAddress=BillingStreet+','+BillingCity+'\n'+BillingPostalCode+','+BillingCountry;
        }
        
       
		//payment term
		 pay = [select id,Name,Payment_Method__c,DAYs__C,Percentage__c,Down_Balance_Payment__c,Amount__c from Payment__c where Contract__c =:printPADate];
			system.debug('返回pay的长度'+pay.size());
        	system.debug('百分数'+pay[0].Percentage__c);
       /* for(Payment__c p:pay){     
            if(p.Down_Balance_Payment__c=='Down Payment'){
                DownPayD=p.Percentage__c;
                DownPay=String.valueOf(p.Percentage__c);
                AmountD=p.Amount__c;
            }else if(p.Down_Balance_Payment__c=='Balance Payment'){
                BanlancePayB=p.Percentage__c;
                BanlancePay=String.valueOf(p.Percentage__c);
                AmountB=p.Amount__c;
            }
     
        }*/
        
        
        //new
        if(pay.size()==1){
           
            if(pay[0].Down_Balance_Payment__c=='Down Payment'){
                system.debug('进入测试开始');
                DownPayD=pay[0].Percentage__c;
                DownPay=String.valueOf(pay[0].Percentage__c);
                AmountD=pay[0].Amount__c;
                system.debug('DownPayD----------'+DownPayD);
                system.debug('DownPay----------'+DownPay);
                system.debug('AmountD----------'+AmountD);
                system.debug('进入测试结束');
            }else if(pay[0].Down_Balance_Payment__c=='Balance Payment'){
                BanlancePayB=pay[0].Percentage__c;
                BanlancePay=String.valueOf(pay[0].Percentage__c);
                AmountB=pay[0].Amount__c;
            }
        }
        if(pay.size()==2){
                   if(pay[0].Down_Balance_Payment__c=='Down Payment'){
                system.debug('进入测试开始');
                DownPayD=pay[0].Percentage__c;
                DownPay=String.valueOf(pay[0].Percentage__c);
                AmountD=pay[0].Amount__c;
                system.debug('DownPayD----------'+DownPayD);
                system.debug('DownPay----------'+DownPay);
                system.debug('AmountD----------'+AmountD);
                system.debug('进入测试结束');
            }else if(pay[0].Down_Balance_Payment__c=='Balance Payment'){
                BanlancePayB=pay[0].Percentage__c;
                BanlancePay=String.valueOf(pay[0].Percentage__c);
                AmountB=pay[0].Amount__c;
            }
            
            
            
             if(pay[1].Down_Balance_Payment__c=='Down Payment'){
                DownPayD2=pay[1].Percentage__c;
                DownPay2=String.valueOf(pay[1].Percentage__c);
                AmountD2=pay[1].Amount__c;
            }else if(pay[1].Down_Balance_Payment__c=='Balance Payment'){
                BanlancePayB2=pay[1].Percentage__c;
                BanlancePay2=String.valueOf(pay[1].Percentage__c);
                AmountB2=pay[1].Amount__c;
            }
        }
		        
        
        
        if(DownPayD==null){
            DownPayD=0;
          // DownPayD2=0; 
        }
		if(DownPayD2==null){
           // DownPayD=0;
           DownPayD2=0; 
        }
                if(BanlancePayB==null){
            BanlancePayB=0;
                    //BanlancePayB2=0;
        }
          if(BanlancePayB2==null){
            //BanlancePayB=0;
                    BanlancePayB2=0;
        }
        
      
     
     

    }
}