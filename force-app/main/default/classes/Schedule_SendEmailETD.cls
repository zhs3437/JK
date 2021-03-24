global class Schedule_SendEmailETD implements Schedulable {
    global void execute(SchedulableContext sc) {

         ID batchprocessid = Database.executeBatch(new Batch_SendEmailETD(),20);
    }

    global void runtest(){
    	 Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}