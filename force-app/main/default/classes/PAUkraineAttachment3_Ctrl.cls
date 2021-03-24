public class PAUkraineAttachment3_Ctrl {
public String Address{get;set;}
	public String AuthorizedSignatory{get;set;}
	public String Title{get;set;}
    public String SellerVATNO{get;set;}
     public String Day  {get;set;}
    public String Month{get;set;}
    public String Year {get;set;}
    public String printtime{get;set;}
    public String printtimeUK{get;set;}
	// 创建日期

	
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
	public List<Contract> con{get;set;}
    public Contract coo{get;set;}
	// Current Opportunity
	public Opportunity opportunity{get;set;}
	// Current Account
	public Account buyer{get;set;}
	// Current Date
	 public Decimal fright{get;set;}
	//public TodayTime tt{get;set;}
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
	
    public PAUkraineAttachment3_Ctrl(ApexPages.StandardController controller) {
  
    

	

    }
    
    public void initialize(){
         String printPADate = ApexPages.currentPage().getParameters().get('id');
        con =[select Print_PA_Date__c,PA_Date__c,Contract_NO__c,BuyerAccount__r.Name,BuyerAccount__r.BillingAddress,BillingAddress,BuyerAccount__r.VAT_NO__c,BuyerAccount__r.Fax,
               BuyerAccount__r.Account_Address_Ukrainian__c,BuyerAccount__r.Actual_Sales_Name__c,Opportunity__r.IBAN__c,BuyerAccount__r.Account_Name_Ukrainian__c,BuyerAccount__r.Company_Email__c,BuyerAccount__r.Phone,SELLER__c,Buyer_s_representative_English__c,Buyer_s_representative_Ukraine__c,Authorized_Representative__c,Trade_term__c,Destination_port2__c,
               Port_of_Origin__c,CurrencyIsoCode,BankInfo__r.Bank_Name__c,BankInfo__r.Address__c,BankInfo__r.BENEFICIARY_s_Name__c,
               BankInfo__r.BENEFICIARY_s_A_C__c,BankInfo__r.BENEFICIARY_s_Address__c,BankInfo__r.SWIFT__c,Bank_Information_Content__c,Owner.MobilePhone,Owner.Fax,Owner.Email,
               Opportunity__r.BankInfo_Name_Buyer__c,Departure_Port__c,Destination__c,Opportunity__r.BENEFICIARY_s_Name_Buyer__c,Opportunity__r.BENEFICIARY_s_A_C_Buyer__c,Opportunity__r.BankInfo_Addr_Buyer__c,
               Opportunity__r.BENEFICIARY_s_Address_Buyer__c,Opportunity__r.SWIFT_Buyer__c,Basis_of_Representation_English__c,Basis_of_Representation_Ukraine__c
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
            Month='Jan';
        }else if(Month=='2'){
            Month='Feb';
        }else if(Month=='3'){
            Month='Mar';
        }else if(Month=='4'){
            Month='Apr';
        }else if(Month=='5'){
            Month='May';
        }else if(Month=='6'){
            Month='Jun';
        }else if(Month=='7'){
            Month='Jul';
        }else if(Month=='8'){
            Month='Aug';
        }else if(Month=='9'){
            Month='Sep';
        }else if(Month=='10'){
            Month='Oct';
        }else if(Month=='11'){
            Month='Nov';
        }else if(Month=='12'){
            Month='Dec';
        }
        if(con[0].PA_Date__c==null){
        Year   = String.valueOf(Date.today().Year());
        }
        else{
            Year   = String.valueOf(con[0].PA_Date__c.Year());
        }
        printtime=String.valueOf(Month+'\t'+Day+',\t'+Year);
           if(Month=='Jan'){
            Month='січня';
        }else if(Month=='Feb'){
            Month='лютого';
        }else if(Month=='Mar'){
            Month='березня';
        }else if(Month=='Apr'){
            Month='квітня';
        }else if(Month=='May'){
            Month='травня';
        }else if(Month=='Jun'){
            Month='червня';
        }else if(Month=='Jul'){
            Month='липня';
        }else if(Month=='Aug'){
            Month='серпня';
        }else if(Month=='Sep'){
            Month='вересня';
        }else if(Month=='Oct'){
            Month='жовтня';
        }else if(Month=='Nov'){
            Month='листопада';
        }else if(Month=='Dec'){
            Month='грудня';
        }
if(con[0].PA_Date__c==null){
        Day   = String.valueOf(Date.today().Day());
        }
        else{
            Day   = String.valueOf(con[0].PA_Date__c.Day());
        }        

        
        printtimeUK=String.valueOf(Day +'\t'+Month+'\t'+Year);
        system.debug('开始');
         
      
        system.debug('con:'+con[0]);
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
                   
            system.debug(co.Print_PA_Date__c );
        }
        update con;
        coo=con[0];


        
        
      
     
     

    }
}