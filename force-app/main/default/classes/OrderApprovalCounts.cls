global class  OrderApprovalCounts {
    
    webservice static String ClickPriceApproval(String Aorderid){
        system.debug('开始配对');
        Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: Aorderid');
        if(Aord.Header_Change__c==true || Aord.Product_Change__c==true ||  Aord.Delivery_Date_Change__c==true || Aord.Payment_Change__c==true){
            return OrderApprovalCounts.Changetoemail(Aorderid);
        }else{
            
            return OrderApprovalCounts.Addaction(Aorderid);
        }
    }
    webservice static String LockAorder(String Aorderid){
        Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: Aorderid');
        if(Aord.Lock__c!=true){
            Aord.Lock__c=true;
            Aord.Lock_Time__c=datetime.now();
            update Aord;
            return '成功';
        }
        
        return '已Lock';
    }
    public class Approver  {
        public Approver(string uEmail,string uName,string roleName,String uid){
            this.uEmail=uEmail;
            this.uName=uName;
            this.roleName=roleName;
            this.isSelect=true;
            this.uId = uId;
        }
        public boolean isSelect {get;set;}
        public String uEmail {get;set;}         
        public String uName {get;set;}
        public String roleName {get;set;}
        public String uId{get;set;}
    }
    public SET<Approver> approverList {get;set;}
    public static String Addaction(String Aorderid){
        List<Order_Differences__c> odp=[select id from Order_Differences__c where Amendment_Purchase_Agreement__c =: Aorderid];
        if(odp.size()>0){                 
            delete odp;                         
                        }
        
        Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: Aorderid');
        
        List<RecordType> rt=[select id from RecordType where name=:'AgreementFile'];
        if(rt.size()>0){
            Aord.RecordTypeid=rt[0].id;
            Aord.Submission_Time__c=datetime.now();
            Aord.Header_Change__c=false;
            update Aord;
        }
        system.debug('Aord:'+Aord);
        Id id1=Aord.Order__c;
        Order ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                  'Where id =: id1');
        system.debug('ord:'+ord);
        Id id2=Aord.id;
         if(Aord.Trade_term__c != ord.Trade_term__c ){
              try{
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:'AmendmentAddFreight'];
                 System.debug('Start Send Email-->');
                List<String> emailList = new List<String>();
                String email =Label.Logistics;
                User user =[Select Id,Email,Isactive from User where Email =:email limit 1];
                emailList.add(email);
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                mail.setTargetObjectId(user.ID);
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }                
                mail.setWhatId(Aord.Id);
                mail.setSenderDisplayName(UserInfo.getName());
                mailList.add(mail);
            
            Messaging.sendEmail(mailList);
  
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
        }
        List<Amendment__c> AordLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                  'Where Order__c =:id1 order by CreatedDate DESC');
        system.debug('AordLst数量为:'+AordLst.size());
        system.debug('判断数量');
        if(AordLst.size()==1){
            system.debug('数量为1');
            Aord.ApprovalNumbers__c=1;
            List<Amendment_Payment__c> APayLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                              'Where Amendment_Purchase_Agreement__c =:id2');
            system.debug('APayLst数量为:'+APayLst.size());
            List<Amendment_Order_Product__c> AOPLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                                   'Where OriginalOrderItem__c =:id2');
            system.debug('AOPLst数量为:'+AOPLst.size());
            List<OrderItem> orderlineLst = [Select id,Total_MW__c,TotalPrice,Quantity,UnitPrice,Total_Price__c,Product2Id,Product2.name,SAP_Product_Materiel_No__c,Type_of_module__c,Guaranteed_Delivery_Date__c from OrderItem where OrderId =:ord.id];
            system.debug('orderlineLst数量为:'+orderlineLst.size());
            List<Payment__c> payLst = [select id,Amount__c,Percentage__c,Down_Balance_Payment__c,PaymentDescription__c,payment_Method__c,Days__c,Payment_Term__c,Opportunity__c from Payment__c where Order__c =:ord.id ];
            system.debug('payLst数量为:'+payLst.size());
            
            Order_Differences__c  OrdDiff = new Order_Differences__c();
            OrdDiff.Amendment_Purchase_Agreement__c = Aorderid;
            OrdDiff.Destination_Country_New__c = Aord.Destination_Country__c;
            OrdDiff.SELLER_New__c =Aord.SELLER__c;
            OrdDiff.Total_MW_New__c = Aord.Total_MW2__c;
            OrdDiff.Total_Price_New__c = Aord.Total_Price__c ;
            OrdDiff.Total_Quantity_New__c =  Aord.Total_Quantity__c;
            OrdDiff.Trade_term_New__c = Aord.Trade_term__c ;
            OrdDiff.Commission_New__c = Aord.Commission__c ;
            OrdDiff.zongjia_New__c = Aord.Totalprice__c ;
            OrdDiff.Account_Allocation_Group_New__c = Aord.Account_Allocation_Group__c ;
            OrdDiff.Account_Country_New__c = Aord.Account_Country__c ;
            OrdDiff.Account_Group_New__c = Aord.Account_Group__c ;
            OrdDiff.Account_Id_New__c = Aord.Account_Id__c ;
            OrdDiff.Account_Holder_New__c = Aord.Account_Holder__c ;
            OrdDiff.Account_Name_New__c = Aord.Account__c ;
            OrdDiff.Account_Phone_New__c = Aord.Account_Phone__c ;
            OrdDiff.Account_Title_New__c = Aord.Account_Title__c ;
            OrdDiff.Activated_By_New__c = Aord.ActivatedBy__c ;
            OrdDiff.Activated_Date_New__c = Aord.ActivatedDate__c ;
            OrdDiff.Actual_Sales_Name_New__c = Aord.Actual_Sales_Name__c ;
            OrdDiff.Applicant_Direct_Superior_New__c = Aord.Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers_New__c = Aord.ApprovalNumbers__c ;
            OrdDiff.Authorized_Representative_New__c = Aord.Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_New__c = Aord.Avg_Price_W__c ;
            OrdDiff.Bank_Account_New__c = Aord.Bank_Account__c ;
            OrdDiff.Bank_City_New__c = Aord.Bank_City__c ;
            OrdDiff.Bank_Code_New__c = Aord.Bank_Code__c ;
            OrdDiff.Bank_Country_New__c = Aord.Bank_Country__c ;
            OrdDiff.Bank_Information_Content_New__c = Aord.Bank_Information_Content__c ;
            OrdDiff.Bank_Name_New__c = Aord.Bank_Name__c ;
            OrdDiff.Bank_Region_New__c = Aord.Bank_Region__c ;
            OrdDiff.Bank_Street_New__c = Aord.Bank_Street__c ;
            OrdDiff.BillingCity_New__c = Aord.BillingCity__c ;
            OrdDiff.BillingCountry_New__c = Aord.BillingCountry__c ;
            OrdDiff.BillingPostalCode_New__c = Aord.BillingPostalCode__c ;
            OrdDiff.BillingState_New__c = Aord.BillingState__c ;
            OrdDiff.BillingStreet_New__c = Aord.BillingStreet__c ;
            OrdDiff.BMO_SH_New__c = Aord.BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_New__c = Aord.Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_New__c = Aord.BMO_SR__c ;
            OrdDiff.BSB_Number_New__c = Aord.BSB_Number__c ;
            OrdDiff.Buyer_New__c = Aord.Buyer__c ;
            OrdDiff.BuyerSAPId_New__c = Aord.BuyerSAPId__c ;
            OrdDiff.CC_No_New__c = Aord.CC_No__c ;
            OrdDiff.Commission_Type_New__c = Aord.Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_New__c = Aord.Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_New__c = Aord.CompanyAuthorizedBy__c ;
            OrdDiff.Company_Authorized_Date_New__c = Aord.CompanyAuthorizedDate__c ;
            OrdDiff.Company_Registration_No_New__c = Aord.Company_Registration_No__c ;
            OrdDiff.Contact_Name_New__c = Aord.Contact_Name__c ;
            
            OrdDiff.Contract_Type_New__c = Aord.Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_New__c = Aord.Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_New__c = Aord.Contract_Owner__c ;
            OrdDiff.Country_Scope_New__c = Aord.Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_New__c = Aord.CustomerAuthorizedBy__c ;
            OrdDiff.Customer_Authorized_Date_New__c = Aord.CustomerAuthorizedDate__c ;
            OrdDiff.Customer_Business_Scale_New__c = Aord.Customer_Business_Scale__c ;
            OrdDiff.Customer_country_New__c = Aord.Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_New__c = Aord.delivery_note_CI__c ;
            OrdDiff.Description_New__c = Aord.Description__c ;
            OrdDiff.Destination_Country_New__c = Aord.Destination_Country__c ;
            OrdDiff.Destination_New__c = Aord.Destination__c ;
            OrdDiff.Destination_Port_New__c = Aord.Destination_Port__c ;
            OrdDiff.Email_New__c = Aord.Email__c ;
            OrdDiff.Distribution_channel_New__c = Aord.Distribution_channel__c ;
            OrdDiff.Emergency_level_New__c = Aord.Emergency_level__c ;
            OrdDiff.Factory_WH_New__c = Aord.Factory__c ;
            OrdDiff.Fax_New__c = Aord.Fax__c ;
            OrdDiff.GST_Classification_Region_New__c = Aord.GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_New__c = Aord.IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_New__c = Aord.Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_New__c = Aord.ISTBD__c ;
            OrdDiff.Ledger_Name_New__c = Aord.Ledger_Name__c ;
            OrdDiff.Lock_New__c = Aord.Lock__c ;
            OrdDiff.MaterielNo_New__c = Aord.MaterielNo__c ;
            OrdDiff.MaxRowNo_New__c = Aord.MaxRowNo__c ;
            OrdDiff.Normal_New__c = Aord.Normal__c ;
            OrdDiff.OA_Emergency_level_New__c = Aord.OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_New__c = Aord.OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_New__c = Aord.OA_Operate_Type__c ;
            OrdDiff.Operate_Type_New__c = Aord.Operate_Type__c ;
            OrdDiff.Opportunity_New__c = Aord.Opportunity__c ;
            OrdDiff.Order_Amount_New__c = Aord.TotalAmount__c ;
            OrdDiff.Order_Currency_New__c = Aord.CurrencyIsoCode__c ;
            OrdDiff.Order_End_Date_New__c = Aord.EndDate__c ;
            OrdDiff.Order_Name_New__c = Aord.Name__c ;
            OrdDiff.Order_Reference_Number_New__c = Aord.OrderReferenceNumber__c ;
            OrdDiff.Order_Start_Date_New__c = Aord.EffectiveDate__c ;
            OrdDiff.Original_Order_New__c = Aord.OriginalOrder__c ;
            OrdDiff.Other_New__c = Aord.Other__c ;
            OrdDiff.Payment_Term_Description_New__c = Aord.Payment_Term_Description__c ;
            OrdDiff.Phone_New__c = Aord.Phone__c ;
            OrdDiff.PMC_confirm_New__c = Aord.PMC_confirm__c ;
            OrdDiff.PO_Date_New__c = Aord.PODate__c ;
            OrdDiff.PO_Number_New__c = Aord.PONumber__c ;
            OrdDiff.Previous_Amendment_Generation_Date_New__c = Aord.Previous_Amendment_Generation_Date__c ;
            OrdDiff.Product_Group_New__c = Aord.Product_Group__c ;
            OrdDiff.Progress_Remarks_New__c = Aord.Progress_Remarks__c ;
            OrdDiff.Quote_New__c = Aord.Quote__c ;
            OrdDiff.Reduction_Order_New__c = Aord.IsReductionOrder__c ;
            OrdDiff.Region_New__c = Aord.Region__c ;
            OrdDiff.Requested_supplier_New__c = Aord.Requested_supplier__c ;
            OrdDiff.Routing_Number_ABA_New__c = Aord.Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_New__c = Aord.Sales_Dept__c ;
            OrdDiff.Sales_Group_New__c = Aord.Sales_Group__c ;
            OrdDiff.Sales_Org_New__c = Aord.Sales_Org__c ;
            OrdDiff.Sales_Region_New__c = Aord.Sales_Region__c ;
            OrdDiff.SAP_Company_Code_New__c = Aord.SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_New__c = Aord.SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_New__c = Aord.SAP_Describe__c ;
            OrdDiff.SAP_External_ID_New__c = Aord.SAP_External_ID__c ;
            OrdDiff.SAP_Factory_New__c = Aord.SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_New__c = Aord.SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_New__c = Aord.SAP_Project_No__c ;
            OrdDiff.SAP_Region_New__c = Aord.SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_New__c = Aord.SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_New__c = Aord.SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_New__c = Aord.SAP_User_ID__c ;
            OrdDiff.SC_New__c = Aord.SC_No__c ;
            OrdDiff.Search_New__c = Aord.Search__c ;
            OrdDiff.Seller_Address_New__c = Aord.Seller_Address__c ;
            OrdDiff.SELLER_New__c = Aord.SELLER__c ;
            OrdDiff.Seller_Name_New__c = Aord.Seller_Name__c ;
            OrdDiff.SEQ_New__c = Aord.SEQ__c ;
            OrdDiff.Ship_To_Contact_New__c = Aord.ShipToContact__c ;
            OrdDiff.Shipping_type_New__c = Aord.Shipping_type__c ;
            OrdDiff.Special_Approvals_New__c = Aord.Special_Approvals__c ;
            OrdDiff.Special_Requirements_New__c = Aord.Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_New__c	 = Aord.SPECIAL_TERMS__c ;
            OrdDiff.Special_New__c = Aord.Special__c ;
            OrdDiff.Stage_New__c = Aord.Stage__c ;
            OrdDiff.Status_New__c = Aord.Status__c ;
            OrdDiff.Street_Room_Number_New__c = Aord.Street_Room_Number__c ;
            OrdDiff.Subject_Group_New__c = Aord.Subject_Group__c ;
            OrdDiff.Supply_By_New__c = Aord.Supply_By__c ;
            OrdDiff.SWIFT_Code_New__c = Aord.SWIFT_Code__c ;
            OrdDiff.Tax_New__c = Aord.Tax__c ;
            OrdDiff.Tax_No_New__c = Aord.Tax_No__c ;
            OrdDiff.Tax_Rate_New__c = Aord.Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_New__c = Aord.Taxpayer_Identification_No__c ;
            OrdDiff.Title_New__c = Aord.Title__c ;
            OrdDiff.Total_MW_New__c = Aord.Total_MW2__c ;
            OrdDiff.Total_Price_New__c = Aord.Total_Price__c ;
            OrdDiff.Total_Price_Tax_New__c = Aord.Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_New__c = Aord.Total_Quantity__c ;
            OrdDiff.Trade_term_New__c = Aord.Trade_term__c ;
            OrdDiff.Transit_Fees_New__c	 = Aord.Transit_Fees__c	 ;
            OrdDiff.Update_Time_1st_New__c = Aord.Update_Time_1st__c ;
            OrdDiff.VAT_NO_New__c = Aord.VAT_NO__c ;
            OrdDiff.Warranty_Insurance_New__c = Aord.Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_New__c = Aord.Warranty_On_Material_and_Workmanship__c ;
            OrdDiff.Discount_New__c = Aord.Discount__c ; 
            OrdDiff.Rebate_New__c = Aord.Rebate__c ;
            
            
            
            
            
            
            
            
            
            
            
            OrdDiff.Destination_Country_Old__c = ord.Destination_Country__c ;
            OrdDiff.Discount_old__c = ord.Discount__c ;
            OrdDiff.Rebate_old__c = ord.Rebate__c ;
            OrdDiff.SELLER_Old__c = ord.SELLER__c;
            OrdDiff.ApprovalNumbers__c  = Aord.ApprovalNumbers__c;
            OrdDiff.Total_MW_Old__c  = ord.Total_MW__c;
            OrdDiff.Total_Price_Old__c = ord.Total_Price__c;
            OrdDiff.Total_Quantity_Old__c = ord.Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = ord.Trade_term__c;
            OrdDiff.Commission_Old__c = ord.Commission__c;
            OrdDiff.Destination_Country_Old__c = ord.Destination_Country__c;
            OrdDiff.SELLER_Old__c =ord.SELLER__c;
            OrdDiff.Total_MW_Old__c = ord.Total_MW__c;
            OrdDiff.Total_Price_Old__c = ord.Total_Price__c ;
            OrdDiff.Total_Quantity_Old__c =  ord.Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = ord.Trade_term__c ;
            OrdDiff.Commission_Old__c = ord.Commission__c ;
            OrdDiff.zongjia_Old__c = ord.Total_Price__c ;
            OrdDiff.Account_Allocation_Group_Old__c = ord.Account_Allocation_Group__c ;
            OrdDiff.Account_Country_Old__c = ord.Account_Country__c ;
            OrdDiff.Account_Group_Old__c = ord.Account_Group__c ;
            OrdDiff.Account_Id_Old__c = ord.Account_Id__c ;
            OrdDiff.Account_Holder_Old__c = ord.Account_Holder__c ;
            OrdDiff.Account_Name_Old__c = ord.AccountId ;
            OrdDiff.Account_Phone_Old__c = ord.Account_Phone__c ;
            OrdDiff.Account_Title_Old__c = ord.Account_Title__c ;
            OrdDiff.Activated_By_Old__c = ord.ActivatedById ;
            OrdDiff.Activated_Date_Old__c = ord.ActivatedDate ;
            OrdDiff.Actual_Sales_Name_Old__c = ord.Actual_Sales_Name__c ;
            
            OrdDiff.Applicant_Direct_Superior_Old__c = ord.Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers_Old__c = ord.ApprovalNumbers__c ;
            OrdDiff.Authorized_Representative_Old__c = ord.Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_Old__c = ord.Avg_Price_W__c ;
            OrdDiff.Bank_Account_Old__c = ord.Bank_Account__c ;
            OrdDiff.Bank_City_Old__c = ord.Bank_City__c ;
            OrdDiff.Bank_Code_Old__c = ord.Bank_Code__c ;
            OrdDiff.Bank_Country_Old__c = ord.Bank_Country__c ;
            OrdDiff.Bank_Information_Content_Old__c = ord.Bank_Information_Content__c ;
            OrdDiff.Bank_Name_Old__c = ord.Bank_Name__c ;
            OrdDiff.Bank_Region_Old__c = ord.Bank_Region__c ;
            OrdDiff.Bank_Street_Old__c = ord.Bank_Street__c ;
            OrdDiff.BillingCity_Old__c = ord.BillingCity ;
            OrdDiff.BillingCountry_Old__c = ord.BillingCountry ;
            OrdDiff.BillingPostalCode_Old__c = ord.BillingPostalCode ;
            OrdDiff.BillingState_Old__c = ord.BillingState ;
            OrdDiff.BillingStreet_Old__c = ord.BillingStreet ;
            OrdDiff.BMO_SH_Old__c = ord.BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_Old__c = ord.Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_Old__c = ord.BMO_SR__c ;
            OrdDiff.BSB_Number_Old__c = ord.BSB_Number__c ;
            OrdDiff.Buyer_Old__c = ord.Buyer__c ;
            OrdDiff.BuyerSAPId_Old__c = ord.BuyerSAPId__c ;
            OrdDiff.CC_No_Old__c = ord.CC_No__c ;
            OrdDiff.Commission_Type_Old__c = ord.Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_Old__c = ord.Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_Old__c = ord.CompanyAuthorizedByid ;
            OrdDiff.Company_Authorized_Date_Old__c = ord.CompanyAuthorizedDate ;
            OrdDiff.Company_Registration_No_Old__c = ord.Company_Registration_No__c ;
            OrdDiff.Contact_Name_Old__c = ord.Contact_Name__c ;
            
            OrdDiff.Contract_Type_Old__c = ord.Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_Old__c = ord.Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_Old__c = ord.Contract_Owner__c ;
            OrdDiff.Country_Scope_Old__c = ord.Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_Old__c = ord.CustomerAuthorizedByid ;
            OrdDiff.Customer_Authorized_Date_Old__c = ord.CustomerAuthorizedDate ;
            OrdDiff.Customer_Business_Scale_Old__c = ord.Customer_Business_Scale__c ;
            OrdDiff.Customer_country_Old__c = ord.Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_Old__c = ord.delivery_note_CI__c ;
            OrdDiff.Description_Old__c = ord.Description ;
            OrdDiff.Destination_Country_Old__c = ord.Destination_Country__c ;
            OrdDiff.Destination_Old__c = ord.Destination__c ;
            OrdDiff.Destination_Port_Old__c = ord.Destination_Port__c ;
            OrdDiff.Email_Old__c = ord.Email__c ;
            OrdDiff.Distribution_channel_Old__c = ord.Distribution_channel__c ;
            OrdDiff.Emergency_level_Old__c = ord.Emergency_level__c ;
            OrdDiff.Factory_WH_Old__c = ord.Factory__c ;
            OrdDiff.Fax_Old__c = ord.Fax__c ;
            OrdDiff.GST_Classification_Region_Old__c = ord.GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_Old__c = ord.IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_Old__c = ord.Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_Old__c = ord.ISTBD__c ;
            OrdDiff.Ledger_Name_Old__c = ord.Ledger_Name__c ;
            OrdDiff.Lock_Old__c = ord.Lock__c ;
            OrdDiff.MaterielNo_Old__c = ord.MaterielNo__c ;
            OrdDiff.MaxRowNo_Old__c = ord.MaxRowNo__c ;
            OrdDiff.Normal_Old__c = ord.Normal__c ;
            OrdDiff.OA_Emergency_level_Old__c = ord.OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_Old__c = ord.OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_Old__c = ord.OA_Operate_Type__c ;
            OrdDiff.Operate_Type_Old__c = ord.Operate_Type__c ;
            OrdDiff.Opportunity_Old__c = ord.Opportunity__c ;
            OrdDiff.Order_Amount_Old__c = ord.TotalAmount ;
            OrdDiff.Order_Currency_Old__c = ord.CurrencyIsoCode ;
            OrdDiff.Order_End_Date_Old__c = ord.EndDate ;
            OrdDiff.Order_Name_Old__c = ord.Name ;
            OrdDiff.Order_Reference_Number_Old__c = ord.OrderReferenceNumber ;
            OrdDiff.Order_Start_Date_Old__c = ord.EffectiveDate ;
            OrdDiff.Original_Order_Old__c = ord.OriginalOrderid ;
            OrdDiff.Other_Old__c = ord.Other__c ;
            OrdDiff.Payment_Term_Description_Old__c = ord.Payment_Term_Description__c ;
            OrdDiff.Phone_Old__c = ord.Phone__c ;
            OrdDiff.PMC_confirm_Old__c = ord.PMC_confirm__c ;
            OrdDiff.PO_Date_Old__c = ord.PODate ;
            OrdDiff.PO_Number_Old__c = ord.PONumber ;
            OrdDiff.Previous_Amendment_Generation_Date_Old__c = ord.Previous_Amendment_Generation_Date__c ;
            OrdDiff.Product_Group_Old__c = ord.Product_Group__c ;
            OrdDiff.Progress_Remarks_Old__c = ord.Progress_Remarks__c ;
            OrdDiff.Quote_Old__c = ord.Quoteid ;
            OrdDiff.Reduction_Order_Old__c = ord.IsReductionOrder ;
            OrdDiff.Region_Old__c = ord.Region__c ;
            OrdDiff.Requested_supplier_Old__c = ord.Requested_supplier__c ;
            OrdDiff.Routing_Number_ABA_Old__c = ord.Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_Old__c = ord.Sales_Dept__c ;
            OrdDiff.Sales_Group_Old__c = ord.Sales_Group__c ;
            OrdDiff.Sales_Org_Old__c = ord.Sales_Org__c ;
            OrdDiff.Sales_Region_Old__c = ord.Sales_Region__c ;
            OrdDiff.SAP_Company_Code_Old__c = ord.SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_Old__c = ord.SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_Old__c = ord.SAP_Describe__c ;
            OrdDiff.SAP_External_ID_Old__c = ord.SAP_External_ID__c ;
            OrdDiff.SAP_Factory_Old__c = ord.SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_Old__c = ord.SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_Old__c = ord.SAP_Project_No__c ;
            OrdDiff.SAP_Region_Old__c = ord.SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_Old__c = ord.SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_Old__c = ord.SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_Old__c = ord.SAP_User_ID__c ;
            OrdDiff.SC_Old__c = ord.SC_No__c ;
            OrdDiff.Search_Old__c = ord.Search__c ;
            OrdDiff.SELLER_Old__c = ord.SELLER__c ;
            OrdDiff.SEQ_Old__c = ord.SEQ__c ;
            OrdDiff.Ship_To_Contact_Old__c = ord.ShipToContactid ;
            OrdDiff.Shipping_type_Old__c = ord.Shipping_type__c ;
            OrdDiff.Special_Approvals_Old__c = ord.Special_Approvals__c ;
            OrdDiff.Special_Requirements_Old__c = ord.Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_Old__c     = ord.SPECIAL_TERMS__c ;
            OrdDiff.Special_Old__c = ord.Special__c ;
            OrdDiff.Stage_Old__c = ord.Stage__c ;
            OrdDiff.Status_Old__c = ord.Status ;
            OrdDiff.Street_Room_Number_Old__c = ord.Street_Room_Number__c ;
            OrdDiff.Subject_Group_Old__c = ord.Subject_Group__c ;
            OrdDiff.Supply_By_Old__c = ord.Supply_By__c ;
            OrdDiff.SWIFT_Code_Old__c = ord.SWIFT_Code__c ;
            OrdDiff.Tax_Old__c = ord.Tax__c ;
            OrdDiff.Tax_No_Old__c = ord.Tax_No__c ;
            OrdDiff.Tax_Rate_Old__c = ord.Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_Old__c = ord.Taxpayer_Identification_No__c ;
            OrdDiff.Title_Old__c = ord.Title__c ;
            OrdDiff.Total_MW_Old__c = ord.Total_MW__c ;
            OrdDiff.Total_Price_Old__c = ord.Total_Price__c ;
            OrdDiff.Total_Price_Tax_Old__c = ord.Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_Old__c = ord.Total_Quantity__c ;
            OrdDiff.Trade_term_Old__c = ord.Trade_term__c ;
            OrdDiff.Transit_Fees_Old__c  = ord.Transit_Fees__c  ;
            OrdDiff.Update_Time_1st_Old__c = ord.Update_Time_1st__c ;
            OrdDiff.VAT_NO_Old__c = ord.VAT_NO__c ;
            OrdDiff.Warranty_Insurance_Old__c = ord.Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_Old__c = ord.Warranty_On_Material_and_Workmanship__c ;
            
            
            insert OrdDiff;
            system.debug('插入业务机会下的产品差异数据');
            
            Integer falg =0;
            List<OrderItem_Difference__c> OrderItemDiffLst = new  List<OrderItem_Difference__c>();
            for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                falg = 0;
                for(OrderItem OrderItemOld : orderlineLst){
                    system.debug('OrderItemOld.Id:'+OrderItemOld.Id);
                    system.debug('OrderItemNew.ID__c:'+OrderItemNew.ID__c);
                    if(String.valueOf(OrderItemOld.Id) == OrderItemNew.ID__c){
                        system.debug('产品配对');
                        OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                        OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                        OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                        OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_New__c =OrderItemNew.Product2__c;
                        OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                        OrderLinDiff.SAP_Product_Materiel_No_New__c =  OrderItemNew.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                        OrderLinDiff.total_Price_New__c =  OrderItemNew.total_Price__c;
                        OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                        OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c; 
                        OrderLinDiff.total_Price2_New__c =OrderItemNew.TotalPrice__c;
                        OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                        
                        OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product2.name;
                        OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_Old__c = OrderItemOld.Product2id;
                        OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity;
                        OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                        OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                        OrderLinDiff.total_Price2_Old__c = OrderItemOld.TotalPrice;
                        OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                        OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice;
                        OrderItemDiffLst.add(OrderLinDiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_New__c = OrderItemNew.Product2__c;
                    OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                    OrderLinDiff.SAP_Product_Materiel_No_New__c = OrderItemNew.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW__c;
                    OrderLinDiff.total_Price_New__c = OrderItemNew.total_Price__c;
                    OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                    OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c;
                    OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                    OrderLinDiff.total_Price2_New__c =OrderItemNew.TotalPrice__c;
                    OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                    OrderItemDiffLst.add(OrderLinDiff);
                }
            }
            for(OrderItem OrderItemOld : orderlineLst){
                falg = 0;
                for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                    if(String.valueOf(OrderItemOld.Id) == OrderItemNew.ID__c){
                        falg=1;    
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product2.name;
                    
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_Old__c = OrderItemOld.Product2id;
                    OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity;
                    OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                    OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                    OrderLinDiff.total_Price2_Old__c = OrderItemOld.TotalPrice;
                    OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                    OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice;
                    OrderItemDiffLst.add(OrderLinDiff);
                    
                }
            }
            if(OrderItemDiffLst.size()>0)insert OrderItemDiffLst;
            
            //插入业务机会下的付款方式数据
            List<PaymentDifference__c> paydiffLst = new  List<PaymentDifference__c>();
            
            for(Amendment_Payment__c payNew : APayLst){
                falg = 0;
                for(Payment__c payOld : payLst){
                    if(payNew.ID__c == payOld.Id){
                        system.debug('付款配对');
                        PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Order_Differences__c = OrdDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        paydiff.Days_New__c = payNew.Days__c;
                        paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                        paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                        paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                        paydiff.Percentage_New__c  = payNew.Percentage__c;
                        paydiff.Days_Old__c = payOld.Days__c;
                        paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                        paydiff.PaymentDescription_old__c=payOld.PaymentDescription__c;
                        paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
                        paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
                        paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
                        paydiff.Percentage_Old__c =payOld.Percentage__c;
                        paydiffLst.add(paydiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    system.debug('付款新建配对');
                    PaymentDifference__c paydiff =new PaymentDifference__c();
                    paydiff.Order_Differences__c = OrdDiff.Id;
                    paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    paydiff.Days_New__c = payNew.Days__c;
                    paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                    paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                    paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                    paydiff.Percentage_New__c = payNew.Percentage__c;
                    paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                    paydiffLst.add(paydiff);
                }
            }
            /*
for(Payment__c payOld : payLst){
falg = 0;
for(Amendment_Payment__c payNew : APayLst){
if(payNew.ID__c == payOld.Id){
falg=1;
}
}
if(falg ==0){
system.debug('付款被删除了');
PaymentDifference__c paydiff =new PaymentDifference__c();
paydiff.Order_Differences__c = OrdDiff.Id;
paydiff.Days_Old__c = payOld.Days__c;
paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
paydiff.Percentage_Old__c =payOld.Percentage__c;
paydiffLst.add(paydiff);
}
}
*/
            system.debug(paydiffLst.size());
            if(paydiffLst.size()>0)insert paydiffLst;
            
        }
        
        
        
        if(AordLst.size()>1){
            system.debug('数量为1');
            Aord.ApprovalNumbers__c=AordLst.size();
            List<Amendment_Payment__c> APayLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                              'Where Amendment_Purchase_Agreement__c =:id2');
            system.debug('APayLst数量为:'+APayLst.size());
            List<Amendment_Order_Product__c> AOPLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                                   'Where OriginalOrderItem__c =:id2 order by CreatedDate DESC  ');
            system.debug('AOPLst数量为:'+AOPLst.size());
            
            Order_Differences__c  OrdDiff = new Order_Differences__c();
            OrdDiff.Amendment_Purchase_Agreement__c = Aorderid;
            OrdDiff.Destination_Country_New__c = AordLst[0].Destination_Country__c;
            OrdDiff.SELLER_New__c =AordLst[0].SELLER__c;
            OrdDiff.Total_MW_New__c = AordLst[0].Total_MW2__c;
            OrdDiff.Total_Price_New__c = AordLst[0].Total_Price__c ;
            OrdDiff.Total_Quantity_New__c =  AordLst[0].Total_Quantity__c;
            OrdDiff.Trade_term_New__c = AordLst[0].Trade_term__c ;
            OrdDiff.Commission_New__c = AordLst[0].Commission__c ;
            OrdDiff.zongjia_New__c = AordLst[0].Totalprice__c ;
            OrdDiff.Account_Allocation_Group_New__c = AordLst[0].Account_Allocation_Group__c ;
            OrdDiff.Account_Country_New__c = AordLst[0].Account_Country__c ;
            OrdDiff.Account_Group_New__c = AordLst[0].Account_Group__c ;
            OrdDiff.Account_Id_New__c = AordLst[0].Account_Id__c ;
            OrdDiff.Account_Holder_New__c = AordLst[0].Account_Holder__c ;
            OrdDiff.Account_Name_New__c = AordLst[0].Account__c ;
            OrdDiff.Account_Number_New__c = AordLst[0].AccountNumber__c ;
            OrdDiff.Account_Phone_New__c = AordLst[0].Account_Phone__c ;
            OrdDiff.Account_Title_New__c = AordLst[0].Account_Title__c ;
            OrdDiff.Activated_By_New__c = AordLst[0].ActivatedBy__c ;
            OrdDiff.Activated_Date_New__c = AordLst[0].ActivatedDate__c ;
            OrdDiff.Actual_Sales_Name_New__c = AordLst[0].Actual_Sales_Name__c ;
            OrdDiff.Amendment_Point_New__c = AordLst[0].Amendment_Point__c ;
            OrdDiff.Amendment_Review_status_New__c  = AordLst[0].Amendment_Review_status__c ;
            OrdDiff.Amendment1_New__c = AordLst[0].Amendment1__c ;
            OrdDiff.Amendment2_New__c = AordLst[0].Amendment2__c ;
            OrdDiff.Amendment3_New__c = AordLst[0].Amendment3__c ;
            OrdDiff.Amendment4_New__c = AordLst[0].Amendment4__c ;
            OrdDiff.Amendment5_New__c = AordLst[0].Amendment5__c ;
            OrdDiff.Amendment6_New__c = AordLst[0].Amendment6__c ;
            OrdDiff.Amendment7_New__c = AordLst[0].Amendment7__c ;
            OrdDiff.Applicant_Direct_Superior_New__c = AordLst[0].Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers__c = Aord.ApprovalNumbers__c ;
            OrdDiff.ApprovalNumbers_New__c = AordLst[0].ApprovalNumbers__c ;
            OrdDiff.Approved_count_New__c = AordLst[0].Approved_count__c ;
            OrdDiff.Authorized_Representative_New__c = AordLst[0].Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_New__c = AordLst[0].Avg_Price_W__c ;
            OrdDiff.Bank_Account_New__c = AordLst[0].Bank_Account__c ;
            OrdDiff.Bank_City_New__c = AordLst[0].Bank_City__c ;
            OrdDiff.Bank_Code_New__c = AordLst[0].Bank_Code__c ;
            OrdDiff.Bank_Country_New__c = AordLst[0].Bank_Country__c ;
            OrdDiff.Bank_Information_Content_New__c = AordLst[0].Bank_Information_Content__c ;
            OrdDiff.Bank_Name_New__c = AordLst[0].Bank_Name__c ;
            OrdDiff.Bank_Region_New__c = AordLst[0].Bank_Region__c ;
            OrdDiff.Bank_Street_New__c = AordLst[0].Bank_Street__c ;
            OrdDiff.Billing_Address_New__c = AordLst[0].Billing_Address__c ;
            OrdDiff.BillingCity_New__c = AordLst[0].BillingCity__c ;
            OrdDiff.BillingCountry_New__c = AordLst[0].BillingCountry__c ;
            OrdDiff.BillingPostalCode_New__c = AordLst[0].BillingPostalCode__c ;
            OrdDiff.BillingState_New__c = AordLst[0].BillingState__c ;
            OrdDiff.BillingStreet_New__c = AordLst[0].BillingStreet__c ;
            OrdDiff.BMO_SH_New__c = AordLst[0].BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_New__c = AordLst[0].Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_New__c = AordLst[0].BMO_SR__c ;
            OrdDiff.BSB_Number_New__c = AordLst[0].BSB_Number__c ;
            OrdDiff.Buyer_New__c = AordLst[0].Buyer__c ;
            OrdDiff.Buyer_Name_New__c = AordLst[0].Buyer_Name__c ;
            OrdDiff.BuyerSAPId_New__c = AordLst[0].BuyerSAPId__c ;
            OrdDiff.CC_No_New__c = AordLst[0].CC_No__c ;
            OrdDiff.Commission_Type_New__c = AordLst[0].Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_New__c = AordLst[0].Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_New__c = AordLst[0].CompanyAuthorizedBy__c ;
            OrdDiff.Company_Authorized_Date_New__c = AordLst[0].CompanyAuthorizedDate__c ;
            OrdDiff.Company_Registration_No_New__c = AordLst[0].Company_Registration_No__c ;
            OrdDiff.Contact_Name_New__c = AordLst[0].Contact_Name__c ;
            OrdDiff.Contract_End_Date_New__c = AordLst[0].ContractEndDate__c ;
            OrdDiff.Contract_Name_New__c = AordLst[0].ContractName__c ;
            OrdDiff.Contract_Number_New__c = AordLst[0].Contract__c ;
            OrdDiff.Contract_Type_New__c = AordLst[0].Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_New__c = AordLst[0].Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_New__c = AordLst[0].Contract_Owner__c ;
            OrdDiff.Country_Scope_New__c = AordLst[0].Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_New__c = AordLst[0].CustomerAuthorizedBy__c ;
            OrdDiff.Customer_Authorized_Date_New__c = AordLst[0].CustomerAuthorizedDate__c ;
            OrdDiff.Customer_Business_Scale_New__c = AordLst[0].Customer_Business_Scale__c ;
            OrdDiff.Customer_country_New__c = AordLst[0].Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_New__c = AordLst[0].delivery_note_CI__c ;
            OrdDiff.Description_New__c = AordLst[0].Description__c ;
            OrdDiff.Destination_Country_New__c = AordLst[0].Destination_Country__c ;
            OrdDiff.Destination_New__c = AordLst[0].Destination__c ;
            OrdDiff.Destination_Port_New__c = AordLst[0].Destination_Port__c ;
            OrdDiff.Email_New__c = AordLst[0].Email__c ;
            OrdDiff.Distribution_channel_New__c = AordLst[0].Distribution_channel__c ;
            OrdDiff.Emergency_level_New__c = AordLst[0].Emergency_level__c ;
            OrdDiff.Factory_WH_New__c = AordLst[0].Factory__c ;
            OrdDiff.Fax_New__c = AordLst[0].Fax__c ;
            OrdDiff.GST_Classification_Region_New__c = AordLst[0].GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_New__c = AordLst[0].IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_New__c = AordLst[0].Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_New__c = AordLst[0].ISTBD__c ;
            OrdDiff.Ledger_Name_New__c = AordLst[0].Ledger_Name__c ;
            OrdDiff.Lock_New__c = AordLst[0].Lock__c ;
            OrdDiff.MaterielNo_New__c = AordLst[0].MaterielNo__c ;
            OrdDiff.MaxRowNo_New__c = AordLst[0].MaxRowNo__c ;
            OrdDiff.Normal_New__c = AordLst[0].Normal__c ;
            OrdDiff.OA_Emergency_level_New__c = AordLst[0].OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_New__c = AordLst[0].OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_New__c = AordLst[0].OA_Operate_Type__c ;
            OrdDiff.Operate_Type_New__c = AordLst[0].Operate_Type__c ;
            OrdDiff.Opportunity_New__c = AordLst[0].Opportunity__c ;
            OrdDiff.Order_Amount_New__c = AordLst[0].TotalAmount__c ;
            OrdDiff.Order_Currency_New__c = AordLst[0].CurrencyIsoCode__c ;
            OrdDiff.Order_End_Date_New__c = AordLst[0].EndDate__c ;
            OrdDiff.Order_Name_New__c = AordLst[0].Name__c ;
            OrdDiff.Order_Product_New__c = AordLst[0].Order_Product__c ;
            OrdDiff.Order_Reference_Number_New__c = AordLst[0].OrderReferenceNumber__c ;
            OrdDiff.Order_Start_Date_New__c = AordLst[0].EffectiveDate__c ;
            OrdDiff.Original_Order_New__c = AordLst[0].OriginalOrder__c ;
            OrdDiff.Other_New__c = AordLst[0].Other__c ;
            OrdDiff.Payment_Term_Description_New__c = AordLst[0].Payment_Term_Description__c ;
            OrdDiff.Phone_New__c = AordLst[0].Phone__c ;
            OrdDiff.PMC_confirm_New__c = AordLst[0].PMC_confirm__c ;
            OrdDiff.PO_Date_New__c = AordLst[0].PODate__c ;
            OrdDiff.PO_Number_New__c = AordLst[0].PONumber__c ;
            OrdDiff.Previous_Amendment_Generation_Date_New__c = AordLst[0].Previous_Amendment_Generation_Date__c ;
            OrdDiff.Print_Contract_Date_New__c = AordLst[0].Print_Contract_Date__c ;
            OrdDiff.Product_Group_New__c = AordLst[0].Product_Group__c ;
            OrdDiff.Progress_Remarks_New__c = AordLst[0].Progress_Remarks__c ;
            OrdDiff.Purchase_Type_New__c = AordLst[0].Purchase_Type__c ;
            OrdDiff.Quote_New__c = AordLst[0].Quote__c ;
            OrdDiff.Reduction_Order_New__c = AordLst[0].IsReductionOrder__c ;
            OrdDiff.Region_New__c = AordLst[0].Region__c ;
            OrdDiff.Requested_supplier_New__c = AordLst[0].Requested_supplier__c ;
            OrdDiff.Review_status_New__c = AordLst[0].Review_status__c ;
            OrdDiff.Routing_Number_ABA_New__c = AordLst[0].Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_New__c = AordLst[0].Sales_Dept__c ;
            OrdDiff.Sales_Group_New__c = AordLst[0].Sales_Group__c ;
            OrdDiff.Sales_Org_New__c = AordLst[0].Sales_Org__c ;
            OrdDiff.Sales_Region_New__c = AordLst[0].Sales_Region__c ;
            OrdDiff.SAP_Company_Code_New__c = AordLst[0].SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_New__c = AordLst[0].SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_New__c = AordLst[0].SAP_Describe__c ;
            OrdDiff.SAP_External_ID_New__c = AordLst[0].SAP_External_ID__c ;
            OrdDiff.SAP_Factory_New__c = AordLst[0].SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_New__c = AordLst[0].SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_New__c = AordLst[0].SAP_Project_No__c ;
            OrdDiff.SAP_Region_New__c = AordLst[0].SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_New__c = AordLst[0].SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_New__c = AordLst[0].SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_New__c = AordLst[0].SAP_User_ID__c ;
            OrdDiff.SC_New__c = AordLst[0].SC_No__c ;
            OrdDiff.Search_New__c = AordLst[0].Search__c ;
            OrdDiff.Seller_Address_New__c = AordLst[0].Seller_Address__c ;
            OrdDiff.SELLER_New__c = AordLst[0].SELLER__c ;
            OrdDiff.Seller_Name_New__c = AordLst[0].Seller_Name__c ;
            OrdDiff.SEQ_New__c = AordLst[0].SEQ__c ;
            OrdDiff.Ship_To_Contact_New__c = AordLst[0].ShipToContact__c ;
            OrdDiff.Shipping_type_New__c = AordLst[0].Shipping_type__c ;
            OrdDiff.Special_Approvals_New__c = AordLst[0].Special_Approvals__c ;
            OrdDiff.Special_Requirements_New__c = AordLst[0].Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_New__c     = AordLst[0].SPECIAL_TERMS__c ;
            OrdDiff.Special_New__c = AordLst[0].Special__c ;
            OrdDiff.Stage_New__c = AordLst[0].Stage__c ;
            OrdDiff.Status_New__c = AordLst[0].Status__c ;
            OrdDiff.Street_Room_Number_New__c = AordLst[0].Street_Room_Number__c ;
            OrdDiff.Subject_Group_New__c = AordLst[0].Subject_Group__c ;
            OrdDiff.Supply_By_New__c = AordLst[0].Supply_By__c ;
            OrdDiff.SWIFT_Code_New__c = AordLst[0].SWIFT_Code__c ;
            OrdDiff.Tax_New__c = AordLst[0].Tax__c ;
            OrdDiff.Tax_No_New__c = AordLst[0].Tax_No__c ;
            OrdDiff.Tax_Rate_New__c = AordLst[0].Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_New__c = AordLst[0].Taxpayer_Identification_No__c ;
            OrdDiff.Title_New__c = AordLst[0].Title__c ;
            OrdDiff.Total_MW_New__c = AordLst[0].Total_MW2__c ;
            OrdDiff.Total_Price_New__c = AordLst[0].Total_Price__c ;
            OrdDiff.Total_Price_Tax_New__c = AordLst[0].Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_New__c = AordLst[0].Total_Quantity__c ;
            OrdDiff.Trade_term_New__c = AordLst[0].Trade_term__c ;
            OrdDiff.Transit_Fees_New__c  = AordLst[0].Transit_Fees__c  ;
            OrdDiff.Update_Time_1st_New__c = AordLst[0].Update_Time_1st__c ;
            OrdDiff.VAT_NO_New__c = AordLst[0].VAT_NO__c ;
            OrdDiff.Warranty_Insurance_New__c = AordLst[0].Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_New__c = AordLst[0].Warranty_On_Material_and_Workmanship__c ;
            OrdDiff.Discount_New__c = AordLst[0].Discount__c ; 
            OrdDiff.Rebate_New__c = AordLst[0].Rebate__c ; 
            OrdDiff.Discount_old__c = AordLst[1].Discount__c ;
            OrdDiff.Rebate_old__c = AordLst[1].Rebate__c ;
            
            OrdDiff.Destination_Country_Old__c = AordLst[1].Destination_Country__c ;
            OrdDiff.SELLER_Old__c = AordLst[1].SELLER__c;
            
            OrdDiff.Total_Price_Old__c = AordLst[1].Total_Price__c;
            OrdDiff.Total_Quantity_Old__c = AordLst[1].Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = AordLst[1].Trade_term__c;
            OrdDiff.Commission_Old__c = AordLst[1].Commission__c;
            OrdDiff.Destination_Country_Old__c = AordLst[1].Destination_Country__c;
            OrdDiff.SELLER_Old__c =AordLst[1].SELLER__c;
            OrdDiff.Total_MW_Old__c = AordLst[1].Total_MW2__c;
            OrdDiff.Total_Price_Old__c = AordLst[1].Total_Price__c ;
            OrdDiff.Total_Quantity_Old__c =  AordLst[1].Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = AordLst[1].Trade_term__c ;
            OrdDiff.Commission_Old__c = AordLst[1].Commission__c ;
            OrdDiff.zongjia_Old__c = AordLst[1].Total_Price__c ;
            OrdDiff.Account_Allocation_Group_Old__c = AordLst[1].Account_Allocation_Group__c ;
            OrdDiff.Account_Country_Old__c = AordLst[1].Account_Country__c ;
            OrdDiff.Account_Group_Old__c = AordLst[1].Account_Group__c ;
            OrdDiff.Account_Id_Old__c = AordLst[1].Account_Id__c ;
            OrdDiff.Account_Holder_Old__c = AordLst[1].Account_Holder__c ;
            OrdDiff.Account_Name_Old__c = AordLst[1].Account__c ;
            OrdDiff.Account_Phone_Old__c = AordLst[1].Account_Phone__c ;
            OrdDiff.Account_Title_Old__c = AordLst[1].Account_Title__c ;
            OrdDiff.Activated_By_Old__c = AordLst[1].ActivatedBy__c ;
            OrdDiff.Activated_Date_Old__c = AordLst[1].ActivatedDate__c ;
            OrdDiff.Actual_Sales_Name_Old__c = AordLst[1].Actual_Sales_Name__c ;
            
            OrdDiff.Applicant_Direct_Superior_Old__c = AordLst[1].Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers_Old__c = AordLst[1].ApprovalNumbers__c ;
            OrdDiff.Authorized_Representative_Old__c = AordLst[1].Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_Old__c = AordLst[1].Avg_Price_W__c ;
            OrdDiff.Bank_Account_Old__c = AordLst[1].Bank_Account__c ;
            OrdDiff.Bank_City_Old__c = AordLst[1].Bank_City__c ;
            OrdDiff.Bank_Code_Old__c = AordLst[1].Bank_Code__c ;
            OrdDiff.Bank_Country_Old__c = AordLst[1].Bank_Country__c ;
            OrdDiff.Bank_Information_Content_Old__c = AordLst[1].Bank_Information_Content__c ;
            OrdDiff.Bank_Name_Old__c = AordLst[1].Bank_Name__c ;
            OrdDiff.Bank_Region_Old__c = AordLst[1].Bank_Region__c ;
            OrdDiff.Bank_Street_Old__c = AordLst[1].Bank_Street__c ;
            OrdDiff.BillingCity_Old__c = AordLst[1].BillingCity__c ;
            OrdDiff.BillingCountry_Old__c = AordLst[1].BillingCountry__c ;
            OrdDiff.BillingPostalCode_Old__c = AordLst[1].BillingPostalCode__c ;
            OrdDiff.BillingState_Old__c = AordLst[1].BillingState__c ;
            OrdDiff.BillingStreet_Old__c = AordLst[1].BillingStreet__c ;
            OrdDiff.BMO_SH_Old__c = AordLst[1].BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_Old__c = AordLst[1].Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_Old__c = AordLst[1].BMO_SR__c ;
            OrdDiff.BSB_Number_Old__c = AordLst[1].BSB_Number__c ;
            OrdDiff.Buyer_Old__c = AordLst[1].Buyer__c ;
            OrdDiff.BuyerSAPId_Old__c = AordLst[1].BuyerSAPId__c ;
            OrdDiff.CC_No_Old__c = AordLst[1].CC_No__c ;
            OrdDiff.Commission_Type_Old__c = AordLst[1].Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_Old__c = AordLst[1].Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_Old__c = AordLst[1].CompanyAuthorizedBy__c ;
            OrdDiff.Company_Authorized_Date_Old__c = AordLst[1].CompanyAuthorizedDate__c ;
            OrdDiff.Company_Registration_No_Old__c = AordLst[1].Company_Registration_No__c ;
            OrdDiff.Contact_Name_Old__c = AordLst[1].Contact_Name__c ;
            
            OrdDiff.Contract_Type_Old__c = AordLst[1].Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_Old__c = AordLst[1].Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_Old__c = AordLst[1].Contract_Owner__c ;
            OrdDiff.Country_Scope_Old__c = AordLst[1].Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_Old__c = AordLst[1].CustomerAuthorizedBy__C ;
            OrdDiff.Customer_Authorized_Date_Old__c = AordLst[1].CustomerAuthorizedDate__C ;
            OrdDiff.Customer_Business_Scale_Old__c = AordLst[1].Customer_Business_Scale__c ;
            OrdDiff.Customer_country_Old__c = AordLst[1].Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_Old__c = AordLst[1].delivery_note_CI__c ;
            OrdDiff.Description_Old__c = AordLst[1].Description__c ;
            OrdDiff.Destination_Country_Old__c = AordLst[1].Destination_Country__c ;
            OrdDiff.Destination_Old__c = AordLst[1].Destination__c ;
            OrdDiff.Destination_Port_Old__c = AordLst[1].Destination_Port__c ;
            OrdDiff.Email_Old__c = AordLst[1].Email__c ;
            OrdDiff.Distribution_channel_Old__c = AordLst[1].Distribution_channel__c ;
            OrdDiff.Emergency_level_Old__c = AordLst[1].Emergency_level__c ;
            OrdDiff.Factory_WH_Old__c = AordLst[1].Factory__c ;
            OrdDiff.Fax_Old__c = AordLst[1].Fax__c ;
            OrdDiff.GST_Classification_Region_Old__c = AordLst[1].GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_Old__c = AordLst[1].IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_Old__c = AordLst[1].Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_Old__c = AordLst[1].ISTBD__c ;
            OrdDiff.Ledger_Name_Old__c = AordLst[1].Ledger_Name__c ;
            OrdDiff.Lock_Old__c = AordLst[1].Lock__c ;
            OrdDiff.MaterielNo_Old__c = AordLst[1].MaterielNo__c ;
            OrdDiff.MaxRowNo_Old__c = AordLst[1].MaxRowNo__c ;
            OrdDiff.Normal_Old__c = AordLst[1].Normal__c ;
            OrdDiff.OA_Emergency_level_Old__c = AordLst[1].OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_Old__c = AordLst[1].OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_Old__c = AordLst[1].OA_Operate_Type__c ;
            OrdDiff.Operate_Type_Old__c = AordLst[1].Operate_Type__c ;
            OrdDiff.Opportunity_Old__c = AordLst[1].Opportunity__c ;
            OrdDiff.Order_Amount_Old__c = AordLst[1].TotalAmount__c ;
            OrdDiff.Order_Currency_Old__c = AordLst[1].CurrencyIsoCode ;
            OrdDiff.Order_End_Date_Old__c = AordLst[1].EndDate__c ;
            OrdDiff.Order_Name_Old__c = AordLst[1].Name ;
            OrdDiff.Order_Reference_Number_Old__c = AordLst[1].OrderReferenceNumber__c ;
            OrdDiff.Order_Start_Date_Old__c = AordLst[1].EffectiveDate__c ;
            OrdDiff.Original_Order_Old__c = AordLst[1].OriginalOrder__c ;
            OrdDiff.Other_Old__c = AordLst[1].Other__c ;
            OrdDiff.Payment_Term_Description_Old__c = AordLst[1].Payment_Term_Description__c ;
            OrdDiff.Phone_Old__c = AordLst[1].Phone__c ;
            OrdDiff.PMC_confirm_Old__c = AordLst[1].PMC_confirm__c ;
            OrdDiff.PO_Date_Old__c = AordLst[1].PODate__c ;
            OrdDiff.PO_Number_Old__c = AordLst[1].PONumber__c ;
            OrdDiff.Previous_Amendment_Generation_Date_Old__c = AordLst[1].Previous_Amendment_Generation_Date__c ;
            OrdDiff.Product_Group_Old__c = AordLst[1].Product_Group__c ;
            OrdDiff.Progress_Remarks_Old__c = AordLst[1].Progress_Remarks__c ;
            OrdDiff.Quote_Old__c = AordLst[1].Quote__c ;
            OrdDiff.Reduction_Order_Old__c = AordLst[1].IsReductionOrder__c ;
            OrdDiff.Region_Old__c = AordLst[1].Region__c ;
            OrdDiff.Requested_supplier_Old__c = AordLst[1].Requested_supplier__c ;
            OrdDiff.Routing_Number_ABA_Old__c = AordLst[1].Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_Old__c = AordLst[1].Sales_Dept__c ;
            OrdDiff.Sales_Group_Old__c = AordLst[1].Sales_Group__c ;
            OrdDiff.Sales_Org_Old__c = AordLst[1].Sales_Org__c ;
            OrdDiff.Sales_Region_Old__c = AordLst[1].Sales_Region__c ;
            OrdDiff.SAP_Company_Code_Old__c = AordLst[1].SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_Old__c = AordLst[1].SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_Old__c = AordLst[1].SAP_Describe__c ;
            OrdDiff.SAP_External_ID_Old__c = AordLst[1].SAP_External_ID__c ;
            OrdDiff.SAP_Factory_Old__c = AordLst[1].SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_Old__c = AordLst[1].SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_Old__c = AordLst[1].SAP_Project_No__c ;
            OrdDiff.SAP_Region_Old__c = AordLst[1].SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_Old__c = AordLst[1].SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_Old__c = AordLst[1].SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_Old__c = AordLst[1].SAP_User_ID__c ;
            OrdDiff.SC_Old__c = AordLst[1].SC_No__c ;
            OrdDiff.Search_Old__c = AordLst[1].Search__c ;
            OrdDiff.SELLER_Old__c = AordLst[1].SELLER__c ;
            OrdDiff.SEQ_Old__c = AordLst[1].SEQ__c ;
            OrdDiff.Ship_To_Contact_Old__c = AordLst[1].ShipToContact__c ;
            OrdDiff.Shipping_type_Old__c = AordLst[1].Shipping_type__c ;
            OrdDiff.Special_Approvals_Old__c = AordLst[1].Special_Approvals__c ;
            OrdDiff.Special_Requirements_Old__c = AordLst[1].Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_Old__c     = AordLst[1].SPECIAL_TERMS__c ;
            OrdDiff.Special_Old__c = AordLst[1].Special__c ;
            OrdDiff.Stage_Old__c = AordLst[1].Stage__c ;
            OrdDiff.Status_Old__c = AordLst[1].Status__C ;
            OrdDiff.Street_Room_Number_Old__c = AordLst[1].Street_Room_Number__c ;
            OrdDiff.Subject_Group_Old__c = AordLst[1].Subject_Group__c ;
            OrdDiff.Supply_By_Old__c = AordLst[1].Supply_By__c ;
            OrdDiff.SWIFT_Code_Old__c = AordLst[1].SWIFT_Code__c ;
            OrdDiff.Tax_Old__c = AordLst[1].Tax__c ;
            OrdDiff.Tax_No_Old__c = AordLst[1].Tax_No__c ;
            OrdDiff.Tax_Rate_Old__c = AordLst[1].Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_Old__c = AordLst[1].Taxpayer_Identification_No__c ;
            OrdDiff.Title_Old__c = AordLst[1].Title__c ;
            OrdDiff.Total_Price_Old__c = AordLst[1].Total_Price__c ;
            OrdDiff.Total_Price_Tax_Old__c = AordLst[1].Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_Old__c = AordLst[1].Total_Quantity__c ;
            OrdDiff.Trade_term_Old__c = AordLst[1].Trade_term__c ;
            OrdDiff.Transit_Fees_Old__c  = AordLst[1].Transit_Fees__c  ;
            OrdDiff.Update_Time_1st_Old__c = AordLst[1].Update_Time_1st__c ;
            OrdDiff.VAT_NO_Old__c = AordLst[1].VAT_NO__c ;
            OrdDiff.Warranty_Insurance_Old__c = AordLst[1].Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_Old__c = AordLst[1].Warranty_On_Material_and_Workmanship__c ;
            
            insert OrdDiff;
            id2=AordLst[1].id;
            system.debug('插入业务机会下的产品差异数据');
            List<Amendment_Order_Product__c> orderlineLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                                         'Where OriginalOrderItem__c =:id2');
            
            system.debug('orderlineLst数量为:'+orderlineLst.size());
            Integer falg =0;
            List<OrderItem_Difference__c> OrderItemDiffLst = new  List<OrderItem_Difference__c>();
            for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                falg = 0;
                for(Amendment_Order_Product__c OrderItemOld : orderlineLst){
                    system.debug('OrderItemOld.Id:'+OrderItemOld.Id);
                    system.debug('OrderItemNew.ID__c:'+OrderItemNew.ID__c);
                    if(OrderItemOld.ID__c== OrderItemNew.ID__c){
                        system.debug('产品配对');
                        OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                        OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                        OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                        OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_New__c =OrderItemNew.Product2__c;
                        OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                        OrderLinDiff.SAP_Product_Materiel_No_New__c =  OrderItemNew.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                        OrderLinDiff.total_Price_New__c =  OrderItemNew.total_Price__c;
                        OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                        OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c; 
                        OrderLinDiff.total_Price2_New__c =OrderItemNew.TotalPrice__c;
                        OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                        OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product_Name__c;
                        OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_Old__c = OrderItemOld.Product2__c;
                        OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity__c;
                        OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                        OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                        OrderLinDiff.total_Price2_Old__c =OrderItemOld.TotalPrice__c;
                        OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                        OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice__c;
                        OrderItemDiffLst.add(OrderLinDiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                    OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_New__c = OrderItemNew.Product2__c;
                    OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                    OrderLinDiff.SAP_Product_Materiel_No_New__c = OrderItemNew.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                    OrderLinDiff.total_Price_New__c = OrderItemNew.total_Price__c;
                    OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                    OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c;
                    OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                    OrderItemDiffLst.add(OrderLinDiff);
                }
            }
            for(Amendment_Order_Product__c OrderItemOld : orderlineLst){
                falg = 0;
                for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                    if(String.valueOf(OrderItemOld.Id) == OrderItemNew.ID__c){
                        falg=1;    
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.Name =OrderItemOld.Product_Name__c;
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product_Name__c;
                    OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_Old__c = OrderItemOld.Product2__c;
                    OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity__c;
                    OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                    OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                    OrderLinDiff.total_Price2_Old__c =OrderItemOld.TotalPrice__c;
                    OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                    OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice__c;
                    OrderItemDiffLst.add(OrderLinDiff);
                    
                }
            }
            if(OrderItemDiffLst.size()>0)insert OrderItemDiffLst;
            
            //插入业务机会下的付款方式数据
            List<PaymentDifference__c> paydiffLst = new  List<PaymentDifference__c>();
            List<Amendment_Payment__c> payLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                             'Where Amendment_Purchase_Agreement__c =:id2');
            for(Amendment_Payment__c payNew : APayLst){
                falg = 0;
                for(Amendment_Payment__c payOld : payLst){
                    if(payNew.ID__c == payOld.ID__c){
                        system.debug('付款配对');
                        PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Order_Differences__c = OrdDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        paydiff.Days_New__c = payNew.Days__c;
                        paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                        paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                        paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                        paydiff.Percentage_New__c  = payNew.Percentage__c;
                        paydiff.Days_Old__c = payOld.Days__c;
                        paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                        paydiff.PaymentDescription_old__c=payOld.PaymentDescription__c;
                        paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
                        paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
                        paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
                        paydiff.Percentage_Old__c =payOld.Percentage__c;
                        paydiffLst.add(paydiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    system.debug('付款新建配对');
                    PaymentDifference__c paydiff =new PaymentDifference__c();
                    paydiff.Order_Differences__c = OrdDiff.Id;
                    paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    paydiff.Days_New__c = payNew.Days__c;
                    paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                    paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                    paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                    paydiff.Percentage_New__c = payNew.Percentage__c;
                    paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                    paydiffLst.add(paydiff);
                }
            }
            /*
for(Amendment_Payment__c payOld : payLst){
falg = 0;
for(Amendment_Payment__c payNew : APayLst){
if(payNew.ID__c == payOld.Id){
falg=1;
}
}
if(falg ==0){
system.debug('付款被删除了');
PaymentDifference__c paydiff =new PaymentDifference__c();
paydiff.Order_Differences__c = OrdDiff.Id;
paydiff.Days_Old__c = payOld.Days__c;
paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
paydiff.Percentage_Old__c =payOld.Percentage__c;
paydiffLst.add(paydiff);
}
}
*/
            system.debug(paydiffLst.size());
            if(paydiffLst.size()>0)insert paydiffLst;
            
        }
        Order_Differences__c OD =[select   Amendment_Purchase_Agreement__r.Region__c,Contract_PO_PI_Owner_New__r.name , Contract_PO_PI_Owner_Old__r.name , Actual_Sales_Name_New__c , Actual_Sales_Name_Old__c , Opportunity_New__r.name , Opportunity_Old__r.name , Account_Name_New__r.name  , Account_Name_Old__r.name, Destination_Country_New__c  ,  Destination_Country_Old__c  ,
                                  SAP_User_ID_New__c ,  SAP_User_ID_Old__c , Contract_PO_PI_No_New__c , Contract_PO_PI_No_Old__c , Supply_By_New__c ,  Supply_By_Old__c , Status_New__c  ,  Status_Old__c ,
                                  Buyer_New__r.name  ,       Buyer_Old__r.name 
                                  ,   Order_Start_Date_New__c  ,       Order_Start_Date_Old__c 
                                  ,   Destination_New__c  ,       Destination_Old__c 
                                  ,   Factory_WH_New__c  ,       Factory_WH_Old__c 
                                  ,   Shipping_type_New__c  ,       Shipping_type_Old__c 
                                  , 
                                  Discount_New__c,Discount_old__c,
                                  Rebate_New__c,
                                  Rebate_old__c,
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
                                  ,   Phone_New__c  ,       Phone_Old__c ,Amendment_Purchase_Agreement__r.Destination_Country__c
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
                                  where Amendment_Purchase_Agreement__c =: Aorderid];
        String ODId=OD.ID;
        Boolean noSend = false ;
        List<OrderItem_Difference__c> OIDLst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem_Difference__c) + ' ' +
                                                              'where Order_Differences__c =: ODId');
        List<PaymentDifference__c>  PDLst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.PaymentDifference__c) + ' ' +
                                                           'where Order_Differences__c =: ODId');
        
        List<String> id = new List<String>();
        Boolean SendToLegal = false; 
        Boolean SendToGM = false; 
        Boolean SendToBMO = false; 
        Boolean SendToFinance = false; 
        Boolean SendToCredit = false; 
        Boolean SendToZuzhang = false; 
        Boolean SendToTechlongy = false; 
        if(OD.Destination_Country_New__c != OD.Destination_Country_Old__c ||
           OD.Contract_PO_PI_Owner_New__r.name!=OD.Contract_PO_PI_Owner_Old__r.name||
           OD.Actual_Sales_Name_New__c!=OD.Actual_Sales_Name_Old__c||
           OD.Actual_Sales_Name_New__c!=OD.Actual_Sales_Name_Old__c||
           OD.Opportunity_New__r.name!=OD.Opportunity_Old__r.name||OD.Account_Name_New__r.name !=OD.Account_Name_Old__r.name||
           OD.SELLER_New__c != OD.SELLER_Old__c||OD.SAP_User_ID_New__c!= OD.SAP_User_ID_Old__c||
           OD.Contract_PO_PI_No_New__c!= OD.Contract_PO_PI_No_Old__c||
           OD.Supply_By_New__c!= OD.Supply_By_Old__c||OD.Status_New__c!=OD.Status_Old__c||OD.Status_New__c != OD.Status_Old__c||
           OD.Buyer_New__r.name !=      OD.Buyer_Old__r.name 
           ||  OD.Order_Start_Date_New__c !=      OD.Order_Start_Date_Old__c 
           ||  OD.Destination_New__c !=      OD.Destination_Old__c 
           ||  OD.Factory_WH_New__c !=      OD.Factory_WH_Old__c 
           ||  OD.Shipping_type_New__c !=      OD.Shipping_type_Old__c 
           || 
           OD.Warranty_Insurance_New__c!= OD.Warranty_Insurance_Old__c 
           ||  OD.Region_New__c !=      OD.Region_Old__c 
           ||  OD.Warranty_On_Material_and_Workmanship_New__c !=      OD.Warranty_On_Material_and_Workmanship_Old__c 
           || 
           
           OD.Customer_Order_Reference_PO_New__c !=      OD.Customer_Order_Reference_PO_Old__c
           ||  OD.Commission_Type_New__c !=      OD.Commission_Type_Old__c 
           ||  OD.VAT_NO_New__c !=      OD.VAT_NO_Old__c 
           ||  OD.GST_Classification_Region_New__c !=      OD.GST_Classification_Region_Old__c 
           ||  OD.BMO_SH_New__c !=      OD.BMO_SH_Old__c 
           ||  OD.BMO_SR_New__c !=      OD.BMO_SR_Old__c 
           ||  OD.Special_New__c !=      OD.Special_Old__c 
           ||  OD.Normal_New__c !=      OD.Normal_Old__c 
           ||  OD.Special_Requirements_New__c !=      OD.Special_Requirements_Old__c 
           ||  OD.Special_Approvals_New__c !=      OD.Special_Approvals_Old__c 
           || 
           OD.Intercompany_Seller_POs_New__c !=      OD.Intercompany_Seller_POs_Old__c 
           || 
           OD.Transit_Fees_New__c !=      OD.Transit_Fees_Old__c 
           || 
           OD.Requested_supplier_New__c !=      OD.Requested_supplier_Old__c 
           ||  OD.Other_New__c !=      OD.Other_Old__c 
           ||  OD.PMC_confirm_New__c !=      OD.PMC_confirm_Old__c 
           ||  OD.Tax_Rate_New__c !=      OD.Tax_Rate_Old__c 
           ||  OD.SELLER_New__c !=      OD.SELLER_Old__c 
           ||  OD.Contact_Name_New__c !=      OD.Contact_Name_Old__c 
           ||  OD.Customer_country_New__c !=      OD.Customer_country_Old__c 
           ||  OD.Fax_New__c !=      OD.Fax_Old__c 
           ||  OD.Phone_New__c !=      OD.Phone_Old__c 
           ||  OD.Customer_Business_Scale_New__c !=      OD.Customer_Business_Scale_Old__c   
           ||
           
           OD.Email_New__c !=      OD.Email_Old__c   
           ||  OD.Title_New__c !=      OD.Title_Old__c   
           ||  OD.Authorized_Representative_New__c !=      OD.Authorized_Representative_Old__c   
           ||  OD.BillingCountry_New__c !=      OD.BillingCountry_Old__c   
           ||  OD.BillingState_New__c !=      OD.BillingState_Old__c   
           || 
           OD.BillingCity_New__c !=      OD.BillingCity_Old__c   
           ||  OD.Bank_Street_New__c !=      OD.Bank_Street_Old__c   
           ||  OD.BillingPostalCode_New__c !=      OD.BillingPostalCode_Old__c 
           ||  OD.Trade_term_New__c  !=      OD.Trade_term_Old__c  
           ||  OD.Bank_Information_Content_Old__c.length() - OD.Bank_Information_Content_New__c.length() >5
          ){
              SendToGM =true;
              SendToBMO = true;
              SendToFinance = true;
              
              system.debug('订单变化给BMO发邮件发送邮件啦');
          }
        if( OD.Buyer_New__r.name !=      OD.Buyer_Old__r.name ){
             SendToCredit = true;
        }
        List<String> oldname=new List<String>();
        List<String> newname=new List<String>();
        for(OrderItem_Difference__c OID:OIDLst){
            if(OID.Product_Name_Old__c!=null){
                oldname.add(OID.Product_Name_Old__c);
            }
            if( OID.Product_Name__c!=null){
                newname.add(OID.Product_Name__c)   ; 
            }          
             system.debug('订单产品比较');
            if(OID.Quantity_New__c!=OID.Quantity_Old__c   ||
               OID.Product_New__c!=OID.Product_Old__c ||  OID.SAP_Product_Materiel_No_New__c!=OID.SAP_Product_Materiel_No_Old__c ||
               OID.Total_MW_New__c!=OID.Total_MW_Old__c ||  OID.Type_of_module_New__c!=OID.Type_of_module_Old__c ||  OID.UnitPrice_New__c!=OID.UnitPrice_Old__c  ){
                   SendToBMO = true;
                   SendToGM =true;
                   SendToFinance = true;
                   system.debug('订单产品变化啦'+OID.Guaranteed_Delivery_Date_New__c);
                   system.debug('订单产品变化啦'+OID.Guaranteed_Delivery_Date_Old__c);
                   system.debug('订单产品变化啦'+OD.Amendment_Purchase_Agreement__r.Region__c);
                   
               } 
             if(OID.Guaranteed_Delivery_Date_New__c!=null){
            if(OID.Guaranteed_Delivery_Date_New__c != OID.Guaranteed_Delivery_Date_Old__c && OD.Amendment_Purchase_Agreement__r.Region__c=='North Asia' && OD.Amendment_Purchase_Agreement__r.Destination_Country__c=='Japan'){
                       SYstem.debug('北亚的交期改变'); 
                       SendToZuzhang = true; 
                SendToFinance = true;
                SendToBMO = true;
                system.debug('进入比较'+OID.Guaranteed_Delivery_Date_New__c);
                boolean GMSend =false;
                if(OID.Guaranteed_Delivery_Date_Old__c !=null 
                   && OID.Guaranteed_Delivery_Date_New__c !=null ){
                     GMSend =OrderApprovalCounts.ChangeQuarter(OID.Guaranteed_Delivery_Date_Old__c,OID.Guaranteed_Delivery_Date_New__c);
                System.debug('GMSend------123'+GMSend);
                }
               
                if(GMSend){
                    SendToGM = true;
                    System.debug('SendToGM--------->1234'+SendToGM);
                }

                   }
             }
                
            
                   if(OID.Guaranteed_Delivery_Date_New__c != OID.Guaranteed_Delivery_Date_Old__c && OD.Amendment_Purchase_Agreement__r.Region__c!='North Asia'){
                        SYstem.debug('非北亚的交期改变');   
                       SendToGM =true;
                       SendToFinance = true;
                SendToBMO = true;
                   }
                
        }
        if(oldname.size()==0 && newname.size()>0){
            SendToTechlongy=true;
            system.debug('旧老版本给T发邮件发送邮件啦');
        }
        if(oldname.size()>0 && newname.size()>0){
            for(String newstr:newname){
                string TF ='0';//开关
                for(String oldstr:oldname){
                    if(newstr==oldstr){
                        TF='1';
                        break;
                    }
                }
                if(TF=='0'){
                    SendToTechlongy=true;
                    system.debug('产品名字变化给T发邮件发送邮件啦');
                    break;
                }
            }   
        }
        
        
        //Quantity 修改
        
        for(PaymentDifference__c PD:PDLst){
            if(PD.Payment_Method_New__c!=PD.Payment_Method_Old__c || PD.Percentage_New__c!=PD.Percentage_Old__c ||
               PD.Payment_Term_New__c	!=PD.Payment_Term_Old__c || PD.Down_Balance_Payment_New__c!=PD.Down_Balance_Payment_New__c ||
               PD.Days_New__c	!=PD.Days_Old__c){
                   system.debug('付款方式变化给法务发送邮件啦');
                   SendToBMO = true; 
                   SendToGM =true;
                   SendToFinance = true;
                    SendToCredit = true;
               }
            //Payment Method 修改
        }
        List<SubmitForReview__c> sfr=[select id,Role__c,Status__c from SubmitForReview__c where Amendment__c =:Aorderid ];
        boolean f =false;
        boolean bmo =false;
        boolean l =false;
        boolean t =false;
        Boolean gm =false;
        if(sfr.size()>0){
            for(SubmitForReview__c sfs:sfr){
                if (sfs.Role__c.indexof('Finance')>-1 && sfs.Status__c=='Approved'){
                    f =true;
                }
                else if (sfs.Role__c.indexof('Finance')>-1 && (sfs.Status__c=='Rejected' || sfs.Status__c=='Pending')){
                    sfs.Status__c='Pending';
                }
                else    if (sfs.Role__c.indexof('Legal')>-1 && sfs.Status__c=='Approved'){
                    l =true;
                }
                else if (sfs.Role__c.indexof('Legal')>-1 && (sfs.Status__c=='Rejected' || sfs.Status__c=='Pending')){
                    sfs.Status__c='Pending';
                }
                else    if (sfs.Role__c.indexof('GM')>-1 && sfs.Status__c=='Approved'){
                    gm =true;
                }
                else if (sfs.Role__c.indexof('GM')>-1 && (sfs.Status__c=='Rejected' || sfs.Status__c=='Pending')){
                    sfs.Status__c='Pending';
                }
                else      if (sfs.Role__c.indexof('BMO')>-1 && sfs.Status__c=='Approved'){
                    bmo =true;
                }
                else  if (sfs.Role__c.indexof('BMO')>-1 && (sfs.Status__c=='Rejected' || sfs.Status__c=='Pending')){
                    sfs.Status__c='Pending';
                }
                else   if (sfs.Role__c.indexof('Technical')>-1 && sfs.Status__c=='Approved'){
                    t =true;
                }
                else  if (sfs.Role__c.indexof('Technical')>-1 && (sfs.Status__c=='Rejected' || sfs.Status__c=='Pending')){
                    sfs.Status__c='Pending';
                }
                
            }
            update sfr;
        }
        SET<Approver> approverList = new SET<Approver>(); 
        
        Order_Differences__c newOrdDiff= new Order_Differences__c();
        User currUser = [SELECT u.Id,u.ManagerId,u.Contract_Approver__c, u.Contract_Review__c,u.Cross_Region_BMO__c, u.BMO_specialist__c,UserRoleId,UserRole.Name,Country__c FROM USER u WHERE u.Id=:OD.OwnerId];
        if(SendToFinance && f==false){
            List<Amendment__c> Aord2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                     'Where id =: Aorderid');
            List<User> usr = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Alias =: 'Alexjian'];
            //     List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Alex jiang'];
            if(usr.size()>0){
                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
            }
            SYStem.debug('发邮件给 f');
            if(Sendtocredit){
                List<User> usrr = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Alias =: 'Credit'];
            if(usrr.size()>0){
                approverList.add(new Approver(usrr[0].Email,usrr[0].Name,usrr[0].UserRole.Name,usrr[0].Id));
            }
 
            }
            if(aord2[0].Region__c=='North Asia'){
                        SendEmailUtils.sendToSomeOne(Aord2[0].id,'Credit' , 'amentendsendfile');
                        SendEmailUtils.sendToSomeOne(Aord2[0].id,'miho fujiwara' , 'amentendsendfile');
                 //Utils.sendEmailWithTemplate2('hisashi.sakai@jinkosolar.com', Aord2[0].id, 'amentendsendfile',Aord2[0].Contract_Owner__c);
                    }
        }
        
        newOrdDiff = [Select Id,Amendment_Purchase_Agreement__c,Amendment_Purchase_Agreement__r.Region__c,Amendment_Purchase_Agreement__r.Destination_Country__c from Order_Differences__c where Amendment_Purchase_Agreement__c=:Aorderid];
        if(SendToLegal==true && l==false){
            
            if(newOrdDiff.Amendment_Purchase_Agreement__r.Region__c=='North Asia' && newOrdDiff.Amendment_Purchase_Agreement__r.Destination_Country__c=='Japan'){
                 List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal.japan@jinkosolar.com'];
                //List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Japan'];
                if(usr.size()>0){
                    
                    approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                }
                SYStem.debug('发邮件给 l');
            }else {
                 List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal@jinkosolar.com'];
               // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Public '];
                if(usr.size()>0){
                    approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));  
                }
                SYStem.debug('发邮件给 l');
            }
        }
        
        if(SendToTechlongy && t==false){
                List<User> usr =new List<User>();
            if(Aord.Sales_Region_ConOwner__c=='North Asia' || Aord.Sales_Region_ConOwner__c=='North America'|| Aord.Sales_Region_ConOwner__c=='EU(Union)'|| Aord.Sales_Region_ConOwner__c=='EU(Non-Eu)'|| Aord.Sales_Region_ConOwner__c=='ROA'|| Aord.Sales_Region_ConOwner__c=='Central Asia'|| Aord.Sales_Region_ConOwner__c=='Key Account'){
           usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'technic1@jinkosolar.com'];
            //        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Jinko Technic'];
            }
            if(Aord.Sales_Region_ConOwner__c=='Middle East&Africa'||Aord.Sales_Region_ConOwner__c == 'MENA'||Aord.Sales_Region_ConOwner__c == 'SSA'|| Aord.Sales_Region_ConOwner__c=='Latin America&Italy'|| Aord.Sales_Region_ConOwner__c=='South Asia'){
           usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'technic2@jinkosolar.com'];
            //        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Jinko Technic'];
            }
            //List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'technic@jinkosolar.com'];
            // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Jinko Technic'];
            
            if(usr.size()>0){
                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id)); 
            }
            SYStem.debug('发邮件给 t');
        }
        if(SendToBMO && bmo==false){
            Order ordAmen =[Select id,Contract_Owner__c,Contract_Owner__r.BMO_specialist__c,Contract_Owner__r.Cross_Region_BMO__c FROM Order where id =:id1];
            
            if(Aord.Cross_Region__c==false){
                List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.BMO_specialist__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id)); 
                }
                SYStem.debug('发邮件给 bmo');
            }
            else if(Aord.Cross_Region__c==true){
                List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.Cross_Region_BMO__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id)); 
                }
                SYStem.debug('发邮件给  跨区 bmo'); 
            }
            
        }
        if(SendToZuzhang && SendToGM==false){
            system.debug('进入北亚交期组长发送阶段');
           List<Amendment__c> Aord2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                     'Where id =: Aorderid');
            if(Aord2.size()>0){
                String Userid= Aord2[0].Contract_Owner__c;
                User us2=[select id,Contract_Review__r.Email,Contract_Approver__r.Email from user where id =:userid];
                String RegionHeadEmail2 = us2.Contract_Review__r.Email;
                    if(RegionHeadEmail2 !=null && RegionHeadEmail2 !=''){
                    List<User> usr =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail2];
                    if(Aord2[0].LogisticsCost__c==null){
                    Aord2[0].LogisticsCost__c=0;    
                    }
                    if(usr.size()>0 && Aord2[0].LogisticsCost__c<=100000){
                        system.debug('usr'+usr);
                        approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id)); 
            }else if( Aord2[0].LogisticsCost__c>100000){
                RegionHeadEmail2 = us2.Contract_Approver__r.Email;
                
                SYStem.debug('准备发邮件给 Gm3');
                if(RegionHeadEmail2 !=null && RegionHeadEmail2 !=''){
                    SYStem.debug('准备发邮件给 Gm4');
                    List<User> usr2 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail2];
                    SYStem.debug('准备发邮件给 Gm5');
                    
                    if(usr2.size()>0){
                        approverList.add(new Approver(usr2[0].Email,usr2[0].Name,usr2[0].UserRole.Name,usr2[0].Id)); 
                    }
                    if(Aord.Cross_Region__c == true ){
                String RegionHeadName ='';
                String RegionHeadEmail ='';
                if(Aord.Region__c =='EU'|| Aord.Region__c=='Non EU'){
                    RegionHeadEmail=Label.Area_EU;
                }
                else if(Aord.Region__c =='EU(Union)'|| Aord.Region__c=='EU(Non-Eu)'){
                    RegionHeadEmail=Label.Area_EU;
                }
                else if(Aord.Region__c =='ROA'){
                    RegionHeadEmail=Label.Area_ROA;
                }else if(Aord.Region__c =='North Asia'){
                    RegionHeadEmail=Label.Area_North_Asia;
                }else if(Aord.Region__c =='South Asia'){
                    RegionHeadEmail=Label.Area_South_Asia;
                }else if(Aord.Region__c =='North America'){
                    RegionHeadEmail=Label.Area_North_America;
                }
               // else if(Aord.Region__c =='Middle East&Africa'){
               //     RegionHeadEmail=Label.Area_Middle_east_africa;
               // }
                else if(Aord.Region__c =='Latin America&Italy'){
                    RegionHeadEmail=Label.Area_Latin_America_Italy;
                }else if(Aord.Region__c =='MENA'){
                    RegionHeadEmail=Label.Middle_East_North_Africa;
                }else if(Aord.Region__c =='SSA'){
                    RegionHeadEmail=Label.Sub_Saharan_Africa;
                }
                        
                if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                    List<User> us =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail];
                    
                    system.debug('1111');
                    if(us.size()>0){
                        approverList.add(new Approver(us[0].Email,us[0].Name,us[0].UserRole.Name,us[0].Id));
                    }
                }
            }
                
            }
        }
                        }
            }
        }
        if(SendToGM && gm==false){
            SYStem.debug('准备发邮件给 Gm');
            List<Amendment__c> Aord2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                     'Where id =: Aorderid');
            if(Aord2.size()>0){
                String Userid= Aord2[0].Contract_Owner__c;
                User us=[select id,Contract_Approver__r.Email,Contract_Review__r.Email from user where id =:userid];
                String RegionHeadEmail = us.Contract_Approver__r.Email;
                String RegionHeadEmail2 = us.Contract_Review__r.Email;
                SYStem.debug('准备发邮件给 Gm3');
                if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                    SYStem.debug('准备发邮件给 Gm4');
                    List<User> usr =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail];
                    SYStem.debug('准备发邮件给 Gm5');
                    
                    if(usr.size()>0){
                        approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id)); 
                    }
                    SYStem.debug('发邮件给 gm');
                }
                if(RegionHeadEmail2 !=null && RegionHeadEmail2 !='' && Aord.Region__c =='North Asia' && Aord.Destination_Country__c=='Japan'){
                    SYStem.debug('准备发邮件给组长');
                    List<User> usr2 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail2];
                    SYStem.debug('准备发邮件给组长2');
                    
                    if(usr2.size()>0){
                        approverList.add(new Approver(usr2[0].Email,usr2[0].Name,usr2[0].UserRole.Name,usr2[0].Id)); 
                    }
                       SYStem.debug('发邮件给 组长');
                }
                 
                }
                    
                    
                
            
            
            
            
            if(Aord.Cross_Region__c == true ){
                String RegionHeadName ='';
                String RegionHeadEmail ='';
                if(Aord.Region__c =='EU'|| Aord.Region__c=='Non EU'){
                    RegionHeadEmail=Label.Area_EU;
                }
                else if(Aord.Region__c =='EU(Union)'|| Aord.Region__c=='EU(Non-Eu)'){
                    RegionHeadEmail=Label.Area_EU;
                }
                else if(Aord.Region__c =='ROA'){
                    RegionHeadEmail=Label.Area_ROA;
                }else if(Aord.Region__c =='North Asia'){
                    RegionHeadEmail=Label.Area_North_Asia;
                }else if(Aord.Region__c =='South Asia'){
                    RegionHeadEmail=Label.Area_South_Asia;
                }else if(Aord.Region__c =='North America'){
                    RegionHeadEmail=Label.Area_North_America;
                }
               // else if(Aord.Region__c =='Middle East&Africa'){
               //     RegionHeadEmail=Label.Area_Middle_east_africa;
               // }
                else if(Aord.Region__c =='Latin America&Italy'){
                    RegionHeadEmail=Label.Area_Latin_America_Italy;
                }else if(Aord.Region__c =='MENA'){
                    RegionHeadEmail=Label.Middle_East_North_Africa;
                }else if(Aord.Region__c =='SSA'){
                    RegionHeadEmail=Label.Sub_Saharan_Africa;
                }

                
                if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                    List<User> us =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail];
                    
                    system.debug('1111');
                    if(us.size()>0){
                        approverList.add(new Approver(us[0].Email,us[0].Name,us[0].UserRole.Name,us[0].Id));
                    }
                }
            }
        }
        
        
        //try{
        List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
        List<String> ApproverName = new List<String>(); 
        List<Id> ApproverId = new List<Id>();
        List<String> email = new List<String>();
        for (Approver u : approverList ) {
            
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
            email.add(u.uEmail);
            system.debug('~~~~~~~~~~~>email:'+email);
            ApproverId.add(u.uId);
            ApproverName.add(u.uName);
            system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					
            
        }
        system.debug('~~~~~~~~>reviewList:' + reviewList);
        for(ID userid : ApproverId){
            SubmitForReview__c review = new SubmitForReview__c();
            review.Amendment__c = OD.Amendment_Purchase_Agreement__c;
            review.Status__c    = 'Pending';
            review.User__c      = userid;
            
            reviewList.add(review);
            
            System.debug('~~~~~~~~~userid'+userid);
            System.debug('~~~~~~~~~User__c'+review.User__c);
        }
        List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                 Remarks__c,
                                                 Role__c,
                                                 Status__c,
                                                 User__c
                                                 from SubmitForReview__c
                                                 where Amendment__c =: OD.Amendment_Purchase_Agreement__c
                                                 AND User__c in: ApproverId];
        system.debug('------>oldReviewList:' +  oldReviewList);
        
        if(oldReviewList.size()>0 && oldReviewList != null){
            delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
        }
        
        if(reviewList.size() > 0)insert reviewList;	
        //AmendmentSendEmailCtrl.SendAmendmentReviewMail(approverList,am.Id);
        //CommonUtils.SendAmendmentReviewMail(u.uEmail,am.Id);
        system.debug('====== noSend' + noSend);
        if(!noSend){
            system.debug('=======发送le ' );
            OrderApprovalCounts.SendAmendmentReviewMail(approverList,OD.Amendment_Purchase_Agreement__c);
            String emailnamelist='';
            if(ApproverName.size()>0){
                for(String emailname:ApproverName){
                    emailnamelist+=emailname+ ' ';
                }
            }
            return 'Submit success. '+emailnamelist+ ' has received this request.';
            
        }else{
            //  当为空的时候可以发邮件给 Owner 一封邮件 ，再次提醒！
            system.debug('=======未发送 ');
            return ' 未发送成功';
        }
        //List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
        
        
        //   }catch(Exception ex){ }
    }
    public static String Changetoemail(String Aorderid){
                List<Order_Differences__c> odp=[select id from Order_Differences__c where Amendment_Purchase_Agreement__c =: Aorderid];
        if(odp.size()>0){                 delete odp;
                         
                        }
        
        Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: Aorderid');
        
        List<RecordType> rt=[select id from RecordType where name=:'AgreementFile'];
        if(rt.size()>0){
            Aord.RecordTypeid=rt[0].id;
            Aord.Submission_Time__c=datetime.now();
            update Aord;
        }
        system.debug('Aord:'+Aord);
        Id id1=Aord.Order__c;
        Order ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                  'Where id =: id1');
        system.debug('ord:'+ord);
        Id id2=Aord.id;
         if(Aord.Trade_term__c != ord.Trade_term__c ){
              try{
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:'AmendmentAddFreight'];
                 System.debug('Start Send Email-->');
                List<String> emailList = new List<String>();
                String email =Label.Logistics;
                User user =[Select Id,Email,Isactive from User where Email =:email limit 1];
                emailList.add(email);
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                mail.setTargetObjectId(user.ID);
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }                
                mail.setWhatId(Aord.Id);
                mail.setSenderDisplayName(UserInfo.getName());
                mailList.add(mail);
            
            Messaging.sendEmail(mailList);
  
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
        }
        List<Amendment__c> AordLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                  'Where Order__c =:id1 order by CreatedDate DESC');
        system.debug('AordLst数量为:'+AordLst.size());
        system.debug('判断数量');
        if(AordLst.size()==1){
            system.debug('数量为1');
            Aord.ApprovalNumbers__c=1;
            List<Amendment_Payment__c> APayLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                              'Where Amendment_Purchase_Agreement__c =:id2');
            system.debug('APayLst数量为:'+APayLst.size());
            List<Amendment_Order_Product__c> AOPLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                                   'Where OriginalOrderItem__c =:id2');
            system.debug('AOPLst数量为:'+AOPLst.size());
            List<OrderItem> orderlineLst = [Select id,Total_MW__c,TotalPrice,Quantity,UnitPrice,Total_Price__c,Product2Id,Product2.name,SAP_Product_Materiel_No__c,Type_of_module__c,Guaranteed_Delivery_Date__c from OrderItem where OrderId =:ord.id];
            system.debug('orderlineLst数量为:'+orderlineLst.size());
            List<Payment__c> payLst = [select id,Amount__c,Percentage__c,Down_Balance_Payment__c,PaymentDescription__c,payment_Method__c,Days__c,Payment_Term__c,Opportunity__c from Payment__c where Order__c =:ord.id ];
            system.debug('payLst数量为:'+payLst.size());
            
            Order_Differences__c  OrdDiff = new Order_Differences__c();
            OrdDiff.Amendment_Purchase_Agreement__c = Aorderid;
            OrdDiff.Destination_Country_New__c = Aord.Destination_Country__c;
            OrdDiff.SELLER_New__c =Aord.SELLER__c;
            OrdDiff.Total_MW_New__c = Aord.Total_MW2__c;
            OrdDiff.Total_Price_New__c = Aord.Total_Price__c ;
            OrdDiff.Total_Quantity_New__c =  Aord.Total_Quantity__c;
            OrdDiff.Trade_term_New__c = Aord.Trade_term__c ;
            OrdDiff.Commission_New__c = Aord.Commission__c ;
            OrdDiff.zongjia_New__c = Aord.Totalprice__c ;
            OrdDiff.Account_Allocation_Group_New__c = Aord.Account_Allocation_Group__c ;
            OrdDiff.Account_Country_New__c = Aord.Account_Country__c ;
            OrdDiff.Account_Group_New__c = Aord.Account_Group__c ;
            OrdDiff.Account_Id_New__c = Aord.Account_Id__c ;
            OrdDiff.Account_Holder_New__c = Aord.Account_Holder__c ;
            OrdDiff.Account_Name_New__c = Aord.Account__c ;
            OrdDiff.Account_Phone_New__c = Aord.Account_Phone__c ;
            OrdDiff.Account_Title_New__c = Aord.Account_Title__c ;
            OrdDiff.Activated_By_New__c = Aord.ActivatedBy__c ;
            OrdDiff.Activated_Date_New__c = Aord.ActivatedDate__c ;
            OrdDiff.Actual_Sales_Name_New__c = Aord.Actual_Sales_Name__c ;
            OrdDiff.Applicant_Direct_Superior_New__c = Aord.Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers_New__c = Aord.ApprovalNumbers__c ;
            OrdDiff.Authorized_Representative_New__c = Aord.Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_New__c = Aord.Avg_Price_W__c ;
            OrdDiff.Bank_Account_New__c = Aord.Bank_Account__c ;
            OrdDiff.Bank_City_New__c = Aord.Bank_City__c ;
            OrdDiff.Bank_Code_New__c = Aord.Bank_Code__c ;
            OrdDiff.Bank_Country_New__c = Aord.Bank_Country__c ;
            OrdDiff.Bank_Information_Content_New__c = Aord.Bank_Information_Content__c ;
            OrdDiff.Bank_Name_New__c = Aord.Bank_Name__c ;
            OrdDiff.Bank_Region_New__c = Aord.Bank_Region__c ;
            OrdDiff.Bank_Street_New__c = Aord.Bank_Street__c ;
            OrdDiff.BillingCity_New__c = Aord.BillingCity__c ;
            OrdDiff.BillingCountry_New__c = Aord.BillingCountry__c ;
            OrdDiff.BillingPostalCode_New__c = Aord.BillingPostalCode__c ;
            OrdDiff.BillingState_New__c = Aord.BillingState__c ;
            OrdDiff.BillingStreet_New__c = Aord.BillingStreet__c ;
            OrdDiff.BMO_SH_New__c = Aord.BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_New__c = Aord.Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_New__c = Aord.BMO_SR__c ;
            OrdDiff.BSB_Number_New__c = Aord.BSB_Number__c ;
            OrdDiff.Buyer_New__c = Aord.Buyer__c ;
            OrdDiff.BuyerSAPId_New__c = Aord.BuyerSAPId__c ;
            OrdDiff.CC_No_New__c = Aord.CC_No__c ;
            OrdDiff.Commission_Type_New__c = Aord.Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_New__c = Aord.Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_New__c = Aord.CompanyAuthorizedBy__c ;
            OrdDiff.Company_Authorized_Date_New__c = Aord.CompanyAuthorizedDate__c ;
            OrdDiff.Company_Registration_No_New__c = Aord.Company_Registration_No__c ;
            OrdDiff.Contact_Name_New__c = Aord.Contact_Name__c ;
            
            OrdDiff.Contract_Type_New__c = Aord.Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_New__c = Aord.Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_New__c = Aord.Contract_Owner__c ;
            OrdDiff.Country_Scope_New__c = Aord.Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_New__c = Aord.CustomerAuthorizedBy__c ;
            OrdDiff.Customer_Authorized_Date_New__c = Aord.CustomerAuthorizedDate__c ;
            OrdDiff.Customer_Business_Scale_New__c = Aord.Customer_Business_Scale__c ;
            OrdDiff.Customer_country_New__c = Aord.Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_New__c = Aord.delivery_note_CI__c ;
            OrdDiff.Description_New__c = Aord.Description__c ;
            OrdDiff.Destination_Country_New__c = Aord.Destination_Country__c ;
            OrdDiff.Destination_New__c = Aord.Destination__c ;
            OrdDiff.Destination_Port_New__c = Aord.Destination_Port__c ;
            OrdDiff.Email_New__c = Aord.Email__c ;
            OrdDiff.Distribution_channel_New__c = Aord.Distribution_channel__c ;
            OrdDiff.Emergency_level_New__c = Aord.Emergency_level__c ;
            OrdDiff.Factory_WH_New__c = Aord.Factory__c ;
            OrdDiff.Fax_New__c = Aord.Fax__c ;
            OrdDiff.GST_Classification_Region_New__c = Aord.GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_New__c = Aord.IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_New__c = Aord.Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_New__c = Aord.ISTBD__c ;
            OrdDiff.Ledger_Name_New__c = Aord.Ledger_Name__c ;
            OrdDiff.Lock_New__c = Aord.Lock__c ;
            OrdDiff.MaterielNo_New__c = Aord.MaterielNo__c ;
            OrdDiff.MaxRowNo_New__c = Aord.MaxRowNo__c ;
            OrdDiff.Normal_New__c = Aord.Normal__c ;
            OrdDiff.OA_Emergency_level_New__c = Aord.OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_New__c = Aord.OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_New__c = Aord.OA_Operate_Type__c ;
            OrdDiff.Operate_Type_New__c = Aord.Operate_Type__c ;
            OrdDiff.Opportunity_New__c = Aord.Opportunity__c ;
            OrdDiff.Order_Amount_New__c = Aord.TotalAmount__c ;
            OrdDiff.Order_Currency_New__c = Aord.CurrencyIsoCode__c ;
            OrdDiff.Order_End_Date_New__c = Aord.EndDate__c ;
            OrdDiff.Order_Name_New__c = Aord.Name__c ;
            OrdDiff.Order_Reference_Number_New__c = Aord.OrderReferenceNumber__c ;
            OrdDiff.Order_Start_Date_New__c = Aord.EffectiveDate__c ;
            OrdDiff.Original_Order_New__c = Aord.OriginalOrder__c ;
            OrdDiff.Other_New__c = Aord.Other__c ;
            OrdDiff.Payment_Term_Description_New__c = Aord.Payment_Term_Description__c ;
            OrdDiff.Phone_New__c = Aord.Phone__c ;
            OrdDiff.PMC_confirm_New__c = Aord.PMC_confirm__c ;
            OrdDiff.PO_Date_New__c = Aord.PODate__c ;
            OrdDiff.PO_Number_New__c = Aord.PONumber__c ;
            OrdDiff.Previous_Amendment_Generation_Date_New__c = Aord.Previous_Amendment_Generation_Date__c ;
            OrdDiff.Product_Group_New__c = Aord.Product_Group__c ;
            OrdDiff.Progress_Remarks_New__c = Aord.Progress_Remarks__c ;
            OrdDiff.Quote_New__c = Aord.Quote__c ;
            OrdDiff.Reduction_Order_New__c = Aord.IsReductionOrder__c ;
            OrdDiff.Region_New__c = Aord.Region__c ;
            OrdDiff.Requested_supplier_New__c = Aord.Requested_supplier__c ;
            OrdDiff.Routing_Number_ABA_New__c = Aord.Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_New__c = Aord.Sales_Dept__c ;
            OrdDiff.Sales_Group_New__c = Aord.Sales_Group__c ;
            OrdDiff.Sales_Org_New__c = Aord.Sales_Org__c ;
            OrdDiff.Sales_Region_New__c = Aord.Sales_Region__c ;
            OrdDiff.SAP_Company_Code_New__c = Aord.SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_New__c = Aord.SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_New__c = Aord.SAP_Describe__c ;
            OrdDiff.SAP_External_ID_New__c = Aord.SAP_External_ID__c ;
            OrdDiff.SAP_Factory_New__c = Aord.SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_New__c = Aord.SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_New__c = Aord.SAP_Project_No__c ;
            OrdDiff.SAP_Region_New__c = Aord.SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_New__c = Aord.SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_New__c = Aord.SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_New__c = Aord.SAP_User_ID__c ;
            OrdDiff.SC_New__c = Aord.SC_No__c ;
            OrdDiff.Search_New__c = Aord.Search__c ;
            OrdDiff.Seller_Address_New__c = Aord.Seller_Address__c ;
            OrdDiff.SELLER_New__c = Aord.SELLER__c ;
            OrdDiff.Seller_Name_New__c = Aord.Seller_Name__c ;
            OrdDiff.SEQ_New__c = Aord.SEQ__c ;
            OrdDiff.Ship_To_Contact_New__c = Aord.ShipToContact__c ;
            OrdDiff.Shipping_type_New__c = Aord.Shipping_type__c ;
            OrdDiff.Special_Approvals_New__c = Aord.Special_Approvals__c ;
            OrdDiff.Special_Requirements_New__c = Aord.Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_New__c	 = Aord.SPECIAL_TERMS__c ;
            OrdDiff.Special_New__c = Aord.Special__c ;
            OrdDiff.Stage_New__c = Aord.Stage__c ;
            OrdDiff.Status_New__c = Aord.Status__c ;
            OrdDiff.Street_Room_Number_New__c = Aord.Street_Room_Number__c ;
            OrdDiff.Subject_Group_New__c = Aord.Subject_Group__c ;
            OrdDiff.Supply_By_New__c = Aord.Supply_By__c ;
            OrdDiff.SWIFT_Code_New__c = Aord.SWIFT_Code__c ;
            OrdDiff.Tax_New__c = Aord.Tax__c ;
            OrdDiff.Tax_No_New__c = Aord.Tax_No__c ;
            OrdDiff.Tax_Rate_New__c = Aord.Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_New__c = Aord.Taxpayer_Identification_No__c ;
            OrdDiff.Title_New__c = Aord.Title__c ;
            OrdDiff.Total_MW_New__c = Aord.Total_MW2__c ;
            OrdDiff.Total_Price_New__c = Aord.Total_Price__c ;
            OrdDiff.Total_Price_Tax_New__c = Aord.Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_New__c = Aord.Total_Quantity__c ;
            OrdDiff.Trade_term_New__c = Aord.Trade_term__c ;
            OrdDiff.Transit_Fees_New__c	 = Aord.Transit_Fees__c	 ;
            OrdDiff.Update_Time_1st_New__c = Aord.Update_Time_1st__c ;
            OrdDiff.VAT_NO_New__c = Aord.VAT_NO__c ;
            OrdDiff.Warranty_Insurance_New__c = Aord.Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_New__c = Aord.Warranty_On_Material_and_Workmanship__c ;
            OrdDiff.Discount_New__c = Aord.Discount__c ; 
            OrdDiff.Rebate_New__c = Aord.Rebate__c ;
            
            
            
            
            
            
            
            
            
            
            
            OrdDiff.Destination_Country_Old__c = ord.Destination_Country__c ;
            OrdDiff.Discount_old__c = ord.Discount__c ;
            OrdDiff.Rebate_old__c = ord.Rebate__c ;
            OrdDiff.SELLER_Old__c = ord.SELLER__c;
            OrdDiff.ApprovalNumbers__c  = Aord.ApprovalNumbers__c;
            OrdDiff.Total_MW_Old__c  = ord.Total_MW__c;
            OrdDiff.Total_Price_Old__c = ord.Total_Price__c;
            OrdDiff.Total_Quantity_Old__c = ord.Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = ord.Trade_term__c;
            OrdDiff.Commission_Old__c = ord.Commission__c;
            OrdDiff.Destination_Country_Old__c = ord.Destination_Country__c;
            OrdDiff.SELLER_Old__c =ord.SELLER__c;
            OrdDiff.Total_MW_Old__c = ord.Total_MW__c;
            OrdDiff.Total_Price_Old__c = ord.Total_Price__c ;
            OrdDiff.Total_Quantity_Old__c =  ord.Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = ord.Trade_term__c ;
            OrdDiff.Commission_Old__c = ord.Commission__c ;
            OrdDiff.zongjia_Old__c = ord.Total_Price__c ;
            OrdDiff.Account_Allocation_Group_Old__c = ord.Account_Allocation_Group__c ;
            OrdDiff.Account_Country_Old__c = ord.Account_Country__c ;
            OrdDiff.Account_Group_Old__c = ord.Account_Group__c ;
            OrdDiff.Account_Id_Old__c = ord.Account_Id__c ;
            OrdDiff.Account_Holder_Old__c = ord.Account_Holder__c ;
            OrdDiff.Account_Name_Old__c = ord.AccountId ;
            OrdDiff.Account_Phone_Old__c = ord.Account_Phone__c ;
            OrdDiff.Account_Title_Old__c = ord.Account_Title__c ;
            OrdDiff.Activated_By_Old__c = ord.ActivatedById ;
            OrdDiff.Activated_Date_Old__c = ord.ActivatedDate ;
            OrdDiff.Actual_Sales_Name_Old__c = ord.Actual_Sales_Name__c ;
            
            OrdDiff.Applicant_Direct_Superior_Old__c = ord.Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers_Old__c = ord.ApprovalNumbers__c ;
            OrdDiff.Authorized_Representative_Old__c = ord.Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_Old__c = ord.Avg_Price_W__c ;
            OrdDiff.Bank_Account_Old__c = ord.Bank_Account__c ;
            OrdDiff.Bank_City_Old__c = ord.Bank_City__c ;
            OrdDiff.Bank_Code_Old__c = ord.Bank_Code__c ;
            OrdDiff.Bank_Country_Old__c = ord.Bank_Country__c ;
            OrdDiff.Bank_Information_Content_Old__c = ord.Bank_Information_Content__c ;
            OrdDiff.Bank_Name_Old__c = ord.Bank_Name__c ;
            OrdDiff.Bank_Region_Old__c = ord.Bank_Region__c ;
            OrdDiff.Bank_Street_Old__c = ord.Bank_Street__c ;
            OrdDiff.BillingCity_Old__c = ord.BillingCity ;
            OrdDiff.BillingCountry_Old__c = ord.BillingCountry ;
            OrdDiff.BillingPostalCode_Old__c = ord.BillingPostalCode ;
            OrdDiff.BillingState_Old__c = ord.BillingState ;
            OrdDiff.BillingStreet_Old__c = ord.BillingStreet ;
            OrdDiff.BMO_SH_Old__c = ord.BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_Old__c = ord.Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_Old__c = ord.BMO_SR__c ;
            OrdDiff.BSB_Number_Old__c = ord.BSB_Number__c ;
            OrdDiff.Buyer_Old__c = ord.Buyer__c ;
            OrdDiff.BuyerSAPId_Old__c = ord.BuyerSAPId__c ;
            OrdDiff.CC_No_Old__c = ord.CC_No__c ;
            OrdDiff.Commission_Type_Old__c = ord.Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_Old__c = ord.Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_Old__c = ord.CompanyAuthorizedByid ;
            OrdDiff.Company_Authorized_Date_Old__c = ord.CompanyAuthorizedDate ;
            OrdDiff.Company_Registration_No_Old__c = ord.Company_Registration_No__c ;
            OrdDiff.Contact_Name_Old__c = ord.Contact_Name__c ;
            
            OrdDiff.Contract_Type_Old__c = ord.Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_Old__c = ord.Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_Old__c = ord.Contract_Owner__c ;
            OrdDiff.Country_Scope_Old__c = ord.Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_Old__c = ord.CustomerAuthorizedByid ;
            OrdDiff.Customer_Authorized_Date_Old__c = ord.CustomerAuthorizedDate ;
            OrdDiff.Customer_Business_Scale_Old__c = ord.Customer_Business_Scale__c ;
            OrdDiff.Customer_country_Old__c = ord.Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_Old__c = ord.delivery_note_CI__c ;
            OrdDiff.Description_Old__c = ord.Description ;
            OrdDiff.Destination_Country_Old__c = ord.Destination_Country__c ;
            OrdDiff.Destination_Old__c = ord.Destination__c ;
            OrdDiff.Destination_Port_Old__c = ord.Destination_Port__c ;
            OrdDiff.Email_Old__c = ord.Email__c ;
            OrdDiff.Distribution_channel_Old__c = ord.Distribution_channel__c ;
            OrdDiff.Emergency_level_Old__c = ord.Emergency_level__c ;
            OrdDiff.Factory_WH_Old__c = ord.Factory__c ;
            OrdDiff.Fax_Old__c = ord.Fax__c ;
            OrdDiff.GST_Classification_Region_Old__c = ord.GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_Old__c = ord.IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_Old__c = ord.Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_Old__c = ord.ISTBD__c ;
            OrdDiff.Ledger_Name_Old__c = ord.Ledger_Name__c ;
            OrdDiff.Lock_Old__c = ord.Lock__c ;
            OrdDiff.MaterielNo_Old__c = ord.MaterielNo__c ;
            OrdDiff.MaxRowNo_Old__c = ord.MaxRowNo__c ;
            OrdDiff.Normal_Old__c = ord.Normal__c ;
            OrdDiff.OA_Emergency_level_Old__c = ord.OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_Old__c = ord.OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_Old__c = ord.OA_Operate_Type__c ;
            OrdDiff.Operate_Type_Old__c = ord.Operate_Type__c ;
            OrdDiff.Opportunity_Old__c = ord.Opportunity__c ;
            OrdDiff.Order_Amount_Old__c = ord.TotalAmount ;
            OrdDiff.Order_Currency_Old__c = ord.CurrencyIsoCode ;
            OrdDiff.Order_End_Date_Old__c = ord.EndDate ;
            OrdDiff.Order_Name_Old__c = ord.Name ;
            OrdDiff.Order_Reference_Number_Old__c = ord.OrderReferenceNumber ;
            OrdDiff.Order_Start_Date_Old__c = ord.EffectiveDate ;
            OrdDiff.Original_Order_Old__c = ord.OriginalOrderid ;
            OrdDiff.Other_Old__c = ord.Other__c ;
            OrdDiff.Payment_Term_Description_Old__c = ord.Payment_Term_Description__c ;
            OrdDiff.Phone_Old__c = ord.Phone__c ;
            OrdDiff.PMC_confirm_Old__c = ord.PMC_confirm__c ;
            OrdDiff.PO_Date_Old__c = ord.PODate ;
            OrdDiff.PO_Number_Old__c = ord.PONumber ;
            OrdDiff.Previous_Amendment_Generation_Date_Old__c = ord.Previous_Amendment_Generation_Date__c ;
            OrdDiff.Product_Group_Old__c = ord.Product_Group__c ;
            OrdDiff.Progress_Remarks_Old__c = ord.Progress_Remarks__c ;
            OrdDiff.Quote_Old__c = ord.Quoteid ;
            OrdDiff.Reduction_Order_Old__c = ord.IsReductionOrder ;
            OrdDiff.Region_Old__c = ord.Region__c ;
            OrdDiff.Requested_supplier_Old__c = ord.Requested_supplier__c ;
            OrdDiff.Routing_Number_ABA_Old__c = ord.Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_Old__c = ord.Sales_Dept__c ;
            OrdDiff.Sales_Group_Old__c = ord.Sales_Group__c ;
            OrdDiff.Sales_Org_Old__c = ord.Sales_Org__c ;
            OrdDiff.Sales_Region_Old__c = ord.Sales_Region__c ;
            OrdDiff.SAP_Company_Code_Old__c = ord.SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_Old__c = ord.SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_Old__c = ord.SAP_Describe__c ;
            OrdDiff.SAP_External_ID_Old__c = ord.SAP_External_ID__c ;
            OrdDiff.SAP_Factory_Old__c = ord.SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_Old__c = ord.SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_Old__c = ord.SAP_Project_No__c ;
            OrdDiff.SAP_Region_Old__c = ord.SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_Old__c = ord.SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_Old__c = ord.SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_Old__c = ord.SAP_User_ID__c ;
            OrdDiff.SC_Old__c = ord.SC_No__c ;
            OrdDiff.Search_Old__c = ord.Search__c ;
            OrdDiff.SELLER_Old__c = ord.SELLER__c ;
            OrdDiff.SEQ_Old__c = ord.SEQ__c ;
            OrdDiff.Ship_To_Contact_Old__c = ord.ShipToContactid ;
            OrdDiff.Shipping_type_Old__c = ord.Shipping_type__c ;
            OrdDiff.Special_Approvals_Old__c = ord.Special_Approvals__c ;
            OrdDiff.Special_Requirements_Old__c = ord.Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_Old__c     = ord.SPECIAL_TERMS__c ;
            OrdDiff.Special_Old__c = ord.Special__c ;
            OrdDiff.Stage_Old__c = ord.Stage__c ;
            OrdDiff.Status_Old__c = ord.Status ;
            OrdDiff.Street_Room_Number_Old__c = ord.Street_Room_Number__c ;
            OrdDiff.Subject_Group_Old__c = ord.Subject_Group__c ;
            OrdDiff.Supply_By_Old__c = ord.Supply_By__c ;
            OrdDiff.SWIFT_Code_Old__c = ord.SWIFT_Code__c ;
            OrdDiff.Tax_Old__c = ord.Tax__c ;
            OrdDiff.Tax_No_Old__c = ord.Tax_No__c ;
            OrdDiff.Tax_Rate_Old__c = ord.Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_Old__c = ord.Taxpayer_Identification_No__c ;
            OrdDiff.Title_Old__c = ord.Title__c ;
            OrdDiff.Total_MW_Old__c = ord.Total_MW__c ;
            OrdDiff.Total_Price_Old__c = ord.Total_Price__c ;
            OrdDiff.Total_Price_Tax_Old__c = ord.Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_Old__c = ord.Total_Quantity__c ;
            OrdDiff.Trade_term_Old__c = ord.Trade_term__c ;
            OrdDiff.Transit_Fees_Old__c  = ord.Transit_Fees__c  ;
            OrdDiff.Update_Time_1st_Old__c = ord.Update_Time_1st__c ;
            OrdDiff.VAT_NO_Old__c = ord.VAT_NO__c ;
            OrdDiff.Warranty_Insurance_Old__c = ord.Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_Old__c = ord.Warranty_On_Material_and_Workmanship__c ;
            
            
            insert OrdDiff;
            system.debug('插入业务机会下的产品差异数据');
            
            Integer falg =0;
            List<OrderItem_Difference__c> OrderItemDiffLst = new  List<OrderItem_Difference__c>();
            for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                falg = 0;
                for(OrderItem OrderItemOld : orderlineLst){
                    system.debug('OrderItemOld.Id:'+OrderItemOld.Id);
                    system.debug('OrderItemNew.ID__c:'+OrderItemNew.ID__c);
                    if(String.valueOf(OrderItemOld.Id) == OrderItemNew.ID__c){
                        system.debug('产品配对');
                        OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                        OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                        OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                        OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_New__c =OrderItemNew.Product2__c;
                        OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                        OrderLinDiff.SAP_Product_Materiel_No_New__c =  OrderItemNew.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                        OrderLinDiff.total_Price_New__c =  OrderItemNew.total_Price__c;
                        OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                        OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c; 
                        OrderLinDiff.total_Price2_New__c =OrderItemNew.TotalPrice__c;
                        OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                        
                        OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product2.name;
                        OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_Old__c = OrderItemOld.Product2id;
                        OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity;
                        OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                        OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                        OrderLinDiff.total_Price2_Old__c = OrderItemOld.TotalPrice;
                        OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                        OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice;
                        OrderItemDiffLst.add(OrderLinDiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_New__c = OrderItemNew.Product2__c;
                    OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                    OrderLinDiff.SAP_Product_Materiel_No_New__c = OrderItemNew.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW__c;
                    OrderLinDiff.total_Price_New__c = OrderItemNew.total_Price__c;
                    OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                    OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c;
                    OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                    OrderLinDiff.total_Price2_New__c =OrderItemNew.TotalPrice__c;
                    OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                    OrderItemDiffLst.add(OrderLinDiff);
                }
            }
            for(OrderItem OrderItemOld : orderlineLst){
                falg = 0;
                for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                    if(String.valueOf(OrderItemOld.Id) == OrderItemNew.ID__c){
                        falg=1;    
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product2.name;
                    
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_Old__c = OrderItemOld.Product2id;
                    OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity;
                    OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                    OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                    OrderLinDiff.total_Price2_Old__c = OrderItemOld.TotalPrice;
                    OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                    OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice;
                    OrderItemDiffLst.add(OrderLinDiff);
                    
                }
            }
            if(OrderItemDiffLst.size()>0)insert OrderItemDiffLst;
            
            //插入业务机会下的付款方式数据
            List<PaymentDifference__c> paydiffLst = new  List<PaymentDifference__c>();
            
            for(Amendment_Payment__c payNew : APayLst){
                falg = 0;
                for(Payment__c payOld : payLst){
                    if(payNew.ID__c == payOld.Id){
                        system.debug('付款配对');
                        PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Order_Differences__c = OrdDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        paydiff.Days_New__c = payNew.Days__c;
                        paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                        paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                        paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                        paydiff.Percentage_New__c  = payNew.Percentage__c;
                        paydiff.Days_Old__c = payOld.Days__c;
                        paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                        paydiff.PaymentDescription_old__c=payOld.PaymentDescription__c;
                        paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
                        paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
                        paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
                        paydiff.Percentage_Old__c =payOld.Percentage__c;
                        paydiffLst.add(paydiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    system.debug('付款新建配对');
                    PaymentDifference__c paydiff =new PaymentDifference__c();
                    paydiff.Order_Differences__c = OrdDiff.Id;
                    paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    paydiff.Days_New__c = payNew.Days__c;
                    paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                    paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                    paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                    paydiff.Percentage_New__c = payNew.Percentage__c;
                    paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                    paydiffLst.add(paydiff);
                }
            }
            /*
for(Payment__c payOld : payLst){
falg = 0;
for(Amendment_Payment__c payNew : APayLst){
if(payNew.ID__c == payOld.Id){
falg=1;
}
}
if(falg ==0){
system.debug('付款被删除了');
PaymentDifference__c paydiff =new PaymentDifference__c();
paydiff.Order_Differences__c = OrdDiff.Id;
paydiff.Days_Old__c = payOld.Days__c;
paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
paydiff.Percentage_Old__c =payOld.Percentage__c;
paydiffLst.add(paydiff);
}
}
*/
            system.debug(paydiffLst.size());
            if(paydiffLst.size()>0)insert paydiffLst;
            
        }
        
        
        
        if(AordLst.size()>1){
            system.debug('数量为1');
            Aord.ApprovalNumbers__c=AordLst.size();
            List<Amendment_Payment__c> APayLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                              'Where Amendment_Purchase_Agreement__c =:id2');
            system.debug('APayLst数量为:'+APayLst.size());
            List<Amendment_Order_Product__c> AOPLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                                   'Where OriginalOrderItem__c =:id2 order by CreatedDate DESC  ');
            system.debug('AOPLst数量为:'+AOPLst.size());
            
            Order_Differences__c  OrdDiff = new Order_Differences__c();
            OrdDiff.Amendment_Purchase_Agreement__c = Aorderid;
            OrdDiff.Destination_Country_New__c = AordLst[0].Destination_Country__c;
            OrdDiff.SELLER_New__c =AordLst[0].SELLER__c;
            OrdDiff.Total_MW_New__c = AordLst[0].Total_MW2__c;
            OrdDiff.Total_Price_New__c = AordLst[0].Total_Price__c ;
            OrdDiff.Total_Quantity_New__c =  AordLst[0].Total_Quantity__c;
            OrdDiff.Trade_term_New__c = AordLst[0].Trade_term__c ;
            OrdDiff.Commission_New__c = AordLst[0].Commission__c ;
            OrdDiff.zongjia_New__c = AordLst[0].Totalprice__c ;
            OrdDiff.Account_Allocation_Group_New__c = AordLst[0].Account_Allocation_Group__c ;
            OrdDiff.Account_Country_New__c = AordLst[0].Account_Country__c ;
            OrdDiff.Account_Group_New__c = AordLst[0].Account_Group__c ;
            OrdDiff.Account_Id_New__c = AordLst[0].Account_Id__c ;
            OrdDiff.Account_Holder_New__c = AordLst[0].Account_Holder__c ;
            OrdDiff.Account_Name_New__c = AordLst[0].Account__c ;
            OrdDiff.Account_Number_New__c = AordLst[0].AccountNumber__c ;
            OrdDiff.Account_Phone_New__c = AordLst[0].Account_Phone__c ;
            OrdDiff.Account_Title_New__c = AordLst[0].Account_Title__c ;
            OrdDiff.Activated_By_New__c = AordLst[0].ActivatedBy__c ;
            OrdDiff.Activated_Date_New__c = AordLst[0].ActivatedDate__c ;
            OrdDiff.Actual_Sales_Name_New__c = AordLst[0].Actual_Sales_Name__c ;
            OrdDiff.Amendment_Point_New__c = AordLst[0].Amendment_Point__c ;
            OrdDiff.Amendment_Review_status_New__c  = AordLst[0].Amendment_Review_status__c ;
            OrdDiff.Amendment1_New__c = AordLst[0].Amendment1__c ;
            OrdDiff.Amendment2_New__c = AordLst[0].Amendment2__c ;
            OrdDiff.Amendment3_New__c = AordLst[0].Amendment3__c ;
            OrdDiff.Amendment4_New__c = AordLst[0].Amendment4__c ;
            OrdDiff.Amendment5_New__c = AordLst[0].Amendment5__c ;
            OrdDiff.Amendment6_New__c = AordLst[0].Amendment6__c ;
            OrdDiff.Amendment7_New__c = AordLst[0].Amendment7__c ;
            OrdDiff.Applicant_Direct_Superior_New__c = AordLst[0].Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers__c = Aord.ApprovalNumbers__c ;
            OrdDiff.ApprovalNumbers_New__c = AordLst[0].ApprovalNumbers__c ;
            OrdDiff.Approved_count_New__c = AordLst[0].Approved_count__c ;
            OrdDiff.Authorized_Representative_New__c = AordLst[0].Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_New__c = AordLst[0].Avg_Price_W__c ;
            OrdDiff.Bank_Account_New__c = AordLst[0].Bank_Account__c ;
            OrdDiff.Bank_City_New__c = AordLst[0].Bank_City__c ;
            OrdDiff.Bank_Code_New__c = AordLst[0].Bank_Code__c ;
            OrdDiff.Bank_Country_New__c = AordLst[0].Bank_Country__c ;
            OrdDiff.Bank_Information_Content_New__c = AordLst[0].Bank_Information_Content__c ;
            OrdDiff.Bank_Name_New__c = AordLst[0].Bank_Name__c ;
            OrdDiff.Bank_Region_New__c = AordLst[0].Bank_Region__c ;
            OrdDiff.Bank_Street_New__c = AordLst[0].Bank_Street__c ;
            OrdDiff.Billing_Address_New__c = AordLst[0].Billing_Address__c ;
            OrdDiff.BillingCity_New__c = AordLst[0].BillingCity__c ;
            OrdDiff.BillingCountry_New__c = AordLst[0].BillingCountry__c ;
            OrdDiff.BillingPostalCode_New__c = AordLst[0].BillingPostalCode__c ;
            OrdDiff.BillingState_New__c = AordLst[0].BillingState__c ;
            OrdDiff.BillingStreet_New__c = AordLst[0].BillingStreet__c ;
            OrdDiff.BMO_SH_New__c = AordLst[0].BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_New__c = AordLst[0].Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_New__c = AordLst[0].BMO_SR__c ;
            OrdDiff.BSB_Number_New__c = AordLst[0].BSB_Number__c ;
            OrdDiff.Buyer_New__c = AordLst[0].Buyer__c ;
            OrdDiff.Buyer_Name_New__c = AordLst[0].Buyer_Name__c ;
            OrdDiff.BuyerSAPId_New__c = AordLst[0].BuyerSAPId__c ;
            OrdDiff.CC_No_New__c = AordLst[0].CC_No__c ;
            OrdDiff.Commission_Type_New__c = AordLst[0].Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_New__c = AordLst[0].Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_New__c = AordLst[0].CompanyAuthorizedBy__c ;
            OrdDiff.Company_Authorized_Date_New__c = AordLst[0].CompanyAuthorizedDate__c ;
            OrdDiff.Company_Registration_No_New__c = AordLst[0].Company_Registration_No__c ;
            OrdDiff.Contact_Name_New__c = AordLst[0].Contact_Name__c ;
            OrdDiff.Contract_End_Date_New__c = AordLst[0].ContractEndDate__c ;
            OrdDiff.Contract_Name_New__c = AordLst[0].ContractName__c ;
            OrdDiff.Contract_Number_New__c = AordLst[0].Contract__c ;
            OrdDiff.Contract_Type_New__c = AordLst[0].Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_New__c = AordLst[0].Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_New__c = AordLst[0].Contract_Owner__c ;
            OrdDiff.Country_Scope_New__c = AordLst[0].Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_New__c = AordLst[0].CustomerAuthorizedBy__c ;
            OrdDiff.Customer_Authorized_Date_New__c = AordLst[0].CustomerAuthorizedDate__c ;
            OrdDiff.Customer_Business_Scale_New__c = AordLst[0].Customer_Business_Scale__c ;
            OrdDiff.Customer_country_New__c = AordLst[0].Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_New__c = AordLst[0].delivery_note_CI__c ;
            OrdDiff.Description_New__c = AordLst[0].Description__c ;
            OrdDiff.Destination_Country_New__c = AordLst[0].Destination_Country__c ;
            OrdDiff.Destination_New__c = AordLst[0].Destination__c ;
            OrdDiff.Destination_Port_New__c = AordLst[0].Destination_Port__c ;
            OrdDiff.Email_New__c = AordLst[0].Email__c ;
            OrdDiff.Distribution_channel_New__c = AordLst[0].Distribution_channel__c ;
            OrdDiff.Emergency_level_New__c = AordLst[0].Emergency_level__c ;
            OrdDiff.Factory_WH_New__c = AordLst[0].Factory__c ;
            OrdDiff.Fax_New__c = AordLst[0].Fax__c ;
            OrdDiff.GST_Classification_Region_New__c = AordLst[0].GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_New__c = AordLst[0].IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_New__c = AordLst[0].Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_New__c = AordLst[0].ISTBD__c ;
            OrdDiff.Ledger_Name_New__c = AordLst[0].Ledger_Name__c ;
            OrdDiff.Lock_New__c = AordLst[0].Lock__c ;
            OrdDiff.MaterielNo_New__c = AordLst[0].MaterielNo__c ;
            OrdDiff.MaxRowNo_New__c = AordLst[0].MaxRowNo__c ;
            OrdDiff.Normal_New__c = AordLst[0].Normal__c ;
            OrdDiff.OA_Emergency_level_New__c = AordLst[0].OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_New__c = AordLst[0].OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_New__c = AordLst[0].OA_Operate_Type__c ;
            OrdDiff.Operate_Type_New__c = AordLst[0].Operate_Type__c ;
            OrdDiff.Opportunity_New__c = AordLst[0].Opportunity__c ;
            OrdDiff.Order_Amount_New__c = AordLst[0].TotalAmount__c ;
            OrdDiff.Order_Currency_New__c = AordLst[0].CurrencyIsoCode__c ;
            OrdDiff.Order_End_Date_New__c = AordLst[0].EndDate__c ;
            OrdDiff.Order_Name_New__c = AordLst[0].Name__c ;
            OrdDiff.Order_Product_New__c = AordLst[0].Order_Product__c ;
            OrdDiff.Order_Reference_Number_New__c = AordLst[0].OrderReferenceNumber__c ;
            OrdDiff.Order_Start_Date_New__c = AordLst[0].EffectiveDate__c ;
            OrdDiff.Original_Order_New__c = AordLst[0].OriginalOrder__c ;
            OrdDiff.Other_New__c = AordLst[0].Other__c ;
            OrdDiff.Payment_Term_Description_New__c = AordLst[0].Payment_Term_Description__c ;
            OrdDiff.Phone_New__c = AordLst[0].Phone__c ;
            OrdDiff.PMC_confirm_New__c = AordLst[0].PMC_confirm__c ;
            OrdDiff.PO_Date_New__c = AordLst[0].PODate__c ;
            OrdDiff.PO_Number_New__c = AordLst[0].PONumber__c ;
            OrdDiff.Previous_Amendment_Generation_Date_New__c = AordLst[0].Previous_Amendment_Generation_Date__c ;
            OrdDiff.Print_Contract_Date_New__c = AordLst[0].Print_Contract_Date__c ;
            OrdDiff.Product_Group_New__c = AordLst[0].Product_Group__c ;
            OrdDiff.Progress_Remarks_New__c = AordLst[0].Progress_Remarks__c ;
            OrdDiff.Purchase_Type_New__c = AordLst[0].Purchase_Type__c ;
            OrdDiff.Quote_New__c = AordLst[0].Quote__c ;
            OrdDiff.Reduction_Order_New__c = AordLst[0].IsReductionOrder__c ;
            OrdDiff.Region_New__c = AordLst[0].Region__c ;
            OrdDiff.Requested_supplier_New__c = AordLst[0].Requested_supplier__c ;
            OrdDiff.Review_status_New__c = AordLst[0].Review_status__c ;
            OrdDiff.Routing_Number_ABA_New__c = AordLst[0].Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_New__c = AordLst[0].Sales_Dept__c ;
            OrdDiff.Sales_Group_New__c = AordLst[0].Sales_Group__c ;
            OrdDiff.Sales_Org_New__c = AordLst[0].Sales_Org__c ;
            OrdDiff.Sales_Region_New__c = AordLst[0].Sales_Region__c ;
            OrdDiff.SAP_Company_Code_New__c = AordLst[0].SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_New__c = AordLst[0].SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_New__c = AordLst[0].SAP_Describe__c ;
            OrdDiff.SAP_External_ID_New__c = AordLst[0].SAP_External_ID__c ;
            OrdDiff.SAP_Factory_New__c = AordLst[0].SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_New__c = AordLst[0].SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_New__c = AordLst[0].SAP_Project_No__c ;
            OrdDiff.SAP_Region_New__c = AordLst[0].SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_New__c = AordLst[0].SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_New__c = AordLst[0].SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_New__c = AordLst[0].SAP_User_ID__c ;
            OrdDiff.SC_New__c = AordLst[0].SC_No__c ;
            OrdDiff.Search_New__c = AordLst[0].Search__c ;
            OrdDiff.Seller_Address_New__c = AordLst[0].Seller_Address__c ;
            OrdDiff.SELLER_New__c = AordLst[0].SELLER__c ;
            OrdDiff.Seller_Name_New__c = AordLst[0].Seller_Name__c ;
            OrdDiff.SEQ_New__c = AordLst[0].SEQ__c ;
            OrdDiff.Ship_To_Contact_New__c = AordLst[0].ShipToContact__c ;
            OrdDiff.Shipping_type_New__c = AordLst[0].Shipping_type__c ;
            OrdDiff.Special_Approvals_New__c = AordLst[0].Special_Approvals__c ;
            OrdDiff.Special_Requirements_New__c = AordLst[0].Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_New__c     = AordLst[0].SPECIAL_TERMS__c ;
            OrdDiff.Special_New__c = AordLst[0].Special__c ;
            OrdDiff.Stage_New__c = AordLst[0].Stage__c ;
            OrdDiff.Status_New__c = AordLst[0].Status__c ;
            OrdDiff.Street_Room_Number_New__c = AordLst[0].Street_Room_Number__c ;
            OrdDiff.Subject_Group_New__c = AordLst[0].Subject_Group__c ;
            OrdDiff.Supply_By_New__c = AordLst[0].Supply_By__c ;
            OrdDiff.SWIFT_Code_New__c = AordLst[0].SWIFT_Code__c ;
            OrdDiff.Tax_New__c = AordLst[0].Tax__c ;
            OrdDiff.Tax_No_New__c = AordLst[0].Tax_No__c ;
            OrdDiff.Tax_Rate_New__c = AordLst[0].Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_New__c = AordLst[0].Taxpayer_Identification_No__c ;
            OrdDiff.Title_New__c = AordLst[0].Title__c ;
            OrdDiff.Total_MW_New__c = AordLst[0].Total_MW2__c ;
            OrdDiff.Total_Price_New__c = AordLst[0].Total_Price__c ;
            OrdDiff.Total_Price_Tax_New__c = AordLst[0].Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_New__c = AordLst[0].Total_Quantity__c ;
            OrdDiff.Trade_term_New__c = AordLst[0].Trade_term__c ;
            OrdDiff.Transit_Fees_New__c  = AordLst[0].Transit_Fees__c  ;
            OrdDiff.Update_Time_1st_New__c = AordLst[0].Update_Time_1st__c ;
            OrdDiff.VAT_NO_New__c = AordLst[0].VAT_NO__c ;
            OrdDiff.Warranty_Insurance_New__c = AordLst[0].Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_New__c = AordLst[0].Warranty_On_Material_and_Workmanship__c ;
            OrdDiff.Discount_New__c = AordLst[0].Discount__c ; 
            OrdDiff.Rebate_New__c = AordLst[0].Rebate__c ; 
            OrdDiff.Discount_old__c = AordLst[1].Discount__c ;
            OrdDiff.Rebate_old__c = AordLst[1].Rebate__c ;
            
            OrdDiff.Destination_Country_Old__c = AordLst[1].Destination_Country__c ;
            OrdDiff.SELLER_Old__c = AordLst[1].SELLER__c;
            
            OrdDiff.Total_Price_Old__c = AordLst[1].Total_Price__c;
            OrdDiff.Total_Quantity_Old__c = AordLst[1].Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = AordLst[1].Trade_term__c;
            OrdDiff.Commission_Old__c = AordLst[1].Commission__c;
            OrdDiff.Destination_Country_Old__c = AordLst[1].Destination_Country__c;
            OrdDiff.SELLER_Old__c =AordLst[1].SELLER__c;
            OrdDiff.Total_MW_Old__c = AordLst[1].Total_MW2__c;
            OrdDiff.Total_Price_Old__c = AordLst[1].Total_Price__c ;
            OrdDiff.Total_Quantity_Old__c =  AordLst[1].Total_Quantity__c;
            OrdDiff.Trade_term_Old__c = AordLst[1].Trade_term__c ;
            OrdDiff.Commission_Old__c = AordLst[1].Commission__c ;
            OrdDiff.zongjia_Old__c = AordLst[1].Total_Price__c ;
            OrdDiff.Account_Allocation_Group_Old__c = AordLst[1].Account_Allocation_Group__c ;
            OrdDiff.Account_Country_Old__c = AordLst[1].Account_Country__c ;
            OrdDiff.Account_Group_Old__c = AordLst[1].Account_Group__c ;
            OrdDiff.Account_Id_Old__c = AordLst[1].Account_Id__c ;
            OrdDiff.Account_Holder_Old__c = AordLst[1].Account_Holder__c ;
            OrdDiff.Account_Name_Old__c = AordLst[1].Account__c ;
            OrdDiff.Account_Phone_Old__c = AordLst[1].Account_Phone__c ;
            OrdDiff.Account_Title_Old__c = AordLst[1].Account_Title__c ;
            OrdDiff.Activated_By_Old__c = AordLst[1].ActivatedBy__c ;
            OrdDiff.Activated_Date_Old__c = AordLst[1].ActivatedDate__c ;
            OrdDiff.Actual_Sales_Name_Old__c = AordLst[1].Actual_Sales_Name__c ;
            
            OrdDiff.Applicant_Direct_Superior_Old__c = AordLst[1].Applicant_Direct_Superior__c ;
            OrdDiff.ApprovalNumbers_Old__c = AordLst[1].ApprovalNumbers__c ;
            OrdDiff.Authorized_Representative_Old__c = AordLst[1].Authorized_Representative__c ;
            OrdDiff.Avg_Price_W_Old__c = AordLst[1].Avg_Price_W__c ;
            OrdDiff.Bank_Account_Old__c = AordLst[1].Bank_Account__c ;
            OrdDiff.Bank_City_Old__c = AordLst[1].Bank_City__c ;
            OrdDiff.Bank_Code_Old__c = AordLst[1].Bank_Code__c ;
            OrdDiff.Bank_Country_Old__c = AordLst[1].Bank_Country__c ;
            OrdDiff.Bank_Information_Content_Old__c = AordLst[1].Bank_Information_Content__c ;
            OrdDiff.Bank_Name_Old__c = AordLst[1].Bank_Name__c ;
            OrdDiff.Bank_Region_Old__c = AordLst[1].Bank_Region__c ;
            OrdDiff.Bank_Street_Old__c = AordLst[1].Bank_Street__c ;
            OrdDiff.BillingCity_Old__c = AordLst[1].BillingCity__c ;
            OrdDiff.BillingCountry_Old__c = AordLst[1].BillingCountry__c ;
            OrdDiff.BillingPostalCode_Old__c = AordLst[1].BillingPostalCode__c ;
            OrdDiff.BillingState_Old__c = AordLst[1].BillingState__c ;
            OrdDiff.BillingStreet_Old__c = AordLst[1].BillingStreet__c ;
            OrdDiff.BMO_SH_Old__c = AordLst[1].BMO_SH_SR__c ;
            OrdDiff.BMO_SH_SAP_User_Id_Old__c = AordLst[1].Account_Owner_Sap_Id__c ;
            OrdDiff.BMO_SR_Old__c = AordLst[1].BMO_SR__c ;
            OrdDiff.BSB_Number_Old__c = AordLst[1].BSB_Number__c ;
            OrdDiff.Buyer_Old__c = AordLst[1].Buyer__c ;
            OrdDiff.BuyerSAPId_Old__c = AordLst[1].BuyerSAPId__c ;
            OrdDiff.CC_No_Old__c = AordLst[1].CC_No__c ;
            OrdDiff.Commission_Type_Old__c = AordLst[1].Commission_Type__c ;
            OrdDiff.Commission_Value_sync_to_SAP_Old__c = AordLst[1].Commission_Value_sync_to_SAP__c ;
            OrdDiff.Company_Authorized_By_Old__c = AordLst[1].CompanyAuthorizedBy__c ;
            OrdDiff.Company_Authorized_Date_Old__c = AordLst[1].CompanyAuthorizedDate__c ;
            OrdDiff.Company_Registration_No_Old__c = AordLst[1].Company_Registration_No__c ;
            OrdDiff.Contact_Name_Old__c = AordLst[1].Contact_Name__c ;
            
            OrdDiff.Contract_Type_Old__c = AordLst[1].Contract_Type__c ;
            OrdDiff.Contract_PO_PI_No_Old__c = AordLst[1].Contract_No__c ;
            OrdDiff.Contract_PO_PI_Owner_Old__c = AordLst[1].Contract_Owner__c ;
            OrdDiff.Country_Scope_Old__c = AordLst[1].Country_Scope__c ;
            OrdDiff.Customer_Authorized_By_Old__c = AordLst[1].CustomerAuthorizedBy__C ;
            OrdDiff.Customer_Authorized_Date_Old__c = AordLst[1].CustomerAuthorizedDate__C ;
            OrdDiff.Customer_Business_Scale_Old__c = AordLst[1].Customer_Business_Scale__c ;
            OrdDiff.Customer_country_Old__c = AordLst[1].Customer_country__c ;
            OrdDiff.Customer_Order_Reference_PO_Old__c = AordLst[1].delivery_note_CI__c ;
            OrdDiff.Description_Old__c = AordLst[1].Description__c ;
            OrdDiff.Destination_Country_Old__c = AordLst[1].Destination_Country__c ;
            OrdDiff.Destination_Old__c = AordLst[1].Destination__c ;
            OrdDiff.Destination_Port_Old__c = AordLst[1].Destination_Port__c ;
            OrdDiff.Email_Old__c = AordLst[1].Email__c ;
            OrdDiff.Distribution_channel_Old__c = AordLst[1].Distribution_channel__c ;
            OrdDiff.Emergency_level_Old__c = AordLst[1].Emergency_level__c ;
            OrdDiff.Factory_WH_Old__c = AordLst[1].Factory__c ;
            OrdDiff.Fax_Old__c = AordLst[1].Fax__c ;
            OrdDiff.GST_Classification_Region_Old__c = AordLst[1].GST_Classification_Region__c ;
            OrdDiff.IBAN_Code_Old__c = AordLst[1].IBAN_Code__c ;
            OrdDiff.Intercompany_Seller_POs_Old__c = AordLst[1].Intercompany_Seller_POs__c ;
            OrdDiff.ISTBD_Old__c = AordLst[1].ISTBD__c ;
            OrdDiff.Ledger_Name_Old__c = AordLst[1].Ledger_Name__c ;
            OrdDiff.Lock_Old__c = AordLst[1].Lock__c ;
            OrdDiff.MaterielNo_Old__c = AordLst[1].MaterielNo__c ;
            OrdDiff.MaxRowNo_Old__c = AordLst[1].MaxRowNo__c ;
            OrdDiff.Normal_Old__c = AordLst[1].Normal__c ;
            OrdDiff.OA_Emergency_level_Old__c = AordLst[1].OA_Emergency_level__c ;
            OrdDiff.OA_External_ID_Old__c = AordLst[1].OA_External_ID__c ;
            OrdDiff.OA_Operate_Type_Old__c = AordLst[1].OA_Operate_Type__c ;
            OrdDiff.Operate_Type_Old__c = AordLst[1].Operate_Type__c ;
            OrdDiff.Opportunity_Old__c = AordLst[1].Opportunity__c ;
            OrdDiff.Order_Amount_Old__c = AordLst[1].TotalAmount__c ;
            OrdDiff.Order_Currency_Old__c = AordLst[1].CurrencyIsoCode ;
            OrdDiff.Order_End_Date_Old__c = AordLst[1].EndDate__c ;
            OrdDiff.Order_Name_Old__c = AordLst[1].Name ;
            OrdDiff.Order_Reference_Number_Old__c = AordLst[1].OrderReferenceNumber__c ;
            OrdDiff.Order_Start_Date_Old__c = AordLst[1].EffectiveDate__c ;
            OrdDiff.Original_Order_Old__c = AordLst[1].OriginalOrder__c ;
            OrdDiff.Other_Old__c = AordLst[1].Other__c ;
            OrdDiff.Payment_Term_Description_Old__c = AordLst[1].Payment_Term_Description__c ;
            OrdDiff.Phone_Old__c = AordLst[1].Phone__c ;
            OrdDiff.PMC_confirm_Old__c = AordLst[1].PMC_confirm__c ;
            OrdDiff.PO_Date_Old__c = AordLst[1].PODate__c ;
            OrdDiff.PO_Number_Old__c = AordLst[1].PONumber__c ;
            OrdDiff.Previous_Amendment_Generation_Date_Old__c = AordLst[1].Previous_Amendment_Generation_Date__c ;
            OrdDiff.Product_Group_Old__c = AordLst[1].Product_Group__c ;
            OrdDiff.Progress_Remarks_Old__c = AordLst[1].Progress_Remarks__c ;
            OrdDiff.Quote_Old__c = AordLst[1].Quote__c ;
            OrdDiff.Reduction_Order_Old__c = AordLst[1].IsReductionOrder__c ;
            OrdDiff.Region_Old__c = AordLst[1].Region__c ;
            OrdDiff.Requested_supplier_Old__c = AordLst[1].Requested_supplier__c ;
            OrdDiff.Routing_Number_ABA_Old__c = AordLst[1].Routing_Number_ABA__c ;
            OrdDiff.Sales_Dept_Old__c = AordLst[1].Sales_Dept__c ;
            OrdDiff.Sales_Group_Old__c = AordLst[1].Sales_Group__c ;
            OrdDiff.Sales_Org_Old__c = AordLst[1].Sales_Org__c ;
            OrdDiff.Sales_Region_Old__c = AordLst[1].Sales_Region__c ;
            OrdDiff.SAP_Company_Code_Old__c = AordLst[1].SAP_Company_Code__c ;
            OrdDiff.SAP_Customer_PO_No_Old__c = AordLst[1].SAP_Customer_PO_No__c ;
            OrdDiff.SAP_Describe_Old__c = AordLst[1].SAP_Describe__c ;
            OrdDiff.SAP_External_ID_Old__c = AordLst[1].SAP_External_ID__c ;
            OrdDiff.SAP_Factory_Old__c = AordLst[1].SAP_Factory__c ;
            OrdDiff.SAP_Order_ID_Old__c = AordLst[1].SAP_Order_ID__c ;
            OrdDiff.SAP_Project_No_Old__c = AordLst[1].SAP_Project_No__c ;
            OrdDiff.SAP_Region_Old__c = AordLst[1].SAP_Region__c ;
            OrdDiff.SAP_Sales_Org_Old__c = AordLst[1].SAP_Sales_Org__c ;
            OrdDiff.SAP_Shipping_Old__c = AordLst[1].SAP_Shipping__c ;
            OrdDiff.SAP_User_ID_Old__c = AordLst[1].SAP_User_ID__c ;
            OrdDiff.SC_Old__c = AordLst[1].SC_No__c ;
            OrdDiff.Search_Old__c = AordLst[1].Search__c ;
            OrdDiff.SELLER_Old__c = AordLst[1].SELLER__c ;
            OrdDiff.SEQ_Old__c = AordLst[1].SEQ__c ;
            OrdDiff.Ship_To_Contact_Old__c = AordLst[1].ShipToContact__c ;
            OrdDiff.Shipping_type_Old__c = AordLst[1].Shipping_type__c ;
            OrdDiff.Special_Approvals_Old__c = AordLst[1].Special_Approvals__c ;
            OrdDiff.Special_Requirements_Old__c = AordLst[1].Special_Requirements__c ;
            OrdDiff.SPECIAL_TERMS_Old__c     = AordLst[1].SPECIAL_TERMS__c ;
            OrdDiff.Special_Old__c = AordLst[1].Special__c ;
            OrdDiff.Stage_Old__c = AordLst[1].Stage__c ;
            OrdDiff.Status_Old__c = AordLst[1].Status__C ;
            OrdDiff.Street_Room_Number_Old__c = AordLst[1].Street_Room_Number__c ;
            OrdDiff.Subject_Group_Old__c = AordLst[1].Subject_Group__c ;
            OrdDiff.Supply_By_Old__c = AordLst[1].Supply_By__c ;
            OrdDiff.SWIFT_Code_Old__c = AordLst[1].SWIFT_Code__c ;
            OrdDiff.Tax_Old__c = AordLst[1].Tax__c ;
            OrdDiff.Tax_No_Old__c = AordLst[1].Tax_No__c ;
            OrdDiff.Tax_Rate_Old__c = AordLst[1].Tax_Rate__c ;
            OrdDiff.Taxpayer_Identification_No_Old__c = AordLst[1].Taxpayer_Identification_No__c ;
            OrdDiff.Title_Old__c = AordLst[1].Title__c ;
            OrdDiff.Total_Price_Old__c = AordLst[1].Total_Price__c ;
            OrdDiff.Total_Price_Tax_Old__c = AordLst[1].Total_Price_Tax__c ;
            OrdDiff.Total_Quantity_Old__c = AordLst[1].Total_Quantity__c ;
            OrdDiff.Trade_term_Old__c = AordLst[1].Trade_term__c ;
            OrdDiff.Transit_Fees_Old__c  = AordLst[1].Transit_Fees__c  ;
            OrdDiff.Update_Time_1st_Old__c = AordLst[1].Update_Time_1st__c ;
            OrdDiff.VAT_NO_Old__c = AordLst[1].VAT_NO__c ;
            OrdDiff.Warranty_Insurance_Old__c = AordLst[1].Warranty_Insurance__c ;
            OrdDiff.Warranty_On_Material_and_Workmanship_Old__c = AordLst[1].Warranty_On_Material_and_Workmanship__c ;
            
            insert OrdDiff;
            id2=AordLst[1].id;
            system.debug('插入业务机会下的产品差异数据');
            List<Amendment_Order_Product__c> orderlineLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                                         'Where OriginalOrderItem__c =:id2');
            
            system.debug('orderlineLst数量为:'+orderlineLst.size());
            Integer falg =0;
            List<OrderItem_Difference__c> OrderItemDiffLst = new  List<OrderItem_Difference__c>();
            for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                falg = 0;
                for(Amendment_Order_Product__c OrderItemOld : orderlineLst){
                    system.debug('OrderItemOld.Id:'+OrderItemOld.Id);
                    system.debug('OrderItemNew.ID__c:'+OrderItemNew.ID__c);
                    if(OrderItemOld.ID__c== OrderItemNew.ID__c){
                        system.debug('产品配对');
                        OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                        OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                        OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                        OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_New__c =OrderItemNew.Product2__c;
                        OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                        OrderLinDiff.SAP_Product_Materiel_No_New__c =  OrderItemNew.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                        OrderLinDiff.total_Price_New__c =  OrderItemNew.total_Price__c;
                        OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                        OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c; 
                        OrderLinDiff.total_Price2_New__c =OrderItemNew.TotalPrice__c;
                        OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                        OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product_Name__c;
                        OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                        OrderLinDiff.Product_Old__c = OrderItemOld.Product2__c;
                        OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity__c;
                        OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                        OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                        OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                        OrderLinDiff.total_Price2_Old__c =OrderItemOld.TotalPrice__c;
                        OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                        OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice__c;
                        OrderItemDiffLst.add(OrderLinDiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Name =OrderItemNew.Product_Name__c;
                    OrderLinDiff.Guaranteed_Delivery_Date_New__c = OrderItemNew.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_New__c = OrderItemNew.Product2__c;
                    OrderLinDiff.Quantity_New__c = OrderItemNew.Quantity__c;
                    OrderLinDiff.SAP_Product_Materiel_No_New__c = OrderItemNew.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_New__c = OrderItemNew.Total_MW_Auto__c;
                    OrderLinDiff.total_Price_New__c = OrderItemNew.total_Price__c;
                    OrderLinDiff.Type_of_module_New__c = OrderItemNew.Type_of_module__c;
                    OrderLinDiff.UnitPrice_New__c = OrderItemNew.UnitPrice__c;
                    OrderLinDiff.Product_Name__c =OrderItemNew.Product_Name__c;
                    OrderItemDiffLst.add(OrderLinDiff);
                }
            }
            for(Amendment_Order_Product__c OrderItemOld : orderlineLst){
                falg = 0;
                for(Amendment_Order_Product__c OrderItemNew : AOPLst){
                    if(String.valueOf(OrderItemOld.Id) == OrderItemNew.ID__c){
                        falg=1;    
                    }
                }
                if(falg ==0){
                    OrderItem_Difference__c OrderLinDiff = new OrderItem_Difference__c();
                    OrderLinDiff.Order_Differences__c = OrdDiff.Id;
                    OrderLinDiff.Name =OrderItemOld.Product_Name__c;
                    OrderLinDiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    OrderLinDiff.Product_Name_Old__c =OrderItemOld.Product_Name__c;
                    OrderLinDiff.Guaranteed_Delivery_Date_Old__c = OrderItemOld.Guaranteed_Delivery_Date__c;
                    OrderLinDiff.Product_Old__c = OrderItemOld.Product2__c;
                    OrderLinDiff.Quantity_Old__c = OrderItemOld.Quantity__c;
                    OrderLinDiff.SAP_Product_Materiel_No_Old__c = OrderItemOld.SAP_Product_Materiel_No__c;
                    OrderLinDiff.Total_MW_Old__c = OrderItemOld.Total_MW__c;
                    OrderLinDiff.total_Price_Old__c = OrderItemOld.total_Price__c;
                    OrderLinDiff.total_Price2_Old__c =OrderItemOld.TotalPrice__c;
                    OrderLinDiff.Type_of_module_Old__c = OrderItemOld.Type_of_module__c;
                    OrderLinDiff.UnitPrice_Old__c = OrderItemOld.UnitPrice__c;
                    OrderItemDiffLst.add(OrderLinDiff);
                    
                }
            }
            if(OrderItemDiffLst.size()>0)insert OrderItemDiffLst;
            
            //插入业务机会下的付款方式数据
            List<PaymentDifference__c> paydiffLst = new  List<PaymentDifference__c>();
            List<Amendment_Payment__c> payLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                             'Where Amendment_Purchase_Agreement__c =:id2');
            for(Amendment_Payment__c payNew : APayLst){
                falg = 0;
                for(Amendment_Payment__c payOld : payLst){
                    if(payNew.ID__c == payOld.ID__c){
                        system.debug('付款配对');
                        PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Order_Differences__c = OrdDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                        paydiff.Days_New__c = payNew.Days__c;
                        paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                        paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                        paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                        paydiff.Percentage_New__c  = payNew.Percentage__c;
                        paydiff.Days_Old__c = payOld.Days__c;
                        paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                        paydiff.PaymentDescription_old__c=payOld.PaymentDescription__c;
                        paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
                        paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
                        paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
                        paydiff.Percentage_Old__c =payOld.Percentage__c;
                        paydiffLst.add(paydiff);
                        falg = falg +1;
                    }
                }
                if(falg ==0){
                    system.debug('付款新建配对');
                    PaymentDifference__c paydiff =new PaymentDifference__c();
                    paydiff.Order_Differences__c = OrdDiff.Id;
                    paydiff.ApprovalNumbers__c =String.valueof(Aord.ApprovalNumbers__c);
                    paydiff.Days_New__c = payNew.Days__c;
                    paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                    paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                    paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                    paydiff.Percentage_New__c = payNew.Percentage__c;
                    paydiff.PaymentDescription_new__c=payNew.PaymentDescription__c;
                    paydiffLst.add(paydiff);
                }
            }
            /*
for(Amendment_Payment__c payOld : payLst){
falg = 0;
for(Amendment_Payment__c payNew : APayLst){
if(payNew.ID__c == payOld.Id){
falg=1;
}
}
if(falg ==0){
system.debug('付款被删除了');
PaymentDifference__c paydiff =new PaymentDifference__c();
paydiff.Order_Differences__c = OrdDiff.Id;
paydiff.Days_Old__c = payOld.Days__c;
paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
paydiff.Percentage_Old__c =payOld.Percentage__c;
paydiffLst.add(paydiff);
}
}
*/
            system.debug(paydiffLst.size());
            if(paydiffLst.size()>0)insert paydiffLst;
            
        }

        SET<Approver> approverList = new SET<Approver>(); 
        if(Aord.Header_Change__c==true ||  Aord.Delivery_Date_Change__c==true || Aord.Delivery_Date_Change__c==true || Aord.Payment_Change__c==true){
            List<User> usr = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Alias =: 'Alexjian'];
            //     List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Alex jiang'];
            if(usr.size()>0){
                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
            }
            SYStem.debug('发邮件给 f');
            
            Order ordAmen =[Select id,Contract_Owner__c,Contract_Owner__r.BMO_specialist__c,Contract_Owner__r.Cross_Region_BMO__c FROM Order where id =:Aord.Order__c];
            
            if(Aord.Cross_Region__c==false){
                List<User> usr2 = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.BMO_specialist__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr2[0].Email,usr2[0].Name,usr2[0].UserRole.Name,usr2[0].Id)); 
                }
                SYStem.debug('发邮件给 bmo');
            }
            else if(Aord.Cross_Region__c==true){
                List<User> usr3 = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.Cross_Region_BMO__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr3[0].Email,usr3[0].Name,usr3[0].UserRole.Name,usr3[0].Id)); 
                }
                SYStem.debug('发邮件给  跨区 bmo'); 
            }
            List<Amendment__c> Aord2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                     'Where id =: Aorderid');
            if(Aord2.size()>0){
                String Userid= Aord2[0].Contract_Owner__c;
                User us=[select id,Contract_Approver__r.Email,Contract_Review__r.Email from user where id =:userid];
                String RegionHeadEmail = us.Contract_Approver__r.Email;
                String RegionHeadEmail3 = us.Contract_Review__r.Email;
                if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                    
                    List<User> usr4 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail];
                    
                    
                    if(usr4.size()>0){
                        approverList.add(new Approver(usr4[0].Email,usr4[0].Name,usr4[0].UserRole.Name,usr4[0].Id)); 
                    }
                    SYStem.debug('发邮件给 gm');
                    
                }
                if(RegionHeadEmail3 !=null && RegionHeadEmail3 !='' && Aord.Region__c=='North Asia' &&  Aord.Destination_Country__c=='Japan'){
                    
                    List<User> usr5 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail3];
                    
                    
                    if(usr5.size()>0){
                        approverList.add(new Approver(usr5[0].Email,usr5[0].Name,usr5[0].UserRole.Name,usr5[0].Id)); 
                    }
                    SYStem.debug('发邮件给 组长');
                    
                }
                if(Aord.Cross_Region__c == true ){
                    String RegionHeadName ='';
                    String RegionHeadEmail2 ='';
                    if(Aord.Region__c =='EU'|| Aord.Region__c=='Non EU'){
                        RegionHeadEmail2=Label.Area_EU;
                    }
                    else if(Aord.Region__c =='EU(Union)'|| Aord.Region__c=='EU(Non-Eu)'){
                        RegionHeadEmail2=Label.Area_EU;
                    }
                    else if(Aord.Region__c =='ROA'){
                        RegionHeadEmail2=Label.Area_ROA;
                    }else if(Aord.Region__c =='North Asia'){
                        RegionHeadEmail2=Label.Area_North_Asia;
                    }else if(Aord.Region__c =='South Asia'){
                        RegionHeadEmail2=Label.Area_South_Asia;
                    }else if(Aord.Region__c =='North America'){
                        RegionHeadEmail2=Label.Area_North_America;
                    }
                    //else if(Aord.Region__c =='Middle East&Africa'){
                   //     RegionHeadEmail2=Label.Area_Middle_east_africa;
                   // }
                    else if(Aord.Region__c =='Latin America&Italy'){
                        RegionHeadEmail2=Label.Area_Latin_America_Italy;
                    }else if(Aord.Region__c =='MENA'){
                        RegionHeadEmail2=Label.Middle_East_North_Africa;
                    }else if(Aord.Region__c =='SSA'){
                        RegionHeadEmail2=Label.Sub_Saharan_Africa;
                    }

                    if(RegionHeadEmail2 !=null && RegionHeadEmail2 !=''){
                        List<User> us2 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail2];
                        
                        system.debug('1111');
                        if(us2.size()>0){
                            approverList.add(new Approver(us2[0].Email,us2[0].Name,us2[0].UserRole.Name,us2[0].Id));
                        }
                    }
                }
            }
            if(aord2[0].Region__c=='North Asia'&& aord2[0].Destination_Country__c=='Japan'){
                User us2=[select id,Contract_Review__r.Email from user where id =:Aord2[0].Contract_Owner__c];
                String RegionHeadEmail2 = us2.Contract_Review__r.Email;
                    if(RegionHeadEmail2 !=null && RegionHeadEmail2 !=''){
                    SYStem.debug('准备发邮件给 组长');
                    List<User> usr2 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail2];
                    SYStem.debug('准备发邮件给 组长2');
                    
                    if(usr2.size()>0){
                        approverList.add(new Approver(usr2[0].Email,usr2[0].Name,usr2[0].UserRole.Name,usr2[0].Id)); 
                        SendEmailUtils.sendToSomeOne(Aord2[0].id,'Credit' , 'amentendsendfile');
                        SendEmailUtils.sendToSomeOne(Aord2[0].id,'miho fujiwara' , 'amentendsendfile');
                    }
                    SYStem.debug('发邮件给 组长');
                }
                }
        }
        if(Aord.Payment_Change__c==true){
               List<User> usrr = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Alias =: 'Credit'];
            if(usrr.size()>0){
                approverList.add(new Approver(usrr[0].Email,usrr[0].Name,usrr[0].UserRole.Name,usrr[0].Id));
            }
        }
        if(Aord.Product_Change__c==true){
             List<User> usr =new List<User>();
            if(Aord.Sales_Region_ConOwner__c=='North Asia' || Aord.Sales_Region_ConOwner__c=='North America'|| Aord.Sales_Region_ConOwner__c=='EU(Union)'|| Aord.Sales_Region_ConOwner__c=='EU(Non-Eu)'|| Aord.Sales_Region_ConOwner__c=='ROA'|| Aord.Sales_Region_ConOwner__c=='Central Asia'|| Aord.Sales_Region_ConOwner__c=='Key Account'){
           usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'technic1@jinkosolar.com'];
            //        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Jinko Technic'];
            }
            if(Aord.Sales_Region_ConOwner__c=='Middle East&Africa'||Aord.Sales_Region_ConOwner__c=='MENA'||Aord.Sales_Region_ConOwner__c=='SSA'|| Aord.Sales_Region_ConOwner__c=='Latin America&Italy'|| Aord.Sales_Region_ConOwner__c=='South Asia'){
           usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'technic2@jinkosolar.com'];
            //        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Jinko Technic'];
            }
            if(usr.size()>0){
                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id)); 
            }
            SYStem.debug('发邮件给 t');
        }
        
        List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
        List<String> ApproverName = new List<String>(); 
        SET<Id> ApproverId = new SET<Id>();
        List<String> email = new List<String>();
        for (Approver u : approverList ) {
            
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
            email.add(u.uEmail);
            system.debug('~~~~~~~~~~~>email:'+email);
            ApproverId.add(u.uId);
            ApproverName.add(u.uName);
            system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					
            
        }
        system.debug('~~~~~~~~>reviewList:' + reviewList);
        for(ID userid : ApproverId){
            SubmitForReview__c review = new SubmitForReview__c();
            review.Amendment__c = Aorderid;
            review.Status__c    = 'Pending';
            review.User__c      = userid;
            
            reviewList.add(review);
            
            System.debug('~~~~~~~~~userid'+userid);
            System.debug('~~~~~~~~~User__c'+review.User__c);
        }
     
            
        List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                 Remarks__c,
                                                 Role__c,
                                                 Status__c,
                                                 User__c
                                                 from SubmitForReview__c
                                                 where Amendment__c =: Aorderid
                                                 AND User__c in: ApproverId];
        system.debug('------>oldReviewList:' +  oldReviewList);
        List<SubmitForReview__c> fullReview =[select id,Date__c,
                                              Remarks__c,
                                              Role__c,
                                              Status__c,
                                              User__c
                                              from SubmitForReview__c
                                              where Amendment__c =: Aorderid];
        for(SubmitForReview__c sfr : fullReview){
            
            if(sfr.Role__c.indexof('Legal')>-1){
                oldReviewList.add(sfr);
            }
        }
        if(oldReviewList.size()>0 && oldReviewList != null){
            delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
        }
        
        if(reviewList.size() > 0)insert reviewList;	
        //AmendmentSendEmailCtrl.SendAmendmentReviewMail(approverList,am.Id);
        //CommonUtils.SendAmendmentReviewMail(u.uEmail,am.Id);
        
        
        
        OrderApprovalCounts.SendAmendmentReviewMail(approverList,Aorderid);
        String emailnamelist='';
        if(ApproverName.size()>0){
            for(String emailname:ApproverName){
                emailnamelist+=emailname+ ' ';
            }
        }
        Aord.Header_Change__c=false;
        Aord.Product_Change__c=false;
        Aord.Delivery_Date_Change__c=false; 
        Aord.Payment_Change__c=false;
        update Aord;
        
        
        
        
        return  'Submit success. '+emailnamelist+ ' has received this request.';
        
        
    }
    
    
    public static void SendAmendmentReviewMail(SEt<Approver> recipients,String amId){
        // try{
        System.debug('recipients------2830----'+recipients.size());
        if(recipients == null) return;
        if(recipients.size() == 0) return;
        List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
        List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =: 'test_sgy'];
        System.debug('mailTemplate---'+mailTemplate.size());
        for(Approver user : recipients){
            List<String> emailList = new List<String>();
            Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
            mail.setSaveAsActivity(false);
            emailList.add(user.uEmail);
            mail.setToAddresses(emailList); 
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setTargetObjectId(user.uId);
            if(mailTemplate.size()>0){
                mail.setTemplateId(mailTemplate[0].Id);
            }
            if(amId != null)mail.setWhatId(amId);
            mail.setSenderDisplayName(UserInfo.getName());
            mailList.add(mail);
        }
          System.debug('mailList---'+mailList.size());
        Messaging.sendEmail(mailList);   
        //  }catch(Exception e){System.debug(String.valueOf(e));  }
    }
    
    webservice static void TerminationApprove(String Aorderid){
        //获取当前补充协议所有字段值
       Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: Aorderid');
        
        Id id1=Aord.Order__c;
        //查询终止协议关联的订单
        Order ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                  'Where id =: id1');
        //审批人集合
        SET<Approver> approverList = new SET<Approver>();

        //查询终止协议中全部的在审批对象中的审批人   此步为了重置审批
        List<SubmitForReview__c> fullReviews =[select id,Date__c,
                                              Remarks__c,
                                              Role__c,
                                              Status__c,
                                              User__c
                                              from SubmitForReview__c
                                              where Amendment__c =: Aorderid];

        if(fullReviews.size()>0){
            delete fullReviews;
        }



        //查询财务审批人 
         List<User> usr = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Alias =: 'Alexjian'];
          //审批人集合添加财务 approverList
            if(usr.size()>0){
                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
            }
            SYStem.debug('发邮件给 f');
        //查询订单的关联字段，由于database.query无法查询到关联字段，所以用sql的方法查询
          Order ordAmen =[Select id,Contract_Owner__c,Contract_Owner__r.BMO_specialist__c,Contract_Owner__r.Cross_Region_BMO__c FROM Order where id =:Aord.Order__c];
            //如果这不是个跨区订单，发邮件给SOC
            if(Aord.Cross_Region__c==false){
                //查询SOC
                List<User> usr2 = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.BMO_specialist__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr2[0].Email,usr2[0].Name,usr2[0].UserRole.Name,usr2[0].Id)); 
                }
                SYStem.debug('发邮件给 SOC');
            }
            //如果跨区，发给跨区SOC
            else if(Aord.Cross_Region__c==true){
                //查询跨区SOC
                List<User> usr3 = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.Cross_Region_BMO__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr3[0].Email,usr3[0].Name,usr3[0].UserRole.Name,usr3[0].Id)); 
                }
                SYStem.debug('发邮件给  跨区 SOC'); 
            }
            //我也不知道为啥写这条sql，都是谜语，我是复制前辈的
        List<Amendment__c> Aord2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                     'Where id =: Aorderid');
            if(Aord2.size()>0){
                //userid 是合同的owner
                String Userid= Aord2[0].Contract_Owner__c;
                //查询合同owner的GM邮箱和组长邮箱
                User us=[select id,Contract_Approver__r.Email,Contract_Review__r.Email from user where id =:userid];
                //这里放的GM
                String RegionHeadEmail = us.Contract_Approver__r.Email;
                //这里放的组长
                String RegionHeadEmail3 = us.Contract_Review__r.Email;
                //如果GM邮箱有值
                if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                    //查询到GM的所有信息，包括职位
                    List<User> usr4 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail];
                    
                    
                    if(usr4.size()>0){
                        approverList.add(new Approver(usr4[0].Email,usr4[0].Name,usr4[0].UserRole.Name,usr4[0].Id)); 
                    }
                    SYStem.debug('发邮件给 gm');
                    
                }
            }
        //reviewlist
         List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
        List<String> ApproverName = new List<String>(); 
        SET<Id> ApproverId = new SET<Id>();
        List<String> email = new List<String>();
        //循环所有审批人
        for (Approver u : approverList ) {          
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
            //添加审批人邮箱在邮箱集合中
            email.add(u.uEmail);
            system.debug('~~~~~~~~~~~>email:'+email);
            //添加审批人id在审批人id集合中
            ApproverId.add(u.uId);
            //添加审批人名字在审批人姓名集合中
            ApproverName.add(u.uName);
            system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					           
        }
        system.debug('~~~~~~~~>reviewList:' + reviewList);
        //循环所有审批人id放进审批对象中
        for(ID userid : ApproverId){
            SubmitForReview__c review = new SubmitForReview__c();
            review.Amendment__c = Aorderid;
            review.Status__c    = 'Pending';
            review.User__c      = userid;            
            reviewList.add(review);            
            System.debug('~~~~~~~~~userid'+userid);
            System.debug('~~~~~~~~~User__c'+review.User__c);
        }
     
        //查询终止协议中在审批id集合中存在的审批人    
        List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                 Remarks__c,
                                                 Role__c,
                                                 Status__c,
                                                 User__c
                                                 from SubmitForReview__c
                                                 where Amendment__c =: Aorderid
                                                 AND User__c in: ApproverId];
        system.debug('------>oldReviewList:' +  oldReviewList);
        //查询终止协议中全部的在审批对象中的审批人
        List<SubmitForReview__c> fullReview =[select id,Date__c,
                                              Remarks__c,
                                              Role__c,
                                              Status__c,
                                              User__c
                                              from SubmitForReview__c
                                              where Amendment__c =: Aorderid];
        //循环全部审批人                                      
       /* for(SubmitForReview__c sfr : fullReview){  
        //判断权限中是否有存在法务的          
            if(sfr.Role__c.indexof('Legal')>-1){
                //给老的审批对象添加法务
                oldReviewList.add(sfr);
            }
        }

        if(oldReviewList.size()>0 && oldReviewList != null){
            delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
        }    */    
        if(reviewList.size() > 0)insert reviewList;	       
         OrderApprovalCounts.SendAmendmentReviewMail2(approverList,Aorderid);
        String emailnamelist='';
        if(ApproverName.size()>0){
            for(String emailname:ApproverName){
                emailnamelist+=emailname+ ' ';
            }
        }                        
    }


       public static void SendAmendmentReviewMail2(SEt<Approver> recipients,String amId){
        // try{
        System.debug('recipients------2830----'+recipients.size());
        if(recipients == null) return;
        if(recipients.size() == 0) return;
        List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
        List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:'AmendmentPurchaseAgreementEmail'];
        System.debug('mailTemplate---'+mailTemplate.size());
        for(Approver user : recipients){
            List<String> emailList = new List<String>();
            Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
            mail.setSaveAsActivity(false);
            emailList.add(user.uEmail);
            mail.setToAddresses(emailList); 
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setTargetObjectId(user.uId);
            if(mailTemplate.size()>0){
                mail.setTemplateId(mailTemplate[0].Id);
            }
            if(amId != null)mail.setWhatId(amId);
            mail.setSenderDisplayName(UserInfo.getName());
            mailList.add(mail);
        }
          System.debug('mailList---'+mailList.size());
        Messaging.sendEmail(mailList);   
        //  }catch(Exception e){System.debug(String.valueOf(e));  }
    }
    public static boolean ChangeQuarter(date oldDate,date newDate){ 
       	//System.debug('oldDate'----->+oldDate);
        //System.debug('newDate'----->+newDate);
        System.debug('oldDate---'+oldDate);
        System.debug('newDate---'+newDate);
        Decimal oldMonth = oldDate.month();
        Decimal newMonth = newDate.month();
        Decimal oldYear = oldDate.Year();
        Decimal newYear = newDate.Year();
        
        Decimal oldFlag;
        Decimal newFlag;
        //获取老交期的季度
        if(oldMonth==1 || oldMonth==2 || oldMonth==3){
            oldFlag=1;
        }else if(oldMonth==4 || oldMonth==5 || oldMonth==6){
            oldFlag=2;
        }else if(oldMonth==7 || oldMonth==8 || oldMonth==9){
            oldFlag=3;
        }else if(oldMonth==10 || oldMonth==11 || oldMonth==12){
            oldFlag=4;
        }
        //获取新交期的季度
        if(newMonth==1 || newMonth==2 || newMonth==3){
            newFlag=1;
        }else if(newMonth==4 || newMonth==5 || newMonth==6){
            newFlag=2;
        }else if(newMonth==7 || newMonth==8 || newMonth==9){
            newFlag=3;
        }else if(newMonth==10 || newMonth==11 || newMonth==12){
            newFlag=4;
        }
        //新老交期季度比较
        if(oldFlag!=newFlag || oldYear !=newYear){
           return true;
        }

        return false;
    }
   
    
}