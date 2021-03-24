@isTest(SeeAllData=false)
public without sharing class QW_TestDataFactory {

    public static User createUser() {
        User user = new User();
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        user.ProfileId = profile.Id;
        user.FirstName = 'Shi';
        user.LastName = 'Gongyi';
        user.Alias= 'Shi';
        user.Email = 'gongyi.shi@jinkosolar.com.jinkotest';
        user.Username = 'shi@jinkosolar.com.jinkotest';
        user.TimeZoneSidKey = 'Asia/Shanghai';
        user.LocaleSidKey = 'zh_CN';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'zh_CN';

        return user;
    }

    public static User createUser(String username, String profileId) {
        User user = new User();
        user.ProfileId = profileId;
        user.FirstName = 'Shi';
        user.LastName = 'Gongyi';
        user.Alias= 'Shi';
        user.Email = 'gongyi.shi@jinkosolar.com.jinkotest';
        user.Username = username;
        user.TimeZoneSidKey = 'Asia/Shanghai';
        user.LocaleSidKey = 'zh_CN';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'zh_CN';

        return user;
    }

    public static Group createGroup() {
        return new Group(
            Name = 'Test Group'
        );
    }

    public static GroupMember createGroupMember(Id groupId, Id userOrGroupId) {
        return new GroupMember(
            GroupId = groupId,
            UserOrGroupId = userOrGroupId
        );
    }

    public static Project__c createProject() {
        Project__c projects = new Project__c();
        projects.Name = '中广核黔西南自治州贞丰县陇塔10万kW农业光伏电站项目';
        projects.Project_Location__c = '贵州省';
        projects.Total_Project_Size_MW__c = 60.0000;
        projects.Probability__c = '25%';
        projects.Priority__c = 'Hot';
        projects.ProjcetType__c = 'Lighting';
        projects.Planned_Project_Close_Date__c = Date.newInstance(2020,5,8);
        
        Account account = QW_TestDataFactory.createAccount();
        insert account;
        
        projects.RegionAccount__c = account.Id;
        
        return projects;
    }

    public static Account createAccount() {
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosByName();

        Account account = new Account();
        account.Name = 'JinKoTestAccount';
        account.Country__c = 'China';
        account.Destination_State__c = 'N/A';
        account.Customer_Business_Type__c = 'EPC';
        account.Phone = '11111111111';
        account.Company_Email__c = 'Jinko@jinkosolar.com';
        account.Website = 'www.jinko.com';
        account.RecordTypeId = rtMap.get('China Account').getRecordTypeId();
        account.BillingCountry = 'null';
        account.BillingState = 'null';
        account.BillingCity = 'null';
        account.BillingStreet  = 'null';
        account.BillingPostalCode  = 'null';
        account.IsRegionAccount__c = true;
        account.SAP_External_ID__c = 'test id';

        return account;
    }
    
    public static QWUser__c createQWUser() {
        QWUser__c qwUser = new QWUser__c();
        qwUser.Name = 'TestUser';
        qwUser.Email__c = 'jinko@jinkosolar.com';
        qwUser.IsActive__c = true;
        qwUser.IsRegionLeader__c = true;
        
        return qwUser;
    }
    
    public static Product2 createProduct2() {
        Product2 product = new Product2();
        product.Name = 'JKM400-6H-Test Product';
        product.Maximum_Power_At_STC_Pmax__c = 1;
        product.IsActive = true;
        product.Product_Module_PM__c = 'R-P-163.75-78TR-M';
        return product;
    }
    
    public static SAP_Product__c createSAPProduct() {
        SAP_Product__c product = new SAP_Product__c();
        product.Name = '26000000';
        product.Product_Name__c = 'Test SAP Product';
        product.Product_Code__c = '26000000';
        product.Frame_B_side_Height__c = 'T001001';
        product.Frame_Color__c = 'T002001';
        product.Grade_Level__c = 'T003001';
        return product;
    }

    public static Opportunity createOpportunity() {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = '0.1MW-JKM385M-72-V-20200527';
        opportunity.AccountId = [SELECT Id FROM Account LIMIT 1].Id;
        opportunity.CloseDate = Date.today();
        opportunity.Pricebook2Id = Test.getStandardPriceBookID();
        opportunity.amount = 1200.00;
        opportunity.StageName = 'PO Imminent';
        opportunity.Region__c = 'ROA';
        opportunity.Actual_Sales_Name__c = 'arda';
        opportunity.delivey_point__c = 'sa';
        opportunity.Probability = 8;
        return opportunity;
    }
    
    public static leanx__hr_Resource__c createProduct2(Boolean isCustom) {
        leanx__hr_Resource__c product = new leanx__hr_Resource__c();
        product.Name = 'JKM400-6H-Test Product';
        product.Maximum_Power_At_STC_Pmax__c = 1;
        product.IsActive__c = true;
        
        return product;
    }

    public static Payment__c createPayment() {
		Payment__c payment = new Payment__c();
		payment.Days__c = 10;
        payment.Percentage__c = 100;
        payment.Payment_Stage_China__c = '发货款';
        payment.Payment_Method_China__c = '电汇';
        payment.Payment_Term_China__c = '发货前全款';
        payment.PaymentDescription__c = '批次发货，发货前支付100%批次发货款';

        return payment;
    }
    
    public static leanx__pm_Project__c createIProject() {
        leanx__pm_Project__c project = new leanx__pm_Project__c();
        project.Name = 'JKM400-6H-Test Project';
        project.Trade_Term__c = 'EXW';
        project.Destination_Country__c = 'United States';
        project.Destination_Region__c = 'North America';
        project.Destination_Port__c = 'Los Angelas';
        project.Commission_Type__c = 'Per/W';
        project.Commission__c = 0.001;
        
        return project;
    }
    
    public static leanx__pm_ProjectMember__c createIProjectItemById(Id projectId) {
        leanx__pm_ProjectMember__c item = new leanx__pm_ProjectMember__c();
        item.leanx__Project__c = projectId;
        // item.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        item.Quantity__c = 100;
        item.Sales_Price__c = 1.2;
        item.Total_Power_W__c = 100;
        item.Guaranteed_Delivery_Date__c = Date.valueOf('2021-11-01');
        
        return item;
    }
    
    public static leanx__lg_Contract__c createIContract() {
        leanx__lg_Contract__c contract = new leanx__lg_Contract__c();
        contract.Stage__c = 'Contract Negotiation';
        
        return contract;
    }
    
    public static Contract_Component__c createIContractItemById(Id contractId) {
        Contract_Component__c item = new Contract_Component__c();
        item.Contract__c = contractId;
        // item.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        item.Quantity__c = 100;
        item.Sales_Price__c = 1.2;
        item.Total_Power_W__c = 100;
        item.Guaranteed_Delivery_Date__c = Date.valueOf('2021-11-01');
        
        return item;
    }
    
    public static Agreement__c createAgreement() {
        Agreement__c agreement = new Agreement__c();
        
        return agreement;
    }
    
    public static Agreement_Component__c createAgreementItemById(Id agreementId) {
        Agreement_Component__c item = new Agreement_Component__c();
        item.Agreement__c = agreementId;
        // item.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        item.Quantity__c = 100;
        item.Sales_Price__c = 1.2;
        item.Total_Power_W__c = 100;
        item.Guaranteed_Delivery_Date__c = Date.valueOf('2021-11-01');
        
        return item;
    }
    
    public static Amendment_Agreement__c createAmendmentAgreement() {
        Amendment_Agreement__c agreement = new Amendment_Agreement__c();
        agreement.RecordTypeId = Schema.SObjectType.Amendment_Agreement__c.getRecordTypeInfosByName().get('Amendment Agreement China').getRecordTypeId();
        return agreement;
    }
    
    public static Amendment_Agreement_Product__c createAmendmentAgreementItemById(Id agreementId) {
        Amendment_Agreement_Product__c item = new Amendment_Agreement_Product__c();
        item.Amendment_Agreement__c = agreementId;
        // item.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        item.Quantity__c = 100;
        item.Sales_Price__c = 1.2;
        item.Total_Power_W__c = 100;
        item.Guaranteed_Delivery_Date__c = Date.valueOf('2021-11-01');
        
        return item;
    }

    public static Component_Task_Book__c createComponentTaskBook(){
        return new Component_Task_Book__c(
            RecordTypeId = Schema.SObjectType.Component_Task_Book__c.getRecordTypeInfosByName().get('中国区MDA').getRecordTypeId(),
            Frame_B_side_Height__c = '30mm 边框',
            Frame_Color__c = '银边框',
            Module_Level__c = 'A级',
            Product_Certificate__c = 'IEC61215: 2005 (TUV certified)',
            Rear_cover__c = '白背板',
            Frame_Type__c = '晶科标准边框',
            LRF__c = '无要求_可混',
            EVA__c = '整单一致',
            Glass_Thickness__c = '2.0mm',
            Rear_Cover_Material__c = '由工厂确定',
            Additional_Certificate__c = 'No need',
            C_side_type_of_short_frame__c = '无边框',
            Nameplate__c = '晶科标准-中文',
            Shipping_Mark__c = '晶科标准-英文',
            Current_Sorting_Style__c = '不需要',
            Color_Sorting_style__c = '不需要',
            Additional_Shipping_Mark_Color_Label__c = '不需要',
            Cell__c = '不接受',
            Warranty__c = 'Standard',
            Front_Glass__c = '抗反射玻璃',
            Component_Series_Resistance__c  = '晶科标准（≤0.9Ω）',
            BOM__c='Standard Certified BOM',
            Junction_Box_brand__c = '晶科标准-一体',
            Junction_Box_Cable_Length__c = '900mm',
            Junction_Box_Connector__c = 'MC4',
            On_site_monitor_by_Client_or_3rd_party__c='Yes, Consignee',
            Package__c = 'Standard packing method for Dual-glass frameless modules',
            Power_Tolerance__c='Each module: 0~+3%',
            System_Voltage__c='1500V',
            Additional_power__c='No',
            Special_Approval_for_order_production__c='No',
            On_line_Audit__c='No Need',
            Pre_shipping_Inspection_factory__c='No Need',
            Lab_tests__c='Jinko laboratory',
            Cell_Quantity1__c='72',
            Cell_Type1__c='Other',
            Cell_Quantity2__c='72',
            Cell_Type2__c='Other',
            Cell_Quantity3__c='72',
            Cell_Type3__c='Other',                                                                      
            Technical_manager_Shanghai__c='Approved'
        );
    }
}