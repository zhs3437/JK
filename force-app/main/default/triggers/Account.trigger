trigger Account on Account(after insert,after update,before insert,before update) {
    GlobalSetting__c gsflag = GlobalSetting__c.getOrgDefaults();
    System.debug('gsflag.Account_Flag__c---->@@@'+gsflag.Account_Flag__c);
    if(gsflag.Account_Flag__c){
	if(trigger.isAfter)
	{
		if(trigger.isUpdate)
		{
			AccountInfoChange aic=new AccountInfoChange();
			aic.updateAccountInfo(trigger.new, trigger.oldMap);
            String oldSAPID;
            String newsapID;
            String accountID;
            for(Account accold : trigger.old){
                oldSAPID=accold.SAP_External_ID__c;
              system.debug('old:'+oldSAPID);
                accountID=accold.id;
            }
             for(Account accNew : trigger.new){
                newsapID=accNew.SAP_External_ID__c;
                 system.debug('new:'+newsapID);
            }
              List<contract> conlst=new List<contract>();
            if((oldSAPID=='' || oldSAPID==null)&& newsapID!=null){
                conlst =  Database.query( Utils.MakeSelectSql('Contract')+' WHERE BuyerAccount__c =: accountID'); 
            }
            if(conlst.size()>0){
                for(contract c:conlst){
                       SapSync_Opportunity.getOpportunityInfo(c.Opportunity__c);
                SyncContract.clickUpdate(c.id);
                SyncContract.tocontract(c.Opportunity__c,c.Contract_NO__c);
                }
            }
		}
	}
    if(trigger.isBefore){
        for(Account accNew : trigger.new){
            if(accNew.business_License__c !=null){
            /*    System.debug('进入');
              Blob blob1 = Blob.valueOf(accNew.business_License__c);
                Attachment quoAttach= new Attachment(
                parentId = accNew.id,
                name = 'business License' ,
                ContentType ='PNG/JPG',
                body = blob1
            );
                System.debug('完成');
                
			insert quoAttach;    */
                //accNew.business_License_Work__c=accNew.business_License__c.replace('&amp;','&');
                String firstSubString = accNew.business_License__c.substringBetween('<img', 'img>');
        	System.debug('First substring: ' + firstSubString);
                if(firstSubString!=null){
        	String secondSubString = firstSubString.substringBetween('src="', '"');
			System.debug('Second substring: ' + secondSubString);      
			String link = secondSubString.replace('amp;', '');
			System.debug('Link: ' + link);
			accNew.business_License_Work__c = link;
                }
            }
           
        }
        
    }
    
    }
}