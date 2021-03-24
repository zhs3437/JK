trigger Unlock on SubmitForReview__c (after update) {
    
    public class Approver  {
        public Approver(string uEmail,string uName,string roleName,String uid){
            this.uEmail=uEmail;
            this.uName=uName;
            this.roleName=roleName;
            this.isSelect=true;
            this.uId = uId;
        }
        public boolean isSelect {get;set;}
        public String uEmail {get;set;}         
        public String uName {get;set;}
        public String roleName {get;set;}
        public String uId{get;set;}
    }
    public static void SendAmendmentReviewMail(List<Approver> recipients,String amId){
        // try{
        
        if(recipients == null) return;
        if(recipients.size() == 0) return;
        List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
        List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =: 'test_sgy'];
        for(Approver user : recipients){
            List<String> emailList = new List<String>();
            Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
            mail.setSaveAsActivity(false);
            emailList.add(user.uEmail);
            mail.setToAddresses(emailList); 
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setTargetObjectId(user.uId);
            if(mailTemplate.size()>0){
                mail.setTemplateId(mailTemplate[0].Id);
            }
            if(amId != null)mail.setWhatId(amId);
            mail.setSenderDisplayName(UserInfo.getName());
            mailList.add(mail);
        }
        Messaging.sendEmail(mailList);
        //  }catch(Exception e){System.debug(String.valueOf(e));  }
    }
    String aid;
    // 仅考虑实际业务中只会发生一个补充协议下某一个Review进行审核
    for(SubmitForReview__c review_new : trigger.new){
        aid=review_new.Amendment__c;
    }
    List<Amendment__c> Amend=[select id,Number_of_Approve__c,Destination_Country__c,Region__c,Number_of_Reviews__c,Contract_Owner__c  from Amendment__c where id =:aid];
    List<Approver> approverList = new List<Approver>(); 
    if(amend.size()>0){
        
        List< Order_Differences__c> ODLst =[select id, Contract_PO_PI_Owner_New__r.name , Contract_PO_PI_Owner_Old__r.name , Actual_Sales_Name_New__c , Actual_Sales_Name_Old__c , Opportunity_New__r.name , Opportunity_Old__r.name , Account_Name_New__r.name  , Account_Name_Old__r.name,
                                            Destination_Country_New__c  ,  Destination_Country_Old__c  ,
                                            SAP_User_ID_New__c ,  SAP_User_ID_Old__c , Contract_PO_PI_No_New__c , Contract_PO_PI_No_Old__c , Supply_By_New__c ,  Supply_By_Old__c , Status_New__c  ,  Status_Old__c ,
                                            Buyer_New__r.name  ,       Buyer_Old__r.name 
                                            ,   Order_Start_Date_New__c  ,       Order_Start_Date_Old__c 
                                            ,   Destination_New__c  ,       Destination_Old__c 
                                            ,   Factory_WH_New__c  ,       Factory_WH_Old__c 
                                            ,   Shipping_type_New__c  ,       Shipping_type_Old__c 
                                            , 
                                            Warranty_Insurance_New__c ,  Warranty_Insurance_Old__c 
                                            ,   Region_New__c  ,       Region_Old__c 
                                            ,   Warranty_On_Material_and_Workmanship_New__c  ,       Warranty_On_Material_and_Workmanship_Old__c 
                                            , 
                                            Customer_Order_Reference_PO_New__c  ,       Customer_Order_Reference_PO_Old__c 
                                            ,   Commission_Value_sync_to_SAP_New__c  ,       Commission_Value_sync_to_SAP_Old__c 
                                            ,   Commission_Type_New__c  ,       Commission_Type_Old__c 
                                            ,   VAT_NO_New__c  ,       VAT_NO_Old__c 
                                            ,   GST_Classification_Region_New__c  ,       GST_Classification_Region_Old__c 
                                            ,   BMO_SH_New__c  ,       BMO_SH_Old__c 
                                            ,   BMO_SR_New__c  ,       BMO_SR_Old__c 
                                            ,   Special_New__c  ,       Special_Old__c 
                                            ,   Normal_New__c  ,       Normal_Old__c 
                                            ,   Special_Requirements_New__c  ,       Special_Requirements_Old__c 
                                            ,   Special_Approvals_New__c  ,       Special_Approvals_Old__c 
                                            , 
                                            Intercompany_Seller_POs_New__c  ,       Intercompany_Seller_POs_Old__c 
                                            , 
                                            Requested_supplier_New__c  ,       Requested_supplier_Old__c 
                                            ,   Other_New__c  ,       Other_Old__c 
                                            ,   PMC_confirm_New__c  ,       PMC_confirm_Old__c 
                                            ,   Tax_Rate_New__c  ,       Tax_Rate_Old__c 
                                            ,    Transit_Fees_New__c  ,       Transit_Fees_Old__c 
                                            ,   SELLER_New__c  ,       SELLER_Old__c ,Amendment_Purchase_Agreement__r.Destination_Country__c
                                            ,   Contact_Name_New__c  ,       Contact_Name_Old__c 
                                            ,   Customer_country_New__c  ,       Customer_country_Old__c 
                                            ,   Fax_New__c  ,       Fax_Old__c 
                                            ,   Phone_New__c  ,       Phone_Old__c 
                                            ,   Customer_Business_Scale_New__c  ,       Customer_Business_Scale_Old__c   
                                            ,
                                            Email_New__c  ,       Email_Old__c   
                                            ,   Title_New__c  ,       Title_Old__c   
                                            ,   Authorized_Representative_New__c  ,       Authorized_Representative_Old__c   
                                            ,   BillingCountry_New__c  ,       BillingCountry_Old__c   
                                            ,   BillingState_New__c  ,       BillingState_Old__c   
                                            , 
                                            BillingCity_New__c  ,       BillingCity_Old__c   
                                            ,   Bank_Street_New__c  ,       Bank_Street_Old__c   
                                            ,   BillingPostalCode_New__c  ,       BillingPostalCode_Old__c   
                                            ,   Bank_Information_Content_New__c  ,       Bank_Information_Content_Old__c   
                                            ,   Payment_Term_Description_New__c  ,       Payment_Term_Description_Old__c   
                                            ,   Trade_term_New__c   ,       Trade_term_Old__c   
                                            ,   Total_Price_New__c   ,       Total_Price_Old__c   
                                            ,   Total_Quantity_New__c   ,       Total_Quantity_Old__c   
                                            ,   Commission_New__c ,       Commission_Old__c   ,OwnerId,Amendment_Purchase_Agreement__c
                                            ,Amendment_Purchase_Agreement__r.Region__c from Order_Differences__c where  Amendment_Purchase_Agreement__c =: Amend[0].id];
        Boolean DifferentAmend = false;
        if(ODLst.size()>0){
            for(Order_Differences__c OD :ODLst){
                if(
                    OD.SELLER_New__c !=      OD.SELLER_Old__c ||
                    OD.Destination_Country_New__c != OD.Destination_Country_Old__c ||
                    OD.Buyer_New__r.name !=      OD.Buyer_Old__r.name  ||
                    OD.Trade_term_New__c  !=      OD.Trade_term_Old__c  
                    /**
OD.Destination_Country_New__c != OD.Destination_Country_Old__c ||
OD.Contract_PO_PI_Owner_New__r.name!=OD.Contract_PO_PI_Owner_Old__r.name||
OD.Actual_Sales_Name_New__c!=OD.Actual_Sales_Name_Old__c||
OD.Actual_Sales_Name_New__c!=OD.Actual_Sales_Name_Old__c||
OD.Opportunity_New__r.name!=OD.Opportunity_Old__r.name||OD.Account_Name_New__r.name !=OD.Account_Name_Old__r.name||
OD.SELLER_New__c != OD.SELLER_Old__c||OD.SAP_User_ID_New__c!= OD.SAP_User_ID_Old__c||
OD.Contract_PO_PI_No_New__c!= OD.Contract_PO_PI_No_Old__c||OD.Status_New__c!=OD.Status_Old__c||OD.Status_New__c != OD.Status_Old__c||
OD.Buyer_New__r.name !=      OD.Buyer_Old__r.name 
||  OD.Order_Start_Date_New__c !=      OD.Order_Start_Date_Old__c 
||  OD.Destination_New__c !=      OD.Destination_Old__c 
||  OD.Factory_WH_New__c !=      OD.Factory_WH_Old__c 
|| 
OD.Warranty_Insurance_New__c!= OD.Warranty_Insurance_Old__c 
||  OD.Region_New__c !=      OD.Region_Old__c 
||  OD.Warranty_On_Material_and_Workmanship_New__c !=      OD.Warranty_On_Material_and_Workmanship_Old__c 
|| 

OD.Customer_Order_Reference_PO_New__c !=      OD.Customer_Order_Reference_PO_Old__c
||  OD.Commission_Type_New__c !=      OD.Commission_Type_Old__c 
||  OD.VAT_NO_New__c !=      OD.VAT_NO_Old__c 
||  OD.GST_Classification_Region_New__c !=      OD.GST_Classification_Region_Old__c 
||  OD.BMO_SH_New__c !=      OD.BMO_SH_Old__c 
||  OD.BMO_SR_New__c !=      OD.BMO_SR_Old__c 
||  OD.Special_New__c !=      OD.Special_Old__c 
||  OD.Normal_New__c !=      OD.Normal_Old__c 
||  OD.Special_Requirements_New__c !=      OD.Special_Requirements_Old__c 
||  OD.Special_Approvals_New__c !=      OD.Special_Approvals_Old__c 
|| 
OD.Intercompany_Seller_POs_New__c !=      OD.Intercompany_Seller_POs_Old__c 
|| 
OD.Requested_supplier_New__c !=      OD.Requested_supplier_Old__c 
||  OD.Other_New__c !=      OD.Other_Old__c 
||  OD.PMC_confirm_New__c !=      OD.PMC_confirm_Old__c 
||  OD.Tax_Rate_New__c !=      OD.Tax_Rate_Old__c 
||  OD.SELLER_New__c !=      OD.SELLER_Old__c 
||  OD.Contact_Name_New__c !=      OD.Contact_Name_Old__c 
||  OD.Customer_country_New__c !=      OD.Customer_country_Old__c 
||  OD.Fax_New__c !=      OD.Fax_Old__c 
||  OD.Phone_New__c !=      OD.Phone_Old__c 
||

OD.Email_New__c !=      OD.Email_Old__c   
||  OD.Title_New__c !=      OD.Title_Old__c   
||  OD.Authorized_Representative_New__c !=      OD.Authorized_Representative_Old__c   
||  OD.BillingCountry_New__c !=      OD.BillingCountry_Old__c   
||  OD.BillingState_New__c !=      OD.BillingState_Old__c   
|| 
OD.BillingCity_New__c !=      OD.BillingCity_Old__c   
||  OD.Bank_Street_New__c !=      OD.Bank_Street_Old__c   
||  OD.BillingPostalCode_New__c !=      OD.BillingPostalCode_Old__c 
||  OD.Trade_term_New__c  !=      OD.Trade_term_Old__c  
//原本在这备注
*/
                ){
                    DifferentAmend = true;
                }                
            }
            
            String ODId =ODLst[0].id;
            List<PaymentDifference__c>  PDLst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.PaymentDifference__c) + ' ' +
                                                               'where Order_Differences__c =: ODId');
            system.debug('比较个数');
            List<SubmitForReview__c> fullReview = [SELECT ID,Role__c FROM SubmitForReview__c WHERE Amendment__c =: amend[0].Id];
            List<SubmitForReview__c> fullApprovedReview = [SELECT ID,Role__c FROM SubmitForReview__c WHERE Amendment__c =: amend[0].Id AND Status__c =: 'Approved'];
            system.debug('fullReview:'+fullReview.size());
            system.debug('fullApprovedReview:'+fullApprovedReview.size());
            
            if(fullReview.size()==3 && fullApprovedReview.size() ==3){
                system.debug('3'); 
                Boolean SendToLegal = false; 
                for(PaymentDifference__c PD:PDLst){
                    if(PD.Payment_Method_New__c!=PD.Payment_Method_Old__c || PD.Percentage_New__c!=PD.Percentage_Old__c ||
                       PD.Payment_Term_New__c	!=PD.Payment_Term_Old__c || PD.Down_Balance_Payment_New__c!=PD.Down_Balance_Payment_New__c ||
                       PD.Days_New__c	!=PD.Days_Old__c || DifferentAmend ==true
                       || Amend[0].Destination_Country__c=='Japan'){
                           SendToLegal = true;
                       }
                }
                if(SendToLegal==true){
                    system.debug('需用法务'); 
                    if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='North Asia' && ODLst[0].Amendment_Purchase_Agreement__r.Destination_Country__c=='Japan'){
                        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal.japan@jinkosolar.com'];
                        // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Japan'];
                        if(usr.size()>0){
                            approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                        }
                        SYStem.debug('发邮件给 l');
                    }
                    else if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Union)' ||ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Non-Eu)'){
                        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'francesco.destales@jinkosolar.com'];
                        if(usr.size()>0){
                            approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                        }
                        SYStem.debug('发邮件给 欧洲l');
                    }
                    else {
                        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal@jinkosolar.com'];
                        // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Public'];
                        if(usr.size()>0){
                            approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));  
                        }
                        SYStem.debug('发邮件给 l');
                    }
                    List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
                    List<String> ApproverName = new List<String>(); 
                    List<Id> ApproverId = new List<Id>();
                    List<String> email = new List<String>();
                    for (Approver u : approverList ) {
                        
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                        email.add(u.uEmail);
                        system.debug('~~~~~~~~~~~>email:'+email);
                        ApproverId.add(u.uId);
                        ApproverName.add(u.uName);
                        system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					
                        
                    }
                    system.debug('~~~~~~~~>reviewList:' + reviewList);
                    for(ID userid : ApproverId){
                        SubmitForReview__c review = new SubmitForReview__c();
                        review.Amendment__c = ODLst[0].Amendment_Purchase_Agreement__c;
                        review.Status__c    = 'Pending';
                        review.User__c      = userid;
                        
                        reviewList.add(review);
                        
                        System.debug('~~~~~~~~~userid'+userid);
                        System.debug('~~~~~~~~~User__c'+review.User__c);
                    }
                    List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                             Remarks__c,
                                                             Role__c,
                                                             Status__c,
                                                             User__c
                                                             from SubmitForReview__c
                                                             where Amendment__c =: ODLst[0].Amendment_Purchase_Agreement__c
                                                             AND User__c in: ApproverId];
                    system.debug('------>oldReviewList:' +  oldReviewList);
                    
                    if(oldReviewList.size()>0 && oldReviewList != null){
                        delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
                    }
                    
                    if(reviewList.size() > 0)insert reviewList;	
                    
                    SendAmendmentReviewMail(approverList,ODLst[0].Amendment_Purchase_Agreement__c);
                }
                
                if(SendToLegal==false){
                    system.debug('不用法务'); 
                    if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                    system.debug('发送完成');
                    if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                }
                
                
            }
            if(fullReview.size()==4 && fullApprovedReview.size() ==4){
                system.debug('4'); 
                boolean LegalApproval=false;
                for(SubmitForReview__c sfr : fullReview){
                    
                    if(sfr.Role__c.indexof('Legal')>-1){
                        LegalApproval = true;
                    }
                }
                if(LegalApproval == true){
                    system.debug('不用法务  法务同意'); 
if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                    if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                    system.debug('发送完成');
                }
                if(LegalApproval == false){
                    Boolean SendToLegal = false; 
                    for(PaymentDifference__c PD:PDLst){
                        if(PD.Payment_Method_New__c!=PD.Payment_Method_Old__c || PD.Percentage_New__c!=PD.Percentage_Old__c ||
                           PD.Payment_Term_New__c	!=PD.Payment_Term_Old__c || PD.Down_Balance_Payment_New__c!=PD.Down_Balance_Payment_New__c ||
                           PD.Days_New__c	!=PD.Days_Old__c || DifferentAmend ==true
                           || Amend[0].Destination_Country__c=='Japan'){
                               SendToLegal = true;
                           }
                    }
                    if(SendToLegal==true){
                        if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='North Asia'&& ODLst[0].Amendment_Purchase_Agreement__r.Destination_Country__c=='Japan'){
                            List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal.japan@jinkosolar.com'];
                            //  List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Japan'];
                            if(usr.size()>0){
                                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                            }
                            SYStem.debug('发邮件给 l');
                        }
                        else if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Union)' ||ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Non-Eu)'){
                        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'francesco.destales@jinkosolar.com'];
                        if(usr.size()>0){
                            approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                        }
                        SYStem.debug('发邮件给 欧洲l');
                    }
                        else {
                            List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal@jinkosolar.com'];
                            // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Public'];
                            if(usr.size()>0){
                                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));  
                            }
                            SYStem.debug('发邮件给 l');
                        }
                        List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
                        List<String> ApproverName = new List<String>(); 
                        List<Id> ApproverId = new List<Id>();
                        List<String> email = new List<String>();
                        for (Approver u : approverList ) {
                            
                            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                            email.add(u.uEmail);
                            system.debug('~~~~~~~~~~~>email:'+email);
                            ApproverId.add(u.uId);
                            ApproverName.add(u.uName);
                            system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					
                            
                        }
                        system.debug('~~~~~~~~>reviewList:' + reviewList);
                        for(ID userid : ApproverId){
                            SubmitForReview__c review = new SubmitForReview__c();
                            review.Amendment__c = ODLst[0].Amendment_Purchase_Agreement__c;
                            review.Status__c    = 'Pending';
                            review.User__c      = userid;
                            
                            reviewList.add(review);
                            
                            System.debug('~~~~~~~~~userid'+userid);
                            System.debug('~~~~~~~~~User__c'+review.User__c);
                        }
                        List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                                 Remarks__c,
                                                                 Role__c,
                                                                 Status__c,
                                                                 User__c
                                                                 from SubmitForReview__c
                                                                 where Amendment__c =: ODLst[0].Amendment_Purchase_Agreement__c
                                                                 AND User__c in: ApproverId];
                        system.debug('------>oldReviewList:' +  oldReviewList);
                        
                        if(oldReviewList.size()>0 && oldReviewList != null){
                            delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
                        }
                        
                        if(reviewList.size() > 0)insert reviewList;	
                        
                        SendAmendmentReviewMail(approverList,ODLst[0].Amendment_Purchase_Agreement__c);
}
                    
                    if(SendToLegal==false){
                        system.debug('不需用法务参与 '); 
if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                        if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                        system.debug('发送完成');
                    }
                }
            }
            if(fullReview.size()==5 && fullApprovedReview.size() ==5){
                system.debug('5'); 
                boolean LegalApproval=false;
                for(SubmitForReview__c sfr : fullReview){
                    
                    if(sfr.Role__c.indexof('Legal')>-1){
                        LegalApproval = true;
                    }
                }
                if(LegalApproval == true){
                    system.debug('不用法务  法务同意'); 
                    if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                    if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                    system.debug('发送完成');
                }
                if(LegalApproval == false){
                    Boolean SendToLegal = false; 
                    for(PaymentDifference__c PD:PDLst){
                        if(PD.Payment_Method_New__c!=PD.Payment_Method_Old__c || PD.Percentage_New__c!=PD.Percentage_Old__c ||
                           PD.Payment_Term_New__c	!=PD.Payment_Term_Old__c || PD.Down_Balance_Payment_New__c!=PD.Down_Balance_Payment_New__c ||
                           PD.Days_New__c	!=PD.Days_Old__c || DifferentAmend ==true
                           || Amend[0].Destination_Country__c=='Japan'){
                               SendToLegal = true;
                           }
                    }
                    if(SendToLegal==true){
                        if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='North Asia'&& ODLst[0].Amendment_Purchase_Agreement__r.Destination_Country__c=='Japan'){
                            List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal.japan@jinkosolar.com'];
                            // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Japan'];
                            if(usr.size()>0){
                                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                            }
                            SYStem.debug('发邮件给 l');
                        }
                        else if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Union)' ||ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Non-Eu)'){
                        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'francesco.destales@jinkosolar.com'];
                        if(usr.size()>0){
                            approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                        }
                        SYStem.debug('发邮件给 欧洲l');
                    }
                        else {
                            List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal@jinkosolar.com'];
                            // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Public'];
                            if(usr.size()>0){
                                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));  
                            }
                            SYStem.debug('发邮件给 l');
                        }
                        List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
                        List<String> ApproverName = new List<String>(); 
                        List<Id> ApproverId = new List<Id>();
                        List<String> email = new List<String>();
                        for (Approver u : approverList ) {
                            
                            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                            email.add(u.uEmail);
                            system.debug('~~~~~~~~~~~>email:'+email);
                            ApproverId.add(u.uId);
                            ApproverName.add(u.uName);
                            system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					
                            
                        }
                        system.debug('~~~~~~~~>reviewList:' + reviewList);
                        for(ID userid : ApproverId){
                            SubmitForReview__c review = new SubmitForReview__c();
                            review.Amendment__c = ODLst[0].Amendment_Purchase_Agreement__c;
                            review.Status__c    = 'Pending';
                            review.User__c      = userid;
                            
                            reviewList.add(review);
                            
                            System.debug('~~~~~~~~~userid'+userid);
                            System.debug('~~~~~~~~~User__c'+review.User__c);
                        }
                        List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                                 Remarks__c,
                                                                 Role__c,
                                                                 Status__c,
                                                                 User__c
                                                                 from SubmitForReview__c
                                                                 where Amendment__c =: ODLst[0].Amendment_Purchase_Agreement__c
                                                                 AND User__c in: ApproverId];
                        system.debug('------>oldReviewList:' +  oldReviewList);
                        
                        if(oldReviewList.size()>0 && oldReviewList != null){
                            delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
                        }
                        
                        if(reviewList.size() > 0)insert reviewList;	
                        
                        SendAmendmentReviewMail(approverList,ODLst[0].Amendment_Purchase_Agreement__c);
                    }
                    
                    if(SendToLegal==false){
                        system.debug('不需用法务参与 '); 
                        if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                        if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                        system.debug('发送完成');
                    }
                }
            }
            if(fullReview.size()==6 && fullApprovedReview.size() ==6){
                system.debug('5'); 
                boolean LegalApproval=false;
                for(SubmitForReview__c sfr : fullReview){
                    
                    if(sfr.Role__c.indexof('Legal')>-1){
                        LegalApproval = true;
                    }
                }
                if(LegalApproval == true){
                    system.debug('不用法务  法务同意'); 
                    if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                    if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                    system.debug('发送完成');
                }
                if(LegalApproval == false){
                    Boolean SendToLegal = false; 
                    for(PaymentDifference__c PD:PDLst){
                        if(PD.Payment_Method_New__c!=PD.Payment_Method_Old__c || PD.Percentage_New__c!=PD.Percentage_Old__c ||
                           PD.Payment_Term_New__c	!=PD.Payment_Term_Old__c || PD.Down_Balance_Payment_New__c!=PD.Down_Balance_Payment_New__c ||
                           PD.Days_New__c	!=PD.Days_Old__c || DifferentAmend ==true
                           || Amend[0].Destination_Country__c=='Japan'){
                               SendToLegal = true;
                           }
                    }
                    if(SendToLegal==true){
                        if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='North Asia' && ODLst[0].Amendment_Purchase_Agreement__r.Destination_Country__c=='Japan'){
                            List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal.japan@jinkosolar.com'];
                            // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Japan'];
                            if(usr.size()>0){
                                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                            }
                            SYStem.debug('发邮件给 l');
                        }
                        else if(ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Union)' ||ODLst[0].Amendment_Purchase_Agreement__r.Region__c=='EU(Non-Eu)'){
                        List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'francesco.destales@jinkosolar.com'];
                        if(usr.size()>0){
                            approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
                        }
                        SYStem.debug('发邮件给 欧洲l');
                    }
                        else {
                            List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Email =: 'legal@jinkosolar.com'];
                            // List<User> usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE name =: 'Legal Public'];
                            if(usr.size()>0){
                                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));  
                            }
                            SYStem.debug('发邮件给 l');
                        }
                        List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
                        List<String> ApproverName = new List<String>(); 
                        List<Id> ApproverId = new List<Id>();
                        List<String> email = new List<String>();
                        for (Approver u : approverList ) {
                            
                            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                            email.add(u.uEmail);
                            system.debug('~~~~~~~~~~~>email:'+email);
                            ApproverId.add(u.uId);
                            ApproverName.add(u.uName);
                            system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					
                            
                        }
                        system.debug('~~~~~~~~>reviewList:' + reviewList);
                        for(ID userid : ApproverId){
                            SubmitForReview__c review = new SubmitForReview__c();
                            review.Amendment__c = ODLst[0].Amendment_Purchase_Agreement__c;
                            review.Status__c    = 'Pending';
                            review.User__c      = userid;
                            
                            reviewList.add(review);
                            
                            System.debug('~~~~~~~~~userid'+userid);
                            System.debug('~~~~~~~~~User__c'+review.User__c);
                        }
                        List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                                 Remarks__c,
                                                                 Role__c,
                                                                 Status__c,
                                                                 User__c
                                                                 from SubmitForReview__c
                                                                 where Amendment__c =: ODLst[0].Amendment_Purchase_Agreement__c
                                                                 AND User__c in: ApproverId];
                        system.debug('------>oldReviewList:' +  oldReviewList);
                        
                        if(oldReviewList.size()>0 && oldReviewList != null){
                            delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
                        }
                        
                        if(reviewList.size() > 0)insert reviewList;	
                        
                        SendAmendmentReviewMail(approverList,ODLst[0].Amendment_Purchase_Agreement__c);
                    }
                    
                    if(SendToLegal==false){
                        system.debug('不需用法务参与 '); 
                        if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                        if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                        system.debug('发送完成');
                    }
                }
            }
            if(fullReview.size()==7 && fullApprovedReview.size() ==7){ 
                system.debug('7');
                if(Amend[0].Region__c!='North America'){
                    SendEmailUtils2.sendToSomeOneId(Amend[0].ID,amend[0].Contract_Owner__c,'AmendOrderPrint');
                    }
                if(Amend[0].Region__c=='EU(Union)' || Amend[0].Region__c=='EU(Non-Eu)'){
                       SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'005900000015ehi','AmendOrderPrint'); 
                        SendEmailUtils2.sendToSomeOneId(Amend[0].ID,'0056F000007bYU8','AmendOrderPrint'); 
                    }
                system.debug('7个同意发送完成');
            }
        }
    }
    
}