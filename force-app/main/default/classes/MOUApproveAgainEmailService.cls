global class MOUApproveAgainEmailService implements Messaging.InboundEmailHandler{

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
														   Messaging.InboundEnvelope envelope) {

		//Finance Flag and SOC Flag
		Boolean Finance = False;
		Boolean SOC = False;
		Boolean GM = False;
		Boolean Technical = False;
		Boolean FinanceVP = False;
                                                               
		Boolean isReply = true; // REPLY SUCCESS EMAIL OR NOT
		final String[] lstReviewResult = new String[]{'Approved', 'Rejected'};
		Integer intReviewRes = -1; // -1=Error ; 0=Approved ; 1=Rejected ;

		Messaging.InboundEmailResult EmailResult = new Messaging.InboundEmailresult();
		String userEmail = email.fromAddress;
		String emailBody =
				( email.plainTextBody != null ? email.plainTextBody : email.htmlBody.replaceAll('<[^>]*>', '\n'));

		System.debug(LoggingLevel.DEBUG, '[MOUApproveAgainEmailService]***userEmail:' + userEmail);
		System.debug(LoggingLevel.DEBUG, '[MOUApproveAgainEmailService]***emailBody:' + emailBody);

		//try{
		if (email.subject.contains('[#RVID:') && String.IsNotBlank(emailBody)) {
			// get Opportunity Id
			String SupplementaryFrameworkAgreementID = email.subject.substring(email.subject.indexOf('[#RVID:') + 7,
					email.subject.indexOf('#]')
			);

			Supplementary_Framework_Agreement__c sfa = [
					SELECT Id,
							Opportunity__r.OwnerId,
							Sync_MOU_Opportunity__c,
							Lock__c,
							Approval_Progress__c,
							Region__c,
							Total_MW__c,
							Trade_Term__c,
							Total_Quantity__c,
							SOC_Dept__c,
							SOC_Dept_Comments__c,
							Finance_Price_Approval_Status__c,
							Price_Approval_Feedback_Comments__c,
							Legal_Dept__c,
							Legal_Dept_Comments__c,
							GM_approval_Status__c,
							GM_approval_Comments__c,
							Technical_Dept_Status__c,
							Technical_Dept_Comments__c,
                			Finance_VP_Approval_comments__c,
                			Finance_VP_Approval_Status__c
					from Supplementary_Framework_Agreement__c
					where id =: SupplementaryFrameworkAgreementID
			];
			User BMOUser = [SELECT Id, BMO_specialist__c, Contract_Approver__c FROM User WHERE Id = :sfa.Opportunity__r.OwnerId];

			//list<User> lstUser = Database.query(CommonUtils.MakeSelectSql('User')+' Where EMAIL=:userEmail');
			List<User> userList = [select id, Email, Name, LastName, FirstName, Profile.Id from User where Email =: userEmail and IsActive=true];

			//Finance
			Profile FinanceProfile = [select id, name from Profile where name='Finance'];
			if (userList[0].Profile.Id == FinanceProfile.Id) {
				Finance = TRUE;
			}
 			//财务VP
            Profile FinanceVPProfile = [select id, name from Profile where name='Finance VP'];
			if (userList[0].Profile.Id == FinanceVPProfile.Id) {
				FinanceVP = TRUE;
			}
			//SOC
			User SOCUser = [select id, Email, Name, LastName, FirstName, BMO_specialist__r.Email from User where id =:BMOUser.BMO_specialist__c];
			if (userList[0].Id == SOCUser.Id) {
				SOC = TRUE;
			}

			//GM
			User GMUser = [select id, Email from User where id =:BMOUser.Contract_Approver__c];
			if (userList[0].Id == GMUser.Id) {
				GM = TRUE;
			}

			//Technical
			Profile technicalProfile = [select id, name from Profile where name='Technical'];
			if (userList[0].Profile.Id == technicalProfile.Id) {
				Technical = TRUE;
			}

			User user = userList[0];

			if (user != null) {
				// get Email Content and clear empty line
				List<String> lines = emailBody.split('\n');
				for (integer i = 0; i < lines.size() ; i++) {
					if (String.IsBlank(lines[i]))
						lines.remove(i);
				}
				String reviewResult = lines[0].trim();
				String reviewComments = lines[1];

				// analysis review result
				if (reviewResult.equalsIgnoreCase('APPROVE') || reviewResult.equalsIgnoreCase('APPROVED') ||
						reviewResult.equalsIgnoreCase('YES') || reviewResult.equalsIgnoreCase('Approved') ||
						reviewResult.equalsIgnoreCase('Approve') || reviewResult.equalsIgnoreCase('Yes')) {
					intReviewRes = 0;
				} else if (reviewResult.equalsIgnoreCase('REJECT') || reviewResult.equalsIgnoreCase('REJECTED') ||
						reviewResult.equalsIgnoreCase('NO') || reviewResult.equalsIgnoreCase('Reject') ||
						reviewResult.equalsIgnoreCase('Rejected') || reviewResult.equalsIgnoreCase('No')) {
					intReviewRes = 1;
				}

				// update opportunity value
				if (intReviewRes >= 0 && Finance && sfa.Finance_Price_Approval_Status__c == 'Pending') {
					sfa.Finance_Price_Approval_Status__c = lstReviewResult[intReviewRes];
					sfa.Price_Approval_Feedback_Comments__c = reviewComments;
				} else if (intReviewRes >= 0 && SOC && sfa.SOC_Dept__c == 'Pending') {
					sfa.SOC_Dept__c = lstReviewResult[intReviewRes];
					sfa.SOC_Dept_Comments__c = reviewComments;
					System.debug(LoggingLevel.DEBUG,
									'[MOUApproveAgainEmailService]***SOC_Dept__c:' + lstReviewResult[intReviewRes]);
				} else if (intReviewRes >= 0 && GM && sfa.GM_approval_Status__c == 'Pending') {
					sfa.GM_approval_Status__c = lstReviewResult[intReviewRes];
					sfa.GM_approval_Comments__c = reviewComments;
				} else if (intReviewRes >= 0 && Technical && sfa.Technical_Dept_Status__c == 'Pending') {
					sfa.Technical_Dept_Status__c = lstReviewResult[intReviewRes];
					sfa.Technical_Dept_Comments__c = reviewComments;
				} else if(sfa.Legal_Dept__c == 'Pending'){
					sfa.Legal_Dept__c = lstReviewResult[intReviewRes];
					sfa.Legal_Dept_Comments__c = reviewComments;
					System.debug(LoggingLevel.DEBUG,
									'[MOUApproveAgainEmailService]***Legal_Dept__c:' + lstReviewResult[intReviewRes]);
//					if (sfa.Legal_Dept__c == 'Approved'){
//						sfa.Lock__c = true;
//					}else if(sfa.Legal_Dept__c == 'Rejected'){
//						sfa.Lock__c = false;
//					}
                }else if(intReviewRes >= 0 && FinanceVP && sfa.Finance_VP_Approval_Status__c == 'Pending'){
                    sfa.Finance_VP_Approval_Status__c = lstReviewResult[intReviewRes];
					sfa.Finance_VP_Approval_comments__c = reviewComments;                      
                }
			}

			// reyply the procss result to reviewer
			String repSubject = '[noreply]you have seccess to review.';
			String repBody = 'Dear ' + user.FirstName + ' ' + user.LastName + ':\n' +
					'You have successfully to review the Opportunity[' + SupplementaryFrameworkAgreementID + ']\n' +
					'Thank you!';

			//update opp
			Database.SaveResult dbRes = null;
			if (user != null && intReviewRes != -1 && String.IsNotBlank(SupplementaryFrameworkAgreementID)) {
				dbRes = Database.update(sfa);
			}
			if (user != null && isReply && dbRes != null && dbRes.isSuccess()) {
				if (user.id != '005900000015hNj') {
					CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
				}
			} else {
				//String failureReason = '';
				repSubject = '[noreply]you have failed to review.';
				repBody = 'Dear ' + user.FirstName + ' ' + user.LastName + ':\n' +
						'You have failed to review the Opportunity[' + SupplementaryFrameworkAgreementID + ']\n' +
					// 'Reasons for the failure :'+ failureReason +' \n'+
						'Thank you!';
				CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
			}
		}
Decimal i=0;
                                                               i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
		//		}catch(Exception ex){
		//			// ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
		//			system.debug('ReviewEmailService - ERROR : ' + ex.getMessage());
		//			throw ex;
		//		}

		return EmailResult;
	}
}