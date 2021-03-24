global class AmendmentOrderApprovalEmailService implements Messaging.InboundEmailHandler {

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

		Boolean Legal = False;
		Boolean Finance = false;
		Boolean SOC = False;

		Boolean isReply = true; // REPLY SUCCESS EMAIL OR NOT
		final String[] lstReviewResult = new String[]{'Approved', 'Rejected'};
		Integer intReviewRes = -1; // -1=Error ; 0=Approved ; 1=Rejected ;

		Messaging.InboundEmailResult EmailResult = new Messaging.InboundEmailresult();
		String userEmail = email.fromAddress;
		String emailBody =
				( email.plainTextBody != null ? email.plainTextBody : email.htmlBody.replaceAll('<[^>]*>', '\n'));

		System.debug(LoggingLevel.DEBUG, '[AmendmentOrderApprovalEmailService]***userEmail:' + userEmail);
		System.debug(LoggingLevel.DEBUG, '[AmendmentOrderApprovalEmailService]***emailBody:' + emailBody);

		//try{
		if (email.subject.contains('[#RVID:') && String.IsNotBlank(emailBody)) {

			String AmendmentPurchaseAgreementID = email.subject.substring(email.subject.indexOf('[#RVID:') + 7,
					email.subject.indexOf('#]')
			);

			Amendment__c amendment = [
					SELECT Id,
							(SELECT Id,
									 Status__c,
									 Remarks__c,
									 Role__c
							FROM SubmitForReviews__r)
					FROM Amendment__c
					WHERE ID =: AmendmentPurchaseAgreementID
			];
			List<String> roleStrList = new List<String>();
			for (SubmitForReview__c sub : amendment.SubmitForReviews__r) {
				roleStrList.add(sub.Role__c);
			}
			Map<Id, UserRole> userRoleMap = new Map<Id, UserRole>([SELECT Id, Name FROM UserRole WHERE Name in :roleStrList]);

			List<User> userList = [select id, Email, Name, LastName, FirstName, UserRole.Id from User where Email =: userEmail and IsActive=true];
			User user = userList[0];
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


			if (userRoleMap.get(user.UserRole.Id) != null) {
				for (SubmitForReview__c sub : amendment.SubmitForReviews__r) {
					if (sub.Role__c == userRoleMap.get(user.UserRole.Id).Name) {
						System.debug(LoggingLevel.DEBUG, '[AmendmentOrderApprovalEmailService]***SubmitForReview__c:' + sub);

						sub.Status__c = lstReviewResult[intReviewRes];
						sub.Remarks__c = reviewComments;
					}
				}
			}
			System.debug(LoggingLevel.DEBUG, '[AmendmentOrderApprovalEmailService]***amendment.SubmitForReviews__r:' + amendment.SubmitForReviews__r);
			update amendment.SubmitForReviews__r;

			// reyply the procss result to reviewer
			String repSubject = '[noreply]you have seccess to review.';
			String repBody = 'Dear ' + user.FirstName + ' ' + user.LastName + ':\n' +
					'You have successfully to review the Amendment Purchase Agreement[' + AmendmentPurchaseAgreementID + ']\n' +
					'Thank you!';

			//update opp
			Database.SaveResult dbRes = null;
			if (user != null && intReviewRes != -1 && String.IsNotBlank(AmendmentPurchaseAgreementID)) {
				dbRes = Database.update(amendment);
			}
			if (user != null && isReply && dbRes != null && dbRes.isSuccess()) {
				if (user.id != '005900000015hNj') {
					CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
				}
			} else {
				//String failureReason = '';
				repSubject = '[noreply]you have failed to review.';
				repBody = 'Dear ' + user.FirstName + ' ' + user.LastName + ':\n' +
						'You have failed to review the Amendment Purchase Agreement[' + AmendmentPurchaseAgreementID + ']\n' +
					// 'Reasons for the failure :'+ failureReason +' \n'+
						'Thank you!';
				CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
			}
		}

		return EmailResult;
	}

}