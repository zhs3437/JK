trigger GeneratePaymentDescription on Payment__c (after insert,after update,after delete) {
	/*
	//new add,避免101错误的选择
	List<Opportunity> fullOpps = [Select ID,Name,Payment_Term_Description__c,Payment_1MW_Approve__c
                                   From Opportunity];
                                   
   	List<Payment__c> fullOppPays = new List<Payment__c>();
   	List<Payment__c> fullConPays = new List<Payment__c>();
   	String oppid;
   	String conid;
   	
   	if(Trigger.isDelete){
   		oppid = trigger.old[0].Opportunity__c;
   		conid = trigger.old[0].Contract__c;
   	}else{
   		oppid = trigger.new[0].Opportunity__c;
   		conid = trigger.new[0].Contract__c;
   	}
   	
   	Contract contract;
   	if(conid != null)contract = [Select ID,Name,Payment_Term_Description__c 
                                   From Contract Where ID =: conid];
   	
   	if(oppid != null)fullOppPays = [Select Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                        Condition__c,Opportunity__r.Trade_Term__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                        From Payment__c Where Opportunity__c =: oppid];
    
    if(conid != null)fullConPays = [Select Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                        Condition__c,Opportunity__r.Trade_Term__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                        From Payment__c Where Contract__c =: conid];
	
    if(trigger.isDelete){
        for(Payment__c pay : trigger.old){
            if(pay.Opportunity__c != null){
                //Opportunity opp = [Select ID,Name,Payment_Term_Description__c 
                                   //From Opportunity Where ID =: pay.Opportunity__c];
                Opportunity opp = new Opportunity();
                for(Opportunity obj : fullOpps){
                	if(obj.Id == pay.Opportunity__c){
                		opp = obj;
                		break;
                	}
                }
                
                /*List<Payment__c> fullPayments = [Select Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                        Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                        From Payment__c Where Opportunity__c =: opp.ID];*/
/*                List<Payment__c> fullPayments = fullOppPays;
                
                if(!opp.Payment_1MW_Approve__c){
	                for(Payment__c tmp : fullPayments){
	                    if(tmp.Precise_Day__c !=null){
	                        opp.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' ' + tmp.Precise_Day__c.year() + '-' + tmp.Precise_Day__c.month() + '-' + tmp.Precise_Day__c.day() + ' / ';                   
	                    }else{
	                        opp.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' / ';                
	                    }
	                }
                }            
                update opp;
                break;
                
            }else if (pay.Contract__c != null){
                /*Contract con = [Select ID,Name,Payment_Term_Description__c 
                                   From Contract Where ID =: pay.Contract__c];
                List<Payment__c> fullPayments = [Select Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                        Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                        From Payment__c Where Contract__c =: con.ID];*/
/*                List<Payment__c> fullPayments = fullConPays;
                Contract con = contract;
                
                con.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription(fullPayments, pay.Opp_Trade_Term__c, false);
                if(string.isEmpty(con.Payment_Term_Description__c)){
	                for(Payment__c tmp : fullPayments){
	                    if(tmp.Precise_Day__c !=null){
	                        con.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' ' + tmp.Precise_Day__c.year() + '-' + tmp.Precise_Day__c.month() + '-' + tmp.Precise_Day__c.day() + ' / ';                   
	                    }else{
	                        con.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' / ';                
	                    }               
	                }
                }
                update con;
                break;
            }
        }
    }else{
        for(Payment__c pay : trigger.new){
        	
        	System.debug('refresh payment 1'+pay.Opportunity__c);
        	System.debug('refresh payment 2'+pay.Contract__c);
            if(pay.Opportunity__c != null){
                //Opportunity opp = [Select ID,Name,Payment_Term_Description__c 
                                   //From Opportunity Where ID =: pay.Opportunity__c];
                                   
                Opportunity opp = new Opportunity();
                for(Opportunity obj : fullOpps){
                	if(obj.Id == pay.Opportunity__c){
                		opp = obj;
                		break;
                	}
                }
                
                /*List<Payment__c> fullPayments = [Select Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                        Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                        From Payment__c Where Opportunity__c =: opp.ID];*/
/*               List<Payment__c> fullPayments = fullOppPays;
                
                if(!opp.Payment_1MW_Approve__c){
	                for(Payment__c tmp : fullPayments){
	                    if(tmp.Precise_Day__c !=null){
	                        opp.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' ' + tmp.Precise_Day__c.year() + '-' + tmp.Precise_Day__c.month() + '-' + tmp.Precise_Day__c.day() + ' / ';                   
	                    }else{
	                        opp.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' / ';                
	                    }
	                } 
                } 
                update opp;
                break;
                
            }else if (pay.Contract__c != null){
                /*Contract con = [Select ID,Name,Payment_Term_Description__c 
                                   From Contract Where ID =: pay.Contract__c];
                List<Payment__c> fullPayments = [Select Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                        Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                        From Payment__c Where Contract__c =: con.ID];*/
/*                List<Payment__c> fullPayments = fullConPays;
                Contract con = contract;
                
                if(string.isEmpty(con.Payment_Term_Description__c)){
	                for(Payment__c tmp : fullPayments){
	                    if(tmp.Precise_Day__c !=null){
	                        con.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' ' + tmp.Precise_Day__c.year() + '-' + tmp.Precise_Day__c.month() + '-' + tmp.Precise_Day__c.day() + ' / ';                   
	                    }else{
	                        con.Payment_Term_Description__c += tmp.Percentage__c + '% ' + tmp.Down_Balance_Payment__c + ' ' 
	                            + tmp.Payment_Method__c + ' ' + tmp.Days__c + ' days ' + tmp.Payment_Term__c + ' / ';                
	                    }               
	                }
                }
    			System.debug('refresh payment 3'+con.Payment_Term_Description__c);
    			
                update con;
                break;
            }
        }
    }
    */
}