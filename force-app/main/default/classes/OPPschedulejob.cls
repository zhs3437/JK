global class OPPschedulejob implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
 
            OPPJob db = new OPPJob();
            Database.executeBatch(db,1);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 

}