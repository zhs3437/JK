public class PAUkraineAttachment2_Ctrl {
    public String Percentage{get;set;}
    public List<Payment__c> pay{get;set;}
    public Individual_Teams__c Dpay1{get;set;}
    public Individual_Teams__c Bpay1{get;set;}
    public Individual_Teams__c Dpay2{get;set;}
    public Individual_Teams__c Bpay2{get;set;}
     public String DDpay1{get;set;}
    public String BBpay1{get;set;}
    public String DDpay2{get;set;}
    public String BBpay2{get;set;}
    
    public String GuaranteedDeliveryDate{get;set;}
     public String GDay  {get;set;}
    public String GMonth{get;set;}
    public String GYear {get;set;}
    public String Address{get;set;}
    public String AuthorizedSignatory{get;set;}
    public String Title{get;set;}
    public String SellerVATNO{get;set;}
    public String Day  {get;set;}
    public String Month{get;set;}
    public String Year {get;set;}
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
    Public String FCA{get;set;}
    
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
    
  
    public String requestId{get;set;}
    
   
    public Contract coo{get;set;}
    public List<Contract> con{get;set;}
  
    public Opportunity opportunity{get;set;}
   
    public Account buyer{get;set;}
  
    
    
    public Date tod{get;set;}
   
    
    public List<Product_Detail__c> pds{get;set;}
    public Product_Detail__c pd {get;set;}
    public List<Component_Task_Book__c> ctbs{get;set;}
    public List<Information_of_Seller__c> ioss{get;set;}  
    public Information_of_Seller__c ios{get;set;}
    
    public PAUkraineAttachment2_Ctrl(ApexPages.StandardController controller) {
        
        
        
        
        
    }
    
    public void initialize(){
 String printPADate = ApexPages.currentPage().getParameters().get('id');
        con =[select Print_PA_Date__c,PA_Date__c,Contract_NO__c,BuyerAccount__r.Name,BuyerAccount__r.BillingAddress,BillingAddress,BuyerAccount__r.VAT_NO__c,BuyerAccount__r.Fax,
               BuyerAccount__r.Account_Address_Ukrainian__c,BuyerAccount__r.Actual_Sales_Name__c,Opportunity__r.IBAN__c,BuyerAccount__r.Account_Name_Ukrainian__c,BuyerAccount__r.Company_Email__c,BuyerAccount__r.Phone,SELLER__c,Buyer_s_representative_English__c,Buyer_s_representative_Ukraine__c,Authorized_Representative__c,Trade_term__c,Destination_port2__c,
               Port_of_Origin__c,Local_Warehouse__c,CurrencyIsoCode,BankInfo__r.Bank_Name__c,BankInfo__r.Address__c,BankInfo__r.BENEFICIARY_s_Name__c,
               BankInfo__r.BENEFICIARY_s_A_C__c,BankInfo__r.BENEFICIARY_s_Address__c,BankInfo__r.SWIFT__c,Bank_Information_Content__c,Owner.MobilePhone,Owner.Fax,Owner.Email,
               Opportunity__r.BankInfo_Name_Buyer__c,incoterm_version__c, Departure_Port__c,Destination__c,Opportunity__r.BENEFICIARY_s_Name_Buyer__c,Opportunity__r.BENEFICIARY_s_A_C_Buyer__c,Opportunity__r.BankInfo_Addr_Buyer__c,
               Opportunity__r.BENEFICIARY_s_Address_Buyer__c,Opportunity__r.SWIFT_Buyer__c,Basis_of_Representation_English__c,Basis_of_Representation_Ukraine__c
               from Contract where id =: printPADate];   
        FCA='0';
        if(con[0].Local_Warehouse__c!=null){
            if(con[0].Local_Warehouse__c.contains('Rotterdam') && con[0].Trade_term__c=='FCA'){
                FCA='1';
            }
            if(con[0].Local_Warehouse__c.contains('Piraeus') && con[0].Trade_term__c=='FCA'){
                FCA='2';
            }
        }
        
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
              Month = String.valueOf(Date.today().Month());
        }
        else{
            Month = String.valueOf(con[0].PA_Date__c.Month());
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
              Year  = String.valueOf(Date.today().Year());
        }
        else{
            Year = String.valueOf(con[0].PA_Date__c.Year());
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
        }else if(Month=='Nov'){Month='листопада';}else if(Month=='Dec'){Month='грудня';}
              if(con[0].PA_Date__c==null){
        Day   = String.valueOf(Date.today().Day());
        }
        else{
            Day   = String.valueOf(con[0].PA_Date__c.Day());
        }
        printtimeUK=String.valueOf(Day +'\t'+Month+'\t'+Year);
        system.debug('开始');
        String seller;
       
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
        if(ioss.size()>0){
        ios=ioss[0];
        }
        
        pds = [Select Id,Contract_PO_PI__c,Cable_length_UK__c,Quantity__c,Total_W__c,	Product_Name__c,Unit_WM__c,Total_Price__c,Unit_Price_Without_Commission__c,
               Battery_Type__c,Guaranteed_Delivery_Date__c,Unit_Price__c,Number_of_Cells__c,Weight__c,Dimensions__c,GuaranteedDeliveryDateAuto2__c
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
                
                 GDay   = String.valueOf(pd.Guaranteed_Delivery_Date__c.Day());
         if(GDay=='1'){ GDay=GDay+'st';}else if(GDay=='2'){GDay=GDay+'nd';}else if(GDay=='3'){GDay=GDay+'rd';}else if(GDay=='11'){GDay=GDay+'st';}else if(GDay=='12'){ GDay=GDay+'nd';}else if(GDay=='13'){GDay=GDay+'rd';}else if(GDay=='21'){GDay=GDay+'st';}else if(GDay=='22'){GDay=GDay+'nd';}else if(GDay=='23'){ GDay=GDay+'rd';}else if(GDay=='31'){ GDay=GDay+'st'; }else{GDay=GDay+'th';
        }
        GMonth = String.valueOf(pd.Guaranteed_Delivery_Date__c.Month());
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
        
        GYear  = String.valueOf(pd.Guaranteed_Delivery_Date__c.Year());
        GuaranteedDeliveryDate=String.valueOf(GMonth+'\t'+GDay+','+GYear);
        //total.GuaranteedDeliveryDateAuto__c=GuaranteedDeliveryDate;       
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
        buyerAddress=BillingStreet+','+BillingCity +','+BillingState+','+'\n'+BillingPostalCode
            +','+BillingCountry;
        
        //Preview 关联
        pay = [select id,Name,Payment_Method__c,DAYs__C,Percentage__c,Down_Balance_Payment__c,Amount__c from Payment__c where Contract__c =:printPADate];
        
        list<Individual_Teams__c> indList = [select id,
                                             Name,
                                             Field_Values__c,
                                             Actual_Values__c,
                                             Type__c,
                                             Contract__c
                                             from Individual_Teams__c 
                                             where Contract__c =:printPADate
                                             limit 1000];
        
        if(indList.size()==0){
               for(Payment__c P:pay){
                IF(P.Down_Balance_Payment__c=='Down Payment'){
                    DDpay1='The buyer shall pay '+P.Percentage__c+'% of the Total Purchase Price of the Goods as Down Payment by T/T within '+P.DAYs__C+' after the Execution Date of this Purchase Order';
                    DDpay2='Покупець оплачує '+P.Percentage__c+' % загальної Продажної ціни Товару – Передоплату, шляхом банківського переказу протягом '+P.DAYs__C+' днів з дати  цього Договору купівлі-продажу';
                   
                }
                IF(P.Down_Balance_Payment__c=='Balance Payment'){
                    BBpay1=' The buyer shall pay '+P.Percentage__c+'% of the  Purchase Price of the Goods as Balance Payment by T/T within '+ 
                        P.DAYs__C+' days after related Bill of Lading date of such Goods. Seller will inform Buyer by email that Goods are ready for being shipped from '+coo.Departure_Port__c+
                        ' 3 weeks before the Expected Time of Shipment on the condition that Seller has received the Down Payment of the Goods.';
                    String BBPAYUK;
                    if(coo.Departure_Port__c=='China Main Port'){
                        BBPAYUK='головного порту Китаю';
                    }else if(coo.Departure_Port__c=='Vietnam Main Port'){
                        BBPAYUK='головний порт В\'єтнаму';
                    }
                    BBpay2='Покупець оплачує  '+P.Percentage__c+'% Продажної ціни Товару як Решту Вартості шляхом банківського переказу протягом '+
                        P.DAYs__C+' днів після відповідної дати Коносаменту на такі Товари. Продавець проінформує Покупця по електронній пошті, що Товар готовий до відвантаження з '+BBPAYUK+
                        ' за 3 тижня до очікуваної дати відвантаження за умови, що Продавець отримав Передоплату за Товар. ';
                 
                }
                
            }
        }else if(indList.size()>0){
            for(Individual_Teams__c str : indList){
                if(Str.name=='Dpay1'){
                    Dpay1 =str;
                }
                if(Str.name=='Dpay2'){
                    Dpay2 =str;
                }
                if(Str.name=='Bpay1'){
                    Bpay1= str;
                }
                if(Str.name=='Bpay2'){
                    Bpay2= str;
                }
            }
         
        }
        
    }
    
}