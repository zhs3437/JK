trigger StockTrigger on Distribution_Stock__c (before delete) {
 if (Trigger.isBefore) {
        Distribution_Stock__c delIc = new Distribution_Stock__c();
        Inventory__c ic = new Inventory__c();
        for(Distribution_Stock__c ds:Trigger.old){
         ic = [Select id,Name,Quantity__c from Inventory__c where id=:ds.Inventory__c];
            ic.Quantity__c = ds.Distribution_Quantity__c+ic.Quantity__c;
       }
     update ic;
     } 
}