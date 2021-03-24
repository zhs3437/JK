global class OrderDetailJob2 implements Schedulable{
    global void execute(SchedulableContext sc) {

                     OrderDetailJob3 db = new OrderDetailJob3();
             Database.executeBatch(db,9500);
    }
}