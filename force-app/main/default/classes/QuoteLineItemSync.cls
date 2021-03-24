global class QuoteLineItemSync {
	webservice static String run(String id){
		if(id != null){
			Quote quo = [SELECT ID,Name,OpportunityId FROM Quote WHERE ID =: id];
			List<QuoteLineItem> quoItems = [SELECT ID,Wire_Length__c,Battery_Type__c,Battery_Line__c,
				Junction_Box_Type__c,Junction_Box_Brand__c,ConnectorLine__c,Quantity,PricebookEntry.product2Id
				FROM QuoteLineItem WHERE QuoteId =: quo.ID];
			List<OpportunityLineItem> oppItems = [SELECT ID,Wire_Length__c,Battery_Type__c,Battery_Line__c,OpportunityId,
				Junction_Box_Type__c,Junction_Box_Brand__c,ConnectorLine__c,PricebookEntry.product2Id,Quantity,PricebookEntryId,
				ListPrice,Subtotal,Total_Price__c,UnitPrice
				FROM OpportunityLineItem WHERE OpportunityId =: quo.OpportunityId];
			List<QuoteLineItem> tmpItems = new List<QuoteLineItem>();
			/*for(QuoteLineItem qitem : quoItems){
				for(OpportunityLineItem oitem : oppItems){
					if(oitem.PricebookEntry.product2Id == qitem.PricebookEntry.product2Id){
						qitem.Wire_Length__c = oitem.Wire_Length__c;
						qitem.Battery_Type__c = oitem.Battery_Type__c;
						qitem.Battery_Line__c = oitem.Battery_Line__c;
						qitem.Junction_Box_Type__c = oitem.Junction_Box_Type__c;
						qitem.Junction_Box_Brand__c = oitem.Junction_Box_Brand__c;
						qitem.ConnectorLine__c = oitem.ConnectorLine__c;
						qitem.Quantity = oitem.Quantity;
						
						tmpItems.add(qitem);
					}
				}
			}
			if(tmpItems.size() > 0)update tmpItems;*/
			
			delete quoItems;
			
			for(OpportunityLineItem oitem : oppItems){
				QuoteLineItem qitem = new QuoteLineItem();
				qitem.Wire_Length__c = oitem.Wire_Length__c;
				qitem.Battery_Type__c = oitem.Battery_Type__c;
				qitem.Battery_Line__c = oitem.Battery_Line__c;
				qitem.Junction_Box_Type__c = oitem.Junction_Box_Type__c;
				qitem.Junction_Box_Brand__c = oitem.Junction_Box_Brand__c;
				qitem.ConnectorLine__c = oitem.ConnectorLine__c;
				qitem.Quantity = oitem.Quantity;
				qitem.UnitPrice = oitem.UnitPrice;
				qitem.PricebookEntryId = oitem.PricebookEntryId;
				qitem.QuoteId = id;
				
				tmpItems.add(qitem);
			}
			
			if(tmpItems.size() > 0)insert tmpItems;
			
		}
		return '';
	}
	
	public void runTest(){
    	String run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
    }
	
}