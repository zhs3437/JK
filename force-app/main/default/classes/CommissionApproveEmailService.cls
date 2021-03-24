global class CommissionApproveEmailService implements Messaging.InboundEmailHandler {

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
				List<Commission_Application__c> ca =[select id,opportunity__c from Commission_Application__c where id =: OpportunityId];
				list<Opportunity> opps = [select id,Region__c,CEO_Approval_Status__c,CEO_Approval_comments__c,Total_MW__c,Trade_Term__c,Total_Quantity__c,RecordType.name,Sales_manager_approval__c,Price_Approval_Status__c from Opportunity where id =: ca[0].opportunity__c];
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
				    system.debug('intReviewRes:'+intReviewRes);
					if(intReviewRes >= 0){
                        if(lstUser[0].email=='mg@jinkosolar.com'){
						opp.CEO_Approval_Status__c            = lstReviewResult[intReviewRes];
						opp.CEO_Approval_comments__c = reviewComments;
                        }
                        if(lstUser[0].email=='cfo.office@jinkosolar.com'){
						opp.CFO_Approval_Status__c            = lstReviewResult[intReviewRes];
						opp.CFO_Approval_comments__c = reviewComments;
                        }
                        if(lstUser[0].email=='jeffrey.wang@jinkosolar.com'){
						opp.VP_Approval_Status__c            = lstReviewResult[intReviewRes];
						opp.VP_Approval_comments__c = reviewComments;
                        }
												
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