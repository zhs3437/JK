global with sharing class OrderDiffListCtrl{ 
    global string requestId{get;set;}
    
    
    global List<Order_Differences__c> orderDiffLst{
        get{
            return [Select id,ApprovalNumbers__c,Contract_PO_PI_Owner_New__r.name,Contract_PO_PI_No_Old__c,Supply_By_Old__c,Supply_By_New__c,Actual_Sales_Name_New__c,Contract_PO_PI_No_New__c,Opportunity_New__r.name,Account_Name_New__r.name,SAP_User_ID_New__c,Account_Name_Old__r.name,Opportunity_Old__r.name,Actual_Sales_Name_Old__c,Contract_PO_PI_Owner_Old__r.name,Destination_Country_New__c,Commission_New__c,Commission_Old__c,Destination_Country_Old__c,SELLER_New__c,DiffMW__c,DiffPrice__c,DiffQuantity__c,
                    SELLER_Old__c,SAP_User_ID_Old__c,BillingCity_New__c,Payment_Term_Description_New__c,Payment_Term_Description_Old__c,BillingPostalCode_New__c,BillingPostalCode_Old__c,Bank_Information_Content_New__c,Bank_Information_Content_Old__c,BillingCity_Old__c,Bank_Street_New__c,Bank_Street_Old__c,Email_New__c,BillingState_New__c,BillingState_Old__c,BillingCountry_New__c,BillingCountry_Old__c,Authorized_Representative_New__c,Authorized_Representative_Old__c,Title_New__c,Title_Old__c,Email_Old__c,Total_MW_New__c,Fax_New__c,Fax_Old__c,Phone_New__c,Customer_Business_Scale_New__c,Customer_Business_Scale_Old__c,Phone_Old__c,Customer_country_New__c,Customer_country_Old__c,Contact_Name_New__c,Contact_Name_Old__c,Transit_Fees_New__c,Transit_Fees_Old__c,Tax_Rate_New__c,Tax_Rate_Old__c,PMC_confirm_New__c,PMC_confirm_Old__c,Other_New__c,Other_Old__c,Special_Approvals_Old__c,Requested_supplier_New__c,Requested_supplier_Old__c,Intercompany_Seller_POs_New__c,Intercompany_Seller_POs_Old__c,Special_Approvals_New__c,Special_Requirements_New__c,Special_Requirements_Old__c,Special_New__c,Special_Old__c,Normal_Old__c,Normal_New__c,BMO_SH_New__c,BMO_SR_New__c,BMO_SR_Old__c,BMO_SH_Old__c,GST_Classification_Region_New__c,GST_Classification_Region_Old__c,Commission_Type_New__c,Commission_Type_Old__c,VAT_NO_New__c,VAT_NO_Old__c,Commission_Value_sync_to_SAP_New__c,Commission_Value_sync_to_SAP_Old__c,Customer_Order_Reference_PO_New__c,Customer_Order_Reference_PO_Old__c,Warranty_On_Material_and_Workmanship_New__c,Warranty_On_Material_and_Workmanship_Old__c,Total_MW_Old__c,Region_New__c,Region_Old__c,Warranty_Insurance_New__c,Warranty_Insurance_Old__c,Shipping_type_New__c,Shipping_type_Old__c,Destination_New__c,Destination_Old__c,Factory_WH_New__c,Factory_WH_Old__c,Buyer_Old__r.name,Order_Start_Date_New__c,Order_Start_Date_Old__c,Total_Price_New__c,Total_Price_Old__c,Total_Quantity_New__c,Total_Quantity_Old__c,Status_New__c,Status_Old__c,Buyer_New__r.name,
                    Trade_term_New__c,Trade_term_Old__c from Order_Differences__c where Amendment_Purchase_Agreement__c=:requestId
                   ];
        }
        set;
    }
    global List<OrderItem_Difference__c> orderLinDiffLst {get{
            return [select Name, ApprovalNumbers__c,Product_New__r.name,Product_Name__c,Quantity_New__c,Quantity_Old__c,Total_MW_New__c,Total_MW_Old__c,Total_Price_New__c,Total_Price_Old__c,UnitPrice_New__c,UnitPrice_Old__c,Guaranteed_Delivery_Date_New__c,Guaranteed_Delivery_Date_Old__c
           
			from OrderItem_Difference__c 
			where Order_Differences__c =:orderDiffLst[0].id 
			limit 2000];
        }
        set;
    }
    global List<PaymentDifference__c> payDiffLst {get{
            return[select 	Id,Amount_Old__c, Amount_New__c,Percentage_Old__c,Percentage_New__c,Payment_Method_Old__c,
				Payment_Method_New__c,Down_Balance_Payment_Old__c,Down_Balance_Payment_New__c,Days_Old__c,Days_New__c,
               Payment_Term_Old__c,Payment_Term_New__c
			from PaymentDifference__c
			where Order_Differences__c =:orderDiffLst[0].id  
			limit 2000];
        }
        set;
    }

}