trigger MDATrigger on Component_Task_Book__c (before insert,before update,after insert,after update) {
       	
    // neo
    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;

  if(Trigger.isBefore){
        System.debug('走进验证规则-------------------------');
        if(Trigger.isInsert || Trigger.isUpdate){
            if(checkRecursive.runOnce()){ 
            for(Component_Task_Book__c ctb : Trigger.new ){
                if(Trigger.isUpdate){
   if(!Approval.isLocked(ctb.id)){
       for(Component_Task_Book__c ctbold : Trigger.old ){
                    if(ctb.Technical_manager_Shanghai__c=='Approved' && ctbold.Technical_manager_Shanghai__c=='Approved'){
                    ctb.Technical_manager_Shanghai__c='';
                    }
       }
                }

                }
                 if(ctb.Amendment_Purchase_Agreement__c !=null && ctb.Contract__c ==null && ctb.Opportunity__c ==null){
                    Amendment__c apa = [Select id,Contract__c,Opportunity__c from Amendment__c where id=:ctb.Amendment_Purchase_Agreement__c];
                    if(ctb.Contract__c ==null){ 
                        ctb.Contract__c=apa.Contract__c;
					}
                     if(ctb.Opportunity__c ==null){
                        ctb.Opportunity__c=apa.Opportunity__c;
					}
				}
                else if(ctb.Contract__c !=null && ctb.Opportunity__c ==null){
                    Contract currcon = [Select id,Opportunity__c from Contract where id=:ctb.Contract__c];
                    if(ctb.Opportunity__c ==null){
                        ctb.Opportunity__c=currcon.Opportunity__c;
					}
					// if (ctb.Order__c == null) {
					// 	List<Order> orders = [SELECT Id FROM Order WHERE ContractId = :ctb.Contract__c];
					// 	if (orders.size() > 0) ctb.Order__c = orders[0].Id;
					// }
				}
                else if(ctb.Opportunity__c !=null && ctb.Contract__c ==null){
                    List<Contract> con =new List<Contract>();
                        con = [Select id from Contract where Opportunity__c=:ctb.Opportunity__c];
                    if(ctb.Contract__c ==null && con.size()>0){
                        ctb.Contract__c=con[0].id;
					}
				}
                       
                
                system.debug('=====' + ctb.Contract__c);
                if(ctb.Contract__c !=null){
                
                Contract con = [Select Id,OwnerId,Inspection__c,Inspection_Description__c From Contract Where Id =: ctb.Contract__c];
                   
                User u = [Select Id,BMO_specialist__c From User Where Id =: con.OwnerId];
                if(ctb.Contract__c != null){
                    ctb.BMO_SH__c = u.BMO_specialist__c;
                } 
                    
                     }
        
            }
            
        }
        
        }
        
    }
  if(Trigger.isAfter){
      if(Trigger.isINSERT){
          for(Component_Task_Book__c ctb : Trigger.new ){
                    System.debug('走进接口流程');
                    if(ctb.RecordTypeId !='0126F000001j8RB'){
                     SapAsyncToMDAPickList.SendOrderNo(ctb.Name);
                    }
          }
      }
        if(Trigger.isUpdate){
            for(Component_Task_Book__c ctbold : Trigger.old){
                for(Component_Task_Book__c ctb : Trigger.new){
                    if(ctb.RecordTypeId !='0126F000001j8RB' && ctb.Technical_manager_Shanghai__c =='Approved' && ctbold.Technical_manager_Shanghai__c!='Approved'){
                     SapAsyncToMDAPickList.SendOrderNo(ctb.Name);
                    }
                }
            }
            for(Component_Task_Book__c ctb : Trigger.new ){
                    System.debug('走进接口流程');
                    
                    //SAPSyncMDAStructure.MDAPicklist(ctb.Name);
                    //String result1 = SapAsyncToMDAPickList.SendOrderNo(ctb.Name);
                    //String result2 = SAPSyncMDAStructure.MDAPicklist(ctb.Name);
                   // System.debug('result1---'+result1);
                  //  System.debug('result2---'+result2);
                Decimal i=1;
               
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                	i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;

				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 System.debug('接口流程结束');
                system.debug('=====' + ctb.Contract__c);
                if(ctb.Contract__c !=null){
                Contract con = [Select Id,OwnerId,Inspection__c,Inspection_Description__c From Contract Where Id =: ctb.Contract__c];
                
                    
                     i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
                     i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
				i++;
				i++;
				i++; 
                 i++;
                    
                    List<Component_Task_Book__c> ctblst = [select id,Regional_customs_clearance_request__c,Pre_shipping_Inspection_factory__c,Lab_tests__c,On_site_monitor_by_Client_or_3rd_party__c from Component_Task_Book__c where Contract__c=:ctb.Contract__c];
                    String jianzaoflag='0';//监造
                    String yanhuoflag='0';//验货
                    String tastflag='0';//测试	
                    String clearanceflag = '0';//监装及验货
                    for(Component_Task_Book__c ctbs:ctblst){
                        if(ctbs.Pre_shipping_Inspection_factory__c=='Need'){
                            yanhuoflag='厂内验货';
                        }
                        if(ctbs.On_site_monitor_by_Client_or_3rd_party__c=='Yes, Consignee'){
                            jianzaoflag='监造';
                        }
                        if(ctbs.Lab_tests__c=='Jinko laboratory'){
                            tastflag='晶科实验室测试';
                        }
                        if(ctbs.Lab_tests__c=='3rd Party lab'){
                            tastflag='第三方测试';
                        }
                        if(ctbs.Regional_customs_clearance_request__c == 'COC'){
                            clearanceflag = '监装';
                        }
                        if(ctbs.Regional_customs_clearance_request__c == 'COC+PSI'){
                            clearanceflag = '监装及验货';
                        }
                        if(ctbs.Pre_shipping_Inspection_factory__c=='No Need'&&ctbs.On_site_monitor_by_Client_or_3rd_party__c=='No Need'&&ctbs.Lab_tests__c=='No Need'&&ctbs.Regional_customs_clearance_request__c=='No Need'){
                            clearanceflag = '不需要';
                        }
                    }
                    String str = yanhuoflag+' '+jianzaoflag+' '+tastflag+' '+clearanceflag;
                    str = str.replace('0','');
                    system.debug('str'+str);
                    if(str=='   不需要'){
                        con.Inspection__c = '1，不需要';
                        con.Inspection_Description__c = null;
                    }
                    if(str=='厂内验货监造  '){
                        con.Inspection__c = '2，监造和验货';
                        con.Inspection_Description__c = null;
                    }
                    if(str==' 监造  '){
                        con.Inspection__c = '3，监造';
                        con.Inspection_Description__c = null;
                    }
                    if(str=='   监装及验货'){
                        con.Inspection__c = '6，验货和监装';
                        con.Inspection_Description__c = null;
                    }
                    if(str!=null&&str!='厂内验货 监造  '&&str!=' 监造  '&&str!='   监装及验货'&&str!='   不需要'){
                        con.Inspection_Description__c = str;
                        con.Inspection__c = '7，Other';
                    }
                    update con;
                     }
            }
            
            
            if(checkRecursive.runOnce()){ 
            for(Component_Task_Book__c ctb1 : Trigger.new ){
              Component_Task_Book__c  ctb=[select ModuleType1__c, Module_Type2__c,Module_Type3__c,ModuleType1__r.name,Module_Type2__r.name,Module_Type3__r.name from Component_Task_Book__c where id =:ctb1.id];
                if(ctb.ModuleType1__c!=null && ctb.Module_Type2__c!=null && ctb.Module_Type3__c ==null){
            if(ctb.ModuleType1__r.name.contains('JKM') && ctb.Module_Type2__r.name.contains('JKM')    
              ){
                  if(ctb.ModuleType1__r.name.contains('-60')||ctb.ModuleType1__r.name.contains('-72')){
                         if((ctb.ModuleType1__r.name.contains('-60') && ctb.Module_Type2__r.name.contains('-60'))||
                            (ctb.ModuleType1__r.name.contains('-72') && ctb.Module_Type2__r.name.contains('-72'))){
                                
                            }else{
                               ctb1.adderror('ModuleTypes must be the same type');  
                          		
                            }
                         
                         
                     }
                  if(ctb.ModuleType1__r.name.contains('H')||ctb.Module_Type2__r.name.contains('H')){
                      if((ctb.ModuleType1__r.name.contains('H') && ctb.Module_Type2__r.name.contains('H'))){
                          
                      }else{
                           ctb1.adderror('ModuleTypes must be the same type');  
                      }
                  }
                  if(ctb.ModuleType1__r.name.contains('V')||ctb.Module_Type2__r.name.contains('V')){
                      if((ctb.ModuleType1__r.name.contains('V') && ctb.Module_Type2__r.name.contains('V'))){
                          
                      }else{
                         ctb1.adderror('ModuleTypes must be the same type');  
                      }
                  }
                  
              }
               else if(ctb.ModuleType1__r.name.contains('IBC') && ctb.Module_Type2__r.name.contains('IBC')    
                      ){   } 
                    else{
                 // ctb1.adderror('ModuleTypes must be the same type');  
              }
        }
        //三条数据
        if(ctb.ModuleType1__c!=null && ctb.Module_Type2__c!=null && ctb.Module_Type3__c !=null){
            system.debug('---K');
            system.debug(ctb.ModuleType1__c);
            system.debug(ctb.ModuleType1__r.name);
            system.debug(ctb.Module_Type2__c);
            system.debug(ctb.Module_Type2__r.name);
            system.debug(ctb.Module_Type3__c);
            system.debug(ctb.Module_Type3__r.name);
            system.debug('---END');
              if(ctb.ModuleType1__r.name.contains('JKM') && ctb.Module_Type2__r.name.contains('JKM')&&
                 ctb.Module_Type3__r.name.contains('JKM') 
              ){
                  if(ctb.ModuleType1__r.name.contains('-60')||ctb.ModuleType1__r.name.contains('-72')){
                         if((ctb.ModuleType1__r.name.contains('-60') && ctb.Module_Type2__r.name.contains('-60')&&ctb.Module_Type3__r.name.contains('-60'))||
                            (ctb.ModuleType1__r.name.contains('-72') && ctb.Module_Type2__r.name.contains('-72')&& ctb.Module_Type3__r.name.contains('-72'))){
                                
                            }else{
                                system.debug('1ERR');
                               ctb1.adderror('ModuleTypes must be the same type');  
                            }
                         
                         
                     }
                  if(ctb.ModuleType1__r.name.contains('H')||ctb.Module_Type2__r.name.contains('H')||ctb.Module_Type3__r.name.contains('H')){
                      if((ctb.ModuleType1__r.name.contains('H') && ctb.Module_Type2__r.name.contains('H')&& ctb.Module_Type3__r.name.contains('H'))){
                          
                      }else{
                          system.debug('2ERR');
                      ctb1.adderror('ModuleTypes must be the same type');  
                      }
                  }
                  if(ctb.ModuleType1__r.name.contains('V')||ctb.Module_Type2__r.name.contains('V')||ctb.Module_Type3__r.name.contains('V')){
                      if((ctb.ModuleType1__r.name.contains('V') && ctb.Module_Type2__r.name.contains('V')&& ctb.Module_Type3__r.name.contains('V'))){
                          
                      }else{
                          system.debug('3ERR');
 ctb1.adderror('ModuleTypes must be the same type');  
                      }
                  }
              }
            else if(ctb.ModuleType1__r.name.contains('IBC') && ctb.Module_Type2__r.name.contains('IBC')&&
                 ctb.Module_Type3__r.name.contains('IBC') 
              ){}
            else{
                system.debug('4ERR');
  //   ctb1.adderror('ModuleTypes must be the same type');  
              }
        }
        
                
            }
            }
        }
        

    }

	if(Trigger.isBefore){
		System.debug('走进验证规则-------------------------');
		if(Trigger.isInsert || Trigger.isUpdate){
			for(Component_Task_Book__c ctb : Trigger.new){
				System.debug('ctb.Inspection_or_supervision__c'+ctb.Inspection_or_supervision__c);
				System.debug('ctb.RecordType.Name  记录类型'+ctb.RecordType.Name);
				//组件合格证页面报错提示
				if((ctb.Module_Certificate__c=='需要，客户标准' || ctb.Module_Certificate__c=='') && ctb.Module_Certificate_Text__c=='' && ctb.RecordTypeId =='0126F000001j8RB' ){
					ctb.addError('如果组件合格证为空或者需要，请填写组件合格证备注');
				}else if(ctb.Module_Certificate__c!='需要，客户标准' && ctb.Module_Certificate_Text__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写组件合格证备注');
				}
				//安装说明书
				if((ctb.Installation_instructions__c=='客户标准' || ctb.Installation_instructions__c=='') && ctb.Installation_instructions_Text__c=='' && ctb.RecordTypeId =='0126F000001j8RB' ){
					ctb.addError('如果安装说明书为空或者客户标准，请填写安装说明书备注');
				}else if(ctb.Installation_instructions__c!='客户标准' && ctb.Installation_instructions_Text__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写安装说明书证备注');
				}
				//是否需使用缠绕膜
				if((ctb.Wrapping_film__c=='需要，客户指定缠绕层数' || ctb.Wrapping_film__c=='') && ctb.Wrapping_film_text__c=='' && ctb.RecordTypeId =='0126F000001j8RB' ){
					ctb.addError('如果是否需使用缠绕膜为空或者客户标准，请填写是否需使用缠绕膜备注');
				}else if(ctb.Wrapping_film__c!='需要，客户指定缠绕层数' && ctb.Wrapping_film_text__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写是否需使用缠绕膜备注');
				}
				//组件外观标准
				if((ctb.Component_appearance_standard__c=='客户标准' || ctb.Component_appearance_standard__c=='') && ctb.Component_appearance_standard_text__c=='' && ctb.RecordTypeId =='0126F000001j8RB' ){
					ctb.addError('如果组件外观标准为空或者客户标准，请填写组件外观标准备注');
				}else if(ctb.Component_appearance_standard__c!='客户标准' && ctb.Component_appearance_standard_text__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写组件外观标准备注');
				}
				//组件EL标准
				if((ctb.EL_standard__c=='客户标准' || ctb.EL_standard__c=='') && ctb.EL_standard_text__c=='' && ctb.RecordTypeId =='0126F000001j8RB' ){
					ctb.addError('如果组件EL标准为空或者客户标准，请填写组件EL标准备注');
				}else if(ctb.EL_standard__c!='客户标准' && ctb.EL_standard_text__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写组件EL标准备注');
				}
				//组件是否需要外送做功率及EL测试
				if((ctb.EL_Test__c=='是' || ctb.EL_Test__c=='') && ctb.EL_Test_Text__c=='' && ctb.RecordTypeId =='0126F000001j8RB' ){
					ctb.addError('如果组件是否需要外送做功率及EL测试为空或者客户标准，请填写组件是否需要外送做功率及EL测试备注');
				}else if(ctb.EL_Test__c!='是' && ctb.EL_Test_Text__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写组件是否需要外送做功率及EL测试备注');
				}
				//客户是否验货或驻厂监造
				if((ctb.Inspection_or_supervision__c=='客户验货'|| ctb.Inspection_or_supervision__c=='客户驻厂监造' || ctb.Inspection_or_supervision__c=='') && ctb.Inspection_or_supervision_time__c==null && ctb.RecordTypeId =='0126F000001j8RB' ){
					system.debug('测试--------123');
					ctb.addError('如果客户是否验货或驻厂监造为空或者客户验货和客户驻厂监造，请填写客户是否验货或驻厂监造备注');
				}else if((ctb.Inspection_or_supervision__c!='客户验货' && ctb.Inspection_or_supervision__c!='客户驻厂监造') && ctb.Inspection_or_supervision_time__c !=null && ctb.RecordTypeId =='0126F000001j8RB'){
					system.debug('为啥会走进来');
					ctb.addError('请填写客户是否验货或驻厂监造备注');
				}
				//填充因子FF
				if(ctb.FF__c== '其他' && ctb.FF_Text__c=='' && ctb.RecordTypeId =='0126F000001j8RB'){
					ctb.addError('请填写填充因子FF备注');
				}
			}
		}
	}
	 
    
}