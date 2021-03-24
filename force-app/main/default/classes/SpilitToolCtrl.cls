public class SpilitToolCtrl {
    
    public List<OrderItem> orderItemList  {get;set;}//当前订单下产品明细
    public List<OrderItem> spilitItemList {get;set;}//选择产品后的订单下明细
    public Double unitPrice {get;set;}
    public OrderItem currentItem {get;set;}
    
    public String requestId {get;set;}//当前请求订单ID
    public String requestPricebookEntryId {get;set;}//当前请求产品价格表元素ID
    public String requestItemId {get;set;}//当前请求的明细ID
    public String requestQuantity {get;set;}//需要拆分的条数
    public Integer requestNumber{get;set;}
    
    public Boolean isSpilit {get;set;}// true - 进入拆分 / false - 选择产品
    
    public SpilitToolCtrl(){
        requestId = ApexPages.currentPage().getParameters().get('id');
        isSpilit  = false;
        spilitItemList = new List<OrderItem>();
        orderItemList  = new List<OrderItem>();
    }
    
    // select exist order item
    public void modeBasicData(){
        if(requestId != null){
            orderItemList = Database.query( Utils.MakeSelectSql('OrderItem')+' WHERE OrderId =: requestId');
        }else{
            orderItemList.add(new OrderItem(OrderId   = requestId,
                                            Quantity  = 0,
                                            UnitPrice = 0,
                                            Guaranteed_Delivery_Date__c = Date.today()));
        }
    }
    
    // change spilit interview
    public void goSpilit(){
        if(requestItemId != null && requestPricebookEntryId != null){
            isSpilit = true;
            for(OrderItem item : orderItemList){
                if(item.Id == requestItemId){
                    unitPrice = item.UnitPrice;
                    spilitItemList.add(item);
                    currentItem = item;
                }
            }
        }
    }
    
    // add spilit item
    public void addItem(){
        if(requestQuantity != null && currentItem != null){
            try{
                
                if(spilitItemList.size() > 0){
                    spilitItemList = new List<OrderItem>();
                    spilitItemList.add(currentItem);
                }
                
                for(Integer i = 1 ; i < Integer.valueOf(requestQuantity) ; i++ ){
                    OrderItem item = currentItem.clone(false, true);
                    item.Quantity  = 0;
                    item.Request_No__c = i;
                    spilitItemList.add(item);
                }
            }catch(TypeException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Error Message : Please fill in integer!'));
            }
        }
    }
    
    // re select
    public void reSelect(){
        spilitItemList = new List<OrderItem>();
        isSpilit  = false;
        //currentItem = new OrderItem();
        requestQuantity = '';
    }
    
    // save items
    public void saveItems(){
        if(spilitItemList.size() > 0){
            try{
                //OrderItem firstItem = spilitItemList[0];
                for(OrderItem item : spilitItemList){
                    item.Request_No__c = null;//清空所有request no
                 //   item.RowNo__c = null;
                //  system.debug('------->:' + item);
                  system.debug('item.id--->'+item.Id); 
                    if(item.Id == null){
                        item.RowNo__c = null;
                    }
                    if(item.UnitPrice != unitPrice){
                        item.RowNo__c = null;
                    }
                }
                upsert spilitItemList;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
            }
        }
    }
    
    // remove
    public void remove(){
        if(spilitItemList.size() > 0 && requestNumber != null){
            spilitItemList.remove(requestNumber);
        }
        
        for(OrderItem item: spilitItemList){
            if(item.Request_No__c != null && item.Request_No__c > requestNumber){
                item.Request_No__c -= 1;
            }
        }
        
    }
    
}