trigger OpportunityAfterUpdate on Opportunity (before update, After update) {
    if(trigger.isBefore)
    {
        if(trigger.isUpdate)
        {
            for(Opportunity opp : trigger.new){
              for(Opportunity opp_old : trigger.old){
                  if(opp.StageName=='Closed Lost'&&opp_old.StageName!='Closed Lost'){
                      opp.StageBeforeLost__c = opp_old.StageName;
                  }
             }
            }
        }
    }


    if(Trigger.isAfter){
        
    if(Trigger.isUpdate){
        if(checkRecursive.runOnce4()){
        
//          Cls_UpdateLogisticFreight ulf=new Cls_UpdateLogisticFreight();
 //           ulf.updateFreight(trigger.new,trigger.oldMap);
 //           ulf.Update_Freight(trigger.new, trigger.oldMap);
             
        String oppSeller='';
        String oppId='';
        for(Opportunity opp_new : trigger.new){
            for(Opportunity opp_old : trigger.old){
                if(opp_old.Seller__c != opp_new.Seller__c){
                    oppSeller= opp_new.Seller__c;
                      oppId = opp_new.Id; 
                }           
            }
        }
         system.debug('dasds:'+oppSeller);
        List<Contract> contractList= new  List<Contract>();
        if(oppId !=null || oppId !=''){
         contractList =[Select Id,SELLER__c,Opportunity__c,BankInfo__c,BankInfo_Lock__c from Contract where Opportunity__c =: oppId]; 
            system.debug('dasds:'+contractList);
        }/**
        if(contractList.size()==1){
            if(oppSeller==contractList[0].SELLER__c){
                contractList[0].BankInfo_Lock__c = false;
            }else{
                if(contractList[0].BankInfo__c!=null){
                contractList[0].BankInfo_Lock__c = true;
                }
            }
            update contractList;
        
        }
*/
        } 
        }
    }
   }