/*
 * Created by leal on 2020/4/14.
 */
global class MOUApprovalController {

	webservice static void MOUApprovalController(Id opportunityId) {
		opportunityId = opportunityId;
		Opportunity opportunity = [
				SELECT Id,
						Lock__c,
						SOC_Dept__c,
						Region__c,
						Approval_Lock__c,
						Finance_Approval_Status__c,
						Legal_Dept__c,
						SOC_Dept_Comments__c,
						Finance_Dept_Comments__c,
						Legal_Dept_Comments__c,
						OwnerId,
						Owner.BMO_specialist__c,
						Owner.Contract_Approver__c,
						GM_approval_Status__c,
						GM_approval_Comments__c,
						Technical_Dept_Status__c,
						Technical_Dept_Comments__c,
						Account.Sales_Region__c,
            			VP_Approval_Status__c,
            			VP_Approval_comments__c,
            			roll_up_product_counts__c,
            			roll_up_unitprice_count__c,
						(Select Id, Name, Product2.Name
						FROM OpportunityLineItems)
				FROM Opportunity
				WHERE Id=:opportunityId
		];
		Boolean lockRe = opportunity.Lock__c;

		if (lockRe) {
			opportunity.Lock__c = false;
		}
		//		opportunity.Approval_Lock__c = false;
		update opportunity;

		sendApprovalEmail(opportunityId, selectEmailAdress(opportunity));

		if (lockRe) {
			opportunity.Lock__c = true;
		}
		//		opportunity.Approval_Lock__c = true;
		update opportunity;
	}

	Public static List<String> selectEmailAdress(Opportunity opp) {

		//字段初始化
		opp.SOC_Dept__c = 'Pending';
		opp.Finance_Approval_Status__c = 'Pending';
		opp.GM_approval_Status__c = 'Pending';
		opp.Legal_Dept__c = 'Pending';
		opp.SOC_Dept_Comments__c = '';
		opp.Finance_Dept_Comments__c = '';
		opp.GM_approval_Comments__c = '';
		opp.Legal_Dept_Comments__c = '';
		opp.Technical_Dept_Status__c = 'Pending';
		opp.Technical_Dept_Comments__c = '';
        System.debug('opp.roll_up_product_counts__c------------>'+opp.roll_up_product_counts__c);
        System.debug('opp.roll_up_unitprice_count__c------------>'+opp.roll_up_unitprice_count__c);
        if(opp.roll_up_product_counts__c - opp.roll_up_unitprice_count__c >0 && opp.VP_Approval_Status__c !='Approved'){
           opp.VP_Approval_Status__c = 'Pending';
           opp.VP_Approval_comments__c = '';
        }

		List<String> emailList = new List<String>();
//		User technicalUser = [select id, Email, Name, LastName, FirstName from User where Name ='Jinko Technic'];
//		emailList.add(technicalUser.Email);

		//技术需要审批判断
		if (opp.Account.Sales_Region__c != null){
			if (opp.Account.Sales_Region__c == 'Middle East&Africa'||opp.Account.Sales_Region__c == 'MENA'||opp.Account.Sales_Region__c == 'SSA' || opp.Account.Sales_Region__c == 'Latin America&Italy' || opp.Account.Sales_Region__c == 'South Asia') {
				List<User> technicalUser01 = [SELECT Id, Name, Email, UserRole.Name, Alias FROM USER WHERE Alias =: 'technic2'];
				emailList.add(technicalUser01[0].Email);

			} else if (opp.Account.Sales_Region__c.contains('EU') || opp.Account.Sales_Region__c == 'ROA' || opp.Account.Sales_Region__c == 'North America' || opp.Account.Sales_Region__c == 'North Asia' || opp.Account.Sales_Region__c == 'Central Asia') {
				List<User> technicalUser02 = [SELECT Id, Name, Email, UserRole.Name, Alias FROM USER WHERE Alias =: 'tech'];
				emailList.add(technicalUser02[0].Email);
			}
		}
		//Alex jiang 财务
		User user = [select id, Email, Name, LastName, FirstName from User where Name ='Alex jiang'];

		//SOC BMO specialist
		User SOC = [select id, Email, Name, LastName, FirstName, BMO_specialist__r.Email, BMO_specialist__c from User where id =:opp.Owner.BMO_specialist__c];

		//GM
        if(opp.Owner.Contract_Approver__c!=null){
		User GM = [select id, Email, Name, LastName, FirstName from User where id =:opp.Owner.Contract_Approver__c];
            	emailList.add(GM.Email);
        }else{
            String RegionHeadEmail='';
            if(opp.Region__c =='EU'|| opp.Region__c=='Non EU'){RegionHeadEmail=Label.Area_EU;}else if(opp.Region__c =='EU(Union)'|| opp.Region__c=='EU(Non-Eu)'){RegionHeadEmail=Label.Area_EU;}else if(opp.Region__c =='ROA'){RegionHeadEmail=Label.Area_ROA;}else if(opp.Region__c =='North Asia'){RegionHeadEmail=Label.Area_North_Asia;}else if(opp.Region__c =='South Asia'){RegionHeadEmail=Label.Area_South_Asia;}else if(opp.Region__c =='North America'){RegionHeadEmail=Label.Area_North_America;}else if(opp.Region__c =='Middle East&Africa'){RegionHeadEmail=Label.Area_Middle_east_africa;}else if(opp.Region__c =='Latin America&Italy'){RegionHeadEmail=Label.Area_Latin_America_Italy;}else if(opp.Region__c =='MENA'){RegionHeadEmail=Label.Middle_East_North_Africa;}else if(opp.Region__c =='SSA'){RegionHeadEmail=Label.Sub_Saharan_Africa;}
            emailList.add(RegionHeadEmail);
        }
		emailList.add(user.Email);
		emailList.add(SOC.Email);
	
		System.debug('emailList------------->' + emailList);

		return emailList;
	}

	public static void sendApprovalEmail(Id opportunityId, List<String> emailList) {
		String emailTemplateDeveloperName = 'MOU_Opportunity';
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
		System.debug('emailTemplate------------->' + emailTemplate);

		List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();

		Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, null, opportunityId);

		email.setSenderDisplayName(UserInfo.getName());
		email.setUseSignature(false);
		email.setBccSender(false);
		email.setToAddresses(emailList);
		email.setSaveAsActivity(true);
		emailMessageList.add(email);

		Messaging.sendEmail(emailMessageList);
	}

}