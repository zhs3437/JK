public class UkrainePreview_Ctrl {
 public String Address{get;set;}
    public String AuthorizedSignatory{get;set;}
    public String Title{get;set;}
    public String SellerVATNO{get;set;}
    public String Day  {get;set;}
    public String Month{get;set;}
    public String Year {get;set;}
    public String printtime{get;set;}
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
    //public TodayTime tt{get;set;}
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
    
    public UkrainePreview_Ctrl(ApexPages.StandardController controller) {
        
        
        
        
        
    }
    
    public void initialize(){
        Day   = String.valueOf(Date.today().Day());
        Month = String.valueOf(Date.today().Month());
        Year  = String.valueOf(Date.today().Year());
        printtime=String.valueOf(Year+'-'+Month+'-'+Day);
        
        system.debug('开始');
        String seller;
        String printPADate = ApexPages.currentPage().getParameters().get('id');
        con = [select Print_PA_Date__c,Contract_NO__c,BuyerAccount__r.Name,BuyerAccount__r.BillingAddress,BillingAddress,BuyerAccount__r.VAT_NO__c,BuyerAccount__r.Fax,
               BuyerAccount__r.Company_Email__c,BuyerAccount__r.Phone,SELLER__c,Authorized_Representative__c,Trade_term__c,Destination_port2__c,
               Port_of_Origin__c,CurrencyIsoCode,BankInfo__r.Bank_Name__c,BankInfo__r.Address__c,BankInfo__r.BENEFICIARY_s_Name__c,
               BankInfo__r.BENEFICIARY_s_A_C__c,BankInfo__r.BENEFICIARY_s_Address__c,BankInfo__r.SWIFT__c,Bank_Information_Content__c,
               Product__c
               from Contract where id =: printPADate];
        system.debug('con:'+con[0]);
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
            seller=co.SELLER__c;         
            system.debug(co.Print_PA_Date__c );
        }
        update con;
        coo=con[0];
        system.debug('coo:'+coo);
        ioss = [SELECT Seller__c,Address__c,Seller_VAT_NO__c FROM Information_of_Seller__c WHERE Seller__c=:seller];
        
        ios=ioss[0];
        
        pds = [Select Id,Contract_PO_PI__c,Quantity__c,Total_W__c,	Product_Name__c,Unit_WM__c,Total_Price__c,Unit_Price_Without_Commission__c,
               Battery_Type__c,GuaranteedDeliveryDateAuto2__c
               From Product_Detail__c Where Contract_PO_PI__c =: printPADate];
        
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
        buyerAddress=BillingStreet+','+BillingCity+','+BillingState+','+BillingPostalCode+','+BillingCountry;
        
        
        
    }
}