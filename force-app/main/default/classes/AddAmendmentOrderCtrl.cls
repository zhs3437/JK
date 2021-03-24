public class AddAmendmentOrderCtrl {
    public order mp{get;set;}
    public String requestId{get;set;}
    public order lm {get;set;}
        public decimal  LogisticsCost {get;set;}
    public String deleteID {get;set;}
    public List<order> Orderlst {get;set;}
    public List<Payment__c> Plst {get;set;}
    public List<OrderItem> Oslst {get;set;}
    public String yuyan {get;set;}
    public List<Amendment_Order_Product__c> aop {get;set;}
    Public List<Amendment_Payment__c> aps {get;set;}
    public AddAmendmentOrderCtrl(ApexPages.StandardController sd){
        system.debug('deleteID:'+deleteID);
        requestId = ApexPages.currentPage().getParameters().get('id');
        lm = [select id,lock__c from order where id =: requestId];
        
        system.debug(requestId);
        if(requestId != null){
            this.mp = (order)UtilClass.GetObjByID(Schema.SObjectType.order,requestId);
        }
        LoadDataList();
    }
    public void LoadDataList(){
        
        Orderlst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.order) + ' ' +
                                  'Where id =: requestId');
        Oslst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem) + ' ' +
                             'Where OrderID =: requestId');
        Plst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c) + ' ' +
                            'Where Order__c =: requestId');
        system.debug('Orderlst===:'+Orderlst);
        system.debug('mp===:'+mp);
        aop=new List<Amendment_Order_Product__c>();
        yuyan=Orderlst[0].CurrencyIsoCode; 
        aps=new List<Amendment_Payment__c>();
        system.debug('货币:'+yuyan);
        
        
        for(Integer i = 1 ; i < Plst.size()+1 ; i++ ){
            system.debug('Request_No__c:'+i);
            
            
            Payment__c oi=Plst[i-1];
            system.debug('oi.Percentage__c:'+oi.Percentage__c);
            Amendment_Payment__c ap =new Amendment_Payment__c();
            ap.ID__c=oi.ID;
            ap.Request_No__c=i;
            ap.Comments__c=oi.Comments__c;
            ap.Credit_Valid__c=oi.Credit_Valid__c;
            ap.Days__c=oi.Days__c;
            ap.Down_Balance_Payment__c=oi.Down_Balance_Payment__c;
            ap.Payment_Method__c=oi.Payment_Method__c;
            if(oi.Payment_Term__c=='after warranty start date'||oi.Payment_Term__c=='at sight'
               ||oi.Payment_Term__c=='after C/I date'||oi.Payment_Term__c=='net from Commercial invoice date'
              ||oi.Payment_Term__c=='after goods arrival at the destination'||oi.Payment_Term__c=='ETA Date'
              ||oi.Payment_Term__c=='EXW warehouse'||oi.Payment_Term__c=='__'
              ||oi.Payment_Term__c=='Before ETA'||oi.Payment_Term__c=='after Buyer receives the scan copy of telex release bill of lading'
              ||oi.Payment_Term__c=='latest payment day (specify)'||oi.Payment_Term__c=='after Commercial Operation Date'
              ||oi.Payment_Term__c=='after Final Acceptance Certificate'||oi.Payment_Term__c=='after Provisional Acceptance Certificate'
              ||oi.Payment_Term__c=='after goods arrival at oversea warehouse and inspection'||oi.Payment_Term__c=='after EXW factory date'
              ||oi.Payment_Term__c=='upon receipt of orignial BL'||oi.Payment_Term__c=='upon copy of B/L'
              ||oi.Payment_Term__c=='after month-end of invoicing date'||oi.Payment_Term__c=='after month-end of of B/L date'
              ||oi.Payment_Term__c=='after month-end of of CMR date'||oi.Payment_Term__c=='after delivery to site'
               ||oi.Payment_Term__c=='After ETD'||oi.Payment_Term__c=='after B/L date'
               ||oi.Payment_Term__c=='before ETD'||oi.Payment_Term__c=='at precise day (specify)'
               ||oi.Payment_Term__c=='after contract execution'||oi.Payment_Term__c=='after PO date'
               ||oi.Payment_Term__c=='before delivery to site'||oi.Payment_Term__c=='before arrival at destination port'
               ||oi.Payment_Term__c=='before arrival at intermediate port'||oi.Payment_Term__c=='net from invoice date'
               ||oi.Payment_Term__c=='before delivery from seller\'s warehouse'||oi.Payment_Term__c=='before pickup from seller\'s warehouse'
               ||oi.Payment_Term__c=='before pickup from seller\'s factory'||oi.Payment_Term__c=='Before shipment from the warehouse'
               ||oi.Payment_Term__c=='Before shipment from the port'||oi.Payment_Term__c=='After ETA'||oi.Payment_Term__c=='Before EXW warehouse'
              ){
                  ap.Payment_Term__c=null;
              }else{
            ap.Payment_Term__c=oi.Payment_Term__c;
              }
            ap.Percentage__c=oi.Percentage__c;
            system.debug('ap.Percentage__c:'+ap.Percentage__c);
            ap.Precise_Day__c=oi.Precise_Day__c;
            aps.add(ap);         
        }
        for(Integer i = 1 ; i < Oslst.size()+1 ; i++ ){
            system.debug('Request_No__c:'+i);
            OrderItem oi=Oslst[i-1];
            Amendment_Order_Product__c ao =new Amendment_Order_Product__c();
            system.debug('Request_No__c2:'+i);
            ao.Request_No__c=i;
            system.debug('Request_No__c3:'+ao.Request_No__c);
            ao.CurrencyIsoCode=yuyan;
            ao.Cheetah__c=oi.Cheetah__c; 
            ao.ID__c=oi.id; 
            ao.AvailableQuantity__c=oi.AvailableQuantity;
            ao.Battery_Type__c=oi.Battery_Type__c;
            ao.Bus_bars_of_cell__c=oi.Bus_bars_of_cell__c;
            ao.Certification__c=oi.Certification__c;
            ao.Color_of_frame_and_backsheet__c=oi.Color_of_frame_and_backsheet__c;
            ao.Connector__c=oi.Connector__c;
            ao.EndDate__c=oi.EndDate;
            ao.Expected_delivery_date__c=oi.Expected_delivery_date__c;
            ao.Grade__c=oi.Grade__c;
            ao.Guaranteed_Delivery_Date__c=oi.Guaranteed_Delivery_Date__c;
            ao.Guaranteed_Delivery_Date_japan__c=oi.Guaranteed_Delivery_Date_japan__c;
            ao.Guaranteed_ETD__c=oi.Requested_ETD__c;
            ao.Guaranteed_Ex_work_date__c=oi.Requested_Ex_work_date__c;
            ao.ISTBD__c=oi.IS_TBD__c;
            ao.Length_of_Junction_Box_wiring__c=oi.Length_of_Junction_Box_wiring__c;
            ao.Description__c=oi.Description;
            ao.ListPrice__c=oi.ListPrice;
            ao.M_P__c=oi.MP__c;
            ao.MaterielNo__c=oi.MaterielNo__c;
            ao.Order__c=oi.Orderid;
            if(oi.product_active__c==false){
            List<product2> p3=  [select id from product2 where name=:oi.Product_Name__c and isactive=true];
            if(p3.size()>0){
                ao.Product2__c=p3[0].id;
            }
                }
            else{
                ao.Product2__c=oi.product2id;
            }
               
            ao.Product_Code__c=oi.OrderItemNumber;
            ao.Quantity__c=oi.Quantity;
            ao.QuoteLineItem__c=oi.QuoteLineItemid;
            ao.Remarks__c=oi.Remarks__c;
            ao.Requested_Goods_Ready_date__c=oi.Requested_Goods_Ready_date__c;
            ao.RowNo__c=oi.RowNo__c;
            ao.SAP_Product_Materiel_No__c=oi.SAP_Product_Materiel_No__c;
            ao.Special_required__c=oi.Special_required__c;
            ao.ServiceDate__c=oi.ServiceDate;
            ao.Total_MW__c=oi.Total_MW__c;
            ao.total_Price__c=oi.Total_Price__c;
            ao.TotalPriceBackstage__c=oi.TotalPrice;
            ao.UnitPrice__c=oi.UnitPrice;
            ao.Type_of_module__c=oi.Type_of_module__c;
            ao.unit_Price__c=oi.Unit_Price__c;
            aop.add(ao);
        }
        system.debug('列表:'+aop);
    }
    public PageReference Cancel(){
        PageReference pr = new PageReference('/'+requestId);
        return pr;
    }
    public void addOrderItem(){
        integer num=aop.size();
        aop.add(new Amendment_Order_Product__c(CurrencyIsoCode=yuyan,Order__c=requestId,Request_No__c=num+1));
    }
    public void addPayment(){
        integer num=aps.size();
        aps.add(new Amendment_Payment__c(Request_No__c=num+1));
    }
    public PageReference SelectDailyDetail(){
        String flag='0';
        boolean tf=lm.lock__c;
        lm.lock__c=false;
        update lm;
        List<Amendment__c> aList =[select id from Amendment__c where Order__c=:requestId and soclock__c=:false];
        if(aList.size()==0){
            flag='1';
        }
        system.debug('aop:'+aop);
        
        Amendment__c am=new Amendment__c();
        am.Summary_Comments__c=Orderlst[0].Summary_Comments__c;
        am.name=Orderlst[0].OrderNumber+'   V'+(aList.size()+1);
        am.Order__c=requestId;
        am.CurrencyIsoCode=Orderlst[0].CurrencyIsoCode;
                am.Commission_Payee__c=Orderlst[0].Commission_Payee__c;
        am.TotalAmount__c=Orderlst[0].TotalAmount;
        am.Account_Allocation_Group__c=Orderlst[0].Account_Allocation_Group__c;
        am.Account_Group__c=Orderlst[0].Account_Group__c;
        am.Discount__c						   =  Orderlst[0].Discount__c  ;
        am.Rebate__c						   =  Orderlst[0].Rebate__c;
        am.Sales_1__c						   =  Orderlst[0].Sales_1__c;
        am.Sales_1_percentage__c              = Orderlst[0].Sales_1_percentage__c;
        am.Sales_2__c						   =  Orderlst[0].Sales_2__c;
        am.Sales_2_percentage__c              = Orderlst[0].Sales_2_percentage__c;
        am.Sales_3__c						   =  Orderlst[0].Sales_3__c;
        am.Sales_3_percentage__c              = Orderlst[0].Sales_3_percentage__c;
        am.Account_Holder__c=Orderlst[0].Account_Holder__c;
        am.LogisticsCost__c=LogisticsCost;
        am.Account__c=Orderlst[0].AccountId;
        am.Account_Title__c=Orderlst[0].Account_Title__c;
        am.ActivatedBy__c=Orderlst[0].ActivatedById;
        am.ActivatedDate__c=Orderlst[0].ActivatedDate;
        am.Actual_Sales_Name__c=Orderlst[0].Actual_Sales_Name__c;
        am.Applicant_Direct_Superior__c=Orderlst[0].Applicant_Direct_Superior__c;
        am.Authorized_Representative__c=Orderlst[0].Authorized_Representative__c;
        am.Avg_Price_W__c=Orderlst[0].Avg_Price_W__c;
        am.Bank_Account__c=Orderlst[0].Bank_Account__c;
        am.Bank_City__c=Orderlst[0].Bank_City__c;
        am.Bank_Code__c=Orderlst[0].Bank_Code__c;
        am.Bank_Country__c=Orderlst[0].Bank_Country__c;
        am.Bank_Information_Content__c=Orderlst[0].Bank_Information_Content__c;
        am.Bank_Name__c=Orderlst[0].Bank_Name__c;
        am.Bank_Region__c=Orderlst[0].Bank_Region__c;
        am.Bank_Street__c=Orderlst[0].Bank_Street__c;
        am.BankInfo__c=Orderlst[0].BankInfo__c;
        am.BillToContact__c=Orderlst[0].BillToContactId;
        am.BillingCity__c=Orderlst[0].BillingCity;
        am.BillingCountry__c=Orderlst[0].BillingCountry;
        am.BillingPostalCode__c=Orderlst[0].BillingPostalCode;
        am.BillingState__c=Orderlst[0].BillingState;
        am.BillingStreet__c=Orderlst[0].BillingStreet;
        am.BMO_SR__c=Orderlst[0].BMO_SR__c;
        am.BSB_Number__c=Orderlst[0].BSB_Number__c;
        am.Buyer__c=Orderlst[0].Buyer__c;
        am.CC_No__c=Orderlst[0].CC_No__c;
        am.Commission__c=Orderlst[0].Commission__c;
        am.Commission_Type__c=Orderlst[0].Commission_Type__c;
        am.CompanyAuthorizedBy__c=Orderlst[0].CompanyAuthorizedById;
        am.CompanyAuthorizedDate__c=Orderlst[0].CompanyAuthorizedDate;
        am.Company_Registration_No__c=Orderlst[0].Company_Registration_No__c;
        am.Contact_Name__c=Orderlst[0].Contact_Name__c;
        //    am.ContractEndDate__c=Orderlst[0].Contract.EndDate;
        //   am.ContractName__c=Orderlst[0].Contract.Name;
        am.Contract__c=Orderlst[0].ContractId;
        am.Contract_No__c=Orderlst[0].Contract_No__c;
        am.Contract_Owner__c=Orderlst[0].Contract_Owner__c;
        am.Country_Scope__c=Orderlst[0].Country_Scope__c;
        am.CustomerAuthorizedBy__c=Orderlst[0].CustomerAuthorizedByid;
        am.CustomerAuthorizedDate__c=Orderlst[0].CustomerAuthorizedDate;
        am.Customer_Business_Scale__c=Orderlst[0].Customer_Business_Scale__c;
        am.Customer_country__c=Orderlst[0].Customer_country__c;
        am.delivery_note_CI__c=Orderlst[0].delivery_note_CI__c;
        am.Description__c=Orderlst[0].Description;
        am.Destination__c=Orderlst[0].Destination__c;
        am.Destination_Country__c=Orderlst[0].Destination_Country__c;
        am.Distribution_channel__c=Orderlst[0].Distribution_channel__c;
        am.Email__c=Orderlst[0].Email__c;
        am.Emergency_level__c=Orderlst[0].Emergency_level__c;
        am.Factory__c=Orderlst[0].Factory__c;
        am.Fax__c=Orderlst[0].Fax__c;
        am.GST_Classification_Region__c=Orderlst[0].GST_Classification_Region__c;
        am.IBAN_Code__c=Orderlst[0].IBAN_Code__c;
        am.Intercompany_Seller_POs__c=Orderlst[0].Intercompany_Seller_POs__c;
        am.Ledger_Name__c=Orderlst[0].Ledger_Name__c;
        am.MaxRowNo__c=Orderlst[0].MaxRowNo__c;
        am.Normal__c=Orderlst[0].Normal__c;
        am.OA_External_ID__c=Orderlst[0].OA_External_ID__c;
        am.Operate_Type__c=Orderlst[0].Operate_Type__c;
        am.Opportunity__c=Orderlst[0].Opportunity__c;
        am.EndDate__c=Orderlst[0].EndDate;
        am.Name__c=Orderlst[0].Name;
        am.OrderReferenceNumber__c=Orderlst[0].OrderReferenceNumber;
        am.EffectiveDate__c=Orderlst[0].EffectiveDate;
        am.OriginalOrder__c=Orderlst[0].OriginalOrderid;
        am.Other__c=Orderlst[0].Other__c;
        am.Payment_Term_Description__c=Orderlst[0].Payment_Term_Description__c;
        am.Phone__c=Orderlst[0].Phone__c;
        am.PMC_confirm__c=Orderlst[0].PMC_confirm__c;
        am.PODate__c=Orderlst[0].PODate;
        am.PONumber__c=Orderlst[0].PONumber;
        am.Product_Group__c=Orderlst[0].Product_Group__c;
        am.Progress_Remarks__c=Orderlst[0].Progress_Remarks__c;
        am.Quote__c=Orderlst[0].Quoteid;
        am.IsReductionOrder__c=Orderlst[0].IsReductionOrder;
        am.Region__c=Orderlst[0].Region__c;
        am.Requested_supplier__c=Orderlst[0].Requested_supplier__c;
        am.Routing_Number_ABA__c=Orderlst[0].Routing_Number_ABA__c;
        am.Sales_Dept__c=Orderlst[0].Sales_Dept__c;
        am.Sales_Group__c=Orderlst[0].Sales_Group__c;
        am.Sales_Org__c=Orderlst[0].Sales_Org__c;
        am.Sales_Region__c=Orderlst[0].Sales_Region__c;
        am.SAP_Customer_PO_No__c=Orderlst[0].SAP_Customer_PO_No__c;
        am.SAP_Describe__c=Orderlst[0].SAP_Describe__c;
        am.SAP_External_ID__c=Orderlst[0].SAP_External_ID__c;
        am.SAP_Order_ID__c=Orderlst[0].SAP_Order_ID__c;
        am.SAP_Project_No__c=Orderlst[0].SAP_Project_No__c;
        am.SC_No__c=Orderlst[0].SC_No__c;
        am.Search__c=Orderlst[0].Search__c;
        am.SELLER__c=Orderlst[0].SELLER__c;
        am.SEQ__c=Orderlst[0].SEQ__c;
        am.ShipToContact__c=Orderlst[0].ShipToContactid;
        am.Shipping_type__c=Orderlst[0].Shipping_type__c;
        am.Special_Approvals__c=Orderlst[0].Special_Approvals__c;
        am.Special_Requirements__c=Orderlst[0].Special_Requirements__c;
        am.SPECIAL_TERMS__c=Orderlst[0].SPECIAL_TERMS__c;
        am.Special__c=Orderlst[0].Special__c;
        am.Stage__c=Orderlst[0].Stage__c;
        am.Status__c=Orderlst[0].Status;
        am.Street_Room_Number__c=Orderlst[0].Street_Room_Number__c;
        am.Subject_Group__c=Orderlst[0].Subject_Group__c;
        am.Supply_By__c=Orderlst[0].Supply_By__c;
        am.SWIFT_Code__c=Orderlst[0].SWIFT_Code__c;
        am.Tax__c=Orderlst[0].Tax__c;
        am.Tax_No__c=Orderlst[0].Tax_No__c;
        am.Tax_Rate__c=Orderlst[0].Tax_Rate__c;
        am.Taxpayer_Identification_No__c=Orderlst[0].Taxpayer_Identification_No__c;
        am.Title__c=Orderlst[0].Title__c;
        am.Trade_term__c=Orderlst[0].Trade_term__c;
        am.Transit_Fees__c=Orderlst[0].Transit_Fees__c;
        am.Update_Time_1st__c=Orderlst[0].Update_Time_1st__c;
        am.VAT_NO__c=Orderlst[0].VAT_NO__c;
        am.Warranty_Insurance__c=Orderlst[0].Warranty_Insurance__c;
        am.Warranty_On_Material_and_Workmanship__c=Orderlst[0].Warranty_On_Material_and_Workmanship__c;
        
        insert am;
        for(Amendment_Order_Product__c ao:aop){
            ao.CurrencyIsoCode=yuyan;
            ao.OriginalOrderItem__c=am.id;
             
        }
        upsert aop;
        for(Amendment_Payment__c oi:aps){
            oi.Amendment_Purchase_Agreement__c=am.id;
        }
        
        upsert aps;   
        lm.lock__c=tf;
        update lm;
        return new ApexPages.StandardController(am).view();
    }
    
    public void DeletePay(){
        system.debug('id:'+deleteID);
        if(deleteID != null && deleteID != ''){
            aps.remove(Integer.valueOf(deleteID)-1);
        }
        for(Integer i = 1 ; i < aps.size()+1 ; i++ ){
            Amendment_Payment__c ao =aps[i-1];
            ao.Request_No__c=i;
        }
    }
    public void DeleteiTEM(){
        system.debug('deleteID:'+deleteID);
        system.debug('Oslst:'+Oslst);
        if(deleteID != null && deleteID != ''){
            aop.remove(Integer.valueOf(deleteID)-1);
        }
        for(Integer i = 1 ; i < aop.size()+1 ; i++ ){
            Amendment_Order_Product__c ao =aop[i-1];
            ao.Request_No__c=i;
        }
        system.debug('Oslst2:'+Oslst);
    }
}