trigger APaymentDescription on Amendment_Payment__c (after insert, after update,before insert, before update,  after delete) {
        Set<string> oppIds = new Set<string>();
    Set<string> conIds = new Set<string>();
    Set<string> ordIds = new Set<string>();
        system.debug('产品触发器开始');
List<Standard_Template_Teams__c>  stdList = [select id,
                                                                 Name,
                                                                 Field_Values__c,
                                                                 Actual_Values__c,
                                                                 Type__c,
                                                                 Flag__c
                                                                 from Standard_Template_Teams__c 
                                                                 limit 4000];
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
                                
            for(Amendment_Payment__c pay: Trigger.new){
                system.debug('----->kaishi '+pay.All_Trade_Term__c);
                system.debug('----->kaishi '+pay.Percentage__c);
                if(pay.All_Trade_Term__c!=''){
                    system.debug('----->kaishi ');
                    string payment_descritpion = '';

                    String flag='0';
                    List<String> StandFieldValue= new List<String>();
                    for(Standard_Template_Teams__c stt: stdList){
                        
                        if(stt.Type__c == 'Contain'){  
                            if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                                StandFieldValue = stt.Field_Values__c.split(':');
                                system.debug('信息汇总:---->'+ stt.Field_Values__c);
                             
                                if(StandFieldValue[0].indexof(pay.All_Trade_Term__c)>-1 && StandFieldValue[1].indexof(pay.Down_Balance_Payment__c)>-1 && StandFieldValue[2].indexof(pay.Payment_Method__c)>-1 && StandFieldValue[3].indexof(pay.Payment_Term__c)>-1){
                                    if(pay.Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             payment_descritpion =
                                                'Buyer shall pay '+pay.Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             payment_descritpion = 'Buyer shall pay '+pay.Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+pay.Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           } else{payment_descritpion =payment_descritpion+'\n'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    payment_descritpion = payment_descritpion.replace('[填入天数]',string.valueof(pay.Days__c));
                                        }
                                    }
                                    else{payment_descritpion =payment_descritpion+'\n'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    payment_descritpion = payment_descritpion.replace('[填入天数]',string.valueof(pay.Days__c));
                                        }
                                    flag='1';
                                }
                            }
                            
                        }
                    }
                    if(flag=='0'){
                        String miss2='[填入比例] % OA [填入天数] days by [填入方法] \n';
                         system.debug('--->'+miss2);
                        system.debug('--->'+string.valueof(pay.Percentage__c));
                        miss2=miss2.replace('[填入比例]',string.valueof(pay.Percentage__c));
                        miss2=miss2.replace('[填入天数]',string.valueof(pay.Days__c));
                        miss2=miss2.replace('[填入方法]',string.valueof(pay.Payment_Method__c));
                        system.debug('--->'+miss2);
                        payment_descritpion = payment_descritpion + miss2;
                        system.debug('--->'+payment_descritpion);
                    }
                    pay.PaymentDescription__c=payment_descritpion;
                    system.debug('----->kaishi '+payment_descritpion);
                }
            }
        }
    }
            if(Trigger.isAfter){

    	if(Trigger.isInsert || Trigger.isUpdate){
            for(Amendment_Payment__c pay : Trigger.new){
                                if(string.isNotEmpty(pay.Amendment_Purchase_Agreement__c) && !ordIds.contains(pay.Amendment_Purchase_Agreement__c)){
                	ordIds.add(pay.Amendment_Purchase_Agreement__c);
                } 
}
            	map<id,Amendment__c> ordMap = new map<id,Amendment__c>([SELECT ID,Name,Payment_Term_Description__c,Trade_term__c
														FROM Amendment__c
														WHERE id in: ordIds]);
              set<id> updateOppIds = new set<id> ();
            set<id> updateConIds = new set<id> ();
            set<id> updateOrdIds = new set<id> ();
            
            list<Opportunity> updateOppList = new list<Opportunity>();
            list<Contract> updateConList = new list<Contract>();
            list<Amendment__c> updateOrdList = new list<Amendment__c>();
                        for(Amendment_Payment__c pay: Trigger.new){
                string payment_descritpion = '';
                                         if(ordMap.containsKey(pay.Amendment_Purchase_Agreement__c)){
                	Amendment__c ord = ordMap.get(pay.Amendment_Purchase_Agreement__c);
                	System.debug('************ order: '+ord);                    
                    list<Amendment_Payment__c> relatePayments = [Select Down_Balance_Payment__c, 
                                                       VietNam__c,  
                                                                 Pakistan__c,
                                                       Payment_Term__c, 
                                                       Payment_Method__c,  
                                                       Name, Id,  
                                                       Days__c, 
                                                       CurrencyIsoCode,  
                                                       Precise_Day__c,
                                                       Percentage__c
                                                       From Amendment_Payment__c 
                                                       Where Amendment_Purchase_Agreement__c =: ord.id];

                   
		       	 	payment_descritpion = PaymentHelper.retrivePaymentDescription2(relatePayments, ord.Trade_term__c, false);    
		       	 	//payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false,ttpts);
		       	 	System.debug('************ description1: '+payment_descritpion);              
                    if(!string.isNotEmpty(payment_descritpion)){
			       	 	payment_descritpion = PaymentHelper.retrivePaymentDescription2(relatePayments);
			       	 	System.debug('************ description2: '+payment_descritpion);                  
                    }
                                             system.debug('2021/1/8:'+updateOrdIds);
                    if(string.isNotEmpty(payment_descritpion) && !updateOrdIds.contains(ord.id)){
                        ord.Payment_Term_Description__c = payment_descritpion;
                        updateOrdList.add(ord);
                        updateOrdIds.add(ord.id);
                    }
                }   
                        }
             if(updateOrdList.size()>0){
                  system.debug('2021/1/8:更新开始');
            	update updateOrdList;
            }
        }}
            else if(Trigger.isDelete){
        	
            for(Amendment_Payment__c pay : Trigger.old){

                if(!ordIds.contains(pay.Amendment_Purchase_Agreement__c)){
                    ordIds.add(pay.Amendment_Purchase_Agreement__c);
                }                
            }
                 map<id,Amendment__c> ordMap = new map<id,Amendment__c>([SELECT ID,Name,Payment_Term_Description__c,Trade_term__c
														FROM Amendment__c
														WHERE id in: ordIds]);
                            set<id> updateOppIds = new set<id> ();
            set<id> updateOrdIds = new set<id> ();
            
            list<Opportunity> updateOppList = new list<Opportunity>();
            list<Amendment__c> updateOrdList = new list<Amendment__c>();
                            for(Amendment_Payment__c pay: Trigger.old){
                Amendment__c ord = ordMap.get(pay.Amendment_Purchase_Agreement__c);
                                                if(ord != null){
                	list<Amendment_Payment__c> relatePayments =  [Select Down_Balance_Payment__c, 
                                                       Payment_Term__c, 
                                                       Payment_Method__c,  
                                                       Name, Id,  
                                                       Days__c, 
                                                       CurrencyIsoCode,  
                                                       Precise_Day__c,
                                                       Percentage__c
                                                       From Amendment_Payment__c 
                                                       Where Amendment_Purchase_Agreement__c =: ord.id];
                   system.debug('---------->relatePayments:' + relatePayments);
	                if(relatePayments.size()==0 && !updateOrdIds.contains(ord.id)){
	                    ord.Payment_Term_Description__c = '';
	                    updateOrdList.add(ord);
	                    updateOrdIds.add(ord.id);
	                }
			       	string payment_descritpion = PaymentHelper.retrivePaymentDescription2(relatePayments, ord.Trade_term__c, false);
			       	//string payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false,ttpts);
	                if(string.isNotEmpty(payment_descritpion) && !updateOrdIds.contains(ord.id)){
	                    ord.Payment_Term_Description__c = payment_descritpion;
	                    updateOrdList.add(ord);
	                    updateOrdIds.add(ord.id);
	                }
	                else if(string.isEmpty(payment_descritpion) && !updateOrdIds.contains(ord.id)){
			       	 	ord.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription2(relatePayments);                
	                    updateOrdList.add(ord);
	                    updateOrdIds.add(ord.id);
	                }
                }
                            }
                if(updateOrdList.size()>0){
                upsert updateOrdList;
            }  
}
}