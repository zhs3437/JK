/*
*Author Charliy  
*Date:  2020-8-26
*Description: 发送给创建业务机会超过100条的用户
*/
global class BatchOppSendEmail implements Database.Batchable<sObject>,Schedulable {
   
    global void execute(SchedulableContext sc) {
       
        try{
 
            BatchOppSendEmail db = new BatchOppSendEmail();
            Database.executeBatch(db,1);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime endTimes = dateTime.valueOf('2020-01-01 00:00:00'); 
        List<Opportunity> oppList = [Select id,name,OwnerId,Earliest_Expected_Delivery_Date__c,RecordTypeId, Account.Name from Opportunity where stageName!='Closed Won' and stageName!='Closed Lost' and createdtonow__c>90 and Earliest_Expected_Delivery_Date__c != null and createdDate>=:endTimes and RecordTypeId != '0126F0000022Ykj'];
        system.debug(oppList);
        List<User> userLst = [Select id,name from User where IsActive = true];
        system.debug(userLst);
        Map<User,List<Opportunity>> UOmap = new Map<User,List<Opportunity>>();
        system.debug(UOmap);
        for(User u :userLst){
            List<Opportunity> opp = new List<Opportunity>();
            for(Opportunity o:oppList){
                if(o.OwnerId==u.Id){
                    opp.add(o);
                }
            }
            if(opp.size()>0){
             UOmap.put(u,opp);
            }
        }
        system.debug('UOmap'+UOmap);
        Set<User> uSet = UOmap.keySet();
        List<User> ulst = new List<User>(uSet);
        system.debug(uSet);
        List<id> ids = new List<id>();
        for(User u :ulst){
            ids.add(u.id);
        }
        return Database.getQueryLocator('SELECT Id,email,FirstName from User where id in:ids');
    }

    global void execute(Database.BatchableContext BC, list<User> list_user) {
        system.debug(list_user);
        if(list_user.size()>0)
        {
            system.debug('list_user'+list_user);
          list<String> recipients =new list<String>();
            for(User us:list_user)
            {
                SendEmailUtils.UnOppOwner(us);
            }
        }
    }

    global void finish(Database.BatchableContext BC) {

    }
    }