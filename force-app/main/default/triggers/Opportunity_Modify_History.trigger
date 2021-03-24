/**
 * Add By Javen 2013-1-14 17:43:27, for work piece(20130111-00001) 
 * this class for log the field change.
 **/
trigger Opportunity_Modify_History on Opportunity ( before update , after update) {

	
	if( Trigger.isBefore && Trigger.isUpdate ){
		
		// check the opportunity' account is change
		if( !Test.isRunningTest() ){
			Map<ID,Opportunity> map_Opportunitys = new Map<ID,Opportunity>(
									[SELECT ID,(SELECT Id  FROM Contracts__r) FROM Opportunity WHERE ID IN :trigger.new]);
			for( Opportunity opp : trigger.new ){
				Boolean hasChange = trigger.oldMap.get(opp.Id).AccountId != opp.AccountId; 
				Boolean hasContract = map_Opportunitys.get( opp.Id ).Contracts__r.size() > 0;
				if( hasChange && hasContract ){
					opp.addError( 'this Opportunity has Contract already , you can\'t change the Account name.' );
				}
			}
		}
	
	}
	
	
    if( Trigger.isAfter && Trigger.isUpdate && !Test.isRunningTest()){
    	
		List<Opportunity_History__c> lstOppHistory = new List<Opportunity_History__c>();
		Opportunity_History__c tmpObj = null;
		
		List<ID> oppids = new List<ID>();
		for(Opportunity opp : Trigger.new){
			oppids.add(opp.Id);
		}
		List<Contract> conList = [SELECT ID,Opportunity__c FROM Contract WHERE Opportunity__c in: oppids];
		
    	for(Opportunity newOpp : Trigger.new){
    		Opportunity oldOpp = Trigger.oldMap.get( newOpp.Id );
    		
			//List<Contract> lstRelateCons = [SELECT ID FROM Contract WHERE Opportunity__c=:newOpp.Id];
			List<Contract> lstRelateCons = new List<Contract>();
			for(Contract c : conList){
				if(c.Opportunity__c == newOpp.Id){
					lstRelateCons.add(c);
				}
			}
			
			// this record must exists 1 contract;
			if( lstRelateCons.size() > 0 ){
				// check Amount Field
				If( oldOpp.Total_Price__c != newOpp.Total_Price__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Amount';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Total_Price__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Total_Price__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				// check Stage Field
				If( oldOpp.StageName != newOpp.StageName ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Stage';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.StageName);
						tmpObj.After_Modify__c = String.valueOf(newOpp.StageName);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Credit_Days__c != newOpp.Credit_Days__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Balapayment Credit Days';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Credit_Days__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Credit_Days__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Balance_Payment__c != newOpp.Balance_Payment__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Balance Payment';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Balance_Payment__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Balance_Payment__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Payment_Method__c != newOpp.Payment_Method__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Payment Method';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Payment_Method__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Payment_Method__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.TotalOpportunityQuantity != newOpp.TotalOpportunityQuantity ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Quantity';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.TotalOpportunityQuantity);
						tmpObj.After_Modify__c = String.valueOf(newOpp.TotalOpportunityQuantity);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Trade_Term__c != newOpp.Trade_Term__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Trade Term';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Trade_Term__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Trade_Term__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Confirmed_ETA__c != newOpp.Confirmed_ETA__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Confirmed ETA';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Confirmed_ETA__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Confirmed_ETA__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Confirmed_ETA2__c != newOpp.Confirmed_ETA2__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Confirmed ETA2';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Confirmed_ETA2__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Confirmed_ETA2__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Confirmed_ETA3__c != newOpp.Confirmed_ETA3__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Confirmed ETA3';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Confirmed_ETA3__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Confirmed_ETA3__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Confirmed_ETD__c != newOpp.Confirmed_ETD__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Confirmed ETD';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Confirmed_ETD__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Confirmed_ETD__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Confirmed_ETD2__c != newOpp.Confirmed_ETD2__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Confirmed ETD2';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Confirmed_ETD2__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Confirmed_ETD2__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Confirmed_ETD3__c != newOpp.Confirmed_ETD3__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Confirmed ETD3';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Confirmed_ETD3__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Confirmed_ETD3__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.Customer_Delivery_Date__c != newOpp.Customer_Delivery_Date__c ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Customer Delivery Date';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.Customer_Delivery_Date__c);
						tmpObj.After_Modify__c = String.valueOf(newOpp.Customer_Delivery_Date__c);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
				
				If( oldOpp.CloseDate != newOpp.CloseDate ){
					for( Contract con : lstRelateCons ){
						tmpObj = new Opportunity_History__c();
						tmpObj.Change_Field__c = 'Close Date';
						tmpObj.Before_Modify__c = String.valueOf(oldOpp.CloseDate);
						tmpObj.After_Modify__c = String.valueOf(newOpp.CloseDate);
						tmpObj.Opportunity__c = newOpp.Id;
						tmpObj.Contract__c = con.Id;
						lstOppHistory.add(tmpObj);
					}
				}
			}
			
    	}
		
		// insert history    	
    	if( lstOppHistory.size()>0 ){
    		insert lstOppHistory;
    		system.debug('######################## insert lstOppHistory size : '+lstOppHistory.size() );
    	}
		
	}

}