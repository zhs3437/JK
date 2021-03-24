trigger UpdateAccountTransferDateBD on Account (before update) {
    try{
        GlobalSetting__c gsflag = GlobalSetting__c.getOrgDefaults();
    System.debug('gsflag.Account_Flag__c---->@@@'+gsflag.Account_Flag__c);
    if(gsflag.Account_Flag__c){
    User user = [SELECT u.id,u.ProfileId FROM USER u WHERE u.Id=:UserInfo.getUserId()];
        for(Account accold : trigger.old){
            for(Account accnew : trigger.new){
                if(user.ProfileId == '00e90000000NsvM' || user.ProfileId == '00e90000000sjac'){
                    if(accold.OwnerId != accnew.OwnerId){
                        accnew.Original_Owner__c = accold.OwnerId;
                    }
                    if(accold.Original_Owner__c != accnew.Original_Owner__c){
                        accnew.Sharing_Date__c = system.today();
                        
                    }
                }
            }
        }
    }
    }catch(Exception e){

    }
}