trigger FrameworkAgreementPaymentTrigger on Framework_Agreement_Payment__c(after insert, after update,before insert, before update,  after delete,before delete) {
	//重置MOUOpportunity审批
	Set<Id> MOUOppIdSet = new Set<Id>();
	Map<Id, Framework_Agreement_Payment__c> oldPaymentMap = Trigger.oldMap;
	Map<Id, Framework_Agreement_Payment__c> newPaymentMap = Trigger.newMap;
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			for(Framework_Agreement_Payment__c payment:Trigger.new){
				MOUOppIdSet.add(payment.Supplementary_framework_agreement__c);
			}
		}
		if(Trigger.isUpdate){
			for (Id newPaymentId : newPaymentMap.keySet()) {
				Framework_Agreement_Payment__c newPayment = newPaymentMap.get(newPaymentId);

				//if (oldLineItemMap != null) {
				Framework_Agreement_Payment__c oldPayment = oldPaymentMap.get(newPayment.Id);

				if (oldPayment != null) {
					if (newPayment.Percentage__c != oldPayment.Percentage__c ||
									newPayment.Amount__c != oldPayment.Amount__c ||
									newPayment.Down_Balance_Payment__c != oldPayment.Down_Balance_Payment__c ||
									newPayment.Payment_Method__c != oldPayment.Payment_Method__c ||
									newPayment.Days__c != oldPayment.Days__c ||
									newPayment.Payment_Term__c != oldPayment.Payment_Term__c ||
									newPayment.Credit_Valid__c != oldPayment.Credit_Valid__c ||
									newPayment.Precise_Day__c != oldPayment.Precise_Day__c ||
									newPayment.PaymentDescription__c != oldPayment.PaymentDescription__c) {
						MOUOppIdSet.add(newPayment.Supplementary_framework_agreement__c);
					}
				}
			}
		}
		if(Trigger.isDelete){
			for(Framework_Agreement_Payment__c payment:Trigger.old){
				MOUOppIdSet.add(payment.Supplementary_framework_agreement__c);
			}
		}

		List<Supplementary_framework_agreement__c> supplementaryList = [
				SELECT Id,
						SOC_Dept__c,
						Finance_Price_Approval_Status__c,
						GM_approval_Status__c,
						Legal_Dept__c,
						Technical_Dept_Status__c,
						Technical_Dept_Comments__c,
						SOC_Dept_Comments__c,
						Price_Approval_Feedback_Comments__c,
						GM_approval_Comments__c,
						Legal_Dept_Comments__c,
						Opportunity__c
				FROM Supplementary_framework_agreement__c
				WHERE Id IN :MOUOppIdSet
		];

		//审批初始化
		if (supplementaryList.size() != 0) {
			Set<Id> oppIdSet = new Set<Id>();
			for (Supplementary_framework_agreement__c newOpp : supplementaryList) {
				oppIdSet.add(newOpp.Opportunity__c);
			}
			Map<Id, Opportunity> opportunityMap;
			if (oppIdSet.size() != 0) {
				opportunityMap = new Map<Id, Opportunity>([SELECT Id, Roll_up_SFA_Counts__c FROM Opportunity WHERE Id IN :oppIdSet]);
			}

			for (Supplementary_framework_agreement__c newOpp : supplementaryList) {
				if (opportunityMap.get(newOpp.Opportunity__c).Roll_up_SFA_Counts__c != 1) {
					newOpp.SOC_Dept__c = '';
					newOpp.Finance_Price_Approval_Status__c = '';
					newOpp.GM_approval_Status__c = '';
					newOpp.Legal_Dept__c = '';
					newOpp.Technical_Dept_Status__c = '';
					newOpp.Technical_Dept_Comments__c = '';
					newOpp.SOC_Dept_Comments__c = '';
					newOpp.Price_Approval_Feedback_Comments__c = '';
					newOpp.GM_approval_Comments__c = '';
					newOpp.Legal_Dept_Comments__c = '';
				}
			}
			update supplementaryList;
		}
	}
}