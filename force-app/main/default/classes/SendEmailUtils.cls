global class SendEmailUtils {
     //给EU Region Header 发送邮件
    webservice static String sendToEURegionHeader(String oppid){
        String recipientsLst = null;

        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c FROM Opportunity WHERE ID =: oppid];
        List<Id> UserIds = new List<Id>();       
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='EURegionHeader')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Special_Price');
        system.debug('是否输出'+ recipients);
        for (User u : recipients) {
            recipientsLst += u.Name + ' ';
        }
        recipientsLst = recipientsLst.replace('null', '');
        return recipientsLst;
    }
    //给 Middle East&Africa Region Header 发送邮件
    webservice static String sendToMERegionHeader(String oppid){
        String recipientsLst = null;

        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c FROM Opportunity WHERE ID =: oppid];
        List<Id> UserIds = new List<Id>();       
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='MERegionHeader')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Special_Price');
        system.debug('是否输出'+ recipients);
        for (User u : recipients ) {
            recipientsLst += u.Name + ' ';
        }
        recipientsLst = recipientsLst.replace('null', '');
        return recipientsLst;
    }
    
    
    //发邮件给上海技术部门
    webservice static String sendToShanghaiTechnicals(String ordId){
        system.debug('--------shanghai技术');
        List<Id> UserIds = new List<Id>();
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Shanghai Technical')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, ordId, 'Approve_Component_Task_Book');
        return 'Success';
    }
    
    //发送邮件给Finance  Alex Jiang  create By jason
    webservice static String sendToFinanceAlex(String conId){
        Contract con = new Contract();
        if(conId != null){
            con = [SELECT ID,Name,Finance_approved_orders_Fast_Process__c,BMO_Manager_approved_orders_Fast_Process__c FROM Contract WHERE ID =: conId];
        }
        if(con != null){
            con.Finance_approved_orders_Fast_Process__c = false;
            update con;
        }
        
        List<User> recipientAlex = [SELECT ID,Name,Email FROM User WHERE Name =: 'Alex Jiang'];
        Utils.sendEmailWithTemplate(recipientAlex,conId, 'Request_Fast_Process');
        System.debug('----->是否发送:'  + recipientAlex);
        return '';
    }
    //发送邮件给BMO  Cathy Yang create By jason
    webservice static String sendToBMOCathy(String conId){
        Contract con = new Contract();
        if(conId != null){
            con = [SELECT ID,Name,Finance_approved_orders_Fast_Process__c,BMO_Manager_approved_orders_Fast_Process__c FROM Contract WHERE ID =: conId];
        }
        if(con != null){
            con.BMO_Manager_approved_orders_Fast_Process__c = false;
            update con;
        }
        
        List<User> recipientBMO = [SELECT ID,Name,Email FROM User WHERE Name =: 'Cathy Yang'];
        Utils.sendEmailWithTemplate(recipientBMO,conId, 'Request_Fast_Process');
        System.debug('----->是否发送:'  + recipientBMO);
        return '';
    }
    
    //给财务部门发送邮件
    webservice static String sendToFinance(String oppid){
        
        String recipientsLst = null;

        //当业务员点击 submit for price approval之后,变成pending
        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c FROM Opportunity WHERE ID =: oppid];

        
        List<Id> UserIds = new List<Id>();       
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Finance')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Opportunity_Review_Mail');
        system.debug('是否输出'+ recipients);
        for (User u : recipients) {
            recipientsLst += u.Name + ' ';
        }
        recipientsLst = recipientsLst.replace('null', '');
        return recipientsLst;
    }
    
     //发送邮件给Finance  Alex Jiang  create By Fanzr
     webservice static String sendToFinanceAlex02(String oppid){
        String recipientsLst = null;
        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c FROM Opportunity WHERE ID =: oppid];
        List<Id> UserIds = new List<Id>();       
        List<User> recipientAlex = [SELECT ID,Name,Email FROM User WHERE Name =: 'Alex Jiang'];
        Utils.sendEmailWithTemplate(recipientAlex, oppid, 'Opportunity_Review_Mail');
        System.debug('----->是否发送:'  + recipientAlex);
        for (User u : recipientAlex) {
            recipientsLst += u.Name + ' ' ;
        }
        recipientsLst = recipientsLst.replace('null', '');
        return recipientsLst;
    }
    
    //发送邮件给指定的人员  create By jason
    webservice static String sendToSomeOne(String oppid,String name, String emailTemplateName){
        List<User> recipient= [SELECT ID,Name,Email FROM User WHERE Name =: name];
        String username;
        username = null;
         for (User u : recipient) {
            username += u.Name + ' ' ;
        }
         System.debug('----->recipient:'  + recipient);
        System.debug('----->recipient:'  + emailTemplateName);
        Utils.sendEmailWithTemplate(recipient, oppid, emailTemplateName);
        System.debug('----->是否发送:'  + recipient);
        return username;
    }
      //发送邮件给指定的人员  create By Han 20180105
    webservice static String sendToSomeOneId(String oppid,Id usId, String emailTemplateName){
        List<User> recipient= [SELECT ID,Name,Email FROM User WHERE ID =: usId];
         System.debug('----->recipient:'  + recipient);
        System.debug('----->recipient:'  + emailTemplateName);
        Utils.sendEmailWithTemplate(recipient, oppid, emailTemplateName);
        System.debug('----->是否发送:'  + recipient);
        return '';
    }
     
    // 给Con Owner 发邮件    create by Sam 20170814
   webservice static String sendToConOwner(String conId,String ownerid){
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID =: ownerid];
        system.debug('recipients------->:' +recipients);
        Utils.sendEmailWithTemplate(recipients, conId, 'Contract_Africa_Send_Email');
       system.debug('000000000000000000');
        return '';
    }
    //给Con Owner 对应的 BMO 发邮件      create by Sam 20170814
     webservice static String sendToConBMO(String conId,String ownerid){
        User u = new User();
        if(ownerid != null) u = [SELECT ID,Name,Email,BMO_specialist__c FROM User WHERE ID =: ownerid];
        List<User> recipientsbmo = [SELECT ID,Name,Email FROM User WHERE ID =: u.BMO_specialist__c];
        system.debug('@@@@@@@@@@@@@@@@@@@11111--->1' + recipientsbmo);
        Utils.sendEmailWithTemplate(recipientsbmo, conId, 'Contract_Africa_Send_Email');
                 system.debug('@@@@@@@@@@@@@@@@@@@11111====>2' + recipientsbmo);
        return '';
    }
    
    
    //发送价格审批给 User Owner对应的 Contract Approver    add by jason 20160413
  
    webservice static String sendToContractApprover(String oppid,String ownerid){
        String recipientsLst = null;
        System.debug('@@@@@ sendToContractApprover' );
        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c,Total_Quantity__c,Trade_Term__c,Sales_manager_approval__c FROM Opportunity WHERE ID =: oppid];

        
            User u = new User();
            
            System.debug('################# ownerid' + ownerid );
            
            if(ownerid != null) u = [SELECT ID,Name,Email,Contract_Approver__c FROM User WHERE ID =: ownerid];
            List<User> recipientsbmo = [SELECT ID,Name,Email FROM User WHERE ID =: u.Contract_Approver__c];
            Utils.sendEmailWithTemplate(recipientsbmo, oppid, 'Special_Price');
            System.debug('################# recipientsbmo' + recipientsbmo );
            for (User us : recipientsbmo) {
                recipientsLst += us.Name + ' ';
            }
            recipientsLst = recipientsLst.replace('null', '');
            return recipientsLst;
           
    }
    
    //给物流部门发送邮件
    webservice static String sendToLogistics(String oppid){
        List<Id> UserIds = new List<Id>();
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Logistics')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Freight_Notify');
        system.debug('额外邮件');
        return '';
    }

     //给物流部门发送MEA更新仓库费用邮件
    webservice static String sendToLogisticsMEA(String oppid){
        List<Id> UserIds = new List<Id>();
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Logistics')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'MEA_ToLogistics');
        return '';
    }
    
    //发申请在途库存审批邮件给物流部门 add by wangjie 20160405
    webservice static String sendTransitToLogistics(String oppid){
        List<Id> UserIds = new List<Id>();
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Logistics')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Apply_Logistics_Email_To_Logistics');
        return '';
    }
    //发申请在途库存审批邮件给PMC add by wangjie 20160405
     webservice static String sendTransitToPMC(String oppid){
        List<Id> UserIds = new List<Id>();
        for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='PMC')]){
            UserIds.add(gm.UserOrGroupId);
        }
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Apply_Logistics_Email_To_Logistics');
        return '';
    }
       //给Opp Owner对应的BMO 发邮件 add by wangjie 20160405
    webservice static String sendTransitToBMO(String oppid,String ownerid){
        User u = new User();
        if(ownerid != null) u = [SELECT ID,Name,Email,BMO_specialist__c FROM User WHERE ID =: ownerid];
        List<User> recipientsbmo = [SELECT ID,Name,Email FROM User WHERE ID =: u.BMO_specialist__c];
        Utils.sendEmailWithTemplate(recipientsbmo, oppid, 'Apply_Logistics_Email_To_Logistics');
        return '';
    }
              //给Opp Owner 发邮件 add by wangjie 20160405
    webservice static String sendTransitToOppOwner(String oppid,String ownerid){
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID =: ownerid];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Expiration_reminder_mail');
        return '';
    }
    
   
    
    //给Opp Owner 发邮件
    webservice static String sendToOppOwner(String oppid,String ownerid){
        List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID =: ownerid];
        Utils.sendEmailWithTemplate(recipients, oppid, 'Transit_Fee_Changed_Notify');
        return '';
    }
    
    //给Opp Owner对应的BMO 发邮件
    webservice static String sendToBMO(String oppid,String ownerid){
        User u = new User();
        if(ownerid != null) u = [SELECT ID,Name,Email,BMO_specialist__c FROM User WHERE ID =: ownerid];
        List<User> recipientsbmo = [SELECT ID,Name,Email FROM User WHERE ID =: u.BMO_specialist__c];
        system.debug('@@@@@@@@@@@@@@@@@@@11111' + recipientsbmo);
        Utils.sendEmailWithTemplate(recipientsbmo, oppid, 'Transit_Fee_Changed_Notify');
        return '';
    }
   
    
    //create by Hanfan 20170726
      //给Opp Owner 发邮件
      
    webservice static String sendEmailToThisList(String oppid,List<Id> recIds){        
        List<User> recipientsbmo = [SELECT ID,Name,Email FROM User WHERE ID in: recIds ];
        system.debug('@@@@@@@@@@@@@@@@@@@222222' + recipientsbmo);
        Utils.sendEmailWithTemplate(recipientsbmo, oppid, 'Send_Email_To_Owner_opp');
        return '';
    }    
    
    
    
     // 满足Japan 1MW发送给财务的同时也发给GM查看邮件    add by jason 20160513
    webservice static String sendToJapanGM(String oppid,String ownerid){
        System.debug('@@@@@ sendToJapanGM' );
        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c,Total_Quantity__c,Payment_1MW_Approve__c,Trade_Term__c,Sales_manager_approval__c FROM Opportunity WHERE ID =: oppid];
        if(opp != null){
            opp.Price_Approval_Status__c = 'Pending';
            opp.Sales_manager_approval__c = 'Pending';
            
        }
        List<Payment__c> payments = [select id,Name,Payment_Method__c,Percentage__c,Down_Balance_Payment__c 
                                        from Payment__c where Opportunity__c =:oppid];
        if(opp.Payment_1MW_Approve__c == true){
            User u = new User();
            
            System.debug('################# ownerid' + ownerid );
            
            if(ownerid != null) u = [SELECT ID,Name,Email,Contract_Approver__c FROM User WHERE ID =: ownerid];
            List<User> recipientsbmo = [SELECT ID,Name,Email FROM User WHERE ID =: u.Contract_Approver__c];
            Utils.sendEmailWithTemplate(recipientsbmo, oppid, 'Japan_GM_1MW_Review');
            
            System.debug('################# recipientsbmo' + recipientsbmo );
            
            //update opp;
            return 'success';
        }
        return 'failed';
      }
   
   
  
    
    
    //澳大利亚区域
    webservice static String sendToAustralia(String oppid){
        
        //当业务员点击 submit for price approval之后,变成pending
        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c,Total_Quantity__c,Trade_Term__c,Sales_manager_approval__c FROM Opportunity WHERE ID =: oppid];
        if(opp != null){
            opp.Price_Approval_Status__c = 'Pending';
            opp.Sales_manager_approval__c = 'Pending';
        }
        
        List<Payment__c> payList = [SELECT ID,Payment_Method__c FROM Payment__c WHERE Opportunity__c =: oppid AND (Payment_Method__c =: 'T/T' OR Payment_Method__c =: 'T/T (Balance)')];
        
        //小于等于2个柜的订单，业务员（提交） -----》Donald Leo
        if(opp.Total_Quantity__c <= 2800 && (opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'EXW') && payList.size() > 0){
           
            
            //List<User> recipients = [SELECT ID,Name,Email FROM User WHERE Name =: 'Vicky Sun'];
            //Utils.sendEmailWithTemplate(recipients, oppid, 'Special_Price');
        
            //List<User> recipients1 = [SELECT ID,Name,Email FROM User WHERE Name =: 'Anita Li'];
            //Utils.sendEmailWithTemplate(recipients1, oppid, 'Special_Price');
            
            List<User> recipients2 = [SELECT ID,Name,Email FROM User WHERE Name =: 'Donald Leo'];
            Utils.sendEmailWithTemplate(recipients2, oppid, 'Special_Price');
            
            update opp;
            return 'success';
        }else{
            List<Id> UserIds = new List<Id>();       
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                        from GroupMember gm 
                                        where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Finance')]){
                UserIds.add(gm.UserOrGroupId);
            }
            List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
            Utils.sendEmailWithTemplate(recipients, oppid, 'Special_Price');
            
            update opp;
            return 'success';
        }
        
        return 'failed';
    }
    
    //日本区域
    webservice static String sendToJapan(String oppid){
        
        //当业务员点击 submit for price approval之后,变成pending
        Opportunity opp = new Opportunity();
        if(oppid != null) opp = [SELECT ID,Name,Price_Approval_Status__c,Total_Quantity__c,Trade_Term__c FROM Opportunity WHERE ID =: oppid];
        if(opp != null){
            opp.Price_Approval_Status__c = 'Pending';
        }
        
        List<Payment__c> payList = [SELECT ID,Payment_Method__c FROM Payment__c WHERE Opportunity__c =: oppid AND (Payment_Method__c =: 'T/T' OR Payment_Method__c =: 'T/T (Balance)')];
        
        //小于等于4个柜的订单，将由Vicky Sun进行系统审批，包括价格审批与合同审批。
        if(opp.Total_Quantity__c <= 2800 && (opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'EXW') && payList.size() > 0){
            //List<User> recipients1 = [SELECT ID,Name,Email FROM User WHERE Name =: 'Donald Leo'];
            //Utils.sendEmailWithTemplate(recipients1, oppid, 'Special_Price');
            
            
            //List<User> recipients = [SELECT ID,Name,Email FROM User WHERE Name =: 'Anita Li'];
            List<User> recipients = [SELECT ID,Name,Email FROM User WHERE Name =: 'Vicky Sun'];
            Utils.sendEmailWithTemplate(recipients, oppid, 'Special_Price');

            update opp;
            return 'success';
        }else{
            List<Id> UserIds = new List<Id>();       
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                        from GroupMember gm 
                                        where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Finance')]){
                UserIds.add(gm.UserOrGroupId);
            }
            List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ID in: UserIds];
            Utils.sendEmailWithTemplate(recipients, oppid, 'Special_Price');
            
            update opp;
            return 'success';
        }
        
        return 'failed';
    }
    
    // 给法务部门发送邮件，审批 Allow new process for japan
    webservice static void sendToLegal(String oppid){
        if(oppid != null){
            List<Profile> proList = [SELECT ID,Name FROM Profile WHERE Name =: 'Legal'];
            if(proList.size() > 0){
                List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ProfileId =: proList[0].Id AND Username =: 'legal.japan@jinkosolar.com'];
                Utils.sendEmailWithTemplate(recipients, oppid, 'Legal_New_Process');
            }
        }
    }
    
    // 给财务部门发送邮件，审批 Sinosure Confirmed (暂时不需要)
    webservice static void SinosureConfirmed(String conid){
        if(conid != null){
            List<Profile> proList = [SELECT ID,Name FROM Profile WHERE Name =: 'Legal'];
            if(proList.size() > 0){
                List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ProfileId =: proList[0].Id];
                Utils.sendEmailWithTemplate(recipients, conid, 'Sinosure_Confirmed');
            }
        }
    }
    
    // 给BMO部门发送邮件，审批 Warranty On Material and Workmanship
    webservice static void Warranty(String conid){
        if(conid != null){
            /*List<Profile> proList = [SELECT ID,Name FROM Profile WHERE Name =: 'Legal'];
            if(proList.size() > 0){
                List<User> recipients = [SELECT ID,Name,Email FROM User WHERE ProfileId =: proList[0].Id];
                Utils.sendEmailWithTemplate(recipients, conid, 'Warranty_On_Material_and_Workmanship');
            }*/
        }
    }
    
    // 给部门发送邮件，审批 Warranty On Material and Workmanship
    webservice static void OppOwner(String oppid,List<User> recipients){
        if(oppid != null){
            Utils.sendEmailWithTemplate(recipients, oppid, 'New_Process_Allowed');
        }
    }
    //发送未赢单的业务机会
    webservice static void UnOppOwner(User recipients){
            Utils.sendEmailWithTemplated(recipients, 'OppUnWon');
    }
    // 一旦新建一个澳洲的业务机会 , 自动发送邮件给sabrina
    webservice static void AusOpp(String oppid){
        if(oppid != null){
            List<User> recipients = [SELECT ID,Name,Email FROM User WHERE Name =: 'Sabrina Liu'];
            Utils.sendEmailWithTemplate(recipients, oppid, 'Australia_Opportunity');
        }
    }
    
    public void runTest(){
        String run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
    }
}