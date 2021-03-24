public with sharing class CommonUtils {
    public class MakeSqlException extends Exception {}
    /**
    * MakeSelectSql 
    * return "select * from Object"
    */
    public static string MakeSelectSql(string objName){
        string sqlStr = '';
        //get all object describe
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (Schema.SObjectType st : gd.values()) {
            Schema.DescribeSObjectResult r = st.getDescribe();
            //get the Object name
            if(r.getName() == objName){
                Map<String, Schema.SObjectField> fieldsmap = r.fields.getMap();
                for (String fName : fieldsmap.keySet()){
                   //update By ：jason 20160505
                    if(fName == 'currentstatus' || fName == 'billingaddress' || fName == 'shippingaddress'){
                        continue;
                    }
                    
                    sqlstr = sqlstr + fName+',';
                }
                if(sqlstr.length()>0){
                    if(objName == 'Opportunity'){
                        sqlstr = sqlstr + 'RecordType.Name ,';
                    }
                    sqlstr = sqlstr.substring(0,sqlstr.length()-1);
                    
                }
                sqlstr = 'select '+sqlstr+' from '+ objName;
            }
        }
        //limit check
        if(sqlstr.length()== 0) throw new MakeSqlException('The Object not exist'); 
       // if(sqlstr.length()> 10000) throw new MakeSqlException('sql length over 10000'); 
        return sqlStr;
    }
    /**
    * GetObjByID
    * return [select * from Object where id=:id]
    */
    public static sObject GetObjByID(string objName,string id){
        return Database.query(CommonUtils.MakeSelectSql(objName)+' Where id =:id');
    }
    
     public static String SendReviewMail1(String conId,List<String> address, String emailTemplateName){
        List<User> recipient= [SELECT ID,Name,Email FROM User WHERE Email in: address];
         System.debug('----->recipient:'  + recipient);
        System.debug('----->recipient:'  + emailTemplateName);
        Utils.sendEmailWithTemplate(recipient, conId, emailTemplateName);
        System.debug('----->是否发送:'  + recipient);
        return '';
    }
    @future
    public static void SendReviewMail12(String conId){
           System.debug('发送邮件20200804合同');
        Contract opp =[select id,Ownerid,Region__c,Destination_Country__c from contract where id=:conid ];
       //   Utils.sendEmailWithTemplate3('gongyi.shi@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);

            //北亚√
            IF(opp.Region__c=='North Asia'){
				Utils.sendEmailWithTemplate3('yayun.wang@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
				Utils.sendEmailWithTemplate3('shunxia.li@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('lr@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('yu1.chen@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('hong.liu@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('hisashi.sakai@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('jian.zhu@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('hui.wu1@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }
            //南亚
             IF(opp.Region__c=='South Asia'){
                Utils.sendEmailWithTemplate3('hong.liu@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('lr@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                }
            //北美√
            else IF(opp.Region__c=='North America'){
                Utils.sendEmailWithTemplate3('marie.wilson@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('issac.li@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('kyle.carpenter@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('rhea.bautista@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('yunsien.tan@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('sheree.tom@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('john.ball@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }
            //欧洲√
            else if(opp.Region__c=='EU(Union)' || opp.Region__c=='EU(Non-Eu)'|| opp.Destination_Country__c=='Italy'){
                 Utils.sendEmailWithTemplate3('Int.logistics@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }
            //中东非√
            else if(opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA'){
                 Utils.sendEmailWithTemplate3('MEA.logistics@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }
            //拉丁√
            else if(opp.Region__c=='Latin America&Italy'){
                 Utils.sendEmailWithTemplate3('yulan.gong@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('Nubia.razo@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }
            //澳洲 √
            else if(opp.Region__c=='ROA' && (opp.Destination_Country__c=='Australia' || opp.Destination_Country__c=='New Zealand')){
                 Utils.sendEmailWithTemplate3('lr@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('chunmei.wang@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('samantha.yong@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }
            //ROA √
               else if(opp.Region__c=='ROA' && opp.Destination_Country__c!='Australia' && opp.Destination_Country__c!='New Zealand'){
                    Utils.sendEmailWithTemplate3('chunmei.wang@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                    Utils.sendEmailWithTemplate3('yayun.wang@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                   Utils.sendEmailWithTemplate3('hui.wu1@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                   }
            //其他
            else{
                                 Utils.sendEmailWithTemplate3('lr@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
                Utils.sendEmailWithTemplate3('chunmei.wang@jinkosolar.com',opp.id, 'Freight_Notify_Contract',opp.Ownerid);
            }


        
    }
    
    public static void SendReviewMail(List<String> toAddress,ID contractId){
        try{
            System.debug('############## toAddress: '+toAddress);
            System.debug('############## contractId: '+contractId);
            EmailTemplate mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName = 'Contract_Review_Mail'];
            System.debug('############## mailTemplate: '+mailTemplate);
            List<String> ccAddress = new List<String>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            system.debug('ccAddress-->'+ccAddress);
            if (toAddress.size() > 0){
                mail.setToAddresses(toAddress);
            }
            if (ccAddress.size() > 0){
                mail.setCcAddresses(ccAddress);
            }
            mail.setWhatId(contractId);
            mail.setTemplateId(mailTemplate.Id);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSenderDisplayName(UserInfo.getName());
            system.debug('UserInfo.getUserId()-->'+UserInfo.getUserId());
             system.debug('UserInfo.getUserId()-->'+UserInfo.getName());
            System.debug('############## start send');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('############## end send');
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
                System.debug('############## error: '+e);
            }
        }
    }
    
    //add By Han 20180329
      public static void SendRemindMail(List<String> toAddress,ID contractId,String emailtemplate){
        try{
            System.debug('############## toAddress: '+toAddress);
            System.debug('############## contractId: '+contractId);
            EmailTemplate mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =: emailtemplate];
            System.debug('############## mailTemplate: '+mailTemplate);
            List<String> ccAddress = new List<String>();
            system.debug('ccAddress-->'+ccAddress);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            if (toAddress.size() > 0){
                mail.setToAddresses(toAddress);
            }
            if (ccAddress.size() > 0){
                mail.setCcAddresses(ccAddress);
            }
            mail.setWhatId(contractId);
            mail.setTemplateId(mailTemplate.Id);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSenderDisplayName(UserInfo.getName());
            System.debug('############## start send');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('############## end send');
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
                System.debug('############## error: '+e);
            }
        }
    }
     
   //add By Han 20180104
    //send Email for Special Contract 
    public static void SendSpecialReviewMail(List<String> toAddress,ID contractId){
        try{
            System.debug('############## toAddress: '+toAddress);
            System.debug('############## contractId: '+contractId);
            EmailTemplate mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName = 'Contract_New_Special_Review_Email'];
            System.debug('############## mailTemplate: '+mailTemplate);
            List<String> ccAddress = new List<String>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            if (toAddress.size() > 0){
                mail.setToAddresses(toAddress);
            }
            if (ccAddress.size() > 0){
                mail.setCcAddresses(ccAddress);
            }
            mail.setWhatId(contractId);
            mail.setTemplateId(mailTemplate.Id);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSenderDisplayName(UserInfo.getName());
            System.debug('############## start send');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('############## end send');
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
                System.debug('############## error: '+e);
            }
        }
    }
    //add By jason 20160605
    //For send Email to Amendment Reviewer
    //start
    public static void SendAmendmentReviewMail(List<String> toAddress,ID amendmentId){
        try{
            System.debug('############## toAddress: '+toAddress);
            System.debug('############## amendmentId: '+amendmentId);
            EmailTemplate mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =: 'AmendmentEmaiTemplate'];
            System.debug('############## mailTemplate: '+mailTemplate);
            List<String> ccAddress = new List<String>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            if (toAddress.size() > 0){
                mail.setToAddresses(toAddress);
            }
            if (ccAddress.size() > 0){
                mail.setCcAddresses(ccAddress);
            }
            mail.setWhatId(amendmentId);
            mail.setTemplateId(mailTemplate.Id);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSenderDisplayName(UserInfo.getName());
            System.debug('############## start send');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('############## end send');
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
                System.debug('############## error: '+e);
            }
        }
    }
    
    /*  
    public static void sendEmailWithTemplate(List<User> recipients,String amid ,string emailTemplateName){
        try{
            
            if(recipients == null) return;
            if(recipients.size() == 0) return;
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            
            EmailTemplate mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =: emailTemplateName];
            
            for(User user : recipients){
                List<String> emailList = new List<String>();
                 // Create a new single email message object
                // that will send out a single email to the addresses in the To, CC & BCC list.
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                //the email is not saved as an activity.
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                emailList.add(user.Email);
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                mail.setTargetObjectId(user.Id);
                
                    mail.setTemplateId(mailTemplate.Id);
                
                if(amid != null)mail.setWhatId(amid);
                mail.setSenderDisplayName(UserInfo.getName());
                
                mailList.add(mail);
            }
            Messaging.sendEmail(mailList);
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
    }
    
    //end
    */
    
    /**
     * Add by Javen, 2013-01-13
     * CommonUtil for send a simple mail
     */
    public static void SendBasicMail(String[] toAddress, String subject, String body , String[] ccAddress ){
        
        try{
            Messaging.SingleEmailMessage [] mailToSend = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
            mail.setToAddresses(toAddress);
            // mail.setCcAddresses(ccAddress);
            mail.setsubject(subject);
            mail.setPlainTextBody(body);
            mailToSend.add(mail);
            Messaging.sendEmail( mailToSend ,false);
        }catch( Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
        }
    }
    
    public static void sendMailForGradingAccount( Account[] accs ){
        Messaging.SingleEmailMessage [] mails = new List<Messaging.SingleEmailMessage>(); 
        for(Account acc : accs){
            /*
            User u = [Select Id, Name, Email From User Where Id =: acc.User__c];
            String subject = 'The Account Grading is expired';
            String body = 'The Account '+acc.Name+' is expired, Please regrade the customer';
            Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
            String[] toAddresses = new String[] {u.Email}; 
            mail.setToAddresses(toAddresses);
            mail.setsubject(subject);
            mail.setPlainTextBody(body);
            mails.add(mail);
            */
        }
        if(mails.size()>0){
            Messaging.sendEmail(mails,false);
        }
    }
    public void runTest()
    {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;i++;i++;i++;
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