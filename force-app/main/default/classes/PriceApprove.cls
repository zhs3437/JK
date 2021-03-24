/*
*create by : Jason
*create date : 20160701
*deceription ：1MW 价格审批 发送电子邮件给指定的人
*/


global class PriceApprove {
    webservice static void emailbox(String oppid){
        Opportunity opp = [select id,
                           emailbox__c,ApprovalNumbers__c
                           from Opportunity
                           where id =:oppId];
        opp.emailbox__c=true;
        update opp;
    }
    webservice static String sendtozuzhang(String oppid){

        Opportunity opp = [select id,
                           Total_MW__c,
                           Total_Quantity__c,
                           Region__c,
                           Special_Terms__c,
                           Land_Freight_China__c,
                           Land_Freight_Oversea__c,
                           Destination_Country__c,
                           Ocean_Freight__c,
                           Trade_Term__c,
                           Expect_Price_and_Comments__c,
                           RecordType.name,
                           Customer_Type__c,
                           Allow_new_process_for_Japan_picklist__c,
                           whether_pick_up_batch__c,
                           OwnerId,
                           Payment_1MW_Approve__c,
                           Owner.Region__c,
                           Owner.Contract_Approver__r.Name,
                           Owner.Contract_Review__r.Name,
                           Cross_Region__c,
                           Sales_manager_approval__c,
                           Cross_region_GM_approval__c,
                           Price_Approval_Status__c,
                           Price_GM_Approval_Start_Time__c,
                           Price_Approval_Trigger_Count__c,
                           Price_Approval_Trigger_Time__c,
                           Price_Review_Approval_Start_Time__c,
                           Price_Finance_Approval_Finish_time__c,
                           Sales_Region__c,
                           vn_fast__c,
                           Sales_Dept__c,
                           Price_GM_Approval_Finish_Time__c,
                           Owner.name,ApprovalNumbers__c
                           
                           from Opportunity
                           where id =:oppId];
  SendEmailUtils2.sendToSomeOne(opp.Id,opp.Owner.Contract_Review__r.name,'PriceApproveEmailAsia');   
        return '1';
    }
    webservice static String snedtovickysun(String oppid){
        Opportunity opp = [select id,
                           Total_MW__c,
                           Total_Quantity__c,
                           Region__c,
                           Special_Terms__c,
                           Land_Freight_China__c,
                           Land_Freight_Oversea__c,
                           Destination_Country__c,
                           Ocean_Freight__c,
                           Trade_Term__c,
                           Expect_Price_and_Comments__c,
                           RecordType.name,
                           Customer_Type__c,
                           Allow_new_process_for_Japan_picklist__c,
                           whether_pick_up_batch__c,
                           OwnerId,
                           Payment_1MW_Approve__c,
                           Owner.Region__c,
                           Owner.Contract_Approver__r.Name,
                           Owner.Contract_Review__r.Name,
                           Cross_Region__c,
                           Sales_manager_approval__c,
                           Cross_region_GM_approval__c,
                           Price_Approval_Status__c,
                           Price_GM_Approval_Start_Time__c,
                           Price_Approval_Trigger_Count__c,
                           Price_Approval_Trigger_Time__c,
                           Price_Review_Approval_Start_Time__c,
                           Price_Finance_Approval_Finish_time__c,
                           Sales_Region__c,
                           vn_fast__c,
                           Sales_Dept__c,
                           Price_GM_Approval_Finish_Time__c,
                           Owner.name,ApprovalNumbers__c
                           
                           from Opportunity
                           where id =:oppId];
          SendEmailUtils.sendToSomeOneId(opp.id,opp.Owner.Contract_Approver__r.Name,'Special_Price');       
        return '1';
    }
    webservice static String submit(String oppid){
        
        if(string.isEmpty(oppid))return 'Opporunity Id is null';
        
        Opportunity opp = [select id,
                           Total_MW__c,
                           Total_Quantity__c,
                           Region__c,
                           Special_Terms__c,
                           Land_Freight_China__c,
                           Land_Freight_Oversea__c,
                           Destination_Country__c,
                           Ocean_Freight__c,
                           Trade_Term__c,
                           Expect_Price_and_Comments__c,
                           RecordType.name,
                           Customer_Type__c,
                           Allow_new_process_for_Japan_picklist__c,
                           whether_pick_up_batch__c,
                           OwnerId,
                           Payment_1MW_Approve__c,
                           Owner.Region__c,
                           Owner.Contract_Approver__r.Name,
                           Owner.Contract_Review__r.Name,
                           Cross_Region__c,
                           Sales_manager_approval__c,
                           Cross_region_GM_approval__c,
                           Price_Approval_Status__c,
                           Price_GM_Approval_Start_Time__c,
                           Price_Approval_Trigger_Count__c,
                           Price_Approval_Trigger_Time__c,
                           Price_Review_Approval_Start_Time__c,
                           Price_Finance_Approval_Finish_time__c,
                           Sales_Region__c,
                           vn_fast__c,
                           Sales_Dept__c,
                           Price_GM_Approval_Finish_Time__c,
                           Owner.name,ApprovalNumbers__c
                           
                           from Opportunity
                           where id =:oppId];
        Opportunity  opp2 = [SELECT ID,AccountId,
                             StageName,
                             RecordType.Name,
                             Payment_1MW_Approve__c,
                             Total_MW__c,
                             Trade_Term__c,
                             Total_Quantity__c,
                             Payment_Term_Description__c,
                             whether_pick_up_batch__c,
                             Price_Approval_Status__c,
                             Sales_manager_approval__c,
                             Customer_Type__c,
                             Allow_new_process_for_Japan_picklist__c,
                             Seller__c,
                             Special_Terms__c,
                             Region__c,
                             Price_Approval_Trigger_Count__c,
                             Price_Approval_Trigger_Time__c,
                             Contract__c,
                             Contract_No__c,
                             Account.credit_good__c,
                             Owner.Name
                             FROM Opportunity 
                             WHERE id =:opp.id];
        List<Payment__c> payList = [SELECT ID,
                                    Payment_Method__c 
                                    FROM Payment__c 
                                    WHERE Opportunity__c =: oppid AND (Payment_Method__c =: 'T/T' OR Payment_Method__c =: 'T/T (Balance)')];
        
        
		//如果是欧洲地区的，点击价格审批间隔时间为五分钟
        if(opp !=null){
            
      
        if(opp.Price_Approval_Trigger_Time__c!=null){

        if(opp.Owner.Region__c.contains('EU') ||opp.Region__c.contains('EU')){//DateTime.now()-opp.Price_Approval_Trigger_Time__c<5
            if(opp.Price_Approval_Trigger_Time__c.addMinutes(5)>DateTime.now()){
                System.debug('欧洲防止重复点击价格审批');
                return 'You shall not multi-trigger approval, now you have to wait 5 minutes';
            }
        } 
            else{ if(opp.Price_Approval_Trigger_Time__c.addMinutes(1)>DateTime.now()){
                System.debug('其他地区重复点击价格审批');
                return 'You shall not multi-trigger approval, now you have to wait 1 minutes';
            }}   
}        
          }
        
        
         //如果owner是唐晨或者卞文倩，发邮件给Cynthia Li
   /**
        if((opp.OwnerId=='0056F000009rBBY' || opp.OwnerId=='00590000000Lgv1') &&(opp.ApprovalNumbers__c ==0 || opp.ApprovalNumbers__c ==null)){
            System.debug('唐晨或者卞文倩,发邮件给Cynthia Li');
            SendEmailUtils.sendToSomeOne(opp.id,'Cynthia Li','Special_Price_No_need_Approve');    
            //SendEmailUtils.sendToSomeOne(opp.id,'Cynthia Li','Special_Price');    
            System.debug('邮件发送成功');
        }
        **/
        if(opp.Region__c =='ROA'){
             for(GroupMember gm : [
                  Select gm.UserOrGroupId 
				  from GroupMember gm 
				  where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Aroon Jiamkasemnit(team)')]){
                      if(gm.UserOrGroupId==opp.OWNERID){
                       GroupMember aroon =   [Select gm.UserOrGroupId 
				           from GroupMember gm 
				           where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='aroon.jiamkasemnit')][0];
                        SendEmailUtils.sendToSomeOneId(opp.id,aroon.UserOrGroupId,'Special_Price');    
                          
                      }
                  }
             for(GroupMember gm : [
                  Select gm.UserOrGroupId 
				  from GroupMember gm 
				  where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Anita Li(team)')]){
                      if(gm.UserOrGroupId==opp.OWNERID){
                       GroupMember aroon =   [Select gm.UserOrGroupId 
				           from GroupMember gm 
				           where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Anita Li(Leader)')][0];
                        SendEmailUtils.sendToSomeOneId(opp.id,aroon.UserOrGroupId,'Special_Price');    
                          
                      }
                  }
              for(GroupMember gm : [
                  Select gm.UserOrGroupId 
				  from GroupMember gm 
				  where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Simon Wong')]){
                      if(gm.UserOrGroupId==opp.OWNERID){
                       GroupMember aroon =   [Select gm.UserOrGroupId 
				           from GroupMember gm 
				           where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Simon Wong(Leader)')][0];
                          SendEmailUtils.sendToSomeOneId(opp.id,aroon.UserOrGroupId,'Special_Price');       
                      }
                  }
             
              for(GroupMember gm : [
                  Select gm.UserOrGroupId 
				  from GroupMember gm 
				  where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Bright Wang')]){
                      if(gm.UserOrGroupId==opp.OWNERID){
                       GroupMember aroon =   [Select gm.UserOrGroupId 
				           from GroupMember gm 
				           where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Bright Wang(Leader)')][0];
                         SendEmailUtils.sendToSomeOneId(opp.id,aroon.UserOrGroupId,'Special_Price');          
                      }
                  }
             
              for(GroupMember gm : [
                  Select gm.UserOrGroupId 
				  from GroupMember gm 
				  where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Ekarat Paramawanich')]){
                      if(gm.UserOrGroupId==opp.OWNERID){
                       GroupMember aroon =   [Select gm.UserOrGroupId 
				           from GroupMember gm 
				           where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Ekarat Paramawanich(Leader)')][0];
                          SendEmailUtils.sendToSomeOneId(opp.id,aroon.UserOrGroupId,'Special_Price');          
                      }
                  }
             
              for(GroupMember gm : [
                  Select gm.UserOrGroupId 
				  from GroupMember gm 
				  where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Shehan Talagala')]){
                      if(gm.UserOrGroupId==opp.OWNERID){
                       GroupMember aroon =   [Select gm.UserOrGroupId 
				           from GroupMember gm 
				           where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Shehan Talagala(Lead)')][0];
                         SendEmailUtils.sendToSomeOneId(opp.id,aroon.UserOrGroupId,'Special_Price');          
                      }
                  }
         }
        if(
            opp.Land_Freight_China__c==null && 
            opp.Land_Freight_Oversea__c==null
            && opp.Ocean_Freight__c==null &&
            (!(opp.Trade_Term__c == 'EXW'
               || opp.Trade_Term__c == 'CIF'
              || opp.Trade_Term__c == 'FOB'))
            && opp.Sales_Region__c != 'North Asia' && opp.Region__c != 'North America'){
                
                return 'There is no transit fees. please contact logistic to fill in.' ;
                
            }
        else if(string.isEmpty(opp.Expect_Price_and_Comments__c) && opp.RecordType.name != 'USA'){
            return 'Please fill in \'Expect Price and Comments\' information and click submit again.' ;
            
        }
        
        else if(opp.Owner.name=='Nancy Wang' || opp.Owner.name =='jaffer Wang'){
            //  SendEmailUtils.sendToFinanceAlex02(opp.id);
            System.debug('~~~~~~~~~~ sendToFinanceAlex02:'
                         + '\n \t\t' + opp.Total_MW__c
                         + '\n \t\t' + opp.Total_Quantity__c
                         + '\n \t\t' + opp.Payment_1MW_Approve__c
                         + '\n \t\t' + opp.Special_Terms__c
                         + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                         + '\n \t\t' + opp.Trade_Term__c
                         + '\n \t\t' + opp.Customer_Type__c);
            //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
            if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            update opp;
            
            //发送邮件前保存业务机会信息
            //  OpportunityApprovalCounts.Addaction(opp.id);
               String name1;
            if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c>1){//修改1兆瓦价格审批去除法务alex  by joel
                  name1=  SendEmailUtils.sendToFinanceAlex02(opp.id);    
            }
            /*else if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c<=1 && opp.Sales_manager_approval__c!='Approved'){
                name1 = SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
            }*/
            //return  'Submit success. '+name1+ ' has received this request.';
            System.debug('return测试1');
            return  'Submit success. '+name1+ ' has received this request.';
        } 
           else if(opp.Cross_Region__c == true ){
            String RegionHeadName ='';
            String RegionHeadEmail ='';
            if(opp.Region__c =='EU'|| opp.Region__c=='Non EU'){
                RegionHeadEmail=Label.Area_EU;
            }
            else if(opp.Region__c =='EU(Union)'|| opp.Region__c=='EU(Non-Eu)'){
                RegionHeadEmail=Label.Area_EU;
            }
            else if(opp.Region__c =='ROA'){
                RegionHeadEmail=Label.Area_ROA;
            }else if(opp.Region__c =='North Asia'){
                RegionHeadEmail=Label.Area_North_Asia;
            }else if(opp.Region__c =='South Asia'){
                RegionHeadEmail=Label.Area_South_Asia;
            }else if(opp.Region__c =='North America'){
                RegionHeadEmail=Label.Area_North_America;
            }else if(opp.Region__c =='Middle East&Africa'){
                RegionHeadEmail=Label.Area_Middle_east_africa;
            }else if(opp.Region__c =='Latin America&Italy'){
                RegionHeadEmail=Label.Area_Latin_America_Italy;
            }else if(opp.Region__c =='MENA'){
                RegionHeadEmail=Label.Middle_East_North_Africa;
            }else if(opp.Region__c =='SSA'){
                RegionHeadEmail=Label.Sub_Saharan_Africa;
            }
            if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                User us =[Select id,Name,Email,IsActive from User where Email =:RegionHeadEmail and IsActive = true];
                system.debug('*********user.Email***'+us.Email);
                system.debug('1111');
                if(us !=null){
                    RegionHeadName =us.Name;
                }}
               if(opp.Sales_manager_approval__c!='Approved' && opp.Sales_Region__c!='North Asia'){
            SendEmailUtils.sendToSomeOne(opp.id,opp.Owner.Contract_Approver__r.Name,'Cross_region_price_approval');
            }
                if(opp.Sales_manager_approval__c!='Approved' && opp.Sales_Region__c=='North Asia'){
            SendEmailUtils.sendToSomeOne(opp.id,opp.Owner.Contract_Review__r.Name,'Cross_region_price_approval');
               
                    SendEmailUtils.sendToSomeOne(opp.id,'Cynthia Li','Cross_region_price_approval_CynthiaLi');     
            }
               /**
               if(opp.Sales_manager_approval__c!='Approved' && opp.Sales_Region__c=='North Asia' && opp.Total_Quantity__c>800){
            SendEmailUtils.sendToSomeOne(opp.id,opp.Owner.Contract_Approver__r.Name,'Cross_region_price_approval');
            }
               if(opp.Sales_manager_approval__c!='Approved' && opp.Sales_Region__c=='North Asia' && opp.Total_Quantity__c<=800){
            //部署替换
                   SendEmailUtils.sendToSomeOne(opp.id,'Derrick Zong','Cross_region_price_approval');
            }
               */
            system.debug('2222'+opp.Owner.Contract_Approver__r.Name);
            
            system.debug('RegionHeadName'+RegionHeadName);
               if(opp.Cross_region_GM_approval__c!='Approved'){
            SendEmailUtils.sendToSomeOne(opp.id,RegionHeadName,'Special_Price');
            }
            system.debug('333');
            //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
            if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            update opp;
            
            //发送邮件前保存业务机会信息
            //    OpportunityApprovalCounts.Addaction(opp.id);
            System.debug('return测试2');
               if(opp.Sales_Region__c=='North Asia'){
                    return  'Submit success. '+ RegionHeadName+','+opp.Owner.Contract_Review__r.Name+  ' has received this request.';
               }
               else{
            return  'Submit success. '+ RegionHeadName+','+opp.Owner.Contract_Approver__r.Name+  ' has received this request.';
               }
        }
        else if (opp.RecordType.name == 'USA'){
              if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        opp.Price_Approval_Trigger_Time__c=DateTime.now();
 
                        
            update opp;
            
            //发送邮件前保存业务机会信息
            //   OpportunityApprovalCounts.Addaction(opp.id);
            String name2;  
            if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c>1){ //by joel,此处有发邮件给alex的判断
                name2=SendEmailUtils.sendToFinance(opp.id);  
            }else if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c<=1){
                name2=SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
            }
           
            System.debug('return测试3');
            return  'Submit success. '+name2+ ' has received this request.';
        }
        else if(opp.vn_fast__c==true && opp.Total_MW__c<3){
                   if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                   opp.Price_Approval_Trigger_Time__c=DateTime.now();
                   update opp;
                   //发送邮件前保存业务机会信息
                   //  OpportunityApprovalCounts.Addaction(opp.id);
                   String namevn;  
                   if(opp.Sales_manager_approval__c!='Approved'){
                    namevn=SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
                      }
            		System.debug('return测试3-3');
                   return  'Submit success. '+namevn+ ' has received this request.';            
        }
        else if((opp.Destination_Country__c == 'Australia'||opp.Destination_Country__c == 'New Zealand' )&& (opp.Owner.name!='Nancy Wang' || opp.Owner.name != 'jaffer Wang')){
            system.debug('2019/1/10'+opp);
            if((opp.Total_MW__c <= 1  ||(opp2.Account.credit_good__c==true && opp.Total_MW__c<1.5))
               && opp.Destination_Country__c !='New Zealand'
               && opp.Trade_Term__c == 'DDP' 
               && payList.size() > 0
               && opp.whether_pick_up_batch__c == 'True'){
                   system.debug('2019/1/10');
                   //	SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);	
                   System.debug('~~~~~~~~~~ sendToContractApprover:'
                                + '\n \t\t' + opp.Total_MW__c
                                + '\n \t\t' + opp.Total_Quantity__c
                                + '\n \t\t' + opp.Payment_1MW_Approve__c
                                + '\n \t\t' + opp.Special_Terms__c
                                + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                                + '\n \t\t' + opp.Trade_Term__c
                                + '\n \t\t' + opp.Customer_Type__c);
                   //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                   if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                   opp.Price_Approval_Trigger_Time__c=DateTime.now();
                   update opp;
                   //发送邮件前保存业务机会信息
                   //  OpportunityApprovalCounts.Addaction(opp.id);
                   String name3;  
                   if(opp.Sales_manager_approval__c!='Approved'){
                    name3=SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
                      }
                   System.debug('return测试4');
                   return  'Submit success. '+name3+ ' has received this request.';
                   
               }
            else if((opp.Total_MW__c <= 1  ||(opp2.Account.credit_good__c==true && opp.Total_MW__c<1.5))
                    && opp.Trade_Term__c == 'EXW'
                    && payList.size() > 0){
                        //SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);	
                        System.debug('~~~~~~~~~~ sendToContractApprover:'
                                     + '\n \t\t' + opp.Total_MW__c
                                     + '\n \t\t' + opp.Total_Quantity__c
                                     + '\n \t\t' + opp.Payment_1MW_Approve__c
                                     + '\n \t\t' + opp.Special_Terms__c
                                     + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                                     + '\n \t\t' + opp.Trade_Term__c
                                     + '\n \t\t' + opp.Customer_Type__c);
                        //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                        if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        opp.Price_Approval_Trigger_Time__c=DateTime.now();
                        update opp;
                        
                        //发送邮件前保存业务机会信息
                        //  OpportunityApprovalCounts.Addaction(opp.id);
                        String name4;
                        if(opp.Sales_manager_approval__c!='Approved'){
                  name4=SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
                      }
                        System.debug('return测试5');
                        return  'Submit success. '+name4+ ' has received this request.';		
                        
                    }
            else {
                //SendEmailUtils.sendToFinance(opp.id);
                System.debug('~~~~~~~~~~ sendToFinance:'
                             + '\n \t\t' + opp.Total_MW__c
                             + '\n \t\t' + opp.Total_Quantity__c
                             + '\n \t\t' + opp.Payment_1MW_Approve__c
                             + '\n \t\t' + opp.Special_Terms__c
                             + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                             + '\n \t\t' + opp.Trade_Term__c
                             + '\n \t\t' + opp.Customer_Type__c);
                //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                opp.Price_Approval_Trigger_Time__c=DateTime.now();
                update opp;
                
                //发送邮件前保存业务机会信息
                //    OpportunityApprovalCounts.Addaction(opp.id);
                  String name8;
                if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c>1){//by joel 
                      name8= SendEmailUtils.sendToFinance(opp.id);
                }
                String name8_1;
                if(opp.Sales_manager_approval__c!='Approved'){
                    name8_1 =SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
                }
                if(name8 !=null && name8_1==null){
                    return  'Submit success. '+name8+ ' has received this request.';
                }else if(name8 ==null && name8_1!=null){
                    return  'Submit success. '+name8_1+ ' has received this request.';
                         }
                
                System.debug('return测试1-1');
                return  'Submit success. '+name8+name8_1+ ' has received this request.';
                
            }
            
        }
        //跨区域业务机会，发邮件给区域负责人与业务机会所有者的区域负责人
     
        
        //日本区简化流程
        //create by Han 20180112
        
        else if((opp.RecordType.name == 'Japan' || (opp.Region__c =='North Asia' && opp.Destination_Country__c=='South Korea')) && opp.Total_MW__c > 1 && opp.Cross_Region__c == false){
            
            system.debug('*****************针对韩国区域也发送给GM');
            opp.Price_GM_Approval_Start_Time__c = DateTime.now();
           /**
            User us =[Select id,Name,Email from User where Email =:Label.Area_North_Asia];
             if(us !=null){
               if(opp.Sales_manager_approval__c!='Approved'){
                SendEmailUtils.sendToContractApprover(opp.Id, opp.OwnerId);
                   }
            }

            
             if(opp.Total_Quantity__c>800){
            if(us !=null){
               if(opp.Sales_manager_approval__c!='Approved'){
                SendEmailUtils.sendToContractApprover(opp.Id, opp.OwnerId);
                   }
            }
            }else if(opp.Total_Quantity__c<=800){
               ////部署替换
                 if(opp.Sales_Dept__c!='Approved'){
                 SendEmailUtils.sendToSomeOne(opp.id,'Derrick Zong','Special_Price');
                 }
              //  SendEmailUtils.sendToContractApprover(opp.Id, opp.OwnerId);
            }
            */
            if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            update opp;
            String Aname='';
            if(opp.Price_Approval_Status__c!='Approved' &&opp.Total_MW__c>1){// by joel
                Aname=SendEmailUtils.sendToFinance(opp.id);
            }else{
                Aname='';
            }
            if(opp.Sales_Dept__c!='Approved'){
                if(opp.OwnerId!='00590000002Rx9V'){
            SendEmailUtils.sendToSomeOne(opp.Id, opp.Owner.Contract_Review__r.Name, 'PriceApproveEmailAsia');}
            else{
                SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
            }
            }
            //发送邮件前保存业务机会信息
            //     OpportunityApprovalCounts.Addaction(opp.id);
            if(opp.RecordType.name == 'Japan'){
                System.debug('return测试6');
                if(opp.OwnerId!='00590000002Rx9V'){
                return  '審査・承認の要請を所属GM'+Aname  + opp.Owner.Contract_Review__r.Name + ' に提出済。';
                    }
                else{
                return  '審査・承認の要請を所属GM'+Aname  + opp.Owner.Contract_Approver__r.Name + ' に提出済。';
                }
            }else{
                System.debug('return测试7');
                return  'Submit success. '+Aname  +opp.Owner.Contract_Review__r.Name+ ' has received this request.';
            }
            
        }
        else if((opp.RecordType.name == 'Japan'|| (opp.Region__c =='North Asia' && opp.Destination_Country__c=='South Korea'))  && opp.Total_MW__c < 1 && opp.Cross_Region__c == false){
            system.debug('123');
            
            
                if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            if(opp.OwnerId!='00590000002Rx9V'){
                SendEmailUtils.sendToSomeOne(opp.Id, opp.Owner.Contract_Review__r.Name, 'PriceApproveEmailAsia');
                }else{
                 SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);    
                }
                update opp;   
                System.debug('return测试8');
            if(opp.OwnerId!='00590000002Rx9V'){
                return '注意：　審査・承認の要請を所属チームリーダー'+opp.Owner.Contract_Review__r.Name+'に提出済。';
                }
            else{
                 return '注意：　審査・承認の要請を所属チームリーダー'+opp.Owner.Contract_Approver__r.Name+'に提出済。';
            }
          
        }
        
       
        else if((opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Payment_1MW_Approve__c == true){
            
            
            opp.Price_GM_Approval_Start_Time__c = DateTime.now();
            if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            User us;
            if(opp.Region__c == 'Middle East&Africa'){
                us =[Select id,Name,Email from User where Email =: Label.Area_Middle_east_africa limit 1];
            }else if(opp.Region__c == 'MENA'){
                us =[Select id,Name,Email from User where Email =: Label.Middle_East_North_Africa limit 1];
            }else if(opp.Region__c == 'SSA'){
                us =[Select id,Name,Email from User where Email =: Label.Sub_Saharan_Africa limit 1];
            }
            
            if(us !=null){
                   if(opp.Sales_manager_approval__c!='Approved'){
                       SendEmailUtils.sendToSomeOne(opp.Id, us.Name, 'Special_Price');}
            }
            update opp;                
            //发送邮件前保存业务机会信息
            //      OpportunityApprovalCounts.Addaction(opp.id);
                  System.debug('return测试10');
            return  'Submit success. '+us.Name + ' has received this request.';
            
        }
        else if((opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Payment_1MW_Approve__c == false){
            opp.Price_GM_Approval_Start_Time__c = DateTime.now();
            if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            User us;
            if(opp.Region__c == 'Middle East&Africa'){
                us =[Select id,Name,Email from User where Email =: Label.Area_Middle_east_africa limit 1];
            }else if(opp.Region__c == 'MENA'){
                us =[Select id,Name,Email from User where Email =: Label.Middle_East_North_Africa limit 1];
            }else if(opp.Region__c == 'SSA'){
                us =[Select id,Name,Email from User where Email =: Label.Sub_Saharan_Africa limit 1];
            }
            String alex;
            if(us !=null){
                   if(opp.Sales_manager_approval__c!='Approved'){
                       SendEmailUtils.sendToSomeOne(opp.Id, us.Name, 'Special_Price');}
                   if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c>1){ // refresh by joel
                alex= SendEmailUtils.sendToFinance(opp.id);
                   }else{
                       alex='';
                   }
            }
            update opp;                
            //发送邮件前保存业务机会信息
            //      OpportunityApprovalCounts.Addaction(opp.id);
            System.debug('return测试11');
            return  'Submit success. '+us.Name +','+alex+ ' has received this request.';
            
        }
        //20200305
        else if(opp.RecordType.name == 'Japan' && (opp.Owner.name!='Nancy Wang' || opp.Owner.name !='jaffer Wang')){
            //SendEmailUtils.sendToFinance(opp.id);
            //SendEmailUtils.sendToJapanGM(opp.id, opp.OwnerId); //此邮件只作为提示邮件
            //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
            if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
            update opp;
            
            //发送邮件前保存业务机会信息
            //   OpportunityApprovalCounts.Addaction(opp.id);
             String name5; 
            if(opp.Price_Approval_Status__c!='Approved' && opp.Total_MW__c>1){  //refresh by joel
                 name5= SendEmailUtils.sendToFinance(opp.id);
            }else{
                name5=SendEmailUtils.sendToSomeOne(opp.id,opp.Owner.Contract_Approver__r.Name,'Special_Price');//by joel
            }
            System.debug('return测试1-2');
            return  'Submit success. '+name5+ ' has received this request.';
            
        }
      /**
        else if( (opp.Owner.name!='Nancy Wang' || opp.Owner.name !='jaffer Wang')
                &&opp.Total_MW__c <= 1.0 
                //美国和欧洲
                && (opp.Region__c == 'EU' || opp.Region__c == 'North Of America' || opp.Region__c == 'EU(Union)')
                //&& (opp.Region__c == 'EU(Union)' || opp.Region__c == 'North Of America')
                && (opp.Trade_Term__c == 'CIF'
                    || opp.Trade_Term__c == 'EXW'
                    || opp.Trade_Term__c == 'FOB'
                    || opp.Trade_Term__c == 'DAP'
                    || opp.Trade_Term__c == 'DDP'
                    || opp.Trade_Term__c == 'CFR')
               ){
                   if(opp.Region__c == 'EU' && opp.Owner.Region__c == 'Middle East&Africa' || opp.Region__c == 'EU(Union)'){
                       //if(opp.Region__c == 'EU(Union)' && opp.Owner.Region__c == 'Middle East&Africa'){
                       System.debug('~~~~~~~~~~ 跨区域1MW，EU'
                                    + '\n \t\t' + opp.Total_MW__c
                                    + '\n \t\t' + opp.Total_Quantity__c
                                    + '\n \t\t' + opp.Payment_1MW_Approve__c
                                    + '\n \t\t' + opp.Special_Terms__c
                                    + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                                    + '\n \t\t' + opp.Trade_Term__c
                                    + '\n \t\t' + opp.Customer_Type__c);
                       //	SendEmailUtils.sendToEURegionHeader(opp.id);
                       //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                       if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                       opp.Price_Approval_Trigger_Time__c=DateTime.now();
                       update opp;
                       
                       //发送邮件前保存业务机会信息
                       // OpportunityApprovalCounts.Addaction(opp.id);
                       return  'Submit success. '+SendEmailUtils.sendToEURegionHeader(opp.id)+ ' has received this request.';
                       
                   }
                   else{
                       System.debug('~~~~~~~~~~ sendToFinance:美国和欧洲1MW'
                                    + '\n \t\t' + opp.Total_MW__c
                                    + '\n \t\t' + opp.Total_Quantity__c
                                    + '\n \t\t' + opp.Payment_1MW_Approve__c
                                    + '\n \t\t' + opp.Special_Terms__c
                                    + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                                    + '\n \t\t' + opp.Trade_Term__c
                                    + '\n \t\t' + opp.Customer_Type__c);
                       
                       //	SendEmailUtils.sendToFinance(opp.id);
                       //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                       if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                       opp.Price_Approval_Trigger_Time__c=DateTime.now();
                       
                       //发送邮件前保存业务机会信息
                       //  OpportunityApprovalCounts.Addaction(opp.id);
                       update opp;
                       String name6;
                        if(opp.Price_Approval_Status__c!='Approved'){
                 name6= SendEmailUtils.sendToFinance(opp.id);
                   }
                       return  'Submit success. '+name6+' has received this request.';
                       
                   }
                   //其他
               }
**/
        else if(opp.Total_MW__c <= 1.0 
                && (opp.Owner.name!='Nancy Wang' || opp.Owner.name !='jaffer Wang')
                && opp.Payment_1MW_Approve__c == true
                
                //&& opp.Region__c != 'EU' 
                && opp.Region__c != 'North Of America'
                && String.isEmpty(opp.Special_Terms__c)
                && (opp.Trade_Term__c == 'CIF'
                    || opp.Trade_Term__c == 'EXW'
                    || opp.Trade_Term__c == 'FOB'
                    || opp.Trade_Term__c == 'DAP'
                    || opp.Trade_Term__c == 'DDP'
                    || opp.Trade_Term__c == 'CFR'
                    || opp.Trade_Term__c == 'CIP'
                    || opp.Trade_Term__c == 'FCA')
                || opp.Trade_Term__c == 'DAT'){
                    if((opp.Region__c == 'Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Owner.Region__c == 'EU(Union)'){
                        //if(opp.Region__c == 'Middle East&Africa' && opp.Owner.Region__c == 'EU(Union)'){
                        system.debug('======跨区域1MW 中东' );
                        //SendEmailUtils.sendToMERegionHeader(opp.id);
                        //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                        if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        opp.Price_Approval_Trigger_Time__c=DateTime.now();
                        update opp;
                        System.debug('return测试12');
                        return  'Submit success. '+SendEmailUtils.sendToMERegionHeader(opp.id)+' has received this request.';
                    }
                    else{
                        System.debug('~~~~~~~~~~ sendToContractApprover: 1MW 其他情况'
                                     + '\n \t\t' + opp.Total_MW__c
                                     + '\n \t\t' + opp.Total_Quantity__c
                                     + '\n \t\t' + opp.Payment_1MW_Approve__c
                                     + '\n \t\t' + opp.Special_Terms__c
                                     + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                                     + '\n \t\t' + opp.Trade_Term__c
                                     + '\n \t\t' + opp.Customer_Type__c);
                        //SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
                        //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                        if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        opp.Price_Approval_Trigger_Time__c=DateTime.now();
                        update opp;
                        
                        //发送邮件前保存业务机会信息
                        // OpportunityApprovalCounts.Addaction(opp.id);
                        String name7;  
                        if(opp.Sales_manager_approval__c!='Approved'){
                             name7=   SendEmailUtils.sendToContractApprover(opp.id, opp.OwnerId);
                           }
                        System.debug('return测试3-4');
                        return  'Submit success. '+name7+ ' has received this request.';
                        
                    }	
                    
                }
			else {
                    if((opp.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp.Owner.Region__c == 'EU(Union)'){
                        //	if(opp.Region__c == 'Middle East&Africa' && opp.Owner.Region__c == 'EU(Union)'){
                        system.debug('======跨区域正常单子 中东 财务和区域老大' );
                        //SendEmailUtils.sendToFinance(opp.id);
                        //	SendEmailUtils.sendToMERegionHeader(opp.id);
                        //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                        if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        opp.Price_Approval_Trigger_Time__c=DateTime.now();
                        update opp;
                        
                        //发送邮件前保存业务机会信息
                        //  OpportunityApprovalCounts.Addaction(opp.id);
                        String AlexResult;
                        if(opp.Total_MW__c>1){//by joel
							AlexResult=SendEmailUtils.sendToFinance(opp.id);
                        }else{
                            AlexResult='';
                        }
                        
                            System.debug('return测试13');
                        return  'Submit success. '+ AlexResult + SendEmailUtils.sendToMERegionHeader(opp.id)+ ' has received this request.';
                    }
                    else if(opp.Region__c == 'EU(Union)' && (opp.Owner.Region__c == 'Middle East&Africa' ||opp.Region__c == 'MENA'||opp.Region__c == 'SSA')){   
                        //}else if(opp.Region__c == 'EU(Union)' && opp.Owner.Region__c == 'Middle East&Africa'){
                        system.debug('======跨区域正常单子 EU  财务和区域老大' );
                        //    SendEmailUtils.sendToFinance(opp.id);
                        //	SendEmailUtils.sendToEURegionHeader(opp.id);
                        //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                        if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        opp.Price_Approval_Trigger_Time__c=DateTime.now();
                        update opp;
                        
                        //发送邮件前保存业务机会信息
                        //   OpportunityApprovalCounts.Addaction(opp.id);
                        //   
                        //   
                        String AlexResult2;
                        if(opp.Total_MW__c>1){//by joel
                            AlexResult2=SendEmailUtils.sendToFinance(opp.id);
                        }else{
                            AlexResult2='';
                        }
                        System.debug('return测试3-5');
                        return 'Submit success. '+ AlexResult2 + SendEmailUtils.sendToEURegionHeader(opp.id)+ ' has received this request.';	
                        
                    }
                    else {
                        //发Finance
                        //SendEmailUtils.sendToFinance(opp.id);
                        if(opp.Price_Approval_Trigger_Count__c==null){
                opp.Price_Approval_Trigger_Count__c=1;
            }else{
                opp.Price_Approval_Trigger_Count__c=opp.Price_Approval_Trigger_Count__c+1;
            }
                        
                        
                        
            opp.Price_Approval_Trigger_Time__c=DateTime.now();
                        update opp;
                        System.debug('~~~~~~~~~~ sendToFinance: 所有情况都不满足'
                                     + '\n \t\t' + opp.Total_MW__c
                                     + '\n \t\t' + opp.Total_Quantity__c
                                     + '\n \t\t' + opp.Payment_1MW_Approve__c
                                     + '\n \t\t' + opp.Special_Terms__c
                                     + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                                     + '\n \t\t' + opp.Trade_Term__c
                                     + '\n \t\t' + opp.Customer_Type__c);
                        //create by HanFan 20170810 抓取业务机会提交价格审批开始时间
                      
                        //发送邮件前保存业务机会信息
                        // OpportunityApprovalCounts.Addaction(opp.id);
                        String GMEU;
                         if(opp.Sales_manager_approval__c!='Approved' ){
                             GMEU = SendEmailUtils.sendToSomeOne(opp.id,opp.Owner.Contract_Approver__r.Name,'Special_Price');
                         
                         }
                        
                         String name8;
                           if(opp.Price_Approval_Status__c!='Approved' &&opp.Total_MW__c>1){//refresh by joel
                               name8= SendEmailUtils.sendToFinance(opp.id);
                           }else{
                               name8='';
                           }
                        System.debug('return测试14');
                        return 'Submit success. '+GMEU+' '+name8+' has received this request.';
                        
                    }	
                    
                }
        System.debug('~~~~~~~~~~ sendToFinance: 发送失败'
                     + '\n \t\t' + opp.Total_MW__c
                     + '\n \t\t' + opp.Total_Quantity__c
                     + '\n \t\t' + opp.Payment_1MW_Approve__c
                     + '\n \t\t' + opp.Special_Terms__c
                     + '\n \t\t' + opp.Allow_new_process_for_Japan_picklist__c
                     + '\n \t\t' + opp.Trade_Term__c
                     + '\n \t\t' + opp.Customer_Type__c);
        return 'Error';
        
    }
    
    webservice static String submit2NothAisa(String oppid){
        if(string.isEmpty(oppid))return 'Opporunity Id is null';
        
        Opportunity opp = [select id,
                           Total_MW__c,
                           Total_Quantity__c,
                           Region__c,
                           Special_Terms__c,
                           Land_Freight_China__c,
                           Land_Freight_Oversea__c,
                           Destination_Country__c,
                           Ocean_Freight__c,
                           Trade_Term__c,
                           Expect_Price_and_Comments__c,
                           RecordType.name,
                           Customer_Type__c,
                           Allow_new_process_for_Japan_picklist__c,
                           whether_pick_up_batch__c,
                           OwnerId,
                           Payment_1MW_Approve__c,
                           Owner.Region__c,
                           Owner.Contract_Approver__r.Name,
                           Owner.Contract_Review__r.Name,
                           Cross_Region__c,
                           Sales_Region__c,
                           Price_GM_Approval_Start_Time__c,
                           Price_Approval_Trigger_Time__c,
                           Price_Review_Approval_Start_Time__c,
                           Price_Finance_Approval_Finish_time__c,
                           Price_GM_Approval_Finish_Time__c,
                           Japan_Finance_Trigger_Count__c,
                           Owner.name
                           from Opportunity
                           where id =:oppId];
          if(
            opp.Land_Freight_China__c==null && 
            opp.Land_Freight_Oversea__c==null
            && opp.Ocean_Freight__c==null &&
            (!(opp.Trade_Term__c == 'EXW'
               || opp.Trade_Term__c == 'CIF'))
            && opp.Sales_Region__c != 'North Asia' && opp.Region__c != 'North America'){
                
                return 'There is no transit fees. please contact logistic to fill in.' ;
                
            }
        else if(string.isEmpty(opp.Expect_Price_and_Comments__c) && opp.RecordType.name != 'USA'){
            return 'Please fill in \'Expect Price and Comments\' information and click submit again.' ;
            
        }
        if(opp.Japan_Finance_Trigger_Count__c==null){
            opp.Japan_Finance_Trigger_Count__c=1;
        }else{
        opp.Japan_Finance_Trigger_Count__c=opp.Japan_Finance_Trigger_Count__c+1;
        }
        opp.Japan_Finance_Trigger_Time__c=datetime.now();
        update opp;
        SendEmailUtils.sendToSomeOne(opp.id,'credit','Special_Price');
        return  'Submit success.  Japan Finance  has received this request.';        
    }
     
}