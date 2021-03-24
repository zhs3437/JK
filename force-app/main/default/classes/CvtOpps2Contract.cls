public class CvtOpps2Contract {
    
    //copy Account Infomation to Contract 
    public static Contract CpyAccInfo(Opportunity op,Contract con){
        Account acc = (Account) CommonUtils.GetObjByID('Account',op.AccountId);
        system.debug('-----> CpyAccInfo.acc = '+ acc );
        system.debug('-----> CpyAccInfo.opp = '+ op );
        system.debug('-----> CpyAccInfo.con = '+ con );
        con.AccountId = acc.Id;
        
        // modified in 2014-09-22, active to record insert only
        if( con.Id == null ){
            con.BUYER__c = acc.AccountName2__c;
        }
        
        con.Customer_country__c = acc.Country__c;
        con.Customer_Grade__c = acc.Customer_Grading__c;
        con.Customer_Business_Scale__c = acc.Customer_Business_Type__c;
        con.Phone__c = acc.Phone;
        con.Fax__c = acc.Fax ;
        con.Email__c = acc.Company_Email__c;
        if(acc.Cooperation_method__c == 'OEM')
            con.JINKO_OEM__c = 'OEM';
        else
            con.JINKO_OEM__c = 'Jinko';
        con.BillingStreet = acc.BillingStreet;
        con.BillingCity = acc.BillingCity;
        con.BillingState = acc.BillingState;
        con.BillingPostalCode = acc.BillingPostalCode;
        con.BillingCountry = acc.BillingCountry;
        //获得客户的sapId
        con.SAP_External_ID__c = acc.SAP_External_ID__c;
   
        system.debug('@@@@@@acc.BillingCountry)'+acc.BillingCountry);
        system.debug('@@@@@@con.BillingCountry)'+con.BillingCountry);
        
        
        //copy opps 业务机会
        // neo
        con.InventoryArea__c = op.Type_of_Inventory_or_Production__c;
        con.Branch__c = op.Branch__c;
        con.Destination_Country__c = op.Destination_Country__c ;
        con.Destination__c = op.delivey_point__c ;
        CON.delivery_note_CI__c =op.Customer_Order_Reference_PO__c;
        CON.incoterm_version__c =op.incoterm_version__c;
        con.Not_UK_Pa_c__c=op.Not_Ukraine_Company__c;
        con.Logistic_Special_Cost_Per_W__c = op.Logistic_Special_Cost_Per_W__c;
        con.Ocean_Freight__c = op.Ocean_Freight__c;
        con.Warehouse_Premium__c = op.Warehouse_Premium__c;
        con.Land_Freight_China__c = op.Land_Freight_China__c;
        con.Land_Freight_Oversea__c = op.Land_Freight_Oversea__c;
        con.Local_Warehouse__c = op.Local_Warehouse__c;
        con.Warehouse_or_Factory__c = op.Warehouse_or_Factory__c;
        con.Number_of_Containers__c = op.Number_of_Containers__c;
        con.Ocean_Freight_Oversea__c = op.Ocean_Freight_Oversea__c;
            //+' '+ op.Destination_Port__c;
        con.CurrencyIsoCode = op.CurrencyIsoCode;
        con.opportunity__c = op.Id;
        con.Payment_Method__c = op.Payment_Method__c;
        con.Balance_Payment__c = op.Balance_Payment__c;
        con.Credit_Days__c = op.Credit_Days__c;
            con.Estimated_Gross_Margin_Rate_Old__c = op.Estimated_Gross_Margin_Rate_Old__c;
            con.Estimated_Gross_Margin_Rate_Cheetah_Old__c = op.Estimated_Gross_Margin_Rate_Cheetah_Old__c;
            con.Estimated_Gross_Margin_Rate_Connector_Ol__c = op.Estimated_Gross_Margin_Rate_Connector_Ol__c;
            con.Estimated_Gross_Margin_Rate_Smart_Old__c = op.Estimated_Gross_Margin_Rate_Smart_Old__c;
            con.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c = op.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c;
            con.Estimated_Gross_Margin_Rate_Tiger_Old__c = op.Estimated_Gross_Margin_Rate_Tiger_Old__c;
            con.Estimated_Gross_Margin_Rating_Cheetah_Ol__c = op.Estimated_Gross_Margin_Rating_Cheetah_Ol__c;
            con.Estimated_Gross_Margin_Rating_Old__c = op.Estimated_Gross_Margin_Rating_Old__c;
            con.Estimated_Gross_Margin_Rating_Smart_Old__c = op.Estimated_Gross_Margin_Rating_Smart_Old__c;
            con.Estimated_Gross_Margin_Rating_Tiger_Old__c = op.Estimated_Gross_Margin_Rating_Tiger_Old__c;
            con.Estimated_Gross_Margin_Rating_TigerPOld__c = op.Estimated_Gross_Margin_Rating_TigerPOld__c;
            con.Estimated_Gross_Margin_RatingConnectorOl__c = op.Estimated_Gross_Margin_RatingConnectorOl__c;
            con.Logistic_Special_Cost_Per_W_Old__c = op.Logistic_Special_Cost_Per_W_Old__c;
            con.Ocean_Freight_China_Old__c = op.Ocean_Freight_China_Old__c;
            con.Ocean_Freight_Oversea_Old__c = op.Ocean_Freight_Oversea_Old__c;
            con.TotaGross_Margin_ConnectorOld__c = op.TotaGross_Margin_ConnectorOld__c;
            con.Total_Gross_Margin_Old__c = op.Total_Gross_Margin_Old__c;
            con.Total_Gross_Margin_CheetahOld__c = op.Total_Gross_Margin_CheetahOld__c;
            con.Total_Gross_Margin_SmartOld__c = op.Total_Gross_Margin_SmartOld__c;
            con.Total_Gross_Margin_Tiger_ProOld__c = op.Total_Gross_Margin_Tiger_ProOld__c;
            con.Total_Gross_Margin_TigerOld__c = op.Total_Gross_Margin_TigerOld__c;
            con.Total_Price_CheetahOld__c = op.Total_Price_CheetahOld__c;
            con.Total_Price_ConnectorOld__c = op.Total_Price_ConnectorOld__c;
            con.Total_Price_SmartOld__c = op.Total_Price_SmartOld__c;
            con.Total_Price_Tiger_ProOld__c = op.Total_Price_Tiger_ProOld__c;
            con.Total_Price_TigerOld__c = op.Total_Price_TigerOld__c;
            con.Rate_Old__c = op.Rate_Old__c;
            con.Land_Freight_China_Old__c = op.Land_Freight_China_Old__c;
            con.Land_Freight_Oversea_Old__c = op.Land_Freight_Oversea_Old__c;
        con.Warehouse_Premium_Old__c = op.Warehouse_Premium_Old__c;
        system.debug('con.Payment_Term_Description__c--->'+con.Payment_Term_Description__c);
        system.debug('op.Payment_Term_Description__c--->'+op.Payment_Term_Description__c);
        con.Payment_Term_Description__c = op.Payment_Term_Description__c;
       system.debug('con.Payment_Term_Description__c--->'+con.Payment_Term_Description__c);
        //获取业务机会佣金字段
        if(!String.isEmpty(String.valueof(op.Commision__c))){
        con.Commission_Type__c =op.Commission_Type__c;
        con.Commission__c =op.Commision__c;
        }
        //con.Rebate__c =op.Rebate__c;
        con.Commission_Payee__c=op.Commission_Payee__c;
        con.Discount__c =op.Discount__c;
        con.Rebate__c =op.Rebate__c;
        con.ownerid=op.ownerid;
        //获得业务机会的Actual Sales Name字段值,create by Han
        String oppSalesName ='';       
        oppSalesName =  op.Actual_Sales_Name__c;
        system.debug('oppSalesName'+oppSalesName);
        if(!String.isEmpty(oppSalesName)){
        system.debug('123');
        con.Actual_Sales_Name__c =oppSalesName.toLowerCase();
        if(oppSalesName.toLowerCase().indexOf('arda')>-1 || oppSalesName.toLowerCase().indexOf('kristaporyan')>-1){
            con.SAP_User_ID__c ='80000014';
        }else if(oppSalesName.toLowerCase().indexOf('ezgi')>-1 || oppSalesName.toLowerCase().indexOf('yilmaz')>-1){
            con.SAP_User_ID__c ='80003538';
        }
            }
       // con.CMO_Dept__c = op.Sales_manager_approval__c;
        //if语句由sam添加
        if(op.RecordType.Name  == 'USA'){
            con.CMO_Dept__c = op.Sales_manager_approval__c;
         
            con.CMO_Dept_Comments__c = op.GM_approval_Feedback__c;
        }
        
        
        if(op.Payment_1MW_Approve__c == true ){
            con.Payment_Reivew_Approval__c = '';
        }else{
            con.Payment_Reivew_Approval__c = op.Payment_Reivew_Approval__c;
        }
          
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@'+op.Payment_Term_Description__c);
        con.Perpayment__c = op.Perpayment__c;
        con.Prepaid__c = op.Prepaid__c;
        con.Prepayment_Amount__c = op.Prepayment_Amount__c;
        con.Trade_term__c = op.Trade_Term__c;
        system.debug('con.Trade_term__c -->'+con.Trade_term__c );
        con.Expected_Delivery_Date__c = op.Customer_Delivery_Date__c;
        // create by jason 20160414
        con.SELLER__c = op.Seller__c;
        system.debug('con.Trade_term__c -->'+con.SELLER__c );
        con.Region__c = op.Region__c;
        //create by Han 特殊付款方式同步
      //  con.SpecialPaymentTerm__c = op.SpecialPayment__c;
        //Added by Leo 20180511  如果opp 的warranty为空，那么就不刷这个值过去
        if(op.Warranty_Insurance__c !=null ){
            con.Warranty_Insurance__c = op.Warranty_Insurance__c;
        }
        if(op.Warranty_On_Material_and_Workmanship__c !=null){
             con.Warranty_On_Material_and_Workmanship__c = op.Warranty_On_Material_and_Workmanship__c;
        }
        
        con.Transit_Fees__c=0;
        /**
        if(String.IsNotEmpty(String.valueOf(op.Land_Freight_China__c))){
            con.Transit_Fees__c =con.Transit_Fees__c ;
            
        }
          if(String.IsNotEmpty(String.valueOf(op.Land_Freight_Oversea__c))){
            con.Transit_Fees__c =con.Transit_Fees__c +op.Land_Freight_Oversea__c;
            
        }
          if(String.IsNotEmpty(String.valueOf(op.Ocean_Freight__c))){
            con.Transit_Fees__c =con.Transit_Fees__c +op.Ocean_Freight__c;
            
        }
**/
               system.debug('con.Trade_term__c -->'+con.SELLER__c );
         // create by HanFan 20170927 当生成合同的业务机会类型为美国区的时候，自动将Warranty Insurance，Warranty On Material and Workmanship这两个字段赋值
      /*  if(op.RecordType.Name=='USA'){
          con.Warranty_Insurance__c = op.Warranty_Insurance__c;
          con.Warranty_On_Material_and_Workmanship__c = op.Warranty_On_Material_and_Workmanship__c;
         } */
        
        //获取recordType
        Id rtId = ContractHelper.getContractRecordTypeId(op);
        if(!string.isEmpty(rtId)){
            con.RecordTypeId = rtId;
        }
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID FrameRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Frame Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        ID InventoryRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Inventory Contract').getRecordTypeId();
        ID ProductionInventRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Production & Inventory Contract').getRecordTypeId();
        ID ProductionRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Production Contract').getRecordTypeId();
       //ContractPreviewClick.Contract(con.Id);
       //create by HanFan 20180326
        if(con.RecordTypeId==FrameRecordTypeId || con.RecordTypeId==IntercompanyRecordTypeId ||con.RecordTypeId==InventoryRecordTypeId ||con.RecordTypeId==ProductionInventRecordTypeId ||con.RecordTypeId==ProductionRecordTypeId){
            if(op.RecordType.Name!='Japan' && op.Price_Approval_Status__c !='Approved'){
                       system.debug('测试 -->' );
          // con.Finance_Dept__c = op.Price_Approval_Status__c;            
                }
        }
      //create by HanFan 2017/2/10
        if(con.RecordTypeId == AustraliaRecordTypeId){
            String regEx='(\\d+(\\,\\d+))|(\\d+(\\.\\d+))|(\\d+)'; 
            Pattern p = Pattern.compile(regEx);
            /*
            if(op.Land_Freight_China__c != null){
                String str = op.Land_Freight_China__c;
                
                Matcher m = p.matcher(str); 
            
                 if (m.find()) {  
                        String num=m.group();
                        if(num.contains(',')==true){
                        integer ii=num.indexOf(',');
                        String str1=num.substring(0, ii);
                        String str2=num.substring(ii+1,num.length());
                        num=str1+str2;
                        con.Transit_Fees__c=Double.valueOf(num); 
                    }else{
                     con.Transit_Fees__c=Double.valueOf(num);    
                    }
                    }  
            }else 
                if(op.Land_Freight_Oversea__c != null){
                String str = op.Land_Freight_Oversea__c;
                 Matcher m = p.matcher(str); 
                if (m.find()) {  
                    String num=m.group();
                    if(num.contains(',')==true){
                        integer ii=num.indexOf(',');
                        String str1=num.substring(0, ii);
                        String str2=num.substring(ii+1,num.length());
                        num=str1+str2;
                        con.Transit_Fees__c=Double.valueOf(num); 
                    }else{
                     con.Transit_Fees__c=Double.valueOf(num);    
                    }
                    }  
                    }
*/
                  
/*
            else if(op.Ocean_Freight__c != null){
                String str = op.Ocean_Freight__c;
                 Matcher m = p.matcher(str);
               
                if (m.find()) {  
                    String num=m.group();
                    if(num.contains(',')==true){
                        integer ii=num.indexOf(',');
                        String str1=num.substring(0, ii);
                        String str2=num.substring(ii+1,num.length());
                        num=str1+str2;
                        con.Transit_Fees__c=Double.valueOf(num); 
                    }else{
                     con.Transit_Fees__c=Double.valueOf(num);    
                    }
                  }  
               
            }
*/
        }
    
        List <Contact> contact = [SELECT LastName,FirstName FROM Contact WHERE AccountId=:acc.Id and Primary_Contact__c=true limit 1];
        if( contact.size() > 0 ){
           con.Contact_Name__c = (contact[0].FirstName+' '+contact[0].LastName);
        }
               system.debug('con.Trade_term__c -->'+con.SELLER__c );
        return con; 
    }
    
    public static Product_Detail__c[] CpyOppsLineItem(OpportunityLineItem[] opls ,Contract con){
        /**  copy field's value from OpportunityLineItem to Order Line [insert Product_Detail] **/
        // neo
        // update opls;
        Product_Detail__c[] ols = new List<Product_Detail__c>();
        for(OpportunityLineItem o : opls){
            System.debug('@@@@@@@@@Guaranteed_Delivery_Date_japan__c' + o.Guaranteed_Delivery_Date_japan__c);
            //给合同中的产品信息赋值
            Product_Detail__c ol = new Product_Detail__c();
            //copy fields from the opportunity
            //
            //初次评级数据存储
            ol.Commision_Rebate_Cost_Per_W_Old__c = o.Commision_Rebate_Cost_Per_W__c;
               ol.Estimated_Gross_Margin_Old__c = o.Estimated_Gross_Margin__c;
               ol.Free_Power_W_Old__c = o.Free_Power_W__c;
               ol.Freight_Cost_Per_W_Old__c = o.Freight_Cost_Per_W__c;
               ol.Gross_Margin_Rate_Old__c = o.Gross_Margin_Rate__c;
               ol.Insurence_Cost_Per_W_Old__c = o.Insurence_Cost_Per_W__c;
               ol.Payment_Cost_Per_W_Old__c = o.Payment_Cost_Per_W__c;
               ol.Product_Cost_Old__c = o.Product_Cost__c;
               ol.Special_Material_Cost_Per_W_Old__c = o.Special_Material_Cost_Per_W__c;
               ol.Special_Material_Type_Old__c = o.Special_Material_Type__c;
               ol.Third_Party_Test_Cost_Old__c = o.Third_Party_Test_Cost__c;
               ol.Total_Gross_Margin_Old__c = o.Total_Gross_Margin__c;
               ol.Transfer_Stock_Rate_Old__c = o.Transfer_Stock_Rate__c;
               ol.Special_Material_Old__c = o.Special_Material__c;
            
            ol.Free_Power_W__c = o.Free_Power_W__c;
            ol.Special_Material_Cost_Per_W__c = o.Special_Material_Cost_Per_W__c;
            ol.Third_Party_Test_Cost__c = o.Third_Party_Test_Cost__c;
            ol.Transfer_Stock_Rate__c = o.Transfer_Stock_Rate__c;
            ol.Estimated_Gross_Margin__c = o.Estimated_Gross_Margin__c;
            // neo - copy gross margin because of skip trigger flag true
            ol.Confirmed_Gross_Margin__c = o.Estimated_Gross_Margin__c;
            ol.Commision_Rebate_Cost_Per_W__c = o.Commision_Rebate_Cost_Per_W__c;
            ol.Freight_Cost_Per_W__c = o.Freight_Cost_Per_W__c;
            ol.Payment_Cost_Per_W__c = o.Payment_Cost_Per_W__c;
            ol.Product_Cost__c = o.Product_Cost__c;
            ol.Total_Gross_Margin__c = o.Total_Gross_Margin__c;
            ol.Insurence_Cost_Per_W__c = o.Insurence_Cost_Per_W__c;
            ol.Main_Type__c = o.Main_Type__c;
            ol.Special_Material_Type__c = o.Special_Material_Type__c;
            ol.Special_Material__c = o.Special_Material__c;
            ol.CurrencyIsoCode = con.CurrencyIsoCode;
            ol.MixedDelivery__c =o .MixedDelivery__c;
            ol.Quantity__c = o.Quantity;
            ol.OppProductID__c=o.id;
            ol.Inventorytype__c = o.Inventorytype__c;
            ol.Stock_age__c =o.Stock_age__c;
            system.debug('测试对比'+ o.Stock_age__c);
            system.debug('测试对比'+ ol.Stock_age__c);
            ol.Unit_Price__c = o.UnitPrice;
            ol.Product__c = o.PricebookEntry.product2Id;
            ol.tolerance__c = o.tolerance__c;
            ol.Cheetah__c = o.Cheetah__c;
            ol.Number_of_Cells__c=o.Number_of_Cells__c;
            ol.Weight__c=o.Weight__c;
            ol.Dimensions__c=o.Dimensions__c;
             ol.Cable_length_UK__c=o.Cable_length_UK__c;
            //Requirements
            ol.Solar_Cell__c = o.Solar_Cell__c;
            ol.Back_Sheet__c = o.Back_Sheet__c;
            ol.EVA__c = o.EVA__c;
            ol.Tempered_glass__c = o.Temperd_Glass__c;
            ol.Ribbon__c = o.Ribbon__c;
            ol.Japan_Rate_Tax__c = o.Japan_Rate_Tax__c;
            ol.Total_Price_Tax_Japan__c=o.Total_Price_Tax_Japan__c;
            ol.Test_code__c=o.Test_code__c;
            ol.Opp_Description__c=o.Opp_Description__c;
            if(o.FOB_Sales_Price__c!=null ){
            ol.FOB_Unit_Price__c=o.FOB_Sales_Price__c;
                }
            if(o.FOB_Sales_Price__c==null ){
                 ol.FOB_Unit_Price__c=o.UnitPrice;
                }
            ol.Junction_Box__c = o.Junction_Box_Brand__c;
            //ol.Junction_Box_Type__c = o.Junction_Box_Type__c;
            ol.Frame__c = o.Frame__c;
            ol.Serial_No__c = o.Serial_No__c;
            ol.Package__c = o.Package__c;
            ol.Label__c = o.Label__c;
            ol.Others__c = o.Description;
            ol.Contract_PO_PI__c = con.Id;
            ol.Estimated_Time_of_Departure__c = o.Estimated_Time_of_Departure__c;
            ol.Estimated_Time_of_Departure_ETD__c = o.Estimated_Time_of_Departure_ETD__c;
            ol.Estimated_Time_of_Departure_ETD_7__c = o.Estimated_Time_of_Departure_ETD_7__c;
            ol.Expected_Delivery_Date_ETA__c = o.Expected_Delivery_Date_ETA__c;
            ol.Guaranteed_Delivery_Date_japan__c = o.Guaranteed_Delivery_Date_japan__c;
            ol.Guaranteed_Delivery_Date__c = o.Guaranteed_Delivery_Date__c;
            
            ol.Junction_Box_Type__c = o.Type_of_module__c;
            ol.Battery_Type__c = o.Battery_Type__c;
            ol.Length_of_Junction_Box_wiring__c = o.Wire_Length__c;
            ol.Connector__c = o.ConnectorLine__c;
            ol.Certification__c = o.Certification__c;
            ol.Grade__c = o.Grade__c;
            ol.Color_of_frame_and_backsheet__c = o.Color_of_Module__c;
            ol.Special_required__c = o.Special_required__c;
            ol.Bus_bars_of_cell__c = o.Bus_bars_of_cell__c;
            ol.SAP_Product_Materiel_No__c = o.SAP_Product_Materiel_No__c;
            ol.SAP_Materiel_No__c = o.SAP_Materiel_No__c;
            ol.Total_Price__c = o.TotalPrice;
            ol.Total_MW__c = o.Total_Power_W__c;
            ol.MP__c  = o.MP__c;
            ol.Product_Series__c  = o.Product_Type__c;
            System.debug('@@@@@@@@@Guaranteed_Delivery_Date_japan__c' + o.Guaranteed_Delivery_Date_japan__c);
            System.debug('@@@@@@@@@Guaranteed_Delivery_Date__c' + o.Guaranteed_Delivery_Date__c);
            
            ols.add(ol);
        //}
        
        }
        return ols;
    }
    
    public static void updateInventory(Opportunity op,Contract con){
        try{
            //get Opps's Apply Inventory
            List<Apply_Inventory__c> aiList = [select id from Apply_Inventory__c where Opportunity__c=:op.id ];
            List<Id> AIids = new List<Id>();
            for(Apply_Inventory__c ai:aiList){
                AIids.add(ai.id);
            }
            //Get Distribution Stock
            List<Distribution_Stock__c> dsList = [select id,Contract_PO_PI__c 
                                                                                        from Distribution_Stock__c 
                                                                                        where Apply_Inventory__c in:AIids limit 200];
            //set Distribution_Stock's Contract ID
            for(Distribution_Stock__c ds : dsList){
                ds.Contract_PO_PI__c =con.id;
            }
            //update Distribution_Stock__c
            update dsList;
        }catch(DmlException e){
            //for (Integer i = 0; i < e.getNumDml(); i++) {
              //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            //}
        }
    }
    
    public static void updateProductionScheduled(Opportunity op,Contract con){
        try{
            //get Opps's Apply Inventory
            List<Production_scheduled__c> psList = [select id from Production_scheduled__c where Opportunity__c=:op.id ];
            //set Distribution_Stock's Contract ID
            for(Production_scheduled__c ps : psList){
                ps.Contract_PO_PI__c =con.id;
            }
            //update Distribution_Stock__c
            update psList;
        }catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
    }
    
      
    
    /** these of the following is init static method **/
    
    public static Contract initCon( String theId ){
        system.debug('-----initCon');
        Contract con = null;
        try{
            con = [Select Id , SELLER__c,branch__c, RecordTypeId,Opportunity__c,BillingStreet,Trade_term__c,BillingCity,BillingState,BillingPostalCode,BillingCountry From Contract Where Id =:theId limit 1];
        } catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ==' + e.getDmlMessage(i)));
            }
        }
        return con; 
    }
    
    public static Opportunity initOpp( String theId ){
        system.debug('-----initOpp');
        Opportunity op = null;

        try{
            op =(Opportunity) CommonUtils.GetObjByID('Opportunity',theId); 
        } catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        return op;
    }
   
    public static OpportunityLineItem[] initOpls(String theId){
        system.debug('-----initOpls');
        OpportunityLineItem[] result = null;
         try{
            //get the schema data
            Map<String, Schema.SObjectField> fMap = new Map<String, Schema.SObjectField> ();
            fMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
            String sqlstr = '';
            for (String fName : fMap.keySet()){
                sqlstr = sqlstr + fName+',';
            }
            if(sqlstr.length()>0){
                sqlstr = sqlstr.substring(0,sqlstr.length()-1);
            }
            
            sqlstr = 'select Id,Gross_Margin_Rate__c,TotalPrice,Main_Type__c,Special_Material__c,Special_Material_Type__c,Free_Power_W__c ,Third_Party_Test_Cost__c,Commision_Rebate_Cost_Per_W__c,Insurence_Cost_Per_W__c,Product_Cost__c,Payment_Cost_Per_W__c, Freight_Cost_Per_W__c,Special_Material_Cost_Per_W__c, Total_Gross_Margin__c, Transfer_Stock_Rate__c,Estimated_Gross_Margin__c,Cable_length_UK__c,Test_code__c,Opp_Description__c,Inventorytype__c,Product_Type__c,Dimensions__c,Weight__c,Number_of_Cells__c,Stock_age__c,Bus_bars_of_cell__c,Japan_Rate_Tax__c,Total_Price_Tax_Japan__c,MixedDelivery__c,MP__c,Cheetah__c,FOB_Sales_Price__c,SAP_Product_Materiel_No__c,SAP_Materiel_No__c,Special_required__c,Color_of_Module__c,Grade__c,Certification__c,Type_of_module__c,Total_Power_W__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c,Estimated_Time_of_Departure__c,Estimated_Time_of_Departure_ETD__c,Estimated_Time_of_Departure_ETD_7__c,Expected_Delivery_Date_ETA__c'+
            ' from OpportunityLineItem Where OpportunityId =:theId';
            //query the opportunity
            result = Database.query(sqlstr);
        }
        catch(DmlException e){
         for (Integer i = 0; i < e.getNumDml(); i++) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
           }
        }
        return result;
    }
    
    public static boolean updatePayments(Opportunity op,Contract con){
        List<Payment__c> OppPays = [Select Amount__c,Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                    Condition__c,Credit_Valid__c,Type__c,Opportunity__c,Comments_English__c, Comments_Japan__c,Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c,Comments__c
                    From Payment__c Where Opportunity__c =: op.ID];
       List<Payment__c> opppay2 =new List<Payment__c>();
        for(Payment__c tmp : OppPays){
            if(tmp.Contract__c!=null){
                tmp.Contract__c=null;
                opppay2.add(tmp);
            }
        }
        update Opppay2;
        List<Payment__c> conPays = [Select Amount__c,Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                    Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c,Comments__c
                    From Payment__c Where Contract__c =: con.ID];
        system.debug('~~~~>payment:' + OppPays);
        system.debug('~~~~>payment:' + conPays);
        boolean flag = false;
         List<Payment__c> delPays = new List<Payment__c>(); 
        String conpayment='';
         for(Payment__c tmp : conPays){
             conpayment=conpayment+tmp.Percentage__c+','+tmp.Down_Balance_Payment__c+','+tmp.Payment_Method__c+','
                 +tmp.Payment_Term__c+','+tmp.Days__c+';';
                 delPays.add(tmp);
                 system.debug('~~~~>payment:' + conPays);
             
         }
        system.debug('~~~~>合同的payment:' + conpayment);

        if(delPays.size()>0){
            delete delPays;
        } 
         
        //delete delPays;
        

        
        List<Payment__c> insPays = new List<Payment__c>();
        
        for(Payment__c tmp : OppPays){
            
                Payment__c newPay = new Payment__c();
                        newPay.Down_Balance_Payment__c = tmp.Down_Balance_Payment__c;
                        newPay.Payment_Method__c       = tmp.Payment_Method__c;
                        newPay.Payment_Term__c         = tmp.Payment_Term__c;
                        newPay.Days__c                 = tmp.Days__c;
                        newPay.Contract__c             = con.ID;
                        newPay.Percentage__c           = tmp.Percentage__c;
                        newPay.Precise_Day__c          = tmp.Precise_Day__c;
                        newPay.Comments__c             = tmp.Comments__c;
                        newPay.Credit_Valid__c         = tmp.Credit_Valid__c;
                        newPay.Type__c=tmp.Type__c;
                        newPay.Comments_English__c=tmp.Comments_English__c;
                        newPay.Comments_Japan__c=tmp.Comments_Japan__c;
            String opppayment=tmp.Percentage__c+','+tmp.Down_Balance_Payment__c+','+tmp.Payment_Method__c+','
                 +tmp.Payment_Term__c+','+tmp.Days__c+';';
            if(conpayment.contains(opppayment)){}
            else{flag=true;}
            insPays.add(newPay);
        }
                    
        upsert insPays;
        return flag;
    }
    
    @Future(callout=true)
    public static void historyOpp(String ids){
        Opportunity op = [Select id,Estimated_Gross_Margin_Rate_Old__c , Weighted_Gross_Margin_Rate__c,
            Estimated_Gross_Margin_Rate_Cheetah_Old__c ,Weighted_Gross_Margin_Rate_Cheetah__c,
            Estimated_Gross_Margin_Rate_Connector_Ol__c ,Weighted_Gross_Margin_Rate_Connector__c,
            Estimated_Gross_Margin_Rate_Smart_Old__c , Weighted_Gross_Margin_Rate_Smart__c,
            Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c , Weighted_Gross_Margin_Rate_TigerPro__c,
            Estimated_Gross_Margin_Rate_Tiger_Old__c , Weighted_Gross_Margin_Rate_Tiger__c,
            Estimated_Gross_Margin_Rating_Cheetah_Ol__c , Gross_Margin_Rating_Cheetah__c,
            Estimated_Gross_Margin_Rating_Old__c , Gross_Margin_Rating__c,
            Estimated_Gross_Margin_Rating_Smart_Old__c , Gross_Margin_Rating_Smart__c,
            Estimated_Gross_Margin_Rating_Tiger_Old__c , Gross_Margin_Rating_Tiger__c,
            Estimated_Gross_Margin_Rating_TigerPOld__c , Gross_Margin_Rating_TigerPro__c,
            Estimated_Gross_Margin_RatingConnectorOl__c , Gross_Margin_Rating_Connector__c,
            Logistic_Special_Cost_Per_W_Old__c , Logistic_Special_Cost_Per_W__c,
            Ocean_Freight_China_Old__c , Ocean_Freight__c,
            Ocean_Freight_Oversea_Old__c , Ocean_Freight_Oversea__c,
            TotaGross_Margin_ConnectorOld__c , Total_Gross_Margin_Connector__c,
            Total_Gross_Margin_Old__c , Total_Gross_Margin__c,
            Total_Gross_Margin_CheetahOld__c , Total_Gross_Margin_Cheetah__c,
            Total_Gross_Margin_SmartOld__c , Total_Gross_Margin_Smart__c,
            Total_Gross_Margin_Tiger_ProOld__c , Total_Gross_Margin_TigerPro__c,
            Total_Gross_Margin_TigerOld__c , Total_Gross_Margin_Tiger__c,
            Total_Price_CheetahOld__c , Total_Price_Cheetah__c,
            Total_Price_ConnectorOld__c , Total_Price_Connector__c,
            Total_Price_SmartOld__c , Total_Price_Smart__c,
            Total_Price_Tiger_ProOld__c , Total_Price_TigerPro__c,
            Total_Price_TigerOld__c , Total_Price_Tiger__c,
            Rate_Old__c , Rate__c,
            Land_Freight_China_Old__c , Land_Freight_China__c,
            Land_Freight_Oversea_Old__c , Land_Freight_Oversea__c,
            Warehouse_Premium_Old__c , Warehouse_Premium__c from opportunity where id=:ids];
            op.Estimated_Gross_Margin_Rate_Old__c = op.Weighted_Gross_Margin_Rate__c;
            op.Estimated_Gross_Margin_Rate_Cheetah_Old__c = op.Weighted_Gross_Margin_Rate_Cheetah__c;
            op.Estimated_Gross_Margin_Rate_Connector_Ol__c = op.Weighted_Gross_Margin_Rate_Connector__c;
            op.Estimated_Gross_Margin_Rate_Smart_Old__c = op.Weighted_Gross_Margin_Rate_Smart__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c = op.Weighted_Gross_Margin_Rate_TigerPro__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Old__c = op.Weighted_Gross_Margin_Rate_Tiger__c;
            op.Estimated_Gross_Margin_Rating_Cheetah_Ol__c = op.Gross_Margin_Rating_Cheetah__c;
            op.Estimated_Gross_Margin_Rating_Old__c = op.Gross_Margin_Rating__c;
            op.Estimated_Gross_Margin_Rating_Smart_Old__c = op.Gross_Margin_Rating_Smart__c;
            op.Estimated_Gross_Margin_Rating_Tiger_Old__c = op.Gross_Margin_Rating_Tiger__c;
            op.Estimated_Gross_Margin_Rating_TigerPOld__c = op.Gross_Margin_Rating_TigerPro__c;
            op.Estimated_Gross_Margin_RatingConnectorOl__c = op.Gross_Margin_Rating_Connector__c;
            op.Logistic_Special_Cost_Per_W_Old__c = op.Logistic_Special_Cost_Per_W__c;
            op.Ocean_Freight_China_Old__c = op.Ocean_Freight__c;
            op.Ocean_Freight_Oversea_Old__c = op.Ocean_Freight_Oversea__c;
            op.TotaGross_Margin_ConnectorOld__c = op.Total_Gross_Margin_Connector__c;
            op.Total_Gross_Margin_Old__c = op.Total_Gross_Margin__c;
            op.Total_Gross_Margin_CheetahOld__c = op.Total_Gross_Margin_Cheetah__c;
            op.Total_Gross_Margin_SmartOld__c = op.Total_Gross_Margin_Smart__c;
            op.Total_Gross_Margin_Tiger_ProOld__c = op.Total_Gross_Margin_TigerPro__c;
            op.Total_Gross_Margin_TigerOld__c = op.Total_Gross_Margin_Tiger__c;
            op.Total_Price_CheetahOld__c = op.Total_Price_Cheetah__c;
            op.Total_Price_ConnectorOld__c = op.Total_Price_Connector__c;
            op.Total_Price_SmartOld__c = op.Total_Price_Smart__c;
            op.Total_Price_Tiger_ProOld__c = op.Total_Price_TigerPro__c;
            op.Total_Price_TigerOld__c = op.Total_Price_Tiger__c;
            op.Rate_Old__c = op.Rate__c;
            op.Land_Freight_China_Old__c = op.Land_Freight_China__c;
            op.Land_Freight_Oversea_Old__c = op.Land_Freight_Oversea__c;
           op.Warehouse_Premium_Old__c = op.Warehouse_Premium__c;
        update op;
        
        Contract con = [Select id,Estimated_Gross_Margin_Rate_Old__c,
            Estimated_Gross_Margin_Rate_Cheetah_Old__c,
            Estimated_Gross_Margin_Rate_Connector_Ol__c,
            Estimated_Gross_Margin_Rate_Smart_Old__c,
            Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c,
            Estimated_Gross_Margin_Rate_Tiger_Old__c,
            Estimated_Gross_Margin_Rating_Cheetah_Ol__c,
            Estimated_Gross_Margin_Rating_Old__c,
            Estimated_Gross_Margin_Rating_Smart_Old__c,
            Estimated_Gross_Margin_Rating_Tiger_Old__c,
            Estimated_Gross_Margin_Rating_TigerPOld__c,
            Estimated_Gross_Margin_RatingConnectorOl__c,
            Logistic_Special_Cost_Per_W_Old__c,
            Ocean_Freight_China_Old__c,
            Ocean_Freight_Oversea_Old__c,
            TotaGross_Margin_ConnectorOld__c,
            Total_Gross_Margin_Old__c,
            Total_Gross_Margin_CheetahOld__c,
            Total_Gross_Margin_SmartOld__c,
            Total_Gross_Margin_Tiger_ProOld__c,
            Total_Gross_Margin_TigerOld__c,
            Total_Price_CheetahOld__c,
            Total_Price_ConnectorOld__c,
            Total_Price_SmartOld__c,
            Total_Price_Tiger_ProOld__c,
            Total_Price_TigerOld__c,
            Rate_Old__c,
            Land_Freight_China_Old__c,
            Land_Freight_Oversea_Old__c,
            Warehouse_Premium_Old__c from contract where Opportunity__c=:ids];
        con.Estimated_Gross_Margin_Rate_Old__c = op.Estimated_Gross_Margin_Rate_Old__c;
            con.Estimated_Gross_Margin_Rate_Cheetah_Old__c = op.Estimated_Gross_Margin_Rate_Cheetah_Old__c;
            con.Estimated_Gross_Margin_Rate_Connector_Ol__c = op.Estimated_Gross_Margin_Rate_Connector_Ol__c;
            con.Estimated_Gross_Margin_Rate_Smart_Old__c = op.Estimated_Gross_Margin_Rate_Smart_Old__c;
            con.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c = op.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c;
            con.Estimated_Gross_Margin_Rate_Tiger_Old__c = op.Estimated_Gross_Margin_Rate_Tiger_Old__c;
            con.Estimated_Gross_Margin_Rating_Cheetah_Ol__c = op.Estimated_Gross_Margin_Rating_Cheetah_Ol__c;
            con.Estimated_Gross_Margin_Rating_Old__c = op.Estimated_Gross_Margin_Rating_Old__c;
            con.Estimated_Gross_Margin_Rating_Smart_Old__c = op.Estimated_Gross_Margin_Rating_Smart_Old__c;
            con.Estimated_Gross_Margin_Rating_Tiger_Old__c = op.Estimated_Gross_Margin_Rating_Tiger_Old__c;
            con.Estimated_Gross_Margin_Rating_TigerPOld__c = op.Estimated_Gross_Margin_Rating_TigerPOld__c;
            con.Estimated_Gross_Margin_RatingConnectorOl__c = op.Estimated_Gross_Margin_RatingConnectorOl__c;
            con.Logistic_Special_Cost_Per_W_Old__c = op.Logistic_Special_Cost_Per_W_Old__c;
            con.Ocean_Freight_China_Old__c = op.Ocean_Freight_China_Old__c;
            con.Ocean_Freight_Oversea_Old__c = op.Ocean_Freight_Oversea_Old__c;
            con.TotaGross_Margin_ConnectorOld__c = op.TotaGross_Margin_ConnectorOld__c;
            con.Total_Gross_Margin_Old__c = op.Total_Gross_Margin_Old__c;
            con.Total_Gross_Margin_CheetahOld__c = op.Total_Gross_Margin_CheetahOld__c;
            con.Total_Gross_Margin_SmartOld__c = op.Total_Gross_Margin_SmartOld__c;
            con.Total_Gross_Margin_Tiger_ProOld__c = op.Total_Gross_Margin_Tiger_ProOld__c;
            con.Total_Gross_Margin_TigerOld__c = op.Total_Gross_Margin_TigerOld__c;
            con.Total_Price_CheetahOld__c = op.Total_Price_CheetahOld__c;
            con.Total_Price_ConnectorOld__c = op.Total_Price_ConnectorOld__c;
            con.Total_Price_SmartOld__c = op.Total_Price_SmartOld__c;
            con.Total_Price_Tiger_ProOld__c = op.Total_Price_Tiger_ProOld__c;
            con.Total_Price_TigerOld__c = op.Total_Price_TigerOld__c;
            con.Rate_Old__c = op.Rate_Old__c;
            con.Land_Freight_China_Old__c = op.Land_Freight_China_Old__c;
            con.Land_Freight_Oversea_Old__c = op.Land_Freight_Oversea_Old__c;
        con.Warehouse_Premium_Old__c = op.Warehouse_Premium_Old__c;
        update con;
        
        List<OpportunityLineItem> oppItem =[SELECT id,
                                                   Opportunity.Id,
                                               Commision_Rebate_Cost_Per_W_Old__c,
                                               Commision_Rebate_Cost_Per_W__c,
                                               Estimated_Gross_Margin_Old__c,
                                               Estimated_Gross_Margin__c,
                                               Free_Power_W__c,
                                               Free_Power_W_Old__c,
                                               Freight_Cost_Per_W_Old__c,
                                               Freight_Cost_Per_W__c,
                                               Gross_Margin_Rate_Old__c,
                                               Gross_Margin_Rate__c,
                                               Insurence_Cost_Per_W_Old__c,
                                               Insurence_Cost_Per_W__c,
                                               Payment_Cost_Per_W_Old__c,
                                               Payment_Cost_Per_W__c,
                                               Product_Cost_Old__c,
                                               Product_Cost__c,
                                               Special_Material_Cost_Per_W_Old__c,
                                               Special_Material_Cost_Per_W__c,
                                               Special_Material_Type_Old__c,
                                               Special_Material_Type__c,
                                               Third_Party_Test_Cost_Old__c,
                                               Third_Party_Test_Cost__c,
                                               Total_Gross_Margin_Old__c,
                                               Total_Gross_Margin__c,
                                               Transfer_Stock_Rate_Old__c,
                                               Transfer_Stock_Rate__c,
                                               Special_Material_Old__c,
                                               Special_Material__c
                                            FROM OpportunityLineItem
                                            WHERE Opportunity.Id = :ids];
           for(OpportunityLineItem o : oppItem){
               o.Commision_Rebate_Cost_Per_W_Old__c = o.Commision_Rebate_Cost_Per_W__c;
               o.Estimated_Gross_Margin_Old__c = o.Estimated_Gross_Margin__c;
               o.Free_Power_W_Old__c = o.Free_Power_W__c;
               o.Freight_Cost_Per_W_Old__c = o.Freight_Cost_Per_W__c;
               o.Gross_Margin_Rate_Old__c = o.Gross_Margin_Rate__c;
               o.Insurence_Cost_Per_W_Old__c = o.Insurence_Cost_Per_W__c;
               o.Payment_Cost_Per_W_Old__c = o.Payment_Cost_Per_W__c;
               o.Product_Cost_Old__c = o.Product_Cost__c;
               o.Special_Material_Cost_Per_W_Old__c = o.Special_Material_Cost_Per_W__c;
               o.Special_Material_Type_Old__c = o.Special_Material_Type__c;
               o.Third_Party_Test_Cost_Old__c = o.Third_Party_Test_Cost__c;
               o.Total_Gross_Margin_Old__c = o.Total_Gross_Margin__c;
               o.Transfer_Stock_Rate_Old__c = o.Transfer_Stock_Rate__c;
               o.Special_Material_Old__c = o.Special_Material__c;
           }
           update oppItem;
        
               List<Product_Detail__c> ols = [select id,
                                              Commision_Rebate_Cost_Per_W__c,
                                              Estimated_Gross_Margin__c,
                                              Free_Power_W__c,
                                              Freight_Cost_Per_W__c,
                                              Gross_Margin_Rate__c,
                                              Insurence_Cost_Per_W__c,
                                              Payment_Cost_Per_W__c,
                                              Product_Cost__c,
                                              Special_Material_Cost_Per_W__c,
                                              Special_Material_Type__c,
                                              Third_Party_Test_Cost__c,
                                              Total_Gross_Margin__c,
                                              Transfer_Stock_Rate__c,
                                              Special_Material__c from Product_Detail__c where Contract_PO_PI__c=:con.id];
        for(OpportunityLineItem o : oppItem){
        for(Product_Detail__c ol : ols){
            ol.Commision_Rebate_Cost_Per_W_Old__c = o.Commision_Rebate_Cost_Per_W__c;
               ol.Estimated_Gross_Margin_Old__c = o.Estimated_Gross_Margin__c;
               ol.Free_Power_W_Old__c = o.Free_Power_W__c;
               ol.Freight_Cost_Per_W_Old__c = o.Freight_Cost_Per_W__c;
               ol.Gross_Margin_Rate_Old__c = o.Gross_Margin_Rate__c;
               ol.Insurence_Cost_Per_W_Old__c = o.Insurence_Cost_Per_W__c;
               ol.Payment_Cost_Per_W_Old__c = o.Payment_Cost_Per_W__c;
               ol.Product_Cost_Old__c = o.Product_Cost__c;
               ol.Special_Material_Cost_Per_W_Old__c = o.Special_Material_Cost_Per_W__c;
               ol.Special_Material_Type_Old__c = o.Special_Material_Type__c;
               ol.Third_Party_Test_Cost_Old__c = o.Third_Party_Test_Cost__c;
               ol.Total_Gross_Margin_Old__c = o.Total_Gross_Margin__c;
               ol.Transfer_Stock_Rate_Old__c = o.Transfer_Stock_Rate__c;
               ol.Special_Material_Old__c = o.Special_Material__c;
               
          }     
        }
               update ols;
        
    }
    public static testMethod void onTest(){
        Account acc  = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '333';
        con.Opportunity__c = opp.Id;
        insert con;
        Opportunity o = CvtOpps2Contract.initOpp(opp.Id);
        Contract c = CvtOpps2Contract.initCon(con.Id);
        c = CvtOpps2Contract.CpyAccInfo(o, c);
        Product2 p = TestHelper.createProduct2();
        PriceBookEntry pbe = TestHelper.createPriceBookEntry(p.Id);
        OpportunityLineItem oppLine = TestHelper.createOpportunityLineItem(opp.Id, pbe.Id);
        List<OpportunityLineItem> oppLines = new List<OpportunityLineItem>();
        oppLines.add(oppLine);
        CvtOpps2Contract.initOpls(opp.Id);
        //Product_Detail__c pd = TestHelper.createProductDetail();
        //List<Product_Detail__c> pds = new List<Product_Detail__c>();
        //pds.add(pd);
        CvtOpps2Contract.CpyOppsLineItem(oppLines, c);
        CvtOpps2Contract.updatePayments(opp, con);
        CvtOpps2Contract.historyOpp(opp.Id);
        CvtOpps2Contract.updateInventory(o, c);
        CvtOpps2Contract.updateProductionScheduled(o, c);
        
        /*
        system.debug('------------- prepare date ----------------');
        testPrepare testdata = new testPrepare();
        system.debug('------------- prepare date done!----------------');
        
        // part one - initOpp
        Opportunity op = CvtOpps2Contract.initOpp(testdata.o1.Id);
        //System.assertEquals( op.Name , '2MW-JKM190-20130101' );
        // part two - initCon
        Contract con = CvtOpps2Contract.initCon(testdata.c1.Id);
        System.assertEquals( con.Id, testdata.c1.Id );
        // part three - CpyAccInfo
        con = CvtOpps2Contract.CpyAccInfo(op, con);
        System.assertEquals( con.AccountId , op.AccountId );
        System.assertEquals( con.Credit_Days__c , op.Credit_Days__c );
        // part four
        System.assertNotEquals( con , null );
        System.assertEquals( con.Payment_Term_Description__c , op.Payment_Term_Description__c );
        // part five - initOpls
        OpportunityLineItem[] opls = CvtOpps2Contract.initOpls(testdata.o1.Id);
        System.assert( opls.size() > 0 );
        // part six - CpyOppsLineItem
        Product_Detail__c[] oList = CvtOpps2Contract.CpyOppsLineItem(opls, con);
        System.assert( oList.size() > 0 );
        
        CvtOpps2Contract.updateInventory(op, con);
        CvtOpps2Contract.updateProductionScheduled(op, con);
        */
    }
}