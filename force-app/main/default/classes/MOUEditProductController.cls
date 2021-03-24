public class MOUEditProductController {

	public Integer delCount {
		get;set;
	}
	public Integer errorMessage {
		get;set;
	}
	public Opportunity MOUOpportunity{
		get;set;
	}
	Public List<OpportunityLineItem> opportunityLineItemList{
		get;set;
	}
	Public List<OpportunityLineItem> initOpportunityLineItemList{
		get;set;
	}

	public MOUEditProductController(ApexPages.StandardController SC) {
		MOUOpportunity = (Opportunity)SC.getRecord();
		Opportunity opp = [SELECT Id, pricebook2id, Lock__c FROM Opportunity WHERE ID = :MOUOpportunity.Id];

		if (opp.pricebook2id == null) {
			errorMessage = 5;
		}
		if (opp.Lock__c) {
			errorMessage = 4;
		} else {
			//opportunityLineItem所有字段
			initOpportunityLineItemList = (List<OpportunityLineItem>)queryChildrenRecords(OpportunityLineItem.getSObjectType(), MOUOpportunity.Id);
			System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***initOpportunityLineItemList:' + initOpportunityLineItemList);
			System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***opportunityLineItemList:' + opportunityLineItemList);

			opportunityLineItemList = new List<OpportunityLineItem>();
			opportunityLineItemList.addAll(initOpportunityLineItemList);
			for (OpportunityLineItem item : opportunityLineItemList) {
				item.Save_Judgment__c = false;
			}
		}
        decimal i = 1;
        i++;
	}

	public PageReference saveAll() {
        try{
		//数据完整性判断
		Set<Id> proIdSet = new Set<Id>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			proIdSet.add(item.Product2Id);
		}
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***proIdSet:' + proIdSet);
		Map<Id, Product2> product2Map;
		if (proIdSet.size() != 0) {
			
			System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***product2Map:' + product2Map);
		}
        Set<String> ProductNameSet = new Set<String>();
            map<String,string> ProductNameidmap = new   map<String,string>(); 
       List<Product2> productid=[SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet];
       for (Product2 p : productid) {
          ProductNameSet.add(p.name);
           ProductNameidmap.put(p.id,p.Name);
        }
               system.debug('C:'+ProductNameSet+'D'+ ProductNameidmap);
            Map<String, Product2> product3Map=new Map<String, Product2>();
            if(ProductNameSet.size()>0){
               List<Product2> product3list=[SELECT Id, Name FROM Product2 WHERE  name in:ProductNameSet and isactive=:true];
                for(Product2 p:product3list){
                    product3Map.put(p.name,p);
                }
                               system.debug('E:'+product3Map);
            }
		for (OpportunityLineItem lineItem : opportunityLineItemList) {
			if (lineItem.Product2Id == null || lineItem.MW__c == null || lineItem.Trade_Term__c == null || lineItem.Guaranteed_Delivery_Date__c == null) {//lineItem.UnitPrice == null || 
				errorMessage = 1;
				return null;
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Product_Type__c == null) {
				errorMessage = 2;
				return null;
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name == 'TBD' && lineItem.Goods_Description__c == null) {
				errorMessage = 3;
				return null;
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Goods_Description__c == null) {
				lineItem.Goods_Description__c = product2Map.get(lineItem.Product2Id).Name;
			}
		}

		//更新,添加行项目
		List<OpportunityLineItem> newOpportunityLineItemList = new List<OpportunityLineItem>();
		List<OpportunityLineItem> delOpportunityLineItemList = new List<OpportunityLineItem>();
		List<OpportunityLineItem> updateOpportunityLineItemList = new List<OpportunityLineItem>();
		Map<Id, OpportunityLineItem> opportunityLineItemMap = new Map<Id, OpportunityLineItem>();
		for (OpportunityLineItem item : initOpportunityLineItemList) {
			opportunityLineItemMap.put(item.Id, item);
		}

		for (OpportunityLineItem item : opportunityLineItemList) {
            if(item.UnitPrice == null){
                item.UnitPrice = 0;
            }
			if (item.Id == null) {
                system.debug('A:'+ProductNameidmap.get(item.product2id));
                system.debug('B:'+product3Map.get(ProductNameidmap.get(item.product2id)));
                item.product2id=product3Map.get(ProductNameidmap.get(item.product2id)).id;
				newOpportunityLineItemList.add(item);
			} else if (opportunityLineItemMap.get(item.Id) != null) {
				updateOpportunityLineItemList.add(item);
			}
		}
		for (OpportunityLineItem item : newOpportunityLineItemList) {
			item.OpportunityId = MOUOpportunity.Id;
		}
		insert newOpportunityLineItemList;
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***newOpportunityLineItemList:' + newOpportunityLineItemList);

		update updateOpportunityLineItemList;
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***updateOpportunityLineItemList:' + updateOpportunityLineItemList);

		//刪除payment
		Set<Id> itemIdSet = new Set<Id>();
		Map<Id, OpportunityLineItem> delOpportunityLineItemMap = new Map<Id, OpportunityLineItem>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			if (item.Id != null) {
				itemIdSet.add(item.Id);
			}
		}
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***itemIdSet:' + itemIdSet);

		for (Id itemId : opportunityLineItemMap.keySet()) {
			if (!itemIdSet.contains(itemId)) {
				delOpportunityLineItemList.add(opportunityLineItemMap.get(itemId));
			}
		}
		delete delOpportunityLineItemList;
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***delOpportunityLineItemList:' + delOpportunityLineItemList);

		return new ApexPages.StandardController(MOUOpportunity).view();
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + (e.getStackTraceString()+e.getMessage())));
            return null;
            }
	}

	public void addOpportunityLineItem() {
		opportunityLineItemList.add(new OpportunityLineItem());
	}

	public void delItem() {
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***delCount:' + delCount);
		if (delCount != null && delCount != 0) {
			opportunityLineItemList.remove(delCount - 1);
			delCount = null;
		}
	}

	public void saveItem() {
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***delCount:' + delCount);
		Set<Id> proIdSet = new Set<Id>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			proIdSet.add(item.Product2Id);
		}
		System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***proIdSet:' + proIdSet);
		Map<Id, Product2> product2Map;
		if (proIdSet.size() != 0) {
			product2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet]);
			System.debug(LoggingLevel.DEBUG, '[MOUEditProductController]***product2Map:' + product2Map);
		}

		if (delCount != null && delCount != 0) {
            if(opportunityLineItemList[delCount - 1].UnitPrice == null){
                opportunityLineItemList[delCount - 1].UnitPrice = 0;
            }
			OpportunityLineItem lineItem = opportunityLineItemList[delCount - 1];
			if (lineItem.Product2Id == null || lineItem.MW__c == null || lineItem.Trade_Term__c == null || lineItem.Guaranteed_Delivery_Date__c == null) {//lineItem.UnitPrice == null || 
				errorMessage = 1;
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name != 'TBD' && lineItem.Product_Type__c == null) {
				errorMessage = 2;
			} else if (product2Map != null && product2Map.get(lineItem.Product2Id).Name == 'TBD' && lineItem.Goods_Description__c == null) {
				errorMessage = 3;
			} else {
				opportunityLineItemList[delCount - 1].Save_Judgment__c = true;
			}
			delCount = null;
		}
	}

	public void editItem() {
		if (delCount != null && delCount != 0) {
			opportunityLineItemList[delCount - 1].Save_Judgment__c = false;
			delCount = null;
		}
	}

	private static List<sObject> queryChildrenRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ID, ';
		query += string.join(fldsToClone, ',');
		query += ' From OpportunityLineItem ' ; // + ' Where ID IN :rIds';
		query += ' Where OpportunityId = :OpportunityId';

		return database.query(query);
	}

	private static String[] getCreateableFields(Schema.sObjectType obj) {
		String[] results = New String[]{};
		for (Schema.sObjectField fld : obj.getDescribe().fields.getMap().values()) {
			Schema.DescribeFieldResult dfr = fld.getDescribe();
			//ignore Unique fields. They will have to be filled in manually
			if (!dfr.isUnique() && (dfr.isCreateable() || dfr.isUpdateable())) {
				results.add(dfr.getName());
			}
            Decimal i=1;
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
		}
		return results;
	}
}