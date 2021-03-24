global class MDAschedulejob implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
 
            MDAJob db = new MDAJob();
            Database.executeBatch(db,1);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 

}