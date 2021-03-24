trigger QuoteItemTrigger on QuoteLineItem (before insert) {    
    for(QuoteLineItem qli : trigger.new){
        Quote q = [Select Id,Incoterms__c From Quote Where Id =: qli.QuoteId];
        qli.Incoterms__c = q.Incoterms__c;
    }

}