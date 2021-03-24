public class UkrainePreviewctrl {
    public String Day  {get;set;}
    public String Day2  {get;set;}
    public String Month{get;set;}
    public String Year {get;set;}
    public String GuaranteedDeliveryDate{get;set;}
    public String GDay  {get;set;}
    public String GMonth{get;set;}
    public String GYear {get;set;}
    
    
    Public String printtime{get;set;}
    Public String printtimeUK{get;set;}
    Public String printtimeADD4{get;set;}
    public Information_of_Seller__c ios{get;set;}
    public Contract con{get;set;}
    public List<Product_Detail__c> pds{get;set;}
    public Product_Detail__c pd{get;set;}
    public Decimal T_PCS{get;set;}
    public Decimal T_WPS{get;set;}
    public Decimal T_PurchasePrice{get;set;}
    public List<Payment__c> pay{get;set;}
    public Individual_Teams__c Basic1{get;set;}
    public Individual_Teams__c Basic2{get;set;}
    public Individual_Teams__c Dpay1{get;set;}
    public Individual_Teams__c Bpay1{get;set;}
    public Individual_Teams__c Dpay2{get;set;}
    public Individual_Teams__c Bpay2{get;set;}
   // public Individual_Teams__c DownPayment1{get;set;}
	//public Individual_Teams__c DownPayment2{get;set;}    
    //新增 20200304
    public Individual_Teams__c Dpay1_2{get;set;}
    public Individual_Teams__c Bpay1_2{get;set;}
    public Individual_Teams__c Dpay2_2{get;set;}
    public Individual_Teams__c Bpay2_2{get;set;}
    //20200304
    
    public Individual_Teams__c X01{get;set;}
    public Individual_Teams__c X02{get;set;}
    public UkrainePreviewctrl(ApexPages.StandardController controller) {
        system.debug('chushihua'+Dpay1);
        work();
    }
    public void work(){
        
        Day   = String.valueOf(Date.today().Day());
        Day2   = String.valueOf(Date.today().Day()+4);
        if(Day=='1'){
            Day=Day+'st';
        }else if(Day=='2'){
            Day=Day+'nd';
        }else if(Day=='3'){
            Day=Day+'rd';
        }else if(Day=='11'){
            Day=Day+'st';
        }else if(Day=='12'){
            Day=Day+'nd';
        }else if(Day=='13'){
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
        
        if(Day2=='1'){
            Day2=Day2+'st';
        }else if(Day2=='2'){
            Day2=Day2+'nd';
        }else if(Day2=='3'){
            Day2=Day2+'rd';
        }else if(Day2=='11'){
            Day2=Day2+'st';
        }else if(Day2=='12'){
            Day2=Day2+'nd';
        }else if(Day2=='13'){
            Day2=Day2+'rd';
        }else if(Day2=='21'){
            Day2=Day2+'st';            
        }else if(Day2=='22'){
            Day2=Day2+'nd';
        }else if(Day2=='23'){
            Day2=Day2+'rd';
        }else if(Day2=='31'){
            Day2=Day2+'st';
        }else{
            Day2=Day2+'th';
        }
        
        Month = String.valueOf(Date.today().Month());
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
        
        Year  = String.valueOf(Date.today().Year());
        printtime=String.valueOf(Month+'\t'+Day+',\t'+Year);        
        
        printtimeADD4=String.valueOf(Month+'\t'+Day2+','+Year);
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
        Day   = String.valueOf(Date.today().Day());
        printtimeUK=String.valueOf(Day +'\t'+Month+'\t'+Year);
        //以上都是计算时间
        
        // String printPADate = ApexPages.currentPage().getParameters().get('id');
        
        // system.debug('ExcuteId-------------------->'+ExcuteId);
        
        
        String printPADate = ApexPages.currentPage().getParameters().get('id');
        system.debug('id:'+printPADate);  
        con = [select Print_PA_Date__c,Basis_of_Representation_English__c,Basis_of_Representation_Ukraine__c,Contract_NO__c,BuyerAccount__r.Name,BuyerAccount__r.Actual_Sales_Name__c,BuyerAccount__r.BillingAddress,BillingAddress,BuyerAccount__r.VAT_NO__c,BuyerAccount__r.Fax,
               BuyerAccount__r.Company_Email__c,BuyerAccount__r.Account_Name_Ukrainian__c,BuyerAccount__r.Phone,SELLER__c,Authorized_Representative__c,Trade_term__c,Destination_port2__c,Destination__c,BuyerAccount__r.owner.naME,
               Port_of_Origin__c,CurrencyIsoCode,BankInfo__r.Bank_Name__c,Payment_Term_Description__c,PaymentTermStand__c,Buyer_s_representative_English__c,Buyer_s_representative_Ukraine__c,BankInfo__r.Address__c,BankInfo__r.BENEFICIARY_s_Name__c,Departure_Port__c,
               BankInfo__r.BENEFICIARY_s_A_C__c,BankInfo__r.BENEFICIARY_s_Address__c,BankInfo__r.SWIFT__c,Bank_Information_Content__c,OwnerId,Owner.BMO_specialist__c
               from Contract where id =: printPADate];
        
        pay = [select id,Name,Payment_Method__c,DAYs__C,Percentage__c,Down_Balance_Payment__c,Amount__c,Payment_Term__c from Payment__c where Contract__c =:printPADate];
        list<Individual_Teams__c> indList = [select id,
                                             Name,
                                             Field_Values__c,
                                             Actual_Values__c,
                                             Type__c,
                                             Contract__c
                                             from Individual_Teams__c 
                                             where Contract__c =:printPADate
                                             limit 1000];
        System.debug('Dpay1-------->'+Dpay1);
        //System.debug('DownPayment1-------->'+DownPayment1);
        if(indList.size()==0 && Dpay1==null){
            System.debug('是否成功进入这里');
            Dpay1=NEW Individual_Teams__c();
            Dpay2=NEW Individual_Teams__c();
            Bpay1=NEW Individual_Teams__c();
            Bpay2=NEW Individual_Teams__c();
            //新增 20200304
            Dpay1_2=NEW Individual_Teams__c();
            Dpay2_2=NEW Individual_Teams__c();
            Bpay1_2=NEW Individual_Teams__c();
            Bpay2_2=NEW Individual_Teams__c();
            //20200304
            Basic1=new Individual_Teams__C();
            Basic2=new Individual_Teams__C();
            X01=new Individual_Teams__C();
            X02=new Individual_Teams__C();
            Basic1.name='Basic1';
            Basic2.name='Basic2';
            Basic1.Contract__C=printPADate;
            Basic2.Contract__c=printPADate;
            //20200421
            //DownPayment1=NEW Individual_Teams__c();
            //DownPayment2=NEW Individual_Teams__c();
            basic1.actual_Values__c='3.3. Supply of the Goods is carried on conditions of '+Con.Trade_term__c+' '+ con.Destination__c+'(“Destination Port”) according to the Incoterms 2010 rules.\n'+
                ' Together with the Goods, the Seller must send to the Buyer the following original documents or scan copies thereof via E-mail:\n'+
                '-   Certificate of Origin (original)\n'+
                '-   Commercial Invoice (original)\n'+
                '-   Packing List (original)\n'+
                '-   Bill of Lading (scan copy)\n'+
                '-   Cargo insurance (scan copy)\n'+
                '-   Export declaration (scan copy)\n'; 
            basic2.actual_Values__c='3.3. Поставка Товару здійснюється на умовах '+Con.Trade_term__c+' '+ con.Destination__c+' («Порт Призначення») відповідно до правил Інкотермс 2010.\n'+
                ' Разом із Товаром Продавець повинен надіслати Покупцю наступні оригінали або скан-копії наступних документів електронною поштою:\n'+
                '-    Сертифікат походження (оригінал)\n'+
                '-    Комерційний рахунок-фактуру (оригінал)\n'+
                '-    Пакувальний лист (оригінал)\n'+
                '-    Коносамент (скан-копію)\n'+
                '-    Страхування вантажу (скан-копію)\n'+
                '-    Експортну декларацію (скан-копію)\n'; 
            X01.name='X01';
            X02.name='X02';
            X01.Contract__C=printPADate;
            X02.Contract__c=printPADate;
            X01.actual_Values__c='This Purchase Agreement (the "Agreement" or “Contract”) is made by and between '+CON.BuyerAccount__r.Name+' represented by '+con.Buyer_s_representative_English__c+', acting on the basis of '+con.Basis_of_Representation_English__c+', hereinafter called the "Buyer" and '+Con.SELLER__c+', represented by Mr. Cao Haiyun, acting on the basis of Power of Attorney, hereinafter called the "Seller", whereby the Buyer intends to buy and the Seller agrees to sell the below mentioned products (the "Goods") according to the terms and conditions stipulated below:\n';
            X02.actual_Values__c='Цей Договір купівлі-продажу (далі - «Договір» або «Контракт») укладено між '+CON.BuyerAccount__r.Account_Name_Ukrainian__c+' в особі '+con.Buyer_s_representative_Ukraine__c+', яка/який діє на підставі '+con.Basis_of_Representation_English__c+', далі іменується «Покупець», і '+Con.SELLER__c+', в особі пана Цао Хайюнь, який діє на підставі Довіреності, далі іменується «Продавець», згідно з яким Покупець має намір купити, а Продавець згоден продати зазначені нижче продукти («Товар») відповідно до умов та положень, зазначених нижче:\n';
            Decimal DPFlag;
            DPFlag =0;
            Decimal DPercentage1;
            Decimal DPercentage2;
            Decimal DDays1;
            Decimal DDays2;
            Boolean ExecutionDateFlag;
            ExecutionDateFlag =false;
             for(Payment__c P:pay){
                 IF(P.Down_Balance_Payment__c=='Down Payment'){
                     DPFlag++;
                     if(DPFlag==1){
                         if(p.Payment_Term__c.contains('Execution')){
                           DPercentage1=p.Percentage__c;
                           DDays1=P.DAYs__C; 
                           ExecutionDateFlag=true;
                         }
                         
                     }
                     if(DPFlag==2){
                         DPercentage2=p.Percentage__c;
                         DDays2=P.DAYs__C;
                     }
                 }
             }
			
			  IF(DPFlag==1 && ExecutionDateFlag){
                    Dpay1.Actual_Values__c ='The buyer shall pay '+DPercentage1+'% of the Total Purchase Price of the Goods as Down Payment by T/T within '+DDays1+' days after the Execution Date of this Purchase Order';
                    Dpay2.Actual_Values__c ='Покупець оплачує  '+DPercentage1+'% загальної Продажної ціни Товару – Передоплату, шляхом T/T шляхом'+DDays1+' днів з дати  цього Договору купівлі-продажу'; 
                }
                IF(DPFlag==2){
                    Dpay1.Actual_Values__c ='The buyer shall pay '+ DPercentage1+'% of the Total Purchase Price of the Goods by T/T within '+DDays1+' days after the Execution Date of this Purchase Order and then pay '+DPercentage2+'% of the Total Purchase Price of the Goods by T/T no later than '+DDays2+ 'days before the related Bill of Lading date of such Goods (collectively, the “Down Payment”).';
                    Dpay2.Actual_Values__c = 'Покупець оплачує  '+ DPercentage1+' % Загальної Продажної Ціни Товару шляхом банківського переказу протягом  '+DDays1+' днів з дати цього Договору купівлі-продажу, а після цього оплачує  '+DPercentage2+'% Загальної Продажної Ціни Товару, шляхом банківського переказу не пізніше ніж за '+DDays2+ ' днів до дати відповідного коносаменту на такі Товари (разом – “Передоплата”)';
                }
            
            for(Payment__c P:pay){
               /* IF(P.Down_Balance_Payment__c=='Down Payment'){
                    Dpay1.Actual_Values__c +='The buyer shall pay '+P.Percentage__c+'% of the Total Purchase Price of the Goods as Down Payment by T/T within '+P.DAYs__C+' days after the Execution Date of this Purchase Order';
                    Dpay2.Actual_Values__c +='Покупець оплачує '+P.Percentage__c+'% загальної Продажної ціни Товару – Передоплату, шляхом T/T шляхом'+P.DAYs__C+' днів з дати  цього Договору купівлі-продажу';
 
                }*/
              
                
                IF(P.Down_Balance_Payment__c=='Balance Payment'){
                    Bpay1.Actual_Values__c=' The buyer shall pay '+P.Percentage__c+'% of the Total Purchase Price of the Goods as Balance Payment by T/T within '+ 
                        P.DAYs__C+' days after related Bill of Lading date of such Goods. Seller will inform Buyer by email that Goods are ready for being shipped from '+con.Departure_Port__c+
                        ' 3 weeks before the Expected Time of Shipment on the condition that Seller has received the Down Payment of the Goods.';
                      String BBPAYUK;
                    if(con.Departure_Port__c=='China Main Port'){
                        BBPAYUK='головного порту Китаю';
                    }else if(con.Departure_Port__c=='Vietnam Main Port'){
                        BBPAYUK='головний порт В\'єтнаму';
                    }
                    Bpay2.Actual_Values__c='Покупець оплачує '+P.Percentage__c+'% Продажної ціни Товару як Решту Вартості шляхом банківського переказу протягом '+
                        P.DAYs__C+'днів після відповідної дати Коносаменту на такі Товари. Продавець проінформує Покупця по електронній пошті, що Товар готовий до відвантаження з '+BBPAYUK+
                        'за 3 тижня до очікуваної дати відвантаження за умови, що Продавець отримав Передоплату за Товар. ';

                }
                
            }
                               Dpay1.name='Dpay1';
                    Dpay2.name='Dpay2';
                    Dpay1.Contract__c=printPADate;
                    Dpay2.Contract__c=printPADate;
                                Bpay1.name='Bpay1';
                    Bpay2.name='Bpay2';
            		/*DownPayment1.name='DownPayment1';
            		DownPayment2.name='DownPayment2';
            		DownPayment1.Contract__c=printPADate;
            		DownPayment2.Contract__c=printPADate;*/
                    Bpay1.Contract__C=printPADate;
                    Bpay2.Contract__c=printPADate;
        }
        else if(indList.size()!=0 && Dpay1==null){
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
                if(Str.name=='Basic1'){
                    Basic1= str;
                }
                if(Str.name=='Basic2'){
                    Basic2= str;
                }
                if(Str.name=='X01'){
                    X01= str;
                }
                if(Str.name=='X02'){
                    X02= str;
                }
                /*if(Str.name=='DownPayment1'){
                    DownPayment1=str;
                }
                if(Str.name=='DownPayment2'){
                    DownPayment2=str;
                }*/
            }
            
        }
        list<Information_of_Seller__c> ioss=new  list<Information_of_Seller__c>();
        ioss=[SELECT Seller__c,Address__c,Seller_VAT_NO__c,Name,Authorized_Signatory__c 
               FROM Information_of_Seller__c WHERE Seller__c=:con.SELLER__c];
            if(ioss.size()>0){
            ios = ioss[0];
            }
        pds = [Select Id,Contract_PO_PI__c,Quantity__c,Total_W__c,	Product_Name__c,Unit_WM__c,Total_Price__c,Unit_Price_Without_Commission__c,
               Battery_Type__c,Guaranteed_Delivery_Date__c,Unit_Price__c,Number_of_Cells__c,Weight__c,Dimensions__c,GuaranteedDeliveryDateAuto2__c
               From Product_Detail__c Where Contract_PO_PI__c =: printPADate];
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
                
                //交期
                GDay   = String.valueOf(pd.Guaranteed_Delivery_Date__c.Day());
                if(GDay=='1'){
                    GDay=GDay+'st';
                    
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
                
                
            }
        }
        system.debug('chushihua'+Dpay1);
    }
    public PageReference AddSave(){
        
        list<Individual_Teams__c> indListnew = new list<Individual_Teams__c>();
        con.PaymentTermStand__c=con.Payment_Term_Description__c;
        update con;
        system.debug(Dpay1);
        
        indListnew.add(Dpay1);
        system.debug('Dpay1--------------------------->'+Dpay1);
        indListnew.add(Dpay2);
        system.debug('Dpay2--------------------------->'+Dpay2);
        indListnew.add(Bpay1);
        system.debug('Bpay1--------------------------->'+Bpay1);
        indListnew.add(Bpay2);
        system.debug('Bpay2--------------------------->'+Bpay2);
        indListnew.add(basic1);
        system.debug('basic1--------------------------->'+basic1);
        indListnew.add(basic2);
              system.debug('basic2--------------------------->'+basic2);
        indListnew.add(x01);
        system.debug('x01--------------------------->'+x01);
        indListnew.add(x02);
        system.debug('x02--------------------------->'+x02);
        //20200421
        /*indListnew.add(DownPayment1);
        system.debug('DownPayment1--------------------------->'+DownPayment1);
        indListnew.add(DownPayment2);
        system.debug('DownPayment2--------------------------->'+DownPayment2);*/
        
        if(indListnew.size()>0){
        UPSERT indListnew;
        }
        
        
        // ExcuteId=printPADate;
        
        // PageReference pageRef = new PageReference('/800/o');
        system.debug('success');  
        String printPADate = ApexPages.currentPage().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/UKpreview?id='+printPADate);
        
        /** PageReference savePDF = Page.PreviewContractPDF;
system.debug('Start show PDF');
return savePdf(savePDF);*/
        
        return pageRef;
    }
    
    public  PageReference  SendEmail(){
        try{
            List<Id> addId = new List<Id>();
            addId.add(con.OwnerId);
            addId.add(con.Owner.BMO_specialist__c);
            if(addId.size()>0){
                for(Id id:addId){
                    SendEmailUtils.sendToSomeOneId(con.Id, id, 'ContractRemind');
                }
                
            }
            system.debug('1231');
            con.LegalRepair__c = true;
            con.Legal_Dept_SendEmail_Time__c = datetime.now();
            update con;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , 'Send Email Successful'));
        }catch(Exception ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
            
        }
        return null;
    }
    
    
    
}