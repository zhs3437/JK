global class OA_SyncOrderNotice {    
    webservice static String generateData(String ord){
        String result=null;
        if(ord != null){
            system.debug('开始-----------');
            system.debug('ord'+ord);
            Order order = Database.query( UtilClass.MakeSelectSql(Schema.SObjectType.Order)+' WHERE Id =: ord');
            Order orderLong=[SELECT ID,NAME,Buyer__r.Name,Contract_Owner__r.name,Contract.Inspection__c,Contract.Inspection_Description__c FROM Order WHERE id=:ord];
            OA_ponWebservicesWorkflow.PonMainInfo OaPonMainInfo=new OA_ponWebservicesWorkflow.PonMainInfo();
            if(order.Cross_Region__c==true){
                if(order.Contract_Owner__c=='005900000012G4M'){
                     OaPonMainInfo.xdr='qing.tian';
                }else if(order.Seller_Region__c=='Key Account' ||order.Seller_Region__c=='Central Asia' ){
                      OaPonMainInfo.xdr='qing.tian';
                }
               
                else{
  OaPonMainInfo.xdr='xueli.sun';                   
                }
            }else{
            OaPonMainInfo.xdr=order.OA_Contact__c;//下单人
            }
            OaPonMainInfo.xdsj=String.valueof(date.today());//下单时间
            //订单类型
            if(order.Normal__c==true){
                OaPonMainInfo.ddlx='0';
            }else if(order.Special__c==true){
                OaPonMainInfo.ddlx='1';
            }
            system.debug('String.valueOf(date.today())'+String.valueOf(date.today()));
            OaPonMainInfo.sqrq=String.valueOf(date.today());
            OaPonMainInfo.dataType='1';
            OaPonMainInfo.sapddh=order.SAP_Order_ID__c;//SAP订单号			
            OaPonMainInfo.tpsm=order.Special_Approvals__c;//Special Approvals 特批
            OaPonMainInfo.buyer=orderLong.Buyer__r.Name;//买方
            OaPonMainInfo.hth=order.Contract_No__c;//合同号
            OaPonMainInfo.xsry=orderLong.Contract_Owner__r.name;//Sales Person销售人员
            OaPonMainInfo.seller=order.SELLER__c;//卖方
            OaPonMainInfo.nbjyxx=order.Intercompany_Seller_POs__c;//Intercompany Seller &POs 内部交易信息
            OaPonMainInfo.mddqy=order.Region__c;//Destination Region目的地区域
            //Shipping Methods 运输方式
            if(order.Shipping_type__c=='Ocean transportation'){
                OaPonMainInfo.ysfs='0';                
            }else if(order.Shipping_type__c=='Land transportation' ||order.Shipping_type__c=='Railway transportation'){
                OaPonMainInfo.ysfs='1';
            }else if(order.Shipping_type__c=='Air transportation' ||order.Shipping_type__c=='Express delivery'){
                OaPonMainInfo.ysfs='2';
            }
            OaPonMainInfo.shdd=order.Destination_Port__c;//收货地址（目的港口）
            OaPonMainInfo.mytkjmysy=order.Trade_term__c;//贸易条款及术语
            OaPonMainInfo.yqghf=order.Requested_supplier__c;//Requested supplier 要求供货方
            OaPonMainInfo.qrfk=order.PMC_confirm__c;//PMC confirm/确认反馈
            OaPonMainInfo.mddgj=order.Destination_Country__c;//国家
            system.debug('国家---------'+order.Destination_Country__c);
            //1.Special Requirements 相关特殊要求
             if(orderLong.Contract.Inspection__c == '1，不需要'){
                OaPonMainInfo.xgtsyq = '1';
            }else if(orderLong.Contract.Inspection__c == '2，监造和验货'){
                OaPonMainInfo.xgtsyq = '2';
            }else if(orderLong.Contract.Inspection__c == '3，监造'){
                OaPonMainInfo.xgtsyq = '3';
            }else if(orderLong.Contract.Inspection__c == '4，验货（晶科指定）'){
                OaPonMainInfo.xgtsyq = '4';
            }else if(orderLong.Contract.Inspection__c == '5，验货（客户指定）'){
                OaPonMainInfo.xgtsyq = '5';
            }
            else if(orderLong.Contract.Inspection__c == '6，验货和监装'){
                OaPonMainInfo.xgtsyq = '6';
            }
            else if(orderLong.Contract.Inspection__c == '7，Other'){
                OaPonMainInfo.xgtsyq = '7';
            }
            /**
            if(orderLong.Contract.Inspection__c=='Need'){
                OaPonMainInfo.xgtsyq='4';
            }else if(orderLong.Contract.Inspection__c=='No Need'){
                OaPonMainInfo.xgtsyq='5';
            }
**/
            OaPonMainInfo.xgtsyqsr=orderLong.Contract.Inspection_Description__c;//相关特殊要求-输入
            //OaPonMainInfo.bx=;//Warranty Insurance (保险）
            if(order.Warranty_Insurance__c=='No Insurance Required'){
                OaPonMainInfo.bx='NONE';
            }else if(order.Warranty_Insurance__c=='PG'){
                 OaPonMainInfo.bx='PG';
            }else if(order.Warranty_Insurance__c=='AR'){
                OaPonMainInfo.bx='AR';
            }
            OaPonMainInfo.qt=order.Other__c;//3.Other 其他
            
            List<OrderItem> oi=[SELECT ID,
                                OrderId,
                                Product_Name__c,
                                MP__c,
                                Quantity,
                                Total_MW__c,
                                Requested_Goods_Ready_date__c,
                                Requested_Ex_work_date__c,
                                Requested_ETD__c,
                                Battery_Type__c,
                                Remarks__c 
                                FROM OrderItem 
                                WHERE OrderId=:ord];  
            system.debug('oi-----------'+oi.size());
            OA_ponWebservicesWorkflow oa =new OA_ponWebservicesWorkflow();
            OA_ponWebservicesWorkflow.ArrayOfPonDetailInfo oaoInfo=new OA_ponWebservicesWorkflow.ArrayOfPonDetailInfo();
            oaoInfo.PonDetailInfo =new OA_ponWebservicesWorkflow.PonDetailInfo[0];
            for(Integer i=0;i<oi.size();i++){
                OA_ponWebservicesWorkflow.PonDetailInfo OaPonDetailInfo=new OA_ponWebservicesWorkflow.PonDetailInfo();
                OaPonDetailInfo.product = oi[i].Product_Name__c;
                OaPonDetailInfo.type_x=String.valueOf(oi[i].MP__c);
                OaPonDetailInfo.PCS=String.valueOf(oi[i].Quantity);
                OaPonDetailInfo.MW=String.valueOf(oi[i].Total_MW__c);
                OaPonDetailInfo.YQHHRQ=String.valueOf(oi[i].Requested_Goods_Ready_date__c);
                OaPonDetailInfo.YQLCRQ=String.valueOf(oi[i].Requested_Ex_work_date__c);
                OaPonDetailInfo.ETDYQ=String.valueOf(oi[i].Requested_ETD__c);
                OaPonDetailInfo.BZ=String.valueOf(oi[i].Remarks__c);               
            	 OaPonDetailInfo.dcplx=String.valueOf(oi[i].Battery_Type__c);            
                oaoInfo.PonDetailInfo.add(OaPonDetailInfo);
                system.debug('i--------'+i);
            }
            system.debug('PonDetailInfo---------'+oaoInfo.PonDetailInfo.size());
            system.debug('PonDetailInfo---------'+oaoInfo.PonDetailInfo[0].dcplx);
            //oaoInfo.PonDetailInfo=oaa;
            OA_ponserviceServices OAponservice=new OA_ponserviceServices();
            boolean lock;
            OA_ponserviceServices.createPonWorkflowResponse_element ocet =new OA_ponserviceServices.createPonWorkflowResponse_element();
            ocet.out='Success';
            OA_ponserviceServices.createPonWorkflow_element oce=new OA_ponserviceServices.createPonWorkflow_element();
            oce.in0=OaPonMainInfo;
            system.debug('国家========='+oce.in0.mddgj);
            oce.in1=oaoInfo;   	
            OA_ponserviceServices.PonServiceHttpPort opp=new OA_ponserviceServices.PonServiceHttpPort();
  
                result = opp.createPonWorkflow(oce.in0,oce.in1);
            
            order.OA_Notice_NO__c=result;
            lock=order.Lock__c;
            order.Lock__c=false;
            update order;
            order.Lock__c=lock;
            update order;
            	
        }        
        return result;
    }
}