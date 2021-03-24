public class MDAOppUpdate {
    public Void InsertUpdateOpportunity(Set<String> oppId ){
        if(oppId.size()>0){
            List<Opportunity> updateOpportunity =new List<Opportunity>();
            for(Opportunity opp :[Select Id,IsMDAApproval__c from Opportunity where Id IN:oppId]){
                opp.IsMDAApproval__c = true;
                updateOpportunity.add(opp);
            }
            if(updateOpportunity.size()>0){
                update updateOpportunity;
            }
        }
  }
    
     public Void UpdateOpportunity(Set<String> oppId ){
        if(oppId.size()>0){
            List<Opportunity> updateOpportunity =new List<Opportunity>();
            for(Opportunity opp :[Select Id,IsMDAApproval__c from Opportunity where Id IN:oppId]){
                opp.IsMDAApproval__c = true;
                updateOpportunity.add(opp);
            }
            if(updateOpportunity.size()>0){
                update updateOpportunity;
            }
        }
  }
}