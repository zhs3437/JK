public class OrdPreviewCtrl {
    public list<Standard_Template_Teams__c> stdList{get;set;}
    public String  SpecialT1{get;set;}
    public String  SpecialT2{get;set;}
    public String  SpecialT3{get;set;}
    public String  SpecialT4{get;set;}
    public String  SpecialT5{get;set;}
        public String  LGoverningLaw{get;set;}
        public String  LDisputeResolution{get;set;}
        public String  LSPECIALTERMS{get;set;}
    public String SPECIALTERMS{get;set;}
    public String MeSPECIALTERMS{get;set;}
    list<String> SpecialTemLst {get;set;}
    public Integer  SpecialTemLstsize{get;set;}
    public Boolean MexicoSpecial{get;set;}
    public String MexicoSpecialString{get;set;}
    public Amendment__c ad{get;set;}
    public Amendment__c ad2{get;set;}
    public Amendment__c add1{get;set;}
    public Amendment__c add2{get;set;}
    public Amendment__c add3{get;set;}
    public String  newSPECIALTERMS{get;set;}
    public String GoverningLaw{get;set;}
    public String DisputeResolution{get;set;}
    public String Warranty{get;set;}
    public integer Anum{get;set;}
     public Decimal  Ver{get;set;}
    public String TradeTerm{get;set;}
    public String ContractFactory{get;set;}
    public List<String> StandFieldValue{get;set;}
    public  List<Amendment_Payment__c> payLst{get;set;}
    public  List<Amendment__c> ALst{get;set;}
    public  List<Amendment_Order_Product__c> AopLst{get;set;}
    public Date ExceptionDeliveryDate{get;set;}
    public date dt{get;set;}
    public String newPaymentTerm{get;set;}
    public String newPaymentTerm1{get;set;}
    public String newPaymentTerm2{get;set;}
        public String newPaymentTerm3{get;set;}
    public String newPaymentTerm4{get;set;}
    public String newPaymentTermKK{get;set;}
    public User sellers{get;set;}
    public String Address{get;set;}
    public String buyerVATNO{get;set;}
    public String LongPayment{get;set;}
    public String LongTradeTerm{get;set;} 
    public String requestId{get;set;}

public Order ord2{get;set;}
  public Order ord{get;set;}


    public String NewDescription{get;set;}
    public Date ActiveDate{get;set;}
        public  boolean BuyerLetter{get;set;}
    public Boolean AmendDifferent{get;set;} 
    public Boolean AmendProDifferent{get;set;}
    public Boolean AmendPayDifferent{get;set;}
    public Boolean AmendTable{get;set;}//显不显示表2.1

    public OrdPreviewCtrl(ApexPages.StandardController ctrl){
                        if (!Test.isRunningTest()){ ctrl.addFields(new List<String>{'IsCif__c', 'Amount_received__c','Number_of_pieces_shipped__c','Component_Model__c','Buyer__r','Name','Legal_Change_2_1__c'});}
        dt = date.today();
        requestId = ApexPages.currentPage().getParameters().get('id');
        //新增
         Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                              'Where id =:requestId');
        
        Id id1=Aord.Order__c;
          //查询终止协议关联的订单
          ord = new Order();
            ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                      'Where id =: id1');
            ord2= new Order();
          ord2 = [SELECT ID,Name,Buyer__r.Name from Order Where id=:id1];
          //新增结束
        ad = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                            'Where id =: requestId');
        Ver = ad.Version_revision__c;
        
        Contract contf=[select Buyer_Letter_of_guarantee__c from Contract where  id =: ad.Contract__c];
        if(contf.Buyer_Letter_of_guarantee__c=='None' || contf.Buyer_Letter_of_guarantee__c==null){
            BuyerLetter=false;
        }else{BuyerLetter=true;}
  ALst=[select id,Printing_time__c from Amendment__c where Order__c=:ad.Order__c order by createddate];
        if(Ver==null){
        
        Anum=integer.valueof(ad.name.substring(ad.name.length()-1, ad.name.length()));
        }else{
            Anum=integer.valueof(Ver);
        }
        if(String.isEmpty(String.valueof(ad.Effective_Date__c))){
            system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ad.Old_Contract_execution_date__c));
            ActiveDate = Date.valueof(ad.Old_Contract_execution_date__c);
        }else{
             system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ad.CreatedDate));
             system.debug('ad.EffectiveDate__c'+ad.Effective_Date__c);
            ActiveDate = ad.Effective_Date__c;
        }
        if(Anum==2){
            add1=Alst[1];
        }
        if(Anum==3){
            add1=Alst[1];
            add2=Alst[2];
        }
        if(Anum>=4){
            add1=Alst[1];
            add2=Alst[2];
            add3=Alst[3];
        }

        if(String.isEmpty(String.valueof(ad.Printing_time__c))){
            ad.Printing_time__c=date.today();
        }
        if(ad.Contract_Owner__c!=null){
        String userId = ad.Contract_Owner__c;
        sellers = [Select id ,Phone , MobilePhone,City,Country,PostalCode,State,Street, Address,name, Email from User where Id =: userId];
        system.debug('ad---->'+ad.SELLER__c);
        }
        List<Information_of_Seller__c>  sellers = [select id,Address__c,Authorized_Signatory__c,Seller__c,Title__c,Seller_VAT_NO__c from Information_of_Seller__c where Seller__c =: ad.SELLER__c limit 1];
        Information_of_Seller__c infoSeller = sellers[0];
        
        Address = infoSeller.Address__c;
        String accountId= ad.Buyer__c;
        Account buyer = Database.query(Utils.MakeSelectSql('Account')  + ' WHERE Id =: accountId');
        buyerVATNO = buyer.VAT_NO__c; 
        payLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                               'Where Amendment_Purchase_Agreement__c =: requestId');
        AopLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                              'Where OriginalOrderItem__c =: requestId ORDER BY Guaranteed_Delivery_Date__c asc');
        
        NewDescription ='';
        String AmountDescription ='';
        if(ad.Amount_received__c !=0 && ad.Amount_received__c !=0.00 && ad.Amount_received__c !=null){
            AmountDescription ='the Seller has received '+ad.Amount_received__c + '('+ad.CurrencyIsoCode+')'+' from the Buyer';
        }
        String ProductDescrption ='';
        for(Amendment_Order_Product__c amendProduct :AopLst){
            if(amendProduct.Number_of_pieces_shipped__c !=0 && amendProduct.Number_of_pieces_shipped__c !=null){
                if(ProductDescrption=='' ){
                    ProductDescrption ='duly delivered '+amendProduct.Number_of_pieces_shipped__c+ ' pieces of '+amendProduct.Product_Name__c+ ' modules';
                }else{
                    ProductDescrption = ProductDescrption +' ,'+amendProduct.Number_of_pieces_shipped__c+ ' pieces of '+amendProduct.Product_Name__c+ ' modules';
                }             
            }
        }
        if(AmountDescription !=''){
          NewDescription ='WHEREAS, as of the Effective Date,'+ AmountDescription; 
        }
        if(ProductDescrption !=''){
            if(NewDescription !=''){
                NewDescription = NewDescription+' And'+ProductDescrption +' under the Purchase Order';
            }else{
                 NewDescription ='WHEREAS, as of the Effective Date,the Seller has '+ProductDescrption +' under the Purchase Order';
            }
        }else{
             if(NewDescription !=''){
                NewDescription = NewDescription+' under the Purchase Order';
            }
        }
        AmendPayDifferent=false;
        AmendProDifferent=false;
        AmendDifferent=false;
        AmendTable =false;
        AmendChange();
          system.debug('AmendPayDifferent--->'+AmendPayDifferent);
              system.debug('AmendProDifferent-->'+AmendProDifferent);
              system.debug('AmendDifferent-->'+AmendDifferent);
        if(AmendPayDifferent ==false && AmendDifferent ==false ){
            AmendTable = true;
        }
        if(ad.Legal_Change_2_1__c==true){
             AmendTable = false;
        }
            
        LoadPreview();
    }
    
    
  
    public void initialize(){
    }
    public void AmendChange(){
                Order_Differences__c OD =[select    Contract_PO_PI_Owner_New__r.name , Contract_PO_PI_Owner_Old__r.name , Actual_Sales_Name_New__c , Actual_Sales_Name_Old__c , Opportunity_New__r.name , Opportunity_Old__r.name , Account_Name_New__r.name  , Account_Name_Old__r.name, Destination_Country_New__c  ,  Destination_Country_Old__c  ,
                                   SAP_User_ID_New__c ,  SAP_User_ID_Old__c , Contract_PO_PI_No_New__c , Contract_PO_PI_No_Old__c , Supply_By_New__c ,  Supply_By_Old__c , Status_New__c  ,  Status_Old__c ,
                                  Buyer_New__r.name  ,       Buyer_Old__r.name 
                                  ,   Order_Start_Date_New__c  ,       Order_Start_Date_Old__c 
                                  ,   Destination_New__c  ,       Destination_Old__c 
                                  ,   Factory_WH_New__c  ,       Factory_WH_Old__c 
                                  ,   Shipping_type_New__c  ,       Shipping_type_Old__c 
                                  , 
                                  Warranty_Insurance_New__c ,  Warranty_Insurance_Old__c 
                                  ,   Region_New__c  ,       Region_Old__c 
                                  ,   Warranty_On_Material_and_Workmanship_New__c  ,       Warranty_On_Material_and_Workmanship_Old__c 
                                  , 
                                  Customer_Order_Reference_PO_New__c  ,       Customer_Order_Reference_PO_Old__c 
                                  ,   Commission_Value_sync_to_SAP_New__c  ,       Commission_Value_sync_to_SAP_Old__c 
                                  ,   Commission_Type_New__c  ,       Commission_Type_Old__c 
                                  ,   VAT_NO_New__c  ,       VAT_NO_Old__c 
                                  ,   GST_Classification_Region_New__c  ,       GST_Classification_Region_Old__c 
                                  ,   BMO_SH_New__c  ,       BMO_SH_Old__c 
                                  ,   BMO_SR_New__c  ,       BMO_SR_Old__c 
                                  ,   Special_New__c  ,       Special_Old__c 
                                  ,   Normal_New__c  ,       Normal_Old__c 
                                  ,   Special_Requirements_New__c  ,       Special_Requirements_Old__c 
                                  ,   Special_Approvals_New__c  ,       Special_Approvals_Old__c 
                                  , 
                                  Intercompany_Seller_POs_New__c  ,       Intercompany_Seller_POs_Old__c 
                                  , 
                                  Requested_supplier_New__c  ,       Requested_supplier_Old__c 
                                  ,   Other_New__c  ,       Other_Old__c 
                                  ,   PMC_confirm_New__c  ,       PMC_confirm_Old__c 
                                  ,   Tax_Rate_New__c  ,       Tax_Rate_Old__c 
                                  ,    Transit_Fees_New__c  ,       Transit_Fees_Old__c 
                                  ,   SELLER_New__c  ,       SELLER_Old__c 
                                  ,   Contact_Name_New__c  ,       Contact_Name_Old__c 
                                  ,   Customer_country_New__c  ,       Customer_country_Old__c 
                                  ,   Fax_New__c  ,       Fax_Old__c 
                                  ,   Phone_New__c  ,       Phone_Old__c 
                                  ,   Customer_Business_Scale_New__c  ,       Customer_Business_Scale_Old__c   
                                  ,
                                  Email_New__c  ,       Email_Old__c   
                                  ,   Title_New__c  ,       Title_Old__c   
                                  ,   Authorized_Representative_New__c  ,       Authorized_Representative_Old__c   
                                  ,   BillingCountry_New__c  ,       BillingCountry_Old__c   
                                  ,   BillingState_New__c  ,       BillingState_Old__c   
                                  , 
                                  BillingCity_New__c  ,       BillingCity_Old__c   
                                  ,   Bank_Street_New__c  ,       Bank_Street_Old__c   
                                  ,   BillingPostalCode_New__c  ,       BillingPostalCode_Old__c   
                                  ,   Bank_Information_Content_New__c  ,       Bank_Information_Content_Old__c   
                                  ,   Payment_Term_Description_New__c  ,       Payment_Term_Description_Old__c   
                                  ,   Trade_term_New__c   ,       Trade_term_Old__c   
                                  ,   Total_Price_New__c   ,       Total_Price_Old__c   
                                  ,   Total_Quantity_New__c   ,       Total_Quantity_Old__c   
                                  ,   Commission_New__c ,       Commission_Old__c   ,OwnerId,Amendment_Purchase_Agreement__c
                                  
                                  
                                  from Order_Differences__c
                                  where Amendment_Purchase_Agreement__c =: requestId];
          
        if(OD !=null){
              String ODId=OD.ID;
        Boolean noSend = false ;
     
        List<OrderItem_Difference__c> OIDLst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem_Difference__c) + ' ' +
                                                              'where Order_Differences__c =: ODId');
        List<PaymentDifference__c>  PDLst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.PaymentDifference__c) + ' ' +
                                                           'where Order_Differences__c =: ODId');
        
        List<String> id = new List<String>(); 
        if(OD.Destination_Country_New__c != OD.Destination_Country_Old__c ||
           OD.SELLER_New__c != OD.SELLER_Old__c||
           OD.Buyer_New__r.name !=      OD.Buyer_Old__r.name  || 
           OD.Destination_New__c !=      OD.Destination_Old__c ||   
           OD.Trade_term_New__c  !=      OD.Trade_term_Old__c     
           ||   OD.Bank_Information_Content_Old__c.length()-OD.Bank_Information_Content_New__c.length() >5
          ){
          AmendDifferent = true;
          system.debug('订单基本信息改变');
          }
            if(OIDLst.size()>0){
                  for(OrderItem_Difference__c OID:OIDLst){
            if(OID.Quantity_New__c!=OID.Quantity_Old__c || OID.Guaranteed_Delivery_Date_New__c!=OID.Guaranteed_Delivery_Date_Old__c ||
                 OID.SAP_Product_Materiel_No_New__c!=OID.SAP_Product_Materiel_No_Old__c ||OD.Trade_term_New__c  !=      OD.Trade_term_Old__c   ||
                OID.Total_MW_New__c!=OID.Total_MW_Old__c ||  OID.Type_of_module_New__c!=OID.Type_of_module_Old__c ||  OID.UnitPrice_New__c!=OID.UnitPrice_Old__c || OID.Product_Name_Old__c!=OID.Product_Name__c  ){
                AmendProDifferent = true;
                system.debug('订单产品变化');
            }

    }
            }
        if(PDLst.size()>0){
          for(PaymentDifference__c PD:PDLst){
            if(PD.Payment_Method_New__c!=PD.Payment_Method_Old__c || PD.Percentage_New__c!=PD.Percentage_Old__c ||
               PD.Payment_Term_New__c   !=PD.Payment_Term_Old__c || PD.Down_Balance_Payment_New__c!=PD.Down_Balance_Payment_New__c ||
               PD.Days_New__c   !=PD.Days_Old__c){
                system.debug('付款方式变化');
                AmendPayDifferent =true;
            }
            //Payment Method 修改
        }
        }
           system.debug('AmendPayDifferent--->'+AmendPayDifferent);
              system.debug('AmendProDifferent-->'+AmendProDifferent);
              system.debug('AmendDifferent-->'+AmendDifferent);
               }
    }    
    public void LoadPreview(){
        stdList = [select id,
                   Name,
                   Field_Values__c,
                   Actual_Values__c,
                   Type__c,
                   Flag__c
                   from Standard_Template_Teams__c 
                   limit 4000];
        
        for(Standard_Template_Teams__c stt: stdList){
            setIndividualTeam( stt,ad);
            
            
        }
    }
    
    public void setIndividualTeam(Standard_Template_Teams__c stt, Amendment__c ad){
        Boolean DeliveryDatefalg = true;
        if(stt.Type__c == 'Equal'){
            if(stt.Name=='Trade_term__c'){
                if(stt.Field_Values__c==ad.Trade_term__c){
                    
                    if(ad.Trade_term__c =='FCA'){
                        if(ad.SELLER__c =='JinkoSolar GmbH'){
                            TradeTerm = 'FCA '+ ad.Destination__c ; 
                        }else{
                            TradeTerm = stt.Actual_Values__c; 
                        }
                    }
                    else{
                        TradeTerm = stt.Actual_Values__c; 
                    }
                    
                    system.debug('TradeTerm-->'+TradeTerm);
                }
            }
            else if(stt.Name=='Region__c:Destination_Country__c'){
                
                List<String>  IndivValue = new List<String>();
                StandFieldValue = stt.Field_Values__c.split(':');
                
                if(stt.Field_Values__c.indexof(ad.Region__c)>-1 && StandFieldValue[1]==ad.Destination_Country__c){
                    if(ad.Region__c!='ROA'){
                        
                        IndivValue =  stt.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                    } 
                    else if(ad.Region__c=='ROA' && ad.Destination_Country__c !='Australia'){
                        IndivValue =  stt.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                    }else if(ad.Region__c=='ROA' && ad.Destination_Country__c =='Australia'){
                        
                        IndivValue =  stt.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                    }
                    
                }
            }
        }
        if(stt.Type__c == 'Contain'){ 
            if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                if(payLst.size()>0){
                    
                    if(payLst.size()==1){
                        StandFieldValue = stt.Field_Values__c.split(':');
                        String it;
                        if(ad.Trade_term__c=='CFR'|| ad.Trade_term__c=='CIF' || ad.Trade_term__c=='CIP' || ad.Trade_term__c=='FOB' || ad.Trade_term__c=='EXW' ){
                            if(payLst[0].Payment_Term__c=='x% DP X days after the Execution Date'){
                                if(payLst[0].Down_Balance_Payment__c=='Down Payment'){
                                    ExceptionDeliveryDate = dt.addDays(Integer.valueof(payLst[0].Days__c));
                                }
                                if(ExceptionDeliveryDate !=null && (ad.Trade_term__c=='CFR'|| ad.Trade_term__c=='CIF' || ad.Trade_term__c=='CIP' || ad.Trade_term__c=='FOB')){
                                    ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(14);
                                }else if(ExceptionDeliveryDate !=null && ad.Trade_term__c=='EXW'){
                                    ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(3);
                                }
                                
                                DeliveryDatefalg = true;
                                
                            }else if(payLst[0].Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                if(ad.Trade_term__c=='CFR'|| ad.Trade_term__c=='CIF' || ad.Trade_term__c=='CIP' || ad.Trade_term__c=='FOB'){
                                    if(payLst[0].Days__c >13){
                                        DeliveryDatefalg = true;  
                                    }else{
                                        DeliveryDatefalg = true;  
                                    }
                                }else if(ad.Trade_term__c=='EXW'){
                                    if(payLst[0].Days__c >2){
                                        DeliveryDatefalg = true;  
                                    }else{
                                        DeliveryDatefalg = true;  
                                    }
                                }
                            }
                            
                        }
                        
                        if(stt.Field_Values__c.indexof(ad.Trade_term__c)>-1){   
                            it = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+payLst[0].Payment_Method__c +':'+ payLst[0].Payment_Term__c+':'; 
                        } 
                        List<String>  IndivFieldValue = new List<String>();
                        if( it !=null){
                            IndivFieldValue= it.split(':'); 
                        }else{
                            it ='Not StandTemplate'; 
                        }     
                        
                        if(StandFieldValue==IndivFieldValue){
                            
                            it =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                            it = it.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                            
                            if(payLst[0].Percentage__c!=100){
                                newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                            }
                            else{
                                newPaymentTerm = it; 
                            }
                            if(DeliveryDatefalg==false){
                               // newPaymentTerm = '特殊贸易方式的打印时间根据规则叠加超出了预计发货时间,需要法务手动填写'; 
                            }
                            
                            
                        }
                        
                    }
                    else if(payLst.size()==2){
                        if(ad.Trade_term__c=='CFR'|| ad.Trade_term__c=='CIF' || ad.Trade_term__c=='CIP' || ad.Trade_term__c=='FOB' || ad.Trade_term__c=='EXW' ){
                            if(payLst[0].Payment_Term__c=='x% DP X days after the Execution Date'){
                                if(payLst[0].Down_Balance_Payment__c=='Down Payment'){
                                    ExceptionDeliveryDate = dt.addDays(Integer.valueof(payLst[0].Days__c));
                                }
                                if(ExceptionDeliveryDate !=null && (ad.Trade_term__c=='CFR'|| ad.Trade_term__c=='CIF' || ad.Trade_term__c=='CIP' || ad.Trade_term__c=='FOB')){
                                    ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(13);
                                }else if(ExceptionDeliveryDate !=null && ad.Trade_term__c=='EXW'){
                                    ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(2);
                                }
                                
                                
                                DeliveryDatefalg = true; 
                            }else if(payLst[0].Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                if(ad.Trade_term__c=='CFR'|| ad.Trade_term__c=='CIF' || ad.Trade_term__c=='CIP' || ad.Trade_term__c=='FOB'){
                                    if(payLst[0].Days__c >13){
                                        DeliveryDatefalg = true;  
                                    }else{
                                        DeliveryDatefalg = true;  
                                    }
                                }else if(ad.Trade_term__c=='EXW'){
                                    if(payLst[0].Days__c >2){
                                        DeliveryDatefalg = true;  
                                    }else{
                                        DeliveryDatefalg = true;  
                                    }
                                }
                            }
                            
                        }
                        
                        StandFieldValue = stt.Field_Values__c.split(':');
                        String Payment1;
                        String Payment2;
                        if(stt.Field_Values__c.indexof(ad.Trade_term__c)>-1){  
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
                            system.debug('string.valueof(payLst[0].Percentage__c)---》'+string.valueof(payLst[0].Percentage__c));
                            newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                            newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                        }
                        if(StandFieldValue==IndivFieldValue2){
                            newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                            newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                        }
                        
                        if(newPaymentTerm1 !=null && newPaymentTerm2 !=null){
                            newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2;
                            
                            
                            
                        }
                        if(newPaymentTerm1 ==null || newPaymentTerm2 ==null){
                                newPaymentTerm = '存在后台语句库无法匹配的付款组合';
                                }
                     
                        Decimal i = payLst[0].Percentage__c;
                        Decimal j = payLst[1].Percentage__c;  
                        if((payLst[0].Down_Balance_Payment__c=='Down Payment' && payLst[1].Down_Balance_Payment__c=='Down Payment') || (payLst[0].Down_Balance_Payment__c=='Balance Payment' && payLst[1].Down_Balance_Payment__c=='Balance Payment')){
                            
                          //  newPaymentTerm = '有两条相同类型的付款方式,付款方式描述无法正常显示';
                        }
                        else if( String.valueOf(i+j) =='100' || String.valueOf(i+j) =='100.00'){
                            stt.Actual_Values__c = newPaymentTerm; 
                        }
                        else{
                            newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                        }                            
                        if(DeliveryDatefalg==false){
                          //  newPaymentTerm = '特殊贸易方式的打印时间根据规则叠加超出了预计发货时间,需要法务手动填写'; 
                        }
                        
                        
                        
                        
                    } 
                      else if(payLst.size()==3){
                            StandFieldValue = stt.Field_Values__c.split(':');
                        String Payment1;
                        String Payment2;
                          String Payment3;
                        if(stt.Field_Values__c.indexof(ad.Trade_term__c)>-1){  
                            Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                            Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                             Payment3 = StandFieldValue[0] +':' + payLst[2].Down_Balance_Payment__c + ':'+ payLst[2].Payment_Method__c +':'+  payLst[2].Payment_Term__c;
                        }
                        List<String>  IndivFieldValue1 = new List<String>();
                        List<String>  IndivFieldValue2 = new List<String>();
                          List<String>  IndivFieldValue3 = new List<String>();
                        if(Payment1 !=null && Payment2 !=null && Payment3!=null){
                            IndivFieldValue1= Payment1.split(':'); 
                            IndivFieldValue2= Payment2.split(':'); 
                            IndivFieldValue3= Payment3.split(':'); 
                        }
                        
                        if(StandFieldValue==IndivFieldValue1){
                            system.debug('string.valueof(payLst[0].Percentage__c)---》'+string.valueof(payLst[0].Percentage__c));
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
                        
                        if(newPaymentTerm1 !=null && newPaymentTerm2 !=null  && newPaymentTerm3 !=null){
                            newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2+'\t\r\n' +newPaymentTerm3;
                            
                            
                            
                        }
                        if(newPaymentTerm1 ==null || newPaymentTerm2 ==null|| newPaymentTerm3 ==null){
                                newPaymentTerm = '存在后台语句库无法匹配的付款组合';
                                }
                     
                        Decimal i = payLst[0].Percentage__c;
                        Decimal j = payLst[1].Percentage__c; 
                        Decimal k = payLst[2].Percentage__c; 
                        
                      if( String.valueOf(i+k+j) =='100' || String.valueOf(i+k+j) =='100.00'){
                            stt.Actual_Values__c = newPaymentTerm; 
                        }
                        else{
                            newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                        }                            
                       
                        
                        
                        
                          }
                      else if(payLst.size()==4){
                          StandFieldValue = stt.Field_Values__c.split(':');
                        String Payment1;
                        String Payment2;
                          String Payment3;
                               String Payment4;
                        if(stt.Field_Values__c.indexof(ad.Trade_term__c)>-1){  
                            Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                            Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                             Payment3 = StandFieldValue[0] +':' + payLst[2].Down_Balance_Payment__c + ':'+ payLst[2].Payment_Method__c +':'+  payLst[2].Payment_Term__c;
                        Payment4 = StandFieldValue[0] +':' + payLst[3].Down_Balance_Payment__c + ':'+ payLst[3].Payment_Method__c +':'+  payLst[3].Payment_Term__c;
                        
                        }
                        List<String>  IndivFieldValue1 = new List<String>();
                        List<String>  IndivFieldValue2 = new List<String>();
                          List<String>  IndivFieldValue3 = new List<String>();
                           List<String>  IndivFieldValue4 = new List<String>();
                        if(Payment1 !=null && Payment2 !=null && Payment3!=null&& Payment4!=null){
                            IndivFieldValue1= Payment1.split(':'); 
                            IndivFieldValue2= Payment2.split(':'); 
                            IndivFieldValue3= Payment3.split(':'); 
                            IndivFieldValue4= Payment4.split(':'); 
                        }
                        
                        if(StandFieldValue==IndivFieldValue1){
                            system.debug('string.valueof(payLst[0].Percentage__c)---》'+string.valueof(payLst[0].Percentage__c));
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
                        
                        if(newPaymentTerm1 !=null && newPaymentTerm2 !=null  && newPaymentTerm3 !=null&& newPaymentTerm4 !=null){
                            newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2+'\t\r\n' +newPaymentTerm3+'\t\r\n' +newPaymentTerm4;
                            
                            
                            
                        }
                        if(newPaymentTerm1 ==null || newPaymentTerm2 ==null|| newPaymentTerm3 ==null|| newPaymentTerm4 ==null){
                                newPaymentTerm = '存在后台语句库无法匹配的付款组合';
                                }
                     
                        Decimal i = payLst[0].Percentage__c;
                        Decimal j = payLst[1].Percentage__c; 
                        Decimal k = payLst[2].Percentage__c; 
                           Decimal l = payLst[3].Percentage__c; 
                        
                      if( String.valueOf(i+k+j+l) =='100' || String.valueOf(i+k+j+l) =='100.00'){
                            stt.Actual_Values__c = newPaymentTerm; 
                        }
                        else{
                            newPaymentTerm = '百分比合计不等于100%,付款方式描述无法显示';
                        }                            
                       
                        
                        
                          }
                    else{
                    }
                }
            } 
            else if(stt.Name=='Region__c:Destination_Country__c'){
                List<String>  IndivValue = new List<String>();
                StandFieldValue = stt.Field_Values__c.split(':');
                if(stt.Field_Values__c.indexof(ad.Region__c)>-1 ){
                    if(ad.Region__c=='ROA' && ad.Destination_Country__c !='Australia'){
                        
                        
                        IndivValue =  stt.Actual_Values__c.split(':');
                        
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                        system.debug('123');
                    }
                    else if(ad.Destination_Country__c !='Brazil' && ad.Destination_Country__c !='Chile'&& ad.Destination_Country__c !='Japan'&& ad.Destination_Country__c !='India' && ad.Destination_Country__c !='Mexico' && ad.Destination_Country__c !='United Arab Emirates' && ad.Destination_Country__c !='Italy' &&  ad.Region__c !='ROA'){
                        
                        IndivValue =  stt.Actual_Values__c.split(':');
                        GoverningLaw = IndivValue[0];
                        DisputeResolution = IndivValue[1];
                        
                    }
                }
                
            }
            else if(stt.Name =='Warranty_Insurance__c'){
                if(contract.Warranty_On_Material_and_Workmanship__c!=null){
                    if(stt.Field_Values__c.indexof(ad.Warranty_On_Material_and_Workmanship__c)>-1){
                        
                        Warranty = stt.Actual_Values__c;
                        
                        if(ad.Warranty_Insurance__c =='PG'){
                            Warranty = Warranty +System.Label.Power_Guard;
                        }
                                                if(ad.Warranty_Insurance__c =='AR'){
                            Warranty = Warranty +System.Label.AR;
                        }
                        
                    }
                }
            }
            else if(stt.Name =='Trade_term__c'){
                if(stt.Field_Values__c.indexof(ad.Trade_term__c)>-1){
                    String  str1='CFR,CIF,DAT,DDU,EXW,FCA';
                    String   str2='DAP,DDP,CIP,CPT,';
                    if(str1.indexOf(ad.Trade_term__c)>-1){
                        TradeTerm = stt.Actual_Values__c.replace('[123]',String.valueof(ad.Trade_term__c));
                        if(ad.Trade_term__c =='EXW'){
                            if(ad.Factory__c =='' || ad.Factory__c ==null){
                                TradeTerm =  TradeTerm.replace('[目的港口]',' Seller’s warehouse in '+ad.Destination_Country__c);   
                            }else{
                                ContractFactory = ad.Factory__c; 
                                if(ContractFactory.indexOf('W/H')>-1){
                                    ContractFactory =ContractFactory.remove('W/H');
                                    TradeTerm =  TradeTerm.replace('[目的港口]',' Seller’s warehouse in '+ContractFactory);
                                }else if(ContractFactory.indexOf('factory')>-1){
                                    ContractFactory =ContractFactory.remove('factory');
                                    TradeTerm =  TradeTerm.replace('[目的港口]',' Seller’s factory in '+ContractFactory);
                                }else{
                                    TradeTerm =  TradeTerm.replace('[目的港口]',' Seller’s warehouse in '+ContractFactory); 
                                }
                            }
                            
                        }
                        else{
                            
                            
                            TradeTerm =  TradeTerm.replace('[目的港口]',String.valueof(ad.Destination__c)+'Port'); 
                            
                        }
                    }
                    else if(str2.indexOf(ad.Trade_term__c)>-1){
                        TradeTerm = stt.Actual_Values__c.replace('[123]',ad.Trade_term__c);
                        TradeTerm = TradeTerm.replace('[目的港口]',ad.Destination__c);   
                    }
                    
                }                    
            }
            else if(stt.Name=='Boolean1:Destination_Country__c:Region__c:SELLER__c:Boolean2:Boolean3'){
                StandFieldValue=stt.Field_Values__c.split(':');
                String strCountry ='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD,Jinko Solar Import and Export Co., Ltd.,JinkoSolar International Limited,Jinko Solar Co., Ltd.,JINKOSOLAR TECHNOLOGY LIMITED,ZHEJIANG JINKO SOLAR CO.,LTD,JINKOSOLAR TRADING PRIVATE LIMITED';
                String it;
                if(payLst.size()>0){
                    if(payLst.size()==1 && payLst[0].Percentage__c==100 && payLst[0].Down_Balance_Payment__c=='Down Payment' && payLst[0].Payment_Method__c=='T/T' && payLst[0].Payment_Term__c.indexof('before')>-1){
                        it = false+':country:Region:Seller:'; 
                    }
                    else{
                        it = true+':';
                        
                        if(strCountry.indexof(ad.SELLER__c)>-1){
                            
                            if(ad.SELLER__c=='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                                it =  it+'Australia:Region:'+ad.SELLER__c+':';                                
                            }else{
                                if(ad.Region__c=='EU(Union)'){
                                    it =  it+'Country:EU(Union):'+StandFieldValue[3]+':';
                                }else{
                                    it=  it+'country:Region:Seller:';
                                }
                            }
                        }
                        else{
                            it =  it+'country:Region:Seller:'; 
                        }                            
                    }
                    if(String.isNotEmpty(ad.Delivery_point__c)){
                        if(ad.Trade_term__c=='CIF' && ad.Destination_Country__c=='Brazil' && ad.Delivery_point__c.indexof('warehouse')>-1){
                            it =it +true+':';
                        }else{
                            it =it +false+':'; 
                        }
                    }else{
                        it =it +false+':';  
                    }
                    
                    if(ad.Trade_term__c=='DAP' || ad.Trade_term__c=='DDP'){
                        it =it +true;
                    }else{
                        it =it +false; 
                    }
                    
                    List<String>  IndivFieldValue = new List<String>();
                    
                    
                    IndivFieldValue=it.split(':');
                    
                    if(StandFieldValue==IndivFieldValue){
                        if(IndivFieldValue[4]=='true'){
                            it =stt.Actual_Values__c;
                            it =it.replace('[关联货物所在的具体港口 Port]',ad.Destination__c);
                            stt.Actual_Values__c=it;
                        }else{
                            it =stt.Actual_Values__c;
                        }  
                        SPECIALTERMS  =  it;
                        SpecialTemLst =  SPECIALTERMS.split('~');
                        SpecialTemLstsize = SpecialTemLst.size();
                        MeSPECIALTERMS = System.Label.MexicoSpecial;
                        if(ad.Trade_term__c =='EXW' && ad.Destination_Country__c=='Mexico'){
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
                            System.debug('MexicoSpecial--->'+MexicoSpecial);
                            System.debug('newSPECIALTERMS-->'+newSPECIALTERMS);
                            
                            
                        }  }
                }
            }
        }
        
        if(ad!=null){
            if(String.isNotEmpty(ad.Long_Payment_Term__c)){
                LongPayment = ad.Long_Payment_Term__c;
            }
            if(String.isNotEmpty(ad.Long_Trade_Term__c)){
                LongTradeTerm = ad.Long_Trade_Term__c;
            }
            //  if(String.isNotEmpty(ad.Warranty__c)){
             //   Warranty = ad.Warranty__c;
         //   }
            
                        if(String.isNotEmpty(ad.Dispute_Resolution__c)){
                LDisputeResolution = ad.Dispute_Resolution__c;
            }
                        if(String.isNotEmpty(ad.Governing_Law__c)){
                LGoverningLaw = ad.Governing_Law__c;
            }
                        if(String.isNotEmpty(ad.SPECIAL_TERMSS__c)){
                LSPECIALTERMS = ad.SPECIAL_TERMSS__c;
            }
        }
    }
    
        public PageReference AddSave2(){
                    if(String.isNotEmpty(ad.Long_Payment_Term__c)){
ad.Long_Payment_Term__c=LongPayment; 
                    }
                            if(String.isEmpty(ad.Long_Payment_Term__c)){
ad.Long_Payment_Term__c=newPaymentTerm; 
                    }
                    if(String.isNotEmpty(ad.Long_Trade_Term__c)){
    ad.Long_Trade_Term__c=LongTradeTerm;
                    }
                            if(String.isEmpty(ad.Long_Trade_Term__c)){
    ad.Long_Trade_Term__c=TradeTerm;
                    }
             //   ad.Warranty__c=Warranty;
        
              if(String.isNotEmpty(ad.Dispute_Resolution__c)){
                LDisputeResolution = ad.Dispute_Resolution__c;
            }
                          if(String.isEmpty(ad.Dispute_Resolution__c)){
                LDisputeResolution =DisputeResolution;
            }
                        if(String.isNotEmpty(ad.Governing_Law__c)){
                LGoverningLaw = ad.Governing_Law__c;
            }
                                    if(String.isEmpty(ad.Governing_Law__c)){
                LGoverningLaw = GoverningLaw;
            }
                        if(String.isNotEmpty(ad.SPECIAL_TERMSS__c)){
                LSPECIALTERMS = ad.SPECIAL_TERMSS__c;
            }
                                    if(String.isEmpty(ad.SPECIAL_TERMSS__c)){
                LSPECIALTERMS = newSPECIALTERMS;
            }
    update ad;
                return    new PageReference('/apex/GlobalPurchaseOrderPDF?id='+requestId); 

        
    }
    
    
    public PageReference AddSave(){
                    if(String.isNotEmpty(ad.Long_Payment_Term__c)){
ad.Long_Payment_Term__c=LongPayment; 
                    }
                            if(String.isEmpty(ad.Long_Payment_Term__c)){
ad.Long_Payment_Term__c=newPaymentTerm; 
                    }
                    if(String.isNotEmpty(ad.Long_Trade_Term__c)){
    ad.Long_Trade_Term__c=LongTradeTerm;
                    }
                            if(String.isEmpty(ad.Long_Trade_Term__c)){
    ad.Long_Trade_Term__c=TradeTerm;
                    }
           //    ad.Warranty__c= Warranty;
         
        

    update ad;
                return    new PageReference('/apex/yjPDF?id='+requestId); 

        
    }
    public PageReference savePdf( PageReference savePDF){
        system.debug('start PrintPDF');
        system.debug('requestId-->'+requestId);
        savePDF.getParameters().put('id',requestId);
        String strFileName = 'Amendment'+'.pdf';
        system.debug('start 111111');
        Blob pdfBlob = null;
        system.debug('start 22222');
        PageReference retPage = null;
        system.debug('start 333333');
        /**
if ( !Test.isRunningTest() ) {
system.debug('start 444444');
pdfBlob = savePDF.getContentAsPDF();
system.debug('pdfBlob-->'+pdfBlob);

}
else{
pdfBlob = Blob.valueOf('test');

}
system.debug('stop Test');
**/
        try{
            
            system.debug('strat try');
            system.debug('strat Attachment');
            retPage = new PageReference('/apex/yjPDF?id='+requestId);
            /**
Attachment conAttach= new Attachment(
parentId = requestId,
name = strFileName ,
ContentType ='application/pdf',
body = pdfBlob
);
upsert conAttach;
retPage = new PageReference('/servlet/servlet.FileDownload?file='+conAttach.Id);
**/
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