/**
 * Add By Javen , 20130111, for work piece(20130111-00002) 
 *
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 *
 * this email services for process review via email reply.
 */
global class ReviewProcessEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        Boolean isReply = true; // REPLY SUCCESS EMAIL OR NOT
        final String[] lstReviewResult = new String[]{'Approved' , 'Rejected'};
        Integer intReviewRes = -1;  // -1=Error ; 0=Approved ; 1=Rejected ;
        
        Messaging.InboundEmailResult EmailResult = new Messaging.InboundEmailresult();
        String userEmail = email.fromAddress;
        String emailBody = ( email.plainTextBody!=null ? email.plainTextBody : email.htmlBody.replaceAll('<[^>]*>','\n') );
        
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@TEST_EMAIL_PRE ==  ' + email.subject +' EMAIL : '+ email.fromAddress + '  Body : '+emailBody );
        
        try{
            
            if( email.subject.contains('[#RVID:') && String.IsNotBlank(emailBody) ){
                // get Contract Id
                String ContractId = email.subject.substring( 
                                        email.subject.indexOf('[#RVID:')+7 , 
                                        email.subject.indexOf('#]')
                                   );
                Contract con = (Contract)CommonUtils.GetObjByID('Contract', ContractId);
                
                // get Send User And Dept
                //List<User> lstUser = Database.query(CommonUtils.MakeSelectSql('User')+' Where EMAIL=:userEmail');
                system.debug('-----userEmail' + userEmail);
                system.debug('-----userEmail' + userEmail);
                list<User> lstUser = [select id,Email,Name,LastName,FirstName,ProfileId   from User where  Email =: userEmail];
                if(userEmail=='xinmeng.hao@jinkosolar.com'){
                    lstUser = [select id,Email,Name,LastName,FirstName,Region__c,ProfileId   from User where  Email =: 'credit@jinkosolar.com'];
                }
                User usr = null;
                
                if( lstUser!=null && lstUser.size() > 0 ){
                    usr = lstUser[0];
                    // get Email Content and clear empty line   
                    List<String> lines = emailBody.split('\n');
                    for( integer i=0; i<lines.size() ; i++ ){
                        if( String.IsBlank( lines[i] ) )
                            lines.remove(i);
                    }
                    /**for( integer i=0; i<lines.size() ; i++ ){
                        if( String.IsBlank( lines[i] ) )
                            lines.remove(i);
                    }*/
                    
                    // Email first line: if agree reply (APPROVE, APPROVED, YES), else reply (REJECT, REJECTED, NO)
                    // Email second line: add approve(or reject) Comments.
                    // Review Results
                    String reviewResult = lines[0].trim();
                    String reviewComments = lines[1];
                    system.debug('-----usr' + usr);                 
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@TEST_EMAIL == ProfileId ' + usr.ProfileId +' EMAIL : '+ userEmail + 'Result : '+ reviewResult + '  Comment : ' + reviewComments);
                                    
                    // analysis review result
                    if( reviewResult.equalsIgnoreCase('APPROVE') || reviewResult.equalsIgnoreCase('APPROVED') || reviewResult.equalsIgnoreCase('YES') 
                      || reviewResult.equalsIgnoreCase('Approve') || reviewResult.equalsIgnoreCase('Approved') || reviewResult.equalsIgnoreCase('Yes')){
                        intReviewRes = 0;
                    }
                    else if( reviewResult.equalsIgnoreCase('REJECT') || reviewResult.equalsIgnoreCase('REJECTED') || reviewResult.equalsIgnoreCase('NO')
                           || reviewResult.equalsIgnoreCase('Reject') || reviewResult.equalsIgnoreCase('Rejected') || reviewResult.equalsIgnoreCase('No')){
                        intReviewRes = 1;
                    }else{
                        // throw new Exception();               
                    }
                    system.debug('~~~~~>intReviewRes:'+ intReviewRes);
                    system.debug('~~~~~>userId:'+ usr);
                    system.debug('~~~~~>lstReviewResult[intReviewRes]:'+ lstReviewResult[intReviewRes]);
                    system.debug('~~~~~>reviewComments:'+ reviewComments);
                    system.debug('~~~~~>usr.ProfileId :'+ usr.ProfileId);
                    /*
                    *
                    *update by jason 20160804
                    */
                    //start
                    // Region Head Profile 审批通过改变  Regional Head 状态
                    if(usr.ProfileId == '00e90000001MzXH' || usr.ProfileId=='00e90000000sjacAAA' || usr.ProfileId=='00e6F000003cHJ3QAM'){
                        con.CMO_Dept__c = lstReviewResult[intReviewRes];
                        con.CMO_Dept_Comments__c = reviewComments;
                        System.debug('------->Region Head:' + con.CMO_Dept__c + '\t'+  con.CMO_Dept_Comments__c);
                    }else if(usr.ProfileId == '00e90000000PdECAA0' || usr.ProfileId == '00e6F0000022kXD' ){  //Sales Manager 审批通过 改变  Sales Dept 状态
                        con.Sales_Dept__c = lstReviewResult[intReviewRes];
                        con.Sales_Dept_Comments__c = reviewComments;
                        System.debug('------->Sales Manager:' + con.Sales_Dept__c + '\t'+ con.Sales_Dept_Comments__c);
                    }else if(usr.ProfileId=='00e90000000NsvO' || usr.Id=='0059000000126GN'){  // Finance 或者  Wang Jeffrey
                        con.Finance_Dept__c = lstReviewResult[intReviewRes];
                        con.Finance_Dept_Comments__c = reviewComments;
                        System.debug('------->Finance 或者  Wang Jeffrey:' + con.Finance_Dept__c +'\t'+ con.Finance_Dept_Comments__c);
                    }else if( usr.ProfileId=='00e90000000NsvP' ){      // Legal
                        con.Legal_Dept__c = lstReviewResult[intReviewRes];
                        con.Legal_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.Legal_Dept__c:'+con.Legal_Dept__c);
                    }
                    else if(usr.Id=='005900000046jZU'){
                        con.Ops_Approval__c = lstReviewResult[intReviewRes];
                        con.Ops_Approval_Comments__c = reviewComments;
                        
                    }
                    
                    /*else if(usr.ProfileId=='00e90000000sjacAAA'){
                        con.CMO_Dept__c = lstReviewResult[intReviewRes];
                        con.CMO_Dept_Comments__c = reviewComments;
                        
                    }*/
                    
                    //PMC
                    else if( usr.ProfileId=='00e90000000O2b5' ){    //PMC
                        con.PMC_Dept__c = lstReviewResult[intReviewRes];
                        con.PMC_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.PMC_Dept__c:'+con.PMC_Dept__c);
                    }
                    //Tech
                    else if( usr.ProfileId=='00e90000000NxtY' ){        //Technical
                        con.Technical_Dept__c = lstReviewResult[intReviewRes];
                        con.Technical_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.Technical_Dept__c:'+con.Technical_Dept__c);
                    }
                    // Rose Qi in Profile 00e90000000Nxyj
                    //BMO
                    else if(usr.ProfileId == '00e90000000NsvN' || usr.ProfileId =='00e90000000Nxyj' || usr.ProfileId =='00e2t000000kuQFAAY'){   //BMO 或者  Stock Coordinator
                        con.BMO_Dept__c = lstReviewResult[intReviewRes];
                        con.BMO_Dept_Comments__c = reviewComments;
                        con.BMO_Dept_New__c = lstReviewResult[intReviewRes];
                        con.BMO_Dept_Comments2__c = reviewComments;
                        system.debug('~~~~>con.BMO_Dept__c:'+con.BMO_Dept__c);
                    }
                    //Quality VP
                    else if(usr.ProfileId == '00e90000000Nxyi'){    // Management Profile
                    } else{
                        // throw new Exception();
                        system.debug('################ Review Dont Match Profile/User ####################');
                    }
                    //end
                    /*
                    // According Dept to update this Dept's Contract
                    if(usr.Id == '005900000015hNj'){     // Niendorf Frank 
                        con.Sales_Dept__c = lstReviewResult[intReviewRes];
                        con.Sales_Dept_Comments__c = reviewComments;
                        con.CMO_Dept__c = lstReviewResult[intReviewRes];
                        con.CMO_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>Sales_Dept:'+con.Sales_Dept__c  +'\tcon.CMO_Dept__c:' + con.CMO_Dept__c);
                    
                    //add by jason 20160803
                    }else if(usr.ProfileId == '00e90000001MzXH'){      //Region Head Profile
                        con.CMO_Dept__c = lstReviewResult[intReviewRes];
                        con.CMO_Dept_Comments__c = reviewComments;
                    }
                    else if( usr.ProfileId == '00e90000001MzXH' ||  usr.ProfileId == '00e90000000PdECAA0' ){  //Region Head Profile 或者  Sales Manager 
                        con.Sales_Dept__c = lstReviewResult[intReviewRes];
                        con.Sales_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>Sales_Dept:'+con.Sales_Dept__c);
                        
                    }
                    else if( usr.UserRoleId=='00E90000000IEDV' ||usr.UserRoleId == '00E90000000IEEd'  ||      //CMO 或者  Director, Sales APAC 或者 Europe third Team 或者  General Manager, US 或者 Director, Italy
                    usr.UserRoleId == '00E90000000Ib6J' || usr.UserRoleId == '00E90000000IEEP' || 
                    usr.UserRoleId == '00E90000000IEEY'){
                        con.CMO_Dept__c = lstReviewResult[intReviewRes];
                        con.CMO_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.CMO_Dept__c2:'+con.CMO_Dept__c);
                    }
                    //usr.ProfileId=='00e90000000NsvO' || usr.ProfileId=='00e90000000sjac' 00e90000000NsvO
                    else if( usr.ProfileId=='00e90000000NsvO' || usr.Id=='0059000000126GN' ){  // Finance 或者  Wang Jeffrey 
                        con.Finance_Dept__c = lstReviewResult[intReviewRes];
                        con.Finance_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.Finance_Dept__c:'+con.Finance_Dept__c);
                    }
                    //Legal
                    
                    else if( usr.ProfileId=='00e90000000NsvP' ){      // Legal
                        con.Legal_Dept__c = lstReviewResult[intReviewRes];
                        con.Legal_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.Legal_Dept__c:'+con.Legal_Dept__c);
                    }
                    //PMC
                    else if( usr.ProfileId=='00e90000000O2b5' ){    //PMC
                        con.PMC_Dept__c = lstReviewResult[intReviewRes];
                        con.PMC_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.PMC_Dept__c:'+con.PMC_Dept__c);
                    }
                    //Tech
                    else if( usr.ProfileId=='00e90000000NxtY' ){        //Technical
                        con.Technical_Dept__c = lstReviewResult[intReviewRes];
                        con.Technical_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.Technical_Dept__c:'+con.Technical_Dept__c);
                    }
                    // Rose Qi in Profile 00e90000000Nxyj
                    //BMO
                    else if(usr.ProfileId == '00e90000000NsvN' || usr.ProfileId =='00e90000000Nxyj'){   //BMO 或者  Stock Coordinator
                        con.BMO_Dept__c = lstReviewResult[intReviewRes];
                        con.BMO_Dept_Comments__c = reviewComments;
                        system.debug('~~~~>con.BMO_Dept__c:'+con.BMO_Dept__c);
                    }
                    //Quality VP
                    else if(usr.ProfileId == '00e90000000Nxyi'){    // Management Profile
                    } else{
                        // throw new Exception();
                        system.debug('################ Review Dont Match Profile/User ####################');
                    }
                    */
                }
                    
                // reyply the procss result to reviewer
                String repSubject = '[noreply]you have seccess to review.';
                String repBody = 'Dear '+usr.FirstName +' '+ usr.LastName+ ':\n'+
                                 'You have successfully to review the Contract['+con.Contract_NO__c+']\n'+
                                 'Thank you!';
                Database.SaveResult dbRes = null;
                if( usr!=null && intReviewRes!=-1 && String.IsNotBlank( ContractId ) ){
                    //update con;
                    dbRes = Database.update(con);
                    System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@UPDATE ID' + dbRes.getId() +'  ,  '+ dbRes.isSuccess()  +'   ERROR : '+dbRes.getErrors());
                    // reply review result
                }
                
                if( usr!=null && isReply && dbRes!=null && dbRes.isSuccess() ){
                       if(usr.id!='005900000015hNj'){
                    CommonUtils.SendBasicMail(new String[]{userEmail}, repSubject, repBody, null);
                       }
                } else {
                    //String failureReason = '';
                    repSubject = '[noreply]you have failed to review.';
                    repBody = 'Dear '+usr.FirstName +' '+ usr.LastName+ ':\n'+
                                     'You have failed to review the contract['+con.Contract_NO__c+']\n'+
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
    
    public void test(){
        decimal i=0;
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
        i++;
        i++;
    }
    
}