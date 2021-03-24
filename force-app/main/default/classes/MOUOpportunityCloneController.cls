/*
 * Created by leal on 2020/4/9.
 */
public with sharing class MOUOpportunityCloneController {

	public List<SelectOption> RecordTypeNameList {
		get;set;
	}
	public List<SelectOption> TradeTermList {
		get;set;
	}
	public String RecordTypeName {
		get;set;
	}
	public String TradeTerm {
		get;set;
	}
	public Opportunity OpportunityClone {
		get;set;
	}
	public Id oId {
		get;set;
	}
	Public List<OpportunityLineItem> opportunityLineItemList{
		get;set;
	}
	public String OpportunityName{
		get;set;
	}
	public String DeliveryPoint{
		get;set;
	}

	public MOUOpportunityCloneController(ApexPages.StandardController controller) {
		//获取当前的业务机会id
		Id oId = ((Opportunity)controller.getRecord()).Id;
		this.oId = oId;
		//初始化记录类型
		this.RecordTypeNameList = initRecordTypeList();
		//初始化Trade Term
		this.TradeTermList = initTradeTermList();
		//初始化Trade Term
		this.opportunityLineItemList = initOpportunityLineItemList();
		//初始化opp name
		//		Opportunity Opportunity=[SELECT Id,Name from Opportunity where id=:oId];
		//		this.OpportunityName=Opportunity.Name;

	}

	public List<opportunityLineItem> initOpportunityLineItemList() {
        String SGY ='开始';
		Id oppId = this.oId;
		System.debug('oppId----->' + oppId);
		List<opportunityLineItem> initOpportunityLineItemList = [
				SELECT Id, Save_Judgment__c, Product_Type__c, Product2Id, Goods_Description__c, MW__c, UnitPrice, MOU_Used__c,Remark_of_price_Quantity__c,
						Trade_Term__c, Quantity, Guaranteed_Delivery_Quarter__c, Guaranteed_Delivery_Date__c, Guaranteed_Delivery_Date_Note__c
				FROM OpportunityLineItem
				WHERE Opportunity.Id=:oppId
				AND Product2.Name != 'TBD'
		];
        SGY ='结束';
		System.debug('initOpportunityLineItemList------->' + initOpportunityLineItemList);
      SGY ='结束';
		return initOpportunityLineItemList;
	}

	public List<SelectOption> initTradeTermList() {
		List<String> TradeTermList = getPicklist('Opportunity', 'Trade_Term__c');
		TradeTermList.add(0, '');
		//页面显示的记录类型的集合
		List<SelectOption> TradeTermSelectOptionList = new List<SelectOption>();
		for (String name : TradeTermList) {
			TradeTermSelectOptionList.add(new SelectOption(name, name));
		}
		return TradeTermSelectOptionList;
	}

	public void CloneMOU() {
		try{
		//查出需要克隆对象的所有字段 业务机会
		Opportunity opportunity = (Opportunity)queryForRecords(Opportunity.getSObjectType(), oId);

		opportunity.Lock__c = false;

		update opportunity;

		//业务机会行项目
		List<OpportunityLineItem> opportunityLineItemList =
				(List<OpportunityLineItem>)queryChildrenRecords(OpportunityLineItem.getSObjectType(), oId);
		System.debug('opportunityLineItemList---->' + opportunityLineItemList[0].MOU_Used__c);

		//payment
		List<Payment__c> paymentList = (List<Payment__c>)queryChildrenRecords2(Payment__c.getSObjectType(), oId);

		//克隆MOU业务机会
		Opportunity opportunityClone = opportunity.clone(false, false, false, false);

		//克隆后的业务机会的mou 业务机会默认为克隆的mou 业务机会
		opportunityClone.MOU_Opportunity__c = this.oId;
		opportunityClone.Trade_Term__c = this.TradeTerm;
		opportunityClone.Name = this.OpportunityName;
        opportunityClone.delivey_point__c = this.DeliveryPoint;
            opportunityClone.Sales_type__c = null;
            opportunityClone.Opportunity_Type__c ='Under Frame';
           opportunityClone.Frame_Contract_opportunity__c = this.oId;
		insert opportunityClone;
		this.OpportunityClone = OpportunityClone;

		List<OpportunityLineItem> opportunityLineItemListClone = new List<OpportunityLineItem>();
		List<OpportunityLineItem> oldOpportunityLineItemList = new List<OpportunityLineItem>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			//页面上选中的业务机会行项目 才会进行克隆操作
			if (item.MOU_Used__c) {
				System.debug('item clone mou used---->');
				OpportunityLineItem itemClone = item.clone(false, false);
				itemClone.OpportunityId = opportunityClone.Id;
				itemClone.TotalPrice = null;
				opportunityLineItemListClone.add(itemClone);
			}
			//将对应的行项目标记清空
			item.MOU_Used__c = false;
			oldOpportunityLineItemList.add(item);
			//itemClone.UnitPrice=1;
		}
		update oldOpportunityLineItemList;
		insert opportunityLineItemListClone;

		List<Payment__c> paymentListClone = new List<Payment__c>();
		for (Payment__c item : paymentList) {
			if (item.Judgement_null__c) {
				Payment__c itemClone = item.clone(false, false);
				itemClone.Opportunity__c = opportunityClone.Id;
				paymentListClone.add(itemClone);

			}

		}


		if (paymentListClone.size() != 0) {
			insert paymentListClone;
		}

		lockOpportunity(oId);
		}catch(exception e){
			System.debug('捕捉异常');
			e.getMessage();
			System.debug('捕捉异常------------>'+e.getMessage());
		}
	}

	@Future
	public static void lockOpportunity(Id oppId) {
		Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Id =:oppId];
		opportunity.Lock__c = true;
		update opportunity;
	}

	//判断opp 和对应的opp 行项目 是否是相同类型的TradeTerm
	private Boolean sameTradeTerm() {
		Boolean used = true;
		//根据页面信息更改业务机会行项目
		List<OpportunityLineItem> OpportunityLineItemList1 = new List<OpportunityLineItem>();
		for (OpportunityLineItem lineItem : opportunityLineItemList) {
			OpportunityLineItemList1.add(lineItem);
			//行项目字段标记为作为克隆子对象,其他默认为不克隆子对象
			//			if (lineItem.MOU_Used__c) {
			//				if (lineItem.Trade_Term__c == THIS.TradeTerm) {
			//					used = true;
			//				} else {
			//					used = false;
			//					break;
			//				}
			//
			//			}
			//lineItem.MOU_Used__c=false;
		}
		System.debug('OpportunityLineItemList1------>' + OpportunityLineItemList1);
		update OpportunityLineItemList1;
		return used;
	}

	//执行save 进行保存克隆
	public PageReference doSaveAndClone() {
		try{
		//判断opp 和对应的opp 行项目 是否是相同类型的TradeTerm
		//		if (!sameTradeTerm()) {
		//			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select same trade term'));
		//			return null;
		//		}
		sameTradeTerm();
		//执行克隆
		CloneMOU();

		//根据页面传递过来的记录类型id,更新克隆后的业务机会
		this.opportunityClone.RecordTypeId = RecordTypeName;
		update this.opportunityClone;
		//跳转到克隆后的业务机会编辑页面
		PageReference clonePage = new PageReference('/' + opportunityClone.id + '/e?retURL=%2F' + opportunityClone.id);
		clonePage.setRedirect(true);
		return clonePage;
		}catch (exception e){

			e.getMessage();
			system.debug('捕捉到异常了------------->'+e.getMessage());
			return null;
		}
	}

	//查询所有的业务机会的字段信息 工具类
	private static sObject queryForRecords(Schema.sObjectType oType, ID rId) {

		String[] fldsToClone = getCreateableFields(oType);

		String query = 'Select ';

		query += string.join(fldsToClone, ',');


		query += ' From Opportunity' ; // + ' Where ID IN :rIds';


		query += ' Where ID = :rId';

		return database.query(query);

	}

	//根据对象类型 获取该对象的所有字段 工具类
	private static String[] getCreateableFields(Schema.sObjectType obj) {
		String[] results = New String[]{
				};
		for (Schema.sObjectField fld : obj.getDescribe().fields.getMap().values()) {

			Schema.DescribeFieldResult dfr = fld.getDescribe();

			//ignore Unique fields. They will have to be filled in manually
		//	if (!dfr.isUnique() && (dfr.isCreateable() || dfr.isUpdateable())) {
				results.add(dfr.getName());
		//	}
		}


		return results;

	}

	//查询出对应的子对象
	private static List<sObject> queryChildrenRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);

		String query = 'Select ';

		query += string.join(fldsToClone, ',');


		query += ' From OpportunityLineItem ' ; // + ' Where ID IN :rIds';


		query += ' Where OpportunityId = :OpportunityId';

		return database.query(query);

	}

	//查询出对应的子对象
	Public static List<sObject> queryChildrenRecords2(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);

		String query = 'Select ';

		query += string.join(fldsToClone, ',');

		query += ' From Payment__c ' ; // + ' Where ID IN :rIds';


		query += ' Where Opportunity__c = :OpportunityId';

		return database.query(query);

	}

	//获取对应对象以及字段的picklist集合
	public static List<String> getPicklist(String objName, String fieldName) {
		List<String> lstPicklist = new List<String>();
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objName);
		Sobject Object_name = targetType.newSObject();
		Schema.sObjectType sobjectType = Object_name.getSObjectType();
		Schema.DescribeSObjectResult sobject_describe = sobjectType.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
		for (Schema.PicklistEntry a : pick_list_values) {
			lstPicklist.add(a.getValue());
		}
		return lstPicklist;
	}

	//初始化业务机会记录类型
	public List<SelectOption> initRecordTypeList() {
		//		Id recordTypeId =
		//				Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU').getRecordTypeId();
		//		Id recordTypeId2 =
		//				Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MOU2').getRecordTypeId();
		Set<String> RecordTypeSet = new Set<String>();
		//获取所有业务机会的记录类型
		List<recordtype> recordTypeList = [select id, name from recordtype where sobjecttype =: 'Opportunity'];
        System.debug('20201030V1---:'+recordTypeList);
		//获取业务机会记录类型的详细信息
		List<RecordTypeInfo> recordTypeInfoList = Schema.SObjectType.Opportunity.getRecordTypeInfos();
          System.debug('20201030V2---:'+recordTypeInfoList);
		for (recordtype opp : recordTypeList) {
			for (RecordTypeInfo info : recordTypeInfoList) {
				//判断当前用户是否有对应记录类型的权限
				if (info.isAvailable() && info.getRecordTypeId() == opp.Id) {
					RecordTypeSet.add(opp.Name);
				}
			}


		}
		//页面显示的记录类型的集合
		List<SelectOption> RecordTypeNameList = new List<SelectOption>();
          System.debug('20201030V3---:'+RecordTypeSet);
		for (String name : RecordTypeSet) {
             System.debug('20201030V4---:'+name);
			Id RecordTypeId =
					Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(name).getRecordTypeId();
			//排除克隆mou 类型的
			if (name != 'Letter of Award' && name != 'General Terms and Conditions' &&
							name != 'Memorandum of Understanding' && name != 'Letter of Intention' &&
							name != 'Head of Terms' && name != 'Master Supply Agreement' && name != 'Frame Agreement' &&
							name != 'Distribution Agreement') {
				RecordTypeNameList.add(new SelectOption(RecordTypeId, name));
			}
		}

		return RecordTypeNameList;
	}

}