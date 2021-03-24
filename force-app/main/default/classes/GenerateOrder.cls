public class GenerateOrder {
    
    public static boolean firstRun = true;//由于合同下有许多field update workflow,需要通过该字段避免触发器触发两次
    public static String OrderId = null;
    
    public static String generate(Contract con, Map<ID,List<Product_Detail__c>> prodMap, Map<ID,List<PricebookEntry>> 
                                  bookMap,Map<ID,List<Payment__c>> payMap,Map<ID,List<ContentDocumentLink>> cdlMap){
        
     system.debug('------Generate Order Class');   
                                      
        try{
             SyncContract.clickUpdate(con.id);
            // new order
            Order ord = new Order();
            // neo
            ord.Inventory_Type__c = con.InventoryArea__c;
            ord.Destination_Region__c = con.Destination_Region__c;
            ord.AccountId                          = con.AccountId;
            ord.Discount__c                          = con.Discount__c;
            ord.Rebate__c                          = con.Rebate__c;
            ord.Commission_Payee__c                 =con.Commission_Payee__c;
            ord.Contracts_RecordType__c                          = con.RecordType.name;
            ord.Get_Final_Approved_Time__c                          = con.Get_Final_Approved_Time__c;
            ord.Contracts_Start_Date__c                          = con.StartDate;
            ord.Contract_Commission__c                        = con.Commission__c;
            ord.Estimated_Time_of_Departure__c                          = con.ETD__c;
            ord.JINKO_OEM__c                          = con.JINKO_OEM__c;
            ord.AccountId                          = con.AccountId;
            ord.Authorized_Representative__c       = con.Authorized_Representative__c;
            ord.Avg_Price_W__c                     = con.Avg_Price_W__c;
            ord.BankInfo__c                        = con.BankInfo__c;
            ord.Bank_Information_Content__c        = con.Bank_Information_Content__c;
            ord.Buyer__c                           = con.BuyerAccount__c;
            ord.Commission__c                      = con.Commission__c;
            ord.Commission_Type__c                 = con.Commission_Type__c;
            ord.Contact_Name__c                    = con.Contact_Name__c;
            ord.Total_Price_Incl_Tax__c                     = con.Total_Price_Tax__c;
            ord.Warehouse_or_Factory__c				=con.Warehouse_or_Factory__c;
            ord.Local_Warehouse__c      =con.Local_Warehouse__c  ; 
            ord.Land_Freight_China__c =con.Land_Freight_China__c;
            ord.Ocean_Freight_China__c=con.Ocean_Freight__c;
            ord.Ocean_Freight_Oversea__c=con.Ocean_Freight_Oversea__c;
            ord.Land_Freight_Oversea__c=con.Land_Freight_Oversea__c;
            ord.Warehouse_Premium__c =con.Warehouse_Premium__c;
            ord.Logistic_Special_Cost_Per_W__c =con.Logistic_Special_Cost_Per_W__c;
            ord.Contract_Owner__c                  = con.OwnerId;
            ord.Contract_No__c                     =con.Contract_NO__c;
            ord.Contract_Type__c                   = con.RecordType.Name;
            ord.ContractId                         = con.Id;
            ord.Customer_Business_Scale__c         = con.Customer_Business_Scale__c;
            ord.Customer_country__c                = con.Customer_country__c;
            ord.CurrencyIsoCode                    = con.CurrencyIsoCode;
            ord.Destination__c                     = con.Destination__c;
            ord.Destination_Country__c             = con.Destination_Country__c;
            ord.Email__c                           = con.Email__c;
            ord.EffectiveDate                      = con.EndDate != null ? con.EndDate.addDays(-1) : Date.today().addDays(1);
            ord.Factory__c                         = con.Factory__c;
            ord.Fax__c                             = con.Fax__c;
            ord.Opportunity__c                     = con.Opportunity__c;
            ord.Payment_Term_Description__c        = con.Payment_Term_Description__c;
            ord.Phone__c                           = con.Phone__c;
            ord.Progress_Remarks__c                = con.Progress_Detail_1RD__c;
            ord.Region__c                          = con.Region__c;
            ord.SAP_Customer_PO_No__c              = con.SAP_Customer_PO_No__c;

            ord.SAP_Project_No__c                  = con.SAP_Project_No__c;
            ord.SELLER__c                          = con.SELLER__c;
            ord.Shipping_type__c                   = con.Shipping_type__c;
            ord.SPECIAL_TERMS__c                   = con.SPECIAL_TERMS__c;
            ord.Stage__c                           = con.Stage_1RD__c;
            ord.Supply_By__c                       = con.Supply_By__c;
            ord.Status                             = 'Active';//con.Status;
            ord.Tax__c                             = con.Tax__c;
            ord.Sales_1__c                         =  con.Sales_1__c;
            ord.Sales_1_percentage__c              = con.Sales_1_percentage__c;
            ord.Sales_2__c                         =  con.Sales_2__c;
            ord.Sales_2_percentage__c              = con.Sales_2_percentage__c;
            ord.Sales_3__c                         =  con.Sales_3__c;
            ord.Sales_3_percentage__c              = con.Sales_3_percentage__c;
            ord.Jinko_Parent_Company_Guarantee_needed__c = con.Jinko_Parent_Company_Guarantee_needed__c;
            ord.Jinko_Parent_Company_Guarantee__c = con.Jinko_Parent_Company_Guarantee__c;
            if(con.Buyer_Country__c == 'Japan'){
            ord.Transit_Fees__c                    = con.Transit_Fees__c;
            }
            ord.Tax_Rate__c                        = con.Tax_Rate__c;
            ord.Title__c                           = con.Title__c;
            //ord.Total_MW__c                        = con.Total_MW__c;
            //ord.Total_Price__c                     = con.Total_Price__c;
            //ord.Total_Quantity__c                  = con.Total_Quantity__c;
            ord.Trade_term__c                      = con.Trade_term__c;
            ord.Update_Time_1st__c                 = con.Update_Time_1rd__c;
            ord.Warranty_Insurance__c              = con.Warranty_Insurance__c;
            ord.Warranty_On_Material_and_Workmanship__c = con.Warranty_On_Material_and_Workmanship__c;
            ord.Pricebook2Id                       = con.Pricebook2Id__c;
            //sync Commission 2017/11/29 by Han
            ord.Commission__c                      = con.Commission__c;
            //获取合同Actual Sales Name值
            ord.Actual_Sales_Name__c               = con.Actual_Sales_Name__c;
            //billing address
            ord.BillingCity                        = con.BillingCity;
            ord.BillingCountry                     = con.BillingCountry;
            ord.BillingPostalCode                  = con.BillingPostalCode;
            ord.BillingState                       = con.BillingState;
            ord.BillingStreet                      = con.BillingStreet;
            ord.delivery_note_CI__c                = con.delivery_note_CI__c;
            ord.GDDMin__c                          = con.GDDMin__c;
            ord.branch__c                          = con.branch__c;
            system.debug('>>>>>>>>>>>>' + con.Finance_approved_orders_Fast_Process__c);
            system.debug('>>>>>>>>>>>>' + con.BMO_Manager_approved_orders_Fast_Process__c);
            system.debug('>>>>>>>>>>>>' + con.Approval_Status__c);
            system.debug('>>>>>>>>>>>>' + ord.CurrencyIsoCode);
            ord.SAPStatus__c ='I';
            insert ord;
            OrderId = ord.Id;
            String oppid =ord.Opportunity__c;
            
             List<Reserve_inventory_information__c> RiiLstQ= new List<Reserve_inventory_information__c>();
          RiiLstQ= Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Reserve_inventory_information__c) + ' ' +
                                               'Where  Opportunity__c=:oppid ');  
           if(RiiLstQ.size()>0){
                for(Reserve_inventory_information__c rii:RiiLstQ)
                    {
                        rii.order__c=ord.id;
                    }
            }
                update RiiLstQ;
      

            
            Set<ID> cdIDs = new Set<ID>();  //合同中上传文件的id集合
            
            
            List<ContentDocumentLink> cdlList= cdlMap.get(con.Id);
            //List<ContentDocument> cdLst = new List<ContentDocument>();
            
            
            for(ContentDocumentLink cdl : cdlList){
              cdIDs.add(cdl.ContentDocumentId);
            }
            system.debug('-------cdIDs' + cdIDs);
            List<ContentVersion> cvLst = [Select c.VersionData, c.Title, c.Id, c.FileType, c.ContentDocumentId From ContentVersion c Where c.ContentDocumentId in:cdIDs] ;
           
            for(ContentVersion cv : cvLst){
                system.debug('-----cv');
                
                if(ord.Id != null){
                    Attachment quoAttach= new Attachment();
                    quoAttach.parentId = ord.Id;
                    
                    if(cv.FileType == 'EXCEL'){
                        quoAttach.name = cv.Title+'.xls';
                        quoAttach.ContentType ='application/x-xls';
                    }else if(cv.FileType == 'PDF'){
                        quoAttach.name = cv.Title+'.pdf';
                        quoAttach.ContentType ='application/pdf';        
                    }else if(cv.FileType == 'WORD'){
                        quoAttach.name = cv.Title+'.doc';
                        quoAttach.ContentType = 'application/msWord';
                    }
                    else if(cv.FileType == 'WORD_X'){
                        quoAttach.name = cv.Title+'.docx';
                        quoAttach.ContentType = 'application/msWord';
                    }else{
                         quoAttach.ContentType =cv.FileType;
                    }
                    quoAttach.body = cv.VersionData;
                    
                insert quoAttach; 
                }
                
            }
           
            
            
            List<PricebookEntry> entrys = bookMap.get(con.Pricebook2Id__c);
            
            // new order products
            List<Product_Detail__c> prodList= prodMap.get(con.Id);

            List<OrderItem> insert_orderItem = new List<OrderItem>();
            for(Product_Detail__c pd : prodList){
                
                OrderItem oi = new OrderItem();
                oi.Maximum_Power_at_STC_Pmax_Wp__c = pd.Maximum_Power_at_STC_Pmax_Wp__c;
                oi.MixedDelivery__c = pd.MixedDelivery__c;
                oi.Cheetah__c                       = pd.Cheetah__c;
                oi.Product_Series__c                       = pd.Product_Series__c;
                oi.OppProductID__c                       = pd.OppProductID__c;
                oi.Battery_Type__c                       = pd.Battery_Type__c;
                oi.Bus_bars_of_cell__c                   = pd.Bus_bars_of_cell__c;
                oi.Certification__c                      = pd.Certification__c;
                oi.Color_of_frame_and_backsheet__c       = pd.Color_of_frame_and_backsheet__c;
                oi.Connector__c                          = pd.Connector__c;
                oi.Description                           = pd.Production_Description__c;
                oi.Grade__c                              = pd.Grade__c;
                oi.Guaranteed_Delivery_Date__c           = pd.Guaranteed_Delivery_Date__c;
                oi.Guaranteed_Delivery_Date_japan__c     = pd.Guaranteed_Delivery_Date_japan__c;
                oi.Length_of_Junction_Box_wiring__c      = pd.Length_of_Junction_Box_wiring__c;
                oi.SAP_Product_Materiel_No__c            = pd.SAP_Product_Materiel_No__c;
                oi.Test_code__c                          = pd.Test_code__c;
                oi.Opp_Description__c                    = pd.Opp_Description__c;
                            oi.Japan_Rate_Tax__c = pd.Japan_Rate_Tax__c;
            oi.Total_Price_Tax_Japan__c=pd.Total_Price_Tax_Japan__c;
                oi.OrderId                               = ord.Id;
                if (entrys != null) {
                    for(PricebookEntry entry : entrys){
                        if(entry.Product2Id == pd.Product__c){
                            oi.PricebookEntryId = entry.Id;
                        }
                    }
                }
                oi.Quantity                              = pd.Quantity__c;
                oi.Special_required__c                   = pd.Special_required__c;
                oi.Type_of_module__c                     = pd.Junction_Box_Type__c;
                //oi.Total_Price__c                        = pd.Total_Price__c;
                oi.Total_MW__c                           = pd.Total_MW__c;
                oi.UnitPrice                             = pd.Unit_Price__c;
                oi.MP__c                                 = pd.MP__c;
                oi.SAPStatus__c ='I';
                insert_orderItem.add(oi);
            }
            
            insert insert_orderItem;
            
            // sync payments
            List<Payment__c> paymentList = payMap.get(con.Id); 
            List<Payment__c> insertPays  = new List<Payment__c>();
            for(Payment__c pay : paymentList){
                Payment__c tmp = new Payment__c();
                tmp.Down_Balance_Payment__c = pay.Down_Balance_Payment__c;
                tmp.Payment_Method__c       = pay.Payment_Method__c;
                tmp.Payment_Term__c         = pay.Payment_Term__c;
                tmp.Days__c                 = pay.Days__c;
                tmp.Percentage__c           = pay.Percentage__c;
                tmp.Precise_Day__c          = pay.Precise_Day__c;
                tmp.Comments__c             = pay.Comments__c;
                tmp.Credit_Valid__c         = pay.Credit_Valid__c;
                                        tmp.Type__c=pay.Type__c;
                        tmp.Comments_English__c=pay.Comments_English__c;
                        tmp.Comments_Japan__c=pay.Comments_Japan__c;
                tmp.Order__c                = ord.Id;
                tmp.SAPStatus__c ='I';
                insertPays.add(tmp);
            }
            insert insertPays;
            
            //lock
            ord.Lock__c = false;//第一次生成订单时不加锁
            update ord;
            ord.SAPStatus__c ='U';
            return ord.id;
            
        }catch(Exception e){ 
            System.debug('------------> Exception: '+e.getMessage());
        }
        return null;
    }
    
    public void runTest(){
        String run = 'Go test';
    }
}