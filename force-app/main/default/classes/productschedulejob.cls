global class productschedulejob implements Schedulable {
	global void execute(SchedulableContext sc) {
       
        try{
 
            productjob db = new productjob();
            Database.executeBatch(db,1000);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 
}