global class RunBatchApex implements database.batchable<sobject>{
    Public string queryString;
    Public void setQry(string queryString){
        this.queryString = 'Select  id, name from account limit 1';
    }
    global database.querylocator start(database.batchableContext bc){
        return database.getquerylocator(queryString);
    }
    global void execute(database.batchablecontext bd, list<sobject> sc){
    
    }
    Public void finish(database.batchableContext bc){
    }
}