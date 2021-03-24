global class OrderUnLockCtrl {
    webservice static void SearchParent(String attid){
        //  try{
        system.debug('attid-->'+attid);
        List<Amendment__c> amendList = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                      'Where id =: attid');
        List<Amendment__c> amendupList =new List<Amendment__c>();
        for(Amendment__c amend :amendList){
            if(amend.Lock__c==false){
                amend.Lock__c=true;
                amendupList.add(amend);
            }
        }
        update amendupList;
        system.debug('amendList-->'+amendList);
        List<String> amendIDList = new List<String>();
        for(Amendment__c amend : amendList){
            amendIDList.add(amend.Order__c); 
        }
        system.debug('amendIDList-->'+amendIDList);
        List<Order>  OrdList = new List<Order>();
        if(amendList !=null && amendList.size()>0){
            OrdList = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.order) + ' ' +
                                     'Where id in: amendIDList');
        }
        system.debug('OrdList-->'+OrdList);
        List<Order>  UpdateOrdList = new List<Order>();
        if(OrdList !=null && OrdList.size()>0){
            for(Order ord : OrdList){
                ord.Lock__c = false;
                            system.debug('Order信息-->'+ord.Lock__c);
                UpdateOrdList.add(ord);    
                           
            }
            system.debug('UpdateOrdList-->'+UpdateOrdList);
            if(UpdateOrdList !=null && UpdateOrdList.size()>0){
                system.debug('start update');
                update UpdateOrdList;
                system.debug('stop update');
            }
        }
        UpdateOrder(amendList,OrdList);
        // }catch( Exception ex){system.debug('Error:-->'+ex.getMessage());}
        
        
    }
        webservice static void SOCLock(String attid){
        //  try{
        system.debug('attid-->'+attid);
        List<Amendment__c> amendList = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                      'Where id =: attid');
           amendList[0].Lock__c = false; 
            amendList[0].SOClock__c=true;
            update amendList;
            amendList[0].Lock__c = true;
            update amendList;
            }
    
    public static void UpdateOrder( List<Amendment__c> amendList , List<Order>  OrdList){
        set<id> pid=new set<id>();
        String orderid;
        String Amendmentid;
        string bizhong;
        
        
        
        
        
        
        
        
        
        List<Order> updateOrderList = new List<Order>();
        // 订单内容回传
        if(amendList !=null && amendList.size()>0 && OrdList.size()>0 && OrdList !=null){

            for(Order ord :OrdList){
                system.debug('order Lock'+ord.lock__c);
                for(Amendment__c amend :amendList){
                    if(ord.id ==amend.Order__c){
                        orderid=ord.id;
                        Amendmentid=amend.id;
                        bizhong=amend.CurrencyIsoCode;
                        ord.CurrencyIsoCode=amend.CurrencyIsoCode;
                        ord.Account_Allocation_Group__c=  amend.Account_Allocation_Group__c;
                        ord.Account_Group__c=  amend.Account_Group__c;
                        ord.Account_Holder__c=   amend.Account_Holder__c;
                        ord.AccountId=  amend.Account__c;
                        ord.Account_Title__c=   amend.Account_Title__c;
                        ord.Actual_Sales_Name__c=   amend.Actual_Sales_Name__c;
                        ord.Applicant_Direct_Superior__c=  amend.Applicant_Direct_Superior__c;
                        ord.Authorized_Representative__c=  amend.Authorized_Representative__c;
                        ord.Avg_Price_W__c=  amend.Avg_Price_W__c;
                        ord.Bank_Account__c=   amend.Bank_Account__c;
                        ord.Bank_City__c=   amend.Bank_City__c;
                        ord.Bank_Code__c=    amend.Bank_Code__c;
                        ord.Bank_Country__c=    amend.Bank_Country__c;
                        ord.Bank_Information_Content__c=    amend.Bank_Information_Content__c;
                        ord.Bank_Name__c=    amend.Bank_Name__c;
                        ord.Bank_Region__c=    amend.Bank_Region__c;
                        ord.Bank_Street__c=    amend.Bank_Street__c;
                        ord.BankInfo__c=    amend.BankInfo__c;
                        ord.BillToContactId=    amend.BillToContact__c;
                        ord.BillingCity=    amend.BillingCity__c;
                        ord.BillingCountry=   amend.BillingCountry__c;
                        ord.BillingPostalCode=   amend.BillingPostalCode__c;
                        ord.BillingState=   amend.BillingState__c;
                        ord.BillingStreet=   amend.BillingStreet__c;
                        ord.BMO_SR__c=    amend.BMO_SR__c;
                        ord.BSB_Number__c=   amend.BSB_Number__c;
                        ord.Buyer__c=   amend.Buyer__c;
                        ord.CC_No__c=   amend.CC_No__c;
                        ord.Commission__c=   amend.Commission__c;
                        ord.Account_Group__c=    amend.Commission_Type__c;
                        ord.Commission_Type__c=   amend.Commission_Type__c;
                        ord.CompanyAuthorizedById=   amend.CompanyAuthorizedBy__c;
                        ord.CompanyAuthorizedDate=  amend.CompanyAuthorizedDate__c;
                        ord.Company_Registration_No__c=  amend.Company_Registration_No__c;
                        ord.Discount__c                        =  amend.Discount__c;
                        ord.Rebate__c                          =  amend.Rebate__c;
                        ord.Commission_Payee__c                        =  amend.Commission_Payee__c;
                        ord.Sales_1__c                         =  amend.Sales_1__c;
                        ord.Sales_1_percentage__c              = amend.Sales_1_percentage__c;
                        ord.Sales_2__c                         =  amend.Sales_2__c;
                        ord.Sales_2_percentage__c              =amend.Sales_2_percentage__c;
                        ord.Sales_3__c                         =  amend.Sales_3__c;
                        ord.Sales_3_percentage__c              = amend.Sales_3_percentage__c;
                        ord.Contact_Name__c=   amend.Contact_Name__c;
                        ord.ContractId=   amend.Contract__c;
                        ord.Contract_No__c=  amend.Contract_No__c;
                        ord.Contract_Owner__c=   amend.Contract_Owner__c;
                        ord.Country_Scope__c=   amend.Country_Scope__c;
                        ord.CustomerAuthorizedByid=   amend.CustomerAuthorizedBy__c;
                        ord.CustomerAuthorizedDate=    amend.CustomerAuthorizedDate__c;
                        ord.Customer_Business_Scale__c=   amend.Customer_Business_Scale__c;
                        ord.Customer_country__c=   amend.Customer_country__c;
                        ord.delivery_note_CI__c=   amend.delivery_note_CI__c;
                        ord.Description=  amend.Description__c;
                        ord.Destination__c=    amend.Destination__c;
                        ord.Destination_Country__c=    amend.Destination_Country__c;
                        ord.Distribution_channel__c=    amend.Distribution_channel__c;
                        ord.Email__c=   amend.Email__c;
                        ord.Emergency_level__c=   amend.Emergency_level__c;
                        ord.Factory__c=   amend.Factory__c;
                        ord.Fax__c=   amend.Fax__c;
                        ord.GST_Classification_Region__c=   amend.GST_Classification_Region__c;
                        ord.IBAN_Code__c=   amend.IBAN_Code__c;
                        ord.Intercompany_Seller_POs__c=   amend.Intercompany_Seller_POs__c;
                        ord.Account_Group__c= amend.Account_Group__c ;
                        ord.Ledger_Name__c= amend.Ledger_Name__c;
                        ord.Lock__c = false;
                        ord.MaxRowNo__c=   amend.MaxRowNo__c;
                        ord.Normal__c=  amend.Normal__c;
                        ord.OA_External_ID__c=   amend.OA_External_ID__c;
                        ord.Operate_Type__c=  amend.Operate_Type__c;
                        ord.Opportunity__c=        amend.Opportunity__c;
                        ord.EndDate=  amend.EndDate__c;
                        ord.Name=  amend.Name__c;
                        ord.OrderReferenceNumber=   amend.OrderReferenceNumber__c;
                        ord.EffectiveDate=   amend.EffectiveDate__c;
                        //   ord.OriginalOrderid=   amend.OriginalOrder__c;
                        ord.Other__c=   amend.Other__c;
                        ord.Payment_Term_Description__c=   amend.Payment_Term_Description__c;
                        ord.Phone__c=   amend.Phone__c; 
                        ord.PMC_confirm__c=    amend.PMC_confirm__c;
                        ord.PODate=    amend.PODate__c;
                        ord.PONumber=    amend.PONumber__c;
                        ord.Product_Group__c=   amend.Product_Group__c;
                        ord.Progress_Remarks__c=  amend.Progress_Remarks__c;
                        ord.Quoteid=    amend.Quote__c;
                        //   ord.IsReductionOrder=    amend.IsReductionOrder__c;
                        ord.Region__c=    amend.Region__c;
                        ord.Requested_supplier__c=    amend.Requested_supplier__c;
                        ord.Routing_Number_ABA__c=    amend.Routing_Number_ABA__c;
                        ord.Sales_Dept__c=        amend.Sales_Dept__c;
                        ord.Sales_Group__c=     amend.Sales_Group__c;
                        ord.Sales_Org__c=     amend.Sales_Org__c;
                        ord.Sales_Region__c=     amend.Sales_Region__c; 
                        ord.SAP_Customer_PO_No__c=     amend.SAP_Customer_PO_No__c;
                        ord.SAP_Describe__c=        amend.SAP_Describe__c;
                        ord.SAP_External_ID__c=    amend.SAP_External_ID__c;
                       // ord.SAP_Order_ID__c=   amend.SAP_Order_ID__c;
                        ord.SAP_Project_No__c=   amend.SAP_Project_No__c;
                        ord.SC_No__c =   amend.SC_No__c;
                        ord.Search__c=  amend.Search__c;
                        ord.SELLER__c=    amend.SELLER__c;
                        ord.SEQ__c=    amend.SEQ__c;
                        ord.ShipToContactid=    amend.ShipToContact__c;
                        ord.Shipping_type__c =   amend.Shipping_type__c;
                        ord.Special_Approvals__c=    amend.Special_Approvals__c;
                        ord.Special_Requirements__c=     amend.Special_Requirements__c;
                       //  ord.SPECIAL_TERMS__c=    amend.SPECIAL_TERMS__c;
                        ord.Special__c=    amend.Special__c;
                        ord.Stage__c=     amend.Stage__c;
                        ord.Status=     amend.Status__c;
                        ord.Street_Room_Number__c=        amend.Street_Room_Number__c;
                        ord.Subject_Group__c=    amend.Subject_Group__c;
                        ord.Supply_By__c=    amend.Supply_By__c;
                        ord.SWIFT_Code__c=   amend.SWIFT_Code__c;
                        ord.Tax__c=    amend.Tax2__c;
                        ord.Tax_No__c=    amend.Tax_No__c;
                        ord.Tax_Rate__c=    amend.Tax_Rate__c;
                        ord.Taxpayer_Identification_No__c=     amend.Taxpayer_Identification_No__c;
                        ord.Title__c=     amend.Title__c;
                        ord.Trade_term__c=     amend.Trade_term__c;
                        ord.Transit_Fees__c =    amend.Transit_Fees__c;
                        ord.Update_Time_1st__c =   amend.Update_Time_1st__c;
                        ord.VAT_NO__c   =  amend.VAT_NO__c;
                        ord.Warranty_Insurance__c=  amend.Warranty_Insurance__c;
                        ord.Warranty_On_Material_and_Workmanship__c=  amend.Warranty_On_Material_and_Workmanship__c;
                           system.debug('order Lock'+ord.lock__c);
                        updateOrderList.add(ord);
                    }
                }
            }
            
        }
        
        //附加产品回传
        system.debug('产品开始回传');
        List<Amendment_Order_Product__c> AOPLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                                               'Where OriginalOrderItem__c =:Amendmentid');
        List<OrderItem> OILst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem) + ' ' +
                                             'Where Orderid =:orderid');
        for(Amendment_Order_Product__c aopp:AOPLst){
            system.debug('产品个数:'+AOPLst.size());
            pid.add(aopp.Product2__c);
        }
        List<PricebookEntry> peLst=[select id,Product2id,CurrencyIsoCode,Pricebook2Id from PricebookEntry where Product2id in:pid];
        system.debug('价格个数:'+peLst.size());
        MAP<id,List<PricebookEntry>> pmap=new MAP<id,List<PricebookEntry>>();
        for(id ids:pid){
            List<PricebookEntry> a =new List<PricebookEntry>();
            for(PricebookEntry pe:peLst){
                if(ids == pe.Product2id){
                    a.add(pe);
                }
            }
            pmap.put(ids,a);
        }
        if(AOPLst !=null && AOPLst.size()>0 && OILst.size()>0 && OILst !=null){
            List<OrderItem> updateAOPList = new List<OrderItem>();
            List<OrderItem> insertAOPList = new List<OrderItem>();
            List<OrderItem> deleteAOPList = new List<OrderItem>();
            String num;
            
            for(Amendment_Order_Product__c aop :AOPLst){
                num='0';
                for(OrderItem oi :OILst){
                    if(String.valueOf(oi.id) ==aop.ID__c){
                        system.debug('有相同产品');
                        if(oi.Product_Name__c==aop.Product_Name__c){
                            system.debug('1');
                            system.debug('11:'+aop);
                            num='1';
                            
                            oi.Cheetah__c=aop.Cheetah__c;
                            oi.Battery_Type__c=aop.Battery_Type__c;
                            oi.Bus_bars_of_cell__c=aop.Bus_bars_of_cell__c;
                            oi.Certification__c=aop.Certification__c;
                            oi.Color_of_frame_and_backsheet__c=aop.Color_of_frame_and_backsheet__c;
                            oi.Connector__c=aop.Connector__c;
                            oi.EndDate=aop.EndDate__c;
                            oi.Expected_delivery_date__c=aop.Expected_delivery_date__c;
                            oi.Grade__c=aop.Grade__c;
                            oi.Total_Price_Tax_Japan__c=aop.TotalPrice_Tax_no_Tran__c;
                            oi.Japan_Rate_Tax__c=aop.Japan_Rate_Tax__c;
                            
                            oi.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
                            oi.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
                            oi.Requested_ETD__c=aop.Guaranteed_ETD__c;
                            oi.Requested_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
                            oi.IS_TBD__c=aop.ISTBD__c;
                            oi.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
                            oi.Description=aop.Description__c;
                            oi.MP__c=aop.M_P__c;
                             oi.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
                            oi.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
                            oi.Requested_ETD__c=aop.Guaranteed_ETD__c;
                            oi.Requested_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
                            oi.IS_TBD__c=aop.ISTBD__c;
                            oi.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
                            oi.Description=aop.Description__c;
                            oi.MP__c=aop.M_P__c;
                             oi.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
                            oi.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
                            oi.Requested_ETD__c=aop.Guaranteed_ETD__c;
                            oi.Requested_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
                            oi.IS_TBD__c=aop.ISTBD__c;
                            oi.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
                            oi.Description=aop.Description__c;
                            oi.MP__c=aop.M_P__c;
                             oi.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
                            oi.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
                            oi.Requested_ETD__c=aop.Guaranteed_ETD__c;
                            oi.Requested_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
                            oi.IS_TBD__c=aop.ISTBD__c;
                            oi.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
                            oi.Description=aop.Description__c;
                            oi.MP__c=aop.M_P__c;
                            
                            oi.MaterielNo__c=aop.MaterielNo__c;
                            oi.Quantity=aop.Quantity__c;
                            oi.QuoteLineItemid=aop.QuoteLineItem__c;
                            oi.Remarks__c=aop.Remarks__c;
                            oi.Request_No__c=aop.Request_No__c;
                            oi.Requested_Goods_Ready_date__c=aop.Requested_Goods_Ready_date__c;
                            oi.RowNo__c=aop.RowNo__c;
                            
                            oi.SAP_Product_Materiel_No__c=aop.SAP_Product_Materiel_No__c;
                            oi.Special_required__c=aop.Special_required__c;
                            oi.ServiceDate=aop.ServiceDate__c;
                            oi.Total_MW__c=aop.Total_MW__c;
                            
                            oi.total_Price__c=aop.Total_Price__c;
                            oi.UnitPrice=aop.UnitPrice__c;
                            
                            oi.Type_of_module__c=aop.Type_of_module__c;
                            oi.unit_Price__c=aop.Unit_Price__c;
                            //Snake 20200827
                            insertAOPList.add(oi);  
                        }
                        if(oi.Product_Name__c!=aop.Product_Name__c){
                            system.debug('2');
                            num='1';
                            deleteAOPList.add(oi);
                            OrderItem oi2 =new OrderItem();
                            oi2.Battery_Type__c=aop.Battery_Type__c;
                            oi2.Bus_bars_of_cell__c=aop.Bus_bars_of_cell__c;
                            oi2.Certification__c=aop.Certification__c;
                            oi2.Color_of_frame_and_backsheet__c=aop.Color_of_frame_and_backsheet__c;
                            oi2.Connector__c=aop.Connector__c;
                            oi2.EndDate=aop.EndDate__c;
                            oi2.Expected_delivery_date__c=aop.Expected_delivery_date__c;
                            oi2.Grade__c=aop.Grade__c;
                            oi2.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
                            oi2.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
                            oi2.Requested_ETD__c=aop.Guaranteed_ETD__c;
                            oi2.Requested_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
                            oi2.IS_TBD__c=aop.ISTBD__c;
                            oi2.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
                            oi2.Description=aop.Description__c;
                            oi2.MP__c=aop.M_P__c;
                            oi2.MaterielNo__c=aop.MaterielNo__c;
                            oi2.Orderid=aop.Order__c;
                            oi2.Product2id=aop.Product2__c;
                            oi2.Total_Price_Tax_Japan__c=aop.TotalPrice_Tax_no_Tran__c;
                            oi2.Japan_Rate_Tax__c=aop.Japan_Rate_Tax__c;
                            List<PricebookEntry> peLst2 = pmap.get(aop.Product2__c);
                            
                            
                            for(PricebookEntry pe:peLst2){
                                system.debug('pe.CurrencyIsoCode-->'+pe.CurrencyIsoCode);
                                system.debug('bizhong-->'+bizhong);
                                system.debug(' pe.Pricebook2Id-->'+ pe.Pricebook2Id);
                                system.debug('OrdList[0].Pricebook2Id-->'+ OrdList[0].Pricebook2Id);
                                if(pe.Pricebook2Id==OrdList[0].Pricebook2Id){
                                    oi2.PricebookEntryId = pe.Id;
                                }
                            }
                            
                            
                            oi2.Quantity=aop.Quantity__c;
                            oi2.QuoteLineItemid=aop.QuoteLineItem__c;
                            oi2.Remarks__c=aop.Remarks__c;
                            oi2.Request_No__c=aop.Request_No__c;
                            oi2.Requested_Goods_Ready_date__c=aop.Requested_Goods_Ready_date__c;
                            oi2.RowNo__c=aop.RowNo__c;
                            oi2.Special_required__c=aop.Special_required__c;
                            oi2.ServiceDate=aop.ServiceDate__c;
                            oi2.Total_MW__c=aop.Total_MW__c;
                            oi2.total_Price__c=aop.Total_Price__c;
                            oi2.UnitPrice=aop.UnitPrice__c;
                            oi2.Type_of_module__c=aop.Type_of_module__c;
                            oi2.unit_Price__c=aop.Unit_Price__c;
                            insertAOPList.add(oi2);  
                        }
                    }
                    
                }
                if(num=='0'){
                    system.debug('新的');
                    OrderItem oi2 =new OrderItem();
                    oi2.Battery_Type__c=aop.Battery_Type__c;
                    oi2.Bus_bars_of_cell__c=aop.Bus_bars_of_cell__c;
                    oi2.Certification__c=aop.Certification__c;
                    oi2.Color_of_frame_and_backsheet__c=aop.Color_of_frame_and_backsheet__c;
                    oi2.Connector__c=aop.Connector__c;
                    oi2.EndDate=aop.EndDate__c;
                    oi2.Expected_delivery_date__c=aop.Expected_delivery_date__c;
                    oi2.Grade__c=aop.Grade__c;
                    oi2.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
                    oi2.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
                    oi2.Requested_ETD__c=aop.Guaranteed_ETD__c;
                    oi2.Requested_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
                    oi2.IS_TBD__c=aop.ISTBD__c;
                    oi2.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
                    oi2.Description=aop.Description__c;
                    oi2.MP__c=aop.M_P__c;
                    oi2.Total_Price_Tax_Japan__c=aop.TotalPrice_Tax_no_Tran__c;
                    oi2.Japan_Rate_Tax__c=aop.Japan_Rate_Tax__c;
                    
                    oi2.MaterielNo__c=aop.MaterielNo__c;
                    oi2.Orderid=aop.Order__c;
                    oi2.Product2id=aop.Product2__c;
                    List<PricebookEntry> peLst2 = pmap.get(aop.Product2__c);
                    for(PricebookEntry pe:peLst2){
                        system.debug('pe.CurrencyIsoCode-->'+pe.CurrencyIsoCode);
                        system.debug('bizhong-->'+bizhong);
                        system.debug(' pe.Pricebook2Id-->'+ pe.Pricebook2Id);
                        system.debug('OrdList[0].Pricebook2Id-->'+ OrdList[0].Pricebook2Id);
                      
                        SYSTEM.debug('pe.Pricebook2Id---->'+pe.Pricebook2Id);
                         SYSTEM.debug('OrdList.size()---->'+OrdList.size());
                        
                         if(pe.Pricebook2Id==OrdList[0].Pricebook2Id){
                            oi2.PricebookEntryId = pe.Id;
                            
                            system.debug('id-->'+oi2.PricebookEntryId);
                        }   
						
                        
                    }
                    
                    
                    oi2.Quantity=aop.Quantity__c;
                    
                    oi2.Remarks__c=aop.Remarks__c;
                    oi2.Request_No__c=aop.Request_No__c;
                    
                    oi2.Requested_Goods_Ready_date__c=aop.Requested_Goods_Ready_date__c;
                    oi2.Special_required__c=aop.Special_required__c;
                    oi2.ServiceDate=aop.ServiceDate__c;
                    oi2.Total_MW__c=aop.Total_MW__c;
                    oi2.total_Price__c=aop.Total_Price__c;
                    oi2.UnitPrice=aop.UnitPrice__c;
                    oi2.Type_of_module__c=aop.Type_of_module__c;
                    oi2.unit_Price__c=aop.Unit_Price__c;
                    
                    insertAOPList.add(oi2);  
                }
            }
            
            upsert insertAOPList;
            update  updateOrderList;
            for(OrderItem oi :OILst){
                num='0';
                for(Amendment_Order_Product__c aop :AOPLst){
                    if(String.valueOf(oi.id) ==aop.ID__c){
                        system.debug('有相同产品');
                        num='1';
                    }
                }
                if(num=='0'){
                    system.debug('产品被删除了');
                    deleteAOPList.add(oi);
                }
            }
            delete deleteAOPList;
        }
        
        
        
        
        
        
        
        
        
        
        
        
        //附加付款方式回传
        system.debug('付款开始回传');
        List<Amendment_Payment__c> APLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                                        'Where Amendment_Purchase_Agreement__c =:Amendmentid');
        List<Payment__c> PLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c) + ' ' +
                                             'Where Order__c =:orderid');
        
        
        if(APLst !=null && APLst.size()>0){
            List<Payment__c> updatePList = new List<Payment__c>();
            List<Payment__c> insertPList = new List<Payment__c>();
            List<Payment__c> deletePList = new List<Payment__c>();
            String num2;
            
            for(Amendment_Payment__c ap :APLst){
                num2='0';
                for(Payment__c p :PLst){
                    if(String.valueOf(p.id) ==ap.ID__c){
                        system.debug('有相同付款方式');
                        num2='1';
                        p.Comments__c=ap.Comments__c;
                        p.Credit_Valid__c=ap.Credit_Valid__c;
                        p.Days__c=ap.Days__c;
                        p.Down_Balance_Payment__c=ap.Down_Balance_Payment__c;
                        p.Payment_Method__c=ap.Payment_Method__c;
                        p.Payment_Term__c=ap.Payment_Term__c;
                        p.Percentage__c=ap.Percentage__c;
                        p.Precise_Day__c=ap.Precise_Day__c;
                        updatePList.add(p);  
                    }
                    
                }
                system.debug('num:'+num2);
                if(num2=='0'){
                    system.debug('新的');
                    Payment__c p2 =new Payment__c();
                    p2.Order__c=orderid;
                    p2.Comments__c=ap.Comments__c;
                    p2.Credit_Valid__c=ap.Credit_Valid__c;
                    p2.Days__c=ap.Days__c;
                    p2.Down_Balance_Payment__c=ap.Down_Balance_Payment__c;
                    p2.Payment_Method__c=ap.Payment_Method__c;
                    p2.Payment_Term__c=ap.Payment_Term__c;
                    p2.Percentage__c=ap.Percentage__c;
                    p2.Precise_Day__c=ap.Precise_Day__c;
                    insertPList.add(p2);  
                }
            }
            
           
            for(Payment__c p :PLst){
                num2='0';
                for(Amendment_Payment__c ap :APLst){
                    if(String.valueOf(p.id) ==ap.ID__c){
                        system.debug('有相同付款方式');
                        num2='1';
                    }
                }
                if(num2=='0'){
                    system.debug('付款方式被删除了');
                    deletePList.add(p);
                }
            }
            delete deletePList;
             update updatePList;
            insert insertPList;
        }
        
        
        
        
        
        
        
        //
        
    }
    
}