trigger ContractTrigger on Contract (before insert, after insert, before update ,after update) {
    
    // neo
    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;
    
    //system.debug('~~~~~~~~~~~~~~~~~>:trigger start');
    //system.debug('~~~~~~~~~~~~~~~~~>:trigger.isAfter\n' +trigger.isAfter +
    //                                 'trigger.isBefore\n'+ trigger.isBefore +
    //                               'trigger.isInsert\n'+trigger.isInsert +
    //                             'trigger.isUpdate\n'+ trigger.isUpdate);
    
    String recordType = ''; 
    // bastic opportunity
    List<ID> accIds = new List<ID>();
    for(Contract con : trigger.new){
        //
        //    system.debug('测试合同ID' + con.id);
        accIds.add(con.AccountId);
    }
    
    List<Opportunity> oppList = [SELECT ID,AccountId,
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
                                 Destination_Country__c,
                                 Special_Terms__c,
                                 Region__c,
                                 QuoteNum__c,
                                 Price_Approval_Trigger_Time__c,
                                 Contract__c,
                                 Contract_No__c,
                                 Account.credit_good__c,
                                 Owner.Name,
                                 Sales_Region__c,
                                 Owner.Region__c,
                                 Probability
                                 FROM Opportunity 
                                 WHERE AccountId in: accIds ];
    
    Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
    for(Opportunity opp : oppList){
        oppMap.put(opp.Id,opp);
    }
    //  sam
    if (Trigger.isBefore) {
        
        // create by Sam 抓取各部门的最终审批状态的时间
        if(Trigger.isUpdate){
            
            for(Contract con: trigger.new){
                
                for(Contract con_old : trigger.old){
                    
                if(con_old.BankInfo__c==null && con.BankInfo__c!=null){
                con.Bankinfo_input_time__c=datetime.now(); 
                }
                
                    if(con.Status == 'Activated' && con.Status !=con_old.Status){
                        con.Contract_Active_Time__c = dateTime.now();
                    }
                    
                    if((con.Approval_Status__c  == 'Approved'|| con.BMO_Dept__c == 'Rejected') && con.Approval_Status__c !=con_old.Approval_Status__c){
                        con.Get_Final_Approved_Time2__c = dateTime.now();
                    }
                    
                    if((con.BMO_Dept__c == 'Approved'|| con.BMO_Dept__c == 'Rejected') && con.BMO_Dept__c !=con_old.BMO_Dept__c){
                        con.BMO_Dept_Finish_Time__c =DateTime.now();
                    }
                    if((con.Legal_Dept__c == 'Approved' || con.Legal_Dept__c == 'Rejected') && con.Legal_Dept__c !=con_old.Legal_Dept__c){
                        con.Legal_Dept_Finish_Time__c    =DateTime.now();
                    }
                    if((con.Sales_Dept__c == 'Approved' || con.Sales_Dept__c == 'Rejected') && con.Sales_Dept__c !=con_old.Sales_Dept__c){
                        con.Sales_Dept_Finish_Time__c    =DateTime.now();
                    }
                    if((con.Technical_Dept__c == 'Approved' || con.Technical_Dept__c == 'Rejected') && con.Technical_Dept__c !=con_old.Technical_Dept__c){
                        con.Technical_Dept_Finish_Time__c    =DateTime.now();
                    }
                    if((con.Finance_Dept__c == 'Approved' || con.Finance_Dept__c == 'Rejected') && con.Finance_Dept__c !=con_old.Finance_Dept__c){
                        con.Finance_Dept_Finish_Time__c  =DateTime.now();
                    }
                    if((con.CMO_Dept__c == 'Approved' || con.CMO_Dept__c == 'Rejected') && con.CMO_Dept__c !=con_old.CMO_Dept__c){
                        con.Regional_Head_Finish_Time__c     =DateTime.now();
                    }
                    if((con.Technology_Department_Manager__c == 'Approved' || con.Technology_Department_Manager__c == 'Rejected') && con.Technology_Department_Manager__c !=con_old.Technology_Department_Manager__c){
                        con.Technology_DeptDirector_Finish_Time__c   =DateTime.now();
                    }
                    if((con.PMC_Dept__c == 'Approved' || con.PMC_Dept__c == 'Rejected') && con.PMC_Dept__c !=con_old.PMC_Dept__c){
                        con.PMC_Dept_Finish_Time__c  =DateTime.now();
                    }
                    
                   
                   
                }
            }
            
        }
    }
    
    
    
    if(Trigger.isBefore){
        //  system.debug('~~~~~~~~~~~~~~~~~>:trigger isbefore1');
        
        List<BackInfo__c> bankinfos = [Select id,Short_Name__c From BackInfo__c];
        Map<string,BackInfo__c> BackInfoMap = new Map<string,BackInfo__c>();
        for(BackInfo__c bi: bankinfos){
            BackInfoMap.put(bi.Short_Name__c,bi);
        }
        
        for(Contract c : Trigger.new){
            //   System.debug('------>:BMO_specialist__c' + c.BMO_Specialist__c );
            String strid ='';
            strid=c.OwnerId;
            List<User> userList = [Select Id,Name,
                                   ManagerId,
                                   BMO_specialist__c ,
                                   Country__c, 
                                   Contract_Approver__c,
                                   Contract_Review__c
                                   From User where isActive = true and Id =:strid];
            if( Trigger.isInsert || Trigger.isUpdate){
                User u = new User();
                for(User user : userList){
                    if(user.Id == c.OwnerId){
                        u = user;
                        //     system.debug('------>:u' + u);
                        break;
                    }
                }
                c.BMO_Specialist__c = u.BMO_specialist__c;
                if(u.Contract_Approver__c!=null){
                    c.GM_for_approval_process__c = u.Contract_Approver__c;
                c.Contract_Approver__c = u.Contract_Approver__c;
                    }else{
                        //c.adderror('没有对应的GM');

                        if(c.Destination_Region__c=='EU(Union)' ||c.Destination_Region__c=='EU(Non-Eu)'){c.Contract_Approver__c = '005900000015hNj';}
                        else if(c.Destination_Region__c=='ROA'){c.Contract_Approver__c = '0059000000126GB';}
                        else if(c.Destination_Region__c=='North Asia'){c.Contract_Approver__c = '0059000000126GD';}
                        else if(c.Destination_Region__c=='South Asia'){c.Contract_Approver__c = '00590000001VTWZ';}
                        else if(c.Destination_Region__c=='North America'){c.Contract_Approver__c = '00590000001VGKF';}
                        else if(c.Destination_Region__c=='Middle East&Africa'){c.Contract_Approver__c = '0059000000126GW';}
                        else if(c.Destination_Region__c=='Latin America&Italy'){c.Contract_Approver__c = '005900000012G4b';}
                        else if(c.Destination_Region__c=='Central Asia'){c.Contract_Approver__c = '00590000001VTWZ';}

                       // c.GM_for_approval_process__c = '';
                    }
                system.debug('joel---Contract_Review__c-------'+u.Contract_Review__c);
                c.Contract_Review__c = u.Contract_Review__c;               
                
                if(string.isEmpty(c.BankInfo__c)){
                   system.debug('在哪里c'+c);
                    system.debug('在哪里bank'+BackInfoMap);   
                    c.BankInfo__c = ContractHelper.setBankInfo(c,BackInfoMap);
                }
                
                
            }
            
        }
    }
    
    
    if(Trigger.isBefore){
        //TODO  询问David
        //   system.debug('~~~~~~~~~~~~~>trigger.isBefore2');
        for(Contract con : Trigger.new){
            //一般订单的合同条款
            //    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+con.Trade_term__c + '||' + con.Payment_Method__c );
            if(Trigger.isInsert){
                //      system.debug( '###################');
                // Add by David 2012 11/15 
                if(con.Payment_Method__c == '100% Prepayment' && con.RecordTypeId != '012O00000000f63') {
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_10_For_Replace_PO3;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_11_For_Replace_PO4;
                    //        system.debug( '###################');
                }
                If(con.Payment_Method__c == '100% O/A' && con.RecordTypeId != '012O00000000f63') {
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_100_OA;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_100_OA2;
                    //  system.debug( '###################');   
                }
                
                If(con.Payment_Method__c == 'Prepayment +O/A' && con.RecordTypeId != '012O00000000f63'){
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_Prepayment_OA;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_Prepayment_OA2;
                    //    system.debug( '###################');   
                }
                
                If((con.Payment_Method__c == '100%OA+ L/C' || con.Payment_Method__c == '100% L/C') && con.RecordTypeId != '012O00000000f63') {
                    
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_100_OA_L_C;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_100_OA_L_C2;
                    //  system.debug( '###################');   
                }
                
                If(con.Payment_Method__c == 'Prepayment+OA + L/C' && con.RecordTypeId != '012O00000000f63'){
                    
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_Prepayment_OA_L_C;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_Prepayment_OA_L_C2;
                    //  system.debug( '###################');   
                }
                
                If(con.Payment_Method__c == '100%OA+Bank Guarantee' && con.RecordTypeId != '012O00000000f63'){
                    
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_100_OA_Bank_Guarantee;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_100_OA_Bank_Guarantee2;
                    // system.debug( '###################');
                }
                
                If(con.Payment_Method__c == 'Prepayment + OA+Bank Guarantee' && con.RecordTypeId != '012O00000000f63'){
                    
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_Prepayment_OA_Bank_Guarantee;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_Prepayment_OA_Bank_Guarantee2;
                    // system.debug( '###################');
                }
                
                If(con.Payment_Method__c == '100%OA+Parent Guarantee' && con.RecordTypeId != '012O00000000f63'){
                    
                    con.PO_Remarks_3__c = System.Label.PO_Remarks_12_For_100_OA_Parent_Guarantee;
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_100_OA_Parent_Guarantee2;
                    //  system.debug( '###################');   
                }
                
                If(con.Payment_Method__c == 'Prepayment + OA+ Parent Guarantee'  && con.RecordTypeId != '012O00000000f63') {
                    
                    String str = System.Label.PO_Remarks_12_For_Prepayment_OA_Parent_Guarantee;
                    con.PO_Remarks_3__c = str.replaceAll( '#DataTime#', String.valueOf( con.PO_PI_Date__c ) );
                    //    system.debug( '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+str);
                    //   system.debug( '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+ str.replaceAll( '#DataTime#', String.valueOf( con.PO_PI_Date__c ) ));
                    con.PO_Remarks_4__c = System.Label.PO_Remarks_12_For_Prepayment_OA_Parent_Guarantee2;
                    
                }
                
                //Add trade term value for appear on PO&PI/ Added by David 
                if(con.Trade_term__c == 'EXW Factory' || 
                   con.Trade_term__c == 'EXW Overseas Warehouse'){
                       //  system.debug('****************' + '');
                       con.Standard_Trade_Term__c = System.Label.EXW;
                       
                   }
                if(con.Trade_term__c == 'FOB Shanghai / Ningbo' || 
                   con.Trade_term__c == 'FOB Shanghai / Qingdao'){
                       
                       con.Standard_Trade_Term__c = System.Label.FOB;
                   }
                if(con.Trade_term__c == 'CIP'){
                    
                    con.Standard_Trade_Term__c = System.Label.CIP;
                }
                if(con.Trade_term__c == 'CIF'){
                    
                    con.Standard_Trade_Term__c = System.Label.CIF;
                }
                if(con.Trade_term__c == 'DAP'){
                    
                    con.Standard_Trade_Term__c = System.Label.DAP;
                }
                if(con.Trade_term__c == 'DDP'){
                    
                    con.Standard_Trade_Term__c = System.Label.DDP;
                }
                
                //  system.debug('====================='+con.PO_Remarks_3__c);
            }
        }// end for
        
    }
    
    
    //创建合同时获取合同的RecordType
    
    if(Trigger.isBefore){
        ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        ID FrameRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Frame Contract').getRecordTypeId();
        ID ProductionRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Production Contract').getRecordTypeId();
        ID SampleRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Sample Order').getRecordTypeId();
        
        RemarkExchangeUtils tools = new RemarkExchangeUtils();
        if(!Test.isRunningTest()){
            // 第一次生成合同时变更record type
            if(trigger.isBefore && trigger.isInsert){
                
                for(Contract con_new : trigger.new){
                    // get opportunity
                    Opportunity opp;
                    if(oppMap.get(con_new.Opportunity__c) != null)opp = oppMap.get(con_new.Opportunity__c);
                    //记录历史record type id
                    List<Contract> connum=[select id from Contract where Opportunity__c=:opp.id];
                    system.debug('connum'+connum);
                    if(con_new.RecordTypeId==SampleRecordTypeId && !opp.Sales_Region__c.contains('EU') ){
                        con_new.addError('Message: You can not choose free sample record type. please try others. Thanks.');
                    }
                    
                    if(opp.RecordType.Name == 'USA' && opp.Total_Quantity__c==0 && con_new.RecordTypeId!=IntercompanyRecordTypeId){
                        con_new.addError('Message: You can not create Contract, because you didn\'t add Product.');
                    }
                    if(opp.Owner.Region__c== 'Middle East&Africa' && opp.QuoteNum__c==0 && con_new.RecordTypeId!=IntercompanyRecordTypeId){
                        con_new.addError('Message: You can not create Contract, because you didn\'t create Quote.');
                    }
                    if(con_new.RecordTypeId != null)con_new.History_Record_Type_ID__c = String.valueOf(con_new.RecordTypeId).subString(0,15);
                    
                    // Legal allow     -> Opportunity : Record Type = Japan Opportunity & Total MW < 1MW -> 1MW Japan Contract
                    // Legal not allow -> Japan Profile : 1MW Japan & inventory & frame & production     -> By his select
                    
                    recordType = ContractHelper.getContractRecordTypeId(opp);
                    System.debug('~~~~~~~~~~~~ recordTypeID: '+ ContractHelper.getContractRecordTypeId(opp));
                    System.debug('~~~~~~~~~~~~ recordType: '+ recordType);
                    if(recordType != null){
                        con_new.RecordTypeId = recordType;
                        //FinanceApproval = true; 
                    }
                    system.debug('----- con_New' + con_new.RecordTypeId );
                    // 20160518 ---> end
                    
                    //20160530 update about twice error
                    //20200308 不卡一兆瓦财务审批
                    if(GenerateOrder.firstRun){
                        system.debug('-----AustraliaRecordTypeId' + AustraliaRecordTypeId);
                        system.debug('----- con_Newdd' + con_new.RecordTypeId );
                        system.debug('---- recordType ：' + con_new.RecordType.Name);
                        
                        if(connum.size()>=1){
                            con_new.addError('Message:The contract is existing. you can not create contract again.');
                        }
                        if (opp.Total_MW__c < 1  && opp.RecordType.Name == 'Japan' /*&& con_new.RecordTypeId != Japan1MWRecordTypeId*/  && opp.Sales_manager_approval__c != 'Approved'
                            && opp.Allow_new_process_for_Japan_picklist__c !='allow' &&  opp.Region__c=='North Asia' && con_new.RecordTypeId!=IntercompanyRecordTypeId && opp.Customer_Type__c !='Jinko Standard Japan') {
                                con_new.addError('Message: 1You can not create Contract, because you didn\'t get price approve.');
                            } 
                        else if(opp.Total_MW__c < 1 && (opp.RecordType.Name == 'Japan' && con_new.RecordTypeId == Japan1MWRecordTypeId )|| con_new.RecordTypeId == AustraliaRecordTypeId ){ // Opportunity Total MW < 1 & Record Type = Japan Opportunity
                                // TODO : Nothing
                            }
                        else {
                                // TODO : Origin Logic
                                if(con_new.RecordTypeId != AustraliaRecordTypeId && 
                                   con_new.RecordTypeId != Standard1MWRecordTypeId && 
                                   con_new.RecordTypeId != IntercompanyRecordTypeId && 
                                   con_new.RecordTypeId != Japan1MWRecordTypeId){
                                       
                                       if( opp.RecordType.Name != 'Japan' && opp.Region__c!='North Asia'  && opp.RecordType.Name != 'USA'   && opp.Price_Approval_Status__c != 'Approved' && con_new.RecordTypeId!=IntercompanyRecordTypeId && opp.Total_MW__c>1){
                                           con_new.addError('Message: 2You can not create Contract, because you didn\'t get price approve.');
                                       }
                                   }
                                else if(  opp.RecordType.Name != 'Japan' && opp.Region__c!='North Asia'  && opp.RecordType.Name != 'USA' && opp.Price_Approval_Status__c != 'Approved' && opp.Total_MW__c>1 && 
                                        (con_new.RecordTypeId == FrameRecordTypeId || con_new.RecordTypeId == ProductionRecordTypeId)){
                                            con_new.addError('Message: 3You can not create Contract, because you didn\'t get price approve.');
                                        }
                            else{
                                           if( opp.Sales_manager_approval__c != 'Approved' && opp.RecordType.Name != 'USA'){
                                                con_new.addError('Message: 4You can not create Contract, because you didn\'t get GM approve.');
                                            }
                                        }
                            }
                        GenerateOrder.firstRun = false;
                    }
                    
                    //15.Payment不为100% & downpayment，就为true，其余为false
                    if(con_new.Payment_Term_Description__c != null && con_new.Payment_Term_Description__c.contains('Down Payment') && (con_new.Payment_Term_Description__c.contains('100.00%') || con_new.Payment_Term_Description__c.contains('100%'))){
                        con_new.Sinosure_Confirmed__c = 'False';
                    }else{
                        con_new.Sinosure_Confirmed__c = 'True';
                    }
                    // 条件(通用) - Seller必需=JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD - 澳大利亚模版
                    if(con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia' &&  con_new.RecordTypeId == AustraliaRecordTypeId){
                        if(con_new.Trade_term__c == 'DDP'){
                            tools.Australia_DDP(con_new); 
                        }else if(con_new.Trade_term__c == 'EXW'){
                            tools.Australia_EXW(con_new);
                        }
                    }
                }
            }
            
            // 法律条款变更 (日/澳)
            if(Trigger.isUpdate && trigger.isBefore){
                //          system.debug('法律条款变更 (日/澳)');
                
                List<ID> conIds = new List<ID>();
                for(Contract con : trigger.new){
                    conIds.add(con.Id);
                }
                List<Payment__c> payList = [SELECT ID,Contract__c,
                                            Payment_Method__c,
                                            Payment_Term__c,
                                            Down_Balance_Payment__c,
                                            Percentage__c 
                                            FROM Payment__c 
                                            WHERE Contract__c in: conIds];
                
                for(Contract con_new : trigger.new){
                    for(Contract con_old : trigger.old){
                        
                        Boolean hasTT = false;
                        for(Payment__c pay : payList){
                            if(pay.Contract__c == con_new.Id){
                                if(pay.Payment_Method__c.contains('T/T')){
                                    hasTT = true;
                                    break;
                                }
                            }
                        }
                        
                        for(Payment__c pay : payList){
                            if(pay.Contract__c == con_new.Id){
                                if(pay.Down_Balance_Payment__c == 'Down Payment' && pay.Percentage__c == 100){
                                    con_new.Sinosure_Confirmed__c = 'False';
                                    break;
                                }else{
                                    con_new.Sinosure_Confirmed__c = 'True';
                                }
                            }
                        }
                        // 只有付款方式是TT的单子，才会是新的流程 其他的LC或者escrow都是按照原流程
                        if(hasTT && con_new.Total_Quantity__c <= 2800){
                            system.debug('只有付款方式是TT的单子，才会是新的流程 其他的LC或者escrow都是按照原流程');
                            Opportunity opp;
                            if(oppMap.get(con_new.Opportunity__c) != null)opp = oppMap.get(con_new.Opportunity__c);
                            
                            // Trade term / Seller 有变化即需要变动Record Type
                            if(ContractHelper.contractChanged(con_new,con_old)){
                                // 澳大利亚record type  - 大于2个柜小于等于4个柜 / Seller = JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD / Trade Term = DDP|EXW
                                if(con_new.Total_Quantity__c <= 2800 && con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia'){
                                    if(con_new.Trade_term__c == 'DDP' && opp.whether_pick_up_batch__c == 'True'){
                                        //  system.debug('澳大利亚record type  - 大于2个柜小于等于4个柜 / Seller = JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD / Trade Term = DDP|EXW');
                                        //if(ausRecord.size()> 0)
                                        con_new.RecordTypeId = AustraliaRecordTypeId;
                                    }else if(con_new.Trade_term__c == 'EXW'){
                                        //if(ausRecord.size()> 0)
                                        con_new.RecordTypeId = AustraliaRecordTypeId;
                                    }
                                }
                            }
                            
                            // Trade term / Warranty On Material / Sinosure Confirmed / Seller 有变化即需变更模版
                            if(ContractHelper.contractChanged2(con_new,con_old)){
                                
                                // 条件(通用) - Seller必需=JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD - 澳大利亚模版
                                if(con_new.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD' && con_new.Buyer_Country__c == 'Australia' &&  con_new.RecordTypeId == AustraliaRecordTypeId){
                                    if(con_new.Trade_term__c == 'DDP'){
                                        tools.Australia_DDP(con_new); 
                                    }else if(con_new.Trade_term__c == 'EXW'){
                                        tools.Australia_EXW(con_new);
                                    }
                                }            
                            }
                            
                            System.debug('############ record type : '+con_new.RecordTypeId);
                            
                        }else if(con_new.Total_Quantity__c > 2800 && con_new.History_Record_Type_ID__c != null && con_new.RecordTypeId != null && con_new.RecordTypeId != con_new.History_Record_Type_ID__c && (con_new.RecordTypeId == AustraliaRecordTypeId /*|| con_new.RecordTypeId == JapanRecordTypeId*/)){
                            //  con_new.RecordTypeId = Id.valueOf(con_new.History_Record_Type_ID__c);
                        }
                    }
                }
                
                
                // neo - calculate freight
                OpportunityLineItemGrossMarginHandler handler = new OpportunityLineItemGrossMarginHandler();
                for (String Id : Trigger.newMap.keySet()) {
                    if (Trigger.oldMap.get(Id).Destination_Port__c != Trigger.newMap.get(Id).Destination_Port__c ||
                        Trigger.oldMap.get(Id).Trade_term__c != Trigger.newMap.get(Id).Trade_term__c) OpportunityLineItemGrossMarginHandler.oceanNeedChangeIds.add(Id);
                    if (Trigger.oldMap.get(Id).Destination_Country__c != Trigger.newMap.get(Id).Destination_Country__c ||
                        Trigger.oldMap.get(Id).Trade_term__c != Trigger.newMap.get(Id).Trade_term__c) OpportunityLineItemGrossMarginHandler.landNeedChangeIds.add(Id);
                }
            }
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            Set<String> OppId = new Set<String>();
            String conID ='';
            String conRegion ='';
            for(Contract c : Trigger.new){
                 system.debug('101测试开始');
            SapSync_Opportunity.getOpportunityInfo(c.Opportunity__c);
                SyncContract.clickUpdate(c.id);
                SyncContract.tocontract(c.Opportunity__c,c.Contract_NO__c);
            system.debug('101测试结束'); 
                // update opps's contract No.
              Opportunity   opp = oppMap.get(c.Opportunity__c);
                OppId.add(c.Opportunity__c);
                conID=c.ID;
                conRegion = c.Region__c;
               
            } 
            //Syn Payments Insert Contract
            set<string> oppIds = new set<string>();
            
            for(Contract con : trigger.new){
                if(!oppIds.contains(con.Opportunity__c)&& string.isNotEmpty(con.Opportunity__c)){
                    oppIds.add(con.Opportunity__c);
                }    
            }
            if(conRegion =='North Asia'){
                SetContractID.UpdateConID(OppId,conID);           
            }
            
            List<Payment__c>  fullPays = [Select ID,Name,
                                          Down_Balance_Payment__c, 
                                          Payment_Term__c, 
                                          Payment_Method__c, 
                                          Contract__c, 
                                          Days__c, 
                                          CurrencyIsoCode,  
                                          Precise_Day__c,
                                          Opportunity__c, 
                                          Percentage__c,
                                          Comments__c,
                                          Credit_Valid__c,
                                          Order__c,
                                          Type__c,
                                          Opp_Trade_Term__c,
                                          Japan__c,
                                          Comments_English__c,
                                          Comments_Japan__c
                                          From Payment__c 
                                          Where Opportunity__c in: oppIds];
            
            List<Payment__c> insertPays = new List<Payment__c>();
            
            for(Contract con : trigger.new){
                Opportunity opp = oppMap.get(con.Opportunity__c);  
                
                for(Payment__c pay : fullPays){
                    if(pay.Opportunity__c == opp.ID){
                        Payment__c tmp = new Payment__c();
                        tmp.Down_Balance_Payment__c = pay.Down_Balance_Payment__c;
                        tmp.Payment_Method__c       = pay.Payment_Method__c;
                        tmp.Payment_Term__c         = pay.Payment_Term__c;
                        tmp.Days__c                 = pay.Days__c;
                        tmp.Contract__c             = con.ID;
                        tmp.Percentage__c           = pay.Percentage__c;
                        tmp.Precise_Day__c          = pay.Precise_Day__c;
                        tmp.Comments__c             = pay.Comments__c;
                        tmp.Credit_Valid__c         = pay.Credit_Valid__c;
                        tmp.Type__c=pay.Type__c;
                        tmp.Comments_English__c=pay.Comments_English__c;
                        tmp.Comments_Japan__c=pay.Comments_Japan__c;
                        insertPays.add(tmp);
                    }    
                }
                            insert insertPays;
                               SYSTEM.DEBUG('2020/08/14:'+opp);
                if(opp !=null){
                  opp.Contract__c = con.id;
                    opp.Contract_No__c = con.Contract_NO__c;
                SYSTEM.DEBUG('2020/08/14:'+opp.Contract_No__c);
                    update opp;
                SYSTEM.DEBUG('2020/08/14:'+opp.Contract_No__c);
                }
            }
            


        }
        
        if(Trigger.isUpdate){
            for(Contract c : Trigger.new){
                for(Contract c_old : trigger.old){
                    if( c.Buyer_Letter_of_guarantee__c ==null && 
                       (c_old.RecordTypeName__c !='1MW Australia Contract' || c_old.RecordTypeName__c !='1MW Global Standard Contract' || c_old.RecordTypeName__c !='1MW Japan Contract'||c_old.Region__c !='North Asia' || c_old.Region__c!='North America')  )
                    {
                        // c.addError('Please fill in Buyer Letter of guarantee');
                    }
                    
                    if(c.Approval_Status__c != c_old.Approval_Status__c){
                        if( c.Opportunity__c != null ){
                            // update opps's Contract Approval status and contract No.
                            Opportunity opp = oppMap.get(c.Opportunity__c);
                            if(opp != null){
                                opp.Contract_Approval__c = c.Approval_Status__c;
                                opp.Contract__c = c.id;
                                update opp;
                            }
                        }
                    }

                }
                 //if(Trigger.isAfter){


                //非快速流程判断法务是否审批去更新业务机会stage
                /*if(c.RecordTypeName__c !='1MW Australia Contract' && c.RecordTypeName__c !='1MW Global Standard Contract' && c.RecordTypeName__c !='1MW Japan Contract'){
                    System.debug('20200618------------>1');
                    if(c.Legal_Dept__c=='Approved'){
                        Opportunity opp = oppMap.get(c.Opportunity__c);
                        if(opp != null && opp.Probability<100){
                            System.debug('@@--@@1');
                            System.debug('opp------1>'+opp.StageName);
                            System.debug('opp.id------>'+opp.Id);
                            opp.StageName='PO Imminent';
                            opp.Probability=75;
                            System.debug('opp------2>'+opp.StageName);
                            update opp;
                            System.debug('走完'+opp.StageName);
                        }
                    }
                }else if(c.RecordTypeName__c =='1MW Australia Contract' || c.RecordTypeName__c =='1MW Global Standard Contract' || c.RecordTypeName__c =='1MW Japan Contract'){
                    System.debug('20200618------------>2');
                    Opportunity opp = oppMap.get(c.Opportunity__c);
                    System.debug('opp.Probability----------->'+opp.Probability);
                    if(c.BMO_Dept__c =='Approved' ){
                        if(((c.Destination_Region__c=='Middle East&Africa' || c.Destination_Region__c=='Latin America&Italy' || c.Destination_Region__c=='EU(Union)' || c.Destination_Region__c=='EU(Non-Eu)') && c.Opp_approval__c==true) || c.CMO_Dept__c=='Approved'){
                            if(opp != null && opp.Probability<100){
                                System.debug('@@--@@2');
                                System.debug('opp------1>'+opp.StageName);
                                System.debug('opp.id------>'+opp.Id);
                                opp.StageName='PO Imminent';
                                opp.Probability=75;
                                System.debug('opp------2>'+opp.StageName);
                                update opp;
                                System.debug('走完'+opp.StageName);
                            }
                        }
                    }
                }*/

                // }

            }
            //如果生成订单，则将book stock 中对应的 distribution book的orderId字段赋值
            /**
            List<String> conIdLst = new  List<String>();
            for(Contract con : Trigger.new){
                conIdLst.add(con.Id);
                system.debug('有什么:'+conIdLst);
            }
            
            List<Distribution_Stock__c> DissLst = new List<Distribution_Stock__c>();
            DissLst = [Select id,Contract_PO_PI__c,Order__c,Lock__c from Distribution_Stock__c where Contract_PO_PI__c in:conIdLst];
            List<Distribution_Stock__c> newDissLst = new List<Distribution_Stock__c>();
            for(Contract c : Trigger.new){
                for(Distribution_Stock__c diss : DissLst){
                    if(diss.Contract_PO_PI__c == c.Id && diss.Lock__c==false){
                        diss.Order__c = c.OrderId__c;
                        newDissLst.add(diss);
                    }
                }
            }     
            if(newDissLst !=null){
                update newDissLst;
            } 
            */
        }

        // neo
        new OpportunityLineItemGrossMarginHandler(Trigger.newMap);
    }
    
    //当合同双签之后
    //
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            List<Contract> updateContractLst = new List<Contract>();//获取跟新的合同
            List<String> ContractIDLst = new List<String>();//获取跟新的合同下ID
            Boolean IfemailISSend = false;
            for(Contract c_new : Trigger.new){
                for(Contract c_old : Trigger.old){
                    if(c_new.IFSendEmail__c==true){
                        IfemailISSend =true;  
                    }
                    if(c_new.Sales_Region__c=='North Asia' && c_new.IFSendEmail__c ==false){
                        if(c_new.Approval_Status__c != c_old.Approval_Status__c && c_new.Approval_Status__c =='Approved'){
                            updateContractLst.add(c_new);
                            ContractIDLst.add(c_new.Id);
                        }
                    }
                }
            }
            if(ContractIDLst !=null && ContractIDLst.size()>0){
                List<Distribution_Stock__c> disLst = new  List<Distribution_Stock__c>();//找出有该合同下的所有的库存预定
                disLst = [Select id,Status__c,SAP_TYPE__c,Contract_PO_PI__c,Apply_Inventory__c from Distribution_Stock__c where Contract_PO_PI__c in:ContractIDLst];
                String bookstockId = null;
                for(Distribution_Stock__c dis : disLst){
                    bookstockId = dis.Apply_Inventory__c;
                }
                Apply_Inventory__c  bookstock = new Apply_Inventory__c();
                if(bookstockId !=null){
                    bookstock =[Select id,TotalDisBookNumber__c from Apply_Inventory__c limit 1];
                }
                String ContractSendEmialID = null;
                if(bookstock !=null){
                    for(Contract con:updateContractLst){
                        if(con.Total_Quantity__c != bookstock.TotalDisBookNumber__c){
                            ContractSendEmialID=String.valueof(con.Id);
                        } 
                    }
                }else{
                    for(Contract con:updateContractLst){
                        ContractSendEmialID=String.valueof(con.Id);
                    } 
                }
                List<Distribution_Stock__c> updateDisLst = new List<Distribution_Stock__c>();
                List<String>  disIDLst = new List<String>();
                for(Contract con:updateContractLst){
                    for(Distribution_Stock__c dis:disLst){
                        if(dis.Status__c=='Booked' && dis.SAP_TYPE__c =='Booked同步成功' ){
                            disIDLst.add(dis.Id);
                        }
                    }
                }
                if(ContractSendEmialID !=null && IfemailISSend==false && (disIDLst !=null || disIDLst.size()>0)){
                    ContractNorthAisabookStock.SendEmail(ContractSendEmialID,disIDLst);      
                }
                
            }
        }
    }
}