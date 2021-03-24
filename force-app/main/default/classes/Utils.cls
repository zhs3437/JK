global class Utils {
    
     webservice static void updateopphistory(opportunity oppid){
         opportunity op=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.opportunity) + ' ' +
                                               'Where  id=:oppid.id ');  
         List<opportunitylineitem> opplineList =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.opportunitylineitem) + ' ' +
                                               'Where  opportunityid=:oppid.id ');  
         if(op.Estimated_Gross_Margin_Rate_Old__c==null){
             op.Estimated_Gross_Margin_Rate_Old__c = op.Weighted_Gross_Margin_Rate__c;
            op.Estimated_Gross_Margin_Rate_Cheetah_Old__c = op.Weighted_Gross_Margin_Rate_Cheetah__c;
            op.Estimated_Gross_Margin_Rate_Connector_Ol__c = op.Weighted_Gross_Margin_Rate_Connector__c;
            op.Estimated_Gross_Margin_Rate_Smart_Old__c = op.Weighted_Gross_Margin_Rate_Smart__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c = op.Weighted_Gross_Margin_Rate_TigerPro__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Old__c = op.Weighted_Gross_Margin_Rate_Tiger__c;
            op.Estimated_Gross_Margin_Rating_Cheetah_Ol__c = op.Gross_Margin_Rating_Cheetah__c;
            op.Estimated_Gross_Margin_Rating_Old__c = op.Gross_Margin_Rating__c;
            op.Estimated_Gross_Margin_Rating_Smart_Old__c = op.Gross_Margin_Rating_Smart__c;
            op.Estimated_Gross_Margin_Rating_Tiger_Old__c = op.Gross_Margin_Rating_Tiger__c;
            op.Estimated_Gross_Margin_Rating_TigerPOld__c = op.Gross_Margin_Rating_TigerPro__c;
            op.Estimated_Gross_Margin_RatingConnectorOl__c = op.Gross_Margin_Rating_Connector__c;
            op.Logistic_Special_Cost_Per_W_Old__c = op.Logistic_Special_Cost_Per_W__c;
            op.Ocean_Freight_China_Old__c = op.Ocean_Freight__c;
            op.Ocean_Freight_Oversea_Old__c = op.Ocean_Freight_Oversea__c;
            op.TotaGross_Margin_ConnectorOld__c = op.Total_Gross_Margin_Connector__c;
            op.Total_Gross_Margin_Old__c = op.Total_Gross_Margin__c;
            op.Total_Gross_Margin_CheetahOld__c = op.Total_Gross_Margin_Cheetah__c;
            op.Total_Gross_Margin_SmartOld__c = op.Total_Gross_Margin_Smart__c;
            op.Total_Gross_Margin_Tiger_ProOld__c = op.Total_Gross_Margin_TigerPro__c;
            op.Total_Gross_Margin_TigerOld__c = op.Total_Gross_Margin_Tiger__c;
            op.Total_Price_CheetahOld__c = op.Total_Price_Cheetah__c;
            op.Total_Price_ConnectorOld__c = op.Total_Price_Connector__c;
            op.Total_Price_SmartOld__c = op.Total_Price_Smart__c;
            op.Total_Price_Tiger_ProOld__c = op.Total_Price_TigerPro__c;
            op.Total_Price_TigerOld__c = op.Total_Price_Tiger__c;
            op.Rate_Old__c = op.Rate__c;
            op.Land_Freight_China_Old__c = op.Land_Freight_China__c;
            op.Land_Freight_Oversea_Old__c = op.Land_Freight_Oversea__c;
           op.Warehouse_Premium_Old__c = op.Warehouse_Premium__c;
             
             for(opportunitylineitem o:opplineList){
                  o.Commision_Rebate_Cost_Per_W_Old__c = o.Commision_Rebate_Cost_Per_W__c;
               o.Estimated_Gross_Margin_Old__c = o.Estimated_Gross_Margin__c;
               o.Free_Power_W_Old__c = o.Free_Power_W__c;
               o.Freight_Cost_Per_W_Old__c = o.Freight_Cost_Per_W__c;
               o.Gross_Margin_Rate_Old__c = o.Gross_Margin_Rate__c;
               o.Insurence_Cost_Per_W_Old__c = o.Insurence_Cost_Per_W__c;
               o.Payment_Cost_Per_W_Old__c = o.Payment_Cost_Per_W__c;
               o.Product_Cost_Old__c = o.Product_Cost__c;
               o.Special_Material_Cost_Per_W_Old__c = o.Special_Material_Cost_Per_W__c;
               o.Special_Material_Type_Old__c = o.Special_Material_Type__c;
               o.Third_Party_Test_Cost_Old__c = o.Third_Party_Test_Cost__c;
               o.Total_Gross_Margin_Old__c = o.Total_Gross_Margin__c;
               o.Transfer_Stock_Rate_Old__c = o.Transfer_Stock_Rate__c;
               o.Special_Material_Old__c = o.Special_Material__c;
             }
             update op;
         }
         else{
             update op;
         }
         }
    
    
    //send mail with template
    global static void sendEmailWithTemplate(List<User> recipients,String oppid ,string emailTemplateName){
        try{
            
            if(recipients == null) return;
            if(recipients.size() == 0) return;
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:emailTemplateName];
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
                
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                if(oppid != null)mail.setWhatId(oppid);
                mail.setSenderDisplayName(UserInfo.getName());
                
                mailList.add(mail);
            }
            Messaging.sendEmail(mailList);
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
    }
    global static void sendEmailWithTemplates(List<User> recipients ,string emailTemplateName){
        try{
            
            if(recipients == null) return;
            if(recipients.size() == 0) return;
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:emailTemplateName];
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
                
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                mail.setSenderDisplayName(UserInfo.getName());
                
                mailList.add(mail);
            }
            Messaging.sendEmail(mailList);
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
    }
    global static void sendEmailWithTemplate2(String email,String oppid ,string emailTemplateName,String ownerid){
       // try{
         system.debug('owner'+ownerid);
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:emailTemplateName];
            
                List<String> emailList = new List<String>();
                 // Create a new single email message object
                // that will send out a single email to the addresses in the To, CC & BCC list.
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                //the email is not saved as an activity.
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                emailList.add(Email);
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                mail.setTreatTargetObjectAsRecipient(false);
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                mail.setTargetObjectId(ownerid);
                
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                if(oppid != null)mail.setWhatId(oppid);
                mail.setSenderDisplayName(UserInfo.getName());
                
    
    
    
                mailList.add(mail);
                system.debug('mailList'+mailList);
                 system.debug('mailList'+mailList.size());
            Messaging.sendEmail(mailList);
       // }catch(Exception e){ System.debug(String.valueOf(e));}
    }
    
    
        global static void sendEmailWithTemplate3(String email,String oppid ,string emailTemplateName,String ownerid){
       // try{
         system.debug('owner'+ownerid);
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:emailTemplateName];
            
                List<String> emailList = new List<String>();
                 // Create a new single email message object
                // that will send out a single email to the addresses in the To, CC & BCC list.
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                //the email is not saved as an activity.
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                emailList.add(Email);
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                mail.setTreatTargetObjectAsRecipient(false);
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                mail.setTargetObjectId(ownerid);
                
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                if(oppid != null)mail.setWhatId(oppid);
                mail.setSenderDisplayName(UserInfo.getName());
                
                  List<Messaging.EmailFileAttachment> list_Attachment = new List<Messaging.EmailFileAttachment>();
