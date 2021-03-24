global class OverDateInfo implements Database.Batchable<sObject>{
    global final String Query;
    
    global OverDateInfo(){
    	Query='select id, Status__c,Reminder_Date__c,Due_Date__c from Apply_Inventory__c where Due_Date__c = today and Status__c = \'Book\' ';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
   		List<Apply_Inventory__c> lst = new List<Apply_Inventory__c>();
        for(sobject obj : scope){
            Apply_Inventory__c inv = (Apply_Inventory__c)obj;
             if(inv.Status__c == 'Book'){
                 inv.Status__c = 'Timeout(Close)';
                 lst.add(inv);
        	 }
        }
        update lst;
    }
    global void finish(Database.BatchableContext BC){
    }
}