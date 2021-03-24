trigger OpportunityLineItem_after_delete on OpportunityLineItem (after delete, after insert, after update) {
  
  /*  if(trigger.isDelete){
   for(OpportunityLineItem otm : Trigger.old) {
			
			  ID priceBookId = otm.PricebookEntryId;
              PricebookEntry pe = [Select Product2Id From PricebookEntry where Id =:priceBookId];
              String opportunityId = String.valueOf(pe.Product2Id);
              
    		  String pageProductStr = opportunityId.substring(0,opportunityId.length()-3)+'_'+ otm.Type_of_module__c+'_'+otm.Certification__c;
    		  //get releated Opportunity 			
    	      ID oppoID = otm.OpportunityId; 	        
			  Opportunity oppo = [Select Id,IsStandardProduct__c,NoStandardCompleted__c From Opportunity where Id = :oppoID];
			  
			  
			  
    		//Calculate result
    		Decimal num1;
    		Decimal num2;
    		
    		try{   			
    			 num1 = oppo.NoStandardCompleted__c - 1;
    			 num2 = oppo.IsStandardProduct__c - 1;
    		
    		} catch(NullPointerException e) {
    			System.debug(e.getMessage());		
    		}
    		   		
    	
			 List<Opportunity_Standard_Product__c> standardProductList = [SELECT Combination_key__c FROM 
				        Opportunity_Standard_Product__c Where Combination_key__c = :pageProductStr];
				        
			  if(standardProductList.isEmpty()) {
			     oppo.IsStandardProduct__c = num2;
			     if(otm.Required_Special_Demand_Code__c == 'Yes' || otm.Required_Special_Demand_Code__c == 'No') {
			     	oppo.NoStandardCompleted__c = num1;
			     }   
			  }

			update oppo;
		}
    } 


    if(trigger.isAfter)
    {
        if(trigger.isInsert || trigger.isUpdate)
        {
            set<Id> set_prodid =new set<Id>();

            for(OpportunityLineItem oppline:trigger.new)
            {
                if(oppline.OpportunityId !=null)
                {
                    set_prodid.add(oppline.OpportunityId);
                }
            }

            if(set_prodid.size() >0)
            {
                List<Opportunity>  list_opp= [Select Power__c,Id from Opportunity where Id in:set_prodid];
                list<OpportunityLineItem> list_oppline=[Select Id,Power_W__c,OpportunityId from OpportunityLineItem where OpportunityId in:set_prodid Order By CreatedDate asc limit 10];
                System.debug('***********************list_opp+list_oppline***'+list_opp+'*****'+list_oppline);

                if(list_oppline.size()>0)
                {
                    for(Opportunity opp:list_opp)
                    {
                        opp.Power__c=list_oppline[0].Power_W__c;
                    }
                    update list_opp;
                }
            }
        }
    }


    //add on 2018 04 24 By Leo   用于自动抓取Product 的Guarantee delivery Date
    /*    if(trigger.isAfter){
            if(trigger.isInsert ||trigger.isUpdate ) // 取当前插入或者更新的opp id 值
            {
                set<Id> set_oppid = new set<Id>(); //装和product相关的opp Id
                map<Id,OpportunityLineItem> map_opp=new map<Id,OpportunityLineItem>();

                for(OpportunityLineItem oppline:trigger.new)
                {

                    if(oppline.OpportunityId !=null)
                    {
                        set_oppid.add(oppline.OpportunityId);
                        System.debug('******set_oppid*****'+set_oppid);

                    }

                }

                if(set_oppid.size()>0){

                    list<Opportunity> list_opp=[select Customer_Delivery_Date__c,Id from Opportunity where Id in:set_oppid ];
                    list<OpportunityLineItem> list_oppline =[select Id,Guaranteed_Delivery_Date__c,OpportunityId from OpportunityLineItem where OpportunityId in:set_oppid Order By Guaranteed_Delivery_Date__c desc ];
                    System.debug('##########list_opp###########'+list_opp+'#######list_oppline######'+list_oppline);
                    if(list_oppline.size()>0)
                    {
                        for(Opportunity opp:list_opp)
                        {
                                opp.Customer_Delivery_Date__c=list_oppline[0].Guaranteed_Delivery_Date__c;
                        }
                        update list_opp;
                    }

                 }
            }
            if(trigger.isDelete)
            {
                 set<Id> set_oppid = new set<Id>(); //装和product相关的opp Id
                map<Id,OpportunityLineItem> map_opp=new map<Id,OpportunityLineItem>();

                for(OpportunityLineItem oppline:trigger.old)
                {

                    if(oppline.OpportunityId !=null)
                    {
                        set_oppid.add(oppline.OpportunityId);
                        System.debug('******set_oppid*****'+set_oppid);

                    }

                }

                if(set_oppid.size()>0){

                    list<Opportunity> list_opp=[select Customer_Delivery_Date__c,Id from Opportunity where Id in:set_oppid ];
                    list<OpportunityLineItem> list_oppline =[select Id,Guaranteed_Delivery_Date__c,OpportunityId from OpportunityLineItem where OpportunityId in:set_oppid Order By Guaranteed_Delivery_Date__c desc ];
                    System.debug('##########list_opp###########'+list_opp+'#######list_oppline######'+list_oppline);
                    if(list_oppline.size()>0)
                    {
                        for(Opportunity opp:list_opp)
                        {
                                opp.Customer_Delivery_Date__c=list_oppline[0].Guaranteed_Delivery_Date__c;
                        }
                        update list_opp;
                    }

                 }
            }
    }  */
}