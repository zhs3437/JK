trigger DuplicationCheckOnAccount on Account (before insert) {
    //try{
        
            for(Account acc: trigger.new ){
                
                
                List<Account> listDeplication = [select a.id, a.Owner.Name , a.Website,a.Company_Email__c,a.Name,a.AccountName2__c from Account a 
                where (a.Company_Email__c =: acc.Company_Email__c or a.Name =: acc.Name or a.Website =:acc.Website)
                and a.id !=: acc.id];
                
                system.debug('@@@@@@@@@@@' + acc.Id);
                system.debug('@@@@@@@@@' + acc.Company_Email__c);
                 User u1 = [select u.id, u.Email ,u.Title from User u where u.Title = 'CRM Administrator'];
                 system.debug('^^^^^^^^^^^^^^^^^' + u1);
                
                if( listDeplication.size()>0 ){
                    Account accold = listDeplication[0];
                    system.debug('@@@@@@@@@' + accold.Company_Email__c);
                    system.debug('@@@@@@@@@' + accold.id + accold.Name);
                    system.debug('^^^^^^^^' + acc.id + acc.Name);
                    //如果公司名称，或公司邮箱及公司网址任何一条相同，不给予用户保存。
                    if((acc.Company_Email__c == accold.Company_Email__c || acc.Name == accold.Name ||
                    (acc.Website == accold.Website && acc.Website != null))&& acc.id != accold.id && u1.id != '00590000000Lgv1'){
                        
                        //需要发送邮件通知到财务助理Steven&Cathy让他们去判断
                        //List<String> recepients=new String[]{ 'weihongbin168@hotmail.com' };
                        User u = [select u.id, u.Email from User u where u.name = 'Steven Hu'];
                        
                        EmailTemplate mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName = 'Duplicate_Email'];
                        
                        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
                        
                        
                        mail.setWhatId( accold.id );
                        mail.setSaveAsActivity( false );
                        mail.setTargetObjectId(u.id);
                        mail.setTemplateId( mailTemplate.Id );
                        
                        //mail.setToAddresses( recepients );
                        mail.setUseSignature(false);
                        mail.setBccSender(false);
                        mail.setSaveAsActivity(false);
                        
                        System.debug('--------------> Send To : ' + u.Email );
                        
                        Messaging.SendEmailResult[] mailMsg = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        System.debug('--------------> Send Result : ' + mailMsg[0].isSuccess() );
                        
                        
                        acc.Duplicated__c = true;
                        acc.DuplicatedMessage__c = 'this record is duplicated with Account '+ accold.Name +' ['+accold.Id+'], Old Account Owner is : ' +accold.Owner.Name;
                        
                        //报错信息：
                        //acc.addError( 'you can not save this account, because the account is existing, if you have any problem please Contact Global Account manager: Steven Hu' );
                        
                    }
                }
        
            }
        
    
    //}catch(Exception e){
        
    //}
}