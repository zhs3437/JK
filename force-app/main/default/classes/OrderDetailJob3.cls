global  class OrderDetailJob3 implements Database.Batchable<sObject>{
     global Database.QueryLocator start(Database.BatchableContext BC){
        String VisitList='select id from OrderDetail__c';
        return Database.getQueryLocator( VisitList);
    }
    global void execute(Database.BatchableContext BC, List<OrderDetail__c> oilst) {
        List<OrderDetail__c> deleteolist = new  List<OrderDetail__c>();
        for(OrderDetail__c od:oilst){
            deleteolist.add(od);
            }
        system.debug('deleteolist:'+deleteolist);
        delete deleteolist;
    }
    global void finish(Database.BatchableContext BC){
       OrderDetailJob db = new OrderDetailJob(); 
           Database.executeBatch(db, integer.valueof(label.month2));
        
    }
}