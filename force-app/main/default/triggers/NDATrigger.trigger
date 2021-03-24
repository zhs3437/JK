trigger NDATrigger on Requested_NDA__c (after insert, after update, before insert, 
before update) {
	if(Trigger.isBefore){
        for(Requested_NDA__c r : Trigger.new){
          
          if( Trigger.isInsert || Trigger.isUpdate ){
            
            // When the NDA is created. We should set the Contract Approver..
                User u = [Select Id,Name,Contract_Approver__c
                          From User 
                          Where Id =: r.OwnerId limit 1];
                //set the Regional Head
                
                r.Contract_Approver__c = u.Contract_Approver__c;
                
          }    
      } 
	}   
}