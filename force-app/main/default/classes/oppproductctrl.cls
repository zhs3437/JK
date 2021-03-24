global with sharing  class oppproductctrl {
  global string requestId{get;set;}
        global List<opportunityLineItem> opportunityitemList{get{return [Select id,Product_name2__c,product2.name,Quantity,Guaranteed_Delivery_Date__c,unitprice from opportunityLineItem  where Opportunityid=:requestId];}
        set;
    }
}