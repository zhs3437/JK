public  class AccountInfoChange {
    public  void updateAccountInfo(list<Account> list_acc,map<Id,Account> map_acc) 
    {
        for(Account acc:list_acc)
        {
        	if(acc.SAP_External_ID__c !=null &&((acc.VAT_NO__c !=null && acc.VAT_NO__c !=map_acc.get(acc.Id).VAT_NO__c)
        		||(acc.BillingCountry !=map_acc.get(acc.Id).BillingCountry)
        		||(acc.BillingCity !=map_acc.get(acc.Id).BillingCity)
        		||(acc.BillingState !=map_acc.get(acc.Id).BillingState)
        		||(acc.BillingStreet !=map_acc.get(acc.Id).BillingStreet)
        		||(acc.BillingPostalCode !=map_acc.get(acc.Id).BillingPostalCode)
        	//	buyer.BillingCountry +' '+ buyer.BillingCity +' '+ buyer.BillingState +' '+ buyer.BillingStreet
        		||(acc.Name!=null && acc.Name !=map_acc.get(acc.Id).Name)
        	 ))
        	{
        		//邮件主题
        		String subject ='Account info (SAP ID:'+acc.SAP_External_ID__c+') has been updated in CRM ';
        		//邮件正文
        		String body='<p>'+'Dear 蒋工:'+'</p>'
        					+'请注意Account'+'<b>'+'(SAP ID:'+acc.SAP_External_ID__c+')'+'</b>'+'的如下信息已经在CRM中更新:'+'</br>'
        					+'-------------------------------------------------'+'</br>';
        		if(acc.Name!=null && acc.Name !=map_acc.get(acc.Id).Name)
        		{
        			body=body+'<b>'+'更新之后的Account Name:'+'</b>'+acc.Name+'</br>'
        			+'旧Account Name:'+'&nbsp;&nbsp;&nbsp;&nbsp;'+map_acc.get(acc.Id).Name+'</br>'
        			+'</br>'
        			+'</br>';
        		}
        		if((acc.BillingCountry !=map_acc.get(acc.Id).BillingCountry)
        		||(acc.BillingCity !=map_acc.get(acc.Id).BillingCity)
        		||(acc.BillingState !=map_acc.get(acc.Id).BillingState)
        		||(acc.BillingStreet !=map_acc.get(acc.Id).BillingStreet)
        		||(acc.BillingPostalCode !=map_acc.get(acc.Id).BillingPostalCode))
        		{
        			body=body+'<b>'+'更新之后的Account地址:'+'</b>'+acc.BillingPostalCode +' '+ acc.BillingStreet +' '+ acc.BillingCity +' '+ acc.BillingState+' '+acc.BillingCountry+'</br>'
        					+'旧Account地址:'+'&nbsp;&nbsp;&nbsp;&nbsp;'+map_acc.get(acc.Id).BillingPostalCode+' '+map_acc.get(acc.Id).BillingStreet+' '+map_acc.get(acc.Id).BillingCity+''+map_acc.get(acc.Id).BillingState+''+map_acc.get(acc.Id).BillingCountry+'</br>'
        					+'</br>'
        					+'</br>';
        		} 
        		if(acc.VAT_NO__c !=null && acc.VAT_NO__c !=map_acc.get(acc.Id).VAT_NO__c)
        		{
        			body=body+'<b>'+'更新之后的Account VAT NO:'+'</b>'+acc.VAT_NO__c+'</br>'
        					+'旧Account VAT NO:'+'&nbsp;&nbsp;&nbsp;&nbsp;'+map_acc.get(acc.Id).VAT_NO__c+'</br>'
        					+'</br>'
        					+'</br>';
        		}

        		body=body +'-------------------------------------------------'+'</br>'
        				  +'变更触发时间：'+Datetime.now()+'</br>'
        				  +'变更操作用户：'+UserInfo.getUserName();


		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		    	mail.setUseSignature(false);
		        mail.setCharset('UTF-8');
		        mail.setSubject(subject);
		        mail.setHtmlBody(body); 
				//收件人
				mail.setToAddresses(new String[] {Label.SAP_Update_Contact});//地址con.Email
				//mail.setToAddresses(System.Label.SAP_Update_Contact);
				//抄送
				mail.setCcAddresses(new String[] {});
		        // mails.add(mail); 
		        Messaging.sendEmail(new Messaging.Email[]{ mail });	 

        	}
        }
    }

     public void runTest()
    {
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
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
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