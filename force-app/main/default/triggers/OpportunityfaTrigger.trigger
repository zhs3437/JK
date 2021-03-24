trigger OpportunityfaTrigger on Opportunity (after insert,before update,after update,before delete) {
    if (IgnoreUtils.isTriggerDisabled()){
        return;
    }
    OpportunityHandle.handle();
    
    /*
    set<id> oppIDlst = new set<id>();
    Static Boolean flag = false; 
    if(Trigger.isBefore){
        if(trigger.isDelete){
            oppIDlst = OpportunityHandle.oppIdLst(Trigger.old);
            Opportunity oppCh  = OpportunityHandle.oppCh(oppIDlst);
             if(oppCh.faOpportunity__c !=null){
            Opportunity oppfa = OpportunityHandle.oppfa(oppCh);
            List<Opportunity> oppChLst =  OpportunityHandle.oppChLst(oppfa);
                OpportunityHandle.parentSub(oppfa,oppCh,oppChLst);
            }
        }

        if(trigger.isUpdate){
            for(Opportunity opp_new : trigger.new){
                    for(Opportunity opp_old : trigger.old){
                        system.debug('11122');
                         system.debug(' opp_new.faOpportunity__c -->'+ opp_new.faOpportunity__c );
                         system.debug('opp_old.faOpportunity__c--->'+opp_old.faOpportunity__c);
                         system.debug(' opp_new.Opportunity_Type__c--->'+ opp_new.Opportunity_Type__c);
                         system.debug('opp_new.RecordType.Name----->'+opp_new.RecordType.Name);
                        if(
                         opp_new.faOpportunity__c != opp_old.faOpportunity__c && opp_old.faOpportunity__c !=null && opp_new.Opportunity_Type__c=='Under Frame' ){
                              system.debug('2222'); 
                             flag =true;
                        }                    
                    }
                  }
            if (flag) {
            oppIDlst = OpportunityHandle.oppIdLst(Trigger.new);
            Opportunity oppCh  = OpportunityHandle.oppCh(oppIDlst);
            Opportunity oppfa = OpportunityHandle.oppfa(oppCh);
            List<Opportunity> oppChLst =  OpportunityHandle.oppChLst(oppfa);
            
            for(Opportunity opp_new : trigger.new){
                for(Opportunity opp_old : trigger.old){
                    if (opp_old.faOpportunity__c != null) {                            
                        OpportunityHandle.parentSub(oppfa,oppCh,oppChLst);
                    }
                }
            }            
        }
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){   
                oppIDlst = OpportunityHandle.oppIdLst(Trigger.new);
                Opportunity oppCh  = OpportunityHandle.oppCh(oppIDlst);
                Opportunity oppfa = OpportunityHandle.oppfa(oppCh);
                if(oppCh.faOpportunity__c !=null){
                    //获取主业务机会产品
                    List<OpportunityLineItem> oppLineItemLst = OpportunityHandle.oppLineItemLst(oppCh.faOpportunity__c);
                    //克隆主业务机会产品到子业务机会
                    OpportunityHandle.AddoppLineItem(oppLineItemLst,oppCh.id);
                    //克隆主业务机会付款方式到子业务机会
                    OpportunityHandle.clonePaymentItem(OpportunityHandle.paymentLst(oppfa.id), oppCh.id);
                    
                }
            }
        }
    }
   
    if(Trigger.isAfter){              
        if(trigger.isUpdate){
               for(Opportunity opp_new : trigger.new){
                    for(Opportunity opp_old : trigger.old){
                        if(
                       ( opp_new.Total_MW__c != opp_old.Total_MW__c ||
                        opp_new.Total_Power__c != opp_old.Total_Power__c ||
                        opp_new.Total_Price__c != opp_old.Total_Price__c ||
                        opp_new.Total_Quantity__c != opp_old.Total_Quantity__c || 
                        (opp_new.faOpportunity__c != opp_old.faOpportunity__c && opp_new.faOpportunity__c !=null))&& 
                        opp_new.Opportunity_Type__c=='Under Frame'){
                               flag =true;
                            
                        }                    
                    }
                  }

            if (flag) {
                oppIDlst = OpportunityHandle.oppIdLst(Trigger.new);
                Opportunity oppCh  = OpportunityHandle.oppCh(oppIDlst);
                 Opportunity oppfa =new Opportunity();
                for(Opportunity opp_new : trigger.new){
                    if(opp_new.faOpportunity__c !=null){
                   oppfa = OpportunityHandle.oppfa(oppCh);
                 }
                }
                List<Opportunity> oppChLst =  OpportunityHandle.oppChLst(oppfa);
                for(Opportunity opp_new : trigger.new){
                    for(Opportunity opp_old : trigger.old){
                        if(opp_new.faOpportunity__c !=null ){
                            OpportunityHandle.parentNoSub(oppfa,oppCh,oppChLst);
                        }

                    }

                }
            }
        }
	
    }
*/
}