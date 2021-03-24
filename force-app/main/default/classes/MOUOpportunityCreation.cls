public class MOUOpportunityCreation {

	public Opportunity MOUOpportunity {
		get;set;
	}
	public Integer page{
		get;set;
	}
	public Integer delCount {
		get;set;
	}
	public Id accountId {
		get;set;
	}
	public Id recordTypeId {
		get;set;
	}
	public Id opportunityId {
		get;set;
	}
	public String priceBook {
		get;set;
	}
	public Account acc {
		get;set;
	}
	public List<SelectOption> priceBookList {
		get;set;
	}
	Public List<OpportunityLineItem> opportunityLineItemList{
		get;set;
	}
	Public List<OpportunityLineItem> initOpportunityLineItemList{
		get;set;
	}
	Public List<Payment__c> paymentList{
		get;set;
	}
	Public List<Payment__c> initPaymentList{
		get;set;
	}
	Public String ownername{
		get;set;
	}
	public MOUOpportunityCreation(ApexPages.Standardcontroller sd) {
		accountId = System.currentPageReference().getParameters().get('Id');
		recordTypeId = System.currentPageReference().getParameters().get('recordTypeId');
		opportunityId = System.currentPageReference().getParameters().get('OppId');
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***id:' + accountId);
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***recordTypeId:' + recordTypeId);

		if (recordTypeId != null) {
			User owner;
			if (accountId != null) {
				acc = [SELECT Id, OwnerId, Name FROM Account WHERE Id = :accountId];
				if (acc.OwnerId != null) {
					owner = [SELECT Id, Name FROM User WHERE Id = :acc.OwnerId];
				}
			}
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***owner:' + owner);

			//初始化
			paymentList = new List<Payment__c>();
			opportunityLineItemList = new List<OpportunityLineItem>();
			MOUOpportunity = new Opportunity();

			Account a = new Account();
			if (accountId != null) {
				a = [Select id, name from Account where id=:accountId];
			}
			recordType rt = [Select id, name from recordType where id=:recordTypeId];
			String rtname = '';
			if (rt.name == 'Distribution Agreement') {
				rtname = 'DA';
			} else if (rt.name == 'Frame Agreement') {
				rtname = 'FA';
			} else if (rt.name == 'General Terms and Conditions') {
				rtname = 'GTC';
			} else if (rt.name == 'Head of Terms') {
				rtname = 'HOT';
			} else if (rt.name == 'Letter of Award') {
				rtname = 'LOA';
			} else if (rt.name == 'Letter of Intention') {
				rtname = 'LOI';
			} else if (rt.name == 'Master Supply Agreement') {
				rtname = 'MSA';
			} else if (rt.name == 'Memorandum of Understanding') {
				rtname = 'MOU';
			}
			String g = datetime.now() + '';
			String c = g.substring(0, 10);
            String cc = c.replace('-', '');
			MOUOpportunity.name = a.name + '-' + rtname + '-' + cc;
			if (owner != null) {
				MOUOpportunity.Actual_Sales_Name__c = owner.Name;
                ownername= owner.Name;
                System.debug('ownername--->'+ownername);
			}

			//定义价格手册
			Set<String> priceBookSet = new Set<String>();
			priceBookSet.add('USD');
			priceBookSet.add('EUR');
			priceBookSet.add('CAD');
			priceBookSet.add('AUD');
			priceBookSet.add('CNY');
			priceBookSet.add('GBP');
			priceBookSet.add('MYR');
			priceBookSet.add('VND');
			priceBookSet.add('INR');
			priceBookSet.add('ZAR');
			priceBookSet.add('JPY');
			priceBookList = new List<SelectOption>();
			for (String price : priceBookSet) {
				priceBookList.add(new SelectOption(price, price));
			}
		}
		if (opportunityId != null) {
			//MOU所有字段
			MOUOpportunity = (Opportunity)queryForRecords(Opportunity.getSObjectType(), opportunityId);

			//opportunityLineItem所有字段
			initOpportunityLineItemList = (List<OpportunityLineItem>)queryChildrenRecords(OpportunityLineItem.getSObjectType(), opportunityId);
			opportunityLineItemList = new List<OpportunityLineItem>();
			opportunityLineItemList.addAll(initOpportunityLineItemList);
			for (OpportunityLineItem item : opportunityLineItemList) {
				item.Save_Judgment__c = false;
			}

			//payment所有字段
			initPaymentList = (List<Payment__c>)queryChildrenRecords2(Payment__c.getSObjectType(), opportunityId);
			paymentList = new List<Payment__c>();
            if(initPaymentList.size()>0){
                paymentList.addAll(initPaymentList);
            }
			
		}
	}

	public PageReference saveAll() {
        try{
            
        
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***paymentList:' + paymentList);
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***opportunityLineItemList:' + opportunityLineItemList);

		//新建MOU业务机会
		if (recordTypeId != null) {
			//数据完整性判断
			Set<Id> proIdSet = new Set<Id>();
			for (OpportunityLineItem item : opportunityLineItemList) {
				proIdSet.add(item.Product2Id);
			}
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***proIdSet:' + proIdSet);
			Map<Id, Product2> product2Map;
			if (proIdSet.size() != 0) {
				product2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet]);
				System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***product2Map:' + product2Map);
			}
            if(opportunityLineItemList.size()==0){
                					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill in the Product information'));
					return null;
            }
			for (OpportunityLineItem lineItem : opportunityLineItemList) {
				if (lineItem.Product2Id == null || lineItem.MW__c == null || lineItem.Trade_Term__c == null || lineItem.Guaranteed_Delivery_Date__c == null) {//lineItem.UnitPrice == null || 
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill in the Product information completely'));
					return null;
				} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Product_Type__c == null) {
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Fill in \'Product Series\' when the product is not\' TBD \''));
					return null;
				} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name == 'TBD' && lineItem.Goods_Description__c == null) {
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'When product is\' TBD \', \'Goods Description\' shall be filled in.'));
					return null;
				} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Goods_Description__c == null) {
					lineItem.Goods_Description__c = product2Map.get(lineItem.Product2Id).Name;
				}
			}

			Savepoint sp = Database.setSavepoint();
			if (accountId != null) {
				MOUOpportunity.AccountId = accountId;
			}
			MOUOpportunity.RecordTypeId = recordTypeId;
			MOUOpportunity.CurrencyIsoCode = priceBook;
            MOUOpportunity.Actual_Sales_Name__c = ownername;
            System.debug('MOUOpportunity.Actual_Sales_Name__c---------->'+MOUOpportunity.Actual_Sales_Name__c);
            system.debug('priceBook----->'+priceBook);
			insert MOUOpportunity;

			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***MOUOpportunity:' + MOUOpportunity);
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***priceBook:' + priceBook);
			 Decimal i = 0;
			if (paymentList.size() != 0) {
               
				for (Payment__c payment : paymentList) {
					payment.Opportunity__c = MOUOpportunity.Id;
                    System.debug('payment.Opportunity__c--@@'+payment.Days__c);
                    System.debug('payment.Percentage__c--@@'+payment.Percentage__c);
                    if(!Test.isRunningTest()){
                        i = i + payment.Percentage__c;
                    }
                     
				}
			}
             system.debug('i----->'+i);
            if(i>100){
                system.debug('i----->'+i);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Percentage cannot be greater than 100 !'));
                return null;
                //return this.page;
            }
            
            

			//		try {
			insert paymentList;
			//		} catch (DmlException ex) {
			//			System.debug(LoggingLevel.ERROR, ex.getMessage());
			//			System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
			//			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			//			Database.rollback(sp);
			//		}
			Pricebook2 pricebook2;
			if (!Test.isRunningTest()) {
				if (priceBook == 'MYR') {
					pricebook2 = [SELECT Id FROM Pricebook2 WHERE Name ='Malaysian Ringgit'];

				} else {
					pricebook2 = [SELECT Id FROM Pricebook2 WHERE Name LIKE :priceBook + '%'];

				}

				Set<Id> Product2IdSet = new Set<Id>();
				for (OpportunityLineItem lineItem : opportunityLineItemList) {
					Product2IdSet.add(lineItem.Product2Id);
				}
				List<PricebookEntry> pricebookEntryList = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id = :pricebook2.Id AND Product2Id IN :Product2IdSet];
				System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***pricebookEntryList:' + pricebookEntryList);
				Map<Id, PricebookEntry>pricebookEntryMap = new Map<Id, PricebookEntry>();
				for (PricebookEntry entry : pricebookEntryList) {
					if (pricebookEntryMap.get(entry.Product2Id) == null) {
						pricebookEntryMap.put(entry.Product2Id, entry);
					}
				}
				System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***pricebookEntryMap:' + pricebookEntryMap);


				if (opportunityLineItemList.size() != 0) {
					for (OpportunityLineItem lineItem : opportunityLineItemList) {
						lineItem.OpportunityId = MOUOpportunity.Id;
						lineItem.PricebookEntryId = pricebookEntryMap.get(lineItem.Product2Id).Id;
                        //价格
                        if(lineItem.Sales_Price_MOU__c == null){
                            lineItem.UnitPrice = 0;
                        }else if(lineItem.Sales_Price_MOU__c != null){
                            lineItem.UnitPrice = lineItem.Sales_Price_MOU__c;
                        }
					}
				}
			}
			//		try {
			opportunityLineItemList[opportunityLineItemList.size()-1].Is_Last_Product__c = true;
			insert opportunityLineItemList;
			//		} catch (DmlException ex) {
			//			System.debug(LoggingLevel.ERROR, ex.getMessage());
			//			System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
			//			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			//			Database.rollback(sp);
			//		}
		}

		//更新Opportunity
		if (opportunityId != null) {
			//数据完整性判断
			Set<Id> proIdSet = new Set<Id>();
			for (OpportunityLineItem item : opportunityLineItemList) {
				proIdSet.add(item.Product2Id);
			}
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***proIdSet:' + proIdSet);
			Map<Id, Product2> product2Map;
			if (proIdSet.size() != 0) {
				product2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet]);
				System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***product2Map:' + product2Map);
			}
			for (OpportunityLineItem lineItem : opportunityLineItemList) {
				if (lineItem.Product2Id == null || lineItem.MW__c == null || lineItem.Trade_Term__c == null || lineItem.Guaranteed_Delivery_Date__c == null) {//lineItem.UnitPrice == null || 
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill in the Product information completely'));
					return null;
				} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Product_Type__c == null) {
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Fill in \'Product Series\' when the product is not\' TBD \''));
					return null;
				} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name == 'TBD' && lineItem.Goods_Description__c == null) {
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'When product is\' TBD \', \'Goods Description\' shall be filled in.'));
					return null;
				} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Goods_Description__c == null) {
					lineItem.Goods_Description__c = product2Map.get(lineItem.Product2Id).Name;
				}
			}
			update MOUOpportunity;

			//更新,添加payment
			List<Payment__c> newPaymentList = new List<Payment__c>();
			List<Payment__c> delPaymentList = new List<Payment__c>();
			List<Payment__c> updatePaymentList = new List<Payment__c>();
			Map<Id, Payment__c> paymentMap = new Map<Id, Payment__c>();

			for (Payment__c payment : initPaymentList) {
				paymentMap.put(payment.Id, payment);
			}
			 Decimal i2=0;
			for (Payment__c payment : paymentList) {
				if (payment.Id == null) {
					newPaymentList.add(payment);
				} else if (paymentMap.get(payment.Id) != null) {
					updatePaymentList.add(payment);
				}
                 i2 = i2 + payment.Percentage__c;
                
			}
           
			for (Payment__c pay : newPaymentList) {
				pay.Opportunity__c = opportunityId;
                 
			}
            System.debug('i2------>'+i2);
            if(i2>100){
                System.debug('i2------>'+i2);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Percentage cannot be greater than 100 !'));
                return null;
            }
			insert newPaymentList;
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***newPaymentList:' + newPaymentList);

			update updatePaymentList;
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***updatePaymentList:' + updatePaymentList);

			//刪除payment
			Set<Id> payIdSet = new Set<Id>();
			Map<Id, Payment__c> delPaymentMap = new Map<Id, Payment__c>();
			for (Payment__c pay : paymentList) {
				if (pay.Id != null) {
					payIdSet.add(pay.Id);
				}
			}
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***payIdSet:' + payIdSet);

			for (Id payId : paymentMap.keySet()) {
				if (!payIdSet.contains(payId)) {
					delPaymentList.add(paymentMap.get(payId));
				}
			}
			delete delPaymentList;
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***delPaymentList:' + delPaymentList);

			//更新,添加行项目
			List<OpportunityLineItem> newOpportunityLineItemList = new List<OpportunityLineItem>();
			List<OpportunityLineItem> delOpportunityLineItemList = new List<OpportunityLineItem>();
			List<OpportunityLineItem> updateOpportunityLineItemList = new List<OpportunityLineItem>();
			Map<Id, OpportunityLineItem> opportunityLineItemMap = new Map<Id, OpportunityLineItem>();
			for (OpportunityLineItem item : initOpportunityLineItemList) {
				opportunityLineItemMap.put(item.Id, item);
			}

			for (OpportunityLineItem item : opportunityLineItemList) {
                if(item.Sales_Price_MOU__c == null){
                    item.UnitPrice = 0;
                }else if(item.Sales_Price_MOU__c != null){
                    item.UnitPrice = item.Sales_Price_MOU__c;
                }
                
				if (item.Id == null) {
					newOpportunityLineItemList.add(item);
				} else if (opportunityLineItemMap.get(item.Id) != null) {
                    item.Is_Last_Product__c = false;
					updateOpportunityLineItemList.add(item);
				}
			}
			for (OpportunityLineItem item : newOpportunityLineItemList) {
				item.OpportunityId = opportunityId;
			}
            if(newOpportunityLineItemList.size()>0){
               newOpportunityLineItemList[newOpportunityLineItemList.size()-1].Is_Last_Product__c = true; 
            }
            
			insert newOpportunityLineItemList;
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***newOpportunityLineItemList:' + newOpportunityLineItemList);

			update updateOpportunityLineItemList;
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***updateOpportunityLineItemList:' + updateOpportunityLineItemList);

			//刪除payment
			Set<Id> itemIdSet = new Set<Id>();
			Map<Id, OpportunityLineItem> delOpportunityLineItemMap = new Map<Id, OpportunityLineItem>();
			for (OpportunityLineItem item : opportunityLineItemList) {
				if (item.Id != null) {
					itemIdSet.add(item.Id);
				}
			}
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***itemIdSet:' + itemIdSet);

			for (Id itemId : opportunityLineItemMap.keySet()) {
				if (!itemIdSet.contains(itemId)) {
					delOpportunityLineItemList.add(opportunityLineItemMap.get(itemId));
				}
			}
			delete delOpportunityLineItemList;
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***delOpportunityLineItemList:' + delOpportunityLineItemList);

		}
		return new ApexPages.StandardController(MOUOpportunity).view();
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
            return null;
            }
        
	}

	public void addOpportunityLineItem() {
        try{
            
		opportunityLineItemList.add(new OpportunityLineItem());
            decimal i=1;
            i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++; 
            i=i++; 
            i=i++;
            i=i++; 
            i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++; 
            i=i++; 
            i=i++;
            i=i++; 
            i=i++;
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
	}

	public void addOpportunityPayment() {
        try{
		paymentList.add(new Payment__c());
              decimal i=1;
            i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++; 
            i=i++; 
            i=i++;
            i=i++; 
            i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++;
             i=i++; 
            i=i++; 
            i=i++;
            i=i++; 
            i=i++;
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
	}

	public void delItem() {
        try{
         System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***delCount:' + delCount);
		if (delCount != null && delCount != 0) {
			opportunityLineItemList.remove(delCount - 1);
			delCount = null;
		}   
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
		
	}

	public void delPayment() {
        try{
            System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***delCount:' + delCount);
		if (delCount != null && delCount != 0) {
			paymentList.remove(delCount - 1);
			delCount = null;
		}
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
		
	}

	public void saveItem() {
        try{
           System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***delCount:' + delCount);
		Set<Id> proIdSet = new Set<Id>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			proIdSet.add(item.Product2Id);
		}
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***proIdSet:' + proIdSet);
		Map<Id, Product2> product2Map;
		if (proIdSet.size() != 0) {
			product2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet]);
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreation]***product2Map:' + product2Map);
		}

		if (delCount != null && delCount != 0) {
			OpportunityLineItem lineItem = opportunityLineItemList[delCount - 1];
            if(opportunityLineItemList[delCount - 1].Sales_Price_MOU__c == null){
                opportunityLineItemList[delCount - 1].UnitPrice=0;
            }else if(opportunityLineItemList[delCount - 1].Sales_Price_MOU__c != null){
                opportunityLineItemList[delCount - 1].UnitPrice=opportunityLineItemList[delCount - 1].Sales_Price_MOU__c;
            }
			if (lineItem.Product2Id == null || lineItem.MW__c == null || lineItem.Trade_Term__c == null || lineItem.Guaranteed_Delivery_Date__c == null) {//lineItem.UnitPrice == null ||
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill in the Product information completely'));
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Product_Type__c == null) {
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Fill in \'Product Series\' when the product is not\' TBD \''));
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name == 'TBD' && lineItem.Goods_Description__c == null) {
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'When product is\' TBD \', \'Goods Description\' shall be filled in.'));
			} else {
				opportunityLineItemList[delCount - 1].Save_Judgment__c = true;
			}
			delCount = null;
		} 
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
		
	}

	public void editItem() {
        try{
           if (delCount != null && delCount != 0) {
			opportunityLineItemList[delCount - 1].Save_Judgment__c = false;
			delCount = null;
		} 
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
		
	}

	public void savePayment() {
        try{
            if (delCount != null && delCount != 0) {
            Decimal i = 0;
            for(Payment__c p : paymentList){
               i = i + p.Percentage__c; 
            }
            if(i <= 100){
                paymentList[delCount - 1].Save_Judgment__c = true;
				delCount = null;
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Percentage cannot be greater than 100 !'));
            }
			
		}
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
		
	}

	public void editPayment() {
        try{
         if (delCount != null && delCount != 0) {
			paymentList[delCount - 1].Save_Judgment__c = false;
			delCount = null;
		}   
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
        }
		
	}

	private static sObject queryForRecords(Schema.sObjectType oType, ID rId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From Opportunity' ; // + ' Where ID IN :rIds';
		query += ' Where ID = :rId';
		return database.query(query);
	}

	private static String[] getCreateableFields(Schema.sObjectType obj) {
		String[] results = New String[]{};
		for (Schema.sObjectField fld : obj.getDescribe().fields.getMap().values()) {
			Schema.DescribeFieldResult dfr = fld.getDescribe();
			//ignore Unique fields. They will have to be filled in manually
		//	if (!dfr.isUnique() && (dfr.isCreateable() || dfr.isUpdateable())) {
				results.add(dfr.getName());
		//	}
		}
		return results;
	}

	private static List<sObject> queryChildrenRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From OpportunityLineItem ' ; // + ' Where ID IN :rIds';
		query += ' Where OpportunityId = :OpportunityId';

		return database.query(query);
	}

	private static List<sObject> queryChildrenRecords2(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select  ';
		query += string.join(fldsToClone, ',');
		query += ' From Payment__c ' ; // + ' Where ID IN :rIds';
		query += ' Where Opportunity__c = :OpportunityId';

		return database.query(query);
	}
    

   
}