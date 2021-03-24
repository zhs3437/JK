public class SameNameOfProduct {
    public SameNameOfProduct(){
        
    }
    public static String  sameNameError(List<Id> ids){        
        String reStr = '';
        List<Product_Detail__c> orderItemList = [select id,Name,
                                                 Contract_PO_PI__c,
                                                 Product_Name__c,
                                                 Product__c,
                                                 Quantity__c,
                                                 Cable_Length__c,
                                                 Tolerance__c 
                                                 From Product_Detail__c 
                                                 Where id =: ids];
        system.debug('ids------>'+ids);
        List<Component_Task_Book__c> ctbLst = [Select id,Contract__c,
                                               ModuleType1__r.Name,
                                               Module_Type2__r.Name,
                                               Module_Type3__r.Name 
                                               From Component_Task_Book__c 
                                               Where Contract__c =: orderItemList[0].Contract_PO_PI__c];
        
        Contract con = [select id,Region__c from Contract where id=:orderItemList[0].Contract_PO_PI__c];
        if(ctbLst.size()>0 && orderItemList.size()>0){
            for(Product_Detail__c pd : orderItemList){
                for(Component_Task_Book__c ctb : ctbLst){
                    if(pd.Product_Name__c == ctb.ModuleType1__r.Name && con.Region__c!='North America'){
                        reStr = 'You can not select ' + ctb.ModuleType1__r.Name +',because it was created before.';  
                        return reStr;
                    }
                    if(pd.Product_Name__c == ctb.Module_Type2__r.Name && con.Region__c!='North America'){
                        reStr = 'You can not select ' + ctb.Module_Type2__r.Name +',because it was created before.';  
                        return reStr;
                    }
                    if(pd.Product_Name__c == ctb.Module_Type3__r.Name && con.Region__c!='North America'){
                        reStr = 'You can not select ' + ctb.Module_Type3__r.Name +',because it was created before.';  
                        return reStr; 
                    }
                }
            }
            
        }
      //两条数据
        if(orderItemList.size()==2){
            if(orderItemList[0].Product_Name__c.contains('JKM') && orderItemList[1].Product_Name__c.contains('JKM')    
              ){
                  if(orderItemList[0].Product_Name__c.contains('-60')||orderItemList[0].Product_Name__c.contains('-72')){
                         if((orderItemList[0].Product_Name__c.contains('-60') && orderItemList[1].Product_Name__c.contains('-60'))||
                            (orderItemList[0].Product_Name__c.contains('-72') && orderItemList[1].Product_Name__c.contains('-72'))){
                                
                            }else{
                                reStr = 'ModuleTypes must be the same type';  
                          		return reStr; 
                            }
                         
                         
                     }
                  if(orderItemList[0].Product_Name__c.contains('H')||orderItemList[1].Product_Name__c.contains('H')){
                      if((orderItemList[0].Product_Name__c.contains('H') && orderItemList[1].Product_Name__c.contains('H'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
                  if(orderItemList[0].Product_Name__c.contains('V')||orderItemList[1].Product_Name__c.contains('V')){
                      if((orderItemList[0].Product_Name__c.contains('V') && orderItemList[1].Product_Name__c.contains('V'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
                //新增
                if(orderItemList[0].Product_Name__c.contains('B')||orderItemList[1].Product_Name__c.contains('B')){
                    if(orderItemList[0].Product_Name__c.contains('B') && orderItemList[1].Product_Name__c.contains('B') &&
                            !orderItemList[0].Product_Name__c.contains('BD') && !orderItemList[1].Product_Name__c.contains('BD') &&
                            !orderItemList[0].Product_Name__c.contains('MBB') && !orderItemList[1].Product_Name__c.contains('MBB')
                    ){

                    }else{
                        if( (orderItemList[0].Product_Name__c.contains('BD') && orderItemList[1].Product_Name__c.contains('BD') ) ||
                                (orderItemList[0].Product_Name__c.contains('MBB') && orderItemList[1].Product_Name__c.contains('MBB') )
                        ){

                        }else{
                            reStr = 'ModuleTypes must be the same type';
                            return reStr;
                        }
                    }
                }
                  
              }
            else if(orderItemList[0].Product_Name__c.contains('IBC') && orderItemList[1].Product_Name__c.contains('IBC')    ){}
             else if(orderItemList[0].Product_Name__c.contains('MM') && orderItemList[1].Product_Name__c.contains('MM')    ){}
            else{
                  reStr = 'ModuleTypes must be the same type';  
                  return reStr; 
              }
        }
        //三条数据
        if(orderItemList.size()==3){
              if(orderItemList[0].Product_Name__c.contains('JKM') && orderItemList[1].Product_Name__c.contains('JKM')&&
                 orderItemList[2].Product_Name__c.contains('JKM') 
              ){
                  if(orderItemList[0].Product_Name__c.contains('-60')||orderItemList[0].Product_Name__c.contains('-72')){
                         if((orderItemList[0].Product_Name__c.contains('-60') && orderItemList[1].Product_Name__c.contains('-60')&&orderItemList[2].Product_Name__c.contains('-60'))||
                            (orderItemList[0].Product_Name__c.contains('-72') && orderItemList[1].Product_Name__c.contains('-72')&& orderItemList[2].Product_Name__c.contains('-72'))){
                                
                            }else{
                                reStr = 'ModuleTypes must be the same type';  
                          		return reStr; 
                            }
                         
                         
                     }
                  if(orderItemList[0].Product_Name__c.contains('H')||orderItemList[1].Product_Name__c.contains('H')||orderItemList[2].Product_Name__c.contains('H')){
                      if((orderItemList[0].Product_Name__c.contains('H') && orderItemList[1].Product_Name__c.contains('H')&& orderItemList[2].Product_Name__c.contains('H'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
                  if(orderItemList[0].Product_Name__c.contains('V')||orderItemList[1].Product_Name__c.contains('V')||orderItemList[2].Product_Name__c.contains('V')){
                      if((orderItemList[0].Product_Name__c.contains('V') && orderItemList[1].Product_Name__c.contains('V')&& orderItemList[2].Product_Name__c.contains('V'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
                  //新增
                  if(orderItemList[0].Product_Name__c.contains('B') || orderItemList[1].Product_Name__c.contains('B') || orderItemList[2].Product_Name__c.contains('B')){
                      if(orderItemList[0].Product_Name__c.contains('B') && orderItemList[1].Product_Name__c.contains('B') && orderItemList[2].Product_Name__c.contains('B') &&
                              !orderItemList[0].Product_Name__c.contains('BD') && !orderItemList[1].Product_Name__c.contains('BD') && !orderItemList[2].Product_Name__c.contains('BD') &&
                              !orderItemList[0].Product_Name__c.contains('MBB') && !orderItemList[1].Product_Name__c.contains('MBB') && !orderItemList[2].Product_Name__c.contains('MBB')
                      ){

                      }else{
                          if( (orderItemList[0].Product_Name__c.contains('BD') && orderItemList[1].Product_Name__c.contains('BD') && !orderItemList[2].Product_Name__c.contains('BD')) ||
                                  (orderItemList[0].Product_Name__c.contains('MBB') && orderItemList[1].Product_Name__c.contains('MBB') && orderItemList[2].Product_Name__c.contains('MBB'))
                          ){

                          }else{
                              reStr = 'ModuleTypes must be the same type';
                              return reStr;
                          }

                      }
                  }

              }
            ELSE if(orderItemList[0].Product_Name__c.contains('IBC') && orderItemList[1].Product_Name__c.contains('IBC')&&
                 orderItemList[2].Product_Name__c.contains('IBC') 
                   ){}
                         else if(orderItemList[0].Product_Name__c.contains('MM') && orderItemList[1].Product_Name__c.contains('MM') && orderItemList[2].Product_Name__c.contains('MM')    ){}
            else{
                  reStr = 'ModuleTypes must be the same type';  
                  return reStr; 
              }
        }
        
        return 'Success';
    }
    
    public static String  sameNameError2(List<Id> ids){        
        String reStr = '';
        List<OpportunityLineItem> orderItemList = [select id,Name,
                                                   OpportunityId,
                                                   product2Id,
                                                   product2.Name,
                                                   Quantity
                                                   From OpportunityLineItem  
                                                   Where id =: ids];
        system.debug('ids------>'+ids);
        system.debug('productName------------------->'+orderItemList[0].product2.Name);
        system.debug('OpportunityId---------->'+orderItemList[0].OpportunityId);
        List<Component_Task_Book__c> ctbLst = [Select id,Opportunity__c,
                                               ModuleType1__r.Name,
                                               Module_Type2__r.Name,
                                               Module_Type3__r.Name 
                                               From Component_Task_Book__c 
                                               Where Opportunity__c =: orderItemList[0].OpportunityId];
        
        
        if(ctbLst.size()>0 && orderItemList.size()>0){
            for(OpportunityLineItem pd : orderItemList){
                for(Component_Task_Book__c ctb : ctbLst){
                    if(pd.product2.Name == ctb.ModuleType1__r.Name){
                        reStr = 'You can not select ' + ctb.ModuleType1__r.Name +',because it was created before.';  
                        return reStr;
                    }
                    if(pd.product2.Name == ctb.Module_Type2__r.Name){
                        reStr = 'You can not select ' + ctb.Module_Type2__r.Name +',because it was created before.';  
                        return reStr;
                    }
                    if(pd.product2.Name == ctb.Module_Type3__r.Name){
                        reStr = 'You can not select ' + ctb.Module_Type3__r.Name +',because it was created before.';  
                        return reStr; 
                    }
                }
            }
            
        }
        //两条数据
        if(orderItemList.size()==2){
            system.debug('测试长度2');
             //基于所有包含（JKM）版型
            if(orderItemList[0].product2.Name.contains('JKM') && orderItemList[1].product2.Name.contains('JKM')    
              ){
                  if(orderItemList[0].product2.Name.contains('-60')||orderItemList[0].product2.Name.contains('-72')){
                         if((orderItemList[0].product2.Name.contains('-60') && orderItemList[1].product2.Name.contains('-60'))||
                            (orderItemList[0].product2.Name.contains('-72') && orderItemList[1].product2.Name.contains('-72'))){
                                
                            }else{
                                reStr = 'ModuleTypes must be the same type';  
                          		return reStr; 
                            }
                         
                         
                     }
                  if(orderItemList[0].product2.Name.contains('H')||orderItemList[1].product2.Name.contains('H')){
                      if((orderItemList[0].product2.Name.contains('H') && orderItemList[1].product2.Name.contains('H'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
                  if(orderItemList[0].product2.Name.contains('V')||orderItemList[1].product2.Name.contains('V')){
                      if((orderItemList[0].product2.Name.contains('V') && orderItemList[1].product2.Name.contains('V'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
              }
           ELSE if(orderItemList[0].product2.Name.contains('MM') && orderItemList[1].product2.Name.contains('MM')    
                  ){}
            else{
                  reStr = 'ModuleTypes must be the same type';  
                  return reStr; 
              }
        }
        //三条数据
        if(orderItemList.size()==3){
            //基于所有包含（JKM）版型
              if(orderItemList[0].product2.Name.contains('JKM') && orderItemList[1].product2.Name.contains('JKM')&&
                 orderItemList[2].product2.Name.contains('JKM') 
              ){
                  if(orderItemList[0].product2.Name.contains('-60')||orderItemList[0].product2.Name.contains('-72')){
                         if((orderItemList[0].product2.Name.contains('-60') && orderItemList[1].product2.Name.contains('-60')&&orderItemList[2].product2.Name.contains('-60'))||
                            (orderItemList[0].product2.Name.contains('-72') && orderItemList[1].product2.Name.contains('-72')&& orderItemList[2].product2.Name.contains('-72'))){
                                
                            }else{
                                reStr = 'ModuleTypes must be the same type';  
                          		return reStr; 
                            }
                         
                         
                     }
                  if(orderItemList[0].product2.Name.contains('H')||orderItemList[1].product2.Name.contains('H')||orderItemList[2].product2.Name.contains('H')){
                      if((orderItemList[0].product2.Name.contains('H') && orderItemList[1].product2.Name.contains('H')&& orderItemList[2].product2.Name.contains('H'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
                  if(orderItemList[0].product2.Name.contains('V')||orderItemList[1].product2.Name.contains('V')||orderItemList[2].product2.Name.contains('V')){
                      if((orderItemList[0].product2.Name.contains('V') && orderItemList[1].product2.Name.contains('V')&& orderItemList[2].product2.Name.contains('V'))){
                          
                      }else{
                          reStr = 'ModuleTypes must be the same type';  
                          return reStr; 
                      }
                  }
              }
            
                       ELSE if(orderItemList[0].product2.Name.contains('MM') && orderItemList[1].product2.Name.contains('MM')  && orderItemList[2].product2.Name.contains('MM')    
                  ){}
            else{
                  reStr = 'ModuleTypes must be the same type';  
                  return reStr; 
              }
        }
        return 'Success';
    }
}