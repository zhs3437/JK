trigger FrameworkAgreementProductTrigger on Framework_Agreement_Product__c(before insert,before update,before delete) {
	//判断是否重置审批
	Set<Id> MOUOppIdSet = new Set<Id>();
	Map<Id, Framework_Agreement_Product__c> oldProductMap = Trigger.oldMap;
	Map<Id, Framework_Agreement_Product__c> newProductMap = Trigger.newMap;
    Boolean VPapproval = false;
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			for(Framework_Agreement_Product__c product:Trigger.new){
				MOUOppIdSet.add(product.Supplementary_framework_agreement__c);
			}
		}
		if(Trigger.isUpdate){
			for (Id newLineItemId : newProductMap.keySet()) {
				Framework_Agreement_Product__c newProduct = newProductMap.get(newLineItemId);

				//if (oldProductMap != null) {
				Framework_Agreement_Product__c oldProduct = oldProductMap.get(newProduct.Id);

				if (oldProduct != null) {
					if (newProduct.Product2__c != oldProduct.Product2__c ||
									newProduct.UnitPrice__c != oldProduct.UnitPrice__c ||
									newProduct.Quantity__c != oldProduct.Quantity__c ||
									newProduct.Guaranteed_Delivery_Date__c !=
									oldProduct.Guaranteed_Delivery_Date__c) {
						MOUOppIdSet.add(newProduct.Supplementary_framework_agreement__c);
					}
                    if(newProduct.UnitPrice__c != oldProduct.UnitPrice__c){
                        VPapproval =true;
                    }
				}
			}
		}
		if(Trigger.isDelete){
			for(Framework_Agreement_Product__c item:Trigger.old){
				MOUOppIdSet.add(item.Supplementary_framework_agreement__c);
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
            			Finance_VP_Approval_comments__c,
            			Finance_VP_Approval_Status__c,
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
                    if(VPapproval){
						newOpp.Finance_VP_Approval_comments__c = '';
						newOpp.Finance_VP_Approval_Status__c = '';
                    }
				}
			}
			update supplementaryList;
		}
	}
}