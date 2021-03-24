/**   
 *create by Jason 20160602
 *补充协议Email Service
 */
global class AmendmentApproveEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        system.debug('----------huifyuyoujian');
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		
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
				// get Amenment Id
				String AmendmentId = email.subject.substring( 
										email.subject.indexOf('[#RVID:')+7 , 
										email.subject.indexOf('#]')
								   );
								   
				system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@AmendmentId' + AmendmentId);
				
				list<User> lstUser = [select id,Email,Name,LastName,FirstName   from User where  Email =: userEmail and Name != 'Wei David'];
				User user;
				
				if(lstUser.size() > 0){
					user = lstUser[0];
				}
				system.debug('--------->user' + user);
				if(user != null){
					
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
					
					list<SubmitForReview__c> sfrs = [select id,Status__c,
															Remarks__c,
															Date__c,
															User__c,
                                                     		Role__C
															from SubmitForReview__c 
															where Amendment__c =: AmendmentId and User__c =: user.Id];
                    Amendment__c am = new Amendment__c();
                    
					system.debug('-------intReviewRes' + intReviewRes);
                    
                    for(SubmitForReview__c review : sfrs){
                        if(intReviewRes != -1){
                        	review.Status__c   = lstReviewResult[intReviewRes];
                            review.Remarks__c  = reviewComments;
                            review.Date__c     = DateTime.now();
                            review.RoleCopy__c = review.Role__c;
                        }
                    }
                   
					
					system.debug('--------->user' + user);
					// reyply the procss result to reviewer
			    	String repSubject = '[noreply]you have seccess to review.';
			    	String repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
			    					 'You have successfully to review the Amendment Purchase Agreement['+AmendmentId+']\n'+
			    					 'Thank you!';
			    	
			    	if( user!=null && isReply && sfrs.size() > 0 && intReviewRes != -1){
			    		update sfrs;
                                 if(user.id!='005900000015hNj'){
						CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                                     }
			    	}
                    if(user!=null && isReply && sfrs.size() > 0 && intReviewRes == -1){
			    		//String failureReason = '';
			    		repSubject = '[noreply]you have failed to review.';
				    	repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
				    					 'You have failed to review the Amendment Purchase Agreement['+AmendmentId+']\n'+
				    					 // 'Reasons for the failure :'+ failureReason +' \n'+
				    					 'Thank you!'; 
			    		CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
				    }
			    	
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