trigger DistributionStock on Distribution_Stock__c (after update, before update) {
    List<Distribution_Stock__c> DisStockLst = new  List<Distribution_Stock__c>();
    for(Distribution_Stock__c inv_new : trigger.new){
		for(Distribution_Stock__c inv_old : trigger.old){
           
			if(inv_new.Lock__c == inv_old.Lock__c && inv_new.Lock__c==true && inv_new.Id ==inv_old.Id){
				inv_new.addError(Label.InventoryLockException,false);
            }
		}
	}
    /**
    if(Trigger.isInsert && Trigger.isAfter){
        String bookStockId = null
        for(Distribution_Stock__c inv_new : trigger.new){
            bookStockId = inv_new.Apply_Inventory__c;
            }
          Apply_Inventory__c ais = [Select id,Trade_Term__c,Opportunity__c,name,ProductName__c,Factory__c  from Apply_Inventory__c where id=:bookStockId];
        Opportunity opp = [Select id,Contract__c,name from Opportunity where id =:ais.Opportunity__c];  
        OpportunityLineItem itemsLst = [select Id,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,PricebookEntry.product2.Name,Product__c,Product2Id,Product2.Name,
                                               Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,
                                               Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                                               Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c,Expected_Delivery_Date__c,Power_W__c,Estimated_Time_of_Departure_ETD__c
                                               from OpportunityLineItem Where OpportunityId =:ais.Opportunity__c];

            for(Distribution_Stock__c ds : dsLsts){
                 if(itemsLst !=null){
                     for(OpportunityLineItem item : itemsLst){
                         system.debug('ds.Product__c-->'+ds.Product__c);
                            system.debug('ds.Product_Type__c-->'+ds.Product_Type__c);
                           system.debug('ds.Product_Type__r.Name-->'+ds.Product_Type__r.Name);
                          system.debug('item.Product2Id-->'+item.Product2.Name);
                         if(ds.Product__c == item.Product2.Name){
                             ds.Date_of_delivery__c = item.Guaranteed_Delivery_Date__c; 
                             dsLsts.add(ds);
                         }
                        
                     }
                 }
            }
            update dsLsts;
    }
   */
    if(Trigger.isUpdate && Trigger.isBefore){
         for(Distribution_Stock__c inv_new : trigger.new){
		for(Distribution_Stock__c inv_old : trigger.old){
        if(inv_new.Status__c != inv_old.Status__c  && inv_new.Id ==inv_old.Id){
               inv_new.Status_Old__c =  inv_old.Status__c; 
               inv_new.syncNumber__c = 0;
        }
            /**
            else if(inv_new.Status__c == inv_old.Status__c && inv_new.Id ==inv_old.Id){
               inv_new.Status_Old__c =  inv_old.Status__c ;
            inv_new.syncNumber__c = 0;
            
        }
            */
        }
         }
    }
    
    
    
    
    
   
    

}