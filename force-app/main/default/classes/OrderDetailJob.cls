global  class OrderDetailJob implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String VisitList='select id from Order';
        return Database.getQueryLocator( VisitList);
    }
    global void execute(Database.BatchableContext BC, List<Order> oilst) {
        try{
        Set<id> orderidset =new Set<id>();
        for(Order oi:oilst){
            orderidset.add(oi.id);
        }
        system.debug('所有订单数量:'+orderidset.size());
        //orderid 得到所有查询的ID
        List<OrderItem> oilstformap=[select id,Orderid,
                                     Guaranteed_Delivery_Date_by_Month__c,
                                     Quantity,
                                     UnitPrice,
                                     MP__c,
                                     Power_W__c,
                                     Product_Name__c
                                     from OrderItem  
                                     where Orderid in:orderidset ];
        system.debug('所有订单行数量:'+oilstformap.size());
        //所有 orderid 下得所有order行项目
        List<order> orderformap=[select id,BMO_SH_SR__c,Buyer__r.name,Commission__c,Contract_No__c,
                                 Contracts_RecordType__c,CurrencyIsoCode,Opportunity__r.Destination_Country__c,
                                 Opportunity__r.Region__c,DG_Market__c,Discount__c,Contract.JINKO_OEM__c,Contract.RecordType.name,
                                 Payment_Term_Description__c,Project_type__c,Rebate__c,Sales_1__c,Contract.Createddate,Contract.Get_Final_Approved_Time2__c,
                                 Sales_1_percentage__c,Sales_2__c,Sales_2_percentage__c,Sales_3__c,
                                 Sales_3_percentage__c,Opportunity__r.Sales_Region__c,ownerid,SELLER__c,Trade_term__c,
                                 Warranty_Insurance__c,Amendment_count__c,Total_MW__c,Supply_By__c,owner.name,Destination_Port__c,
                                 Contracts_Start_Date__c from order Where id in:orderidset];
        system.debug('所有订单数量1:'+orderformap.size());
        //所有 orderid 下得所有Order
        List<Delivery__c> Delstformap=[select id,Delivery_Month__c,Delivery_Status__c,Quantity__c,Order__c,Product_Name__c,Price__c from Delivery__c  
                                       where Order__c in:orderidset];
        system.debug('所有实际订单数量3:'+Delstformap.size());
        //所有 orderid 下的所有实际发货单
        
        
        map<id,list<OrderItem>> OrderItemMap =new map<id,list<OrderItem>>();
        for(id orderid:orderidset){
            List<OrderItem> oilstmap= new  List<OrderItem>();
            for(OrderItem op:oilstformap){
                if(op.Orderid==orderid){
                    oilstmap.add(op);
                }
            }
            OrderItemMap.put(orderid,oilstmap);
            //id 和订单产品 一对多关系
        }
        system.debug('OrderItemMap'+OrderItemMap);
        //关于 订单产品 MAP 完成
        
        map<id,list<Delivery__c>> DeItemMap =new map<id,list<Delivery__c>>();
        for(id orderid:orderidset){
            List<Delivery__c> delstmap= new  List<Delivery__c>();
            for(Delivery__c od:Delstformap){
                if(od.Order__c==orderid){
                    delstmap.add(od);
                }
            }
            DeItemMap.put(orderid,delstmap);
            //id 和 实际发货单 一对多关系
        }
        system.debug('DeItemMap'+DeItemMap);
        //关于 实际发货 MAP 完成
        
        map<id,list<Order>> OrderMap =new map<id,list<Order>>();
        for(id orderid:orderidset){
            List<Order> orderlstmap= new  List<Order>();
            for(Order od:orderformap){
                if(od.id==orderid){
                    orderlstmap.add(od);
                }
            }
            OrderMap.put(orderid,orderlstmap);
            // id 和订单 一对一地关系
        }
        system.debug('OrderMap'+OrderMap);
        //关于 订单 MAP 完成
        List<OrderDetail__c> Odlst =new List<OrderDetail__c>();
        system.debug('order id 数:'+orderidset);
        for(id orderid:orderidset){
            List<OrderItem> OrderItemlst =OrderItemMap.get(orderid);
            //得到一个id下 所有产品 准备合拼
            String flag='';
            map<String,Decimal> flagmap =new map<String,Decimal>();
            Set<String> flagset=new Set<String>();
            for(OrderItem oi:OrderItemlst){
                flagset.add(oi.Product_Name__c+';'+oi.Guaranteed_Delivery_Date_by_Month__c+';'+oi.UnitPrice);
                system.debug(flagset);
                if(flag.contains(oi.Product_Name__c+';'+oi.Guaranteed_Delivery_Date_by_Month__c+';'+oi.UnitPrice)){
                    flagmap.put(oi.Product_Name__c+';'+oi.Guaranteed_Delivery_Date_by_Month__c+';'+oi.UnitPrice,flagmap.get(oi.Product_Name__c+';'+oi.Guaranteed_Delivery_Date_by_Month__c+';'+oi.UnitPrice)+oi.Quantity);
                }else{
                    flag=flag+ oi.Product_Name__c+';'+oi.Guaranteed_Delivery_Date_by_Month__c+';'+oi.UnitPrice+',';
                    flagmap.put(oi.Product_Name__c+';'+oi.Guaranteed_Delivery_Date_by_Month__c+';'+oi.UnitPrice,oi.Quantity);
                }
                system.debug(flag);
            }
            system.debug('flagmap 数:'+flagmap);
            //所有已价格 产品 交期月份 分好的 值为相同 Key 的数量合
            system.debug('flagset 数:'+flagset);
            //所有已价格 产品 交期月份 分好的 ,隔开的 
            
            for(String name:flagset){
                //按照 所有 分类来配对
                Decimal Quantity = flagmap.get(name);//该情况下的 预计发货数量
                String productname =name.split(';')[0];
                String DeliveryDateByMonth =name.split(';')[1];
                String yujiprice=name.split(';')[2];
                order ord=OrderMap.get(orderid)[0];//得到 Order 信息
                OrderDetail__c od =new OrderDetail__c();
                
                od.Order__c=ord.id;
                od.BMO__c=ord.BMO_SH_SR__c;
                od.Buyer__c=ord.Buyer__r.name;
                od.Commission__c=ord.Commission__c;
                od.Contract_PO_PI_No__c=ord.Contract_No__c;
                od.Contracts_PO_PI_Record_Type__c=ord.Contract.RecordType.name;
                od.Currency__c=ord.CurrencyIsoCode;
                od.Destination_Country__c=ord.Opportunity__r.Destination_Country__c;
                od.Destionation_Region__c=ord.Opportunity__r.Region__c;
                od.DG_Market__c=ord.DG_Market__c;
                od.Discount__c=ord.Discount__c;
                od.JINKO_OEM__c=ord.Contract.JINKO_OEM__c;
                od.Payment_term__c=ord.Payment_Term_Description__c;
                od.Project_type__c=ord.Project_type__c;
                od.Rebate__c=ord.Rebate__c;
                od.Sales_1__c=ord.Sales_1__c;
                od.Sales_1_percentage__c=ord.Sales_1_percentage__c;
                od.Sales_2__c=ord.Sales_2__c;
                od.Sales_2_percentage__c=ord.Sales_2_percentage__c;
                od.Sales_3__c=ord.Sales_3__c;
                od.Sales_3_percentage__c=ord.Sales_3_percentage__c;
                od.Sales_Region__c=ord.Opportunity__r.Sales_Region__c;
                od.Sales_contract_Owner__c=ord.owner.name;
                od.SELLER__c=ord.SELLER__c;
                od.Trade_term__c=ord.Trade_term__c;
                od.Warranty_Insurance__c=ord.Warranty_Insurance__c;
                od.Amendment_count__c=ord.Amendment_count__c;
                od.Product_Name__c=productname;
                od.Delivery_Date__c=DeliveryDateByMonth;
                od.Unit_Price__c =yujiprice;
                od.Quantity__c=Quantity;
                od.Total_MW__c=ord.Total_MW__c;
                if(ord.Contract.Createddate!=null){
                od.Start_date__c=ord.Contract.Createddate.date();
                }
                if(ord.contract.Get_Final_Approved_Time2__c!=null){
                od.Sign_date__c=ord.contract.Get_Final_Approved_Time2__c.date();
                }
                od.Supply_By__c=ord.Supply_By__c;
                od.Port_destionation__c =ord.Destination_Port__c;
                List<OrderItem> orditem=OrderItemMap.get(orderid);//得到 Order products 信息
                for(OrderItem oi:orditem){
                    if(oi.Product_Name__c==productname){
                        od.Power_W__c=String.valueof(oi.Power_W__c);
                       od.M_P__c=oi.MP__c;
                    }
                }
                Odlst.add(od);
            }
        }
        
        insert Odlst;
        //生成三表合一的 预计发货的 一半信息
        system.debug('Odlst:'+Odlst);
        //三遍合一 缺少实际发货部分
        Odlst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderDetail__c) + ' ' +
                             'Where order__c in:orderidset');
        system.debug('Odlst:'+Odlst);
        Map<id,List<OrderDetail__c>> ODmap = new  Map<id,List<OrderDetail__c>>();
        for(id orderid:orderidset){
            List<OrderDetail__c> odlstmap = new List<OrderDetail__c>();
            for(OrderDetail__c od:Odlst){
                if(orderid==od.order__C){
                    odlstmap.add(od);
                }
            }
            ODmap.put(orderid,odlstmap);
            //orderid,该id下所有三遍合一 缺少实际发货部分
        }
        List<OrderDetail__c> Odlst2 =new List<OrderDetail__c>();
        List<OrderDetail__c> Odlst4 =new List<OrderDetail__c>();
        for(id orderid:orderidset){
            List<OrderDetail__c> Odlst3 =ODmap.get(orderid);
            //得到所有 该id下的所有 三表合一
            List<Delivery__c> DElst =DeItemMap.get(orderid);
            //得到实际发货准备合拼
            String flag2='';
            map<String,Decimal> flagmap2 =new map<String,Decimal>();
            Set<String> flagset2=new Set<String>();
            for(Delivery__c oi:DElst){
                flagset2.add(oi.Product_Name__c+';'+oi.Delivery_Month__c+';'+oi.Price__c+';'+oi.Delivery_Status__c);
                system.debug(flagset2);
                if(flag2.contains(oi.Product_Name__c+';'+oi.Delivery_Month__c+';'+oi.Price__c+';'+oi.Delivery_Status__c)){
                    flagmap2.put(oi.Product_Name__c+';'+oi.Delivery_Month__c+';'+oi.Price__c+';'+oi.Delivery_Status__c,flagmap2.get(oi.Product_Name__c+';'+oi.Delivery_Month__c+';'+oi.Price__c+';'+oi.Delivery_Status__c)+oi.Quantity__c);
                }else{
                    flag2=flag2+ oi.Product_Name__c+';'+oi.Delivery_Month__c+';'+oi.Price__c+';'+oi.Delivery_Status__c+',';
                    flagmap2.put(oi.Product_Name__c+';'+oi.Delivery_Month__c+';'+oi.Price__c+';'+oi.Delivery_Status__c,oi.Quantity__c);
                }
                system.debug(flag2);
            }
            system.debug('flagmap2 数:'+flagmap2);
            system.debug('flagset2 数:'+flagset2);
            
            for(String name:flagset2){
                String str='0';
                for(OrderDetail__c od:Odlst3){
                    system.debug('发货单整合数量'+flagset2.size());
                    
                    
                    Decimal Quantity;
                    Quantity = flagmap2.get(name);
                    system.debug('走进来 ALL name:'+name);
                    if(name.contains(od.Product_Name__c+';'+od.Delivery_Date__c+';'+od.Unit_Price__c)){
                       
                        if(name.contains('all')){
                            system.debug('走进来 ALL');
                        if( od.DeQuantity__c==null){
                            od.DeQuantity__c=0;
                        }
                        od.DeQuantity__c=od.DeQuantity__c+Quantity;
                            od.Status__c='all  delivered';
                        Odlst4.add(od);
                            system.debug('走进来 ALL:'+od);
                        system.debug('Odlst'+Odlst);
                        break;
                        }
                        if(name.contains('not')){
                            system.debug('走进来 NOT');
                            OrderDetail__c odclone=od.clone(false,true,false,false);
                        if( odclone.DeQuantity__c==null){
                            odclone.DeQuantity__c=0;
                          
                        }
                        odclone.DeQuantity__c=odclone.DeQuantity__c+Quantity;
                            odclone.Status__c='not delivered';
                        Odlst4.add(odclone);
                            system.debug('走进来 NOT:'+odclone); 
                        system.debug('Odlst'+Odlst);
                        break;
                        }
                    }else{
                        str='1';
                    }
                    
                }
                if(str=='1'){
                    Decimal Quantity;
                    Quantity = flagmap2.get(name);
                    system.debug('走进来 ALL name:'+name);
                    system.debug('走进来 ALL name:'+name.contains('all'));
                    order ord=OrderMap.get(orderid)[0];
                    OrderDetail__c od2 =new OrderDetail__c();
                     if(name.contains('all')){
                          od2.Status__c='all delivered';
                     }
                     if(name.contains('not')){
                     od2.Status__c='not  delivered';
                         }
                    od2.Order__c=ord.id;
                    od2.Product_Name__c=name.split(';')[0];
                    od2.Delivery_Date__c=name.split(';')[1];
                    od2.Unit_price__c=name.split(';')[2];
                    od2.DeQuantity__c=Quantity;
                    od2.BMO__c=ord.BMO_SH_SR__c;
                    od2.Buyer__c=ord.Buyer__r.name;
                    od2.Commission__c=ord.Commission__c;
                    od2.Contract_PO_PI_No__c=ord.Contract_No__c;
                    od2.Contracts_PO_PI_Record_Type__c=ord.Contract.RecordType.name;
                    od2.Currency__c=ord.CurrencyIsoCode;
                    od2.Destination_Country__c=ord.Opportunity__r.Destination_Country__c;
                    od2.Destionation_Region__c=ord.Opportunity__r.Region__c;
                    od2.DG_Market__c=ord.DG_Market__c;
                    od2.Discount__c=ord.Discount__c;
                    od2.JINKO_OEM__c=ord.Contract.JINKO_OEM__c;
                    od2.Payment_term__c=ord.Payment_Term_Description__c;
                    od2.Project_type__c=ord.Project_type__c;
                    od2.Rebate__c=ord.Rebate__c;
                    od2.Sales_1__c=ord.Sales_1__c;
                    od2.Sales_1_percentage__c=ord.Sales_1_percentage__c;
                    od2.Sales_2__c=ord.Sales_2__c;
                    od2.Sales_2_percentage__c=ord.Sales_2_percentage__c;
                    od2.Sales_3__c=ord.Sales_3__c;
                    od2.Sales_3_percentage__c=ord.Sales_3_percentage__c;
                    od2.Sales_Region__c=ord.Opportunity__r.Sales_Region__c;
                    od2.Sales_contract_Owner__c=ord.owner.name;
                    od2.SELLER__c=ord.SELLER__c;
                    od2.Trade_term__c=ord.Trade_term__c;
                    od2.Warranty_Insurance__c=ord.Warranty_Insurance__c;
                    od2.Total_MW__c=ord.Total_MW__c;
                    if(ord.Contract.Createddate!=null){
                    od2.Start_date__c=ord.Contract.Createddate.date();
                    }
                    if(ord.contract.Get_Final_Approved_Time2__c!=null){
                od2.Sign_date__c=ord.contract.Get_Final_Approved_Time2__c.date();
                    }
                    od2.Supply_By__c=ord.Supply_By__c;
                    od2.Amendment_count__c=ord.Amendment_count__c;
                      od2.Port_destionation__c =ord.Destination_Port__c;
                List<OrderItem> orditem=OrderItemMap.get(orderid);//得到 Order products 信息
                for(OrderItem oi:orditem){
                    if(oi.Product_Name__c==name.split(';')[0]){
                        od2.Power_W__c=String.valueof(oi.Power_W__c);
                       od2.M_P__c=oi.MP__c;
                    }
                }
                    Odlst2.add(od2);  
                    system.debug('Odlst2'+Odlst2.size());  
                }
            }
            
            
        }
        upsert Odlst4;
        insert Odlst2;
         }catch(Exception ex ){ System.debug('----------> '+ex.getMessage()); }
    }
    global void finish(Database.BatchableContext BC){}
}