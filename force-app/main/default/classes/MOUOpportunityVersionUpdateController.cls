global class MOUOpportunityVersionUpdateController {
	
	webservice static void turnaroundMOUFiled(String requestId) {
		Supplementary_Framework_Agreement__c SFAOpp = (Supplementary_Framework_Agreement__c)querySFARecords(
				Supplementary_Framework_Agreement__c.getSObjectType(), requestId);
		//解锁MOUOpp
		Opportunity MOUUnlockOpp = [SELECT Id, Lock__c FROM Opportunity WHERE Id = :SFAOpp.Opportunity__c];
		MOUUnlockOpp.Lock__c = false;
		Update MOUUnlockOpp;

		//		//解锁SFA
				SFAOpp.Lock__c = false;
				update SFAOpp;

		Opportunity MOUOpp = (Opportunity)queryMOUOppRecords(Opportunity.getSObjectType(), SFAOpp.Opportunity__c);

		//跟新MOUOpp
		if (SFAOpp.Opportunity__c == MOUOpp.Id) {
			MOUOpp.AccountId = SFAOpp.Account__c;
			MOUOpp.Actual_Sales_Name__c = SFAOpp.Actual_Sales_Name__c;
			MOUOpp.Seller__c = SFAOpp.Seller__c;
			MOUOpp.StageName = SFAOpp.StageName__c;
			MOUOpp.Sales_type__c = SFAOpp.Sales_type__c;
			MOUOpp.GST_Classification_Region__c = SFAOpp.GST_Classification_Region__c;
			MOUOpp.Type_of_Shipping__c = SFAOpp.Type_of_Shipping__c;
			MOUOpp.Type_of_Inventory_or_Production__c = SFAOpp.Type_of_Inventory_or_Production__c;
			MOUOpp.Customer_Delivery_Date__c = SFAOpp.Customer_Delivery_Date__c;
			MOUOpp.Confirmed_ETD__c = SFAOpp.Confirmed_ETD__c;
			MOUOpp.China_Land_Freight__c = SFAOpp.China_Land_Freight__c;
			MOUOpp.Oversea_Freight__c = SFAOpp.Oversea_Freight__c;
			MOUOpp.Destination_Country__c = SFAOpp.Destination_Country__c;
			MOUOpp.Region__c = SFAOpp.Region__c;
			MOUOpp.CloseDate = SFAOpp.Close_Date__c;
			MOUOpp.Seller_Text__c = SFAOpp.Seller_Text__c;
			MOUOpp.Sales_type_Text__c = SFAOpp.Sales_type_Text__c;
			MOUOpp.GST_Classification_Region_Text__c = SFAOpp.GST_Classification_Region_Text__c;
			MOUOpp.Type_of_Shipping_Text__c = SFAOpp.Type_of_Shipping_Text__c;
			MOUOpp.Warehouse_Stock_or_Production_Text__c = SFAOpp.Warehouse_Stock_or_Production_Text__c;
			MOUOpp.Expected_Delivery_Date_Text__c = SFAOpp.Expected_Delivery_Date_Text__c;
			MOUOpp.Estimated_Time_of_Departure_Text__c = SFAOpp.Estimated_Time_of_Departure_Text__c;
			MOUOpp.Freight_Ocean__c = SFAOpp.Freight_Ocean__c;
			MOUOpp.Reason_of_apply_for_insurance__c = SFAOpp.Reason_of_apply_for_insurance__c;
			MOUOpp.Destination_Port__c = SFAOpp.Destination_Port__c;
			MOUOpp.Total_Price_Frameeork_Text__c = SFAOpp.Total_Price_Frameeork_Text__c;
            MOUOpp.Total_MW_Framework_Text__c = SFAOpp.Total_MW_Framework_Text__c;
			//MOUOpp.SOC_Dept__c = SFAOpp.SOC_Dept__c;
			//MOUOpp.Finance_Approval_Status__c = SFAOpp.Finance_Price_Approval_Status__c;
			//MOUOpp.Legal_Dept__c = SFAOpp.Legal_Dept__c;
			//MOUOpp.SOC_Dept_Comments__c = SFAOpp.SOC_Dept_Comments__c;
			//MOUOpp.Finance_Dept_Comments__c = SFAOpp.Price_Approval_Feedback_Comments__c;
			//MOUOpp.Legal_Dept_Comments__c = SFAOpp.Legal_Dept_Comments__c;
			//MOUOpp.GM_approval_Status__c = SFAOpp.GM_approval_Status__c;
			//MOUOpp.GM_approval_Comments__c = SFAOpp.GM_approval_Comments__c;
			//MOUOpp.Technical_Dept_Status__c = SFAOpp.Technical_Dept_Status__c;
			//MOUOpp.Technical_Dept_Comments__c = SFAOpp.Technical_Dept_Comments__c;

		}

		update MOUOpp;
		updatePayment(SFAOpp.Id, MOUOpp.Id);
		updateOpportunityLineItem(SFAOpp.Id, MOUOpp.Id);
		

		//		//更新版本会刷字段
				SFAOpp.Sync_MOU_Opportunity__c = true;
				SFAOpp.Lock__c = true;
				update SFAOpp;
        
        
	}
	
	public static void updateOpportunityLineItem(Id SFAId, Id MOUId) {
		//MOUOpp中行项目
		List<OpportunityLineItem> oppItemList = queryOppItemRecords(OpportunityLineItem.getSObjectType(), MOUId);
		//补充框架中Framework Agreement Product对象
		List<Framework_Agreement_Product__c> FAProductList =
				queryFAProductRecords(Framework_Agreement_Product__c.getSObjectType(), SFAId);

		List<OpportunityLineItem> updateOppLineItem = new List<OpportunityLineItem>();
		List<OpportunityLineItem> insertOppLineItem = new List<OpportunityLineItem>();
		List<OpportunityLineItem> deleteOppLineItem = new List<OpportunityLineItem>();

		//如果补充框架中不存在行项目则删除MOU框架中的行项目。
		if (FAProductList.size() == 0) {
			delete oppItemList;
			return ;
		}

		Set<Id> proId = new Set<Id>();
		for (framework_agreement_product__c FAP : FAProductList) {
			proId.add(FAP.Product2__c);
		}

		List<PricebookEntry> priceBookEntryList = [
				SELECT Id, Product2id, CurrencyIsoCode, Pricebook2Id
				FROM PricebookEntry
				WHERE Product2id IN:proId
		];

		//map<ProductId,List<PricebookEntry>>
		//		Map<Id, List<PricebookEntry>> productPriceBookMap = new Map<Id, List<PricebookEntry>>();
		//		for (framework_agreement_product__c FAP : FAProductList) {
		//			for (PricebookEntry priceBook : priceBookEntryList) {
		//				if (productPriceBookMap.get(FAP.Product2__c) == null) {
		//					productPriceBookMap.put(FAP.Product2__c, new List<PricebookEntry>());
		//				} else if (priceBook.Product2Id == FAP.Product2__c) {
		//					productPriceBookMap.get(FAP.Product2__c).add(priceBook);
		//				}
		//			}
		//		}
		//		System.debug(LoggingLevel.DEBUG,
		//						'[MOUOpportunityVersionUpdateController]***productPriceBookMap:' + productPriceBookMap);

		//Map<OpportunityLineItemId,Framework_Agreement_Product__c>
		Map<Id, Framework_Agreement_Product__c> productFAPMap = new Map<Id, framework_agreement_product__c>();
		for (Framework_Agreement_Product__c FAPro : FAProductList) {
			if (FAPro.MOU_Opportunity_Product_Id__c != null) {
				if (productFAPMap.get(FAPro.MOU_Opportunity_Product_Id__c) == null) {
					productFAPMap.put(FAPro.MOU_Opportunity_Product_Id__c, FAPro);
				}
			} else {
				//MOU_Opportunity_Product_Id__c创建时没有赋值，为新添加的Product
				OpportunityLineItem item = new OpportunityLineItem(
						OpportunityId = MOUId,
						Product2Id = FAPro.Product2__c,
						Quantity = FAPro.Quantity__c,
						Trade_Term__c = FAPro.Trade_Term__c,
						//TotalPrice = FAPro.TotalPrice__c,
						MixedDelivery__c = FAPro.MixedDelivery__c,
						Amend_Date__c = FAPro.Amend_Date__c,
						Amend_Price__c = FAPro.Amend_Price__c,
						Back_Sheet__c = FAPro.Back_Sheet__c,
						Battery_Line__c = FAPro.Battery_Line__c,
						Bus_bars_of_cell__c = FAPro.Bus_bars_of_cell__c,
						Cable_Length__c = FAPro.Cable_Length__c,
						Cable_length_UK__c = FAPro.Cable_length_UK__c,
						Cell_Appearance__c = FAPro.Cell_Appearance__c,
						Checked__c = FAPro.Checked__c,
						Cheetah__c = FAPro.Cheetah__c,
						Comment__c = FAPro.Comments__c,
						Connector__c = FAPro.Connector__c,
						ConnectorLine__c = FAPro.ConnectorLine__c,
						Dimensions__c = FAPro.Dimensions__c,
						Discount = FAPro.Discount__c,
						Estimated_Time_of_Departure__c = FAPro.Estimated_Time_of_Departure__c,
						Estimated_Time_of_Departure_ETD__c = FAPro.Estimated_Time_of_Departure_ETD__c,
						EVA__c = FAPro.EVA__c,
						Expected_Delivery_Date__c = FAPro.Expected_Delivery_Date__c,
						Expected_Delivery_Date_ETA__c = FAPro.Expected_Delivery_Date_ETA__c,
						FOB_Sales_Price__c = FAPro.FOB_Sales_Price__c,
						Frame_B_side_Height__c = FAPro.Frame_B_side_Height__c,
						Frame_Color__c = FAPro.Frame_Color__c,
						Frame__c = FAPro.Frame_Material__c,
						Goods_Description__c = FAPro.Goods_Description__c,
						Grade__c = FAPro.Grade__c,
						Guaranteed_Delivery_Date__c = FAPro.Guaranteed_Delivery_Date__c,
						Guaranteed_Delivery_Date_japan__c = FAPro.Guaranteed_Delivery_Date_japan__c,
						isJinkoStandard__c = FAPro.isJinkoStandard__c,
						Japan_Rate_Tax__c = FAPro.Japan_Rate_Tax__c,
						Junction_Box__c = FAPro.Junction_Box__c,
						Label__c = FAPro.Label__c,
						Wire_Length__c = FAPro.Length_of_Junction_Box_wiring__c,
						MP__c = FAPro.M_P__c,
						Module_size__c = FAPro.Module_size__c,
						Number_of_Cells__c = FAPro.Number_of_Cells__c,
						Others__c = FAPro.Others__c,
						Package__c = FAPro.Package__c,
						PAPI_Bal__c = FAPro.PAPI_Bal__c,
						Ribbon__c = FAPro.Ribbon__c,
						Sales_Price_Another__c = FAPro.Sales_Price_Another__c,
						sameproduct__c = FAPro.sameproduct__c,
						Serial_No__c = FAPro.Serial_No__c,
						Solar_Cell__c = FAPro.Solar_Cell__c,
						Special_Lable__c = FAPro.Special_Label__c,
						Special_required__c = FAPro.Special_required__c,
						Stock_age__c = FAPro.Stock_age__c,
						Stock_Collected__c = FAPro.Stock_Collected__c,
						Inventorytype__c = FAPro.Inventorytype__c,
						Subtotal_Pmax__c = FAPro.Subtotal_Pmax__c,
						Support_mixed_delivery__c = FAPro.Support_mixed_delivery__c,
						Temperd_Glass__c = FAPro.Tempered_glass__c,
						tolerance__c = FAPro.tolerance__c,
						Total_Power_W__c = FAPro.Total_Power_W__c,
						Total_Price_Tax_Japan__c = FAPro.Total_Price_Tax_Japan__c,
						Junction_Box_Brand__c = FAPro.Junction_Box_Brand__c,
						Type_of_module__c = FAPro.Type_of_module__c,
						Junction_Box_Type__c = FAPro.Junction_Box_Type__c,
						Weight__c = FAPro.Weight__c,
						Guaranteed_Delivery_Date_Note__c = FAPro.Guaranteed_Delivery_Date_Note__c,
                    	MW__c = FAPro.MW__c,
                    	Product_Type__c = FAPro.Product_Type__c,
                    	UnitPrice = FAPro.Sales_Price__c,
                    	Sales_Price_MOU__c = FAPro.Sales_Price__c
                    	
				);
				//				for(PricebookEntry pe : productPriceBookMap.get(FAPro.Product2__c)){
				//					item.PricebookEntryId = pe.Id;
				//				}
				insertOppLineItem.add(item);
				//				System.debug(LoggingLevel.DEBUG,'[MOUOpportunityVersionUpdateController]***insertOppLineItem:' + insertOppLineItem);
			}
		}
		Insert insertOppLineItem;

		for (OpportunityLineItem item : oppItemList) {
			if (productFAPMap.get(item.Id) != null) {
				Framework_Agreement_Product__c FAP = productFAPMap.get(item.Id);
				//更新行项目
				if (item.Product2Id == FAP.Product2__c) {
					item.Quantity = FAP.Quantity__c;
					//item.TotalPrice = FAP.TotalPrice__c;
					item.MixedDelivery__c = FAP.MixedDelivery__c;
					item.Trade_Term__c = FAP.Trade_Term__c;
					item.Amend_Date__c = FAP.Amend_Date__c;
					item.Amend_Price__c = FAP.Amend_Price__c;
					item.Back_Sheet__c = FAP.Back_Sheet__c;
					item.Battery_Line__c = FAP.Battery_Line__c;
					item.Bus_bars_of_cell__c = FAP.Bus_bars_of_cell__c;
					item.Cable_Length__c = FAP.Cable_Length__c;
					item.Cable_length_UK__c = FAP.Cable_length_UK__c;
					item.Cell_Appearance__c = FAP.Cell_Appearance__c;
					item.Checked__c = FAP.Checked__c;
					item.Cheetah__c = FAP.Cheetah__c;
					item.Comment__c = FAP.Comments__c;
					item.Connector__c = FAP.Connector__c;
					item.ConnectorLine__c = FAP.ConnectorLine__c;
					item.Dimensions__c = FAP.Dimensions__c;
					item.Discount = FAP.Discount__c;
					item.Estimated_Time_of_Departure__c = FAP.Estimated_Time_of_Departure__c;
					item.Estimated_Time_of_Departure_ETD__c = FAP.Estimated_Time_of_Departure_ETD__c;
					item.EVA__c = FAP.EVA__c;
					item.Expected_Delivery_Date__c = FAP.Expected_Delivery_Date__c;
					item.Expected_Delivery_Date_ETA__c = FAP.Expected_Delivery_Date_ETA__c;
					item.FOB_Sales_Price__c = FAP.FOB_Sales_Price__c;
					item.Frame_B_side_Height__c = FAP.Frame_B_side_Height__c;
					item.Frame_Color__c = FAP.Frame_Color__c;
					item.Frame__c = FAP.Frame_Material__c;
					item.Goods_Description__c = FAP.Goods_Description__c;
					item.Grade__c = FAP.Grade__c;
					item.Guaranteed_Delivery_Date__c = FAP.Guaranteed_Delivery_Date__c;
					item.Guaranteed_Delivery_Date_japan__c = FAP.Guaranteed_Delivery_Date_japan__c;
					item.isJinkoStandard__c = FAP.isJinkoStandard__c;
					item.Japan_Rate_Tax__c = FAP.Japan_Rate_Tax__c;
					item.Junction_Box__c = FAP.Junction_Box__c;
					item.Label__c = FAP.Label__c;
					item.Wire_Length__c = FAP.Length_of_Junction_Box_wiring__c;
					item.MP__c = FAP.M_P__c;
					item.Module_size__c = FAP.Module_size__c;
					item.Number_of_Cells__c = FAP.Number_of_Cells__c;
					item.Others__c = FAP.Others__c;
					item.Package__c = FAP.Package__c;
					item.PAPI_Bal__c = FAP.PAPI_Bal__c;
					item.Quantity = FAP.Quantity__c;
					item.Ribbon__c = FAP.Ribbon__c;
					item.Sales_Price_Another__c = FAP.Sales_Price_Another__c;
					item.sameproduct__c = FAP.sameproduct__c;
					item.Serial_No__c = FAP.Serial_No__c;
					item.Solar_Cell__c = FAP.Solar_Cell__c;
					item.Special_Lable__c = FAP.Special_Label__c;
					item.Special_required__c = FAP.Special_required__c;
					item.Stock_age__c = FAP.Stock_age__c;
					item.Stock_Collected__c = FAP.Stock_Collected__c;
					item.Inventorytype__c = FAP.Inventorytype__c;
					item.Subtotal_Pmax__c = FAP.Subtotal_Pmax__c;
					item.Support_mixed_delivery__c = FAP.Support_mixed_delivery__c;
					item.Temperd_Glass__c = FAP.Tempered_glass__c;
					item.tolerance__c = FAP.tolerance__c;
					item.Total_Power_W__c = FAP.Total_Power_W__c;
					item.Total_Price_Tax_Japan__c = FAP.Total_Price_Tax_Japan__c;
					item.Junction_Box_Brand__c = FAP.Junction_Box_Brand__c;
					item.Type_of_module__c = FAP.Type_of_module__c;
					item.Junction_Box_Type__c = FAP.Junction_Box_Type__c;
					item.Weight__c = FAP.Weight__c;
					item.Guaranteed_Delivery_Date_Note__c = FAP.Guaranteed_Delivery_Date_Note__c;
                    item.MW__c = FAP.MW__c;
                    item.Product_Type__c = FAP.Product_Type__c;
                    item.UnitPrice = FAP.Sales_Price__c;
                    item.Sales_Price_MOU__c = FAP.Sales_Price__c;
					updateOppLineItem.add(item);
					System.debug(LoggingLevel.DEBUG, '[MOUOpportunityVersionUpdateController]***updateOppLineItem:' + updateOppLineItem);
				}
			} else {
				//行项目在补充框架中不存在
				deleteOppLineItem.add(item);
				System.debug(LoggingLevel.DEBUG, '[MOUOpportunityVersionUpdateController]***deleteOppLineItem:' + deleteOppLineItem);
			}
		}
		Update updateOppLineItem;
		Delete deleteOppLineItem;
        
        Supplementary_Framework_Agreement__c SFA = [
				SELECT Id
				FROM Supplementary_Framework_Agreement__c
				WHERE Id = :SFAId
		];
        //更新版本刷新字段
		//SFA.Lock__c = false;
		//SFA.Sync_MOU_Opportunity__c = true;
		//Update SFA;


		//SFA.Lock__c = true;
		//update SFA;

		//解锁MOUOpp
		//Opportunity MOUOpportunity = [SELECT Id, Lock__c FROM Opportunity WHERE Id = :MOUId];
		//MOUOpportunity.Lock__c = true;
		//Update MOUOpportunity;
        
        
        
        
        
        
	}

	@Future
	public static void updatePayment(Id SFAId, Id MOUId) {
		//MOU框架中Payment
		List<Payment__c> MOUOppPaymentList = queryPaymentRecords(Payment__c.getSObjectType(), MOUId);
		//补充框架中的Payment
		List<Framework_Agreement_Payment__c> FAPaymentList =
				queryFAPaymentRecords(Framework_Agreement_Payment__c.getSObjectType(), SFAId);
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityVersionUpdateController]***MOUOppPaymentList:' +
				JSON.serialize(MOUOppPaymentList));


		List<Payment__c> updateFAPaymentList = new List<Payment__c>();
		List<Payment__c> insertFAPaymentList = new List<Payment__c>();
		List<Payment__c> deleteFAPaymentList = new List<Payment__c>();

		Map<Id, Payment__c> MOUOppPaymentMap = new Map<Id, Payment__c>();
		for (Payment__c payment : MOUOppPaymentList) {
			if (MOUOppPaymentMap.get(payment.Id) == null) {
				MOUOppPaymentMap.put(payment.Id, payment);
			}
		}

		for (Framework_Agreement_Payment__c FAPayment : FAPaymentList) {
			if (FAPayment.MOU_Opportunity_Payment_Id__c == null) {
				Payment__c payment = new Payment__c(
						Opportunity__c = MOUId,
						Comments__c = FAPayment.Comments__c,
						Credit_Valid__c = FAPayment.Credit_Valid__c,
						Days__c = FAPayment.Days__c,
						Down_Balance_Payment__c = FAPayment.Down_Balance_Payment__c,
						Payment_Method__c = FAPayment.Payment_Method__c,
						Payment_Term__c = FAPayment.Payment_Term__c,
						PaymentDescription__c = FAPayment.PaymentDescription__c,
						Percentage__c = FAPayment.Percentage__c,
						Precise_Day__c = FAPayment.Precise_Day__c
				);
				insertFAPaymentList.add(payment);
			} else {
				Payment__c payment = MOUOppPaymentMap.get(FAPayment.MOU_Opportunity_Payment_Id__c);
				payment.Comments__c = FAPayment.Comments__c;
				payment.Credit_Valid__c = FAPayment.Credit_Valid__c;
				payment.Days__c = FAPayment.Days__c;
				payment.Down_Balance_Payment__c = FAPayment.Down_Balance_Payment__c;
				payment.Payment_Method__c = FAPayment.Payment_Method__c;
				payment.Payment_Term__c = FAPayment.Payment_Term__c;
				payment.PaymentDescription__c = FAPayment.PaymentDescription__c;
				payment.Percentage__c = FAPayment.Percentage__c;
				payment.Precise_Day__c = FAPayment.Precise_Day__c;
				updateFAPaymentList.add(payment);
			}
		}
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityVersionUpdateController]***insertFAPaymentList:' +
				JSON.serialize(insertFAPaymentList));
		Insert insertFAPaymentList;

		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityVersionUpdateController]***updateFAPaymentList:' +
				JSON.serialize(updateFAPaymentList));
		Update updateFAPaymentList;

		Set<Id> paymentIdSet = MOUOppPaymentMap.keySet();
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityVersionUpdateController]***paymentIdSet:' + paymentIdSet);

		Set<Id> FAPaymentIdSet = new Set<Id>();
		for (framework_agreement_payment__c payment : FAPaymentList) {
			if (payment.MOU_Opportunity_Payment_Id__c != null) {
				FAPaymentIdSet.add(payment.MOU_Opportunity_Payment_Id__c);
			}
		}

		for (Id next : paymentIdSet) {
			if (!FAPaymentIdSet.contains(next)) {
				deleteFAPaymentList.add(MOUOppPaymentMap.get(next));
			}
		}

		Delete deleteFAPaymentList;

		/*Supplementary_Framework_Agreement__c SFA = [
				SELECT Id
				FROM Supplementary_Framework_Agreement__c
				WHERE Id = :SFAId
		];*/

		//更新版本刷新字段
		//SFA.Lock__c = false;
		//SFA.Sync_MOU_Opportunity__c = true;
		//Update SFA;


		//SFA.Lock__c = true;
		//update SFA;

		//解锁MOUOpp
		Opportunity MOUOpportunity = [SELECT Id, Lock__c FROM Opportunity WHERE Id = :MOUId];
		MOUOpportunity.Lock__c = true;
		Update MOUOpportunity;
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

	private static sObject queryMOUOppRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From Opportunity' ; // + ' Where ID IN :rIds';
		query += ' Where ID = :OpportunityId';
		return database.query(query);
	}

	private static List<sObject> queryOppItemRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select  ';
		query += string.join(fldsToClone, ',');
		query += ' From OpportunityLineItem ' ;
		query += ' Where OpportunityId = :OpportunityId';

		return database.query(query);
	}

	private static List<sObject> queryPaymentRecords(Schema.sObjectType oType, ID OpportunityId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select  ';
		query += string.join(fldsToClone, ',');
		query += ' From Payment__c ' ;
		query += ' Where Opportunity__c = :OpportunityId';

		return database.query(query);
	}

	private static sObject querySFARecords(Schema.sObjectType oType, ID SFAId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From Supplementary_Framework_Agreement__c' ; // + ' Where ID IN :rIds';
		query += ' Where ID = :SFAId';
		return database.query(query);
	}

	private static List<sObject> queryFAPaymentRecords(Schema.sObjectType oType, ID SFAId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select ';
		query += string.join(fldsToClone, ',');
		query += ' From Framework_Agreement_Payment__c ' ;
		query += ' Where Supplementary_framework_agreement__c = :SFAId';

		return database.query(query);
	}

	private static List<sObject> queryFAProductRecords(Schema.sObjectType oType, ID SFAId) {
		String[] fldsToClone = getCreateableFields(oType);
		String query = 'Select  ';
		query += string.join(fldsToClone, ',');
		query += ' From Framework_Agreement_Product__c ' ;
		query += ' Where Supplementary_framework_agreement__c = :SFAId';

		return database.query(query);
	}

}