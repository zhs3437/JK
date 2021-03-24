public class MOUFrameworkAgreementFirstCreate {

	@Future
	public static void saveFrameworkAgreement(Id opportunityId) {
		//MOU所有字段
		Opportunity MOUOpportunity = (Opportunity)queryForRecords(Opportunity.getSObjectType(), opportunityId);

		//opportunityLineItem所有字段
		List<OpportunityLineItem> opportunityLineItemList = (List<OpportunityLineItem>)queryChildrenRecords(OpportunityLineItem.getSObjectType(), opportunityId);

		//payment所有字段
		List<Payment__c> paymentList = (List<Payment__c>)queryChildrenRecords2(Payment__c.getSObjectType(), opportunityId);

		//解锁MOUOpp
		Opportunity MOUUnlockOpp = [SELECT Id, Lock__c FROM Opportunity WHERE Id = :opportunityId];
		MOUUnlockOpp.Lock__c = false;

		Update MOUUnlockOpp;

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
				Probability__c = MOUOpportunity.Probability,
				SOC_Dept__c = MOUOpportunity.SOC_Dept__c,
				Finance_Price_Approval_Status__c = MOUOpportunity.Finance_Approval_Status__c,
				Legal_Dept__c = MOUOpportunity.Legal_Dept__c,
				SOC_Dept_Comments__c = MOUOpportunity.SOC_Dept_Comments__c,
				Price_Approval_Feedback_Comments__c = MOUOpportunity.Finance_Dept_Comments__c,
				Legal_Dept_Comments__c = MOUOpportunity.Legal_Dept_Comments__c,
				GM_approval_Status__c = MOUOpportunity.GM_approval_Status__c,
				GM_approval_Comments__c = MOUOpportunity.GM_approval_Comments__c,
				Technical_Dept_Status__c = MOUOpportunity.Technical_Dept_Status__c,
				Technical_Dept_Comments__c = MOUOpportunity.Technical_Dept_Comments__c,
				Sync_MOU_Opportunity__c = true
		);
		Insert SFA;

		//新建Framework Agreement Payment对象
		List<Framework_Agreement_Payment__c> FAPaymentList = new List<Framework_Agreement_Payment__c>();
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
			FAPaymentList.add(FAPayment);
		}

		Insert FAPaymentList;

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
					Guaranteed_Delivery_Quarter__c = item.Guaranteed_Delivery_Quarter__c
			);
			FAProductList.add(FAProduct);
		}

		Insert FAProductList;

		//MOUOpp上锁
		MOUUnlockOpp.Lock__c = true;
		Update MOUUnlockOpp;
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
            System.debug('dfr.getName()------>'+dfr.getName());
			//ignore Unique fields. They will have to be filled in manually 
			//if (!dfr.isUnique() && (dfr.isCreateable() || dfr.isUpdateable())) {
				results.add(dfr.getName());
			//}
		}
		return results;
	}

	private static List<sObject> queryChildrenRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From OpportunityLineItem ' ; // + ' Where ID IN :rIds';
		query += ' Where OpportunityId = :OpportunityId';
		System.debug('query------>'+query);
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