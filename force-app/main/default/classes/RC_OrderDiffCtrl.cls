public without sharing class RC_OrderDiffCtrl {
    public history historyDetail{get;set;}
    public List<productHistory> productHistoryDetailList{get;set;}
    public String requestId{get;set;}

    public class history{
        public Agreement__c iOrderDetail{get;set;}
        public Amendment_Agreement__c iAmendmentAgreementDetail{get;set;}
    }

    public class productHistory{
        public Agreement_Component__c iOrderProductDetail{get;set;}
        public Amendment_Agreement_Product__c iAmendmentAgreementProductDetail{get;set;}
    }

    public RC_OrderDiffCtrl(ApexPages.StandardController sd){
        List<Agreement__c> iOrderList = new List<Agreement__c>();
        List<Amendment_Agreement__c> iAmendmentAgreementList = new List<Amendment_Agreement__c>();
        List<Agreement_Component__c> iOrderProductList = new List<Agreement_Component__c>();
        List<Amendment_Agreement_Product__c> iAmendmentAgreementProductList = new List<Amendment_Agreement_Product__c>();

        requestId = ApexPages.currentPage().getParameters().get('id');

        if (requestId == null) return;
        iAmendmentAgreementList = [SELECT Id, Account__c, Contract_NO__c, 
                                     Trade_Term__c, Installation_Type__c, 
                                     Destination_Country__c, Destination_Region__c, Destination_Port__c,
                                     Seller__c, Warranty_Insurance__c, Warranty_On_Material_and_Workmanship__c, 
                                     Reason_of_apply_for_insurance__c, Inventory_Type__c, 
                                     Discount__c, Discount_Type__c, Commission__c, Commission_Type__c, 
                                     Rebate__c, Rebate_Type__c, Bank_Info__c, 
                                     Special__c, Special_Approvals__c, Intercompany_Seller_POs__c, 
                                     Other__c, Tax_Rate__c, Payment_Term_Description__c, 
                                     Normal__c, Special_Requirements__c, Requested_supplier__c, 
                                     PMC_confirm__c, Transit_Fees__c, Bank_Information_Content__c, Agreement__c
                                     FROM Amendment_Agreement__c 
                                     WHERE Id = :requestId];

        if (iAmendmentAgreementList.size() == 0) return;
        iOrderList = [SELECT Id, Account__c, Contract_NO__c, 
                        Trade_Term__c, Installation_Type__c, 
                        Destination_Country__c, Destination_Region__c, Destination_Port__c,
                        Seller__c, Warranty_Insurance__c, Warranty_On_Material_and_Workmanship__c, 
                        Reason_of_apply_for_insurance__c, Inventory_Type__c, 
                        Discount__c, Discount_Type__c, Commission__c, Commission_Type__c, 
                        Rebate__c, Rebate_Type__c, Bank_Info__c, 
                        Special__c, Special_Approvals__c, Intercompany_Seller_POs__c, 
                        Other__c, Tax_Rate__c, Payment_Term_Description__c, 
                        Normal__c, Special_Requirements__c, Requested_supplier__c, 
                        PMC_confirm__c, Transit_Fees__c, Bank_Information_Content__c
                        FROM Agreement__c
                        WHERE Id = :iAmendmentAgreementList[0].Agreement__c];
        // if ()
        iAmendmentAgreementProductList = [SELECT Id, Name, Quantity__c,Battery_Line__c,Power_W__c,Total_Power_W__c,Guaranteed_Delivery_Date__c,
                                                Total_MW_Individual_Product__c,Guaranteed_Delivery_Date_By_Quarter__c,Product_Series__c,
                                                Goods_Description__c,Weight__c,Opp_Description__c,Agreement__c,Amendment_Agreement__c,
                                                Sales_Price__c,Total_Price__c,FOB_Sales_Price__c,Sales_Price_Another__c,Dimensions__c,Number_Of_Cells__c,
                                                Frame_B_Side_Height__c,Free_Power_W__c,Transfer_Stock_Rate__c,Third_Party_Test_Cost__c,
                                                Special_Material_Cost_Per_W__c,Special_Material_Type__c,Special_Material__c,Product_Cost__c,
                                                Commision_Rebate_Cost_Per_W__c,Insurence_Cost_Per_W__c,Payment_Cost_Per_W__c,Freight_Cost_Per_W__c,
                                                Main_Type__c,Estimated_Gross_Margin__c,Gross_Margin_Rate__c,Total_Gross_Margin__c,Stock_Type__c,
                                                Back_Sheet__c,Frame_Color__c,Bus_Bars_Of_Cell__c,Battery_Type__c,Length_Of_Junction_Box_Wiring__c,
                                                Junction_Box_Brand__c,Connector__c,MP__c,Stock_Age__c,Cable_Length__c,Connector_Line__c,
                                                Cell_Appearance__c,Stock_Collected__c
                                            FROM Amendment_Agreement_Product__c 
                                            WHERE Amendment_Agreement__c = :iAmendmentAgreementList[0].Id];

        if (iOrderList.size() == 0) return;
        iOrderProductList = [SELECT Id,Name,Quantity__c,Power_W__c,Battery_Line__c,Total_Power_W__c,Guaranteed_Delivery_Date__c,Total_MW_Individual_Product__c,
                                    Guaranteed_Delivery_Date_By_Quarter__c,Product_Series__c,Goods_Description__c,Weight__c,Opp_Description__c,
                                    Agreement__c,Sales_Price__c,Total_Price__c,FOB_Sales_Price__c,Sales_Price_Another__c,Dimensions__c,Number_Of_Cells__c,
                                    Frame_B_Side_Height__c,Product_Cost__c,Commision_Rebate_Cost_Per_W__c,Insurence_Cost_Per_W__c,Payment_Cost_Per_W__c,
                                    Freight_Cost_Per_W__c,Main_Type__c,Estimated_Gross_Margin__c,Gross_Margin_Rate__c,Total_Gross_Margin__c,Free_Power_W__c,
                                    Transfer_Stock_Rate__c,Third_Party_Test_Cost__c,Special_Material_Cost_Per_W__c,Special_Material_Type__c,Special_Material__c,
                                    Stock_Type__c,Back_Sheet__c,Frame_Color__c,Bus_Bars_Of_Cell__c,Battery_Type__c,Length_Of_Junction_Box_Wiring__c,
                                    Junction_Box_Brand__c,Connector__c,MP__c,Stock_Age__c,Cable_Length__c,Connector_Line__c,Cell_Appearance__c,Stock_Collected__c
                             FROM Agreement_Component__c
                             WHERE Agreement__c = :iOrderList[0].Id];
                             
        System.debug('iAmendmentAgreementList------>' + iAmendmentAgreementList);
        System.debug('iOrderList------>' + iOrderList);

        historyDetail = new history();

        for (Agreement__c agreement : iOrderList) {
            historyDetail.iOrderDetail = agreement;
        }
        
        for (Amendment_Agreement__c iAmendmentAgreement : iAmendmentAgreementList) {
            historyDetail.iAmendmentAgreementDetail = iAmendmentAgreement;
        }

        Integer sizeNum;
        
        productHistoryDetailList = new List<productHistory>();

        if (iAmendmentAgreementProductList.size() > iOrderProductList.size()) {
            sizeNum = iAmendmentAgreementProductList.size();
        } else {
            sizeNum = iOrderProductList.size();
        }

        System.debug('sizeNum--------->' + sizeNum);

        for (Integer i = 0;i < sizeNum;i++){

            productHistory productHistoryDetail = new productHistory();
            
            if (i <= iOrderProductList.size()-1) {
                productHistoryDetail.iOrderProductDetail = iOrderProductList[i];
            }
            if (i <= iAmendmentAgreementProductList.size()-1) {
                productHistoryDetail.iAmendmentAgreementProductDetail = iAmendmentAgreementProductList[i];
            }
            productHistoryDetailList.add(productHistoryDetail);
        }

        System.debug('HistoryDetail.iOrderDetail----->' + HistoryDetail.iOrderDetail);
        System.debug('HistoryDetail.iAmendmentAgreementDetail----->' + HistoryDetail.iAmendmentAgreementDetail);
        System.debug('HistoryDetail----->' + HistoryDetail);
    }
}