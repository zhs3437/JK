global class BookstockAutoemail implements Schedulable {

	global void execute(SchedulableContext sc) {
       
        try{
 
            BookstockAutoBatch db = new BookstockAutoBatch();
            Database.executeBatch(db,1);

        }catch(Exception ex ){
            System.debug('----------> '+ex.getMessage());
        }
 
	} 

}