global class UpdateContractBoxLink {
    
	@InvocableMethod(label='UpdateContractBoxLink' description='UpdateContractBoxLink')    
    public static void UpdateContractBoxLink(List<Id>  boxIds) {
        
       List<BoxLink__c> bLst = [select id,Contract__c from BoxLink__c where id in: boxIds];
        for(BoxLink__c bl : bLst){
            if(String.isNotEmpty(bl.Contract__c)){
                Contract con = [select id,BoxLink__c From Contract where id =: bl.Contract__c];
                if(String.isEmpty(con.BoxLink__c)){
                    con.BoxLink__c = bl.Id;
                    update con;
                }
            }
        }
        
    }
    
}