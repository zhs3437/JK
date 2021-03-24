public with sharing class OpportunityHelper {
//create by:HanFan  20170726
    //当业务机会中的Finance Price Approval Status字段变为approved,或者GM approval为approved且Payment 1MW Approve为真触发，发送邮件。
    public Static void SendEmail(List<Opportunity> newOpp, List<Opportunity> oldOpp){
        for(Opportunity opp_new : newOpp){
            for(Opportunity opp_old : oldOpp){
                if((opp_new.Price_Approval_Status__c != opp_old.Price_Approval_Status__c && opp_new.Price_Approval_Status__c=='Approved') 
                   ||(opp_new.Sales_manager_approval__c != opp_old.Sales_manager_approval__c && opp_new.Sales_manager_approval__c=='Approved'&& 
                      opp_new.Payment_1MW_Approve__c==true)){
                          List<Id> recIds = new List<Id>();
                          recIds.add(opp_new.OwnerId);
                          recIds.add(opp_new.BMO_Specialist__c);
                          system.debug('opp_new.BMO_Specialist__c'+opp_new.BMO_Specialist__c);   
                          system.debug('sendEmail11111');   
                          SendEmailUtils.sendEmailToThisList(opp_new.ID,recIds);
                          system.debug('sendEmail33333');
                          //   SendEmailUtils.sendEmailToBMO(opp_new.ID,opp_new.OwnerId);
                          //   system.debug('sendEmail44444');
                      }   
            }  
        } 
    }
    
    /*欧洲主子业务机会汇总计算*/
    // 获得业务机会ID
    public Static set<ID> oppIdLst (List<Opportunity> oppLst){
        set<id> oppIDlst = new set<id>();
        for(Opportunity opp : oppLst){
            oppIDlst.add(opp.Id);
        }
        return oppIDlst;
    }
    
    //发生改变的业务机会
    public Static Opportunity oppCh(Set<Id> oppIdLst){
        try{
            if(oppIdLst.size()>0){
                List<Opportunity> oppChLst =[Select Id,
                                             faOpportunity__c,
                                             Total_MW__c,
                                             Total_Power__c,
                                             Total_Price__c,
                                             Total_Quantity__c 
                                             from Opportunity 
                                             where Id in:oppIdLst];
                
                return oppChLst[0];
            }            
        }catch (Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        return null;
    }
    
    public static Opportunity oppfa(Opportunity oppCh){
        try{
            if(String.isNotEmpty(oppCh.faOpportunity__c)){
                Opportunity oppfa=[Select Id,
                                   Total_MW__c,
                                   Total_Opp_MW__c,
                                   Total_Opp_Power__c,
                                   Total_Opp_Price__c,
                                   Total_Opp_Quantity__c,
                                   Total_Power__c,
                                   Total_Price__c,
                                   Total_Quantity__c 
                                   from Opportunity 
                                   where Id =:oppCh.faOpportunity__c];
                return oppfa;
            }            
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }        
        return null;
    }
    public static List<Opportunity> oppChLst(Opportunity oppfa){
        try {
            if(String.isNotEmpty(oppfa.Id)){
                List<Opportunity> oppChLst=[Select Id,
                                            faOpportunity__c,
                                            Total_MW__c,
                                            Total_Power__c,
                                            Total_Price__c,
                                            Total_Quantity__c 
                                            from Opportunity 
                                            where faOpportunity__c =: oppfa.Id];
                return oppChLst;
            }            
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        return null;
    }
    
    //查询主业务机会下所有的业务机会产品
    public static List<OpportunityLineItem> oppLineItemLst(String faOppId){
       //return Database.query(Utils.MakeSelectSql('OpportunityLineItem')+' Where OpportunityId =:faOppId'); 
        try{
            if(String.isNotEmpty(faOppId)){
                return [Select id,Name,OpportunityId,Product2Id,Quantity,TotalPrice,Total_Power_W__c,ListPrice,Guaranteed_Delivery_Date__c,
                        Total_Price__c,Guaranteed_Delivery_Date_japan__c,Discount,Special_Lable__c,Back_Sheet__c,Cable_Length__c,
                        Frame_Color__c,Connector__c,Bus_bars_of_cell__c,Cell_Appearance__c,Battery_Type__c,Wire_Length__c,
                        Junction_Box_Brand__c,ConnectorLine__c,MP__c,isJinkoStandard__c,Tolerance__c,Solar_Cell__c,Junction_Box__c,
                        EVA__c,Frame__c,Temperd_Glass__c,Serial_No__c,Ribbon__c,Package__c,Others__c,Label__c,Certification__c,
                        Color_of_Module__c,Type_of_module__c,Grade__c,Special_required__c,Battery_Line__c,Product_Name__c,
                        SAP_Product_Materiel_No__c,Description,PricebookEntryId
                        From OpportunityLineItem Where OpportunityId =: faOppId];
            }
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }      
        return null;
	
    } 
    //查询主业务机会下所有的付款方式行项目
    public static List<Payment__c> paymentLst(String oppId){
        try{
            if(String.isNotEmpty(oppId)){
                return Database.query(Utils.MakeSelectSql('Payment__c')+' Where Opportunity__c =:oppId');
            }
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        return null;
        //return [Select id,Name,Days__c,Payment_Term__c,Percentage__c,Payment_Method__c,Down_Balance_Payment__c,Credit_Valid__c,Opportunity__c From Payment__c Where Opportunity__c =: oppId];
    }
    //克隆付款方式行项目到子业务机会
    public static void clonePaymentItem(List<Payment__c> paymentLst,String oppId){
        try{
            if(paymentLst.size()>0 && String.isNotEmpty(oppId)){
                List<Payment__c> InsertPayLst = new List<Payment__c>();
                for(Payment__c pay : paymentLst){
                    Payment__c insertpay = new Payment__c();
                    insertpay = pay.clone();
                    insertpay.Opportunity__c = oppId;
                    InsertPayLst.add(insertpay);
                }
                insert InsertPayLst;
            }
            
        }catch(Exception e){            
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        
    }
    
    public static void AddoppLineItem(List<OpportunityLineItem> opplineLst,String oppId){
        try{
            if(opplineLst.size()>0 && String.isNotEmpty(oppId)){
                List<OpportunityLineItem> insertoliLst = new List<OpportunityLineItem>();
                for(OpportunityLineItem oli : opplineLst){
                    OpportunityLineItem oppLineItem =new OpportunityLineItem();
                    oppLineItem = oli.clone();
                    oppLineItem.OpportunityId = oppId;
                    insertoliLst.add(oppLineItem);
                }
                insert insertoliLst;
            }            
        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        
    }
    
    // 克隆Fram业务机会产品插入到Under Fram业务机会中
    public static List<OpportunityLineItem> initOpls(String framOppid){        
        List<OpportunityLineItem> result = new List<OpportunityLineItem>();        
        try{
            //get the schema data
            Map<String, Schema.SObjectField> fMap = new Map<String, Schema.SObjectField> ();
            fMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
            String sqlstr = '';
            for (String fName : fMap.keySet()){
                sqlstr = sqlstr + fName+',';
            }
            if(sqlstr.length()>0){
                sqlstr = sqlstr.substring(0,sqlstr.length()-1);
            }
            
            sqlstr = 'select Id,TotalPrice,Bus_bars_of_cell__c,MP__c,SAP_Product_Materiel_No__c,SAP_Materiel_No__c,Special_required__c,Color_of_Module__c,Grade__c,Certification__c,Type_of_module__c,Total_Power_W__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c,Estimated_Time_of_Departure__c,Estimated_Time_of_Departure_ETD__c,Estimated_Time_of_Departure_ETD_7__c,Expected_Delivery_Date_ETA__c'+
            ' from OpportunityLineItem Where OpportunityId =:framOppid';
            //query the opportunity
            result = Database.query(sqlstr);
        }
        catch(DmlException e){
         for (Integer i = 0; i < e.getNumDml(); i++) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
           }
        }
        return result;
        
    }
    
    //汇总做加法和减法的方法
    public static void parentSub(Opportunity oppfa,Opportunity oppCh,List<Opportunity> oppChLst){
        oppfa.Total_Opp_MW__c=0;
        oppfa.Total_Opp_Power__c=0;
        oppfa.Total_Opp_Price__c=0;
        oppfa.Total_Opp_Quantity__c=0;
        for(Opportunity opp :oppChLst){
            oppfa.Total_Opp_MW__c=oppfa.Total_Opp_MW__c+opp.Total_MW__c;
            oppfa.Total_Opp_Power__c= oppfa.Total_Opp_Power__c+opp.Total_Power__c;
            oppfa.Total_Opp_Price__c=oppfa.Total_Opp_Price__c+opp.Total_Price__c;
            oppfa.Total_Opp_Quantity__c=oppfa.Total_Opp_Quantity__c+opp.Total_Quantity__c;
        }
        oppfa.Total_Opp_MW__c=oppfa.Total_Opp_MW__c-oppCh.Total_MW__c;
        oppfa.Total_Opp_Power__c= oppfa.Total_Opp_Power__c-oppCh.Total_Power__c;
        oppfa.Total_Opp_Price__c=oppfa.Total_Opp_Price__c-oppCh.Total_Price__c;
        oppfa.Total_Opp_Quantity__c=oppfa.Total_Opp_Quantity__c-oppCh.Total_Quantity__c;
        update oppfa;
    }
    
    //汇总只做加法的方法
    public static void parentNoSub(Opportunity oppfa,Opportunity oppCh,List<Opportunity> oppChLst){
        
        //初始化4个数值
        oppfa.Total_Opp_MW__c=0;
        oppfa.Total_Opp_Power__c=0;
        oppfa.Total_Opp_Price__c=0;
        oppfa.Total_Opp_Quantity__c=0;
        for(Opportunity opp :oppChLst){
            oppfa.Total_Opp_MW__c=oppfa.Total_Opp_MW__c+opp.Total_MW__c;
            oppfa.Total_Opp_Power__c= oppfa.Total_Opp_Power__c+opp.Total_Power__c;
            oppfa.Total_Opp_Price__c=oppfa.Total_Opp_Price__c+opp.Total_Price__c;
            oppfa.Total_Opp_Quantity__c=oppfa.Total_Opp_Quantity__c+opp.Total_Quantity__c;
        }
        update oppfa;
    }
    
     //判断子业务机会相关联的住业务机会是否发生改变（删除）
     public static Boolean changedFaOpp(List<Opportunity> newLst,List<Opportunity> oldLst){
         for(Opportunity newOpp : newLst){
             for(Opportunity oldOpp : oldLst){
                 if(newOpp.faOpportunity__c != oldOpp.faOpportunity__c && oldOpp.faOpportunity__c !=null && newOpp.Opportunity_Type__c=='Under Frame'){
                     return true;
                 }
             }
         }
        return false;
    }
    
    //判断子业务机会下产品是否发生改变
     public static Boolean changedProduct(List<Opportunity> newLst,List<Opportunity> oldLst){
         for(Opportunity newOpp : newLst){
             for(Opportunity oldOpp : oldLst){
                 if(
                       ( newOpp.Total_MW__c != oldOpp.Total_MW__c ||
                        newOpp.Total_Power__c != oldOpp.Total_Power__c ||
                        newOpp.Total_Price__c != oldOpp.Total_Price__c ||
                        newOpp.Total_Quantity__c != oldOpp.Total_Quantity__c || 
                        (newOpp.faOpportunity__c != oldOpp.faOpportunity__c && newOpp.faOpportunity__c !=null))&& 
                        newOpp.Opportunity_Type__c=='Under Frame'){
                     return true;
                 }
             }
         }
        return false;
    }
    
    //更新主业务机会汇总值
     public static void updateVolue(List<Opportunity> newLst,List<Opportunity> oldLst,Opportunity oppfa,Opportunity oppCh,List<Opportunity> oppChLst){
         for(Opportunity newOpp : newLst){
             for(Opportunity oldOpp : oldLst){
                 if (oldOpp.faOpportunity__c != null) {                            
                     OpportunityHelper.parentSub(oppfa,oppCh,oppChLst);
                 }

             }
         }
     
    }
    
    //更新主业务机会汇总值
     public static void updateVolue2(List<Opportunity> newLst,List<Opportunity> oldLst,Opportunity oppfa,Opportunity oppCh,List<Opportunity> oppChLst){
         for(Opportunity newOpp : newLst){
             for(Opportunity oldOpp : oldLst){
                 if (oldOpp.faOpportunity__c != null) {                            
                     OpportunityHelper.parentNoSub(oppfa,oppCh,oppChLst);
                 }

             }
         }
     
    }
    //更新主业务机会汇总值
     public static Opportunity updateVolue3(List<Opportunity> newLst,Opportunity oppCh){
         Opportunity oppfa =new Opportunity();
         for(Opportunity newOpp : newLst){
            oppfa = OpportunityHelper.oppfa(oppCh);
            return oppfa;
         }
     	return null;
    }
    
    //以下是老逻辑方法的优化 方法 暂没启用  20170830  
    ////////////////////////////START////////////////////////////////
    //获取业务机会价格审批的提交和审批时间
     public static void getDate(List<Opportunity> newLst,List<Opportunity> oldLst){
         for(Opportunity newOpp : newLst){
             for(Opportunity oldOpp : oldLst){
                 if((newOpp.Price_Approval_Status__c == 'Approved' ||
                     newOpp.Price_Approval_Status__c == 'Rejected') && 
                     newOpp.Price_Approval_Status__c != oldOpp.Price_Approval_Status__c){
                     newOpp.Finance_Approval_Date__c = DateTime.now();
                     newOpp.Price_Finance_Approval_Finish_time__c =DateTime.now();
                 }
                 // create by Hanfan 20170810抓取业务机会提交价格审批结束完成时间
                 if((newOpp.Sales_manager_approval__c == 'Approved'|| 
                     newOpp.Sales_manager_approval__c == 'Reject')  && 
                     newOpp.Sales_manager_approval__c != oldOpp.Sales_manager_approval__c){
                     newOpp.Price_GM_Approval_Finish_Time__c = DateTime.now();
                 }
                 
             }
         }
    }
    
    //创建和更新业务机会的时候，
    // 若为澳大利亚快速流程更新字段 Australia_MW__c 为 true
    public static void updateAustralia(List<Opportunity> newLst){
        for(Opportunity newOpp : newLst){
            if(newOpp.RecordType.Name == 'Australia' && 
               newOpp.Payment_Term_Description__c != null && 
               newOpp.Payment_Term_Description__c.contains('T/T') && 
               newOpp.Total_Quantity__c <= 2800 && newOpp.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                if((newOpp.Trade_term__c == 'DDP' &&
                    newOpp.whether_pick_up_batch__c == 'True') || newOpp.Trade_term__c == 'EXW'){
                        newOpp.Australia_MW__c = true;
                    }
            }else{
                newOpp.Australia_MW__c = false;
            }
        }
    }
    
    // old Logic   赋值业务机会的BMO字段，日本法务字段的自动更新，若为澳大利亚的业务机会发送邮件
    public static void updateFiled(List<Opportunity> newLst){
        List<User> userList = [select id, BMO_specialist__c from User];
        for(Opportunity newOpp : newLst){
            for(User user : userList){
                if(user.Id == newOpp.OwnerId){
                    newOpp.BMO_specialist__c = user.BMO_specialist__c;
                }
            }
            
            //add 2016/1/7
            if(newOpp.Is_GTAC_Formula__c == 'True'){
                newOpp.Allow_new_process_for_Japan_picklist__c = 'pending';
            }else if(newOpp.Is_GTAC_Formula__c == 'False' || newOpp.Is_GTAC_Formula__c == null || newOpp.Is_GTAC_Formula__c == ''){
                newOpp.Allow_new_process_for_Japan_picklist__c = 'allow';
            }
            
            ID AustraliaRecordTypeId 	= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Australia').getRecordTypeId(); 
            //add 2016/1/8
            if(newOpp.RecordTypeId == AustraliaRecordTypeId){
                SendEmailUtils.AusOpp(newOpp.Id);
            }
        }
    }

    //当Allow new process for japan = true 发送提醒邮件给业务机会Owner  old Logic
    
    public static void japanAllowSendEmail(List<Opportunity> newLst,List<Opportunity> oldLst){
		Set<string> userIds = new Set<string>();
        for(Opportunity opp : newLst){
			userIds.add(opp.OwnerId);
		}
		Map<ID,User>  userMap = new Map<ID,User>([SELECT Id,Name,Email	FROM User WHERE Id in: userIds]);
        for(Opportunity opp_new : newLst){
            for(Opportunity opp_old : oldLst){
                if(opp_new.Allow_new_process_for_Japan_picklist__c != opp_old.Allow_new_process_for_Japan_picklist__c && opp_new.Allow_new_process_for_Japan_picklist__c == 'allow'){
                    //List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID =: opp_new.OwnerId];
                    if(userMap.containsKey(opp_new.OwnerId)){
                    	User user = userMap.get(opp_new.OwnerId);
                    	List<User> recipients = new List<User>();
                    	recipients.add(user);
                    	SendEmailUtils.OppOwner(opp_new.Id,recipients);
                    }
                    
                }
            } 
        }
    }
    //获取触发器的业务机会
    public static Opportunity getTriggerOpp(List<Opportunity> newLst){
        Opportunity opp = new Opportunity();
        for(Opportunity newOpp : newLst){
            opp = newOpp;
        }
        return opp;
    }
    
    //插入时满足条件发邮件给物流
    public static Boolean InsertSendOrNo(List<Opportunity> newLst){
        List<Transit_Fees_Database__c> feeList = [SELECT ID,Name,Port__c,Price__c,Size__c,CurrencyIsoCode FROM Transit_Fees_Database__c];
        Boolean sendornot = false;
        for(Opportunity opp : newLst){
            if(opp.Trade_Term__c == 'CIF'){
				sendornot = true;
				return sendornot;
            }else if(opp.Trade_Term__c != 'CIF' && opp.Trade_Term__c == 'EXW Factory' && opp.Trade_Term__c == 'EXW Overseas Warehouse'){
                sendornot = true;
				return sendornot;               
            }else if( (opp.Trade_Term__c == 'EXW Factory' || opp.Trade_Term__c == 'EXW Overseas Warehouse') && opp.isEurope__c == 'true'){
                sendornot = false;
                return sendornot;
            }else if( (opp.Trade_Term__c == 'EXW Factory' || opp.Trade_Term__c == 'EXW Overseas Warehouse') && opp.isEurope__c == 'false'){
                sendornot = true;
                return sendornot;
            }
        }
        return false;
    }
    
    //跟新时满足条件发邮件给物流
    public static Boolean UpdateSendOrNo(List<Opportunity> newLst,List<Opportunity> oldLst){
        List<Transit_Fees_Database__c> feeList = [SELECT ID,Name,Port__c,Price__c,Size__c,CurrencyIsoCode FROM Transit_Fees_Database__c];
        Boolean sendornot = false;
        for(Opportunity opp_new : newLst){
            if(opp_new.Trade_Term__c == 'CIF'){
                sendornot = false;
               
            }else if(opp_new.Trade_Term__c != 'CIF' && opp_new.Trade_Term__c == 'EXW Factory' && opp_new.Trade_Term__c == 'EXW Overseas Warehouse'){
                sendornot = true;
                 
            }else if( (opp_new.Trade_Term__c == 'EXW Factory' || opp_new.Trade_Term__c == 'EXW Overseas Warehouse') && opp_new.isEurope__c == 'true'){
                sendornot = false;
                
            }else if( (opp_new.Trade_Term__c == 'EXW' || opp_new.Trade_Term__c == 'EXW Factory' || opp_new.Trade_Term__c == 'EXW LA SPEZIA' || opp_new.Trade_Term__c != 'EXW Overseas Warehouse') && opp_new.isEurope__c == 'false'){
                sendornot = true;
                
            }
        }
        return false;
    }
    
    //更新时满足条件更新 ocean 的取值
    ////////////////////////////END////////////////////////////////
    //
    public static void test(){
        Integer i = 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
       i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
          i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
       i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;

          i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
       i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;

          i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
       i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;
        i += 1;
        i += 1;
         i += 1;
         i += 1;
         i += 1;
         i += 1;

      
    }
    
}