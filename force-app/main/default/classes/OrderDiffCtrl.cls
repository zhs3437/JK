public without sharing class OrderDiffCtrl {
    public String requestId{get;set;}
            public Integer bankold{get;set;}
        public Integer banknew{get;set;}
    public List<History> HistoryList{get;set;}
    public class History{
        public Integer ApprovalNumbers{get;set;}
        public Double DiffMW{get;set;}
        public Double DiffPow{get;set;}
        public Double DiffPrice{get;set;}
        public Integer DiffQuantity{get;set;}

        public Double DiffCommision{get;set;}
        public List<Order_Differences__c> orderDiffLst{get;set;}
        public List<OrderItem_Difference__c> orderLinDiffLst{get;set;}
        public List<PaymentDifference__c> payDiffLst{get;set;}
        public Order_Differences__c orderdiff{get;set;}
        public History(){
            ApprovalNumbers = 0;
            orderDiffLst = new List<Order_Differences__c>();
            orderLinDiffLst = new List<OrderItem_Difference__c>();
            payDiffLst =new  List<PaymentDifference__c>();
            orderdiff   = new Order_Differences__c();
        }
        public void add(Order_Differences__c orderd){
            orderDiffLst.add(orderd);
            orderdiff = orderd;
        }
        public void addOrderlinDiff(OrderItem_Difference__c orderlinDiff){
            orderLinDiffLst.add(orderlinDiff);
        }
        public void addpayDiff(PaymentDifference__c paydiff){
            payDiffLst.add(paydiff);
        }
    } 
    public Double DiffMW{get;set;}
    public Double DiffPow{get;set;}
    public Double DiffPrice{get;set;}
    public Integer DiffQuantity{get;set;}
    public Double DiffCommision{get;set;}
    public List<PaymentDifference__c> payDiffLst{get;set;}
    public List<Order_Differences__c> orderDiffLst{get;set;} 
    public List<OrderItem_Difference__c> orderLinDiffLst{get;set;}
    public OrderDiffCtrl(ApexPages.StandardController sd){
        system.debug('##进入差异比较##');
        requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('requestId-->'+requestId);
        system.debug('##进入搜索对象##');
        Set<Id> orderDiffID = new  Set<Id>(); 
        if(requestId !=null){
            orderDiffLst =[Select id,ApprovalNumbers__c,Contract_PO_PI_Owner_New__r.name,Contract_PO_PI_No_Old__c,Supply_By_Old__c,Supply_By_New__c,Actual_Sales_Name_New__c,Contract_PO_PI_No_New__c,Opportunity_New__r.name,Account_Name_New__r.name,SAP_User_ID_New__c,Account_Name_Old__r.name,Opportunity_Old__r.name,Actual_Sales_Name_Old__c,Contract_PO_PI_Owner_Old__r.name,Destination_Country_New__c,Commission_New__c,Commission_Old__c,Destination_Country_Old__c,SELLER_New__c,DiffMW__c,DiffPrice__c,DiffQuantity__c,
                           SELLER_Old__c,SAP_User_ID_Old__c,BillingCity_New__c,Payment_Term_Description_New__c,Payment_Term_Description_Old__c,BillingPostalCode_New__c,BillingPostalCode_Old__c,Bank_Information_Content_New__c,Bank_Information_Content_Old__c,BillingCity_Old__c,Bank_Street_New__c,Bank_Street_Old__c,Email_New__c,BillingState_New__c,BillingState_Old__c,BillingCountry_New__c,BillingCountry_Old__c,Authorized_Representative_New__c,Authorized_Representative_Old__c,Title_New__c,Title_Old__c,Email_Old__c,Total_MW_New__c,Fax_New__c,Fax_Old__c,Phone_New__c,Customer_Business_Scale_New__c,Customer_Business_Scale_Old__c,Phone_Old__c,Customer_country_New__c,Customer_country_Old__c,Contact_Name_New__c,Contact_Name_Old__c,Transit_Fees_New__c,Transit_Fees_Old__c,Tax_Rate_New__c,Tax_Rate_Old__c,PMC_confirm_New__c,PMC_confirm_Old__c,Other_New__c,Other_Old__c,Special_Approvals_Old__c,Requested_supplier_New__c,Requested_supplier_Old__c,Intercompany_Seller_POs_New__c,Intercompany_Seller_POs_Old__c,Special_Approvals_New__c,Special_Requirements_New__c,Special_Requirements_Old__c,Special_New__c,Special_Old__c,Normal_Old__c,Normal_New__c,BMO_SH_New__c,BMO_SR_New__c,BMO_SR_Old__c,BMO_SH_Old__c,GST_Classification_Region_New__c,GST_Classification_Region_Old__c,Commission_Type_New__c,Commission_Type_Old__c,VAT_NO_New__c,VAT_NO_Old__c,Commission_Value_sync_to_SAP_New__c,Commission_Value_sync_to_SAP_Old__c,Customer_Order_Reference_PO_New__c,Customer_Order_Reference_PO_Old__c,Warranty_On_Material_and_Workmanship_New__c,Warranty_On_Material_and_Workmanship_Old__c,Total_MW_Old__c,Region_New__c,Region_Old__c,Warranty_Insurance_New__c,Warranty_Insurance_Old__c,Shipping_type_New__c,Shipping_type_Old__c,Destination_New__c,Destination_Old__c,Factory_WH_New__c,Factory_WH_Old__c,Buyer_Old__r.name,Order_Start_Date_New__c,Order_Start_Date_Old__c,Total_Price_New__c,Total_Price_Old__c,Total_Quantity_New__c,Total_Quantity_Old__c,Status_New__c,Status_Old__c,Buyer_New__r.name,
                           Trade_term_New__c,Discount_New__c,Discount_old__c,Rebate_New__c,Rebate_old__c,Trade_term_Old__c from Order_Differences__c where Amendment_Purchase_Agreement__c=:requestId
                           ORDER by ApprovalNumbers__c DESC];
            system.debug('orderDiffLst.size()-->'+orderDiffLst.size());
            
            for(Order_Differences__c odf :orderDiffLst){
                odf.Total_Price_New__c=odf.Total_Price_New__c*100/100;
            }
            if(orderDiffLst.size()>0){    
                HistoryList = new List<History>();
                History h = new History();
                for(Order_Differences__c orderdd : orderDiffLst){
                    orderDiffID.add(orderdd.Id);
                    if(orderdd.Bank_Information_Content_Old__c!=null && orderdd.Bank_Information_Content_new__c!=null){
                    bankold=orderdd.Bank_Information_Content_Old__c.length();
                    banknew=orderdd.Bank_Information_Content_new__c.length();
                        }
                    if(Integer.valueOf(orderdd.ApprovalNumbers__c) != h.ApprovalNumbers){
                        h = new History();
                        h.ApprovalNumbers = Integer.valueOf(orderdd.ApprovalNumbers__c);
                        System.debug(' h.ApprovalNumbers-->'+ h.ApprovalNumbers);
                        HistoryList.add(h);
                    }
                    DiffMW = orderdd.DiffMW__c;
                    DiffPrice =orderdd.DiffPrice__c;
                    DiffQuantity =Integer.valueOf(orderdd.DiffQuantity__c);
                    h.DiffMW = DiffMW;       
                    h.DiffPrice = DiffPrice;       
                    h.DiffQuantity = DiffQuantity; 
                    h.add(orderdd);
                }
                if(orderDiffID.size()>0){
                    orderLinDiffLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem_Difference__c) + ' ' +
                                                    'where Order_Differences__c in: orderDiffID');
                    if(orderLinDiffLst.size()>0){
                        for(OrderItem_Difference__c orderLinDiff : orderLinDiffLst){
                            for(History h1 : HistoryList){
                                if(Integer.valueOf(orderLinDiff.ApprovalNumbers__c) == h1.ApprovalNumbers){
                                    h1.addOrderlinDiff(orderLinDiff);
                                }
                            }
                            
                        }
                    }
                    
                    payDiffLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.PaymentDifference__c) + ' ' +
                                               'where Order_Differences__c in: orderDiffID');
                    if(payDiffLst.size()>0){
                        for(PaymentDifference__c paydiff : payDiffLst){
                            for(History h1 : HistoryList){
                                if(Integer.valueOf(paydiff.ApprovalNumbers__c) == h1.ApprovalNumbers){
                                    h1.addpayDiff(paydiff);
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
}