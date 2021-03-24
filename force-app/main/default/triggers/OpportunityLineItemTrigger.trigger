trigger OpportunityLineItemTrigger on OpportunityLineItem(before insert,before update,before delete,After insert,After update) {
//  new TriggerManager()
//      .bind(TriggerManager.Event.BEFORE_UPDATE, new MOUOpportunityLineItemHandler())
//      .bind(TriggerManager.Event.AFTER_INSERT, new MOUOpportunityLineItemHandler())
//      .bind(TriggerManager.Event.BEFORE_DELETE, new MOUOpportunityLineItemHandler())
//      .manage();

    // neo
  if (OpportunityLineItemGrossMarginHandler.skipTrigger ) return;
  
  //判断是否重置审批
  Set<Id> MOUOppIdSet = new Set<Id>();
  Map<Id, OpportunityLineItem> oldLineItemMap = Trigger.oldMap;
  Map<Id, OpportunityLineItem> newLineItemMap = Trigger.newMap;
  Boolean VPapproval = false;
    
  if(Trigger.isBefore){
    if(Trigger.isInsert){
      for(OpportunityLineItem item:Trigger.new){
        MOUOppIdSet.add(item.OpportunityId);
      }
    }
    if(Trigger.isUpdate){
      for (Id newLineItemId : newLineItemMap.keySet()) {
        OpportunityLineItem newLineItem = newLineItemMap.get(newLineItemId);

        //if (oldLineItemMap != null) {
        OpportunityLineItem oldLineItem = oldLineItemMap.get(newLineItem.Id);

        if (oldLineItem != null) {
          if (newLineItem.Product2Id != oldLineItem.Product2Id ||
                  newLineItem.UnitPrice != oldLineItem.UnitPrice ||
                  newLineItem.Quantity != oldLineItem.Quantity ||
                  newLineItem.Guaranteed_Delivery_Date__c !=
                  oldLineItem.Guaranteed_Delivery_Date__c ||
                               newLineItem.Trade_Term__c != oldLineItem.Trade_Term__c
                       ) {
            MOUOppIdSet.add(newLineItem.OpportunityId);
          }
                    //新增VP的审批，值判断价格是否改变
                    if(newLineItem.UnitPrice != oldLineItem.UnitPrice){
                        VPapproval = true;
                    }
        }
      }
    }
    if(Trigger.isDelete){
      for(OpportunityLineItem item:Trigger.old){
        MOUOppIdSet.add(item.OpportunityId);
      }
        
  }
      if ( Trigger.isUpdate) {
          for(OpportunityLineItem ol: Trigger.new){
              
            system.debug('20200825:'+ol.Product_Name__c);
                //Connector
                if(ol.product_name__c.Startswith('JK03M')||ol.product_name__c.Startswith('JK06M')||ol.product_name__c.Startswith('MC4')||ol.product_name__c.Startswith('JKT')){
                    ol.Product_Type__C ='Connector';
                    ol.Main_Type__c = 'Connector';
                }
              //New Tiger
              else if((ol.product_name__c.Startswith('JKM')||ol.product_name__c.Startswith('MM'))&&ol.product_name__c.contains('LM')&&!ol.product_name__c.contains('N')){
                    ol.Main_Type__c = 'Tiger';
                    if(ol.product_name__c.contains('BD')||ol.product_name__c.contains('BG')){
                        ol.Product_Type__C ='New Tiger-P-DG';
                    }else if(ol.product_name__c.contains('T')||ol.product_name__c.contains('BB')){
                        ol.Product_Type__C ='New Tiger-P-TB';
                    }else{
                        ol.Product_Type__C ='New Tiger-P';
                    }
                }
                //N Type
                else if(((ol.product_name__c.contains('BDV') && !ol.product_name__c.contains('BDVP'))||ol.product_name__c.contains('N-'))&& ol.product_name__c.contains('HLM')){
                    ol.Main_Type__c = 'Tiger';
                    if(ol.product_name__c.contains('6T')){
                        ol.Product_Type__C ='N-Tiger-60M';
                    }else if(ol.product_name__c.contains('6R')||ol.product_name__c.contains('66')){
                        ol.Product_Type__C ='N-Tiger-66M';
                    }
                }
                //P Type
                else if(ol.product_name__c.contains('HLM')){
                    ol.Main_Type__c = 'Tiger';
                    if(ol.product_name__c.contains('6T')||ol.product_name__c.contains('60H')){
                        ol.Product_Type__C ='P-Tiger-60MH';
                    }else if(ol.product_name__c.contains('7T')||ol.product_name__c.contains('72')){
                        if(ol.product_name__c.contains('BD')){
                          ol.Product_Type__C ='P-Tiger-72BD';
                        }else if(ol.product_name__c.contains('TV')){
                          ol.Product_Type__C ='P-Tiger-72BT';
                        }else{
                          ol.Product_Type__C ='P-Tiger-72MH';
                        }
                    }
                }
                //P Type Pro
                else if(ol.product_name__c.contains('L4')){
                    ol.Main_Type__c = 'Tiger Pro';
                    if(ol.product_name__c.contains('6T')||ol.product_name__c.contains('60H')){
                        ol.Product_Type__C ='P-Tiger Pro-60MH';
                    }else if(ol.product_name__c.contains('7T')||ol.product_name__c.contains('72H')){
                        if(ol.product_name__c.contains('BDVP')){
                          ol.Product_Type__C ='P-Tiger Pro-72BD';
                        }else if(ol.product_name__c.contains('TV')){
                          ol.Product_Type__C ='P-Tiger Pro-72BT';
                        }else{
                          ol.Product_Type__C ='P-Tiger Pro-72MH';
                        }
                    }else if(ol.product_name__c.contains('7R')||ol.product_name__c.contains('78')){
                          ol.Product_Type__C ='P-Tiger Pro-78BT';
                    }
                }
                //Smart
                else if(ol.product_name__c.Startswith('JKMS')||ol.product_name__c.Startswith('SMM')){
                    ol.Main_Type__c = 'Smart';
                    if(ol.product_name__c.contains('TI')){
                        ol.Product_Type__C ='Smart-TI';
                    }else if(ol.product_name__c.contains('TG')){
                        ol.Product_Type__C ='Smart-TG';
                    }else if(ol.product_name__c.contains('MX')){
                        ol.Product_Type__C ='Smart-MX';
                    }else{
                        ol.Product_Type__C ='Smart';
                    }
                }
                
                //Tiger Pro
                else if(ol.product_name__c.Startswith('JKM')&& !ol.product_name__c.contains('JKMS')&&ol.product_name__c.contains('L4')){
                    ol.Main_Type__c = 'Tiger Pro';
                    if(ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            ol.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            ol.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }
                else if(ol.product_name__c.Startswith('MM')&&ol.product_name__c.contains('LD')){
                    ol.Main_Type__c = 'Tiger Pro';
                    if(ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            ol.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            ol.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }

                //Tiger
                else if(ol.product_name__c.Startswith('JKM')&& !ol.product_name__c.contains('JKMS')&&ol.product_name__c.contains('L3')){
                    ol.Main_Type__c = 'Tiger';
                    if(ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Tiger-N-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Tiger-N-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Tiger-N-TB';
                        }else{
                            ol.Product_Type__C ='Tiger-N';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Tiger-P-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Tiger-P-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Tiger-P-TB';
                        }else{
                            ol.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(ol.product_name__c.Startswith('MM')&&ol.product_name__c.contains('LC')){
                    ol.Main_Type__c = 'Tiger';
                    if(ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Tiger-N-DG';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Tiger-N-SG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Tiger-N-TB';
                        }else{
                            ol.Product_Type__C ='Tiger-N';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Tiger-P-DG';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Tiger-P-SG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Tiger-P-TB';
                        }else{
                            ol.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(ol.product_name__c.contains('JKSM3')){
                    ol.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    ol.Product_Type__C ='Tiger-P';
                }
                else if(ol.product_name__c.contains('JKSN3')){
                    ol.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    ol.Product_Type__C ='Tiger-N';
                }  
                
               
                else if(ol.product_name__c.startsWith('JKM') && !ol.product_name__c.contains('JKMS')&&(ol.product_name__c.contains('66')||ol.product_name__c.contains('78'))){
                    system.debug('ol.product_name__c'+ol.product_name__c);
                    system.debug('ol.product_name__c'+ol.product_name__c);
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    if(ol.product_name__c.contains('N')){
                        system.debug('ol.product_name__c'+ol.product_name__c);
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Swan Plus-N-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Swan Plus-N-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Swan Plus-N-TB';
                        }else{
                            ol.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Swan Plus-P-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Swan Plus-P-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Swan Plus-P-TB';
                        }else{
                            ol.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                else if(ol.product_name__c.startsWith('MM') &&(ol.product_name__c.contains('66')||ol.product_name__c.contains('78'))){
                    system.debug('ol.product_name__c'+ol.product_name__c);
                    system.debug('ol.product_name__c'+ol.product_name__c);
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    if(ol.product_name__c.contains('N')){
                        system.debug('ol.product_name__c'+ol.product_name__c);
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Swan Plus-N-DG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Swan Plus-N-TB';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Swan Plus-N-SG';
                        }else{
                            ol.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Swan Plus-P-DG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Swan Plus-P-TB';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Swan Plus-P-SG';
                        }else{
                            ol.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                
              
                else if(ol.product_name__c.contains('JKM')&& (ol.product_name__c.contains('BDVP')||ol.product_name__c.contains('BD')||ol.product_name__c.contains('-T')||ol.product_name__c.contains('-D'))){
                    system.debug('ol.product_name__c'+ol.product_name__c);
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    if(ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BD')){
                            ol.Product_Type__C ='Swan-N-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Swan-N-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Swan-N-TB';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BDVP')){
                            ol.Product_Type__C ='Swan-P-DG';
                        }else if(ol.product_name__c.contains('BD')){
                            system.debug('junjun');
                            ol.Product_Type__C ='Swan-N-DG';
                        }else if(ol.product_name__c.contains('-D')){
                            ol.Product_Type__C ='Swan-P-SG';
                        }else if(ol.product_name__c.contains('-T')){
                            ol.Product_Type__C ='Swan-P-TB';
                        }
                    }
                }
                else if(ol.product_name__c.contains('MM')&& (ol.product_name__c.contains('BG')||ol.product_name__c.contains('BB')||ol.product_name__c.contains('MG'))){
                    system.debug('ol.product_name__c'+ol.product_name__c);
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    if(ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Swan-N-DG';
                        }else if(ol.product_name__c.contains('BB')){
                            ol.Product_Type__C ='Swan-N-TB';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Swan-N-SG';
                        }
                    }else if(!ol.product_name__c.contains('N')){
                        if(ol.product_name__c.contains('BG')){
                            ol.Product_Type__C ='Swan-P-DG';
                        }else if(ol.product_name__c.contains('BB')){
                            system.debug('junjun');
                            ol.Product_Type__C ='Swan-P-TB';
                        }else if(ol.product_name__c.contains('MG')){
                            ol.Product_Type__C ='Swan-P-SG';
                        }
                    }
                }
                

                else if((ol.product_name__c.contains('JKM')||ol.product_name__c.Startswith('MM'))&& ol.product_name__c.contains('P-')){
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    if(ol.product_name__c.contains('H')){
                        system.debug('111111');
                        ol.Product_Type__C ='Eagle Poly-HC';
                    }else if(!ol.product_name__c.contains('H')){
                        system.debug('22222');
                        ol.Product_Type__C ='Eagle Poly-FC';
                    }
                }
                
           
                else if(ol.product_name__c.contains('JKM') && !ol.product_name__c.contains('JKMS')){
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(ol.product_name__c.substring(3, 6));
                    if(ol.product_name__c.contains('H')){
                        if(ol.product_name__c.contains('N')){
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=325){
                                    ol.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                if(MW>=395){
                                    ol.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!ol.product_name__c.contains('N')){
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=325){
                                    ol.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                if(MW>=395){
                                    ol.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!ol.product_name__c.contains('H')){
                        if(ol.product_name__c.contains('N')){
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=320){
                                    ol.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                if(MW>=390){
                                    ol.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!ol.product_name__c.contains('N')){
                            system.debug('junjunV3');
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=320){
                                    ol.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    ol.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    ol.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                else if(ol.product_name__c.Startswith('MM')){
                    ol.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(ol.product_name__c.substring(2, 5));
                    if(ol.product_name__c.contains('H')){
                        if(ol.product_name__c.contains('N')){
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=325){
                                    ol.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                if(MW>=395){
                                    ol.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!ol.product_name__c.contains('N')){
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=325){
                                    ol.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                if(MW>=395){
                                    ol.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!ol.product_name__c.contains('H')){
                        if(ol.product_name__c.contains('N')){
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=320){
                                    ol.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                if(MW>=390){
                                    ol.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!ol.product_name__c.contains('N')){
                            system.debug('junjunV3');
                            if(ol.product_name__c.contains('-60')){
                                if(MW>=320){
                                    ol.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    ol.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(ol.product_name__c.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    ol.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    ol.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                
                //else{
                   // ol.Product_Type__C ='';
               // }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
      }
  
  if (Trigger.isInsert || Trigger.isUpdate) {
    for(OpportunityLineItem item: Trigger.new){
    if(item.Product_Type__c!=null){
      if(item.Product_Type__c=='Connector'){
        item.Main_Type__c='Connector';
      }
      else if(item.Product_Type__c.contains('Smart')){
        item.Main_Type__c='Smart';
      }
      else if(item.Product_Type__c.contains('Tiger') && !item.Product_Type__c.contains('Tiger Pro')){
        item.Main_Type__c='Tiger';
      }
      else if(item.Product_Type__c.contains('Tiger Pro')){
        item.Main_Type__c='Tiger Pro';
      }
      else {
              
        item.Main_Type__c='Cheetah(Swan)'; 
      }
      
        }else{
            
          item.Product_Type__c='Cheetah-P-HC';
            item.Main_Type__c='Cheetah(Swan)'; 
            // List<OpportunityLineItem> item2 =new  List<OpportunityLineItem>();
            // item2.add(item);
            // handler = new OpportunityLineItemGrossMarginHandler(item2);
        }
    }
    
    // neo - calculate freight
    System.debug('OpportunityLineItemTrigger');
    OpportunityLineItemGrossMarginHandler handler;
    if (Trigger.isInsert) {
            System.debug('OpportunityLineItemTriggernew');
      for (OpportunityLineItem item : Trigger.new) {
        OpportunityLineItemGrossMarginHandler.containerNeedChangeIds.add(item.OpportunityId); OpportunityLineItemGrossMarginHandler.oceanNeedChangeIds.add(item.OpportunityId);
      }
      handler = new OpportunityLineItemGrossMarginHandler(Trigger.new);
    } else if (Trigger.isUpdate ) {
        System.debug('OpportunityLineItemTriggerupdate');
      for (String Id : Trigger.newMap.keySet()) {
          system.debug(Trigger.oldMap.get(Id).Quantity != Trigger.newMap.get(Id).Quantity);
          if (Trigger.oldMap.get(Id).Quantity != Trigger.newMap.get(Id).Quantity){
            OpportunityLineItemGrossMarginHandler.containerNeedChangeIds.add(Trigger.newMap.get(Id).OpportunityId);OpportunityLineItemGrossMarginHandler.oceanNeedChangeIds.add(Trigger.newMap.get(Id).OpportunityId);OpportunityLineItemGrossMarginHandler.NewProductItemMaps.put(Id,Trigger.newMap.get(Id));

    }
          }
      handler = new OpportunityLineItemGrossMarginHandler(Trigger.new);
    }
    // if (handler != null) update handler.getOpportunityIdMap().values();
    
    List<Opportunity> opportunityList = [
    SELECT Id,
        SOC_Dept__c,
        Finance_Approval_Status__c,
        GM_approval_Status__c,
        Legal_Dept__c,
        Technical_Dept_Status__c,
        Technical_Dept_Comments__c,
        SOC_Dept_Comments__c,
        Finance_Dept_Comments__c,
        GM_approval_Comments__c,
        Legal_Dept_Comments__c,
        Roll_up_SFA_Counts__c,
        VP_Approval_Status__c,
        VP_Approval_comments__c,
        Trade_Term__c
    FROM Opportunity
    WHERE Id IN :MOUOppIdSet
    AND MOU_Type_Judgment__c = true
    ];
    //审批初始化
    if (opportunityList.size() != 0) {
      for (Opportunity newOpp : opportunityList) {
        if (newOpp.Roll_up_SFA_Counts__c == 0){
          newOpp.SOC_Dept__c = '';
          newOpp.Finance_Approval_Status__c = '';
          newOpp.GM_approval_Status__c = '';
          newOpp.Legal_Dept__c = '';
          newOpp.Technical_Dept_Status__c = '';
          newOpp.Technical_Dept_Comments__c = '';
          newOpp.SOC_Dept_Comments__c = '';
          newOpp.Finance_Dept_Comments__c = '';
          newOpp.GM_approval_Comments__c = '';
          newOpp.Legal_Dept_Comments__c = '';
          if(VPapproval){
            newOpp.VP_Approval_Status__c = '';
            newOpp.VP_Approval_comments__c='';
          }
      
        }
      }
      update opportunityList;
    }
  } 
  }
    
    String OppidMOU;
    String tradeterm;
    Boolean tradetermFlag = false;
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            for(OpportunityLineItem item:Trigger.new){
        OppidMOU = item.OpportunityId;
                if(item.Trade_Term__c !=null){
                    tradeterm=item.Trade_Term__c;
                }                
      }
            if(tradeterm !=null){
                 Opportunity opp = [ SELECT Id,
                                    branch__c,
            SOC_Dept__c,
            Finance_Approval_Status__c,
            GM_approval_Status__c,
            Legal_Dept__c,
            Technical_Dept_Status__c,
            Technical_Dept_Comments__c,
            SOC_Dept_Comments__c,
            Finance_Dept_Comments__c,
            GM_approval_Comments__c,
            Legal_Dept_Comments__c,
            Roll_up_SFA_Counts__c,
                  VP_Approval_Status__c,
                  VP_Approval_comments__c,
                  Trade_Term__c,
                        MOU_Type_Judgment__c
        FROM Opportunity
                  WHERE Id = : OppidMOU and MOU_Type_Judgment__c=:true];
                
                List<OpportunityLineItem> itemss = [select id ,OpportunityId,Trade_Term__c from OpportunityLineItem where OpportunityId =:opp.id];
                for(OpportunityLineItem items :itemss){
                    if(items.Trade_Term__c != tradeterm){
                        tradetermFlag =true;
                    }
                }
                if(tradetermFlag == false){
                   // if(Trigger.isAfter){
                      PriceApprovalTools.MouUpdate(opp.Id, tradeterm);
                  // }
                }else{
                    tradeterm = '';
                    PriceApprovalTools.MouUpdate(opp.Id, tradeterm);
                }
                
            }
              
                             
        } 
    }
}