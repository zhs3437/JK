trigger OpportunityTrigger on Opportunity (before insert, before update,after insert,after update) {

    // neo
    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;

    public static boolean EmailFlag = false;
    public static Integer EmailTimes = 0;

    /*
	 * 创建和更新业务机会的时候，当非日本，澳大利亚，北美，若为快速流程更新字段 Global_MW__c 为 true
	 */
    //ID AustraliaRecordTypeId 	= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Australia').getRecordTypeId(); 
    ID AustraliaRecordTypeId ='0126F000001BRq2';
    ID JapanRecordTypeId = '0126F000001BRlR';		

    system.debug('OPPTriggerSTARTxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    List<Id> ids = new List<Id>();
    if(Trigger.isafter && Trigger.isinsert){
        //if(checkRecursive.runOnce5()){ 
        System.debug('101测试20200512——1');
        
        for(Opportunity opp : trigger.new){ 
            ids.add(opp.id);
        }
        
        Opportunity oppChange = [select ContactId from Opportunity where id =:ids]; 
        if(oppChange.ContactId != null){
            Contact conChange = [select name,Actual_Sales_Name__c from Contact where id =:oppChange.ContactId]; 
            oppChange.Actual_Sales_Name__c = conChange.Actual_Sales_Name__c;
            update oppChange;
        }
        // }      
    }
    system.debug('OPPTriggerSTART');
    if(Trigger.isBefore && Trigger.isUpdate){
        if(checkRecursive.runOnce5()){
            System.debug('101测试20200512——2');
            List<String> oppid = new List<String>(); 
            for(Opportunity opp : trigger.new){
                oppid.add(opp.ID);   
                for(Opportunity opp_old : trigger.old){
                    IF((opp.CEO_Approval_Status__c !=opp_old.CEO_Approval_Status__c || opp.CFO_Approval_Status__c !=opp_old.CFO_Approval_Status__c || opp.VP_Approval_Status__c !=opp_old.VP_Approval_Status__c)
                    && opp.CEO_Approval_Status__c=='Approved'&& opp.VP_Approval_Status__c=='Approved'){
                        Commission_Application__c c=   [Select id,Commission_Per_watt__c
                                                        from Commission_Application__c where opportunity__c=:opp.id order by CreatedDate DESC][0];
                        opp.Commision__c=c.Commission_Per_watt__c;
                        opp.Commission_Type__c='Per/W';
                    }
                    
                    if((opp.Price_Approval_Status__c == 'Approved' || opp.Price_Approval_Status__c == 'Rejected') && opp.Price_Approval_Status__c !=opp_old.Price_Approval_Status__c){
                        opp.Finance_Approval_Date__c = DateTime.now();
                        opp.Price_Finance_Approval_Finish_time__c =DateTime.now();
                    }
                    // create by Hanfan 20170810抓取业务机会提交价格审批结束完成时间
                    if((opp.Sales_manager_approval__c == 'Approved'|| opp.Sales_manager_approval__c == 'Reject')  &&  opp.Sales_manager_approval__c !=opp_old.Sales_manager_approval__c){
                        opp.Price_GM_Approval_Finish_Time__c	 =DateTime.now();
                    }
                    if((opp.Cross_region_GM_approval__c == 'Approved'|| opp.Cross_region_GM_approval__c == 'Reject')  &&  opp.Cross_region_GM_approval__c !=opp_old.Cross_region_GM_approval__c){
                        opp.Cross_region_GM_Finish_Time__c	 =DateTime.now();
                    } 
                    if((opp.Sales_Dept__c == 'Approved'|| opp.Sales_Dept__c == 'Rejected')  &&  opp.Sales_Dept__c !=opp_old.Sales_Dept__c){
                        opp.Price_Sales_Manage_Approval_Finish_Time__c	 =DateTime.now();
                    }
                
                }

                if(opp.RecordType.Name == 'Australia' && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T') && opp.Total_Quantity__c <= 2800 && opp.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                    if((opp.Trade_term__c == 'DDP' && opp.whether_pick_up_batch__c == 'True') || opp.Trade_term__c == 'EXW'){
                            opp.Australia_MW__c = true;
                        }
                }else{
                    opp.Australia_MW__c = false;
                }
            }
            if(oppid.size()>0){
                system.debug('oppid***********'+oppid);
                List<Opportunity> opp2List =[Select id,convertCurrency(Total_Price__c) from Opportunity where id in:oppid];
                system.debug('opp2List***********'+opp2List.size());
                for(Opportunity opp_new : trigger.new){
                    for(Opportunity opp : opp2List){
                        if(opp.id == opp_new.id){
                            opp_new.Total_Price_Another__c=opp.Total_Price__c;  
                        }
                    }
                }
            }
        }
    }
    
    
    
    //end
    if(Trigger.isBefore && Trigger.isInsert){
        if(checkRecursive.runOnce13()){
            String oppid='';
            String oppacc='';
            String acci='';//业务机会下的客户
            String oppaccd = '';//新字段
            List<User> userList = [select id, BMO_specialist__c from User];
            list<Account> list_acc = [select Id,ShippingStreet,recordTypeId, ShippingCity,ShippingCountry,Actual_Sales_Name__c from Account];

            for(Opportunity opps : trigger.new){
                if(opps.Region__c == 'ROA'){
                    oppaccd= opps.AccountId;
                }
                system.debug('oppaccd+'+oppaccd);
                if(oppaccd !=''){
                    List<Account> list_ac = [select business_License__c,id,business_License_Work__c from Account where id=:oppaccd];
                    system.debug('list_ac'+list_ac);
                    
                    if(list_ac[0].business_License__c==null &&  userinfo.getProfileId()!='00e90000000sjacAAA' &&  userinfo.getProfileId()!='00e2t000000Df4vAAC'){
                        system.debug('11111');
                        opps.addError('Please upload the customer\'s business license');
                    }
                }
            }        
            for(Opportunity opp : trigger.new){
                
                oppid = opp.Ownerid; 
                oppacc= opp.AccountId;
                for(User user : userList){
                    if(user.Id == opp.OwnerId){
                        opp.BMO_specialist__c = user.BMO_specialist__c;
                    }
                }
                
                //add 2016/1/7
                if(opp.Is_GTAC_Formula__c == 'True'){
                    opp.Allow_new_process_for_Japan_picklist__c = 'pending';
                }else if(opp.Is_GTAC_Formula__c == 'False' || opp.Is_GTAC_Formula__c == null || opp.Is_GTAC_Formula__c == ''){
                    opp.Allow_new_process_for_Japan_picklist__c = 'allow';
                }
                
                
                // add 2018/04
                for(Account acc : list_acc){
                    if(acc.Id == opp.AccountId){
                        acci=acc.id;
                        List<Contact> contactLst=[SELECT ID,Account.id,NAME FROM Contact Where Account.id=:acci];
                        system.debug('2020业务机会创建如果客户没有联系人则不能创建业务机会');
                        if(contactLst.size()==0 && userinfo.getProfileId()!='00e90000000sjacAAA' && acc.recordTypeId !='0126F0000022Yki' && acc.recordTypeId !='0126F000001j8Sx'){//
                            system.debug('getProfileId:'+userinfo.getProfileId());
                            opp.addError('Error: Contact is missing, please go account detail to create contact infomation, Thanks.');
                        }     
                        
                        if(opp.Ownerid=='00590000002S4h0'){
                            opp.Actual_Sales_Name__c='arda';
                        }else{
                            if(acc.Actual_Sales_Name__c !=null){
                                opp.Actual_Sales_Name__c=acc.Actual_Sales_Name__c;
                            }
                        }
                        if(opp.RecordTypeId =='0126F000001MHOJ' && (opp.Trade_Term__c=='DDP'||opp.Trade_Term__c=='DAP'))
                        {
                            opp.delivey_point__c=acc.ShippingStreet+'  '+acc.ShippingCity+'  '+acc.ShippingCountry;
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
                //add 2016/1/8
                if(opp.RecordTypeId == AustraliaRecordTypeId){
                    SendEmailUtils.AusOpp(opp.Id);
                }
                
            }
          
        }
    }
    
    
    
    //当Allow new process for japan = true 发送提醒邮件给业务机会Owner
    if(Trigger.isUpdate && !Test.isRunningTest()){
        
        Set<string> userIds = new Set<string>();
        
        for(Opportunity newOpp : trigger.new){
            if(newOpp.Allow_new_process_for_Japan_picklist__c == 'allow'){
                userIds.add(newOpp.OwnerId);
            }

            /*
			    * @author Devin Bi (devin.bi@syxrong.com)
			    *
			    * @date 2020/5/25
			    *
			    * @description MOU框架Lock功能和重置审批及信息完整性判断
			    */
            if (newOpp.MOU_Type_Judgment__c) {
              //  Profile profile = [select id, name from profile where name='System Administrator' or name = '系统管理员'];

                Map<Id, Opportunity> oppMap = (Map<Id, Opportunity>)trigger.oldMap;

                Opportunity oldOpp = oppMap.get(newOpp.Id);
                System.debug('MOUAutoApprovalHandler---------------------------->' + newOpp.Approval_Lock__c);
                //MOU opportunity锁定验证
                if (newOpp.Lock__c == oldOpp.Lock__c && newOpp.Lock__c ) {//&& UserInfo.getProfileId() != profile.Id
                    newOpp.addError(Label.OpportunityLockException, false);
                }
                //			if (newOpp.Approval_Lock__c == oldOpp.Approval_Lock__c && newOpp.Approval_Lock__c &&
                //							UserInfo.getProfileId() != profile.Id) {
                //				newOpp.addError('Business opportunities are currently under approval', false);
                //			}

                //MOU opportunity上锁
                if (newOpp.SOC_Dept__c != oldOpp.SOC_Dept__c || newOpp.Finance_Approval_Status__c != oldOpp.Finance_Approval_Status__c ||
                                newOpp.GM_approval_Status__c != oldOpp.GM_approval_Status__c || newOpp.Legal_Dept__c != oldOpp.Legal_Dept__c ||
                                newOpp.Technical_Dept_Status__c != oldOpp.Technical_Dept_Status__c || newOpp.VP_Approval_Status__c != oldOpp.VP_Approval_Status__c) {
                    if (newOpp.SOC_Dept__c == 'Approved' && newOpp.Finance_Approval_Status__c == 'Approved' && newOpp.GM_approval_Status__c == 'Approved' && newOpp.Legal_Dept__c == 'Approved' &&
                                    (newOpp.Technical_Dept_Status__c == 'Approved' || newOpp.Technical_Dept_Status__c == null) && (newOpp.VP_Approval_Status__c == 'Approved' || newOpp.VP_Approval_Status__c == null)) {
                                        if(trigger.isBefore){
                                             newOpp.Lock__c = true;
                                        }              
                       
                        if(newOpp.Roll_up_SFA_Counts__c == 0){                         
                            System.debug('-------------------------------------------------------------------------------------------11111111111111111111111111'+newOpp.Id);
                            //审批通过后生成第一次补充框架协议。
                            if(Trigger.isAfter){                                                          
                            	MOUFrameworkAgreementFirstCreate.saveFrameworkAgreement(newOpp.Id);
                             }
                        }
                    }
                }
                //MOU opportunity重置审批验证
                if (newOpp.Roll_up_SFA_Counts__c == 0) {
                    if (newOpp.Trade_Term__c != oldOpp.Trade_Term__c || newOpp.Destination_Port__c != oldOpp.Destination_Port__c || newOpp.Seller__c != oldOpp.Seller__c ||
                                    newOpp.Destination_Country__c != oldOpp.Destination_Country__c || newOpp.AccountId != oldOpp.AccountId) {
                                        if(trigger.isbefore){          
                        //字段初始化
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
                                        }
                    }
                }
                /*//MOU opportunity信息完整性判断
                if (newOpp.Region__c == null && newOpp.Destination_Region_Text__c == null) {
                    newOpp.addError('If Destination Region does not have information, please fill in Destination Region Text', false);
                }
                if (newOpp.Opportunity_Type__c == null && newOpp.Opportunity_Type_Text__c == null) {
                    newOpp.addError('If Opportunity Type does not have information, please fill in Opportunity Type Text', false);
                }
                if (newOpp.Sales_type__c == null && newOpp.Sales_type_Text__c == null) {
                    newOpp.addError('If Sales type does not have information, please fill in Sales type Text', false);
                }
                if (newOpp.Project_related_or_not__c == null && newOpp.Project_related_or_not_Text__c == null) {
                    newOpp.addError('If Project related or not does not have information, please fill in Project related or not Text', false);
                }
                if (newOpp.GST_Classification_Region__c == null && newOpp.GST_Classification_Region_Text__c == null) {
                    newOpp.addError('If GST Classification Region does not have information, please fill in GST Classification Region Text', false);
                }
                if (newOpp.Type_of_Shipping__c == null && newOpp.Type_of_Shipping_Text__c == null) {
                    newOpp.addError('If Type of Shipping(基地--起运港) does not have information, please fill in Type of Shipping(基地--起运港) Text', false);
                }
                if (newOpp.CloseDate == null && newOpp.Close_Date_Text__c == null) {
                    newOpp.addError('If Close Date does not have information, please fill in Close Date Text', false);
                }
                if (newOpp.Type_of_Inventory_or_Production__c == null && newOpp.Warehouse_Stock_or_Production_Text__c == null) {
                    newOpp.addError('If Warehouse Stock or Production does not have information, please fill in Warehouse Stock or Production Text', false);
                }
                if (newOpp.Customer_Delivery_Date__c == null && newOpp.Expected_Delivery_Date_Text__c == null) {
                    newOpp.addError('If Expected Delivery Date does not have information, please fill in Expected Delivery Date Text', false);
                }
                if (newOpp.Confirmed_ETD__c == null && newOpp.Estimated_Time_of_Departure_Text__c == null) {
                    newOpp.addError('If Estimated Time of Departure does not have information, please fill in Estimated Time of Departure Text', false);
                }
                if (newOpp.Destination_Country__c == null && newOpp.Destination_Country_Text__c == null) {
                    newOpp.addError('If Destination Country of Departure does not have information, please fill in Destination Country Text', false);
                }
                if (newOpp.Destination_Port__c == null && newOpp.Destination_Port_Text__c == null) {
                    newOpp.addError('If Destination Port does not have information, please fill in Destination Port Text', false);
                }
                if (newOpp.Departure_Factory__c == null && newOpp.Departure_Factory_Text__c == null) {
                    newOpp.addError('If Departure Factory does not have information, please fill in Departure Factory Text', false);
                }
                if (newOpp.Seller__c == null && newOpp.Seller_Text__c == null) {
                    newOpp.addError('If Seller does not have information, please fill in Seller Text', false);
                }
                if (newOpp.Warranty_On_Material_and_Workmanship__c == null && newOpp.Warranty_On_Material_and_WorkmanshipText__c == null) {
                    newOpp.addError('If Warranty On Material and Workmanship does not have information, please fill in Warranty On Material and WorkmanshipText', false);
                }
                if (newOpp.Warranty_Insurance__c == null && newOpp.Warranty_Insurance_Text__c == null) {
                    newOpp.addError('If Warranty Insurance does not have information, please fill in Warranty Insurance Text', false);
                }
                if (newOpp.Order_reason__c == null && newOpp.Order_reason_Text__c == null) {
                    newOpp.addError('If Order reason does not have information, please fill in Order reason Text', false);
                }
                if (newOpp.Order_Type__c == null && newOpp.Order_Type_Text__c == null) {
                    newOpp.addError('If Order Type does not have information, please fill in Order Type Text', false);
                }
                if (newOpp.Warehouse_or_Factory__c == null && newOpp.Warehouse_or_Factory_Text__c == null) {
                    newOpp.addError('If Warehouse or Factory does not have information, please fill in Warehouse or Factory Text', false);
                }
                if (newOpp.Local_Warehouse__c == null && newOpp.Local_Warehouse_Text__c == null) {
                    newOpp.addError('If Local Warehouse does not have information, please fill in Local Warehouse Text', false);
                }
                if (newOpp.Installation_Type__c == null && newOpp.Installation_Type_Text__c == null) {
                    newOpp.addError('If Installation Type does not have information, please fill in Installation Type Text', false);
                }
                if (newOpp.LeadSource == null && newOpp.Lead_Source_Text__c == null) {
                    newOpp.addError('If Lead Source does not have information, please fill in Lead Source Text', false);
                }
                if (newOpp.Sales_1_percentage__c == null && newOpp.Sales_1_percentage_Text__c == null) {
                    newOpp.addError('If Sales 1 percentage does not have information, please fill in Sales 1 percentage Text', false);
                }
                if (newOpp.Sales_2_percentage__c == null && newOpp.Sales_2_percentage_Text__c == null) {
                    newOpp.addError('If Sales 2 percentage does not have information, please fill in Sales 2 percentage Text', false);
                }
                if (newOpp.Sales_3_percentage__c == null && newOpp.Sales_3_percentage_Text__c == null) {
                    newOpp.addError('If Sales 3 percentage does not have information, please fill in Sales 3 percentage Text', false);
                }
                if (newOpp.Land_Freight_China__c == null && newOpp.Land_Freight_China_Text__c == null) {
                    newOpp.addError('If Land Freight(China) does not have information, please fill in Land Freight(China) Text', false);
                }
                if (newOpp.Land_Freight_Oversea__c == null && newOpp.Land_Freight_Oversea_Text__c == null) {
                    newOpp.addError('If Land Freight(Oversea) does not have information, please fill in Land Freight(Oversea) Text', false);
                }
                if (newOpp.Warehouse_Premium__c == null && newOpp.Warehouse_Premium_Text__c == null) {
                    newOpp.addError('If Warehouse Premium does not have information, please fill in Warehouse Premium Text', false);
                }
                if (newOpp.Ocean_Freight__c == null && newOpp.Ocean_Freight_Text__c == null) {
                    newOpp.addError('If Ocean Freight does not have information, please fill in Ocean Freight Text', false);
                }*/
            }
        }
        Map<ID,User>  userMap = new Map<ID,User>([SELECT Id,Name,Email	FROM User WHERE Id in: userIds]);

        for(Opportunity opp_new : trigger.new){
            for(Opportunity opp_old : trigger.old){
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
    
    /**
* 更新根据目的地港口自动赋值运费  
* 
* refresh by Joel Wang
* 批注 Snake
* date : 2019.06.24  238~ 629
*/
    
  if(Trigger.isInsert && Trigger.isBefore){  
          // 所有后台运费数据
        List<Port_freight_maintenance__c> pfmcList = [SELECT ID,Name,Ocean_Freight__c,Warehouse_Premium__c FROM Port_freight_maintenance__c];
        //flag用于判断业务机会与维护运费港口是否相同
        Boolean flag=true;        
        if(pfmcList.size()>0){              
            for(Opportunity opp : trigger.new){                
                for(Port_freight_maintenance__c pfmc : pfmcList){
                    if(opp.Destination_Port__c==pfmc.Name){
                    //if(opp.Destination_Port__c.equalsIgnoreCase(pfmc.Name)){
                        flag=false;
                        //1.非中东非地区 2.Factory情况 3.后台存在值 更新 4.CIF/CFR

                            if( pfmc.Name == opp.Destination_Port__c && opp.Warehouse_or_Factory__c=='Factory' && (opp.Number_of_Containers__c==null || opp.Number_of_Containers__c==0) &&(opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){ 
                                     if(opp.Ocean_Freight__c==null || opp.Ocean_Freight__c==0){
                                //opp.Ocean_Freight__c = pfmc.Ocean_Freight__c;
                                
                                         }
                            }
                            
                        
                       
                            if(opp.Warehouse_or_Factory__c== 'Factory' && opp.Destination_Port__c!=null && opp.Number_of_Containers__c!=null && (opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){
                                system.debug('opp.Total_MW__c----276>'+opp.Total_MW__c);
                                //Snake 7.17 增加opp.Number_of_Containers__c!=null 判断
                                if(opp.Total_MW__c !=null && opp.Total_MW__c !=0 && opp.Number_of_Containers__c!=null){
                                    if(opp.Ocean_Freight__c==null || opp.Ocean_Freight__c==0){
                                                                    opp.Ocean_Freight__c=(pfmc.Warehouse_Premium__c * opp.Number_of_Containers__c).divide(opp.Total_MW__c * 1000000, 5);
                                   
                                }
                                    }                   
                            }

                    }
                    
                }
                //FOB FCA直接运费0
                if(opp.Warehouse_or_Factory__c== 'Factory' && opp.Destination_Port__c!=null && (opp.Trade_Term__c== 'FOB' || opp.Trade_Term__c== 'FCA')){
                    opp.Ocean_Freight__c=0;
                }
                //中东非 Factory 仓库费直接0
                if(opp.Warehouse_or_Factory__c== 'Factory' &&  (opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA')){
                    opp.Warehouse_Premium__c=0;
                }
                
                if(flag==true &&(opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){
                    opp.CFR_CIF_Flag__c=true;
                }
                if(flag==false){
                    opp.CFR_CIF_Flag__c=false;
                }
                //如果贸易方式是DDP
                /** if(opp.Trade_Term__c== 'DDP' || opp.Trade_Term__c== 'DAP'){
                opp.Ocean_Freight__c =0;
                }else if(opp.Trade_Term__c!= 'DDP' && opp.Trade_Term__c!= 'DAP'){
                opp.Land_Freight_Oversea__c=0;
                }*/
                if(opp.Trade_Term__c== 'EXW' && opp.Land_Freight_China__c==null ){
                    opp.Land_Freight_China__c =0;
                }
                if(opp.Trade_Term__c!= 'EXW'){
                    opp.Land_Freight_China__c =0.005;
                }
                
            }
        }
        // neo
        new OpportunityLineItemGrossMarginHandler().setFreightCostByOpportunity(Trigger.new);
    }
    if(Trigger.isUpdate  && Trigger.isBefore){     
        // 所有后台运费数据
        List<Port_freight_maintenance__c> pfmcList = [SELECT ID,Name,Ocean_Freight__c,Warehouse_Premium__c FROM Port_freight_maintenance__c];
        //flag用于判断业务机会与维护运费港口是否相同
        Boolean flag=true;        
        /*if(pfmcList.size()>0){
             for(Opportunity oldopp : trigger.old){
            for(Opportunity opp : trigger.new){                
                for(Port_freight_maintenance__c pfmc : pfmcList){
                    if(opp.Destination_Port__c==pfmc.Name){
                    //if(opp.Destination_Port__c.equalsIgnoreCase(pfmc.Name)){
                        flag=false;
                        
                        
                        
                        
                        //1.非中东非地区 2.Factory情况 3.后台存在值 更新 4.CIF/CFR

                            if( pfmc.Name == opp.Destination_Port__c && opp.Warehouse_or_Factory__c=='Factory' && (opp.Number_of_Containers__c==null || opp.Number_of_Containers__c==0) &&(opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){ 
                                     if(opp.Ocean_Freight__c==null || opp.Ocean_Freight__c==0){
                                opp.Ocean_Freight__c = pfmc.Ocean_Freight__c;
                                         }
                            }
                            if(opp.Warehouse_or_Factory__c== 'Factory' && opp.Destination_Port__c!=null && opp.Number_of_Containers__c!=null && (oldopp.Number_of_Containers__c==null || oldopp.Number_of_Containers__c==0) && (opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){
                               
                                if(opp.Total_MW__c !=null && opp.Total_MW__c !=0 ){
                                                                    opp.Ocean_Freight__c=(pfmc.Warehouse_Premium__c * opp.Number_of_Containers__c).divide(opp.Total_MW__c * 1000000, 5);
                                   
                                
                                    }                   
                            }
                        
                       
                            if(opp.Warehouse_or_Factory__c== 'Factory' && opp.Destination_Port__c!=null && opp.Number_of_Containers__c!=null && (opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){
                                system.debug('opp.Total_MW__c----276>'+opp.Total_MW__c);
                                //Snake 7.17 增加opp.Number_of_Containers__c!=null 判断
                                if(opp.Total_MW__c !=null && opp.Total_MW__c !=0 && opp.Number_of_Containers__c!=null){
                                    if(opp.Ocean_Freight__c==null || opp.Ocean_Freight__c==0){
                                                                    opp.Ocean_Freight__c=(pfmc.Warehouse_Premium__c * opp.Number_of_Containers__c).divide(opp.Total_MW__c * 1000000, 5);
                                   
                                }
                                    }                   
                            }

                    }
                    
                }
                //FOB FCA直接运费0
                if(opp.Warehouse_or_Factory__c== 'Factory' && opp.Destination_Port__c!=null && (opp.Trade_Term__c== 'FOB' || opp.Trade_Term__c== 'FCA')){
                    opp.Ocean_Freight__c=0;
                }
                //中东非 Factory 仓库费直接0
                if(opp.Warehouse_or_Factory__c== 'Factory' && opp.Region__c == 'Middle East&Africa'){
                    opp.Warehouse_Premium__c=0;
                }
                
                if(flag==true &&(opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){
                    opp.CFR_CIF_Flag__c=true;
                }
                if(flag==false){
                    opp.CFR_CIF_Flag__c=false;
                }
                //如果贸易方式是DDP
                /** if(opp.Trade_Term__c== 'DDP' || opp.Trade_Term__c== 'DAP'){
                opp.Ocean_Freight__c =0;
                }else if(opp.Trade_Term__c!= 'DDP' && opp.Trade_Term__c!= 'DAP'){
                opp.Land_Freight_Oversea__c=0;
                }*/
               /* if(opp.Trade_Term__c== 'EXW' && opp.Land_Freight_China__c==null){
                    opp.Land_Freight_China__c =0;
                }
                if(opp.Trade_Term__c!= 'EXW'){
                    opp.Land_Freight_China__c =0.005;
                }
                
            }
                 }
        }*/
        
        // neo - calculate freight
        OpportunityLineItemGrossMarginHandler handler = new OpportunityLineItemGrossMarginHandler();
        for (String Id : Trigger.newMap.keySet()) {
            if (Trigger.oldMap.get(Id).Region__c != Trigger.newMap.get(Id).Region__c ||
                Trigger.oldMap.get(Id).Destination_Port__c != Trigger.newMap.get(Id).Destination_Port__c ||
                Trigger.oldMap.get(Id).Trade_Term__c != Trigger.newMap.get(Id).Trade_Term__c ||
                Trigger.oldMap.get(Id).Local_Warehouse__c != Trigger.newMap.get(Id).Local_Warehouse__c) OpportunityLineItemGrossMarginHandler.containerNeedChangeIds.add(Id);
            if (Trigger.oldMap.get(Id).Destination_Port__c != Trigger.newMap.get(Id).Destination_Port__c ||
                Trigger.oldMap.get(Id).Trade_Term__c != Trigger.newMap.get(Id).Trade_Term__c ||
                Trigger.oldMap.get(Id).Local_Warehouse__c != Trigger.newMap.get(Id).Local_Warehouse__c||
                Trigger.oldMap.get(Id).Total_MW__c != Trigger.newMap.get(Id).Total_MW__c) OpportunityLineItemGrossMarginHandler.oceanNeedChangeIds.add(Id);
            if (Trigger.oldMap.get(Id).Destination_Country__c != Trigger.newMap.get(Id).Destination_Country__c ||
                Trigger.oldMap.get(Id).Trade_Term__c != Trigger.newMap.get(Id).Trade_Term__c) OpportunityLineItemGrossMarginHandler.landNeedChangeIds.add(Id);
            
        }
    }
    if( Trigger.isUpdate && Trigger.isAfter){
        if(checkRecursive.runOnce()){           
            List<Port_freight_maintenance__c> pfmcList = [SELECT ID,Name,Ocean_Freight__c,Warehouse_Premium__c FROM Port_freight_maintenance__c];
            system.debug('pfmcList.Name--->');
            //flag用于判断业务机会与维护运费港口是否相同
            Boolean flag=true;        
            if(pfmcList.size()>0){              
                for(Opportunity opp : trigger.new){
                    for(Opportunity oppold : trigger.old) {
                        for(Port_freight_maintenance__c pfmc : pfmcList){
                            //找到相同港口时
                            if(opp.Destination_Port__c==pfmc.Name){
                                flag=false;
                                if(opp.Region__c != 'Middle East&Africa' &&opp.Region__c != 'MENA'&&opp.Region__c != 'SSA'){
                                    if (opp.Warehouse_or_Factory__c =='Factory' &&( opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA' )) {  
                                        //修改了贸易方式 或者修改了 发货方式
                                        if(opp.Ocean_Freight__c == oppold.Ocean_Freight__c && (opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c)){
                                            EmailFlag=true;
                                            system.debug('邮件1');
                                        }                                                                 
                                    }else if(opp.Warehouse_or_Factory__c== 'Warehouse' ){
                                        
                                        if(opp.Ocean_Freight__c == oppold.Ocean_Freight__c && (opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c)){
                                            EmailFlag=true;
                                            system.debug('邮件2');
                                        }   
                                    }
                                    //港口更改发邮件
                                    if(opp.Warehouse_or_Factory__c =='Factory'&&(opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA')){
                                        if(opp.Destination_Port__c != oppold.Destination_Port__c && opp.Ocean_Freight__c == oppold.Ocean_Freight__c ){
                                            EmailFlag=true;
                                            system.debug('邮件10-1-1');
                                        }
                                    }else if(opp.Warehouse_or_Factory__c =='Warehouse'){
                                        if(opp.Destination_Port__c != oppold.Destination_Port__c && opp.Ocean_Freight__c == oppold.Ocean_Freight__c ){
                                            EmailFlag=true;
                                            system.debug('邮件10-1-2');
                                        }
                                    }
                                    
                                }
                            }
                            
                            //中东非
                            if((opp.Region__c == 'Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Destination_Port__c==pfmc.Name){
                                flag=false;
                                if(opp.Warehouse_or_Factory__c== 'Factory'&&(opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' &&opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA') && (opp.Destination_Port__c != oppold.Destination_Port__c ||opp.Trade_Term__c !=oppold.Trade_Term__c)){
                                    if(opp.Ocean_Freight__c == oppold.Ocean_Freight__c && (opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c)){
                                        EmailFlag=true;
                                        system.debug('邮件3-1'); 
                                    }
                                    
                                }
                                if(opp.Warehouse_or_Factory__c== 'Warehouse'){
                                    
                                    if(opp.Ocean_Freight__c == oppold.Ocean_Freight__c &&(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c
                                                                                          || opp.Warehouse_Premium__c !=oppold.Warehouse_Premium__c)){
                                                                                              
                                                                                              EmailFlag=true;
                                                                                              system.debug('邮件3');
                                                                                              
                                                                                          }                               
                                    
                                }
                                //港口更改发邮件
                                if(opp.Warehouse_or_Factory__c =='Factory'&&(opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA')){
                                    if(opp.Destination_Port__c != oppold.Destination_Port__c && opp.Ocean_Freight__c == oppold.Ocean_Freight__c ){
                                        EmailFlag=true;
                                        system.debug('邮件10-2');
                                    }
                                }else if(opp.Warehouse_or_Factory__c =='Warehouse'){
                                    if(opp.Destination_Port__c != oppold.Destination_Port__c && opp.Ocean_Freight__c == oppold.Ocean_Freight__c ){
                                        EmailFlag=true;
                                        system.debug('邮件10-2');
                                    }
                                }
                            } 
                            //如果贸易方式为DDP，并且Land_Freight_Oversea__c为空或者0，发邮件提醒更新运费(不区分地区)
                            if(opp.Trade_Term__c=='DDP' && (opp.Land_Freight_Oversea__c==null|| opp.Land_Freight_Oversea__c==0)){
                                if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
                                    EmailFlag=true;
                                    system.debug('邮件11');
                                }
                            }
                            
                        }
                        
                        
                        //中东非仓库溢价
                        if((opp.Region__c == 'Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Warehouse_or_Factory__c== 'Warehouse' && (opp.Warehouse_Premium__c==null || opp.Warehouse_Premium__c==0)
                          && (opp.Warehouse_or_Factory__c!=oppold.Warehouse_or_Factory__c || opp.Local_Warehouse__c!= oppold.Local_Warehouse__c) && (opp.Local_Warehouse__c=='Rotterdam Wareho' ||opp.Local_Warehouse__c=='Jabel Ali warehouse' ||opp.Local_Warehouse__c=='Walvis Bay')){
                               if(EmailFlag!=true){  
                                   //Utils.sendEmailWithTemplate2('joel@trixpro.com',opp.id, 'MEA_ToLogistics',opp.Ownerid);   //exp.logistic@jinkosolar.com  真实物流部门邮箱
                                   // Utils.sendEmailWithTemplate2('MEA.logistics@jinkosolar.com',opp.id, 'MEA_ToLogistics',opp.Ownerid);
                                   
                                   system.debug('邮件4');
                               }
                           }else if(opp.Warehouse_or_Factory__c== 'Factory'){
                               //  opp.Warehouse_Premium__c=0;
                           }
                        
                        
                    }  
                }
                
                
            }
            for(Opportunity opp : trigger.new){
                for(Opportunity oppold : trigger.old) {
                    //维护信息中没港口维护
                    SYSTEM.debug('flag'+flag);
                    if(flag){      
                        //非中东非地区维护信息没有目的地港口发邮件
                        if(opp.Warehouse_or_Factory__c=='Factory' && opp.Region__c != 'Middle East&Africa' && opp.Region__c != 'MENA'&& opp.Region__c != 'SSA'  && opp.Region__c !='North America' 
                           && opp.Region__c != 'Central Asia' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)
                           &&opp.Destination_Port__c !=null &&(opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){                   
                               system.debug('非中东非地区维护信息没有目的地港口发邮件');
                               
                               if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
                                   EmailFlag=true;
                                   system.debug('邮件5');
                               }
                               
                           }else if(opp.Warehouse_or_Factory__c=='Factory' && opp.Region__c != 'Middle East&Africa'&& opp.Region__c != 'MENA'&& opp.Region__c != 'SSA' && opp.Region__c !='North America' 
                                    && opp.Region__c != 'Central Asia' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)
                                    &&opp.Destination_Port__c !=null &&(opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA')){
                                        if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
                                            EmailFlag=true;
                                            system.debug('邮件6');
                                        }
                                        
                                    }else if(opp.Warehouse_or_Factory__c=='Warehouse' && opp.Region__c != 'Middle East&Africa' && opp.Region__c != 'MENA'&& opp.Region__c != 'SSA' && opp.Region__c !='North America' 
                                             && opp.Region__c != 'Central Asia' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)
                                             && opp.Destination_Port__c !=null){
                                                 if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
                                                     EmailFlag=true;
                                                     system.debug('邮件7');
                                                 }
                                                 
                                             }
                        if(opp.Destination_Port__c !=null && opp.Region__c == 'Middle East&Africa'){
                            //业务机会有港口,维护信息里没有港口信息并且是工厂发货                 
                            /**   if(opp.Warehouse_or_Factory__c== 'Factory' ){
            if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
            Utils.sendEmailWithTemplate2('joel@trixpro.com',opp.id, 'Freight_Notify',opp.Ownerid);
            system.debug('邮件8');
            system.debug('港口-----------------');
            }*/
                            
                            /**}else*/ if(opp.Warehouse_or_Factory__c == 'Warehouse' && (opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA')){
                                if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
                                    EmailFlag=true;
                                    system.debug('邮件9');
                                }
                                
                            }
                            
                        }
                        //港口更改发邮件
                        if(opp.Warehouse_or_Factory__c =='Factory'&&(opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA')){
                            if(opp.Destination_Port__c != oppold.Destination_Port__c && opp.Ocean_Freight__c == oppold.Ocean_Freight__c ){
                                EmailFlag=true;
                                system.debug('邮件10-3');
                            }
                        }else if(opp.Warehouse_or_Factory__c =='Warehouse'){//&&(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c)
                            if(opp.Destination_Port__c != oppold.Destination_Port__c && opp.Ocean_Freight__c == oppold.Ocean_Freight__c  
                              ){
                                  EmailFlag=true;
                                  system.debug('邮件10-3');
                              }
                        }
                        //如果贸易方式为DDP，并且Land_Freight_Oversea__c为空或者0，发邮件提醒更新运费(不区分地区)
                        if(opp.Trade_Term__c=='DDP' && (opp.Land_Freight_Oversea__c==null|| opp.Land_Freight_Oversea__c==0)){
                            if(opp.Trade_Term__c !=oppold.Trade_Term__c || opp.Ocean_Freight__c != oppold.Ocean_Freight__c || opp.Warehouse_or_Factory__c !=oppold.Warehouse_or_Factory__c){
                                EmailFlag=true;
                                system.debug('邮件11');
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    

    if(Trigger.isInsert  && Trigger.isAfter){
        if(checkRecursive.runOnce14()){
        for(Opportunity opp : trigger.new){
          List<payment__c> paylst = new List<payment__c>();
                    paylst=[select id,Percentage__c,Down_Balance_Payment__c,Payment_Method__c,Days__c,Payment_Term__c,Credit_Valid__c from payment__c where Account__c =:opp.AccountId];
                    List<payment__c> insertpaylst = new List<payment__c>();
                    if(paylst.size()>0){
                        for(payment__c p:paylst){
                            payment__c np =new payment__c();
                            np.Percentage__c=p.Percentage__c;
                                np.Down_Balance_Payment__c=p.Down_Balance_Payment__c;
                                np.Days__c=p.Days__c;
                                np.Payment_Term__c=p.Payment_Term__c;
                                np.Credit_Valid__c=p.Credit_Valid__c;
                            np.Payment_Method__c=p.Payment_Method__c;
                            system.debug('opp.id:'+opp.id);
                            np.Opportunity__c=opp.id;
                            insertpaylst.add(np);
                        }
                    }
                    insert insertpaylst;
        
        }
        
        List<Port_freight_maintenance__c> pfmcList = [SELECT ID,Name,Ocean_Freight__c,Warehouse_Premium__c FROM Port_freight_maintenance__c];
        system.debug('pfmcList.Name--->');
        //flag用于判断业务机会与维护运费港口是否相同
        Boolean flag=true;        
        if(pfmcList.size()>0){              
            for(Opportunity opp : trigger.new){
              
                
                for(Port_freight_maintenance__c pfmc : pfmcList){
                    //system.debug('owner'+opp.ownerid);
                    
                    if(opp.Destination_Port__c==pfmc.Name){
                        flag=false;
                        system.debug('flag------------------->'+flag);
                        if(opp.Region__c != 'Middle East&Africa' && opp.Region__c != 'MENA'&& opp.Region__c != 'SSA'){
                            if(opp.Trade_Term__c== 'FOB' || opp.Trade_Term__c== 'FCA'){
                                // opp.Ocean_Freight__c =0;
                            }else if ((opp.Ocean_Freight__c==0 ||opp.Ocean_Freight__c==null)&&(opp.Warehouse_or_Factory__c =='Factory' &&( opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA' ))) {  
                                
                                
                                EmailFlag=true;
                                
                                
                                system.debug('邮件2-1');
                            }else if((opp.Ocean_Freight__c==0 ||opp.Ocean_Freight__c==null)&&opp.Warehouse_or_Factory__c== 'Warehouse'){
                                
                                
                                EmailFlag=true;
                                
                                
                                system.debug('邮件2-2');
                            }
                        }
                    }
                    
                    //中东非
                    if((opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Destination_Port__c==pfmc.Name){
                        flag=false;
                        system.debug('flag------------------->'+flag);
                        system.debug('000000000000000000000000000000000');
                        if(opp.Warehouse_or_Factory__c== 'Warehouse' &&(opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)){
                            
                            EmailFlag=true;
                            
                            system.debug('邮件2-3');
                        }
                    }
                    //如果贸易方式是其他，warahouse是factory
                    if((opp.Ocean_Freight__c==0 ||opp.Ocean_Freight__c==null)&&(opp.Warehouse_or_Factory__c =='Factory' &&( opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA' ))){
                        EmailFlag=true;
                        system.debug('邮件2-3-1');
                    }
                    
                    //如果贸易方式为DDP，并且Land_Freight_Oversea__c为空或者0，发邮件提醒更新运费(不区分地区)
                    if(opp.Trade_Term__c=='DDP' && (opp.Land_Freight_Oversea__c==null|| opp.Land_Freight_Oversea__c==0)){
                        EmailFlag=true; 
                        system.debug('邮件2-3-2');
                    }
                }
                
                
                
                
                
                
            }
            
            
        }
        for(Opportunity opp : trigger.new){
            
            //维护信息中没港口维护
            
            if(flag){
                //非中东非地区维护信息没有目的地港口发邮件
                if(opp.Warehouse_or_Factory__c=='Factory' && opp.Region__c != 'Middle East&Africa' && opp.Region__c != 'MENA'&& opp.Region__c != 'SSA' && opp.Region__c !='North America' 
                   &&opp.Region__c != 'Central Asia' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)
                   &&opp.Destination_Port__c !=null &&(opp.Trade_Term__c== 'CIF' || opp.Trade_Term__c== 'CFR')){                   
                       system.debug('非中东非地区维护信息没有目的地港口发邮件');
                       
                       
                       EmailFlag=true;
                       
                       system.debug('邮件2-5');
                   }else if(opp.Warehouse_or_Factory__c=='Factory' && opp.Region__c != 'Middle East&Africa'&& opp.Region__c != 'MENA'&& opp.Region__c != 'SSA' && opp.Region__c !='North America' 
                            && opp.Region__c != 'Central Asia' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)
                            &&opp.Destination_Port__c !=null &&(opp.Trade_Term__c!= 'CFR' && opp.Trade_Term__c!= 'CIF' && opp.Trade_Term__c!= 'FOB' && opp.Trade_Term__c!= 'FCA')){
                                
                                EmailFlag=true;
                                
                                system.debug('邮件2-6');
                            }else if(opp.Warehouse_or_Factory__c=='Warehouse' && opp.Region__c != 'Middle East&Africa'&& opp.Region__c != 'MENA'&& opp.Region__c != 'SSA' && opp.Region__c !='North America' 
                                     && opp.Region__c != 'Central Asia' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)
                                     && opp.Destination_Port__c !=null){
                                         
                                         EmailFlag=true;
                                         
                                         system.debug('邮件2-7');
                                     }
                if(opp.Destination_Port__c !=null && (opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') ){
                    //业务机会有港口,维护信息里没有港口信息并且是工厂发货                 
                    if(opp.Warehouse_or_Factory__c== 'Factory' ){
                        
                        EmailFlag=true;
                        
                        system.debug('邮件2-8');
                        system.debug('港口-----------------');
                    }else if(opp.Warehouse_or_Factory__c == 'Warehouse' && (opp.Ocean_Freight__c ==null || opp.Ocean_Freight__c ==0)){
                        
                        EmailFlag=true;
                        
                        system.debug('邮件2-9');
                    }
                    
                }
                //如果贸易方式为DDP，并且Land_Freight_Oversea__c为空或者0，发邮件提醒更新运费(不区分地区)
                if(opp.Trade_Term__c=='DDP' && (opp.Land_Freight_Oversea__c==null|| opp.Land_Freight_Oversea__c==0)){
                    EmailFlag=true;
                    
                    system.debug('邮件2-10');                                
                }
            }
            //中东非仓库溢价
            if((opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA' )&& opp.Warehouse_or_Factory__c== 'Warehouse' && (opp.Warehouse_Premium__c==null || opp.Warehouse_Premium__c==0)
               && (opp.Local_Warehouse__c=='Rotterdam Wareho' ||opp.Local_Warehouse__c=='Jabel Ali warehouse' ||opp.Local_Warehouse__c=='Walvis Bay')){
                   if(EmailFlag!=true){  
                       //Utils.sendEmailWithTemplate2('joel@trixpro.com',opp.id, 'MEA_ToLogistics',opp.Ownerid);   //exp.logistic@jinkosolar.com  真实物流部门邮箱
                      // Utils.sendEmailWithTemplate2('MEA.logistics@jinkosolar.com',opp.id, 'MEA_ToLogistics',opp.Ownerid);
                       system.debug('邮件4');
                   }
               }else if(opp.Warehouse_or_Factory__c== 'Factory'){
                   //  opp.Warehouse_Premium__c=0;
               }
        }
        
        }
    }
    
    system.debug('EmailFlag------------>'+EmailFlag);
    //if(checkRecursive.runOnce()){
    if((Trigger.isUpdate ||Trigger.isinsert)  && Trigger.isAfter){
        
        
        
        
        
        
        for(Opportunity opp : trigger.new){       
            if(EmailFlag==true){
                ++EmailTimes;
                if(opp.MOU_Type_Judgment__c == false){
                    checkRecursive.EmailSend(EmailTimes,opp);
                }
                
                
                system.debug('EmailTimes-----------'+EmailTimes);
                system.debug('循环测试——————————————');
            }
        }

        // neo
        new OpportunityLineItemGrossMarginHandler(Trigger.newMap);
    }
    // }
    
   
    
    
    
    //老逻辑02
    
    if(Trigger.isInsert && !Test.isRunningTest()){
        
        
        
        
        
        
        
        //  List<Transit_Fees_Database__c> feeList = [SELECT ID,Name,Port__c,Price__c,Size__c,CurrencyIsoCode FROM Transit_Fees_Database__c];
        for(Opportunity opp : trigger.new){
           
            Boolean sendornot = false;
            Boolean getprice  = false;
            if(opp.Trade_Term__c == 'CIF'){
                sendornot = true;
                getprice  = true;
            }else if(opp.Trade_Term__c != 'CIF' && opp.Trade_Term__c == 'EXW Factory' && opp.Trade_Term__c == 'EXW Overseas Warehouse'){
                sendornot = true;
                getprice  = false;  
            }else if( (opp.Trade_Term__c == 'EXW Factory' || opp.Trade_Term__c == 'EXW Overseas Warehouse') && opp.isEurope__c == 'true'){
                sendornot = false;
                getprice  = false;
            }else if( (opp.Trade_Term__c == 'EXW Factory' || opp.Trade_Term__c == 'EXW Overseas Warehouse') && opp.isEurope__c == 'false'){
                sendornot = true;
                getprice  = false;
            }
            
            
            //After
            if(Trigger.isAfter){
                if(sendornot)
                    //SendEmailUtils.sendToLogistics(opp.Id);
                    system.debug('368---');
            }
            
            
            //Before
            
            /*老逻辑*/
            /* if(Trigger.isBefore){

if(opp.Trade_Term__c == 'CIF' && opp.Departure_Factory__c == 'ShangRao Factory'){
opp.Land_Freight_China__c = 'Truck: CNY 7,045 / 40HQ | Railway: CNY 5,574.9 / 40HQ';
}else if(opp.Trade_Term__c == 'CIF' && opp.Departure_Factory__c == 'HaiNing Factory'){
opp.Land_Freight_China__c = 'Truck: CNY 4,245 / 40HQ';
}

if(opp.Destination_Port__c != null){
opp.Ocean_Freight__c = '';
for(Transit_Fees_Database__c fee : feeList){
if(opp.Destination_Port__c == fee.Port__c && getprice){
opp.Ocean_Freight__c = opp.Ocean_Freight__c + fee.CurrencyIsoCode + ' ' + fee.Price__c + ' / ' + fee.Size__c + ' | ';
}
}
}

//add 20160203 Customer Type = Standard -> allow ; GTAC Frame -> Pending ; Other -> now allow
if(opp.Customer_Type__c != null){
if(opp.Customer_Type__c == 'Jinko Standard Japan'){
opp.Allow_new_process_for_Japan_picklist__c = 'allow';
}else if(opp.Customer_Type__c == 'GTAC' || opp.Customer_Type__c == 'Frame'){
opp.Allow_new_process_for_Japan_picklist__c = 'pending';
}else if(opp.Customer_Type__c == 'Other'){
opp.Allow_new_process_for_Japan_picklist__c = 'not allow';
}
}

}
*/
            
            
            /*满足条件运费清零  modafy by han 20170712 */
            if(Trigger.isBefore){
                String str=opp.delivey_point__c;
                if(string.isEmpty(str)){
                    str='-1';
                }
                // system.debug('str.indexOf(Brazil)'+str.indexOf('Brazil'));
                if(opp.Trade_Term__c == 'CIF' && opp.Seller__c	== 'JINKOSOLAR TECHNOLOGY LIMITED' &&  str.indexOf('Brazil') !=-1){
                    opp.Land_Freight_China__c = 0;
                    opp.Ocean_Freight__c =0;
                    opp.Land_Freight_Oversea__c=0; 
                }else if(opp.Trade_Term__c == 'CIF' && opp.Departure_Factory__c == 'ShangRao Factory' ){
                    //    opp.Land_Freight_China__c = 'Truck: CNY 7,045 / 40HQ | Railway: CNY 5,574.9 / 40HQ';
                }else if(opp.Trade_Term__c == 'CIF' && opp.Departure_Factory__c == 'HaiNing Factory' ){
                    //    opp.Land_Freight_China__c = 'Truck: CNY 4,245 / 40HQ';
                }
                
                /*  if(opp.Destination_Port__c != null){
opp.Ocean_Freight__c = null;
for(Transit_Fees_Database__c fee : feeList){
if(opp.Destination_Port__c == fee.Port__c && getprice){
//     opp.Ocean_Freight__c = opp.Ocean_Freight__c + fee.CurrencyIsoCode + ' ' + fee.Price__c + ' / ' + fee.Size__c + ' | ';
}
}
}*/
                
                //add 20160203 Customer Type = Standard -> allow ; GTAC Frame -> Pending ; Other -> now allow
                if(opp.Customer_Type__c != null){
                    if(opp.Customer_Type__c == 'Jinko Standard Japan'){
                        opp.Allow_new_process_for_Japan_picklist__c = 'allow';
                    }else if(opp.Customer_Type__c == 'GTAC' || opp.Customer_Type__c == 'Frame'){
                        opp.Allow_new_process_for_Japan_picklist__c = 'pending';
                    }else if(opp.Customer_Type__c == 'Other'){
                        opp.Allow_new_process_for_Japan_picklist__c = 'not allow';
                    }
                }
                
            }
            /* uopdate code end*/
        }
    }
    
    
    if(!Test.isRunningTest() && Trigger.isUpdate){
        
        List<Transit_Fees_Database__c> feeList = [SELECT ID,Name,Port__c,Price__c,Size__c,CurrencyIsoCode FROM Transit_Fees_Database__c];
        
        for(Opportunity opp_new : trigger.new){
            for(Opportunity opp_old : trigger.old){
                system.debug('******opp_new****' +opp_new.Price_Approval_Status__c+'******opp_new****'+opp_new.Sales_manager_approval__c);
                SYSTEM.DEBUG('TEST OLD:'+opp_old.Ocean_Freight__c);
                SYSTEM.DEBUG('TEST NEW:'+opp_new.Ocean_Freight__c);
                Boolean sendornot = false;
                Boolean getprice  = false;
                if(opp_new.Trade_Term__c == 'CIF'){
                    sendornot = false;
                    getprice  = true;
                }else if(opp_new.Trade_Term__c != 'CIF' && opp_new.Trade_Term__c == 'EXW Factory' && opp_new.Trade_Term__c == 'EXW Overseas Warehouse'){
                    sendornot = true;
                    getprice  = false;  
                }else if( (opp_new.Trade_Term__c == 'EXW Factory' || opp_new.Trade_Term__c == 'EXW Overseas Warehouse') && opp_new.isEurope__c == 'true'){
                    sendornot = false;
                    getprice  = false;
                }else if( (opp_new.Trade_Term__c == 'EXW' || opp_new.Trade_Term__c == 'EXW Factory' || opp_new.Trade_Term__c == 'EXW LA SPEZIA' || opp_new.Trade_Term__c != 'EXW Overseas Warehouse') && opp_new.isEurope__c == 'false'){
                    sendornot = true;
                    getprice  = false;
                }
                
                if(Trigger.isAfter){
                    if(opp_new.Id == opp_old.Id){
                        
                        if(opp_new.Trade_Term__c != opp_old.Trade_Term__c || opp_new.Destination_Port__c != opp_old.Destination_Port__c){
                            // if(!opp_new.is_intercompany__c && sendornot)SendEmailUtils.sendToLogistics(opp_new.Id);
                        }
                        
                    }
                    
                    
                }
                
                if(Trigger.isBefore){
                    if(opp_new.Id == opp_old.Id){
                        if(opp_new.Payment_Term_Description__c==null){
                            opp_new.Payment_Term_Description__c='';
                        }
                        if(opp_old.Payment_Term_Description__c!=null){
                            SYSTEM.DEBUG('更改判断依据:'+opp_new.Payment_Term_Description__c);
                            SYSTEM.DEBUG('更改判断依据:'+opp_old.Payment_Term_Description__c);
                            SYSTEM.DEBUG('更改判断依据:'+opp_new.Payment_Term_Description__c.length());
                            SYSTEM.DEBUG('更改判断依据:'+opp_old.Payment_Term_Description__c.length());
                            if((opp_new.Trade_Term__c != opp_old.Trade_Term__c || opp_new.Destination_Port__c != opp_old.Destination_Port__c || opp_new.Payment_Term_Description__c.length()-opp_old.Payment_Term_Description__c.length()>8 || opp_old.Payment_Term_Description__c.length()-opp_new.Payment_Term_Description__c.length()>8) ){
                                SYSTEM.DEBUG('jinrupanduan');
                                if(opp_new.Trade_Term__c != opp_old.Trade_Term__c){
                                    SYSTEM.DEBUG('更改判断依据:'+opp_new.Trade_Term__c);
                                    SYSTEM.DEBUG('更改判断依据:'+opp_old.Trade_Term__c);
                                }
                                if(opp_new.Destination_Port__c != opp_old.Destination_Port__c){
                                    SYSTEM.DEBUG('更改判断依据:'+opp_new.Destination_Port__c);
                                    SYSTEM.DEBUG('更改判断依据:'+opp_old.Destination_Port__c);
                                }
                                if(opp_new.Payment_Term_Description__c != opp_old.Payment_Term_Description__c){
                                    SYSTEM.DEBUG('更改判断依据:'+opp_new.Payment_Term_Description__c);
                                    SYSTEM.DEBUG('更改判断依据:'+opp_old.Payment_Term_Description__c);
                                    SYSTEM.DEBUG('更改判断依据:'+opp_new.Payment_Term_Description__c.length());
                                    SYSTEM.DEBUG('更改判断依据:'+opp_old.Payment_Term_Description__c.length());
                                }
                                if(opp_new.Price_Approval_Status__c!=''&& opp_new.Price_Approval_Status__c!=null && opp_new.Total_MW__c>1){
                                    system.debug('V1');
                                    opp_new.Price_Approval_Status__c = 'Pending';
                                    opp_new.HaoXinMeng_Approvel__c = 'Pending';
                                }
                                if(opp_new.Cross_Region__c){
                                    opp_new.Cross_region_GM_approval__c = 'Pending';  
                                }
                                if((
                                    ((opp_old.Trade_Term__c=='FOB' ||opp_old.Trade_Term__c=='EXW'||opp_old.Trade_Term__c=='FCA')&&(opp_new.Trade_Term__c=='CIF'||opp_new.Trade_Term__c=='CFR'))||
                                    ((opp_old.Trade_Term__c=='FOB' ||opp_old.Trade_Term__c=='EXW'||opp_old.Trade_Term__c=='FCA')&&(opp_new.Trade_Term__c=='DDP'||opp_new.Trade_Term__c=='DAP'||opp_new.Trade_Term__c=='DAT'||opp_new.Trade_Term__c=='CIP'))||
                                    ((opp_old.Trade_Term__c=='CIF' ||opp_old.Trade_Term__c=='CFR')&&(opp_new.Trade_Term__c=='DDP'||opp_new.Trade_Term__c=='DAP'||opp_new.Trade_Term__c=='DAT'||opp_new.Trade_Term__c=='CIP')) ) && (opp_new.Region__c =='EU(Union)'||opp_new.Region__c =='EU(Non-Eu)')){
                                        opp_new.Sales_manager_approval__c = 'Pending';
                                        
                                    }
                                else if(opp_new.Region__c !='EU(Union)' &&  opp_new.Region__c !='EU(Non-Eu)'){
                                    opp_new.Sales_manager_approval__c = 'Pending';
                                    
                                }
                                
                            }
                            
                        }
                        /**
                        if(
                            ((opp_new.Land_Freight_China__c != opp_old.Land_Freight_China__c || 
                              opp_new.Land_Freight_Oversea__c != opp_old.Land_Freight_Oversea__c || opp_new.Ocean_Freight__c != opp_old.Ocean_Freight__c)  )
                            
                        ){
                            SYSTEM.DEBUG('TEST OLD:'+opp_old.Ocean_Freight__c);
                            SYSTEM.DEBUG('TEST NEW:'+opp_new.Ocean_Freight__c);
                            
                            if(
                                (opp_old.Land_Freight_China__c!=null&& opp_new.Land_Freight_China__c>1.1*opp_old.Land_Freight_China__c)||
                                (opp_old.Land_Freight_Oversea__c!=null&& opp_new.Land_Freight_Oversea__c>1.1*opp_old.Land_Freight_Oversea__c)||
                                (opp_old.Ocean_Freight__c!=null&& opp_new.Ocean_Freight__c>1.1*opp_old.Ocean_Freight__c)
                            ){
                                system.debug('jinlaila');
                                if(opp_new.Price_Approval_Status__c!=''&& opp_new.Price_Approval_Status__c!=null && opp_new.Total_MW__c>1){
                                    opp_new.Price_Approval_Status__c = 'Pending';
                                    opp_new.HaoXinMeng_Approvel__c = 'Pending';
                                }
                                if(opp_new.Cross_Region__c){
                                    opp_new.Cross_region_GM_approval__c = 'Pending';
                                }
                                if(opp_new.Region__c !='EU(Union)' &&  opp_new.Region__c !='EU(Non-Eu)'){
                                    opp_new.Sales_manager_approval__c = 'Pending';
                                    
                                }
                            }
                            
                            decimal freight1;
                            decimal freight2;
                            if(opp_new.Land_Freight_Oversea__c ==NULL){
                                freight2 =0;
                            }else{freight2=opp_new.Land_Freight_Oversea__c;}
                            if(opp_OLD.Land_Freight_Oversea__c ==NULL){
                                freight1 =0;
                            }else{freight1=opp_OLD.Land_Freight_Oversea__c;}
                            if(opp_new.Region__c =='EU(Union)' ||  opp_new.Region__c =='EU(Non-Eu)'){
                                if(freight2>0.01){
                                    
                                    if((opp_new.Trade_Term__c=='DDP' ||opp_new.Trade_Term__c=='DAP'||opp_new.Trade_Term__c=='DAT'||opp_new.Trade_Term__c=='CIP')
                                       
                                      ){
                                          opp_new.Sales_manager_approval__c = 'Pending';
                                          if(opp_new.Cross_Region__c){
                                              opp_new.Cross_region_GM_approval__c = 'Pending';
                                          }
                                      }
                                }
                            }
                            system.debug('******opp_new****' +opp_new.Price_Approval_Status__c+'******opp_new****'+opp_new.Sales_manager_approval__c);
                            system.debug('opp_old.Contract__c'+opp_old.Contract__c);
                            system.debug('sendToBMO11------>');
                            //通知业务机会Owner和对应的BMO（在User对象取值）
                            SendEmailUtils.sendToOppOwner(opp_new.Id,opp_new.OwnerId);
                            SendEmailUtils.sendToBMO(opp_new.Id,opp_new.OwnerId);
                        }
**/
                        
                        /* 从业务机会行项目trigger中移植过来 解决 101 报错  update by jason 2017/07/13
// update code start
if(opp_new.Sales_Region__c !='North Asia'){
if (opp_new.Total_Quantity__c != opp_old.Total_Quantity__c || opp_new.Total_Power__c != opp_old.Total_Power__c || opp_new.Total_Price__c != opp_old.Total_Price__c) {      
if(opp_new.Price_Approval_Status__c!=''&& opp_new.Price_Approval_Status__c!=null){
system.debug('V2');
system.debug(''+opp_new.Total_Quantity__c+';'+opp_old.Total_Quantity__c+';'+opp_new.Total_Power__c+';'+opp_old.Total_Power__c+';'+opp_new.Total_Price__c+';'+opp_old.Total_Price__c);
opp_new.Price_Approval_Status__c = 'Pending';
opp_new.HaoXinMeng_Approvel__c = 'Pending';
}
opp_new.Sales_manager_approval__c = 'Pending'; 
if(opp_new.Cross_Region__c){
opp_new.Cross_region_GM_approval__c = 'Pending';
}
}  
}


//update code end
//Approval Status = approved 通知Owner BMO
if(opp_new.Price_Approval_Status__c == 'Approved' && opp_new.Price_Approval_Status__c != opp_old.Price_Approval_Status__c){

SendEmailUtils.sendToOppOwner(opp_new.Id,opp_new.OwnerId);
SendEmailUtils.sendToBMO(opp_new.Id,opp_new.OwnerId);
}   

//取ocean值
if(opp_new.Destination_Port__c != opp_old.Destination_Port__c && getprice){
if(opp_new.Destination_Port__c != null){
opp_new.Ocean_Freight__c = null;  

for(Transit_Fees_Database__c fee : feeList){
if(opp_new.Destination_Port__c == fee.Port__c && getprice){
//       opp_new.Ocean_Freight__c = opp_new.Ocean_Freight__c + fee.CurrencyIsoCode + ' ' + fee.Price__c + ' / ' + fee.Size__c + ' | ';
}
}
}
}

//当卖方为jinko，仓库包含巴西，交易方式为CIF，三种运费为0  update by han 2017/07/12
String str=opp_new.delivey_point__c;
if(opp_new.Trade_Term__c != opp_old.Trade_Term__c || opp_new.Seller__c != opp_old.Seller__c || opp_new.delivey_point__c != opp_old.delivey_point__c ){
if(String.isNotEmpty(str)){
if(opp_new.Trade_Term__c == 'CIF' && opp_new.Seller__c == 'JINKOSOLAR TECHNOLOGY LIMITED' &&  str.indexOf('Brazil') !=-1){
opp_new.Land_Freight_China__c = 0;
opp_new.Ocean_Freight__c =0;
opp_new.Land_Freight_Oversea__c=0;
}
}else if(opp_new.Trade_Term__c == 'CIF' && opp_new.Departure_Factory__c == 'ShangRao Factory'){
//   opp_new.Land_Freight_China__c = 'Truck: CNY 7,045 / 40HQ | Railway: CNY 5,574.9 / 40HQ';
}else if(opp_new.Trade_Term__c == 'CIF' && opp_new.Departure_Factory__c == 'HaiNing Factory'){
//   opp_new.Land_Freight_China__c = 'Truck: CNY 4,245 / 40HQ';
}

}
//取陆运值  老逻辑
/**
if(opp_new.Trade_Term__c != opp_old.Trade_Term__c){                            /**
if(opp_new.Trade_Term__c == 'CIF' && opp_new.Departure_Factory__c == 'ShangRao Factory'){                               if(opp_new.Trade_Term__c != opp_old.Trade_Term__c ){
if(opp_new.Trade_Term__c == 'CIF' && opp_new.Departure_Factory__c == 'ShangRao Factory' &&  str.indexOf('Brazil') ==-1){
opp_new.Land_Freight_China__c = 'Truck: CNY 7,045 / 40HQ | Railway: CNY 5,574.9 / 40HQ';                                        opp_new.Land_Freight_China__c = 'Truck: CNY 7,045 / 40HQ | Railway: CNY 5,574.9 / 40HQ';
}else if(opp_new.Trade_Term__c == 'CIF' && opp_new.Departure_Factory__c == 'HaiNing Factory'){                                  }else if(opp_new.Trade_Term__c == 'CIF' && opp_new.Departure_Factory__c == 'HaiNing Factory' &&  str.indexOf('Brazil') ==-1){
opp_new.Land_Freight_China__c = 'Truck: CNY 4,245 / 40HQ';                                      opp_new.Land_Freight_China__c = 'Truck: CNY 4,245 / 40HQ';
}                                   }

}
*/
                    }
                    
                    //add 20160203 Customer Type = Standard -> allow ; GTAC Frame -> Pending ; Other -> now allow
                    if(opp_new.Customer_Type__c != null && opp_new.Customer_Type__c != opp_old.Customer_Type__c){
                        if(opp_new.Customer_Type__c == 'Jinko Standard Japan'){
                            opp_new.Allow_new_process_for_Japan_picklist__c = 'allow';
                        }else if(opp_new.Customer_Type__c == 'GTAC' || opp_new.Customer_Type__c == 'Frame'){
                            opp_new.Allow_new_process_for_Japan_picklist__c = 'pending';
                        }else if(opp_new.Customer_Type__c == 'Other'){
                            opp_new.Allow_new_process_for_Japan_picklist__c = 'not allow';
                        }
                    }
                    
                }
                
            }
        }
        
        
        /*if(Trigger.isAfter){
for(Opportunity opp_new : trigger.new){
for(Opportunity opp_old : trigger.old){
if(opp_new.Id == opp_old.Id){
if(opp_new.Trade_Term__c != opp_old.Trade_Term__c || opp_new.Destination_Port__c != opp_old.Destination_Port__c){
if(!opp_new.is_intercompany__c && opp_new.Logistic_Email__c == 'true')SendEmailUtils.sendToLogistics(opp_new.Id);
}
}
}          
}
}

if(Trigger.isBefore){
for(Opportunity opp_new : trigger.new){
for(Opportunity opp_old : trigger.old){
if(opp_new.Id == opp_old.Id){
if((opp_new.Trade_Term__c != opp_old.Trade_Term__c || opp_new.Destination_Port__c != opp_old.Destination_Port__c) && opp_old.Contract__c == null){
opp_new.Price_Approval_Status__c = 'Pending';
}

if((opp_new.Land_Freight_China__c != opp_old.Land_Freight_China__c || opp_new.Land_Freight_Oversea__c != opp_old.Land_Freight_Oversea__c || opp_new.Ocean_Freight__c != opp_old.Ocean_Freight__c) && opp_old.Contract__c == null){
opp_new.Price_Approval_Status__c = 'Pending';

//通知业务机会Owner和对应的BMO（在User对象取值）
SendEmailUtils.sendToOppOwner(opp_new.Id,opp_new.OwnerId);
SendEmailUtils.sendToBMO(opp_new.Id,opp_new.OwnerId);
}
}
}          
}
}*/
        
        
        //create by: Jason    20160420
        /*当业务机会中的trade term 修改时更新instruction 的信息*/
        if(Trigger.isBefore){
            if(Trigger.isUpdate || Trigger.isInsert) {
                for(Opportunity opp_new : trigger.new){
                    Opportunity opp_old = trigger.oldMap.get(opp_new.id);
                    
                    if(opp_new.Trade_Term__c != opp_old.Trade_Term__c){
                        //给delivey point赋值
                        //opp_new.delivey_point__c = PaymentHelper.retriveGuaranteedDeliveryDate(opp_new.Trade_Term__c);
                        //给Instruction赋值
                        opp_new.Instruction__c = PaymentHelper.retriveDeliveryPoint(opp_new.Trade_Term__c);
                        
                    }else{
                        opp_new.Instruction__c = PaymentHelper.retriveDeliveryPoint(opp_old.Trade_Term__c);
                    }
                } 
            }
            
        }
        
 
        
        /**
//create by:HanFan  20170726
//当业务机会中的Finance Price Approval Status字段变为approved,或者GM approval为approved且Payment 1MW Approve为真触发
if(Trigger.isAfter){
system.debug('--------->:isAfter && update');
OpportunityHandle.SendEmail(trigger.new,trigger.old);
system.debug('sendEmail22222'); 
}
*/
    }
    
}