global class SapTools {
	
    global static List<Log__c> uploadLogList = new List<Log__c>();
    
    global SapTools(){}
    
    
    global static void uploadList(){
        system.debug('start');
        try{
            system.debug('uploadLogList-->'+uploadLogList.size());
            if(uploadLogList.size()>0){
                 system.debug('insert start');
                insert uploadLogList;
                system.debug('insert successful');
                uploadLogList = new List<Log__c>();
            }
        }catch(Exception ex){
            System.debug('----------> '+ex.getMessage());
        }
    }
    // sync order 老逻辑
    webservice static String syncOrder(String orderid,String OANOTic){
    	String msg = OANOTic;
        system.debug('OA'+OANOTic);
        if(orderid != null){
        	system.debug('orderid'+orderid);
            Order ord   = Database.query( UtilClass.MakeSelectSql(Schema.SObjectType.Order)+' WHERE Id =: orderid');
            
	            // sync order
	            SapSync_Order order_tool = new SapSync_Order();
	            order_tool.generateData(ord);
	            String t=order_tool.sync(msg);
            system.debug('gogo');
            system.debug('t'+t);
	            if(order_tool.errorMsg != '')msg = order_tool.errorMsg;
	            // update account & order
	            if(ord.SAP_Order_ID__c != null && (msg == '1' || msg == '0')){
                    ord.Lock__c = false;
                    update ord;
                    ord.Lock__c = true;
            		update ord;
	            	//由于存在第一次加锁后可能没走补充协议就同步订单的可能，所以要先解锁更新后再加锁
	            	msg =t;
	            }
	            /* TBD 客户或物料订单不锁定  */
	            if(ord.BuyerSAPId__c == '1003300' || ord.ISTBD__c != 0){
	            	ord.Lock__c = false;
                    update ord;   
	            }
            uploadList();
        }else{
        	msg = 'order id is null!';
        }
        
        return msg;
    }
     // new sync order  refresh by Joel Wang
  
    // get delivery order
    webservice static void getDelivery(String orderid){
        
         if(orderid != null){
            system.debug('----->>>huidiaofahuoxinxi'); 
           	List<Order> ordLst = [Select Id,Total_Quantity__c,SAP_Order_ID__c,CreatedDate,ContractId,Opportunity__c,Contract_Owner__c,Opportunity__r.OwnerId,LastModifiedDate  
                                  From Order 
                                  Where SAP_Order_ID__c != null And id = : orderid];
            
            DeliveryUtils du = new DeliveryUtils();
            du.sync(ordLst);
            system.debug('-------->fanhuichenggong:');
           uploadList();
        }
        /**
        if(orderid != null){
            system.debug('----->>>huidiaofahuoxinxi'); 
           	Order ord   = Database.query( Utils.MakeSelectSql('Order')+' WHERE Id =: orderid');
            SapSync_Delivery delivery_tool = new SapSync_Delivery();
         
            delivery_tool.generateData(ord);
           delivery_tool.sync();
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
        }
          */
    }
    
     webservice static void getCompleteStatus(String CompleteStatusid){
        if(CompleteStatusid != null){
         if(!Test.isRunningTest()){
                     }
           	List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c')+' WHERE Apply_Inventory__c =: CompleteStatusid');
            SapSync_CompleteStatus CompleteStatus_tool = new  SapSync_CompleteStatus();
         
            //delivery_tool.generateData(ord);
            system.debug('start CompleteStatus_tool');
        
           CompleteStatus_tool.sync(syncDisStockLst);
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
        }
    }
    
      webservice static void getWareHouseChange(String WareHouseid){
        if(WareHouseid != null){
        
           	List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c')+' WHERE Apply_Inventory__c =: WareHouseid');
            SapSync_ChangeWareHouse WareHouseChange_tool = new  SapSync_ChangeWareHouse();
         
            //delivery_tool.generateData(ord);
            system.debug('start CompleteStatus_tool');
        
           WareHouseChange_tool.sync(syncDisStockLst);
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
        }
    }
    
     webservice static String getSAPCreateDN(String CreateDNId){
        if(CreateDNId != null){
        
           	List<OrderItem>  orderItemLst  = [Select Id,Quantity,SAP_Materiel_No__c,Product_Name__c,SAP_Product_Materiel_No__r.Name,SAP_Product_Materiel_No__r.Product_Code__c,Guaranteed_Delivery_Date__c,OrderID,RowNo__c from OrderItem where OrderID =:CreateDNId];
           	List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c')+' WHERE Order__c =: CreateDNId');
            SapSync_CreateDn CreateDN_tool = new  SapSync_CreateDn();
          List<SapEccCreateDn.CreateDnReturn_element> returnList = new  List<SapEccCreateDn.CreateDnReturn_element>();
            //delivery_tool.generateData(ord);
            system.debug('start CompleteStatus_tool');
           CreateDN_tool.generateData('CR');
        //        system.debug('start syncDisStockLst-->'+syncDisStockLst);
                returnList =   CreateDN_tool.sync(syncDisStockLst,orderItemLst);
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
            if(returnList !=null){
               return 'S'; 
            }else {
                 return 'E'; 
            }
             //return 'E'; 
        }
         return 'E';
    }
    
    webservice static void getSAPCancelDN(String CreateDNId){
        if(CreateDNId != null){
        
           	List<OrderItem>  orderItemLst  = [Select Id,Quantity,SAP_Materiel_No__c,Product_Name__c,SAP_Product_Materiel_No__r.Name,SAP_Product_Materiel_No__r.Product_Code__c,Guaranteed_Delivery_Date__c,OrderID,RowNo__c from OrderItem where OrderID =:CreateDNId];
           	List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c')+' WHERE Order__c =: CreateDNId');
            SapSync_CreateDn CreateDN_tool = new  SapSync_CreateDn();
         
            //delivery_tool.generateData(ord);
            system.debug('start CompleteStatus_tool');
            CreateDN_tool.generateData('CA');
               CreateDN_tool.sync(syncDisStockLst,orderItemLst);
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
        }
    }
      webservice static String getSAPNewCreateDN(String CreateDNId,List<String> IDLst){
        if(CreateDNId != null){
        
           	List<OrderItem>  orderItemLst  = [Select Id,Quantity,SAP_Materiel_No__c,Product_Name__c,Guaranteed_Delivery_Date__c,SAP_Product_Materiel_No__r.Name,SAP_Product_Materiel_No__r.Product_Code__c,OrderID,RowNo__c from OrderItem where OrderID =:CreateDNId];
           	List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c')+' WHERE Id in: IDLst');
              List<SapEccCreateDn.CreateDnReturn_element> returnList = new  List<SapEccCreateDn.CreateDnReturn_element>();
            SapSync_CreateDn CreateDN_tool = new  SapSync_CreateDn();

            system.debug('orderItemLst-->'+orderItemLst);
            system.debug('syncDisStockLst-->'+syncDisStockLst);
            //delivery_tool.generateData(ord);
            system.debug('start CompleteStatus_tool');
            CreateDN_tool.generateData('CR');
              returnList = CreateDN_tool.sync(syncDisStockLst,orderItemLst);
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
        if(returnList !=null){
               return 'S'; 
            }else {
                 return 'E'; 
            }
            // return 'E';  
        }
         return 'E';
    }
    
    
      webservice static void getSAPNewCancelDN(String CreateDNId,List<String> IDLst){
        if(CreateDNId != null){
        
           	List<OrderItem>  orderItemLst  = [Select Id,Quantity,SAP_Materiel_No__c,Product_Name__c,Guaranteed_Delivery_Date__c,OrderID,RowNo__c from OrderItem where OrderID =:CreateDNId];
           	List<Distribution_Stock__c>  syncDisStockLst  = Database.query( Utils.MakeSelectSql('Distribution_Stock__c')+' WHERE Id in: IDLst');
            SapSync_CreateDn CreateDN_tool = new  SapSync_CreateDn();
         
            //delivery_tool.generateData(ord);
            system.debug('start CompleteStatus_tool');
            CreateDN_tool.generateData('CA');
               CreateDN_tool.sync(syncDisStockLst,orderItemLst);
            system.debug('-------->fanhuichenggong:');
            // upload log
            uploadList();
        }
    }
    /**
    webservice static void getInventory(String Name){
         if(Name != null){
         //   system.debug('----->>>huidiaofahuoxinxi'); 
        //   	Order ord   = Database.query( Utils.MakeSelectSql('Order')+' WHERE Id =: orderid');
           System.debug('Start Sysnc');
              List<Inventory__c> invList  = new  List<Inventory__c>();
            SapSync_Inventory delivery_tool = new SapSync_Inventory();
            system.debug('Start EU');
           //SapSync_Inventory.UpdateAccountToMIS(nn);
            system.debug('Stop EU');
            delivery_tool.generateData(Name);
            invList=delivery_tool.sync();
            system.debug('invList.size()--->'+invList.size());
            system.debug('-------->fanhuichenggong:');
            // upload log
          //  uploadList();
        }
    }
    */
     webservice static void OASync(string ordId){
        if(ordId != null){	
            system.debug('-----Sync OA : ' + ordId);
            /*
             Account acc = [Select id,Name,SAP_External_ID__c,IBAN_Code__c,SWIFT_Code__c,Account_Allocation_Group__c,
                       Account_Group__c,Account_Holder__c,Bank_Account__c,Bank_City__c,Bank_Code__c,
                       Bank_Country__c,Bank_Name__c,Bank_Region__c,Bank_Street__c,Contract_Currency__c,
                       Country__c,Owner.SAP_User_ID__c,Distribution_channel__c,Emergency_level__c,
                       Ledger_Name__c,Operate_Type__c,Owner.Name,Phone,Product_Group__c,Sales_Dept__c,
                       Sales_Group__c,Sales_Org__c,Sales_Region__c,Search__c,Street_Room_Number__c,CurrencyIsoCode,
                       Subject_Group__c,Taxpayer_Identification_No__c,Title__c,OA_Emergency_level__c,OA_Operate_Type__c
                       From Account Where id =: accountId ];
            */
           Order ord = [Select id ,SAP_External_ID__c,IBAN_Code__c,SWIFT_Code__c,Account_Allocation_Group__c,
                       Account_Group__c,Account_Holder__c,Bank_Account__c,Bank_City__c,Bank_Code__c,
                       Bank_Country__c,Bank_Name__c,Bank_Region__c,Bank_Street__c,Buyer__r.Country__c,
                       Distribution_channel__c,Emergency_level__c,Account_Owner_Sap_Id__c,Buyer__r.Name,
                       Ledger_Name__c,Operate_Type__c,Product_Group__c,Sales_Dept__c,Buyer__r.Phone,
                       Sales_Group__c,Sales_Org__c,Sales_Region__c,Search__c,Street_Room_Number__c,CurrencyIsoCode,
                       Subject_Group__c,Taxpayer_Identification_No__c,Account_Title__c,OA_Emergency_level__c,OA_Operate_Type__c,delivery_note_CI__c
                       From Order Where id =: ordId];         
           OASync_Account sa = new OASync_Account();
           sa.generateData(ord);
           sa.sync();
           system.debug('-----Sync OA End : ');
           // upload log
           uploadList();
            //return 
        }
    }
    
}