trigger JapanContractController on Contract (before insert) {
	/*
	system.debug('~~~~~~~~~~~~~~~~~~~~>isbefore1' + trigger.isBefore );
    system.debug('~~~~~~~~~~~~~~~~~~~~>isinsert1' + trigger.isInsert );
	
    system.debug('~~~~~~~~~~~~~~~~~~~~>start');
    RemarkExchangeUtils tools = new RemarkExchangeUtils();
    
    if(!Test.isRunningTest()){
    	system.debug('~~~~~~~~~~~~~~~~~~~~>Test.isRunningTest()');
        List<RecordType> japanRecord = [Select r.Name, r.Id From RecordType r WHERE r.Name = 'Japan Standard Contract'];
        List<RecordType> ausRecord   = [Select r.Name, r.Id From RecordType r WHERE r.Name = 'Australia Standard Contract'];
        //add by : Jason 20160427 Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        List<RecordType> MWJapanRecord = [Select r.Name, r.Id From RecordType r WHERE r.Name = '1MW Japan Contract'];
        List<RecordType> MWStandardRecord   = [Select r.Name, r.Id From RecordType r WHERE r.Name = '1MW Standard Contract'];
        
        List<RecordType> InterRecord = [Select r.Name, r.Id From RecordType r WHERE r.Name = 'Intercompany Contract'];
        
        system.debug('~~~~~~~~~~~~~~~~~~~~>japanRecord' +japanRecord+'\n\t\t'+
        												+ausRecord +'\n\t\t'+
        												+MWJapanRecord +'\n\t\t'+
        												+MWStandardRecord +'\n\t\t'+
        												+InterRecord +'\n\t\t'	);
        
        List<ID> conIds = new List<ID>();
        List<ID> accIds = new List<ID>();
        for(Contract con : trigger.new){
            conIds.add(con.Id);
            accIds.add(con.AccountId);
        }
        system.debug('~~~~~~~~~~~~~~~~~~~~>conIds' + conIds + '\n\t\t'+ accIds);
        List<Payment__c> payList = [SELECT ID,Contract__c,Payment_Method__c,Payment_Term__c,Down_Balance_Payment__c,Percentage__c FROM Payment__c WHERE Contract__c in: conIds];
        List<Opportunity> oppList = [SELECT ID,AccountId,RecordType.name,Payment_1MW_Approve__c,Total_MW__c,Trade_Term__c,Total_Quantity__c,Payment_Term_Description__c,whether_pick_up_batch__c,Price_Approval_Status__c,Sales_manager_approval__c,Customer_Type__c FROM Opportunity WHERE AccountId in: accIds];
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
        for(Opportunity opp : oppList){
            oppMap.put(opp.Id,opp);
        }
         system.debug('~~~~~~~~~~~~~~~~~~~~>oppMap' + oppMap );
         system.debug('~~~~~~~~~~~~~~~~~~~~>isbefore' + trigger.isBefore );
         system.debug('~~~~~~~~~~~~~~~~~~~~>isinsert' + trigger.isInsert );
        // 第一次生成合同时变更record type
        if(trigger.isBefore && trigger.isInsert){
        	system.debug('~~~~~~~~~~~~~~~~~~~~>trigger.isInsert && trigger.isBefore' );
        	
            for(Contract con_new : trigger.new){
                
                Opportunity opp;
                if(oppMap.get(con_new.Opportunity__c) != null)opp = oppMap.get(con_new.Opportunity__c);
                //记录历史record type id
                if(con_new.RecordTypeId != null)con_new.History_Record_Type_ID__c = String.valueOf(con_new.RecordTypeId).subString(0,15);
                
                System.debug('~~~~~~~~~~~~ Payment Description: '+ opp.Payment_Term_Description__c);
                System.debug('~~~~~~~~~~~~ Total Quantity: '+ opp.Total_Quantity__c);
                System.debug('~~~~~~~~~~~~ SELLER: '+ con_new.SELLER__c);
                System.debug('~~~~~~~~~~~~ Trade Term: '+ con_new.Trade_term__c);
                System.debug('~~~~~~~~~~~~ Buyer Country: '+ con_new.Buyer_Country__c);
                System.debug('~~~~~~~~~~~~ Price Approval Status: '+ opp.Price_Approval_Status__c);
                System.debug('~~~~~~~~~~~~ Sales Manager Status: '+ opp.Sales_manager_approval__c);
                System.debug('~~~~~~~~~~~~ System Australia Standard Contract Record Type Id: '+ ausRecord[0].Id);
                
                //当用户选择Japan Standard Contract，如不能满足日本简易流程的基本条件，将报出提示信息
                if(con_new.RecordTypeId  == japanRecord[0].Id && !(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && 
	            con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Buyer_Country__c == 'Japan')){
                	System.debug('*********** 日本合同不满足基本条件报错' + con_new.RecordTypeId);
                    con_new.addError('Message: You can not create a Japan Standard Contract, please check your Opportunity :\n1.Total Quantity less than 2800\n2.Seller is ジンコソーラージャパン株式会社\n3.Payment contains T/T\n4.Buyer Country is Japan\n5.Trade term is EXW/DDP');
                }
                
                // 20160518 ---> start
                
                Boolean FinanceApproval = false;
                
                if((opp.Customer_Type__c == 'GTAC' || opp.Customer_Type__c == 'Frame' || opp.Customer_Type__c == '' || opp.Customer_Type__c == null) && 
	                	con_new.Allow_new_process_for_Japan_picklist__c == 'allow' && opp != null && opp.Payment_Term_Description__c != null && 
	                	opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && 
	                	(con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && japanRecord.size() > 0){
                	// 满足 Japan Standard Contract 条件
                	con_new.RecordTypeId = japanRecord[0].Id;
                	con_new.Tax_Rate__c = 8;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                	
                }else if(opp.Customer_Type__c == 'Jinko Standard Japan' && opp != null && opp.Payment_Term_Description__c != null && 
                		opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && 
                		con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && 
                		japanRecord.size() > 0){
                	// 满足 Japan Standard Contract 条件
                	con_new.RecordTypeId = japanRecord[0].Id;
                	con_new.Tax_Rate__c = 8;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
               
                }else if(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && 
                		opp.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'  &&
                		con_new.Trade_term__c == 'DDP' && opp.whether_pick_up_batch__c == 'True' &&
                		ausRecord.size()> 0){
                	// 满足 Australia Standard Contract 条件
                	con_new.RecordTypeId = ausRecord[0].Id;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                }else if(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && 
                		opp.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'  &&
                		con_new.Trade_term__c == 'EXW' &&
                		ausRecord.size()> 0){
                	// 满足 Australia Standard Contract 条件
                	con_new.RecordTypeId = ausRecord[0].Id;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                }else if(opp.Total_MW__c < 1 &&
                		opp.Total_Quantity__c > 2800 && 
                			(opp.Trade_Term__c == 'CIF'
			            	|| opp.Trade_Term__c == 'EXW'
		                	|| opp.Trade_Term__c == 'FOB'
		                	|| opp.Trade_Term__c == 'DAP'
		                	|| opp.Trade_Term__c == 'DDP'
		                	|| opp.Trade_Term__c == 'CFR') &&
		                opp.Payment_1MW_Approve__c == true &&
		                con_new.Allow_new_process_for_Japan_picklist__c == 'allow' &&
		                (con_new.SELLER__c == 'ジンコソーラージャパン株式会社' || con_new.SELLER__c == 'Jinko Solar Co., Ltd.' || con_new.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD') &&
		                 opp.Customer_Type__c == 'Jinko Standard Japan' && MWJapanRecord.size() > 0){
                	// 满足Japan 1MW条件
                	con_new.RecordTypeId = MWJapanRecord[0].Id;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                }else if(opp.Total_MW__c < 1
	            		&& opp.Total_Quantity__c >= 2800 
	            		&& opp.RecordType.name == 'Australia'
	            		&& opp.Payment_1MW_Approve__c == true
            			&& (opp.Trade_Term__c == 'CIF'
			            	|| opp.Trade_Term__c == 'EXW'
		                	|| opp.Trade_Term__c == 'FOB'
		                	|| opp.Trade_Term__c == 'DAP'
		                	|| opp.Trade_Term__c == 'DDP'
		                	|| opp.Trade_Term__c == 'CFR')){
                	// 满足Australia 1MW条件
                	con_new.RecordTypeId = MWStandardRecord[0].Id;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                }else if(opp.Total_MW__c < 1 && 
	                		(opp.Trade_Term__c == 'CIF'
			            	|| opp.Trade_Term__c == 'EXW'
			            	|| opp.Trade_Term__c == 'FOB'
			            	|| opp.Trade_Term__c == 'DAP'
			            	|| opp.Trade_Term__c == 'DDP'
			            	|| opp.Trade_Term__c == 'CFR') && 
		            	opp.Payment_1MW_Approve__c == true && opp.Sales_manager_approval__c == 'Approved' && MWStandardRecord.size() > 0 &&
		            	opp.RecordType.Name != 'Japan'){
                	// 满足全球1MW条件
                	con_new.RecordTypeId = MWStandardRecord[0].Id;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                }else{
                	FinanceApproval = true;
                	System.debug('~~~~~~~~~~~~ con_new.RecordTypeId: '+ con_new.RecordTypeId);
                }
                // 20160518 ---> end
                
                //日本 record type
                /*if(opp.Customer_Type__c == 'GTAC' || opp.Customer_Type__c == 'Frame' || opp.Customer_Type__c == '' || opp.Customer_Type__c == null){
                	//走法务审核流程
                	if(con_new.Allow_new_process_for_Japan_picklist__c == 'allow'){
	                    if(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && 
	                       con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Buyer_Country__c == 'Japan'){
	                        if(japanRecord.size() > 0)con_new.RecordTypeId = japanRecord[0].Id;//更改record type
	                        con_new.Tax_Rate__c = 8;
	                       System.debug('############ con_new.RecordTypeId: '+ con_new.RecordTypeId+'\n'+
                    						'con_new.Trade_term__c'+con_new.Trade_term__c+'\n'+
                    						'opp.Total_Quantity__c'+opp.Total_Quantity__c+'\n'+
	                        				'opp.Payment_Term_Description__c'+opp.Payment_Term_Description__c+'\n'+
	                        				'con_new.Allow_new_process_for_Japan_picklist__c'+con_new.Allow_new_process_for_Japan_picklist__c+'\n'+
	                        				'opp.Customer_Type__c'+opp.Customer_Type__c);
	                    }   
	                }
                }else if (opp.Customer_Type__c == 'Jinko Standard Japan'){
                	//无需走法务审核，直接进入快速流程判断
                	if(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && 
                       con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Buyer_Country__c == 'Japan'){
                        if(japanRecord.size() > 0)con_new.RecordTypeId = japanRecord[0].Id;//更改record type
                    	con_new.Tax_Rate__c = 8;
                    	  System.debug('############ con_new.RecordTypeId: '+ con_new.RecordTypeId+'\n'+
                    						'con_new.Trade_term__c'+con_new.Trade_term__c+'\n'+
                    						'opp.Total_Quantity__c'+opp.Total_Quantity__c+'\n'+
	                        				'opp.Payment_Term_Description__c'+opp.Payment_Term_Description__c+'\n'+
	                        				'con_new.Allow_new_process_for_Japan_picklist__c'+con_new.Allow_new_process_for_Japan_picklist__c+'\n'+
	                        				'opp.Customer_Type__c'+opp.Customer_Type__c);
                    }  
                }else if (opp.Customer_Type__c == 'Other'){
                	//走一般流程，即不进行任何行为
                }*/
                
                /*******if(con_new.Allow_new_process_for_Japan_picklist__c == 'allow'){
                    if(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && 
                       con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Buyer_Country__c == 'Japan'){
                        if(japanRecord.size() > 0)con_new.RecordTypeId = japanRecord[0].Id;//更改record type
                        con_new.Tax_Rate__c = 8;
                    }   
                }********/
     
                //澳大利亚 record type
                /*if(opp != null && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'  && con_new.Buyer_Country__c == 'Australia'){
                    if(con_new.Trade_term__c == 'DDP' && opp.whether_pick_up_batch__c == 'True'){
                        if(ausRecord.size()> 0)con_new.RecordTypeId = ausRecord[0].Id;
                    }else if(con_new.Trade_term__c == 'EXW'){
                        if(ausRecord.size()> 0)con_new.RecordTypeId = ausRecord[0].Id;
                    }
                }
                
                if(con_new.RecordTypeId != japanRecord[0].Id && con_new.RecordTypeId != ausRecord[0].Id){
                	
                }*/
                
                //1MW合同Sales manager approval  不为 Approved 无法创建合同
                /*boolean Sales_manager_1MW_Approve = false; 
                  System.debug('*********** 1MW合同审批opp.Total_MW__c:' + opp.Total_MW__c);
                  System.debug('*********** 1MW合同审批opp.Trade_Term__c:' + opp.Trade_Term__c );
                  System.debug('*********** 1MW合同审批opp.Payment_1MW_Approve__c:' + opp.Payment_1MW_Approve__c );
                  System.debug('*********** 1MW合同审批opp.Sales_manager_approval__c：'+ opp.Sales_manager_approval__c );  
                  System.debug('*********** 1MW合同审批Sales_manager_1MW_Approve：'  + Sales_manager_1MW_Approve);
              	if(opp.Total_MW__c < 1
	        		&& (opp.Trade_Term__c == 'CIF'
		            	|| opp.Trade_Term__c == 'EXW'
		            	|| opp.Trade_Term__c == 'FOB'
		            	|| opp.Trade_Term__c == 'DAP'
		            	|| opp.Trade_Term__c == 'DDP'
		            	|| opp.Trade_Term__c == 'CFR')
	            	&& opp.Payment_1MW_Approve__c == true
	            	&& opp.Sales_manager_approval__c == 'Approved'){
	            		
    				Sales_manager_1MW_Approve = true;
	            			
                    System.debug('*********** 1MW合同审批Sales_manager_1MW_Approve：'  + Sales_manager_1MW_Approve);    
                    System.debug('*********** 1MW合同审批' );
            	}*/
            	
            	/*if(opp.Price_Approval_Status__c != 'Approved'   				//一般合同Price Approval Status 不为 Approved 无法创建合同	
            		&& con_new.RecordTypeId  != '01290000001Lyqh'
            		&& con_new.RecordTypeId  !=  ausRecord[0].Id
            		&& con_new.RecordTypeId  !=  MWStandardRecord[0].Id){
                    System.debug('*********** 一般合同审批报错' + con_new.RecordTypeId);
                    con_new.addError('Message: You can not create Contract, because you didn\'t get price approve.');                    
                }else if( opp.Sales_manager_approval__c != 'Approved' && opp.Total_Quantity__c <= 2800 && con_new.RecordTypeId  == ausRecord[0].Id){
                    System.debug('*********** 澳大利亚合同审批报错2' + con_new.RecordTypeId);
                    con_new.addError('Message: You can not create Contract, because you didn\'t get price approve.');
                }*/
                
                
                
                
/*                
                //20160530 update about twice error
                //if(GenerateOrder.firstRun){
	                if(FinanceApproval){
	                	if(opp.Price_Approval_Status__c != 'Approved' && con_new.RecordTypeId != InterRecord[0].Id){
	                		con_new.addError('Message: You can not create Contract, because you didn\'t get price approve.');
	                	}
	                }else{
	                	if(opp.Price_Approval_Status__c == 'Approved'){
	                		//TODO:Nothing
	                	}else if(opp.Sales_manager_approval__c != 'Approved' && con_new.RecordTypeId != InterRecord[0].Id){
	                		con_new.addError('Message: You can not create Contract, because you didn\'t get GM approve.');
	                	}
	                }
	                //GenerateOrder.firstRun = false;
                //}
                
                //15.Payment不为100% & downpayment，就为true，其余为false
                if(con_new.Payment_Term_Description__c != null && con_new.Payment_Term_Description__c.contains('Down Payment') && (con_new.Payment_Term_Description__c.contains('100.00%') || con_new.Payment_Term_Description__c.contains('100%'))){
                    con_new.Sinosure_Confirmed__c = 'False';
                }else{
                    con_new.Sinosure_Confirmed__c = 'True';
                }
                
            }
        }
        
        // 法律条款变更 (日/澳)
        if(Trigger.isUpdate && trigger.isBefore){
        	system.debug('法律条款变更 (日/澳)');
        	for(Contract con_new : trigger.new){
                for(Contract con_old : trigger.old){
                    
                    Boolean hasTT = false;
                    for(Payment__c pay : payList){
                        if(pay.Contract__c == con_new.Id){
                            if(pay.Payment_Method__c.contains('T/T')){
                                hasTT = true;
                                break;
                            }
                        }
                    }
                    
                    for(Payment__c pay : payList){
                        if(pay.Contract__c == con_new.Id){
                            if(pay.Down_Balance_Payment__c == 'Down Payment' && pay.Percentage__c == 100){
                                con_new.Sinosure_Confirmed__c = 'False';
                                break;
                            }else{
                                con_new.Sinosure_Confirmed__c = 'True';
                            }
                        }
                    }
                    
                    // 只有付款方式是TT的单子，才会是新的流程 其他的LC或者escrow都是按照原流程
                    if(hasTT && con_new.Total_Quantity__c <= 2800){
                    	system.debug('只有付款方式是TT的单子，才会是新的流程 其他的LC或者escrow都是按照原流程');
                        Opportunity opp;
                        if(oppMap.get(con_new.Opportunity__c) != null)opp = oppMap.get(con_new.Opportunity__c);
                        
                        // Trade term / Seller 有变化即需要变动Record Type
                        if(con_new.Trade_term__c != con_old.Trade_term__c || con_new.SELLER__c != con_old.SELLER__c || con_new.Total_Quantity__c != con_old.Total_Quantity__c){
                            
                            // 日本record type - 小于等于4个柜 / Seller = ジンコソーラージャパン株式会社 / Trade Term = DDP|EXW
                            if(japanRecord.size() > 0 && con_new.RecordTypeId != japanRecord[0].Id){
                            	if(opp.Customer_Type__c == 'GTAC' || opp.Customer_Type__c == 'Frame' || opp.Customer_Type__c == '' || opp.Customer_Type__c == null){
				                	system.debug('日本record type - 小于等于4个柜 / Seller = ジンコソーラージャパン株式会社 / Trade Term = DDP|EXW');
				                	//走法务审核流程
				                	if(con_new.Allow_new_process_for_Japan_picklist__c == 'allow'){
					                    if(con_new.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Buyer_Country__c == 'Japan'){
					                        if(japanRecord.size() > 0)con_new.RecordTypeId = japanRecord[0].Id;  
                                			con_new.Tax_Rate__c = 8;
                                			//TODO : 给Expected Delivery Date Remark 赋初始值
                                			if(con_new.ETD__c != null && con_new.Expected_Delivery_Date__c != Date.valueOf(con_new.ETD__c)){
			                                   String japanTimeMin = con_new.Expected_Delivery_Date__c.year()+'年'+con_new.Expected_Delivery_Date__c.month()+'月'+con_new.Expected_Delivery_Date__c.day()+'日';
			                                   String japanTimeMax = Date.valueOf(con_new.ETD__c).year()+'年'+Date.valueOf(con_new.ETD__c).month()+'月'+Date.valueOf(con_new.ETD__c).day()+'日';
			                                   con_new.Delivery_Date_Remark__c = 'from [EN min] to [EN max], provided that the specific delivery date within aforementioned schedule shall be decided by both Parties at least 14 days in advance.\n[Japan min]から[Japan max]までの納入とし、当該期間中、各ロット商品の具体的な納期についてはその14日前までに双方の合意により決めるものとする。'.replace('[Japan min]',japanTimeMin).replace('[Japan max]',japanTimeMax).replace('[EN min]',String.valueOf(con_new.Expected_Delivery_Date__c)).replace('[EN max]',String.valueOf(Date.valueOf(con_new.ETD__c)));
			                                }else{
			                                   if(con_new.Expected_Delivery_Date__c != null)con_new.Delivery_Date_Remark__c = String.valueOf(con_new.Expected_Delivery_Date__c);
			                                }
					                    }   
					                }
				                }else if (opp.Customer_Type__c == 'Jinko Standard Japan'){
				                	//无需走法务审核，直接进入快速流程判断
				                	system.debug('无需走法务审核，直接进入快速流程判断');
				                	if(con_new.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Buyer_Country__c == 'Japan'){
				                        if(japanRecord.size() > 0)con_new.RecordTypeId = japanRecord[0].Id;  
                            			con_new.Tax_Rate__c = 8;
                            			//TODO : 给Expected Delivery Date Remark 赋初始值
                            			if(con_new.ETD__c != null && con_new.Expected_Delivery_Date__c != Date.valueOf(con_new.ETD__c)){
		                                   String japanTimeMin = con_new.Expected_Delivery_Date__c.year()+'年'+con_new.Expected_Delivery_Date__c.month()+'月'+con_new.Expected_Delivery_Date__c.day()+'日';
		                                   String japanTimeMax = Date.valueOf(con_new.ETD__c).year()+'年'+Date.valueOf(con_new.ETD__c).month()+'月'+Date.valueOf(con_new.ETD__c).day()+'日';
		                                   con_new.Delivery_Date_Remark__c = 'from [EN min] to [EN max], provided that the specific delivery date within aforementioned schedule shall be decided by both Parties at least 14 days in advance.\n[Japan min]から[Japan max]までの納入とし、当該期間中、各ロット商品の具体的な納期についてはその14日前までに双方の合意により決めるものとする。'.replace('[Japan min]',japanTimeMin).replace('[Japan max]',japanTimeMax).replace('[EN min]',String.valueOf(con_new.Expected_Delivery_Date__c)).replace('[EN max]',String.valueOf(Date.valueOf(con_new.ETD__c)));
		                                }else{
		                                   if(con_new.Expected_Delivery_Date__c != null)con_new.Delivery_Date_Remark__c = String.valueOf(con_new.Expected_Delivery_Date__c);
		                                }
				                    }
				                }else if (opp.Customer_Type__c == 'Other'){
				                	//走一般流程，即不进行任何行为
				                	system.debug('走一般流程，即不进行任何行为');
				                }
                            }
                            
                            // 澳大利亚record type  - 大于2个柜小于等于4个柜 / Seller = JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD / Trade Term = DDP|EXW
                            if(con_new.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia'){
                                if(con_new.Trade_term__c == 'DDP' && opp.whether_pick_up_batch__c == 'True'){
                                	system.debug('澳大利亚record type  - 大于2个柜小于等于4个柜 / Seller = JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD / Trade Term = DDP|EXW');
                                    if(ausRecord.size()> 0)con_new.RecordTypeId = ausRecord[0].Id;
                                }else if(con_new.Trade_term__c == 'EXW'){
                                    if(ausRecord.size()> 0)con_new.RecordTypeId = ausRecord[0].Id;
                                }
                            }
                        }
                        
                        // Trade term / Warranty On Material / Sinosure Confirmed / Seller 有变化即需变更模版
                        if(con_new.Trade_term__c != con_old.Trade_term__c || con_new.SELLER__c != con_old.SELLER__c || con_new.IS_GTAC_Formula__c != con_old.IS_GTAC_Formula__c ||
                                    con_new.Warranty_On_Material_and_Workmanship__c != con_old.Warranty_On_Material_and_Workmanship__c || con_new.GTAC_No__c != con_old.GTAC_No__c ||
                                    con_new.Sinosure_Confirmed__c != con_old.Sinosure_Confirmed__c || con_new.Payment_Term_Description__c != con_old.Payment_Term_Description__c){
                            
                            // 条件(通用) - Seller必需=ジンコソーラージャパン株式会社 - 日本模版
                            if(con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && con_new.Buyer_Country__c == 'Japan' && japanRecord.size()> 0 && con_new.RecordTypeId == japanRecord[0].Id){
                                
                                Boolean key = false;
                                if(opp.Customer_Type__c == 'GTAC' || opp.Customer_Type__c == 'Frame' || opp.Customer_Type__c == '' || opp.Customer_Type__c == null){
				                	//走法务审核流程
				                	if(con_new.Allow_new_process_for_Japan_picklist__c == 'allow'){
					                      key = true;
					                }
				                }else if (opp.Customer_Type__c == 'Jinko Standard Japan'){
				                	//无需走法务审核，直接进入快速流程判断
				                	key = false;
				                }else if (opp.Customer_Type__c == 'Other'){
				                	//走一般流程，即不进行任何行为
				                	key = false;
				                }
                                
                                if(key){
                                    
                                    System.debug('############### trade term: '+con_new.Trade_term__c);
                                    System.debug('############### warranty: '+con_new.Warranty_On_Material_and_Workmanship__c);
                                    System.debug('############### sinosure: '+con_new.Sinosure_Confirmed__c);
                                    
                                    // Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Standard + Sino
                                        tools.GTAC_DDP_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Linear + Sino
                                        tools.GTAC_DDP_Linear_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Standard + Sino
                                        tools.GTAC_EXW_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Linear + Sino
                                        tools.GTAC_EXW_Linear_Sino(con_new);
                                    }
                                    
                                    // No Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Standard + Not Sino
                                        tools.GTAC_DDP_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Linear + Not Sino
                                        tools.GTAC_DDP_Linear_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Standard + Not Sino
                                        tools.GTAC_EXW_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Linear + Not Sino
                                        tools.GTAC_EXW_Linear_NoSino(con_new);
                                    }
                                    
                                }else{
                                    
                                    // Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Standard + Sino
                                        tools.DDP_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Linear + Sino
                                        tools.DDP_Linear_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Standard + Sino
                                        tools.EXW_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Linear + Sino
                                        tools.EXW_Linear_Sino(con_new);
                                    }
                                    
                                    // No Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Standard + Not Sino
                                        tools.DDP_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Linear + Not Sino
                                        tools.DDP_Linear_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Standard + Not Sino
                                        tools.EXW_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Linear + Not Sino
                                        tools.EXW_Linear_NoSino(con_new);
                                    }
                                }
                                
                            }
                                        
                            // 条件(通用) - Seller必需=JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD - 澳大利亚模版
                            if(con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia' && ausRecord.size()> 0 && con_new.RecordTypeId == ausRecord[0].Id){
                                if(con_new.Trade_term__c == 'DDP'){
                                    tools.Australia_DDP(con_new);
                                }else if(con_new.Trade_term__c == 'EXW'){
                                    tools.Australia_EXW(con_new);
                                }
                            }            
                        }
                        
                        System.debug('############ record type : '+con_new.RecordTypeId);
                        
                        
                    }else if(con_new.Total_Quantity__c > 2800 && con_new.History_Record_Type_ID__c != null && con_new.RecordTypeId != null && con_new.RecordTypeId != con_new.History_Record_Type_ID__c && (con_new.RecordTypeId == ausRecord[0].Id || con_new.RecordTypeId == japanRecord[0].Id)){
                        con_new.RecordTypeId = Id.valueOf(con_new.History_Record_Type_ID__c);
                    }
                }
        	}
        }
        
       
        // 法律条款变更 (日/澳)
        /*if(Trigger.isUpdate){
            for(Contract con_new : trigger.new){
                for(Contract con_old : trigger.old){
                    
                    Boolean hasTT = false;
                    for(Payment__c pay : payList){
                        if(pay.Contract__c == con_new.Id){
                            if(pay.Payment_Method__c.contains('T/T')){
                                hasTT = true;
                                break;
                            }
                        }
                    }
                    
                    for(Payment__c pay : payList){
                        if(pay.Contract__c == con_new.Id){
                            if(pay.Down_Balance_Payment__c == 'Down Payment' && pay.Percentage__c == 100){
                                con_new.Sinosure_Confirmed__c = 'False';
                                break;
                            }else{
                                con_new.Sinosure_Confirmed__c = 'True';
                            }
                        }
                    }
                    
                    // 只有付款方式是TT的单子，才会是新的流程 其他的LC或者escrow都是按照原流程
                    if(hasTT && con_new.Total_Quantity__c <= 2800){
                        
                        // Trade term / Seller 有变化即需要变动Record Type
                        if(con_new.Trade_term__c != con_old.Trade_term__c || con_new.SELLER__c != con_old.SELLER__c || con_new.Total_Quantity__c != con_old.Total_Quantity__c){
                            // 日本 - 小于等于4个柜 / Seller = ジンコソーラージャパン株式会社 / Trade Term = DDP|EXW
                            if(con_new.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && (con_new.Trade_term__c == 'DDP' || con_new.Trade_term__c == 'EXW') && con_new.Allow_new_process_for_Japan_picklist__c == 'allow' && japanRecord.size() > 0 && con_new.RecordTypeId != japanRecord[0].Id && con_new.Buyer_Country__c == 'Japan'){
                                
                                if(japanRecord.size() > 0)con_new.RecordTypeId = japanRecord[0].Id;  
                                con_new.Tax_Rate__c = 8;
                                
                                //TODO : 给Expected Delivery Date Remark 赋初始值
                               if(con_new.ETD__c != null && con_new.Expected_Delivery_Date__c != Date.valueOf(con_new.ETD__c)){
                                   String japanTimeMin = con_new.Expected_Delivery_Date__c.year()+'年'+con_new.Expected_Delivery_Date__c.month()+'月'+con_new.Expected_Delivery_Date__c.day()+'日';
                                   String japanTimeMax = Date.valueOf(con_new.ETD__c).year()+'年'+Date.valueOf(con_new.ETD__c).month()+'月'+Date.valueOf(con_new.ETD__c).day()+'日';
                                   con_new.Delivery_Date_Remark__c = 'from [EN min] to [EN max], provided that the specific delivery date within aforementioned schedule shall be decided by both Parties at least 14 days in advance.\n[Japan min]から[Japan max]までの納入とし、当該期間中、各ロット商品の具体的な納期についてはその14日前までに双方の合意により決めるものとする。'.replace('[Japan min]',japanTimeMin).replace('[Japan max]',japanTimeMax).replace('[EN min]',String.valueOf(con_new.Expected_Delivery_Date__c)).replace('[EN max]',String.valueOf(Date.valueOf(con_new.ETD__c)));
                               }else{
                                   if(con_new.Expected_Delivery_Date__c != null)con_new.Delivery_Date_Remark__c = String.valueOf(con_new.Expected_Delivery_Date__c);
                               }
                                
                                
                            }
                            
                            // 澳大利亚 - 大于2个柜小于等于4个柜 / Seller = JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD / Trade Term = DDP|EXW
                            if(con_new.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia'){
                                Opportunity opp;
                                if(oppMap.get(con_new.Opportunity__c) != null)opp = oppMap.get(con_new.Opportunity__c);
                                
                                if(con_new.Trade_term__c == 'DDP' && opp.whether_pick_up_batch__c == 'True'){
                                    if(ausRecord.size()> 0)con_new.RecordTypeId = ausRecord[0].Id;
                                }else if(con_new.Trade_term__c == 'EXW'){
                                    if(ausRecord.size()> 0)con_new.RecordTypeId = ausRecord[0].Id;
                                }
                            }
                        }
                        
                        // Trade term / Warranty On Material / Sinosure Confirmed / Seller 有变化即需变更模版
                        if(con_new.Trade_term__c != con_old.Trade_term__c || con_new.SELLER__c != con_old.SELLER__c || con_new.IS_GTAC_Formula__c != con_old.IS_GTAC_Formula__c ||
                                    con_new.Warranty_On_Material_and_Workmanship__c != con_old.Warranty_On_Material_and_Workmanship__c || con_new.GTAC_No__c != con_old.GTAC_No__c ||
                                    con_new.Sinosure_Confirmed__c != con_old.Sinosure_Confirmed__c || con_new.Payment_Term_Description__c != con_old.Payment_Term_Description__c){
                            
                            // 条件(通用) - Seller必需=ジンコソーラージャパン株式会社 - 日本模版
                            // 并且要通过法务部门勾选 Allow new process for japan
                            if(con_new.SELLER__c == 'ジンコソーラージャパン株式会社' && con_new.Buyer_Country__c == 'Japan' && con_new.Allow_new_process_for_Japan_picklist__c == 'allow' && japanRecord.size()> 0 && con_new.RecordTypeId == japanRecord[0].Id){
                                
                                if(con_new.IS_GTAC_Formula__c == 'True'){
                                    
                                    System.debug('############### trade term: '+con_new.Trade_term__c);
                                    System.debug('############### warranty: '+con_new.Warranty_On_Material_and_Workmanship__c);
                                    System.debug('############### sinosure: '+con_new.Sinosure_Confirmed__c);
                                    
                                    // Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Standard + Sino
                                        tools.GTAC_DDP_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Linear + Sino
                                        tools.GTAC_DDP_Linear_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Standard + Sino
                                        tools.GTAC_EXW_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Linear + Sino
                                        tools.GTAC_EXW_Linear_Sino(con_new);
                                    }
                                    
                                    // No Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Standard + Not Sino
                                        tools.GTAC_DDP_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Linear + Not Sino
                                        tools.GTAC_DDP_Linear_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Standard + Not Sino
                                        tools.GTAC_EXW_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Linear + Not Sino
                                        tools.GTAC_EXW_Linear_NoSino(con_new);
                                    }
                                    
                                }else{
                                
                                    // Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Standard + Sino
                                        tools.DDP_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - DDP + Linear + Sino
                                        tools.DDP_Linear_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Standard + Sino
                                        tools.EXW_Standard_Sino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
                                        // 条件 - EXW + Linear + Sino
                                        tools.EXW_Linear_Sino(con_new);
                                    }
                                    
                                    // No Sinosure
                                    if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Standard + Not Sino
                                        tools.DDP_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - DDP + Linear + Not Sino
                                        tools.DDP_Linear_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Standard + Not Sino
                                        tools.EXW_Standard_NoSino(con_new);
                                    }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
                                        // 条件 - EXW + Linear + Not Sino
                                        tools.EXW_Linear_NoSino(con_new);
                                    }
                                    
                                }
                            }
                                        
                            // 条件(通用) - Seller必需=JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD - 澳大利亚模版
                            if(con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia' && ausRecord.size()> 0 && con_new.RecordTypeId == ausRecord[0].Id){
                                if(con_new.Trade_term__c == 'DDP'){
                                    tools.Australia_DDP(con_new);
                                }else if(con_new.Trade_term__c == 'EXW'){
                                    tools.Australia_EXW(con_new);
                                }
                            }            
                        }
                        
                        System.debug('############ record type : '+con_new.RecordTypeId);
                        
                        
                    }else if(con_new.Total_Quantity__c > 2800 && con_new.History_Record_Type_ID__c != null && con_new.RecordTypeId != null && con_new.RecordTypeId != con_new.History_Record_Type_ID__c && (con_new.RecordTypeId == ausRecord[0].Id || con_new.RecordTypeId == japanRecord[0].Id)){
                        con_new.RecordTypeId = Id.valueOf(con_new.History_Record_Type_ID__c);
                    }
                }
            }
        }*/
        
        
        

//    }
}