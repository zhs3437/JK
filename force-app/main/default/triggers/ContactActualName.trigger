trigger ContactActualName on Contact (before insert,before update) {
    List<Id> ids = new List<Id>();
        if(Trigger.isUpdate||Trigger.isInsert){
            for(Contact conNew:Trigger.new){
                	ids.add(conNew.OwnerId);
            }
            List<User> u = [Select id,Alias from User where id in:ids];
            for(Contact conNew:Trigger.new){
                conNew.Actual_Sales_Name__c = u[0].Alias;
            }
    } 
}