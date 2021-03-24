trigger TriggerAccountApproval on Account (after insert , after update) {
    try{
        GlobalSetting__c gsflag = GlobalSetting__c.getOrgDefaults();
    System.debug('gsflag.Account_Flag__c---->@@@'+gsflag.Account_Flag__c);
    if(gsflag.Account_Flag__c){
        if(Trigger.isInsert){
            for ( Account account : trigger.new) {
                String Account_Contry = account.Country__c;
                // when consist country, so submit approval
                User user = [SELECT u.Country_Range__c FROM USER u WHERE u.Id=:UserInfo.getUserId()];
                
                // When Account' Contry is not User' Contry, and Country_Range not null
                if(user.Country_Range__c!=null && !user.Country_Range__c.contains(account.Country__c) ){
                    // Auto Submit Approval
                    Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                    psr.setObjectId(account.id);
                    Approval.ProcessResult result = Approval.process( psr );
                }
            } // end for new
        }
        if(Trigger.isUpdate){
            
    		System.debug('@@@@isUpdate@@@@');
            // each new Account Object
            String old = '';
            for ( Account account : trigger.old) {
                old = account.Country__c;
            }
            for ( Account account : trigger.new) {
                String Account_Contry = account.Country__c;
                
                if( account.Regions_Approve__c!='Pending' && old!=Account_Contry){
             		System.debug('@@@@Pending@@@@');
                    // when consist country, so submit approval
                    User user = [SELECT u.Country_Range__c,u.Country FROM USER u WHERE u.Id=:UserInfo.getUserId()];
                    String Country_Range = user.Country_Range__c;
                    
                    // When Account' Contry is not User' Contry, and Country_Range not null
                    if(  Country_Range!=null ){
                            if( ! Country_Range.contains( Account_Contry ) ){
                                // Auto Submit Approval
                                Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                                psr.setObjectId(account.id);
                                Approval.ProcessResult result = Approval.process( psr );
                            } 
                    }
                }
            } // end for new
        
        }   
    }
    }catch( Exception e ){}
        
}