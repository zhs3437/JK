global class  CloneAmentOrderProduct {
    webservice static String submit(List<Id> Ids){
		String str=AddProduct(Ids);
        return str;
	}
    
    public Static String AddProduct(List<Id> Ids){
        try{
             List<Amendment_Order_Product__c> aopList = new List<Amendment_Order_Product__c>();
        aopList =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                            'Where id in: Ids');
        List<Amendment_Order_Product__c> CloneAopList = new List<Amendment_Order_Product__c>();
        if(aopList.size()>0){
            for(Amendment_Order_Product__c aop :aopList){
                Amendment_Order_Product__c  newaop =new Amendment_Order_Product__c();
                 newaop.CurrencyIsoCode=aop.CurrencyIsoCode;
            newaop.ID__c=aop.ID__c; 
            newaop.AvailableQuantity__c=aop.AvailableQuantity__c;
            newaop.Battery_Type__c=aop.Battery_Type__c;
            newaop.Bus_bars_of_cell__c=aop.Bus_bars_of_cell__c;
            newaop.Certification__c=aop.Certification__c;
            newaop.Color_of_frame_and_backsheet__c=aop.Color_of_frame_and_backsheet__c;
            newaop.Connector__c=aop.Connector__c;
            newaop.EndDate__c=aop.EndDate__c;
            newaop.Expected_delivery_date__c=aop.Expected_delivery_date__c;
            newaop.Grade__c=aop.Grade__c;
            newaop.Guaranteed_Delivery_Date__c=aop.Guaranteed_Delivery_Date__c;
            newaop.Guaranteed_Delivery_Date_japan__c=aop.Guaranteed_Delivery_Date_japan__c;
            newaop.Guaranteed_ETD__c=aop.Guaranteed_ETD__c;
            newaop.Guaranteed_Ex_work_date__c=aop.Guaranteed_Ex_work_date__c;
            newaop.ISTBD__c=aop.ISTBD__c;
            newaop.Length_of_Junction_Box_wiring__c=aop.Length_of_Junction_Box_wiring__c;
            newaop.Description__c=aop.Description__c;
            newaop.ListPrice__c=aop.ListPrice__c;
            newaop.M_P__c=aop.M_P__c;
            newaop.MaterielNo__c=aop.MaterielNo__c;
            newaop.Order__c=aop.Order__c;
            newaop.Product2__c=aop.Product2__c;
            newaop.Product_Code__c=aop.Product_Code__c;
            newaop.Quantity__c=aop.Quantity__c;
            newaop.QuoteLineItem__c=aop.QuoteLineItem__c;
            newaop.Remarks__c=aop.Remarks__c;
            newaop.Request_No__c=aop.Request_No__c;
            newaop.Requested_Goods_Ready_date__c=aop.Requested_Goods_Ready_date__c;
            newaop.SAP_Product_Materiel_No__c=aop.SAP_Product_Materiel_No__c;
            newaop.Special_required__c=aop.Special_required__c;
            newaop.ServiceDate__c=aop.ServiceDate__c;
            newaop.Total_MW__c=aop.Total_MW__c;
            newaop.total_Price__c=aop.Total_Price__c;
            newaop.UnitPrice__c=aop.UnitPrice__c;
            newaop.Type_of_module__c=aop.Type_of_module__c;
            newaop.unit_Price__c=aop.Unit_Price__c;
            newaop.unit_Price__c=aop.Unit_Price__c;
            newaop.OriginalOrderItem__c =aop.OriginalOrderItem__c;
                CloneAopList.add(newaop);
            }
        }
        if(CloneAopList.size()>0){
            insert CloneAopList;
        }
            return 'Successful';
        }catch(Exception EX){
             return 'fild';
        }
       
    }

}