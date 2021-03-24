global class MOUOpportunityButton {

	webservice static String lockingJudgment(String requestId) {
		Opportunity MOUOpp = [SELECT MOU_Approval__c FROM Opportunity WHERE Id=:requestId];
		String str = null;
		if (MOUOpp.MOU_Approval__c) {
			str = '0';
		}
		return str;
	}

	webservice static String cloneJudgment(String requestId) {
		Opportunity MOUOpp = [SELECT MOU_Approval__c, Roll_up_SFA_Counts__c FROM Opportunity WHERE Id=:requestId];
		String str = null;
		if (MOUOpp.MOU_Approval__c ) {
			str = '0';
		}
		return str;
	}

	webservice static String approveJudgment(String requestId) {
		Supplementary_Framework_Agreement__c SFA = [SELECT SOC_Dept__c, Finance_Price_Approval_Status__c, Legal_Dept__c, Approval_Lock__c FROM Supplementary_Framework_Agreement__c WHERE Id=:requestId];
		String state = null;
		if (SFA.Approval_Lock__c) {
			state = '0';
		}
		return state;
	}

}