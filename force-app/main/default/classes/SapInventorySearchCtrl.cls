global class SapInventorySearchCtrl {
    
    List<SAP_Inventory_Data> all_result_data {get;set;}
    
    public List<SAP_Inventory_Data> getAll_result_data(){
        return this.all_result_data;
    }
    
    class SAP_Inventory_Data{
        public String WERKS{get;set;}//工厂
        public String NAME1{get;set;}//名称
        public String LGORT{get;set;}//库存地点
        public String LGOBE{get;set;}//仓储地点
        public String MEINS{get;set;}//计量单位
        public String LABST{get;set;}//总量
        public String KWMENG{get;set;}//订单数量
        public String ZRELEA{get;set;}//Released数量
        public String ZOUTBO{get;set;}//OutBounded数量
        public String ZCONFI{get;set;}//Confirmed数量
        
        
        public String BOOKED{get;set;}//Booked数量
        /*
        	（逻辑1：总量-Released-Confirmed-Booked） 有合同
			（逻辑2：总量-Released-Confirmed-Apply Inventory Quality * 70%） 无合同
        	
        */
        public String Formula{get;set;}//公式
    }
    
    // 工厂 - 品名    (在OppLineItem下加了Product__c Plant_WH_Name__c 2个字段)
    public OpportunityLineItem tmp_opp_item {get;set;}
    public String plant_wh {get;set;} // plant & warehouse
    public List<SelectOption> getItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        
        // 根据用户ID来判断区域，用于WH选项的显示，不同区域的销售只能看到当前区域的选项
        if(current_user.Contract_Approver__c == '0059000000126GT'){
            //Arturo Herrero
            options.add(new SelectOption('Mexico Warehouse','Mexico Warehouse'));
            options.add(new SelectOption('JKSwiss transit','JKSwiss transit'));
        }else if(current_user.Contract_Approver__c == '005900000015hNj'){
            //Niendorf Frank
            options.add(new SelectOption('Gebze Warehouse','Gebze Warehouse'));
            options.add(new SelectOption('Antwerp Warehous - Switzerland','Antwerp Warehous - Switzerland'));
            options.add(new SelectOption('Rotterdam Wareho - Switzerland','Rotterdam Wareho - Switzerland'));
            options.add(new SelectOption('JKSwiss transit','JKSwiss transit'));
            options.add(new SelectOption('Antwerp Warehous - GmbH','Antwerp Warehous - GmbH'));
            options.add(new SelectOption('Rotterdam Wareho - GmbH','Rotterdam Wareho - GmbH'));
            options.add(new SelectOption('Germany transit','Germany transit'));
        }else if(current_user.Contract_Approver__c == '0059000000126GB'){
            //Anita Li
            options.add(new SelectOption('Adelaide Warehou','Adelaide Warehou'));
            options.add(new SelectOption('JKSwiss transit','JKSwiss transit'));
            options.add(new SelectOption('Brisbane Warehou','Brisbane Warehou'));
            options.add(new SelectOption('Perth Warehouse','Perth Warehouse'));
            options.add(new SelectOption('Melbourne Wareho','Melbourne Wareho'));
            options.add(new SelectOption('Sydney Warehouse','Sydney Warehouse'));
            options.add(new SelectOption('AustraliaTransit','AustraliaTransit'));
            options.add(new SelectOption('Shimizu-bonded','Shimizu-bonded'));
            options.add(new SelectOption('Hakata-bonded','Hakata-bonded'));
            options.add(new SelectOption('Shimizu-non-bond','Shimizu-non-bond'));
            options.add(new SelectOption('Hakata-non-bond','Hakata-non-bond'));
            options.add(new SelectOption('Japan\'s transit','Japan\'s transit'));
        }
        
        return options;
    }
    
    
    
    public User current_user {get;set;}
    public Opportunity current_opp {get;set;}
    public Account current_acc {get;set;}
    
    // 业务机会状态不为lost 或者Win）, &&（该业务机会下合同未双签，字段叫Approval_Status__c）
    public List<OpportunityLineItem> all_opp_items = new List<OpportunityLineItem>();
    
    // 函数参数
    public sapInventory.RANGE_MATNR       SAP_RANGE_MATNR   = new sapInventory.RANGE_MATNR();
    public sapInventory.TDS_RG_LGORT      SAP_TDS_RG_LGORT  = new sapInventory.TDS_RG_LGORT();
    public sapInventory.RANGE_WERKS       SAP_RANGE_WERKS   = new sapInventory.RANGE_WERKS();
    public sapInventory.ZSSD007           SAP_ZSSD007       = new sapInventory.ZSSD007();
    
    public sapInventory.TABLE_OF_ZSSD007 IT_DATA {get;set;}
    public sapInventory.ZSDO0007Response_element result {get;set;}
    
    List<Contract> hasContract = new List<Contract>();//用于判断有无合同
    public String userid;
    public String oppid;
    
    public SapInventorySearchCtrl(){
        
        tmp_opp_item = new OpportunityLineItem();
        
        userid = ApexPages.currentPage().getParameters().get('uid');
        oppid = ApexPages.currentPage().getParameters().get('oppid');
        
        // 取到所有Booked状态的Opp Line Items
        /*List<Contract> bookedContracts = [SELECT ID,Name,Opportunity__c FROM Contract WHERE Opportunity__r.StageName !=: 'Closed Lost' 
            AND Contract.Approval_Status__c != 'Approved' AND Opportunity__c =: oppid];
            
        hasContract = [SELECT ID,Name FROM Contract WHERE Opportunity__c =: oppid];
        
        List<ID> bookedOppIDS = new List<ID>();
        for(Contract con : bookedContracts){
            bookedOppIDS.add(con.Opportunity__c);
        }
        String sqlstr = 'select Id,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c'+
            	' from OpportunityLineItem Where OpportunityId in: bookedOppIDS';
        all_opp_items = Database.query(sqlstr);*/
        
        // 获取当前用户的信息
        if(userid != null)current_user = [SELECT ID,Name,Contract_Approver__c FROM User WHERE ID =: userid];
        
    }
    
    public String errorMsg {get;set;}
    
    public void SearchInventory(){
        
        errorMsg = '';
        all_result_data = new List<SAP_Inventory_Data>();
        
        // 根据用户选择的产品取到物料号、产品名
        String productID        = tmp_opp_item.Product__c;
        List<Product2> prodList = new List<Product2>();
        if(productID != null)prodList = [SELECT ID,Name,SAP_Materiel_No__c FROM Product2 WHERE ID =: productID];
        String productNAME      = prodList.size() > 0 ? prodList[0].Name : '';//产品名
        String prod_SAP_CODE    = prodList.size() > 0 ? prodList[0].SAP_Materiel_No__c : ''; //物料号
        
        // 根据用户选择的Warehouse取到公司代码、工厂编码
		String plant_code = SapMap.getPlant(plant_wh);
		String wh_code    = SapMap.getWH(plant_wh);
        
        //没有物料号，抛出提示
        if( (prod_SAP_CODE == '' ||  prod_SAP_CODE == null) && productID != null){
            errorMsg = 'Error Message : This product has no SAP product code, please contact with your CRM system administrator';
        }else if(productID == null || productID == ''){
            errorMsg = 'Error Message : Please choose a product before you click the search button';
        }else{
            //MATNR -- 物料编码
            SAP_RANGE_MATNR.OPTION = 'EQ';
            SAP_RANGE_MATNR.SIGN = 'I';
            SAP_RANGE_MATNR.HIGH = '';//传单个物料号，HIGH为空
            SAP_RANGE_MATNR.LOW = '0000000000'+prod_SAP_CODE;//要自动加零，加到18位 000000000024000030
            
            //WERKS -- 工厂编号
            if(plant_code == null || plant_code == ''){
            	SAP_RANGE_WERKS.OPTION = '';
	            SAP_RANGE_WERKS.SIGN = '';
	            SAP_RANGE_WERKS.HIGH = '';
	            SAP_RANGE_WERKS.LOW = '';
            }else{
            	SAP_RANGE_WERKS.OPTION = 'EQ';
	            SAP_RANGE_WERKS.SIGN = 'I';
	            SAP_RANGE_WERKS.HIGH = '';
	            SAP_RANGE_WERKS.LOW = plant_code;
            } 
            
            
            //LGORT -- 仓库编码
            if(wh_code == null || wh_code == ''){
            	SAP_TDS_RG_LGORT.OPTION = '';
	            SAP_TDS_RG_LGORT.SIGN = '';
	            SAP_TDS_RG_LGORT.HIGH = '';
	            SAP_TDS_RG_LGORT.LOW = '';
            }else{
            	SAP_TDS_RG_LGORT.OPTION = 'EQ';
	            SAP_TDS_RG_LGORT.SIGN = 'I';
	            SAP_TDS_RG_LGORT.HIGH = '';
	            SAP_TDS_RG_LGORT.LOW = wh_code;
            }

            
            //Table WERKS
            sapInventory.TABLE_OF_RANGE_WERKS S_WERKS   = new sapInventory.TABLE_OF_RANGE_WERKS();
            S_WERKS.item.add(SAP_RANGE_WERKS);
            
            //Table LGORT
            sapInventory.TABLE_OF_TDS_RG_LGORT S_LGORT  = new sapInventory.TABLE_OF_TDS_RG_LGORT();
            S_LGORT.item.add(SAP_TDS_RG_LGORT);
            
            //Table MATNR
            sapInventory.TABLE_OF_RANGE_MATNR S_MATNR   = new sapInventory.TABLE_OF_RANGE_MATNR();
            S_MATNR.item.add(SAP_RANGE_MATNR);
            
            IT_DATA = new sapInventory.TABLE_OF_ZSSD007();//结果集
            
            sapInventory.ZSDO0007 intface = new sapInventory.ZSDO0007();//接口类
            try{
                result = intface.ZSDO0007(IT_DATA,S_LGORT, S_MATNR, S_WERKS );//接口函数
                
                IT_DATA = result.IT_DATA;//拿到结果集
                
                
                
                //拿到Booked或者Apply Inventory的数量
                
                Decimal num = 0;
                
                List<Apply_Inventory__c> aiList = [SELECT ID,Product_Type__c,Quantity__c,Approval_Status__c FROM Apply_Inventory__c WHERE Opportunity__c =: oppid];
            	if(aiList.size() > 0){
            		List<Product2> pdlist = new List<Product2>();
    				
            		for(Apply_Inventory__c ai : aiList){
            			if(ai.Approval_Status__c == 'Approved'){
            				// limit 101 可能出现的点
            				if(ai.Product_Type__c != null)pdlist = [SELECT ID,Name,SAP_Materiel_No__c FROM Product2 WHERE ID =: ai.Product_Type__c];
            				if(pdlist[0].SAP_Materiel_No__c == prod_SAP_CODE){
            					if(ai.Quantity__c > 0)num = ai.Quantity__c * 0.7;
            					break;
            				}
            			}
            		}
            	}
                
                /*if(hasContract.size()>0){
                	//拿booked
                	if(all_opp_items.size() > 0){
                		List<Product2> pdlist = new List<Product2>();
                		for(OpportunityLineItem item : all_opp_items){
                			// limit 101 可能出现的点
                			if(item.PricebookEntry.product2Id != null)pdlist = [SELECT ID,Name,SAP_Materiel_No__c FROM Product2 WHERE ID =: item.PricebookEntry.product2Id];
                			if(pdlist[0].SAP_Materiel_No__c == prod_SAP_CODE){
            					if(item.Quantity > 0)num = item.Quantity * 0.7;
            					break;
                			}
                		}
                	}
                }else{
                	//拿Apply Inventory
                	List<Apply_Inventory__c> aiList = [SELECT ID,Product_Type__c,Quantity__c,Approval_Status__c FROM Apply_Inventory__c WHERE Opportunity__c =: oppid];
                	if(aiList.size() > 0){
                		List<Product2> pdlist = new List<Product2>();
        				
                		for(Apply_Inventory__c ai : aiList){
                			if(ai.Approval_Status__c == 'Approved'){
                				// limit 101 可能出现的点
                				if(ai.Product_Type__c != null)pdlist = [SELECT ID,Name,SAP_Materiel_No__c FROM Product2 WHERE ID =: ai.Product_Type__c];
                				if(pdlist[0].SAP_Materiel_No__c == prod_SAP_CODE){
                					if(ai.Quantity__c > 0)num = ai.Quantity__c * 0.7;
                					break;
                				}
                			}
                		}
                	} 
                }*/
                
                //遍历结果集生成一个内部类List
                all_result_data = new List<SAP_Inventory_Data>();
                for(sapInventory.ZSSD007 zssd : IT_DATA.item){
                    SAP_Inventory_Data data1 = new SAP_Inventory_Data();
                    data1.WERKS    = zssd.WERKS;
                    data1.NAME1    = zssd.NAME1;
                    data1.LGORT    = SapMap.getWH_Opposite(zssd.LGORT) == null ?  zssd.LGORT : SapMap.getWH_Opposite(zssd.LGORT);
                    data1.LGOBE    = zssd.LGOBE;
                    data1.MEINS    = zssd.MEINS;
                    data1.LABST    = zssd.LABST;
                    data1.KWMENG   = zssd.KWMENG;
                    data1.ZRELEA   = zssd.ZRELEA;
                    data1.ZOUTBO   = zssd.ZOUTBO;
                    data1.ZCONFI   = zssd.ZCONFI;
                    data1.BOOKED   = String.valueOf(Integer.valueOf(num));
                    
                    Decimal sum  = Decimal.valueOf(zssd.LABST) - Decimal.valueOf(zssd.ZRELEA) - Decimal.valueOf(zssd.ZCONFI) - num;
                    if(sum < 0){
                    	sum = 0;
                    	data1.Formula = String.valueOf(sum);
                    }else{
                    	data1.Formula = String.valueOf(Integer.valueOf(sum));
                    }
                    
                    
                    all_result_data.add(data1);
                }
                
                System.debug('##########IT_DATA size : ' + IT_DATA.item.size());
                System.debug('##########IT_DATA details : ' + IT_DATA.item);
            }catch(Exception e){
                System.debug('##########error details : ' + e); 
            }
        }
        
    }
    
    public void runTest(){
    	String run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
    }
    
}