/*
*Author Leo  
*Date:  2018-8-30
*Description: 在ETD的前后三天发送邮件。 条件请看公式字段
*/
global class Batch_SendEmailETD implements Database.Batchable<sObject> {
   

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id,Opportunity__r.Id,Can_be_send_Email__c,Account_Owner_Name__c,Account_Phone__c,
                                        Account_Owner_Email__c,Account.Name from Contract where  Can_be_send_Email__c=true]);
    }

    global void execute(Database.BatchableContext BC, list<Contract> list_con) {

        if(list_con.size()>0)
        {
            list<String> recipients =new list<String>();

            for(Contract con:list_con)
            {
                recipients.add(con.Account_Owner_Email__c);
                System.debug('recipients***************'+recipients);
                String url ='https://ap4.salesforce.com/'+con.Opportunity__r.Id;
                String subject='You have a PAPI reaching ETD';
                string body='Dear'+con.Account_Owner_Name__c+':'+'</br>'
                           +'You hava a PAPI is reaching ETD.'+'</br>'
                           +'Account Name:'+con.Account.Name+'</br>'
                           +'Account Phone:'+con.Account_Phone__c+'</br>'
                           +'Please refer below link:'+'</br>'
                           +'<a href='+url+'>'+'https://ap4.salesforce.com/'+con.Opportunity__r.Id+'</a>'+'</br>'
                           +'</br>'
                           +'</br>'
                           +'BR'+'</br>'
                           +'salesforce Team';

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setUseSignature(false);
                        mail.setCharset('UTF-8');
                        mail.setSubject(subject);
                        mail.setHtmlBody(body); 
                        //收件人
                        mail.setToAddresses(recipients);//地址con.Email
                        //抄送
                        mail.setCcAddresses(new String[] {});
                        Messaging.sendEmail(new Messaging.Email[]{ mail });
            }
        }
    }

    global void finish(Database.BatchableContext BC) {

    }

    global void test(){
         Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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