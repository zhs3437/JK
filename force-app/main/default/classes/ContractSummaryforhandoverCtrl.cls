public without sharing  class ContractSummaryforhandoverCtrl {
    public String requestId {get;set;}
    public Contract con {get;set;}
    
     public ContractSummaryforhandoverCtrl(ApexPages.StandardController sd){
        requestId = ApexPages.currentPage().getParameters().get('id');
        
        con=[Select id,Contract_NO__c,Print_PA_Date__c,
                                                                                    Sales_1__c,Sales_1_percentage__c,Sales_2__c,
                                                                                    Sales_2_percentage__c,Sales_3__c,Sales_3_percentage__c,
                                                                                    SELLER__c,BuyerAccount__c,Trade_term__c,Destination__c,
                                                                                    Payment_Term_Description__c,BuyerAccount__r.name
                                                                                    from Contract where id=:requestId];
       
        
    }
}