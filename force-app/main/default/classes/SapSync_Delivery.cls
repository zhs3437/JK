public class SapSync_Delivery {
   
    Order ord = new Order();
    
    public List<Log__c> lst_log {get;set;}
    
    // structure
    public SapSync_Delivery(){
    }
    
    // generate basic data
    public void generateData(Order ord){
        this.ord = ord;
    }
    
  
    public void sync(){
        
        // init - log for recording every integration call
        Log__c log = new Log__c();
        
        try{
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'Delivery';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
            
            // tool
            sapDelivery.ZSDO0054A tool                = new sapDelivery.ZSDO0054A();//函数类
           // sapDelivery.ZSD0054A tool                = new sapDelivery.ZSD0054A();//函数类
            sapDelivery.ZSDO0054Response_element result = new sapDelivery.ZSDO0054Response_element();//结果集
            sapDelivery.TABLE_OF_ZSDO0054 IT_ZSDO0054   = new sapDelivery.TABLE_OF_ZSDO0054();//传递参数 - Delivery List
         //	sapDelivery.TABLE_OF_ZSVBELN_VA IT_SALES_ORDER   = new sapDelivery.TABLE_OF_ZSVBELN_VA();//传递参数 - 当前订单SAP号
            sapDelivery.TABLE_OF_ZSVBELN_VA	IT_SALES_ORDER		= new sapDelivery.TABLE_OF_ZSVBELN_VA();//数组，存放SAP订单号    
            IT_SALES_ORDER.item										= new sapDelivery.ZSVBELN_VA[2000];  //记录条目
            system.debug('========result: ' + result);
        //    sapDelivery.ZSVBELN_VA IT_ZSVBELN_VA =new  sapDelivery.ZSVBELN_VA();
            sapDelivery.ZSVBELN_VA item  = new sapDelivery.ZSVBELN_VA();
            item.VBELN = ord.SAP_Order_ID__c;
            IT_SALES_ORDER.item.add(item);
           // IT_ZSVBELN_VA.VBELN = ord.SAP_Order_ID__c;
          //  String OR_VBELN = ord.SAP_Order_ID__c;//当前订单SAP号
          //  system.debug('========SAPOrdNo: ' + OR_VBELN);
            // delivery list
            List<Delivery__c> deliveryList = new List<Delivery__c>();
            
            // get delivery and generate crm delivery
            
            //result = tool.ZSD0054C(IT_ZSDO0054, OR_VBELN);
            result = tool.ZSDO0054(IT_SALES_ORDER,IT_ZSDO0054); 
            system.debug('========result.IT_ZSDO0054.item.size(): ' + result.IT_ZSDO0054.item.size());
            system.debug('========result: ' + result);
            /*
            List<Delivery__c> currentDelivery = [SELECT ID,SAP_Delivery_No__c,Order__c,Invoice_No__c,Delivery_Date__c,Material_No__c,Product_Name__c,Quantity__c,SAP_Factory__c FROM Delivery__c WHERE Order__c =: ord.Id];
            system.debug('=====currentDeliverySize' + currentDelivery.size());
            system.debug('=====currentDelivery' + currentDelivery);
            */
            if(result.IT_ZSDO0054.item.size() > 0){
            	// has result - generate crm delivery
            	
            	for(sapDelivery.ZSDO0054 sapDelivery : result.IT_ZSDO0054.item){                    
            		if(sapDelivery != null && sapDelivery.VBELN != ''){
            			
            			System.debug('*************** sap delivery:  '+sapDelivery);
            			
            			// generate delivery
            			Delivery__c delivery         = new Delivery__c();
            			delivery.SAP_Delivery_No__c  = sapDelivery.VBELN;//Delivery Order No
            			if([SELECT ID FROM OrderItem WHERE ID =: sapDelivery.ZCRMNO].size()>0)delivery.Order_Product__c = sapDelivery.ZCRMNO;//Delivery Order No
            			delivery.Delivery_Date__c    = Date.valueOf(sapDelivery.WADAT_IST);//Delivery Date
            			delivery.Invoice_No__c       = sapDelivery.ZZ_IVCNO;//Invoice No
            			delivery.Material_No__c      = sapDelivery.MATNR;//Material No
            			delivery.Product_Name__c     = sapDelivery.MAKTX;//Product Name
            			delivery.Quantity__c         = Integer.valueOf(sapDelivery.LFIMG);//已交货数量
            			delivery.SAP_Factory__c      = sapDelivery.WERKS;//SAP工厂编码
            			if(delivery.Quantity__c > 0)delivery.Status__c = 'Delivered';//发货状态
                        delivery.Contract_No__c		 = ord.ContractId;
                        delivery.Opportunity__c		 = ord.Opportunity__c;
                        delivery.Contract_Owner__c	 = ord.Contract_Owner__c;
                        delivery.Opportunity_Owner__c= ord.Opportunity__r.OwnerId;
            			delivery.Order__c            = ord.Id;//订单ID
                                                
                        deliveryList.add(delivery);
                        /*
                        if(currentDelivery.size()!=0){
                            for(Delivery__c d : currentDelivery){
                                system.debug('====d.SAP_Delivery_No__c' + d.SAP_Delivery_No__c);
                                system.debug('====sapDelivery.VBELN' + sapDelivery.VBELN);
                                if(!(d.SAP_Delivery_No__c == sapDelivery.VBELN && 
                                   d.Invoice_No__c == sapDelivery.ZZ_IVCNO && 
                                   d.Material_No__c == sapDelivery.MATNR && 
                                   d.Product_Name__c == sapDelivery.MAKTX && 
                                   d.Quantity__c == Integer.valueOf(sapDelivery.LFIMG) && 
                                   d.SAP_Factory__c == sapDelivery.WERKS && 
                                   d.Delivery_Date__c == Date.valueOf(sapDelivery.WADAT_IST))){
                                    deliveryList.add(delivery);
                                    system.debug('====不相等deliveryListSize: ' + deliveryList.size());
                                    system.debug('====不相等deliveryList: ' + deliveryList);   
                                }
                            }  
                        }else{                            
                            deliveryList.add(delivery);  
                            system.debug('====等于0：' + deliveryList.size());
                        }
						*/
            		}
            	}
            }
            
            // dml - delete
            List<Delivery__c> deleteDelivery = [SELECT ID FROM Delivery__c WHERE Order__c =: ord.Id];
            system.debug('======delete: ' + deleteDelivery.size());
            system.debug('======delete: ' + deleteDelivery);
            if(deleteDelivery.size()>0)delete deleteDelivery;
		          
            
            system.debug('======insert: ' + deliveryList.size());
            system.debug('======insert: ' + deliveryList);
            // dml - insert
            if(deliveryList.size()>0)insert deliveryList; 
                
            // result
            System.debug('############## result msg:  '+result.MAGESS);
            
            if(result.MAGESS == ''){
            	for(Delivery__c delivery : deliveryList){
            		log.SuccessIDs__c += 'delivery sync: '+ delivery.Id + ' & sap delivery id: ' + delivery.SAP_Delivery_No__c + '/';
                	log.SuccessCount__c++;
            	}
            }else{
            	log.FailureIDs__c += 'order sync failed : '+ ord.Id + '/';
                log.SAP_Error_Message__c += result.MAGESS;
            }
            
        }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
        }
        
        SapTools.uploadLogList.add(log);
        
    }

}