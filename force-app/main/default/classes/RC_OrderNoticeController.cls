public class RC_OrderNoticeController {
    public Date tod{get;set;}
    public Agreement__c order{get;set;}
    public String requestId{get;set;}
    public List<Agreement_Component__c> orderItemList  {get;set;}//当前订单下产品明细
    public Agreement_Component__c oi{get;set;}
    
    public RC_OrderNoticeController(ApexPages.StandardController stdController) {
        orderItemList  = new List<Agreement_Component__c>();
        tod = Date.today(); 
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId !=null){
            System.debug('requestId---------->'+requestId);
            order = [Select id,
                     Normal__c,
                     Special__c,
                     Special_Approvals__c,
                     Intercompany_Seller_POs__c,
                     Requested_supplier__c,
                     Special_Requirements__c,
                     Shipping_type__c ,
                     Contract_No__c,
                     SAP_Order_ID__c,
                     Contract_Owner__c,
                     SELLER__c,
                     Destination__c,
                     PMC_confirm__c,
                     Warranty_Insurance__c,
                     Actual_Sales__c,
                     Actual_Sales__r.Name,
                     Actual_Sales__r.Region__c,
                     Actual_Sales__r.BMO_specialist__c,	
                     Destination_Region__c,
                     Total_Power_MW__c,
                     Total_Quantity__c,                     
                     Other__c,
                     Account__r.Name,
                     Trade_term__c,
                     Destination_Country__c,
                     Destination_Port__c,
					 Actual_Sales_Name__c                      
                     From Agreement__c
                     Where id =: requestId];
        }
        //CsvStr cs = new CsvStr();
        //order.Other__c = cs.convertString(order.Other__c, 100);
        if(requestId != null){
            orderItemList = Database.query( Utils.MakeSelectSql('Agreement_Component__c')+' WHERE Agreement__c =: requestId');
        }
        /*else{
            orderItemList.add(new Agreement_Component__c(Agreement__c   = requestId,
                                            Quantity__c  = 0,
                                            Sales_Price__c = 0,
                                            Guaranteed_Delivery_Date__c = Date.today()));
        }*/
    }
}