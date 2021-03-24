public without sharing class RC_RedirectController {
    
    public String redirectUrl {get; set;}
    public String errorMsg {get; set;}
    public String recordId {get; set;}
    public String record {get; set;}
    public String recordIds {get; set;}

    public RC_RedirectController(){}

    public RC_RedirectController(ApexPages.StandardSetController stdController) {
        List<String> temp = new List<String>();
        for (sObject record : stdController.getSelected()) {
            temp.add((String)record.get('Id'));
        }
        recordId = ApexPages.currentPage().getParameters().get('id');
        recordIds = JSON.serialize(temp);
        if (recordId == null) return; 
        record = JSON.serialize(Database.query(
            QW_Utils.getQueryBySObjectType(Id.valueOf(recordId).getSObjectType()) +
            ' WHERE Id = \'' + recordId + '\''
        ));
    }

    public void redirect () {
        Savepoint sp;
        String id = ApexPages.currentPage().getParameters().get('id');
        String action = ApexPages.currentPage().getParameters().get('action');
        Boolean skipSavepoint = ApexPages.currentPage().getParameters().get('skipSavepoint') != null ? 
            Boolean.valueOf(ApexPages.currentPage().getParameters().get('skipSavepoint')) : false;
        this.redirectUrl = '/' + id;
        if (!skipSavepoint) sp = Database.setSavepoint();
        try {
            if ('syncOA'.equals(action)) syncOA ();
            else if ('quickOrder'.equals(action)) quickOrder ();
            else if ('CommissionApplication'.equals(action)) commissionApplication ();
            else if ('resetApprovalStatus'.equals(action)) resetApprovalStatus ();
            else if ('createContract'.equals(action)) createContract (false);
            else if ('refreshContract'.equals(action)) refreshContract ();
            else if ('CreateOrder'.equals(action)) createOrder ();
            else if ('createAmendmentAgreement'.equals(action)) createAmendmentAgreement2 ();
            else if ('refreshOrder'.equals(action)) refreshOrder ();
            else if ('PaymentInformation'.equals(action)) paymentInformation();
            else if ('SAP_SyncOrder'.equals(action)) syncOrder();
            else if ('syncOrder'.equals(action)) syncOrder();
            else if ('printPDF'.equals(action)) printPDF();
            else if ('printTerminationPDF'.equals(action)) printTerminationPDF();
            else if ('printAmendmentPDF'.equals(action)) printAmendmentPDF();
            else if ('shareTo'.equals(action)) shareTo();
            else if ('createMDA'.equals(action)) createMDA();
            else if ('ProductMaintenance'.equals(action)) productMaintenance();
            else if ('checkPermission'.equals(action)) checkPermission();
            else if ('orderNotice'.equals(action)) orderNotice();
            else if ('printMDA'.equals(action)) printMDA();
        } catch (Exception e) {
            if (!skipSavepoint) Database.rollback(sp);
            this.errorMsg = e.getMessage();
            this.redirectUrl = '/' + id;
        }
    }
    
    private void printMDA () {
        String id = ApexPages.currentPage().getParameters().get('id');
        Component_Task_Book__c ctb = [SELECT ID,Technical_manager_Shanghai__c,
                                                TestTime__c,
                                                DS_Version_in_the_Contract__c,
                                                DS_Version_in_the_Contract_Text__c
                                    FROM Component_Task_Book__c
                                    WHERE ID =:id];       
        if(ctb.Technical_manager_Shanghai__c != 'Approved'){
            this.errorMsg = '技术审批通过后才能打印MDA!';
            this.redirectUrl = '/' + id;
        }else if(ctb.DS_Version_in_the_Contract_Text__c == '' && ctb.TestTime__c == true){
            this.errorMsg = '请联系技术填写技术规格书!';
            this.redirectUrl = '/' + id;
        }else{
            this.redirectUrl = SaveAsPDF.doCreateComponentTaskBookChina(id);
        }
    }

    private void quickOrder () {
        String id = ApexPages.currentPage().getParameters().get('id');
        ContractControllerCreate ccc = new ContractControllerCreate(
            new ApexPages.Standardcontroller(
                new Contract(
                    Opportunity__c = id
                )
            ));
        ccc.op = (Opportunity)Database.query(
            QW_Utils.getQueryBySObjectType('Opportunity', new List<String>{'Account.BillingStreet'}) + 
            ' WHERE Id = :id')[0];
        if (ccc.op.Payment_Term_Description__c == null) throw new QW_Utils.QWException('please fill payment term');
        if (ccc.op.Account.BillingStreet == null) throw new QW_Utils.QWException('please fill account BillingStreet');
        ccc.op.Price_Approval_Status__c = 'Approved';
        ccc.op.Sales_manager_approval__c = 'Approved';
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        update ccc.op;
        ccc.con.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Intercompany_Contract').getRecordTypeId();
        OpportunityLineItemGrossMarginHandler.skipTrigger = false;
        ccc.onCreate();
        ccc.con.Approval_Status__c = 'Approved';
        GenerateOrder.firstRun = true;
        update ccc.con;
        Order order = (Order)Database.query(
            QW_Utils.getQueryBySObjectType('Order') + 
            ' WHERE ContractId = \'' + ccc.con.Id + '\'')[0];
        String url = '/' + order.Id;
        this.redirectUrl = url;
    }

    private void orderNotice () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String url = '/apex/RC_OrderNoticeTemplate?id=' + id;        	 			
        this.redirectUrl = url;
    }
    
    private void createMDA () {
        String iid = ApexPages.currentPage().getParameters().get('id');
        String parentFieldValues = ApexPages.currentPage().getParameters().get('parentFieldValues');
        // verify logic
        RC_ModuleDesignProductController ctrl = new RC_ModuleDesignProductController(null);
        if (Test.isRunningTest()) ctrl.pageId = '/a0Z/e';
        Map<String, String> params = ctrl.goto().getParameters();
        String url = '/lightning/o/Component_Task_Book__c/new?recordTypeId=' + Schema.SObjectType.Component_Task_Book__c.getRecordTypeInfosByDeveloperName().get('China_MDA').getRecordTypeId();
        url += '&defaultFieldValues=';
        if (parentFieldValues != null) url += parentFieldValues + ',';
        List<leanx__lg_Contract__c> contracts = [SELECT Id FROM leanx__lg_Contract__c  WHERE Project__c =: iid];
        if (contracts.size() > 0) url += 'iContract__c=' + contracts[0].Id + ',';
        List<Agreement__c> agreements = [SELECT Id FROM Agreement__c  WHERE Contract__c = :iid OR Project__c =: iid];
        if (agreements.size() > 0) url += 'iOrder__c=' + agreements[0].Id + ',';
        if (String.isNotBlank(ctrl.productId1) && String.isNotBlank(params.get(ctrl.productId1))) url += 'iModule_Type1__c=' +  Id.valueOf(params.get(ctrl.productId1)) + ',';
        if (String.isNotBlank(ctrl.productId2) && String.isNotBlank(params.get(ctrl.productId2))) url += 'iModule_Type2__c=' +  Id.valueOf(params.get(ctrl.productId2)) + ',';
        if (String.isNotBlank(ctrl.productId3) && String.isNotBlank(params.get(ctrl.productId3))) url += 'iModule_Type3__c=' +  Id.valueOf(params.get(ctrl.productId3)) + ',';
        if (String.isNotBlank(ctrl.quantityId1) && String.isNotBlank(params.get(ctrl.quantityId1))) url += 'PCS1__c=' + params.get(ctrl.quantityId1) + ',';
        if (String.isNotBlank(ctrl.quantityId2) && String.isNotBlank(params.get(ctrl.quantityId2))) url += 'PCS2__c=' + params.get(ctrl.quantityId2) + ',';
        if (String.isNotBlank(ctrl.quantityId3) && String.isNotBlank(params.get(ctrl.quantityId3))) url += 'PCS3__c=' + params.get(ctrl.quantityId3) + ',';
        if (String.isNotBlank(ctrl.cellquantity) && String.isNotBlank(params.get(ctrl.cellquantity))) url += 'Cell_Quantity1__c=' + params.get(ctrl.cellquantity) + ',';
        if (String.isNotBlank(ctrl.cellquantity2) && String.isNotBlank(params.get(ctrl.cellquantity2))) url += 'Cell_Quantity2__c=' + params.get(ctrl.cellquantity2) + ',';
        if (String.isNotBlank(ctrl.cellquantity3) && String.isNotBlank(params.get(ctrl.cellquantity3))) url += 'Cell_Quantity3__c=' + params.get(ctrl.cellquantity3) + ',';
        if (String.isNotBlank(ctrl.SystemVoltage) && String.isNotBlank(params.get(ctrl.SystemVoltage))) url += 'System_Voltage__c=' + params.get(ctrl.SystemVoltage) + ',';
        if (String.isNotBlank(ctrl.JunctionBoxType) && String.isNotBlank(params.get(ctrl.JunctionBoxType))) url += 'Junction_Box_brand__c=' + params.get(ctrl.JunctionBoxType);
        this.redirectUrl = url;
    }
    
    private void shareTo () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String type = ApexPages.currentPage().getParameters().get('type');
        // verify logic
        if (type == 'Account') this.redirectUrl = '/p/share/AccSharingDetail?parentId=' + id;
        else this.redirectUrl = '/p/share/CustomObjectSharingDetail?parentId=' + id;
    }
    
    private void syncOA () {
        String id = ApexPages.currentPage().getParameters().get('id');
        // verify logic
        List<Account> accounts = [SELECT Id, OA_External_ID__c, SAP_External_ID__c FROM Account WHERE Id =: id];
        if (accounts.size() == 0) throw new QW_Utils.QWException('客户数据不存在');
        else if (accounts[0].SAP_External_ID__c != null) throw new QW_Utils.QWException('客户数据已同步完成，无需重复同步');
        else if (accounts[0].OA_External_ID__c != null && accounts[0].OA_External_ID__c != '-10') throw new QW_Utils.QWException('客户数据同步中，请完成OA流程');
        // getContractAccInfo.submitOA(id);
        this.redirectUrl = '/apex/RC_SynAccPage?id=' + id;
    }

    private void checkPermission () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String url = ApexPages.currentPage().getParameters().get('url');
        String psName = ApexPages.currentPage().getParameters().get('ps');
        // verify logic
        if (String.isNotEmpty(psName) && !QW_Utils.permssionSetCheck(UserInfo.getUserId(), psName)) throw new QW_Utils.QWException('权限不足，无法使用此功能。');
        this.redirectUrl = url;
    }

    private void productMaintenance () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String url = ApexPages.currentPage().getParameters().get('url');
        // verify logic
        if (id != null && Approval.isLocked(id)) throw new QW_Utils.QWException('数据已锁定，暂时无法进行产品维护。');
        else if (!QW_Utils.permssionSetCheck(UserInfo.getUserId(), 'RC_ProductMaintenance')) throw new QW_Utils.QWException('权限不足，无法进行产品维护。');
        this.redirectUrl = url;
    }
    
    private void commissionApplication () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String contractId = ApexPages.currentPage().getParameters().get('contractId');
        // verify logic
        this.redirectUrl = '/apex/RC_CommissionCheck?id=' + id + '&contractId=' + contractId;
    }

    private void resetApprovalStatus () {
        String iid = ApexPages.currentPage().getParameters().get('id');
        String fields = ApexPages.currentPage().getParameters().get('fields');
        SObject record = Id.valueOf(iid).getSobjectType().newSObject(iid);
        for (String field : fields.split(',')) {
            if (String.isBlank(field)) return;
            List<String> strs = field.split('=');
            String name = strs[0];
            String value = strs.size() > 1 ? strs[1] : null;
            if (value != null && value == 'true') record.put(name, true);
            else if (value != null && value == 'false') record.put(name, false);
            else record.put(name, value);
        }
        update record;
        this.errorMsg = '重置成功';
    }

    private void refreshContract () {
        createContract(true);
        this.errorMsg = '刷新成功';
    }

    private void createContract (Boolean isRefresh) {
        String id = ApexPages.currentPage().getParameters().get('projectId');
        List<leanx__lg_Contract__c> contracts = [SELECT Id, Stage__c FROM leanx__lg_Contract__c WHERE Project__c =: id];
        List<leanx__pm_Project__c> projects = [SELECT Id, Stage__c, Actual_Sales__c FROM leanx__pm_Project__c WHERE Id =: id];
        String contractId = contracts.size() > 0 ? contracts[0].Id : null;
        if (contractId != null && !isRefresh) throw new QW_Utils.QWException('合同已存在，如需更新合同数据，请点击【合同】上的刷新按钮');
        if (contractId != null && isRefresh && Approval.isLocked(contractId)) throw new QW_Utils.QWException('审批进行中，暂时无法进行合同数据更新。');
        if (contractId != null && isRefresh && contracts[0].Stage__c != 'Contract Negotiation') throw new QW_Utils.QWException('合同当前阶段暂不支持刷新数据，请先重置【合同审批状态】，再操作【刷新】合同数据');
        if (projects.size() == 0 || projects[0].Stage__c != 'Price Approved') throw new QW_Utils.QWException('请先完成【项目价格审批】，操作【创建】/【刷新】合同数据');
        leanx__lg_Contract__c contract = (leanx__lg_Contract__c) QW_Utils.transferDataToObject(
            id, 'leanx__lg_Contract__c', 'RC_TransferToContract',
            new Map<String, String>{}
        );

        contract.Stage__c = 'Contract Negotiation';
        List<User> sales = [SELECT Id, BMO_specialist__c FROM User WHERE Id =: projects[0].Actual_Sales__c];
        if (sales.size() == 0) throw new QW_Utils.QWException('【实际销售】为空，请补充');
        contract.SOC_Specialist__c = sales[0].BMO_specialist__c;
        
        List<Contract_Component__c> items = new List<Contract_Component__c>();
        String query = QW_Utils.getQueryByFieldSet(leanx__pm_ProjectMember__c.getSObjectType(), 'RC_TransferToContractProduct');
        query += ' WHERE leanx__Project__c = \'' + id + '\'';
        for (SObject item : Database.query(query)) {
            items.add((Contract_Component__c) QW_Utils.transferDataToObject(
                item.Id, 'Contract_Component__c', 'RC_TransferToContractProduct',
                new Map<String, String>{'Id' => 'Project_Product__c'}
            ));
        }
        if (contractId != null) contract.Id = contractId;
        if (contractId != null) delete [SELECT Id FROM Contract_Component__c WHERE Contract__c =: contractId];
        if (contractId != null) delete [SELECT Id FROM Payment__c WHERE China_Contract__c =: contractId];
        contract.Project__c = id;
        upsert contract;
        for (Contract_Component__c item : items) {
            item.Contract__c = contract.Id;
        }
        insert items;
        List<Payment__c> payments = new List<Payment__c>();
        String queryPayment = QW_Utils.getQueryByFieldSet(Payment__c.getSObjectType(), 'RC_ChinaField');
        queryPayment += ' WHERE China_Project__c = \'' + id + '\'';
        for (Payment__c payment : Database.query(queryPayment)) {
            payment.Id = null;
            payment.China_Project__c = null;
            payment.China_Contract__c = contract.Id;
            payments.add(payment);
        }
        insert payments;
        
        TriggerHandler.bypass('RC_MDAReassignHandler');
        List<Component_Task_Book__c> mdas = new List<Component_Task_Book__c>();
        for (Component_Task_Book__c mda : (List<Component_Task_Book__c>)Database.query(
                QW_Utils.getQueryBySObjectType('Component_Task_Book__c') + 
                ' WHERE iProject__c = :id')) {
            mda.iContract__c = contract.Id;
            mdas.add(mda);
        }
        update mdas;

        this.redirectUrl = '/' + contract.Id;
        if (contract.Actual_Sales__c == null) return;
        QW_Utils.shareRecordsToUser(new Set<Id>{contract.Id}, new User(Id = contract.Actual_Sales__c));
        this.errorMsg = '创建成功';
    }
    
    private void createOrder () {
        String id = ApexPages.currentPage().getParameters().get('id');
        List<Agreement__c> orders = [SELECT Id FROM Agreement__c WHERE Contract__c =: id];
        String orderId = orders.size() > 0 ? orders[0].Id : null;
        List<leanx__lg_Contract__c> contracts = [SELECT Stage__c, Actual_Sales__c FROM leanx__lg_Contract__c WHERE Id =: id];
        if (orderId != null) throw new QW_Utils.QWException('订单已存在');
        Set<String> validStages = new Set<String>{'Single Signed', 'Counter Signed'};
        if (contracts.size() == 0 || !validStages.contains(contracts[0].Stage__c)) throw new QW_Utils.QWException('创建订单，需完成【合同单签】');
        Agreement__c agreement = (Agreement__c) QW_Utils.transferDataToObject(
            id, 'Agreement__c', 'RC_TransferToOrder',
            new Map<String, String>{
                'leanx__Account__c' => 'Account__c'
        });
        
        List<User> sales = [SELECT Id, BMO_specialist__c FROM User WHERE Id =: contracts[0].Actual_Sales__c];
        if (sales.size() == 0) throw new QW_Utils.QWException('【实际销售】为空，请补充');
        agreement.SOC_Specialist__c = sales[0].BMO_specialist__c;
        
        List<Agreement_Component__c> items = new List<Agreement_Component__c>();
        String query = QW_Utils.getQueryByFieldSet(Contract_Component__c.getSObjectType(), 'RC_TransferToOrderProduct');
        query += ' WHERE Contract__c = \'' + id + '\'';
        for (SObject item : Database.query(query)) {
            Agreement_Component__c temp = (Agreement_Component__c) QW_Utils.transferDataToObject(
                item.Id, 'Agreement_Component__c', 'RC_TransferToOrderProduct',
                new Map<String, String>{}
            );
            temp.IsActive__c = true;
            items.add(temp);
        }
        if (orderId != null) agreement.Id = orderId;
        if (orderId != null) delete [SELECT Id FROM Agreement_Component__c WHERE Agreement__c =: orderId];
        if (orderId != null) delete [SELECT Id FROM Payment__c WHERE China_Order__c =: orderId];
        agreement.Name = agreement.Contract_No__c + ' V1';
        agreement.Contract__c = id;
        upsert agreement;
        for (Agreement_Component__c item : items) {
            item.Agreement__c = agreement.Id;
        }
        insert items;
        List<Payment__c> payments = new List<Payment__c>();
        String queryPayment = QW_Utils.getQueryByFieldSet(Payment__c.getSObjectType(), 'RC_ChinaField');
        queryPayment += ' WHERE China_Contract__c = \'' + id + '\'';
        for (Payment__c payment : Database.query(queryPayment)) {
            payment.Id = null;
            payment.China_Project__c = null;
            payment.China_Contract__c = null;
            payment.China_Order__c = agreement.Id;
            payments.add(payment);
        }
        insert payments;
        
        TriggerHandler.bypass('RC_MDAReassignHandler');
        List<Component_Task_Book__c> mdas = new List<Component_Task_Book__c>();
        for (Component_Task_Book__c mda : (List<Component_Task_Book__c>)Database.query(
                QW_Utils.getQueryBySObjectType('Component_Task_Book__c') + 
                ' WHERE iContract__c = :id')) {
            mda.iOrder__c = agreement.Id;
            mdas.add(mda);
        }
        update mdas;
        
        this.redirectUrl = '/' + agreement.Id;
        if (agreement.Actual_Sales__c == null) return;
        QW_Utils.shareRecordsToUser(new Set<Id>{agreement.Id}, new User(Id = agreement.Actual_Sales__c));
        this.errorMsg = '创建成功';
    }
    
    private void createAmendmentAgreement2 () {
        String id = ApexPages.currentPage().getParameters().get('id');
        List<Agreement__c> agreements = [SELECT Actual_Sales__c FROM Agreement__c WHERE Id =: id];
        List<Amendment_Agreement__c> amendments = [
            SELECT Id,
                   Stage__c,
                   RecordType.DeveloperName
            FROM Amendment_Agreement__c 
            WHERE Agreement__c =: id];
        Set<String> validStages = new Set<String>{'Pending', 'Prospecting'};
        for (Amendment_Agreement__c amendment : amendments) {
            if (validStages.contains(amendment.Stage__c)) throw new QW_Utils.QWException('已存在进行中的补充协议');
            if (amendment.RecordType.DeveloperName == 'Termination_Agreement_China') throw new QW_Utils.QWException('已创建终止协议');
        }
        Amendment_Agreement__c amendment = (Amendment_Agreement__c) QW_Utils.transferDataToObject(
            id, 'Amendment_Agreement__c', 'RC_TransferToAmendment', new Map<String, String>{}
        );
        
        List<User> sales = [SELECT Id, BMO_specialist__c FROM User WHERE Id =: agreements[0].Actual_Sales__c];
        if (sales.size() == 0) throw new QW_Utils.QWException('【实际销售】为空，请补充');
        amendment.SOC_Specialist__c = sales[0].BMO_specialist__c;
        
        List<Amendment_Agreement_Product__c> items = new List<Amendment_Agreement_Product__c>();
        String query = QW_Utils.getQueryByFieldSet(Agreement_Component__c.getSObjectType(), 'RC_TransferToAmendmentProduct');
        query += ' WHERE Agreement__c = \'' + id + '\'';
        for (SObject item : Database.query(query)) {
            items.add((Amendment_Agreement_Product__c) QW_Utils.transferDataToObject(
                item.Id, 'Amendment_Agreement_Product__c', 'RC_TransferToAmendmentProduct',
                new Map<String, String>{}
            ));
        }
        amendment.RecordTypeId = Schema.SObjectType.Amendment_Agreement__c.getRecordTypeInfosByDeveloperName().get('Amendment_Agreement_China').getRecordTypeId();
        amendment.Name = amendment.Contract_No__c + ' V' + (amendments.size() + 2);
        amendment.Agreement__c = id;
        upsert amendment;
        for (Amendment_Agreement_Product__c item : items) {
            item.Amendment_Agreement__c = amendment.Id;
        }
        insert items;
        List<Payment__c> payments = new List<Payment__c>();
        String queryPayment = QW_Utils.getQueryByFieldSet(Payment__c.getSObjectType(), 'RC_ChinaField');
        queryPayment += ' WHERE China_Order__c = \'' + id + '\'';
        for (Payment__c payment : Database.query(queryPayment)) {
            payment.Id = null;
            payment.China_Project__c = null;
            payment.China_Contract__c = null;
            payment.China_Order__c = null;
            payment.Amendment_Agreement__c = amendment.Id;
            payments.add(payment);
        }
        insert payments;
        
        TriggerHandler.bypass('RC_MDAReassignHandler');
        List<Component_Task_Book__c> mdas = new List<Component_Task_Book__c>();
        for (Component_Task_Book__c mda : (List<Component_Task_Book__c>)Database.query(
                QW_Utils.getQueryBySObjectType('Component_Task_Book__c') + 
                ' WHERE iContract__c = :id')) {
            mda.iAmendment_Agreement__c = amendment.Id;
            mdas.add(mda);
        }
        update mdas;

        this.redirectUrl = '/' + amendment.Id;
        if (amendment.Actual_Sales__c == null) return;
        QW_Utils.shareRecordsToUser(new Set<Id>{amendment.Id}, new User(Id = amendment.Actual_Sales__c));
        this.errorMsg = '创建成功';
    }
    
    private void refreshOrder () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        String name = ApexPages.currentPage().getParameters().get('name');
        List<String> inValidStage = new List<String>{'Prospecting', 'Pending', 'Closed Lost'};
        List<Amendment_Agreement__c> amendments = [SELECT Id, Stage__c FROM Amendment_Agreement__c WHERE Id =: id];
        if (amendments.size() == 0 || (String.isNotBlank(amendments[0].Stage__c) && inValidStage.contains(amendments[0].Stage__c))) throw new QW_Utils.QWException('请完成【补充协议审批】，操作【刷新】订单数据');

        Agreement__c agreement = (Agreement__c) QW_Utils.transferDataToObject(
            id, 'Agreement__c', 'RC_TransferToOrder',
            new Map<String, String>{}
        );
        
        List<Agreement_Component__c> items = new List<Agreement_Component__c>();
        String query = QW_Utils.getQueryByFieldSet(Amendment_Agreement_Product__c.getSObjectType(), 'RC_TransferToOrderProduct');
        query += ' WHERE Amendment_Agreement__c = \'' + id + '\'';
        List<Amendment_Agreement_Product__c> itemNews = (List<Amendment_Agreement_Product__c>)Database.query(query);
        for (SObject item : itemNews) {
            items.add((Agreement_Component__c) QW_Utils.transferDataToObject(
                item.Id, 'Agreement_Component__c', 'RC_TransferToOrderProduct',
                new Map<String, String>{}
            ));
        }
        if (orderId != null) agreement.Id = orderId;
        // if (orderId != null) delete [SELECT Id FROM Agreement_Component__c WHERE Agreement__c =: orderId];
        if (orderId != null) delete [SELECT Id FROM Payment__c WHERE China_Order__c =: orderId];
        agreement.Name = name;
        update agreement;
        for (Agreement_Component__c item : items) {
            item.Agreement__c = agreement.Id;
            if (String.isNotBlank(item.RowNo__c)) item.ExterId__c = agreement.Id + ';' + item.RowNo__c;
            else item.ExterId__c = Math.random().format();
        }
        upsert items Schema.Agreement_Component__c.Fields.ExterId__c;

        // refresh rowNo
        delete itemNews;
        itemNews = new List<Amendment_Agreement_Product__c>();
        for (SObject item : items) {
            itemNews.add((Amendment_Agreement_Product__c) QW_Utils.transferDataToObject(
                item.Id, 'Amendment_Agreement_Product__c', 'RC_TransferToAmendmentProduct',
                new Map<String, String>{}
            ));
        }
        for (Amendment_Agreement_Product__c item : itemNews) {
            item.Amendment_Agreement__c = id;
        }
        insert itemNews;

        List<Payment__c> payments = new List<Payment__c>();
        String queryPayment = QW_Utils.getQueryByFieldSet(Payment__c.getSObjectType(), 'RC_ChinaField');
        queryPayment += ' WHERE Amendment_Agreement__c = \'' + id + '\'';
        for (Payment__c payment : Database.query(queryPayment)) {
            payment.Id = null;
            payment.China_Project__c = null;
            payment.China_Contract__c = null;
            payment.China_Order__c = agreement.Id;
            payments.add(payment);
        }
        insert payments;
        
        TriggerHandler.bypass('RC_MDAReassignHandler');
        TriggerHandler.bypass('RC_MDAReassignHandler');
        List<Component_Task_Book__c> mdas = new List<Component_Task_Book__c>();
        for (Component_Task_Book__c mda : (List<Component_Task_Book__c>)Database.query(
                QW_Utils.getQueryBySObjectType('Component_Task_Book__c') + 
                ' WHERE iAmendment_Agreement__c = :id')) {
            mda.iOrder__c = orderId;
            mdas.add(mda);
        }
        update mdas;

        this.redirectUrl = '/' + agreement.Id;
        this.errorMsg = '刷新成功';
    }
    
    private void paymentInformation () {
        String id = ApexPages.currentPage().getParameters().get('id');
        String recordname = OrderDetailCtrl.findObjectNameFromRecordIdPrefix(id);
        if(recordname=='iContract' || recordname=='leanx__lg_Contract__c' || recordname=='lg_Contract'){
            leanx__lg_Contract__c con = [SELECT ID,
                                            Contract_No__c,
                                            leanx__Account__c,
                                            leanx__Account__r.SAP_External_ID__c
                                            FROM   leanx__lg_Contract__c
                                            WHERE  ID = :id 
                                            LIMIT 1];
            this.redirectUrl = '/apex/OrderDetailPage2?id=' + id+'&ContractNO='+con.Contract_No__c+'&SAPID='+con.leanx__Account__r.SAP_External_ID__c;
        } else if (recordname=='iOrder' || recordname=='Agreement' || recordname=='Agreement__c'){
            Agreement__c a = [SELECT ID,
                                Contract__r.Contract_No__c,
                                Account__c,
                                Account__r.SAP_External_ID__c
                                FROM   Agreement__c
                                WHERE  ID = :id 
                                LIMIT 1];
            this.redirectUrl = '/apex/OrderDetailPage3?id=' + id+'&ContractNO='+a.Contract__r.Contract_No__c+'&SAPID='+a.Account__r.SAP_External_ID__c;
        }
    }
    
    private void syncOrder () {
        String id = ApexPages.currentPage().getParameters().get('id');
        Boolean flag_test = false;
        if (flag_test) throw new QW_Utils.QWException('功能测试中，请联系管理员');
        List<Agreement__c> agreements = (List<Agreement__c>)Database.query(
            QW_Utils.getQueryBySObjectType(Agreement__c.getSObjectType()) + 
            ' WHERE Id = \'' + id + '\'');
        if (agreements.size() == 0) throw new QW_Utils.QWException('数据不存在');
        else if (agreements[0].Buyer_SAP_Id__c == null) throw new QW_Utils.QWException('此订单客户未同步至SAP, 请同步客户主数据至OA系统');
        else if (agreements[0].SAP_Order_ID__c != null) throw new QW_Utils.QWException('此订单已经同步至SAP!');
        else { // if (agreements[0].Buyer_SAP_Id__c != null && agreements[0].SAP_Order_ID__c == null)
            RC_SapSync_Order sapSync = new RC_SapSync_Order(agreements[0], false, false);
            Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(sapSync.sync());
            this.errorMsg = (String)result.get('MESSTXT');
            if ((String)result.get('RESULT') == 'S') {
                // sapSync.agreement.SAP_Order_Id_History__c = sapSync.agreement.SAP_Order_ID__c;
                sapSync.agreement.SAP_Order_ID__c = (String)result.get('I_VBELN');
                update sapSync.agreement;
            }
        }
    }

    private void printPDF () {
        String id = ApexPages.currentPage().getParameters().get('id');
        this.redirectUrl = '/apex/RC_ContractPDFPage?id=' + id;
    }

    private void printTerminationPDF(){
        String id = ApexPages.currentPage().getParameters().get('id');
        Amendment_Agreement__c amendmentOrder = Database.query(Utils.MakeSelectSql('Amendment_Agreement__c') + ' WHERE Id =: id');
        if(amendmentOrder.Amendment_Approve_Staus__c){
            this.redirectUrl = '/apex/RC_TerminationPDF?id=' + id; 
        }else{
            this.errorMsg = '终止协议未审批完成，无法打印终止协议。';
            this.redirectUrl = '/' + id;
        }
    }

    private void printAmendmentPDF(){
        String id = ApexPages.currentPage().getParameters().get('id');  
        Amendment_Agreement__c amendmentOrder = Database.query(Utils.MakeSelectSql('Amendment_Agreement__c') + ' WHERE Id =: id');
        if(amendmentOrder.Amendment_Approve_Staus__c){
            this.redirectUrl = '/apex/RC_AmendmentProductPDF?id=' + id; 
        }else{
            this.errorMsg = '补充协议未审批完成，无法打印补充协议。';
            this.redirectUrl = '/' + id;
        }
    }
}