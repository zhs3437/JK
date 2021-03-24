trigger QuoteSyncTrigger on Quote (before insert,after insert,before update, after update) {
    if(Trigger.isBefore){
        String qoppID ='';
        Date  tdoaytime = Date.today(); 
        if(Trigger.isInsert){
            for (Quote quote : trigger.new) {
                qoppID =quote.OpportunityId;
                quote.Manager__c = quote.Manager1__c;
                quote.Delivery_Destination__c = quote.Delivery_Destination1__c;
                
                if(quote.Region__c=='North Asia' && quote.AccountCountry__c =='Japan'){
                    //quote.rate__c = 8.00;
                    system.debug('quote.Choose_Validity_Time__c'+quote.Choose_Validity_Time__c);
                    quote.Validity_Of_The_Offer__c = Date.today();
                    
                    if(quote.Choose_Validity_Time__c =='1 week'){
                        quote.Validity_Of_The_Offer__c = tdoaytime.addDays(7);
                    }else if(quote.Choose_Validity_Time__c =='1 month'){
                        quote.Validity_Of_The_Offer__c = tdoaytime.addDays(30);
                    }
                    system.debug('quote.Validity_Of_The_Offer__c '+quote.Validity_Of_The_Offer__c );
                }else{
                    quote.rate__c = null;
                }
                
                
            }
            Opportunity opp =[Select id,OwnerID,Owner.Contract_Review__c,Owner.Contract_Approver__c,Actual_Sales_Name__c,Trade_Term__c from Opportunity where id =:qoppID];   
            for(Quote quote : trigger.new){
                if(quote.Region__c=='North Asia' && quote.AccountCountry__c =='Japan'){
                    if(opp.Trade_Term__c=='EXW'|| opp.Trade_Term__c=='DDP'){
                        quote.rate__c = 8.00;
                    }else{
                    quote.rate__c = null;  
                }
                }
                quote.RegionUser__c = opp.Owner.Contract_Approver__c;
                quote.ManagerUser__c = opp.Owner.Contract_Review__c;
                quote.Actual_Sales_Name__c = opp.Actual_Sales_Name__c;
            }
            
        }
        if(Trigger.isUpdate){
            System.debug('Trigger is Change');
            for (Quote quote : trigger.new) {
                qoppID =quote.OpportunityId;
                /**
if(quote.Region__c=='North Asia' && quote.AccountCountry__c =='Japan'){
quote.rate__c = 8.00;
}else{
quote.rate__c = null;
}
*/                
                for(Quote quoteOld : trigger.old){
                    
                    if(quote.Choose_Validity_Time__c != quoteOld.Choose_Validity_Time__c){
                        
                        if(quote.Choose_Validity_Time__c =='1 week' ){
                            quote.Validity_Of_The_Offer__c = tdoaytime.addDays(7);
                        }else if(quote.Choose_Validity_Time__c =='1 month' ){
                            quote.Validity_Of_The_Offer__c = tdoaytime.addDays(30);
                        }
                    }
                }
            }
            Opportunity opp =[Select id,OwnerID,Owner.Contract_Review__c,Owner.Contract_Approver__c,Actual_Sales_Name__c,Trade_Term__c from Opportunity where id =:qoppID];   
            for(Quote quote : trigger.new){
                if(quote.Region__c=='North Asia' && quote.AccountCountry__c =='Japan'){
                    if(opp.Trade_Term__c=='EXW'|| opp.Trade_Term__c=='DDP'){
                        quote.rate__c = 8.00;
                    }else{
                    quote.rate__c = null;  
                }
                }
                quote.RegionUser__c = opp.Owner.Contract_Approver__c;
                quote.ManagerUser__c = opp.Owner.Contract_Review__c;
            }
        }
    }
    if(Trigger.isAfter){
        if (TriggerStopper.stopQuote) return;
        /**

*/
        TriggerStopper.stopQuote = true;    
        
        Set<String> quoteFields = QuoteSyncUtil.getQuoteFields();
        List<String> oppFields = QuoteSyncUtil.getOppFields();
        
        String quote_fields = QuoteSyncUtil.getQuoteFieldsString();
        
        String opp_fields = QuoteSyncUtil.getOppFieldsString();
        
        Map<Id, Id> startSyncQuoteMap = new Map<Id, Id>();
        String quoteIds = '';
        for (Quote quote : trigger.new) {
            if (quote.isSyncing && !trigger.oldMap.get(quote.Id).isSyncing) {
                startSyncQuoteMap.put(quote.Id, quote.OpportunityId);
            }
            
            if (quoteIds != '') quoteIds += ', ';
            quoteIds += '\'' + quote.Id + '\'';
        }
        
        String quoteQuery = 'select Id, OpportunityId, isSyncing' + quote_fields + ' from Quote where Id in (' + quoteIds + ')';
        //System.debug(quoteQuery);     
        
        List<Quote> quotes = Database.query(quoteQuery);
        
        String oppIds = '';    
        Map<Id, Quote> quoteMap = new Map<Id, Quote>();
        
        for (Quote quote : quotes) {
            if (trigger.isInsert || (trigger.isUpdate && quote.isSyncing)) {
                quoteMap.put(quote.OpportunityId, quote);
                if (oppIds != '') oppIds += ', ';
                oppIds += '\'' + quote.opportunityId + '\'';            
            }
        }
        
        if (oppIds != '') {
            String oppQuery = 'select Id, HasOpportunityLineItem' + opp_fields + ' from Opportunity where Id in (' + oppIds + ')';
            //System.debug(oppQuery);     
            
            List<Opportunity> opps = Database.query(oppQuery);
            List<Opportunity> updateOpps = new List<Opportunity>();
            List<Quote> updateQuotes = new List<Quote>();        
            
            for (Opportunity opp : opps) {
                Quote quote = quoteMap.get(opp.Id);
                
                // store the new quote Id if corresponding opportunity has line items
                if (trigger.isInsert && opp.HasOpportunityLineItem) {
                    QuoteSyncUtil.addNewQuoteId(quote.Id);
                }
                
                boolean hasChange = false;
                for (String quoteField : quoteFields) {
                    String oppField = QuoteSyncUtil.getQuoteFieldMapTo(quoteField);
                    Object oppValue = opp.get(oppField);
                    Object quoteValue = quote.get(quoteField);
                    if (oppValue != quoteValue) {                   
                        if (trigger.isInsert && (quoteValue == null || (quoteValue instanceof Boolean && !Boolean.valueOf(quoteValue)))) {
                            quote.put(quoteField, oppValue);
                            hasChange = true;                          
                        } else if (trigger.isUpdate) {
                            if (quoteValue == null) opp.put(oppField, null);
                            else opp.put(oppField, quoteValue);
                            hasChange = true;                          
                        }                    
                    }                     
                }    
                if (hasChange) {
                    if (trigger.isInsert) { 
                        updateQuotes.add(quote);
                    } else if (trigger.isUpdate) {
                        updateOpps.add(opp);                
                    }               
                }                                  
            } 
            
            if (trigger.isInsert) {
                Database.update(updateQuotes);
            } else if (trigger.isUpdate) {
                TriggerStopper.stopOpp = true;            
                Database.update(updateOpps);
                TriggerStopper.stopOpp = false;              
            }    
        }
        
        TriggerStopper.stopQuote = false; 
    }
    
}