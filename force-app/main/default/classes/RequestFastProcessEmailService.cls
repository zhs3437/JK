/**
 * create by jason
 * 财务和BMO 通过邮件回复快速生成订单（不需要合同双签就能生成订单）
 */
global class RequestFastProcessEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		
		Boolean isReply = true;	// REPLY SUCCESS EMAIL OR NOT
    	
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
				String ContractId = email.subject.substring( 
										email.subject.indexOf('[#RVID:')+7 , 
										email.subject.indexOf('#]')
								   );
								   
				
				list<Contract> cons = [select id,Name,BMO_Manager_approved_orders_Fast_Process__c,Finance_approved_orders_Fast_Process__c from Contract where id =: ContractId];
				Contract con;
				if(cons != null && cons.size() > 0 ){
					con = cons[0];
				}
				
				
				list<User> lstUser = [select id,Email,Name,LastName,FirstName   from User where  Email =: userEmail and Name != 'Kane Wu'];
				User user;
				
				if(lstUser.size() > 0){
					user = lstUser[0];
				}
				
				if(user != null){
					
					// get Email Content and clear empty line	
					List<String> lines = emailBody.split('\n');
					for( integer i=0; i<lines.size() ; i++ ){
						if( String.IsBlank( lines[i] ) )
							lines.remove(i);
					}
					String reviewResult = lines[0].trim();
					
					// analysis review result
					if( reviewResult.equalsIgnoreCase('APPROVE') || reviewResult.equalsIgnoreCase('APPROVED') || reviewResult.equalsIgnoreCase('YES') || reviewResult.equalsIgnoreCase('Approved') || reviewResult.equalsIgnoreCase('Approve') || reviewResult.equalsIgnoreCase('Yes')){
						system.debug('--------->:1111111');
						if(user.Name == 'Anita Li'){
						system.debug('--------->:Alex Jiang');
							intReviewRes = 0;
							con.Finance_approved_orders_Fast_Process__c = true;
							system.debug('--------->法务:'+con.Finance_approved_orders_Fast_Process__c);
						}else if(user.Name == 'Cathy Yang'){
							system.debug('--------->:Cathy Yang');
							intReviewRes = 0;
							con.BMO_Manager_approved_orders_Fast_Process__c = true;
							system.debug('--------->BMO:'+con.BMO_Manager_approved_orders_Fast_Process__c);
						}
					}
					else if( reviewResult.equalsIgnoreCase('REJECT') || reviewResult.equalsIgnoreCase('REJECTED') || reviewResult.equalsIgnoreCase('NO') || reviewResult.equalsIgnoreCase('Reject') || reviewResult.equalsIgnoreCase('Rejected') || reviewResult.equalsIgnoreCase('No')){
						if(user.Name == 'Alex Jiang'){
							intReviewRes = 1;
							con.Finance_approved_orders_Fast_Process__c = false;
							system.debug('--------->法务:'+con.Finance_approved_orders_Fast_Process__c);
						}else if(user.Name == 'Cathy Yang'){
							intReviewRes = 1;
							con.BMO_Manager_approved_orders_Fast_Process__c = false;
							system.debug('--------->BMO:'+con.BMO_Manager_approved_orders_Fast_Process__c);
						}
					}
					// reyply the procss result to reviewer
			    	String repSubject = '[noreply]you have seccess to review.';
			    	String repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
			    					 'You have successfully to review the Request Fast Process Order['+ContractId+']\n'+
			    					 'Thank you!';
			    	
			    	Database.SaveResult dbRes = null;
			    	system.debug('---------->:user' + user);
			    	system.debug('---------->:intReviewRes' + intReviewRes);
			    	system.debug('---------->:ContractId' + ContractId);
			    	if( user!=null && intReviewRes!=-1 && String.IsNotBlank( ContractId ) ){
				    	dbRes = Database.update(con);
				    	System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@UPDATE ID' + dbRes.getId() +'  ,  '+ dbRes.isSuccess()  +'   ERROR : '+dbRes.getErrors());
			    	}
			    	system.debug('---------->:isReply' + isReply);
			    	system.debug('---------->:dbRes' + dbRes);
			    	//system.debug('---------->:dbRes.isSuccess()' + dbRes.isSuccess());
			    	
			    	if( user!=null && isReply && dbRes!=null && dbRes.isSuccess() ){
						CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
			    	} else {
			    		//String failureReason = '';
			    		repSubject = '[noreply]you have failed to review.';
				    	repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
				    					 'You have failed to review the Request Fast Process Order['+ContractId+']\n'+
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