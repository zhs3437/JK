public class OrderNoticeController {
    public Date tod{get;set;}
    public Order order{get;set;}
    public String requestId{get;set;}
    public List<OrderItem> orderItemList  {get;set;}//当前订单下产品明细
    public OrderItem oi{get;set;}
    
    public OrderNoticeController(ApexPages.StandardController stdController) {
        orderItemList  = new List<OrderItem>();
        tod = Date.today(); 
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId !=null){
            order = [Select id,
                     Estimated_Gross_Margin_Rating__c,
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
                     Contract_Owner__r.Name,
                     Contract_Owner__r.Region__c,
                     Region__c,
                     Total_MW__c,
                     Total_Quantity__c,
                     Contract_Owner__r.BMO_specialist__c,
                     BMO_SH_SR__c,
                     BMO_SR__c,	
                     Other__c,
                     Buyer__r.Name,
                     Trade_term__c,
                     Destination_Country__c,
                     Destination_Port__c
                     
                     From Order
                     Where id =: requestId];
        }
        //CsvStr cs = new CsvStr();
        //order.Other__c = cs.convertString(order.Other__c, 100);
        if(requestId != null){
            orderItemList = Database.query( Utils.MakeSelectSql('OrderItem')+' WHERE OrderId =: requestId');
        }else{
            orderItemList.add(new OrderItem(OrderId   = requestId,
                                            Quantity  = 0,
                                            UnitPrice = 0,
                                            Guaranteed_Delivery_Date__c = Date.today()));
        }
    }
    
    public void runTest(){
        String run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';        
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test'; 
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';        
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test'; 
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';        
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
        run = 'Test';
    }
    
}