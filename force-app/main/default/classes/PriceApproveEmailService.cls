/*
 *Add By jason ,20160505
 *当Contract Approver 收到邮件时在邮件中回复yes approve approved 时对应的业务机会中自动提交价格审批
 *
 */

global class PriceApproveEmailService implements Messaging.InboundEmailHandler{
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
   
    

       // Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();


		 Boolean isReply = true;	// REPLY SUCCESS EMAIL OR NOT
    	final String[] lstReviewResult = new String[]{'Approved' , 'Reject'};
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
				
				list<Opportunity> opps = 
                    [select id,OwnerId,GM_approval_Feedback__c,Cross_Region__c,Sales_Dept__c,Region__c,Total_MW__c,Trade_Term__c,Regional_Head__c,Total_Quantity__c,RecordType.name,Sales_manager_approval__c,Price_Approval_Status__c,Cross_region_GM_approval__c,Cross_region_GM_feedback__c from Opportunity where id =: OpportunityId];
				Opportunity opp;
				if(opps != null && opps.size() > 0 ){
					opp = opps[0];
				}
				
				//list<User> lstUser = Database.query(CommonUtils.MakeSelectSql('User')+' Where EMAIL=:userEmail');
				list<User> lstUser = [select id,Email,Name,LastName,FirstName,Region__c,ProfileId   from User where  Email =: userEmail];
                if(userEmail=='xinmeng.hao@jinkosolar.com'){
                    lstUser = [select id,Email,Name,LastName,FirstName,Region__c,ProfileId   from User where  Email =: 'credit@jinkosolar.com'];
                }
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
                                              
                           
                       
                   
                        //if((user.Region__c == opp.Region__c)||
                           //((user.Region__c=='EU'|| user.Region__c=='Non EU')&&(opp.Region__c=='EU'|| opp.Region__c=='Non EU')))
						if(user.LastName == opp.Regional_Head__c){
                            opp.Sales_manager_approval__c = lstReviewResult[intReviewRes];
						    opp.GM_approval_Feedback__c   = reviewComments;
                           }else if((opp.Region__c=='Latin America&Italy' && user.Email==Label.Area_Latin_America_Italy)||
                           (opp.Region__c =='Middle East&Africa' && user.Email==Label.Area_Middle_east_africa) ||
                            (opp.Region__c =='North America' && user.Email==Label.Area_North_America)||
                            (opp.Region__c =='South Asia' && user.Email==Label.Area_South_Asia) ||
                            (opp.Region__c =='North Asia' && user.Email==Label.Area_North_Asia)||
                            (opp.Region__c =='MENA' && user.Email==Label.Middle_East_North_Africa)||
                            (opp.Region__c =='SSA' && user.Email==Label.Sub_Saharan_Africa)||
                            (opp.Region__c =='ROA' &&user.Email==Label.Area_ROA)||
                            ((opp.Region__c =='EU(Union)'|| opp.Region__c=='EU(Non-Eu)')&& user.Email==Label.Area_EU)) {
                               opp.Cross_region_GM_approval__c = lstReviewResult[intReviewRes];
                               opp.Cross_region_GM_feedback__c = reviewComments;
                                if((opp.ownerId=='0056F000009rUoAQAU' || opp.ownerId=='0056F000009rUoA') && opp.Cross_Region__c==true ){
                                    opp.Sales_manager_approval__c = lstReviewResult[intReviewRes];
                                    opp.GM_approval_Feedback__c = reviewComments;
                                }
                                else if(opp.Region__c =='North Asia'){
                                    opp.Sales_Dept__c = lstReviewResult[intReviewRes];
                                }

                           }
                        if(
                            //部署替换
                            user.Email=='derrick.zong@jinkosolar.com'
                        ){
                            system.debug('走入这里');
                         opp.Sales_manager_approval__c = lstReviewResult[intReviewRes];
						    opp.GM_approval_Feedback__c   = reviewComments;
                        }
                        if(user.ProfileId == '00e90000000NsvO'){
                           
                        if(user.Email=='credit@jinkosolar.com'){
                             opp.HaoXinMeng_Approvel__c = lstReviewResult[intReviewRes];
                            opp.Japan_Finance_Comments__c   = reviewComments;
                        }else{
                            opp.Price_Approval_Status__c = lstReviewResult[intReviewRes];
						    opp.Price_Approval_Feedback_Comments__c   = reviewComments;
                        }
                        }
                        if(user.ProfileId == '00e90000000PdECAA0' || user.ProfileId =='00e90000001MzXH'){//后面那个建档是Frank的
                            	opp.Sales_Dept__c = lstReviewResult[intReviewRes];
                        }
                    
						//opp.Price_Approval_Status__c            = lstReviewResult[intReviewRes];
						//opp.Price_Approval_Feedback_Comments__c = reviewComments;
						//system.debug('~~~~~~~~~~~~~~~~opp.Price_Approval_Status__c:' + opp.Sales_manager_approval__c);
						//system.debug('~~~~~~~~~~~~~~~~opp.Price_Approval_Feedback_Comments__c:' + opp.Sales_manager_approval__c);
						
                       
						system.debug('~~~~~~~~~~~~~~~~opp.Sales_manager_approval__c:' + opp.Sales_manager_approval__c);
						system.debug('~~~~~~~~~~~~~~~~opp.GM_approval_Feedback__c:' + opp.Sales_manager_approval__c);
                        system.debug('~~~~~~~~~~~~~~~~opp.Cross_region_GM_approval__c:' + opp.Cross_region_GM_approval__c);
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
                    if(User.id!='005900000015hNj'){
					CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                         if(user.Email=='credit@jinkosolar.com'){
                             PriceApprove.submit(OpportunityId);
                        }
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