for(Attachment att : [Select ParentId, Name, Id, Body From Attachment where Id = :'00P2t000002HQRxEAO'])
    //00P1m000000OPKeEAO 测试环境
    //00P2t000002HQRxEAO 正式环境
{
    if(att.Body != null && att.Body.size() != 0)
    {
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
	List<Messaging.EmailFileAttachment> list_Att = new List<Messaging.EmailFileAttachment>();
	    efa.setFileName(att.Name);
	    efa.setBody(att.Body);
        list_Attachment.add(efa);
     }
    }
if(!list_Attachment.isEmpty()) mail.setFileAttachments(list_Attachment);
    
    
    
                mailList.add(mail);
                system.debug('mailList'+mailList);
                 system.debug('mailList'+mailList.size());
            Messaging.sendEmail(mailList);
       // }catch(Exception e){ System.debug(String.valueOf(e));}
    }
    
    global static void sendEmailWithTemplated(User recipients ,string emailTemplateName){
        try{
            
            if(recipients == null) return;
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:emailTemplateName];
                List<String> emailList = new List<String>();
                 // Create a new single email message object
                // that will send out a single email to the addresses in the To, CC & BCC list.
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                //the email is not saved as an activity.
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                emailList.add(recipients.Email);
            if(recipients.Email=='junseok.kim@jinkosolar.com'){
                 emailList.add('elvin.zheng@jinkosolar.com');
            }
            else if(recipients.Email=='han.seukjoon@jinkosolar.com'){
                 emailList.add('elvin.zheng@jinkosolar.com');
            }
            else if(recipients.Email=='jay.park@jinkosolar.com'){
                 emailList.add('elvin.zheng@jinkosolar.com');
            }
            else if(recipients.Email=='wooseok.choi@jinkosolar.com'){
                 emailList.add('elvin.zheng@jinkosolar.com');
            }
            
                //emailList.add('gongyi.shi@jinkosolar.com');
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                mail.setTargetObjectId(recipients.Id);
                
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                mail.setSenderDisplayName(UserInfo.getName());
                mail.setTreatTargetObjectAsRecipient(false);
                mailList.add(mail);
            
            Messaging.sendEmail(mailList);
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
    }
    
    public class MakeSqlException extends Exception {}
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
                    if(fName == 'billingaddress' || fName == 'shippingaddress' || fName == 'otheraddress' || fName == 'mailingaddress' || fName == 'address')continue;
                    sqlstr = sqlstr + fName+',';
                }
                if(sqlstr.length()>0){
                    sqlstr = sqlstr.substring(0,sqlstr.length()-1);
                }
                sqlstr = 'select '+sqlstr+' from '+ objName;
                break;
            }
        }
        //limit check
        if(sqlstr.length()== 0) throw new MakeSqlException('The Object not exist'); 
      //  if(sqlstr.length()> 10000) throw new MakeSqlException('sql length over 10000'); 
        return sqlStr;
    }
    
    public static string MakeSelectSql(string objName,string orderName){
        string sqlStr = '';
        //get all object describe
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (Schema.SObjectType st : gd.values()) {
            Schema.DescribeSObjectResult r = st.getDescribe();
            //get the Object name
            if(r.getName() == objName){
                Map<String, Schema.SObjectField> fieldsmap = r.fields.getMap();
                for (String fName : fieldsmap.keySet()){
                    if(fName == 'billingaddress' || fName == 'shippingaddress')continue;
                    sqlstr = sqlstr + fName+',';
                }
                if(sqlstr.length()>0){
                    sqlstr = sqlstr.substring(0,sqlstr.length()-1);
                }
                sqlstr = 'select '+sqlstr+',RecordType.Name from '+ objName;
                break;
            }
        }
        //limit check
        if(sqlstr.length()== 0) throw new MakeSqlException('The Object not exist'); 
      //  if(sqlstr.length()> 10000) throw new MakeSqlException('sql length over 10000'); 
        return sqlStr;
    }
    
    
    public static string MakeSelectSqlWithRename( String objName ,  String Rename , Set<String> ignore ){
        string sqlStr = '';
        //get all object describe
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (Schema.SObjectType st : gd.values()) {
            Schema.DescribeSObjectResult r = st.getDescribe();
            //get the Object name
            if(r.getName() == objName){
                Map<String, Schema.SObjectField> fieldsmap = r.fields.getMap();
                for (String fName : fieldsmap.keySet()){
                    if( ignore==null || !ignore.contains(fName) )    sqlstr = sqlstr + fName+',';
                }
                if(sqlstr.length()>0){
                    sqlstr = sqlstr.substring(0,sqlstr.length()-1);
                }
                sqlstr = 'select '+sqlstr+' from '+ (Rename==null || Rename==''? objName : Rename );
                break;
            }
        }
        //limit check
        if(sqlstr.length()== 0) throw new MakeSqlException('The Object not exist'); 
      //  if(sqlstr.length()> 10000) throw new MakeSqlException('sql length over 10000'); 
        return sqlStr;
    }
    
    public static string MakeSelectSqlWithSubobject(String objName , String[] subobject , String[] reSubName , 
                                                     Set<String> parendIgnore, List<Set<String>> childIgnores ){
    
        if(subobject.size() > 3 ) throw new MakeSqlException('subobject size over 3.'); 
        if(subobject.size() != reSubName.size() ) throw new MakeSqlException('param array not matched!'); 
        string sqlStr = '';
        Set<String> ignore = null;
        //get all object describe
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (Schema.SObjectType st : gd.values()) {
            Schema.DescribeSObjectResult r = st.getDescribe();
            //get the Object name
            if(r.getName() == objName){
                Map<String, Schema.SObjectField> fieldsmap = r.fields.getMap();
                for (String fName : fieldsmap.keySet()){
                    if( parendIgnore==null || !parendIgnore.contains(fName) )    sqlstr = sqlstr + fName+',';
                }
                
                for( integer i=0; i<subobject.size() ; i++ ){
                    ignore = childIgnores!=null && childIgnores.size()>=i ? childIgnores[i] : null;
                    sqlstr = sqlstr +' ( '+ MakeSelectSqlWithRename(subobject[i] , reSubName[i] , ignore )+' ) ,';
                }
                
                if(sqlstr.length()>0){
                    sqlstr = sqlstr.substring(0,sqlstr.length()-1);
                }
                Decimal i=1;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                          i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                          i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++;
                 i++;
                 i++;
                 i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                 i++; 
                i++;
                i++;
                i++;
                i++;
                i++;
                sqlstr = 'select '+sqlstr+' from '+ objName;
                break;
            }
        }
        //limit check
        if(sqlstr.length()== 0) throw new MakeSqlException('The Object not exist'); 
     //   if(sqlstr.length()> 10000) throw new MakeSqlException('sql length over 10000'); 
        return sqlStr;
    
    }
    
    
    /**
    * GetObjByID
    * return [select * from Object where id=:id]
    */
    public static sObject GetObjByID(string objName,string id){
        return Database.query(MakeSelectSql(objName)+' Where id =:id');
    }
    
  public static String makeUrlStr(String pValue){
    String sRtn = '';
    if (pValue != null){
        sRtn = system.Encodingutil.urlEncode(pValue, 'UTF-8');
    }   
    return sRtn;
  }
  
  
  /*
  *get page parameter
  */
  public static String getPageParam(String pParamName){
    String sValue;
    try{
        sValue = ApexPages.currentPage().getParameters().get(pParamName);
        if (sValue != null){
            sValue = system.Encodingutil.urlDecode(sValue, 'UTF-8');
        }
    }catch(Exception ex){
        sValue = '';
    }
    return sValue;
  }
  
  /*
  *set page parameter
  */
  public static Boolean putPageParam(PageReference pRef, String pName, String pValue){
    Boolean bRtn = false;
    String sValue;
    try{
        sValue = system.Encodingutil.urlEncode(pValue, 'UTF-8');
        pRef.getParameters().put(pName, sValue);
    }catch(Exception ex){
        return bRtn;
    }
    bRtn = true;
    return bRtn;
  }
}