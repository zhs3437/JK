/*
 *Add By jason ,20161219
 *邮件回复yes approve approved 时对应的业务机会中自动提交价格审批
 *
 */

global class ComponentTaskBookEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        Boolean isReply = true; // REPLY SUCCESS EMAIL OR NOT
        final String[] lstReviewResult = new String[]{'Approved' , 'Rejected'};
        
        Integer intReviewRes = -1;  // -1=Error ; 0=Approved ; 1=Rejected ;
        
        Messaging.InboundEmailResult EmailResult = new Messaging.InboundEmailresult();
        String userEmail = email.fromAddress;
        String emailBody = ( email.plainTextBody!=null ? email.plainTextBody : email.htmlBody.replaceAll('<[^>]*>','\n') );
        
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@TEST_EMAIL_PRE ==  ' + email.subject +' EMAIL : '+ email.fromAddress + '  Body : '+emailBody );
        
        try{
            System.debug('################## Condition 1. '+email.subject.contains('[#RVID:'));
            System.debug('################## Condition 2. '+String.IsNotBlank(emailBody));
            
            if( email.subject.contains('[#RVID:') && String.IsNotBlank(emailBody) ){
                // get Amenment Id
                String componentId = email.subject.substring( 
                                        email.subject.indexOf('[#RVID:')+7 , 
                                        email.subject.indexOf('#]')
                                   );
                                   
                system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@componentId' + componentId);
                
                list<User> lstUser = [select id,Email,Name,LastName,FirstName   from User where  Email =: userEmail];
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
                    String reviewSignature =lines[1];
                    //String reviewComments = lines[2];
                    
                    // analysis review result
                    if( reviewResult.equalsIgnoreCase('APPROVE') || reviewResult.equalsIgnoreCase('APPROVED') || reviewResult.equalsIgnoreCase('YES') || reviewResult.equalsIgnoreCase('Approved') || reviewResult.equalsIgnoreCase('Approve') || reviewResult.equalsIgnoreCase('Yes')){
                        intReviewRes = 0;
                    }
                    else if( reviewResult.equalsIgnoreCase('REJECT') || reviewResult.equalsIgnoreCase('REJECTED') || reviewResult.equalsIgnoreCase('NO') || reviewResult.equalsIgnoreCase('Reject') || reviewResult.equalsIgnoreCase('Rejected') || reviewResult.equalsIgnoreCase('No')){
                        intReviewRes = 1;
                    }
                    Component_Task_Book__c  ctb = [Select id,Technical_manager_Shanghai__c,Technical_manager_Shanghai_Comments__c,Signature__c From Component_Task_Book__c Where id =: componentId];
                    
                    ctb.Technical_manager_Shanghai__c = lstReviewResult[intReviewRes];
                    //ctb.Technical_manager_Shanghai_Comments__c = reviewComments;
                    ctb.Signature__c= reviewSignature;
                    system.debug('-----ctb.Technical_manager_Shanghai__c : ' + ctb.Technical_manager_Shanghai__c);
                    system.debug('----- ctb.Technical_manager_Shanghai_Comments__c:' +  ctb.Technical_manager_Shanghai_Comments__c);
                    update ctb;
                    // reyply the procss result to reviewer
                    String repSubject = '[noreply]you have seccess to review.';
                    String repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
                                     'You have successfully to review the Module Design (Change) Assignment['+componentId+']\n'+
                                     'Thank you!';
                    
                    if( user!=null && isReply && ctb != null){
                        update ctb;
                         if(user.id!='005900000015hNj'){
                        CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                             }
                    } else {
                        //String failureReason = '';
                        repSubject = '[noreply]you have failed to review.';
                        repBody = 'Dear '+user.FirstName +' '+ user.LastName+ ':\n'+
                                         'You have failed to review the Module Design (Change) Assignment['+componentId+']\n'+
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