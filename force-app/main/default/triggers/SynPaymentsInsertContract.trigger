trigger SynPaymentsInsertContract on Contract (after insert) {
    /*
    set<string> oppIds = new set<string>();
    
    for(Contract con : trigger.new){
        if(!oppIds.contains(con.Opportunity__c)&& string.isNotEmpty(con.Opportunity__c)){
            oppIds.add(con.Opportunity__c);
        }    	
    }
    List<Opportunity> fullOpps = [SELECT ID,Name 
                                  FROM Opportunity 
                                  where id in:oppIds];
                                  
    List<Payment__c>  fullPays = [Select ID,Name,
    									Down_Balance_Payment__c, 
    									Payment_Term__c, 
    									Payment_Method__c, 
    									Contract__c, 
    									Days__c, 
    									CurrencyIsoCode,  
    									Precise_Day__c,
                    					Opportunity__c, 
                    					Percentage__c,
                    					Comments__c,
                    					Credit_Valid__c,
                    					Order__c
		                    			From Payment__c 
		                    			Where Opportunity__c in: oppIds];
    
    List<Payment__c> insertPays = new List<Payment__c>();
    
    for(Contract con : trigger.new){
        for(Opportunity opp : fullOpps){
            if(opp.ID == con.Opportunity__c){
                
                for(Payment__c pay : fullPays){
                    if(pay.Opportunity__c == opp.ID){
                        Payment__c tmp = new Payment__c();
                        tmp.Down_Balance_Payment__c = pay.Down_Balance_Payment__c;
                        tmp.Payment_Method__c       = pay.Payment_Method__c;
                        tmp.Payment_Term__c         = pay.Payment_Term__c;
                        tmp.Days__c                 = pay.Days__c;
                        tmp.Contract__c             = con.ID;
                        tmp.Percentage__c           = pay.Percentage__c;
                        tmp.Precise_Day__c          = pay.Precise_Day__c;
                        tmp.Comments__c             = pay.Comments__c;
                        tmp.Credit_Valid__c         = pay.Credit_Valid__c;
                        insertPays.add(tmp);
                    }    
                }
                
            }
        }
    }
    
    insert insertPays;
    */
}