public class QuoteModelController {
    //  public String requestId{get;set;}
    public Date tod{get;set;}
    public Quote q {get;set;}
    public List<CurrencyType> ctLst {get;set;}
    public String ctIsoCode{get;set;}
    public double ctConversionRate{get;set;}
    public Opportunity o{get;set;}
    public Account acc{get;set;}   //sam add 18/1/9
    public User user{get;set;}
    public String OppPaymentDescription{get;set;}
    public String companyName{get;set;}
    public String companyAdderss{get;set;}  
    public String companyPostcode{get;set;}
    public String companyTelFax{get;set;}
    public Information_of_Seller__c seller {get;set;}
    public List<QuoteLineItem> QuoteItemLst {get;set;}
    public Datetime LowDeliveryDate{get;set;} //最早交期
    public Datetime HighDeliveryDate{get;set;} //最晚交期
    public Date LowDelivery{get;set;}
    public Date HighDelivery{get;set;}
    public Decimal BalanceDue{get;set;}
    public Decimal ap{get;set;}
    public Integer ProductNumber{get;set;}
    public List<Integer> ProductNumberList{get;set;}
    public Map<String,Integer> ProductNumberMap{get;set;}
    private Integer lintNum=0;
    public QuoteModelController(ApexPages.StandardController stdController) {
        
        tod = Date.today();     
        ProductNumber =0;
        ProductNumberList =new List<Integer>();
        companyName=ApexPages.currentPage().getParameters().get('company');
        system.debug('------>company' + companyName);
        system.debug('------>company' + ApexPages.currentPage().getParameters().get('company'));
        
        if(stdController.getRecord()!=null){
            
            q = [Select id,
                 Name,
                 QuoteNumber,  //sam add
                 Additional_Request__c,
                 Discount,
                 Region__C,
                 BillingAddress,
                 EUContactName__c,     //sam add 2018/1/17
                 EUContactName__r.FirstName,    //sam add 2018/1/17
                 EUContactName__r.LastName,      //sam add 2018/1/17
                 EUContactName__r.Salutation,    //sam add 2018/1/17
                 Email_EU__c,      //sam add 2018/1/17
                 Fax_EU__c,        //sam add 2018/1/17
                 Phone_EU__c,      //sam add 2018/1/17
                 quoteManagerIcon__c,  //sam add 2018/1/18
                 quoteManagerIconTwo__c,//sam add 2018/1/18
                 OppOwnerIcon__c,    //sam add 2018/1/18
                 OppOwnerIconTwo__c, //sam add 2018/1/18
                 actualSalesIcon__c,    //sam add 2018/1/18
                 actualSalesIconTwo__c,  //sam add 2018/1/18
                 Contact_Name__c,
                 Create_Date__c,
                 Delivery_Terms__c,
                 Total_Price__c,
                 Opportunity.seller__c,
                 Account.Name, //sam add
                 Opportunity.Name,  //sam add
                 Validity_Of_The_Offer__c,  //sam add
                 Manager__c,
                 Offer_Validity__c,
                 CurrencyIsoCode,
                 AmountPaid__c,
                 TotalIncGST__c,
                 Actual_Sales_Name__c
                 From Quote
                 Where id =: ((Quote)stdController.getRecord()).id][0] ;
            ctLst =[Select id,ConversionRate,IsoCode from CurrencyType];
            //如果超过页面宽度则截取换行
            if(q.Region__C =='North Asia'){
                string ChangeStr ='';
                o = [select id,name,delivey_point__c,OwnerId,Trade_Term__c,Payment_Term_Description__c,Destination_Country__c,Seller__c,Project__c,Project__r.name from Opportunity where id=:q.OpportunityId];
                Pattern p = Pattern.compile('[a-zA-Z0-9.%()<|/]+'); 
                
                ChangeStr = o.Payment_Term_Description__c;
                if(String.isNotEmpty(ChangeStr)){
                    if(ChangeStr.indexOf(' ')>-1){
                        ChangeStr = ChangeStr.remove(' ');
                    }
                    if(ChangeStr.indexOf('\r\n')>-1){
                        ChangeStr = ChangeStr.remove('\r\n'); 
                    }
                    
                    Matcher m = p.matcher(ChangeStr);
                    system.debug('m-->'+m.matches());
                    if(m.matches()){
                        OppPaymentDescription = sendFild(o.Payment_Term_Description__c,100,'||');
                    }else{
                        OppPaymentDescription = sendFild(o.Payment_Term_Description__c,40,'||');
                        OppPaymentDescription = ChangeStr.remove('\r\n');
                    }           
                }
                
            }
            if(q.Region__C =='EU(Union)' || q.Region__C =='EU(Non-Eu)'){
                o = [select id,name,delivey_point__c,OwnerId,Trade_Term__c,Payment_Term_Description__c,Destination_Country__c,Seller__c,Project__c,Project__r.name from Opportunity where id=:q.OpportunityId];  //sam add 18/1/9
                user = [select id,name,Email,Title,Phone from User where id=: o.OwnerId];  //sam add 18/1/10
                acc = [select id,name from Account where id=: q.AccountId];     //sam add 18/1/9
            }
            else if(q.Region__C =='EU' || q.Region__C =='Non EU'){
                o = [select id,name,delivey_point__c,OwnerId,Trade_Term__c,Payment_Term_Description__c,Destination_Country__c,Seller__c,Project__c,Project__r.name from Opportunity where id=:q.OpportunityId];	//sam add 18/1/9
                user = [select id,name,Email,Title,Phone from User where id=: o.OwnerId];  //sam add 18/1/10
                acc = [select id,name from Account where id=: q.AccountId];   	//sam add 18/1/9
            }
            
            double db = 13.4324;
            db=((Integer)(db*100))/100.0; //注意：使用100.0 而不是 100
            system.debug('db'+db);
            for(CurrencyType ct:ctLst){
                if(ct.IsoCode=='JPY'){
                    ctIsoCode = ct.IsoCode;
                    ctConversionRate=((Integer)(ct.ConversionRate*100))/100.0;
                    system.debug('================IsoCode'+ctIsoCode);
                    system.debug('================CurrencyType'+ctConversionRate);
                }
                
            }
            system.debug('-------:q  ' + q);
            system.debug('-------:q Seller: ' + q.Opportunity.seller__c);
            if(q.AmountPaid__c != null ){
                ap = q.AmountPaid__c;
                BalanceDue = q.TotalIncGST__c - q.AmountPaid__c;
            }else{
                ap = 0;
                BalanceDue = q.TotalIncGST__c;
            }
            // Australia Quote
            //if (!Test.isRunningTest()) { 
            if(q.Region__C == 'ROA'){
                system.debug('123');
                seller = [select id,Address__c,Authorized_Signatory__c,Seller__c,Title__c,Seller_VAT_NO__c from Information_of_Seller__c where Seller__c =: q.Opportunity.seller__c];
                system.debug('------------------->>> : sellerinfo:' +seller );
            }               
            system.debug('234');    
            //}
            //system.debug('------------------->>> : address:' +seller.Address__c +' VAT :' + seller.Seller_VAT_NO__c );
            QuoteItemLst = [Select id,Description,QuoteId,Quantity,Product2.Name,UnitPrice,Product2.Maximum_Power_at_STC_Pmax__c,Total_Price__c,Total_MW__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c,ProductNo__c,Incoterms__c From QuoteLineItem Where QuoteId =: q.id Order by Guaranteed_Delivery_Date__c ASC ];
            system.debug('456');  
            system.debug('---------->>> Quotelineitem : ' + QuoteItemLst.size());
            //比较业务机会产品下面最快发货日期与最晚发货日期 by han 20171219
            //先比较年，在比较月，最后比较天
            for(QuoteLineItem qli: QuoteItemLst){
                system.debug('789');
                if(!string.isEmpty(String.valueOf(qli.Guaranteed_Delivery_Date__c))){
                    system.debug('111');
                    if(string.isEmpty(String.valueOf(LowDeliveryDate))){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date__c;
                        
                    }
                    system.debug('222');
                    if(LowDeliveryDate.year()-qli.Guaranteed_Delivery_Date__c.year()>0){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date__c;
                    }else if(LowDeliveryDate.year()-qli.Guaranteed_Delivery_Date__c.year()==0 && LowDeliveryDate.month()-qli.Guaranteed_Delivery_Date__c.month()>0){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date__c; 
                    }else if(LowDeliveryDate.year()-qli.Guaranteed_Delivery_Date__c.year()==0 &&  LowDeliveryDate.month()-qli.Guaranteed_Delivery_Date__c.month()==0 && LowDeliveryDate.day()-qli.Guaranteed_Delivery_Date__c.day()>0){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date__c; 
                    }
                    system.debug('333');
                    if(string.isEmpty(String.valueOf(HighDeliveryDate))){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date__c;
                    }
                    system.debug('444');
                    if(HighDeliveryDate.year()-qli.Guaranteed_Delivery_Date__c.year()<0){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date__c;
                    }else if(HighDeliveryDate.year()-qli.Guaranteed_Delivery_Date__c.year()==0 && HighDeliveryDate.month()-qli.Guaranteed_Delivery_Date__c.month()<0){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date__c; 
                    }else if(HighDeliveryDate.year()-qli.Guaranteed_Delivery_Date__c.year()==0 && LowDeliveryDate.month()-qli.Guaranteed_Delivery_Date__c.month()==0 && HighDeliveryDate.day()-qli.Guaranteed_Delivery_Date__c.day()<0){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date__c; 
                    }
                }
                system.debug('222');
                
                if(!string.isEmpty(String.valueOf(qli.Guaranteed_Delivery_Date_japan__c))){
                    system.debug('333');
                    if(string.isEmpty(String.valueOf(LowDeliveryDate))){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c;
                        
                    }
                    if(string.isEmpty(String.valueOf(HighDeliveryDate))){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c;
                    }
                    if(LowDeliveryDate.year()-qli.Guaranteed_Delivery_Date_japan__c.year()>0){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c;
                    }else if(LowDeliveryDate.year()-qli.Guaranteed_Delivery_Date_japan__c.year()== 0 && LowDeliveryDate.month()-qli.Guaranteed_Delivery_Date_japan__c.month()>0){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c; 
                    }else if(LowDeliveryDate.year()-qli.Guaranteed_Delivery_Date_japan__c.year()==0 && LowDeliveryDate.month()-qli.Guaranteed_Delivery_Date_japan__c.month()==0 && LowDeliveryDate.day()-qli.Guaranteed_Delivery_Date_japan__c.day()>0){
                        LowDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c; 
                    }
                    if(HighDeliveryDate.year()-qli.Guaranteed_Delivery_Date_japan__c.year()<0){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c;                       
                    }else if(HighDeliveryDate.year()-qli.Guaranteed_Delivery_Date_japan__c.year()==0 && HighDeliveryDate.month()-qli.Guaranteed_Delivery_Date_japan__c.month()<0){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c; 
                    }else if(HighDeliveryDate.year()-qli.Guaranteed_Delivery_Date_japan__c.year()==0 && LowDeliveryDate.month()-qli.Guaranteed_Delivery_Date_japan__c.month()==0 && HighDeliveryDate.day()-qli.Guaranteed_Delivery_Date_japan__c.day()<0){
                        HighDeliveryDate = qli.Guaranteed_Delivery_Date_japan__c;
                    }
                }
                
                ProductNumber =  ProductNumber +1;
                qli.ProductNo__c =ProductNumber;
                
                
            }
            ProductNumber=ProductNumber+1;
            if(!String.isEmpty(String.valueOf(LowDeliveryDate)) && !String.isEmpty(String.valueOf(HighDeliveryDate))){
                LowDelivery = date.valueOf(String.valueOf(LowDeliveryDate));
                HighDelivery = date.valueOf(String.valueOf(HighDeliveryDate));
            }
            
            for(QuoteLineItem ql : QuoteItemLst){
                system.debug('789');  
                if(string.isNotEmpty(ql.Description)){
                    if (ql.Description.length()>35) {
                        CsvStr cs = new CsvStr();
                        ql.Description = cs.convertString(ql.Description, 35);
                        
                        //update ql;
                        system.debug('---------->>> Quotelineitem Description : ' + ql.Description);
                    }else{
                        system.debug('---------->>> Quotelineitem Description222 : ' + ql.Description);
                        ql.Description = ql.Description;
                    }
                }else{
                    
                }
                //system.debug('--------------------->>>> ' + QuoteItemLst[0].Description);
                //system.debug('--------------------->>>> ' +  QuoteItemLst[1].Description);
                
                
            }
            system.debug('999');
            
            if(stdController.getRecord()!=null){
                if(companyName == 'JinkoSolar (PTY)LTD'){
                    companyAdderss  = 'GS 08, Rostra Building, The Forum, North Bank Lane';
                    companyPostcode  ='Century city, Cape Town';
                    companyTelFax  = 'Western Cape,South Africa,7441';
                    
                }else if(companyName == 'Jinko Solar Co., holding'){
                    companyAdderss = 'Jinko Building，99 shouyang Road,Jingan District,';
                    companyPostcode  ='Shanghai,China  Postcode:200072';
                    companyTelFax  = 'Tel: +86-21-51808777  Fax: +86-21-51808600';
                    
                }else if(companyName == 'Jinkosolar Middle East DMCC.'){
                    companyAdderss = 'BB1 Tower, Level 18, Mazaya Business Avenue';
                    companyPostcode  ='DMCC Free Zone, Jumeirah Lakes Towers';
                    companyTelFax  = 'Dubai, United Arab Emirate';
                    
                }else if(companyName == 'Jinko Solar (Italia) S.R.L.'){
                    companyAdderss = 'Via Bazzanese,32/7';
                    companyPostcode  ='40033 Casalecchio di Reno(BO), Italy';
                    companyTelFax  = 'Tel: +39 051 298 8511    Fax:+39 051 571 274';
                    
                }else if(companyName == 'Jinko Solar Italy'){
                    companyAdderss = 'Via Bazzanese 32/7';
                    companyPostcode  ='Casalechio di Reno (BO), Italy';
                          companyTelFax  = 'Tel: +39 051 298 8511    Fax:+39 051 571 274';
                  
                }
                else if(companyName == 'JinkoSolar Mexico'){
                    companyAdderss = 'Calle Durango N° 67,';
                    companyPostcode  ='oficina 101 y 102. Colonia Roma Norte. CP 06700,';
                    companyTelFax  = 'Mexico, DF.';
                    
                }
                else if(companyName == 'Jinkosolar Comercio do Brasil'){
                    companyAdderss = 'Adr Pedroso Alvarenga, 1046/1062,';
                    companyPostcode  ='sala 84 Itaim Bibi, ';
                    companyTelFax  = 'São Paulo/SP';
                    
                }
                else if(companyName == 'Jinko Solar Chile SPA.'){
                    companyAdderss = 'Cerro el Plomo 5931 Of. 507. Las Condes, ';
                    companyPostcode  ='Santiago, Chile';
                    
                }
                
                else if(companyName == 'Jinko Solar Co.,Ltd'){
                    companyAdderss = 'Jinko Building,#99 Shouyang Road,';
                    companyPostcode  ='Jingan Distrid,Shanghai,China';
                    companyTelFax  = '200072';
                }
                else if(companyName == 'ZHEJIANG JINKO SOLAR CO.,LTD'){
                    companyAdderss = 'No. 58 Yuanxi Road, Haining Yuanhua';
                    companyPostcode  ='Industrial Park';
                    companyTelFax  = 'Zhejiang Province, China 314416';
                } else if(companyName == 'ジンコソーラージャパン株式会社'){
                    companyAdderss = '〒104-0031 東京都中央区京橋二丁目2番1号 ';
                    companyPostcode  ='京橋エドグラン9階';
                    companyTelFax  = 'TEL:03-6262-6009　　  FAX:03-6262-3339';
                }
                else if(companyName == 'JINKO SOLAR TECHNOLOGY SDN.BHD.'){
                    companyAdderss = '2481, Tingkat Perusahaan 4,Kawasan';
                    companyPostcode  ='Perusahaan Bebas Perai, 13600 Perai ,';
                    companyTelFax  = 'Penang';
                } else if(companyName == 'Jinko Solar Import and Export Co., Ltd.'){
                    companyAdderss = 'Xuri Area, Shangrao Ecnomic ';
                    companyPostcode  ='Development Zone, Jiangxi Province';
                    // companyTelFax  = 'TEL:03-6262-6009　　  FAX:03-6262-3339';
                }
                else if(companyName == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                    companyAdderss = 'Level 7, 91 Phillip Street,';
                    companyPostcode  ='Parramatta NSW 2150';
                    //     companyTelFax  = 'TEL:03-6262-6009　　  FAX:03-6262-3339';
                }
                 else if(companyName == 'Jinko Solar Denmark Aps'){
                    companyAdderss = '	Gasværksvej 5, St tv,';
                    companyPostcode  ='DK-1656 København V,Denmark ';
                } 
                 else if(companyName == 'JinkoSolar (Switzerland) AG'){
                     companyAdderss = 'Chamerstrasse 85, ';
                    companyPostcode  ='6300 Zug, Switzerland';
                } 
            }
            system.debug('1010101');
        }
        
        
    }    
    public String sendFild(String fild,Integer num,String sStr){
        integer b =1;
        String rStr='';
        while(true) {
            integer pLength = fild.length()/num+1;
            String rStrs = fild.mid((b-1)*num,num);
            rStr+=rStrs+sStr;
            if(b==pLength){
                break;
            } 
            lintNum++;
            b++;
        }
        return rStr;
    }
    
    
    
}