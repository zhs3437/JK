global class conschedulejob implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
 
            conjob db = new conjob();
            Database.executeBatch(db,1);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 

}