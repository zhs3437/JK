public class RC_AddAmendmentOrderCtrl {
    public Agreement__c mp{get;set;}
    public String requestId{get;set;}
    public Agreement__c lm {get;set;}
    public decimal  LogisticsCost {get;set;}
    public String deleteID {get;set;}
    public List<Agreement__c> Orderlst {get;set;}
    public List<Payment__c> Plst {get;set;}
    public List<Agreement_Component__c> Oslst {get;set;}
    public String yuyan {get;set;}
    public List<Amendment_Agreement_Product__c> aop {get;set;}
    public List<Payment__c> aps {get;set;}
    public RC_AddAmendmentOrderCtrl(ApexPages.StandardController sd){
        system.debug('deleteID:'+deleteID);
        requestId = ApexPages.currentPage().getParameters().get('id');
        lm = [select id,lock__c from Agreement__c where id =: requestId];
        
        system.debug(requestId);
        if(requestId != null){
            this.mp = (Agreement__c)UtilClass.GetObjByID(Schema.SObjectType.Agreement__c,requestId);
        }
        LoadDataList();
    }
    public void LoadDataList(){
        
        Orderlst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Agreement__c) + ' ' +
                                  'Where id =: requestId');
        Oslst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Agreement_Component__c) + ' ' +
                             'Where Agreement__c =: requestId');
        Plst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c) + ' ' +
                            'Where China_Order__c =: requestId');
        system.debug('Orderlst===:'+Orderlst);
        system.debug('Oslst===:'+Oslst);
        system.debug('Plst===:'+Plst);
        system.debug('mp===:'+mp);
        aop=new List<Amendment_Agreement_Product__c>();
        yuyan=Orderlst[0].CurrencyIsoCode; 
        aps=new List<Payment__c>();
        system.debug('货币:'+yuyan);
        
        for(Integer i = 1 ; i < Plst.size()+1 ; i++ ){
            system.debug('Requested_Number__c:'+i);
            
            
            Payment__c oi=Plst[i-1];
            system.debug('oi.Percentage__c:'+oi.Percentage__c);
            Payment__c ap =new Payment__c();
            ap.Id=oi.Id;
            ap.Requested_Number__c=i;
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
                  ap.Payment_Term__c = null;
              }else{
            ap.Payment_Term__c = oi.Payment_Term__c;
              }
            ap.Percentage__c = oi.Percentage__c;
            system.debug('ap.Percentage__c:'+ap.Percentage__c);
            ap.Precise_Day__c = oi.Precise_Day__c;
            aps.add(ap);         
        }

        for(Integer i  =  1 ; i < Oslst.size()+1 ; i++ ){
            system.debug('Requested_Number__c:'+i);
            Agreement_Component__c oi = Oslst[i-1];
            Amendment_Agreement_Product__c ao  = new Amendment_Agreement_Product__c();
            system.debug('Request_No__c2:'+i);
            ao.Requested_Number__c = i;
            system.debug('Request_No__c3:'+ao.Requested_Number__c);
            ao.CurrencyIsoCode = yuyan;
            ao.Battery_Type__c = oi.Battery_Type__c;
            ao.Name = oi.Name;
            ao.Bus_Bars_Of_Cell__c = oi.Bus_Bars_Of_Cell__c;
            ao.Certification__c = oi.Certification__c;
            ao.Frame_Material__c = oi.Frame_Material__c;
            ao.Connector__c = oi.Connector__c;
            ao.Expected_Delivery_Date__c = oi.Expected_Delivery_Date__c;
            ao.Grade__c = oi.Grade__c;
            ao.Guaranteed_Delivery_Date__c = oi.Guaranteed_Delivery_Date__c;
            ao.Length_of_Junction_Box_wiring__c = oi.Length_of_Junction_Box_wiring__c;
            ao.MP__c = oi.MP__c;
            ao.Agreement__c = oi.Agreement__c;
            // if (oi.Product__r.active == false){
            //         List<product2> p3=  [select id from product2 where name=:oi.Product_Name__c and isactive=true];
            //         if(p3.size()>0){
            //             ao.Product2__c=p3[0].id;
            //         }
            // } else {
            //     ao.Product2__c=oi.product2id;
            // }
            ao.Product__c = oi.Product__c;
            ao.Quantity__c = oi.Quantity__c;
            ao.Special_Required__c = oi.Special_Required__c;
            ao.Total_Power_W__c = oi.Total_Power_W__c;
            ao.total_Price__c = oi.Total_Price__c;
            ao.Sales_Price__c = oi.Sales_Price__c;
            ao.Type_Of_Module__c = oi.Type_Of_Module__c;
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
        aop.add(new Amendment_Agreement_Product__c(CurrencyIsoCode=yuyan,Agreement__c=requestId,Requested_Number__c=num+1));
    }
    public void addPayment(){
        integer num=aps.size();
        aps.add(new Payment__c(Requested_Number__c=num+1));
    }
    public PageReference SelectDailyDetail(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Amendment_Agreement__c;
        Map<String, Schema.RecordTypeInfo> amendmentRecordTypeInfo = cfrSchema.getRecordTypeInfosByDeveloperName();
        String amendmentRecordId = amendmentRecordTypeInfo.get('Amendment_Agreement_China').getRecordTypeId();
        String flag='0';
        boolean tf=lm.lock__c;
        lm.lock__c=false;
        update lm;
        List<Amendment_Agreement__c> aList =[select id from Amendment_Agreement__c where Agreement__c=:requestId];
        if(aList.size()==0){
            flag='1';
        }
        system.debug('aop:'+aop);
        
        Amendment_Agreement__c am = new Amendment_Agreement__c();
        am.Summary_Comments__c = Orderlst[0].Summary_Comments__c;
        // am.name = Orderlst[0].Contract_NO__c+'   V'+(aList.size()+1);
        am.Name = Orderlst[0].Name;
        am.Agreement__c = requestId;
        am.CurrencyIsoCode = Orderlst[0].CurrencyIsoCode;
		am.Destination_Country__c =  Orderlst[0].Destination_Country__c;
		am.Project__c =  Orderlst[0].Project__c;
		am.Destination_Region__c =  Orderlst[0].Destination_Region__c;
		am.Contract_NO__c =  Orderlst[0].Contract_NO__c;
		am.Destination_Port__c =  Orderlst[0].Destination_Port__c;
		am.Trade_Term__c =  Orderlst[0].Trade_Term__c;
		am.Seller__c =  Orderlst[0].Seller__c;
		am.Warranty_Insurance__c =  Orderlst[0].Warranty_Insurance__c;
		am.Installation_Type__c =  Orderlst[0].Installation_Type__c;
		am.Warranty_On_Material_and_Workmanship__c =  Orderlst[0].Warranty_On_Material_And_Workmanship__c;
		am.Reason_of_apply_for_insurance__c =  Orderlst[0].Reason_Of_Apply_For_Insurance__c;
		am.Lock__c =  Orderlst[0].Lock__c;
		am.Approval_Status__c =  Orderlst[0].Approval_Status__c;
		am.Status__c =  Orderlst[0].Status__c;
		am.Refresh_Data_Times__c =  Orderlst[0].Refresh_Data_Times__c;
		am.Inventory_Type__c =  Orderlst[0].Inventory_Type__c;
		am.Discount__c =  Orderlst[0].Discount__c;
		am.Discount_Type__c =  Orderlst[0].Discount_Type__c;
		am.Special__c =  Orderlst[0].Special__c;
		am.Special_Approvals__c =  Orderlst[0].Special_Approvals__c;
		am.Intercompany_Seller_POs__c	 =  Orderlst[0].Intercompany_Seller_POs__c	;
		am.Bank_Info__c =  Orderlst[0].Bank_Info__c;
		am.Other__c =  Orderlst[0].Other__c;
		am.Tax_Rate__c =  Orderlst[0].Tax_Rate__c;
		am.Commission__c =  Orderlst[0].Commission__c;
		am.Commission_Type__c =  Orderlst[0].Commission_Type__c;
		am.Rebate__c =  Orderlst[0].Rebate__c;
		am.Rebate_Type__c	 =  Orderlst[0].Rebate_Type__c	;
		am.Summary_Comments__c =  Orderlst[0].Summary_Comments__c;
		am.Normal__c =  Orderlst[0].Normal__c;
		am.Special_Requirements__c =  Orderlst[0].Special_Requirements__c;
		am.Requested_supplier__c =  Orderlst[0].Requested_Supplier__c;
		am.PMC_confirm__c =  Orderlst[0].PMC_Confirm__c;
		am.Transit_Fees__c =  Orderlst[0].Transit_Fees__c;
		am.Bank_Information_Content__c =  Orderlst[0].Bank_Information_Content__c;
		am.Payment_Term_Description__c =  Orderlst[0].Payment_Term_Description__c;
		am.Warehouse_or_Factory__c =  Orderlst[0].Warehouse_Or_Factory__c;
		am.Land_Freight_China__c =  Orderlst[0].Land_Freight_China__c;
		am.Ocean_Freight_China__c =  Orderlst[0].Ocean_Freight_China__c;
		am.Ocean_Freight_Oversea__c =  Orderlst[0].Ocean_Freight_Oversea__c;
		am.Land_Freight_Oversea__c =  Orderlst[0].Land_Freight_Oversea__c;
		am.Local_Warehouse__c =  Orderlst[0].Local_Warehouse__c;
		am.Warehouse_Premium__c =  Orderlst[0].Warehouse_Premium__c;
		am.Logistic_Special_Cost_Per_W__c =  Orderlst[0].Logistic_Special_Cost_Per_W__c;
		am.Number_of_Containers__c =  Orderlst[0].Number_of_Containers__c;
		am.Sync_To_SAP__c =  Orderlst[0].Sync_To_SAP__c;
        am.Actual_Sales_Name__c = Orderlst[0].Actual_Sales_Name__c;
        am.Contract_No__c = Orderlst[0].Contract_No__c;
        am.Contract_Owner__c = Orderlst[0].Contract_Owner__c;
        am.Factory_WH__c = Orderlst[0].Factory_WH__c;
        am.RecordTypeId = amendmentRecordId;
        am.Amendment_Agreement_Types__c = Orderlst[0].Amendment_Agreement_Types__c;
        
        insert am;
        for(Amendment_Agreement_Product__c ao:aop){
            ao.CurrencyIsoCode=yuyan;
            ao.Amendment_Agreement__c=am.id;
             
        }
        upsert aop;
        for(Payment__c oi:aps){
            oi.Amendment_Agreement__c=am.id;
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
            Payment__c ao =aps[i-1];
            ao.Requested_Number__c=i;
        }
    }
    public void DeleteiTEM(){
        system.debug('deleteID:'+deleteID);
        system.debug('Oslst:'+Oslst);
        if(deleteID != null && deleteID != ''){
            aop.remove(Integer.valueOf(deleteID)-1);
        }
        for(Integer i = 1 ; i < aop.size()+1 ; i++ ){
            Amendment_Agreement_Product__c ao =aop[i-1];
            ao.Requested_Number__c=i;
        }
        system.debug('Oslst2:'+Oslst);
    }
}