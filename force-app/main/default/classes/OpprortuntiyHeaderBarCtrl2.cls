public class OpprortuntiyHeaderBarCtrl2 {
	public Opportunity opp{
		get;set;
	}
	public boolean flag{
		get;set;
	}
	public String text{
		get;set;
	}
	public boolean judgment{
		get;set;
	}

	public OpprortuntiyHeaderBarCtrl2(apexpages.StandardController std) {
		opp = [select id,
		MOU_Type_Judgment__c,
		RecordType.Name,
		Account.credit_good__c,
		Trade_Term__c,
		Total_Price__c,
               Sales_type__c,
		Destination_Country__c,
		Green_Channel_Approval__c,
		Payment_Term_Description__c,
		Local_Warehouse__c,
		Region__c,
		ownerid,
		Total_MW__c,
		vn_fast__c,
		Warranty_Insurance__c,
		Total_Power__c,
		BMO_specialist__r.name,
		Total_Quantity__c,
		Total_Opp_MW__c,
		Total_Opp_Power__c,
		Total_Opp_Price__c,
		Total_Opp_Quantity__c,
		faOpportunity__c,
		Roll_up__c,
		Opportunity_Type__c,
		Inventory_Approval_Status__c,
		Payment_1MW_Approve__c,
		finance_approval_not_required__c
		from Opportunity
		where id =: std.getId()];
		flag = opp.Payment_1MW_Approve__c;
		judgment = opp.MOU_Type_Judgment__c;
		if (opp.Total_MW__c < 2 && (opp.Region__c == 'Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Account.credit_good__c == true) {
			flag = true;
		}
		list<Payment__c> relatePayments = [Select Down_Balance_Payment__c,
		Payment_Term__c,
		Payment_Method__c,
		Name, Id,
		Days__c,
		CurrencyIsoCode,
		Precise_Day__c,
		Opp_Trade_Term__c,
		Opportunity__c,
		Percentage__c,
		Amount__c
		From Payment__c
		Where Opportunity__c =: opp.id];
		text = '';

		if (opp.Total_MW__c >= 1 && opp.Region__c != 'Middle East&Africa'&&opp.Region__c != 'MENA'&&opp.Region__c != 'SSA' && opp.Region__c != 'ROA') {
			text = text + '总瓦数大于1MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 1 \n';

		}
		if (opp.Total_MW__c >= 3 && opp.Region__c.contains('EU')) {
			text = text + '总瓦数大于3MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 3 \n';

		}
		if (opp.Total_MW__c >= 5 && (opp.Region__c == 'Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA')) {
			text = text + '总瓦数大于5MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 5 \n';

		}
		if (opp.Total_MW__c >= 5 && opp.Region__c == 'ROA') {
			text = text + '总瓦数大于5MW 不执行快速流程 \n Reason of why not fast PAPI procedure: Total MW > 5 \n';

		}
		if (opp.Trade_Term__c == 'FCA') {
			text = text + 'FCA不执行快速流程 \n Reason of why not fast PAPI procedure: Trade Term = FCA \n';

		}
		if (relatePayments.size() > 0) {
			for (Payment__c p : relatePayments) {
				if (opp.Region__c != null) {
					if (!opp.Region__c.contains('EU')) {
						if (p.Payment_Term__c == 'x% OA by LC X days') {
							if (p.Days__c > 90) {
								text = text + 'Payment Term 选择 x% OA by LC X days时 天数小于等于90天,才是快速流程\n';
								text = text + 'Reason of why not fast PAPI procedure: Because fast PAPI required LC days must be less or euqal than 90 days\n';
							}
						}
						if (p.Down_Balance_Payment__c == 'Balance Payment') {
							if (p.Payment_Method__c == 'T/T' || p.Payment_Method__c == 'T/T (Balance)') {
								text = text + 'Balance Payment 选择L/C ,才是快速流程\n';
								text = text + 'Reason of why not fast PAPI procedure: Balance Payment && T/T(Balance) \n';
							}
						}

						if (p.Payment_Term__c == 'x% DP X days before the BL/Delivery Date') {
							if (p.Days__c < 15) {
								text = text + 'Payment Term 选择 x% DP X days before the BL/Delivery Date时 天数大于等于20天,才是快速流程\n';
								text = text + 'Reason of why not fast PAPI procedure: Because fast PAPI required BL/Delivery Date days must be greater or euqal than 15 days \n';
							}
						}
						if (p.Payment_Term__c == 'x% DP X days after the Execution Date') {
							if (p.Days__c > 5) {
								text = text + 'Payment Term 选择 x% DP X days after the Execution Date时 天数小于等于5天,才是快速流程\n';
								text = text + 'Reason of why not fast PAPI procedure: Because fast PAPI required after execution date must be less or euqal than 5 days \n';

							}
						}
					}
				}
				if (opp.Region__c != null) {
					if (opp.Region__c.contains('EU')) {
						if (p.Down_Balance_Payment__c == 'Balance Payment') {
							if (p.Payment_Method__c == 'T/T' || p.Payment_Method__c == 'T/T (Balance)') {
								text = text + 'Balance Payment 选择L/C ,才是快速流程\n';
								text = text + 'Reason of why not fast PAPI procedure: Balance Payment && T/T(Balance) \n';
							}
						}
					}
				}
			}
		}
	}
}