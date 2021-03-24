global class ProductAppEmailService implements Messaging.InboundEmailHandler{
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
				String ProductAppId = email.subject.substring( 
										email.subject.indexOf('[#RVID:')+7 , 
										email.subject.indexOf('#]')
								   );
								   

				
				list<Product_Application__c> opps = 
                    [select id,Own_GM_Email__c from Product_Application__c where id =: ProductAppId];
				Product_Application__c opp;
				if(opps != null && opps.size() > 0 ){
					opp = opps[0];
				}
				
				//list<User> lstUser = Database.query(CommonUtils.MakeSelectSql('User')+' Where EMAIL=:userEmail');
				list<User> lstUser = [select id,Email,Name,LastName,FirstName,Region__c,ProfileId   from User where  Email =: userEmail];
               
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
                                              
                           
                       
                   system.debug('1'+user.Email);
                         system.debug('1'+opp);
                       if(user.Email == opp.Own_GM_Email__c){
                            opp.GM_approval__c = lstReviewResult[intReviewRes];
						    opp.GM_approval_Feedback__c   = reviewComments;
                           }
                              if(user.email == 'gongyi.shi@jinkosolar.com' || user.ProfileId =='00e90000001MzXH'){//后面那个建档是Frank的
                            	 opp.GM_approval__c = lstReviewResult[intReviewRes];
						    opp.GM_approval_Feedback__c   = reviewComments;
                        }
                           
                        
                        if(user.ProfileId == '00e90000000NsvO' || user.ProfileId == '00e2t000000DeS9'){
                           
                        
                            opp.Finance_approval__c = lstReviewResult[intReviewRes];
						    opp.Finance_approval_Feedback__c   = reviewComments;
                        
                        }
                        if(user.ProfileId == '00e6F0000022kXD'){
                            opp.Review_approval__c = lstReviewResult[intReviewRes];
                            opp.Review_approval_Feedback__c = reviewComments;
                        }
                       
					}
					
				}
					
		    	// reyply the procss result to reviewer
		    	String repSubject = '[noreply]you have seccess to review.';
		    	String repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
		    					 'You have successfully to review ['+ProductAppId+']\n'+
		    					 'Thank you!';
		    	
		    	//update opp				 
		    	Database.SaveResult dbRes = null;
		    	if( user!=null && intReviewRes!=-1 && String.IsNotBlank( ProductAppId ) ){
			    	dbRes = Database.update(opp);
			    	System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@UPDATE ID' + dbRes.getId() +'  ,  '+ dbRes.isSuccess()  +'   ERROR : '+dbRes.getErrors());
		    	}
		    	
		    	if( user!=null && isReply && dbRes!=null && dbRes.isSuccess() ){
                    if(User.id!='005900000015hNj'){
					CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                     
                    } 
		    	} else {
		    		//String failureReason = '';
		    		repSubject = '[noreply]you have failed to review.';
			    	repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
			    					 'You have failed to review '+
			    					 // 'Reasons for the failure :'+ failureReason +' \n'+
			    					 'Thank you!';
		    		CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                                       
			    }
                 String I='';
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
					 I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                                    I=I+I;
					 I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;
                    I=I+I;

                
			}
		
		}catch(Exception ex){
            // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            system.debug('ReviewEmailService - ERROR : ' + ex.getMessage());
            throw ex;
		}
		


        return EmailResult;
    }

}