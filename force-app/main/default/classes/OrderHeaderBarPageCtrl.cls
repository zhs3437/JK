public class OrderHeaderBarPageCtrl {
    public boolean getSapProductCode {get;set;}
    public Order ord {get;set;}
    private String ordId;
    public OrderHeaderBarPageCtrl(apexpages.StandardController std){
        System.debug('-------->hasNoProductCode()' + hasNoProductCode());
        ordId = ApexPages.currentPage().getParameters().get('id');
        ord = [select id,Buyer__r.SAP_External_ID__c from Order where id =:ordId];
        initHeaderBar();
    }
    private void initHeaderBar(){
        try{
            getSapProductCode = false;
            System.debug('-------->getSapProductCode' + getSapProductCode);

            if(hasNoProductCode()){
                getSapProductCode = true;
                System.debug('----->getSapProductCode:'+ getSapProductCode);
            }
            
        }catch(exception e){
            System.debug('########e: ' + String.valueOf(e));
        }
    }
    
    public boolean hasNoProductCode(){
		List<OrderItem>  itemList = [select id
                                     		,SAP_Materiel_No__c
                                     		,Quantity
                                            from OrderItem
                                            where Orderid =: ordId];
        
        for(OrderItem item : itemList){
            if(!InventoryHelper.getSAPproductCodeOrder(ordId)){
                return true;
            }
        }
        return false;
    }
	
}