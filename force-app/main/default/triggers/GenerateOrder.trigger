trigger GenerateOrder on Contract (before update, after update) {
    // Test : GenerateOrderTest
    // neo
    // if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;
    
    if (Trigger.isBefore) {
        System.debug('------generate Order trigger');
        Boolean flg = false;
        //system.debug('====4flg: ' + flg);
        Map<ID,List<Product_Detail__c>> prodMap = new Map<ID,List<Product_Detail__c>>();//conid  - prodlist
        Map<ID,List<PricebookEntry>>    bookMap = new Map<ID,List<PricebookEntry>>();   //bookid - booklist 
        Map<ID,List<Payment__c>>        payMap  = new Map<ID,List<Payment__c>>();       //conid  - booklist 
        
        Map<ID,List<ContentDocumentLink>>   cdlMap  = new Map<ID,List<ContentDocumentLink>>();  //conid  - filelist
        
        List<Product_Detail__c>         fullPD  = new List<Product_Detail__c>();// full product details
        List<PricebookEntry>            fullPE  = new List<PricebookEntry>();// full pricebook entry
        List<Payment__c>                fullPA  = new List<Payment__c>();// full payment
        List<ContentDocumentLink>       fullCDL = new List<ContentDocumentLink>(); //full file
        Boolean firstRun = true;
        
        List<ID> conIDs       = new List<ID>();// con id list
        List<ID> pricebookIDs = new List<ID>();// pricebook id list
        
        // select full con ids & pricebook ids
        //system.debug('=======>Before Contract is new');
        for(Contract con : trigger.new){
        //  system.debug('=======>Contract is new');
            conIDs.add(con.Id);
            pricebookIDs.add(con.Pricebook2Id__c);
        //   system.debug('=======>Contract is new'); 
            if(Trigger.isUpdate){
        //        system.debug('=======>Contract is update');
                for(Contract con_old : trigger.old){
        //         system.debug('=======>Contract is old');
                    if(con.OrderId__c == null || con.OrderId__c == ''){
                        system.debug('GenerateOrder.firstRun--->'+GenerateOrder.firstRun);
                        system.debug('########con.Id####'+con.Id+'***********con_old.Id*******'+con_old.Id);
                        system.debug('########con.Approval_Status__c####'+con.Approval_Status__c+'***********con_old.Approval_Status__c*******'+con_old.Approval_Status__c);
                        if((con.Id == con_old.Id && con.Approval_Status__c != con_old.Approval_Status__c && con.Approval_Status__c == 'Approved' && firstRun) || (con.Finance_approved_orders_Fast_Process__c == true && con.BMO_Manager_approved_orders_Fast_Process__c == true && firstRun)  ){
                        flg = true;   
                        system.debug('====29flg: ' + flg);                        
                        }
                    }               
                }
                
            }
            
            
        }
        
        if(flg){
            system.debug('====39flg: ' + flg);
            // select full datas
        /**
            fullPD=[SELECT ID,Name,CurrencyIsoCode,CreatedDate,CreatedById,
                            LastModifiedDate,LastModifiedById,SystemModstamp,Contract_PO_PI__c,Back_Sheet__c,EVA__c,Frame__c,
                            Label__c,Package__c,Product_Name__c,Product__c,Quantity__c,Ribbon__c,Serial_No__c,Solar_Cell__c,Tempered_glass__c,
                            Tolerance__c,Total_MW__c,Total_Price__c,Unit_Price__c,Unit_WM__c,Connector__c,Freight_Price__c,Insurance_Price__c,
                            Maximum_Power_at_STC_Pmax_Wp__c,Junction_Box_Type__c,GST_AUD__c,Total_Price_GST__c,Guaranteed_Delivery_Date__c,
                            Total_W__c,Battery_Type__c,Bus_bars_of_cell__c,Certification__c,Color_of_frame_and_backsheet__c,Grade__c,Length_of_Junction_Box_wiring__c,
                            Special_required__c,MP__c
                            FROM Product_Detail__c where Contract_PO_PI__c in: conIDs];
        */
            fullPD = Database.query(
                QW_Utils.getQueryBySObjectType(
                    'Product_Detail__c') + 
                    ' WHERE Contract_PO_PI__c in: conIDs');
            fullPE = [SELECT ID,NAME,Product2Id,Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id in: pricebookIDs and IsActive=true];
            fullPA = [SELECT ID,Name,
                    Comments__c,
                    Contract__c,
                    Days__c,
                    Down_Balance_Payment__c,
                    Opportunity__c,
                    Order__c,
                    Payment_Method__c,
                    Payment_Term__c,
                    Percentage__c,
                    Precise_Day__c,
                    Credit_Valid__c,
                    Type__c,
                    All_Trade_Term__c,
                                            Opp_Trade_Term__c,
                                            Japan__c,
                                            Comments_English__c,
                                            Comments_Japan__c
                    FROM Payment__c
                    WHERE Contract__c in: conIDs];
            //fullCD = [Select c.Title, c.Id, (Select Id, LinkedEntityId From ContentDocumentLinks Where LinkedEntityId in: conIDs) From ContentDocument c];
            fullCDL = [Select Id, LinkedEntityId,ContentDocumentId,ShareType,Visibility  From ContentDocumentLink Where LinkedEntityId in: conIDs];
            // generate data maps
            for(Contract con : trigger.new){
                List<Product_Detail__c>         prodList = new List<Product_Detail__c>();
                List<PricebookEntry>            pbeList  = new List<PricebookEntry>();
                List<Payment__c>                payList  = new List<Payment__c>();
                List<ContentDocumentLink>       cdlList  = new List<ContentDocumentLink>();
                
                for(Product_Detail__c prod : fullPD){
                    if(prod.Contract_PO_PI__c == con.Id){
                        prodList.add(prod);
                    }
                }
                
                for(PricebookEntry pbe : fullPE){
                    if(pbe.Pricebook2Id == con.Pricebook2Id__c
                    && true){
                        pbeList.add(pbe);
                    }
                }
                
                for(Payment__c pay : fullPA){
                    if(pay.Contract__c == con.Id){
                        payList.add(pay);
                    }
                }
                
                for(ContentDocumentLink cdl : fullCDL){
                    if(cdl.LinkedEntityId == con.Id){
                        cdlList.add(cdl);
                    }
                }
                
                prodMap.put(con.Id,prodList);
                bookMap.put(con.Pricebook2Id__c,pbeList);
                payMap.put(con.Id,payList);
                cdlMap.put(con.Id, cdlList);
            }
            
            // generate order
            for(Contract con : trigger.new){
                try{
                    /*if(Trigger.isInsert){
    if(con.Approval_Status__c == 'Approved'){
    GenerateOrder.generate(con,prodMap,bookMap,payMap);
    }
    }else */
                    if(Trigger.isUpdate){
                        
                    //    System.debug('^^^^^^^^ contract new status : '+ con.Approval_Status__c);
                        
                        for(Contract con_old : trigger.old){
                            
                        //   System.debug('-----------> contract old status : '+ con.Approval_Status__c);
                        //    System.debug('-----------> GenerateOrder.firstRun : '+ GenerateOrder.firstRun);
                    //     System.debug('-----------> contract old Finance : '+ con.Finance_approved_orders_Fast_Process__c  );
                    //      System.debug('-----------> contract old BMO : '+  con.BMO_Manager_approved_orders_Fast_Process__c);
                            
                            
                            if(con.OrderId__c == null || con.OrderId__c == ''){ 
                                if((con.Id == con_old.Id && con.Approval_Status__c != con_old.Approval_Status__c && con.Approval_Status__c == 'Approved' && GenerateOrder.firstRun) || (con.Finance_approved_orders_Fast_Process__c == true && con.BMO_Manager_approved_orders_Fast_Process__c == true && GenerateOrder.firstRun)  ){
                                    system.debug('创建Order');
                                    GenerateOrder.generate(con,prodMap,bookMap,payMap,cdlMap);
                                    //GenerateOrder.generate(con, prodMap, bookMap, payMap);
                                    con.OrderId__c = GenerateOrder.OrderId;
                                    GenerateOrder.firstRun = false;
                                }
                            }
                        }
                    }
                }catch(Exception e){
                    System.debug('-----> '+e.getMessage());
                }
            }
        }
    } else {
        // neo
        Map<Id, Contract> contractOldMap = new Map<Id, Contract>();
        if (Trigger.oldMap != null) contractOldMap.putAll((Map<Id, Contract>) Trigger.oldMap);
        Map<Id, Contract> contractNewMap = new Map<Id, Contract>();
        if (Trigger.newMap != null) contractNewMap.putAll((Map<Id, Contract>) Trigger.newMap);
        Map<Id, List<Component_Task_Book__c>> contractIdMDAsMap = new Map<Id, List<Component_Task_Book__c>>();
        for (Component_Task_Book__c mda : [SELECT Id, Contract__c FROM Component_Task_Book__c WHERE Contract__c IN: Trigger.new]){
            if (contractIdMDAsMap.containsKey(mda.Contract__c)) contractIdMDAsMap.get(mda.Contract__c).add(mda);
            else contractIdMDAsMap.put(mda.Contract__c, new List<Component_Task_Book__c>{mda});
        }

        Map<Id, Order> contractIdOrderMap = new Map<Id, Order>();
        for (Order order : [SELECT Id, ContractId FROM Order WHERE ContractId IN: Trigger.new]){
            contractIdOrderMap.put(order.ContractId, order);
        }

        List<Component_Task_Book__c> mdas = new List<Component_Task_Book__c>();
        for (Id contractId : contractNewMap.keySet()) {
            Contract contractOld = contractOldMap.get(contractId);
            Contract contractNew = contractNewMap.get(contractId);
            // if ((contractOld.Approval_Status__c != contractNew.Approval_Status__c && contractNew.Approval_Status__c == 'Approved') || 
            //     (contractNew.Finance_approved_orders_Fast_Process__c && contractNew.BMO_Manager_approved_orders_Fast_Process__c)){
                if (!contractIdMDAsMap.containsKey(contractId)) continue;
                for (Component_Task_Book__c mda : contractIdMDAsMap.get(contractId)){
                    if (!contractIdOrderMap.containsKey(contractId)) continue;
                    mda.Order__c = contractIdOrderMap.get(contractId).Id;
                    mdas.add(mda);
                }
            // }
        }

        // TriggerHandler.bypass('RC_MDABasicHandler');
        update mdas;
    }
}