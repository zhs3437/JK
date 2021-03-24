global class orderschedulejob implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
 
            ordjob db = new ordjob();
            Database.executeBatch(db,1);

        }catch(Exception ex ){System.debug('----------> '+ex.getMessage());}
 
	} 

}