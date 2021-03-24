trigger AmendmentTrigger on Amendment__c (before update,before insert,after insert) {
   
    TriggerHandler.bypass('RC_MDAReassignHandler');
    if(trigger.isbefore){
        if(trigger.isupdate){
            if(checkRecursive.runOnce()){  
                system.debug('走进测试1');
                String conids;
                id aid;
                for(Amendment__c ord_new : trigger.new){
                    conids=ord_new.Contract__c;
                    aid=ord_new.Id;
                    for(Amendment__c ord_old : trigger.old){
                        
                        if(ord_new.Lock__c == ord_old.Lock__c && ord_new.Lock__c && ord_new.Contact_Name__c == ord_old.Contact_Name__c && ord_new.Fax__c == ord_old.Fax__c && ord_new.Customer_Business_Scale__c == ord_old.Customer_Business_Scale__c && ord_new.BillingCountry__c == ord_old.BillingCountry__c && ord_new.BillingState__c == ord_old.BillingState__c && ord_new.BillingCity__c == ord_old.BillingCity__c && ord_new.BillingStreet__c == ord_old.BillingStreet__c && ord_new.BillingPostalCode__c == ord_old.BillingPostalCode__c && ord_new.Customer_country__c == ord_old.Customer_country__c && ord_new.Phone__c == ord_old.Phone__c  && ord_new.Email__c == ord_old.Email__c  && ord_new.Title__c == ord_old.Title__c  && ord_new.Authorized_Representative__c == ord_old.Authorized_Representative__c){
                            ord_new.addError(Label.OrderLockException,false);
                        }
                        
                        if((ord_new.Destination_Country__c != ord_old.Destination_Country__c ||
                            ord_new.Opportunity__r.name!=ord_old.Opportunity__r.name||
                            ord_new.SELLER__c != ord_old.SELLER__c||
                            ord_new.Contract_No__c!= ord_old.Contract_No__c||
                            ord_new.Buyer__r.name !=      ord_old.Buyer__r.name 
                            ||  ord_new.Factory__c !=      ord_old.Factory__c 
                            ||  ord_new.Shipping_type__c !=      ord_old.Shipping_type__c 
                            || 
                            ord_new.Warranty_Insurance__c!= ord_old.Warranty_Insurance__c 
                            ||  ord_new.Region__c !=      ord_old.Region__c 
                            ||  ord_new.Warranty_On_Material_and_Workmanship__c !=      ord_old.Warranty_On_Material_and_Workmanship__c 
                            
                            
                            ||  ord_new.Commission_Type__c !=      ord_old.Commission_Type__c 
                            ||  ord_new.VAT_NO__c !=      ord_old.VAT_NO__c 
                            ||  ord_new.GST_Classification_Region__c !=      ord_old.GST_Classification_Region__c 
                            
                            ||  ord_new.Special__c !=      ord_old.Special__c 
                            ||  ord_new.Normal__c !=      ord_old.Normal__c 
                            ||  ord_new.Special_Requirements__c !=      ord_old.Special_Requirements__c 
                            ||  ord_new.Special_Approvals__c !=      ord_old.Special_Approvals__c 
                            || 
                            ord_new.Intercompany_Seller_POs__c !=      ord_old.Intercompany_Seller_POs__c 
                            ||  ord_new.Tax_Rate__c !=      ord_old.Tax_Rate__c 
                            
                            
                            ||  ord_new.Bank_Street__c !=      ord_old.Bank_Street__c   
                            ||  ord_new.Trade_term__c  !=      ord_old.Trade_term__c 
                            ||  ord_new.Total_Price__c  !=      ord_old.Total_Price__c 
                           ) && ord_new.Submission_Time__c!=null
                          ){
                              ord_new.Header_Change__c=true;
                          }
                        
                    }
                }
                List<Component_Task_Book__c> ctb =[SELECT ID,Contract__c,Amendment_Purchase_Agreement__c FROM Component_Task_Book__c WHERE Contract__c=:conids];
                if(ctb.size()>0){
                    for(Component_Task_Book__c ct : ctb){
                        ct.Amendment_Purchase_Agreement__c = aid;
                    }
                    
                    update ctb;
                }
                
            }
        }
    }
    

    // 插入
    if(trigger.isinsert){
        String conids;
        id aid;
        for(Amendment__c ord_new : trigger.new){
            conids=ord_new.Contract__c;
            aid=ord_new.Id;
        }
        SyncContract.MDAUpdate(aid,conids);

    }

}