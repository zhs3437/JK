global class AccountActiveJob implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
  
            AccountActive db = new AccountActive();
            Database.executeBatch(db,1);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 

}