public class OrderItemHelper {
    public static void setRowNo(List<OrderItem> Items){
        Set<ID> IDs = new Set<ID> ();
        for(OrderItem item :Items){
            Ids.add(item.OrderId);
        }
        List<Order> Orders = [select id ,MaxRowNo__c,(select id,OrderId,RowNo__c from OrderItems)from Order where id in:IDs];
                    system.debug('order-->'+Orders);
        for(Order o:Orders){
            o.MaxRowNo__c = 0;
            for(OrderItem item :o.OrderItems){
                if(item.RowNo__c> o.MaxRowNo__c){
                    o.MaxRowNo__c = item.RowNo__c;
                }
            }
        }
        Map<id,Order> OrderMap = new Map<id,Order>(Orders);        
        for(OrderItem item :Items){
            Order o = OrderMap.get(item.OrderId);
            system.debug('o-->'+o);
            if(o.MaxRowNo__c!=null){
            o.MaxRowNo__c += 10;

            item.RowNo__c = o.MaxRowNo__c;
                            }
        }
    }

}