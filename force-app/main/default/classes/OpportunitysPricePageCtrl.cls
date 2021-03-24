public class OpportunitysPricePageCtrl {
    public Opportunity opp{get;set;}
    public List<Opportunity> oppLst{get;set;}
    public List<OpportunityLineItem> oppfaLinLst{get;set;}
    public List<OpportunityLineItem> oppLinLst{get;set;}
    public List<OpportunityLineItem> StrLst{get;set;}
    public  OpportunitysPricePageCtrl(){
        initHeaderBar();
    }
    public  OpportunitysPricePageCtrl (apexpages.StandardController std){  
        opp = [select id,
               Total_Price__c,
               Green_Channel_Approval__c,
               Payment_Term_Description__c,
               Local_Warehouse__c,
               Region__c,
               ownerid,
               Total_MW__c,
               Total_Power__c,
               BMO_specialist__r.name,
               Total_Quantity__c,
               Total_Opp_MW__c,
               Total_Opp_Power__c,
               Total_Opp_Price__c,
               Total_Opp_Quantity__c,
               faOpportunity__c,
               Opportunity_Type__c,
               Inventory_Approval_Status__c
               from Opportunity 
               where id =: std.getId()];
        initHeaderBar();
    }  
    private void initHeaderBar(){
        try{
        oppLst=[Select Id,faOpportunity__c from Opportunity where faOpportunity__c =:opp.Id];
        if(oppLst.size()>0){
            oppfaLinLst=[Select Id,OpportunityId,Opportunity.Name,Product2Id,Quantity,UnitPrice,Total_Power_W__c,Total_Price__c,Certification__c,Type_of_module__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c from OpportunityLineItem where OpportunityId=:opp.Id];
            StrLst =new  List<OpportunityLineItem>();
            for(Opportunity opp1 :oppLst){
                oppLinLst =[Select Id,OpportunityId,Product2Id,Opportunity.Name,Quantity,UnitPrice,Total_Power_W__c,Total_Price__c,Certification__c,Type_of_module__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c from OpportunityLineItem where OpportunityId=:opp1.Id];        
                StrLst.addAll(oppLinLst);
            }
        }
        }catch(Exception e){
             system.debug('----'+ e.getStackTraceString());
            system.debug('****'+ e.getMessage());
        }
    }
    
}