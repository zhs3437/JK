public class MOUOpportunityApproveAgainController {
	public Id opportunityId{
		get;set;
	}
	public Integer delCount {
		get;set;
	}
	public Integer errorMessage {
		get;set;
	}
	Public Opportunity MOUOpportunity{
		get;set;
	}
	Public List<OpportunityLineItem> opportunityLineItemList{
		get;set;
	}
	Public List<Payment__c> paymentList{
		get;set;
	}
    public boolean errorFlag {
		get;set;
	}

	public MOUOpportunityApproveAgainController(ApexPages.StandardController SC) {
		try {
			opportunityId = ApexPages.currentPage().getParameters().get('id');
		} catch (Exception e) {
			opportunityId = SC.getId();

		}

		if (string.isEmpty(opportunityId)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Opporunity Id is null'));
		}
		//MOU所有字段
		MOUOpportunity = (Opportunity)queryForRecords(Opportunity.getSObjectType(), opportunityId);

		//opportunityLineItem所有字段
		opportunityLineItemList = (List<OpportunityLineItem>)queryChildrenRecords(OpportunityLineItem.getSObjectType(), opportunityId);
		for (OpportunityLineItem item : opportunityLineItemList) {
			item.Save_Judgment__c = true;
		}

		//payment所有字段
		paymentList = (List<Payment__c>)queryChildrenRecords2(Payment__c.getSObjectType(), opportunityId);
	}

	public PageReference saveAgreement() {
		//数据完整性判断
		Set<Id> proIdSet = new Set<Id>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			proIdSet.add(item.Product2Id);
		}
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***proIdSet:' + proIdSet);
		Map<Id, Product2> product2Map;
		if (proIdSet.size() != 0) {
			product2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet]);
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***product2Map:' + product2Map);
		}
		for (OpportunityLineItem lineItem : opportunityLineItemList) {
			if (lineItem.Product2Id == null || lineItem.MW__c == null ||  lineItem.Trade_Term__c == null || lineItem.Guaranteed_Delivery_Date__c == null) {//lineItem.UnitPrice == null ||
				System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***lineItem:' + lineItem);
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

		//解锁MOUOpp
		Opportunity MOUUnlockOpp = [SELECT Id, Lock__c,Roll_up_SFA_Counts__c,Roll_up_SFA_Counts_Sync_checked__c FROM Opportunity WHERE Id = :opportunityId];
        if(MOUUnlockOpp.Roll_up_SFA_Counts__c != MOUUnlockOpp.Roll_up_SFA_Counts_Sync_checked__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You can not create new amendment until last version finished.'));
                return null;  
        }
        
        
		MOUUnlockOpp.Lock__c = false;

		Update MOUUnlockOpp;

		//保存SFA
		Supplementary_Framework_Agreement__c SFA = saveSFA();
      
		//MOUOpp上锁
		MOUUnlockOpp.Lock__c = true;
		Update MOUUnlockOpp;

          if(errorFlag == true){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Percentage cannot be greater than 100 !'));
              delete SFA;
                return null;  
        }
		return new ApexPages.StandardController(SFA).view();
	}

	public Supplementary_Framework_Agreement__c saveSFA(){
		//統計版本號
		Integer con ;
		List<Supplementary_Framework_Agreement__c> SFAList = [
				SELECT Id
				FROM Supplementary_Framework_Agreement__c
				WHERE Opportunity__c = :opportunityId
		];
		if (SFAList.size() == 0) {
			con = 1;
		} else {
			con = SFAList.size() + 1;
		}

		//新建MOUOppAgreement对象
		Supplementary_Framework_Agreement__c SFA = new Supplementary_Framework_Agreement__c(
				Name = MOUOpportunity.Name + ' V' + con,
				Opportunity__c = MOUOpportunity.Id,
				Account__c = MOUOpportunity.AccountId,
				Actual_Sales_Name__c = MOUOpportunity.Actual_Sales_Name__c,
				Seller__c = MOUOpportunity.Seller__c,
				StageName__c = MOUOpportunity.StageName,
				Sales_type__c = MOUOpportunity.Sales_type__c,
				GST_Classification_Region__c = MOUOpportunity.GST_Classification_Region__c,
				Type_of_Shipping__c = MOUOpportunity.Type_of_Shipping__c,
				Type_of_Inventory_or_Production__c = MOUOpportunity.Type_of_Inventory_or_Production__c,
				Customer_Delivery_Date__c = MOUOpportunity.Customer_Delivery_Date__c,
				Confirmed_ETD__c = MOUOpportunity.Confirmed_ETD__c,
				China_Land_Freight__c = MOUOpportunity.China_Land_Freight__c,
				Oversea_Freight__c = MOUOpportunity.Oversea_Freight__c,
				Destination_Country__c = MOUOpportunity.Destination_Country__c,
				Region__c = MOUOpportunity.Region__c,
				Close_Date__c = MOUOpportunity.CloseDate,
				Seller_Text__c = MOUOpportunity.Seller_Text__c,
				Sales_type_Text__c = MOUOpportunity.Sales_type_Text__c,
				GST_Classification_Region_Text__c = MOUOpportunity.GST_Classification_Region_Text__c,
				Type_of_Shipping_Text__c = MOUOpportunity.Type_of_Shipping_Text__c,
				Warehouse_Stock_or_Production_Text__c = MOUOpportunity.Warehouse_Stock_or_Production_Text__c,
				Expected_Delivery_Date_Text__c = MOUOpportunity.Expected_Delivery_Date_Text__c,
				Estimated_Time_of_Departure_Text__c = MOUOpportunity.Estimated_Time_of_Departure_Text__c,
				Freight_Ocean__c = MOUOpportunity.Freight_Ocean__c,
				Reason_of_apply_for_insurance__c = MOUOpportunity.Reason_of_apply_for_insurance__c,
				Destination_Port__c = MOUOpportunity.Destination_Port__c,
				Total_Price_Frameeork_Text__c = MOUOpportunity.Total_Price_Frameeork_Text__c,
            	Total_MW_Framework_Text__c = MOUOpportunity.Total_MW_Framework_Text__c,
				Probability__c = MOUOpportunity.Probability
		);

		Insert SFA;

		//新建Framework Agreement Payment对象
		errorFlag = false;
		List<Framework_Agreement_Payment__c> FAPaymentList = new List<Framework_Agreement_Payment__c>();
        Decimal i = 0;
		for (Payment__c payment : paymentList) {
			Framework_Agreement_Payment__c FAPayment = new Framework_Agreement_Payment__c(
					Supplementary_framework_agreement__c = SFA.Id,
					MOU_Opportunity_Payment_Id__c = payment.Id,
					Comments__c = payment.Comments__c,
					Credit_Valid__c = payment.Credit_Valid__c,
					Days__c = payment.Days__c,
					Down_Balance_Payment__c = payment.Down_Balance_Payment__c,
					Payment_Method__c = payment.Payment_Method__c,
					Payment_Term__c = payment.Payment_Term__c,
					PaymentDescription__c = payment.PaymentDescription__c,
					Percentage__c = payment.Percentage__c,
					Precise_Day__c = payment.Precise_Day__c
			);
            i = i + FAPayment.Percentage__c;
			FAPaymentList.add(FAPayment);
		}
        if(i>100){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Percentage cannot be greater than 100 !'));
           		errorFlag = true;
                return SFA;  
        }
		//Insert FAPaymentList;

		//新建Framework Agreement Product对象
		List<Framework_Agreement_Product__c> FAProductList = new List<Framework_Agreement_Product__c>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			Framework_Agreement_Product__c FAProduct = new Framework_Agreement_Product__c(
					Supplementary_framework_agreement__c = SFA.Id,
					Product2__c = item.Product2Id,
					TotalPrice__c = item.Total_Price__c,
					Sales_Price__c = item.UnitPrice,
					Trade_Term__c = item.Trade_Term__c,
					MixedDelivery__c = item.MixedDelivery__c,
					Amend_Date__c = item.Amend_Date__c,
					Amend_Price__c = item.Amend_Price__c,
					Back_Sheet__c = item.Back_Sheet__c,
					Battery_Line__c = item.Battery_Line__c,
					Bus_bars_of_cell__c = item.Bus_bars_of_cell__c,
					Cable_Length__c = item.Cable_Length__c,
					Cable_length_UK__c = item.Cable_length_UK__c,
					Cell_Appearance__c = item.Cell_Appearance__c,
					Checked__c = item.Checked__c,
					Cheetah__c = item.Cheetah__c,
					Comments__c = item.Comment__c,
					Connector__c = item.Connector__c,
					ConnectorLine__c = item.ConnectorLine__c,
					Dimensions__c = item.Dimensions__c,
					Discount__c = item.Discount,
					Estimated_Time_of_Departure__c = item.Estimated_Time_of_Departure__c,
					Estimated_Time_of_Departure_ETD__c = item.Estimated_Time_of_Departure_ETD__c,
					EVA__c = item.EVA__c,
					Expected_Delivery_Date__c = item.Expected_Delivery_Date__c,
					Expected_Delivery_Date_ETA__c = item.Expected_Delivery_Date_ETA__c,
					FOB_Sales_Price__c = item.FOB_Sales_Price__c,
					Frame_B_side_Height__c = item.Frame_B_side_Height__c,
					Frame_Color__c = item.Frame_Color__c,
					Frame_Material__c = item.Frame__c,
					Goods_Description__c = item.Goods_Description__c,
					Grade__c = item.Grade__c,
					Guaranteed_Delivery_Date__c = item.Guaranteed_Delivery_Date__c,
					Guaranteed_Delivery_Date_japan__c = item.Guaranteed_Delivery_Date_japan__c,
					isJinkoStandard__c = item.isJinkoStandard__c,
					Japan_Rate_Tax__c = item.Japan_Rate_Tax__c,
					Junction_Box__c = item.Junction_Box__c,
					Label__c = item.Label__c,
					Length_of_Junction_Box_wiring__c = item.Wire_Length__c,
					M_P__c = item.MP__c,
					Module_size__c = item.Module_size__c,
					Number_of_Cells__c = item.Number_of_Cells__c,
					Others__c = item.Others__c,
					Package__c = item.Package__c,
					PAPI_Bal__c = item.PAPI_Bal__c,
					Quantity__c = item.Quantity,
					Ribbon__c = item.Ribbon__c,
					Sales_Price_Another__c = item.Sales_Price_Another__c,
					sameproduct__c = item.sameproduct__c,
					Serial_No__c = item.Serial_No__c,
					Solar_Cell__c = item.Solar_Cell__c,
					Special_Label__c = item.Special_Lable__c,
					Special_required__c = item.Special_required__c,
					Stock_age__c = item.Stock_age__c,
					Stock_Collected__c = item.Stock_Collected__c,
					Inventorytype__c = item.Inventorytype__c,
					Subtotal_Pmax__c = item.Subtotal_Pmax__c,
					Support_mixed_delivery__c = item.Support_mixed_delivery__c,
					Tempered_glass__c = item.Temperd_Glass__c,
					tolerance__c = item.tolerance__c,
					Total_Power_W__c = item.Total_Power_W__c,
					Total_Price_Tax_Japan__c = item.Total_Price_Tax_Japan__c,
					Junction_Box_Brand__c = item.Junction_Box_Brand__c,
					Type_of_module__c = item.Type_of_module__c,
					Junction_Box_Type__c = item.Junction_Box_Type__c,
					Weight__c = item.Weight__c,
					Guaranteed_Delivery_Date_Note__c = item.Guaranteed_Delivery_Date_Note__c,
					Guaranteed_Delivery_Quarter__c = item.Guaranteed_Delivery_Quarter__c,
                	MW__c = item.MW__c,
                	Product_Type__c = item.Product_Type__c
			);
            if(item.UnitPrice==null){
                FAProduct.Sales_Price__c=0;
            }
			FAProductList.add(FAProduct);
		}

        //Insert SFA;
        Insert FAPaymentList;
        //此处没变
		Insert FAProductList;
		return SFA;
	}

	public void addOpportunityLineItem() {
		opportunityLineItemList.add(new OpportunityLineItem(OpportunityId = opportunityId));
	}

	public void addOpportunityPayment() {
		paymentList.add(new Payment__c(Opportunity__c = opportunityId));
	}

	public void delItem() {
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***delCount:' + delCount);
		if (delCount != null && delCount != 0) {
			opportunityLineItemList.remove(delCount - 1);
			delCount = null;
		}
	}

	public void delPayment() {
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***delCount:' + delCount);
		if (delCount != null && delCount != 0) {
			paymentList.remove(delCount - 1);
			delCount = null;
		}
	}

	public void saveItem() {
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***delCount:' + delCount);
		Set<Id> proIdSet = new Set<Id>();
		for (OpportunityLineItem item : opportunityLineItemList) {
			proIdSet.add(item.Product2Id);
		}
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***proIdSet:' + proIdSet);
		Map<Id, Product2> product2Map;
		if (proIdSet.size() != 0) {
			product2Map = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :proIdSet]);
			System.debug(LoggingLevel.DEBUG, '[MOUOpportunityApproveAgainController]***product2Map:' + product2Map);
		}

		if (delCount != null && delCount != 0) {
			OpportunityLineItem lineItem = opportunityLineItemList[delCount - 1];
            if(opportunityLineItemList[delCount - 1].UnitPrice==null){
                opportunityLineItemList[delCount - 1].UnitPrice=0;
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
	}

	public void editItem() {
		if (delCount != null && delCount != 0) {
			opportunityLineItemList[delCount - 1].Save_Judgment__c = false;
			delCount = null;
		}
	}

	public void savePayment() {
		if (delCount != null && delCount != 0) {
            Decimal i=0;
            for(Payment__c p : paymentList){
                i = i + p.Percentage__c;
            }
            if(i<=100){
              paymentList[delCount - 1].Save_Judgment__c = true;
			  delCount = null; 
            }else{
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Percentage cannot be greater than 100 !'));
            }
			
		}
	}

	public void editPayment() {
		if (delCount != null && delCount != 0) {
			paymentList[delCount - 1].Save_Judgment__c = false;
			delCount = null;
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
			//if (!dfr.isUnique() && (dfr.isCreateable() || dfr.isUpdateable())) {
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
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From Payment__c ' ; // + ' Where ID IN :rIds';
		query += ' Where Opportunity__c = :OpportunityId';

		return database.query(query);
	}
}