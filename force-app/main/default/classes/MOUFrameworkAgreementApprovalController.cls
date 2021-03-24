/*
 * Created by leal on 2020/4/23.
 */
global class MOUFrameworkAgreementApprovalController {

	webservice static void MOUFrameworkAgreementApprovalController(Id MOUFrameworkAgreementId) {
		MOUFrameworkAgreementId = MOUFrameworkAgreementId;
		Supplementary_Framework_Agreement__c SFA = [
				SELECT Id,
						Lock__c,
						Approval_Progress__c,
						Opportunity__r.OwnerId,
						SOC_Dept__c,
						Finance_Price_Approval_Status__c,
						Legal_Dept__c,
						SOC_Dept_Comments__c,
						Price_Approval_Feedback_Comments__c,
						Legal_Dept_Comments__c,
						GM_approval_Status__c,
						GM_approval_Comments__c,
						Technical_Dept_Status__c,
						Technical_Dept_Comments__c,
						Account__r.Sales_Region__c,
            			Finance_VP_Approval_comments__c,
                		Finance_VP_Approval_Status__c,
            			roll_up_product_counts__c,
            			roll_up_unitprice_count__c,
            
						(Select Id, Name, Product2__r.Name
						FROM framework_agreement_products__r)
				FROM Supplementary_Framework_Agreement__c
				WHERE Id = :MOUFrameworkAgreementId
		];
		//		Boolean lockRe = sfa.Lock__c;
		//		if(lockRe){
		//			SFA.Lock__c = false;
		//		}
		//		update SFA;

		sendApprovalEmail(MOUFrameworkAgreementId, selectEmailAdress(SFA));

		//		if(lockRe){
		//			sfa.Lock__c = true;
		//		}
		update SFA;
	}

	Public static List<String> selectEmailAdress(Supplementary_Framework_Agreement__c SFA) {

		if (SFA.Lock__c) {
			SFA.Lock__c = false;
		}

		//字段初始化
		update SFA;
		SFA.SOC_Dept__c = 'Pending';
		SFA.Finance_Price_Approval_Status__c = 'Pending';
		SFA.GM_approval_Status__c = 'Pending';
		SFA.Legal_Dept__c = 'Pending';
		SFA.SOC_Dept_Comments__c = '';
		SFA.Price_Approval_Feedback_Comments__c = '';
		SFA.GM_approval_Comments__c = '';
		SFA.Legal_Dept_Comments__c = '';
		SFA.Technical_Dept_Status__c = 'Pending';
		SFA.Technical_Dept_Comments__c = '';
        if(SFA.roll_up_product_counts__c - SFA.roll_up_unitprice_count__c >0 && SFA.Finance_VP_Approval_Status__c!='Approved'){
			SFA.Finance_VP_Approval_Status__c = 'Pending';
			SFA.Finance_VP_Approval_comments__c = '';
        }

		List<String> emailList = new List<String>();

		//技术需要审批判断
		if (SFA.Account__r.Sales_Region__c != null){
			if (SFA.Account__r.Sales_Region__c == 'Middle East&Africa' || SFA.Account__r.Sales_Region__c == 'Latin America&Italy' || SFA.Account__r.Sales_Region__c == 'South Asia') {
				List<User> technicalUser01 = [SELECT Id, Name, Email, UserRole.Name, Alias FROM USER WHERE Alias =: 'technic2'];
				emailList.add(technicalUser01[0].Email);
			} else if (SFA.Account__r.Sales_Region__c.contains('EU') || SFA.Account__r.Sales_Region__c == 'ROA' || SFA.Account__r.Sales_Region__c == 'North America' || SFA.Account__r.Sales_Region__c == 'North Asia' || SFA.Account__r.Sales_Region__c == 'Central Asia') {
				List<User> technicalUser02 = [SELECT Id, Name, Email, UserRole.Name, Alias FROM USER WHERE Alias =: 'tech'];
				emailList.add(technicalUser02[0].Email);
			}
		}

		//Alex jiang 财务
		User user = [select id, Email, Name, LastName, FirstName from User where Name ='Alex jiang'];

		//SOC BMO specialist
		User BMOUser = [SELECT Id, BMO_specialist__c, Contract_Approver__c FROM User WHERE Id = :SFA.Opportunity__r.OwnerId];
		User SOC = [select id, Email, Name, LastName, FirstName, BMO_specialist__r.Email from User where id =:BMOUser.BMO_specialist__c];

		//GM
		User GM = [select id, Email, Name, LastName, FirstName from User where id =:BMOUser.Contract_Approver__c];
		emailList.add(user.Email);
		emailList.add(SOC.Email);
		emailList.add(GM.Email);

		System.debug('emailList------->' + JSON.serialize(emailList));
		return emailList;
	}

	public static void sendApprovalEmail(Id MOUFrameworkAgreementId, List<String> emailList) {
		String emailTemplateDeveloperName = 'MOU_Opportunity_Again';
		Id templateId ;
		EmailTemplate emailTemplate = [
				SELECT Id
				FROM EmailTemplate
				WHERE DeveloperName =: emailTemplateDeveloperName
		];
		templateId = emailTemplate.Id;

		if (templateId == null) {
			return;
		}

		List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();

		Messaging.SingleEmailMessage email =
				Messaging.renderStoredEmailTemplate(templateId, null, MOUFrameworkAgreementId);

		email.setSenderDisplayName(UserInfo.getName());
		email.setUseSignature(false);
		email.setBccSender(false);
		email.setToAddresses(emailList);
		email.setSaveAsActivity(false);
		emailMessageList.add(email);
		Messaging.sendEmail(emailMessageList);
	}
}