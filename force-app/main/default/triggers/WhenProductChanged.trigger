trigger WhenProductChanged on OpportunityLineItem (before insert ,before update ,after update,after insert) {  	   

	if(trigger.isAfter){ 
        if(trigger.isUpdate){
            if(checkRecursive.runOnce10()){ 
              String opid;
	    Set<string> oppIds = new Set<string>();   	   
		for(OpportunityLineItem oppLine : trigger.new){
			oppIds.add(oppLine.OpportunityId);
              opid=oppLine.OpportunityId;
		}	   
              List<payment__c> palst= [select id,name,Opportunity__c from payment__c where Opportunity__c=:opid];//,Field1__c
            system.debug('palst.size()'+palst.size());
            if(palst.size()>0){
               // palst[0].Field1__c=palst[0].Field1__c+1;
                 update palst;
                system.debug('业务机会产品更改主动刷新业务机会付款方式233');
            }
            
	    Map<ID,Opportunity>  oppMap = new Map<ID,Opportunity>([SELECT Id,Name,
                                                               owner.name,
                                                                    Owner.Region__c,
																	Price_Approval_Status__c,
																	is_intercompany__c,
                                                               HaoXinMeng_Approvel__c,
                                                               Cross_region_GM_approval__c,
																	Sales_manager_approval__c,
                                                                    Destination_Country__c,
                                                                    Region__c,
                                                                    Trade_Term__c,
                                                                    Sales_Region__c
																	FROM Opportunity 
																	WHERE Id in: oppIds]);
		System.debug('############ oppIds: '+ oppIds);
        List<Opportunity> oppList = new List<Opportunity>();
             String str;
        for(OpportunityLineItem prod_new : trigger.new){
           str='0';
            for(OpportunityLineItem prod_old : trigger.old){




                if(prod_new.UnitPrice !=null && prod_old.UnitPrice !=null){
       
                      if(((prod_new.Quantity != prod_old.Quantity && ((prod_new.Quantity>prod_old.Quantity*1.05 || prod_new.Quantity<prod_old.Quantity*0.95 )|| prod_old.region__c=='Latin America&Italy' )) || ( prod_new.UnitPrice != prod_old.UnitPrice && ((prod_new.UnitPrice>prod_old.UnitPrice*1.05 || prod_new.UnitPrice<prod_old.UnitPrice*0.95 )|| prod_old.region__c=='Latin America&Italy'))) && (prod_old.Quantity!=null || prod_old.Quantity!=0.00) && prod_new.Id == prod_old.Id){
                              	
                	if(oppMap.containsKey(prod_new.OpportunityId)){


                    	Opportunity opp = oppMap.get(prod_new.OpportunityId);
                    	System.debug('############ oppID: '+ opp.Id);                    	
                	//Opportunity opp = [SELECT Id,Name,Price_Approval_Status__c,is_intercompany__c FROM Opportunity WHERE Id =: prod_new.OpportunityId];
	                    System.debug('############ price approval status1: '+opp.Price_Approval_Status__c);





                            if(opp.Price_Approval_Status__c=='Approved'){opp.Price_Approval_Status__c = 'Pending';}
                            if(opp.HaoXinMeng_Approvel__c =='Approved'){opp.HaoXinMeng_Approvel__c = 'Pending';}
                         if(opp.Cross_region_GM_approval__c == 'Approved'){opp.Cross_region_GM_approval__c = 'Pending';}
                            if(opp.Sales_manager_approval__c =='Approved'){opp.Sales_manager_approval__c ='Pending';}
                         system.debug('1111-->');
                        oppList.add(opp);
	                    //update opp;	                    
	                    System.debug('############ price approval status2: '+opp.Price_Approval_Status__c);  
                      
	                  
                	}
                }
                     
                 if(prod_new.Guaranteed_Delivery_Date__c != prod_old.Guaranteed_Delivery_Date__c && prod_new.Guaranteed_Delivery_Date__c < prod_old.Guaranteed_Delivery_Date__c && prod_old.Guaranteed_Delivery_Date__c !=null && prod_new.Id == prod_old.Id){
                    if(oppMap.containsKey(prod_new.OpportunityId)){                    	
                    	Opportunity opp = oppMap.get(prod_new.OpportunityId);
                    	System.debug('############ oppID: '+ opp.Id);                    	
                	//Opportunity opp = [SELECT Id,Name,Price_Approval_Status__c,is_intercompany__c FROM Opportunity WHERE Id =: prod_new.OpportunityId];
	                    System.debug('############ price approval status1: '+opp.Price_Approval_Status__c);
                         system.debug('222-->');
	                  
                          if(opp.Price_Approval_Status__c=='Approved'){opp.Price_Approval_Status__c = 'Pending';}
                            if(opp.HaoXinMeng_Approvel__c =='Approved'){opp.HaoXinMeng_Approvel__c = 'Pending';}
                         if(opp.Cross_region_GM_approval__c == 'Approved'){opp.Cross_region_GM_approval__c = 'Pending';}
                            if(opp.Sales_manager_approval__c =='Approved'){opp.Sales_manager_approval__c ='Pending';}
                        oppList.add(opp);
	                    //update opp;	                    
	                    System.debug('############ price approval status2: '+opp.Price_Approval_Status__c);  
                        
                        }          
                }     
                    
                                    if(prod_new.id==prod_old.id){
                                        
                                        if((prod_new.Inventorytype__c != prod_old.Inventorytype__c && prod_old.Inventorytype__c!=null)|| (prod_new.Stock_age__c!= prod_old.Stock_age__c && prod_old.Stock_age__c!=null)){
                                        system.debug('比较'+prod_new.Inventorytype__c+';'+prod_old.Inventorytype__c);
                                         system.debug('比较'+prod_new.Stock_age__c+';'+prod_old.Stock_age__c);
                         str='1';
                                            break;
                }       
                                        }
                    
                    
                    
                }
            }
             system.debug('打桩:'+str);
            if(str=='1'){
                Opportunity opp = oppMap.get(prod_new.OpportunityId);
                system.debug('准备发送邮件给OWner 重新提交审批:'+opp.owner.name);
                  if(opp.Price_Approval_Status__c == 'Approved'){opp.Price_Approval_Status__c = 'Pending';}
                    if(opp.Cross_region_GM_approval__c == 'Approved'){opp.Cross_region_GM_approval__c = 'Pending';}
                        if(opp.Sales_manager_approval__c =='Approved'){opp.Sales_manager_approval__c ='Pending';}
oppList.add(opp);
                system.debug(UserInfo.getUserRoleId());
                if(UserInfo.getUserRoleId().indexOf('00E90000000IEDf')!=-1 || UserInfo.getUserRoleId().indexOf('00E90000000IfgEEAS')!=-1){
                SendEmailUtils2.sendToSomeOne(prod_new.id,opp.owner.name,'OppItemStockUpdate');
                    }
                }
        }
           
        if(oppList.size()>0){

            update oppList[0];
        }
        }
 }  
        if(trigger.isinsert){
            if(checkRecursive.runOnce11()){ 
              system.debug('?insert jinlai');
            String oppIds ;
            String flag='0';
            for(OpportunityLineItem oppLin: trigger.new){
                system.debug('?oppLin.sameproduct__c'+oppLin.sameproduct__c);
                oppIds=oppLin.OpportunityId;
                if(oppLin.sameproduct__c==false){
                    system.debug('?');
                    flag='1';
                }
            }
          Opportunity opp =  [SELECT Id,Name,
                                                               owner.name,
                                                                    Owner.Region__c,
																	Price_Approval_Status__c,
																	is_intercompany__c,
                                                               HaoXinMeng_Approvel__c,
                                                               Cross_region_GM_approval__c,
																	Sales_manager_approval__c,
                                                                       Destination_Country__c,
                                                                       Region__c,
                                                                        Trade_Term__c,
                                                                        Sales_Region__c,
                                                                        MOU_Type_Judgment__c
																	FROM Opportunity 
																	WHERE Id =: oppIds];

                     if(opp.MOU_Type_Judgment__c==false){
            for(OpportunityLineItem oppLin2: trigger.new){
           
                    if(trigger.isbefore){
                        
                    

                oppLin2.Opp_Country_Text__c = opp.Destination_Country__c;
                oppLin2.Opp_Region_Text__c = opp.Region__c;
                oppLin2.Opp_Sales_Region_Text__c = opp.Sales_Region__c;
                oppLin2.opp_trade_term_Text__c = opp.Trade_Term__c;
                        }
                
            
       
            if(flag=='1'){
                  system.debug('??');
                if(opp.Price_Approval_Status__c=='Approved'){opp.Price_Approval_Status__c = 'Pending';}
                            if(opp.HaoXinMeng_Approvel__c =='Approved'){opp.HaoXinMeng_Approvel__c = 'Pending';}
                         if(opp.Cross_region_GM_approval__c == 'Approved'){opp.Cross_region_GM_approval__c = 'Pending';}
                            if(opp.Sales_manager_approval__c =='Approved'){opp.Sales_manager_approval__c ='Pending';}
            }
            }
                    update opp;
            }
                
        }
        }      
        /*for(OpportunityLineItem prod_new : trigger.new){
            for(OpportunityLineItem prod_old : trigger.old){ 
            	//编辑业务机会的时候不允许修改产品名字，若修改请删除，重新添加。
                if(prod_new.Product2Id != prod_old.Product2Id){                	
                    //Opportunity opp = [SELECT Id,Name,Price_Approval_Status__c,is_intercompany__c FROM Opportunity WHERE Id =: prod_new.OpportunityId];
                    //Opportunity opp = [SELECT Id,Name,Price_Approval_Status__c,is_intercompany__c FROM Opportunity WHERE Id in : oppIDs and Id =: prod_new.OpportunityId];
                    if(oppMap.containsKey(prod_new.OpportunityId)){                    	
                    	Opportunity opp = oppMap.get(prod_new.OpportunityId);
                    	System.debug('############ oppID: '+ opp.Id);
	                    System.debug('############ price approval status1: '+opp.Price_Approval_Status__c);
	                    opp.Price_Approval_Status__c = 'Pending';
	                    update opp;	                    
	                    System.debug('############ price approval status2: '+opp.Price_Approval_Status__c);	                    
	                    //if(!opp.is_intercompany__c)SendEmailUtils.sendToLogistics(prod_new.OpportunityId);
                    }                    
                }                
                //单价或数量改变时，价格审批状态变为Pending
                if(( prod_new.Quantity != prod_old.Quantity ) || ( prod_new.UnitPrice != prod_old.UnitPrice)){
                	System.debug('############in price approval111');                	
                	if(oppMap.containsKey(prod_new.OpportunityId)){                    	
                    	Opportunity opp = oppMap.get(prod_new.OpportunityId);
                    	System.debug('############ oppID: '+ opp.Id);                    	
                	//Opportunity opp = [SELECT Id,Name,Price_Approval_Status__c,is_intercompany__c FROM Opportunity WHERE Id =: prod_new.OpportunityId];
	                    System.debug('############ price approval status1: '+opp.Price_Approval_Status__c);
	                    opp.Price_Approval_Status__c = 'Pending';
	                    update opp;	                    
	                    System.debug('############ price approval status2: '+opp.Price_Approval_Status__c);
                	}
                }
            }
        }
		if(trigger.isupdate){
			List<Opportunity> updateOpp = new List<Opportunity>();			
			for(OpportunityLineItem line_new : trigger.new){
				for(OpportunityLineItem line_old : trigger.old){
					if((line_new.UnitPrice != line_old.UnitPrice || line_new.Quantity != line_old.Quantity) && oppMap.get(line_new.OpportunityId) != null){
						Opportunity opp = oppMap.get(line_new.OpportunityId);
						opp.Price_Approval_Status__c = 'Pending';
						opp.Sales_manager_approval__c = 'Pending';
						updateOpp.add(opp);
					}
				}
			}			
			if(updateOpp.size()>0){
				try{
					update updateOpp;
				}catch(Exception e){
					System.debug('------------------> '+String.valueOf(e));
				}
			}
		}*/
	}
    //List<Product2> prodList = [SELECT ID,Name FROM Product2 limit 3000];
    Set<Id> ids = new set<ID>();//存放业务机会新增产品的关联产品ID
    Set<Id> OppLinID = new set<ID>();//存放业务机会产品ID
    if(trigger.isBefore){


       
        for(OpportunityLineItem line : trigger.new){
          ids.add(line.Product2Id);
          
          OppLinID.add(line.Id);
        }

        if(trigger.isUpdate){
            if(checkRecursive.runOnce12()){ 
            String oppIds ;
            for(OpportunityLineItem oppLin: trigger.new){

                oppIds=oppLin.OpportunityId;
            }

            Opportunity opp =  [SELECT Id,Name,
            owner.name,
            Owner.Region__c,
            Price_Approval_Status__c,
            is_intercompany__c,
            HaoXinMeng_Approvel__c,
            Cross_region_GM_approval__c,
            Sales_manager_approval__c,
            Destination_Country__c,
            Region__c,
            Trade_Term__c,
            Sales_Region__c,
            MOU_Type_Judgment__c
            FROM Opportunity
            WHERE Id =: oppIds];

            for(OpportunityLineItem oppLin2: trigger.new){
                if(opp.MOU_Type_Judgment__c==false){
                oppLin2.Opp_Country_Text__c = opp.Destination_Country__c;
                oppLin2.Opp_Region_Text__c = opp.Region__c;
                oppLin2.Opp_Sales_Region_Text__c = opp.Sales_Region__c;
                oppLin2.opp_trade_term_Text__c = opp.Trade_Term__c;
                }
            }
        }
    }
   
        List<Product2> prodList = [SELECT ID,Name FROM Product2 where ID in:ids];
         List<OpportunityLineItem> OppprodList = [SELECT ID,Name,UnitPrice,CurrencyIsoCode FROM OpportunityLineItem where ID in:OppLinID];
                 Map<String, Double> codeRateMap = new Map<String, Double>();
            for (CurrencyType ct : [SELECT IsoCode,
                                           ConversionRate
                                    FROM CurrencyType]){
                codeRateMap.put(ct.IsoCode, ct.ConversionRate);
                                    }
           
         
           
        
        //结束
        for(OpportunityLineItem line : trigger.new){
            for(OpportunityLineItem oppprod :OppprodList ){
                if(line.Id ==oppprod.Id){
                    Double rate =codeRateMap.get(oppprod.CurrencyIsoCode);
                   line.Sales_Price_Another__c =  oppprod.UnitPrice/rate;
                }
            }
        }
        for(OpportunityLineItem line : trigger.new){
          for(Product2 prod : prodList){
            	Integer i = 0;
                if(prod.Id == line.Product2Id){
                    line.Product_Name__c = prod.Name;
                    System.debug('========： ' + i++ +':' + prod.Name);
                }
            }
        }
    }
         
}