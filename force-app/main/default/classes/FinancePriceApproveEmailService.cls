/**
 * Add By jason ,20160505
 *当Finance 收到邮件时在邮件中回复yes approve approved 时对应的业务机会中自动提交价格审批
 */
global class FinancePriceApproveEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
       // Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();


		 Boolean isReply = true;	// REPLY SUCCESS EMAIL OR NOT
    	final String[] lstReviewResult = new String[]{'Approved' , 'Rejected'};
		Integer intReviewRes = -1;	// -1=Error ; 0=Approved ; 1=Rejected ;
		
		Messaging.InboundEmailResult EmailResult = new Messaging.InboundEmailresult();
		String userEmail = email.fromAddress;
		String emailBody = ( email.plainTextBody!=null ? email.plainTextBody : email.htmlBody.replaceAll('<[^>]*>','\n') );
		
		system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@TEST_EMAIL_PRE ==  ' + email.subject +' EMAIL : '+ email.fromAddress + '  Body : '+emailBody );
		
		try{
			System.debug('################## Condition 1. '+email.subject.contains('[#RVID:'));
			System.debug('################## Condition 2. '+String.IsNotBlank(emailBody));
			
			if( email.subject.contains('[#RVID:') && String.IsNotBlank(emailBody) ){
				// get Opportunity Id
				String OpportunityId = email.subject.substring( 
										email.subject.indexOf('[#RVID:')+7 , 
										email.subject.indexOf('#]')
								   );
								   
				system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@OpportunityId' + OpportunityId);
				
				list<Opportunity> opps = [select id,Region__c,Total_MW__c,Trade_Term__c,Total_Quantity__c,RecordType.name,Sales_manager_approval__c,Price_Approval_Status__c from Opportunity where id =: OpportunityId];
				Opportunity opp;
				if(opps != null && opps.size() > 0 ){
					opp = opps[0];
				}
				
				//list<User> lstUser = Database.query(CommonUtils.MakeSelectSql('User')+' Where EMAIL=:userEmail');
				
				list<User> lstUser = [select id,Email,Name,LastName,FirstName  from User where  Email =: userEmail ];
				system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@lstUser' + lstUser);
				User user = null;
				if( lstUser!=null && lstUser.size() > 0 ){
					user = lstUser[0];
					// get Email Content and clear empty line	
					List<String> lines = emailBody.split('\n');
					for( integer i=0; i<lines.size() ; i++ ){
						if( String.IsBlank( lines[i] ) )
							lines.remove(i);
					}
					String reviewResult = lines[0].trim();
					String reviewComments = lines[1];
									
					// analysis review result
					if( reviewResult.equalsIgnoreCase('APPROVE') || reviewResult.equalsIgnoreCase('APPROVED') || reviewResult.equalsIgnoreCase('YES') || reviewResult.equalsIgnoreCase('Approved') || reviewResult.equalsIgnoreCase('Approve') || reviewResult.equalsIgnoreCase('Yes')){
						intReviewRes = 0;
					}
					else if( reviewResult.equalsIgnoreCase('REJECT') || reviewResult.equalsIgnoreCase('REJECTED') || reviewResult.equalsIgnoreCase('NO') || reviewResult.equalsIgnoreCase('Reject') || reviewResult.equalsIgnoreCase('Rejected') || reviewResult.equalsIgnoreCase('No')){
						intReviewRes = 1;
					}
					
					// update opportunity value
					if(intReviewRes >= 0){
						opp.Price_Approval_Status__c            = lstReviewResult[intReviewRes];
						opp.Price_Approval_Feedback_Comments__c = reviewComments;
						system.debug('~~~~~~~~~~~~~~~~opp.Price_Approval_Status__c:' + opp.Sales_manager_approval__c);
						system.debug('~~~~~~~~~~~~~~~~opp.Price_Approval_Feedback_Comments__c:' + opp.Sales_manager_approval__c);
						
					}
					
				}
					
		    	// reyply the procss result to reviewer
		    	String repSubject = '[noreply]you have seccess to review.';
		    	String repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
		    					 'You have successfully to review the Opportunity['+OpportunityId+']\n'+
		    					 'Thank you!';
		    	
		    	//update opp				 
		    	Database.SaveResult dbRes = null;
		    	if( user!=null && intReviewRes!=-1 && String.IsNotBlank( OpportunityId ) ){
			    	dbRes = Database.update(opp);
			    	System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@UPDATE ID' + dbRes.getId() +'  ,  '+ dbRes.isSuccess()  +'   ERROR : '+dbRes.getErrors());
		    	}
		    	
		    	if( user!=null && isReply && dbRes!=null && dbRes.isSuccess() ){
                     if(user.id!='005900000015hNj'){
					CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                         }
		    	} else {
		    		//String failureReason = '';
		    		repSubject = '[noreply]you have failed to review.';
			    	repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
			    					 'You have failed to review the Opportunity['+OpportunityId+']\n'+
			    					 // 'Reasons for the failure :'+ failureReason +' \n'+
			    					 'Thank you!';
		    		CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
			    }
			}
		
		}catch(Exception ex){
            // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            system.debug('ReviewEmailService - ERROR : ' + ex.getMessage());
            throw ex;
		}
		


        return EmailResult;
    }
}