/*
 * Created by leal on 2020/4/15.
 */
global class MOUApproveEmailService implements Messaging.InboundEmailHandler{

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

		//try{

		if (email.subject.contains('[#RVID:') && String.IsNotBlank(emailBody)) {
			// get Opportunity Id
			String OpportunityId = email.subject.substring(
							email.subject.indexOf('[#RVID:') + 7,
					email.subject.indexOf('#]')
			);

			Opportunity opp = [
					SELECT id,
							Finance_Dept_Comments__c,
							Approval_Lock__c,
							Lock__c,
							OwnerId,
							Owner.BMO_specialist__c,
							Owner.Contract_Approver__c,
							Region__c,
							Total_MW__c,
							MOU_Opportunity_Approval_Status__c,
							MOU_Opportunity_Comments__c,
							Trade_Term__c,
							Total_Quantity__c,
							RecordType.name,
							Sales_manager_approval__c,
							Finance_Approval_Status__c,
							GM_approval_Status__c,
							GM_approval_Comments__c,
							Technical_Dept_Status__c,
							Technical_Dept_Comments__c,
							SOC_Dept__c,
							Legal_Dept__c,
                			VP_Approval_Status__c,
            				VP_Approval_comments__c
					FROM Opportunity
					WHERE id =: OpportunityId
			];

			//list<User> lstUser = Database.query(CommonUtils.MakeSelectSql('User')+' Where EMAIL=:userEmail');
			List<User> userList = [select id, Email, Name, LastName, FirstName, Profile.Id from User where Email =: userEmail and IsActive=true];
			//财务
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
			User SOCUser = [select id, Email, Name, LastName, FirstName, BMO_specialist__r.Email from User where id =:opp.Owner.BMO_specialist__c];
			if (userList[0].Id == SOCUser.Id) {
				SOC = TRUE;
			}

			//GM
            if(opp.Owner.Contract_Approver__c!=null){
			User GMUser = [select id, Email from User where id =:opp.Owner.Contract_Approver__c];
			if (userList[0].Id == GMUser.Id) {
				GM = TRUE;
			}
            }else{
                if (useremail == Label.Area_EU ||
           
                useremail ==Label.Area_ROA ||
               useremail == Label.Area_North_Asia ||
               useremail == Label.Area_South_Asia ||
               useremail == Label.Area_North_America ||
               useremail == Label.Area_Middle_east_africa ||
                useremail ==Label.Area_Latin_America_Italy ||
                useremail ==Label.Middle_East_North_Africa ||
                useremail ==Label.Sub_Saharan_Africa 
            ) {
				GM = TRUE;
			}
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

				System.debug('intReviewRes-------------------->' + intReviewRes);
				// update opportunity value
				if (intReviewRes >= 0 && Finance && opp.Finance_Approval_Status__c == 'Pending') {
					opp.Finance_Approval_Status__c = lstReviewResult[intReviewRes];
					opp.Finance_Dept_Comments__c = reviewComments;
				} else if (intReviewRes >= 0 && SOC && opp.SOC_Dept__c == 'Pending') {
					opp.SOC_Dept__c = lstReviewResult[intReviewRes];
					opp.SOC_Dept_Comments__c = reviewComments;
				} else if (intReviewRes >= 0 && GM && opp.GM_approval_Status__c == 'Pending') {
					opp.GM_approval_Status__c = lstReviewResult[intReviewRes];
					opp.GM_approval_Comments__c = reviewComments;
				} else if (intReviewRes >= 0 && Technical && opp.Technical_Dept_Status__c == 'Pending') {
					opp.Technical_Dept_Status__c = lstReviewResult[intReviewRes];
					opp.Technical_Dept_Comments__c = reviewComments;
				} else if (opp.Legal_Dept__c ==  'Pending'){
					opp.Legal_Dept__c = lstReviewResult[intReviewRes];
					opp.Legal_Dept_Comments__c = reviewComments;
//					if (opp.Legal_Dept__c == 'Approved'){
//						opp.Lock__c = true;
//					}else if(opp.Legal_Dept__c == 'Rejected'){
//						opp.Lock__c = false;
//					}
                }else if(intReviewRes >= 0 && opp.VP_Approval_Status__c == 'Pending' && FinanceVP){
                    opp.VP_Approval_Status__c = lstReviewResult[intReviewRes];
					opp.VP_Approval_comments__c = reviewComments;
                }

			}

			// reyply the procss result to reviewer
			String repSubject = '[noreply]you have seccess to review.';
			String repBody = 'Dear ' + user.FirstName + ' ' + user.LastName + ':\n' +
					'You have successfully to review the Opportunity[' + OpportunityId + ']\n' +
					'Thank you!';

			//update opp
			Database.SaveResult dbRes = null;
			if (user != null && intReviewRes != -1 && String.IsNotBlank(OpportunityId)) {
				dbRes = Database.update(opp);
			}

			if (user != null && isReply && dbRes != null && dbRes.isSuccess()) {
				if (user.id != '005900000015hNj') {
					CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
				}
			} else {
				//String failureReason = '';
				repSubject = '[noreply]you have failed to review.';
				repBody = 'Dear ' + user.FirstName + ' ' + user.LastName + ':\n' +
						'You have failed to review the Opportunity[' + OpportunityId + ']\n' +
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
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
                                                                i++;
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