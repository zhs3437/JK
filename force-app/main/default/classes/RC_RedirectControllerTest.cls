@IsTest
public without sharing class RC_RedirectControllerTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        Opportunity opportunity = QW_TestDataFactory.createOpportunity();
        insert opportunity;
        Product2 product2 = QW_TestDataFactory.createProduct2();
        insert product2;
        leanx__pm_Project__c project = QW_TestDataFactory.createIProject();
        project.Actual_Sales__c = admin.Id;
        insert project;
        leanx__pm_ProjectMember__c projectItem = QW_TestDataFactory.createIProjectItemById(project.Id);
        insert projectItem;
        leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract();
        contract.Project__c = project.Id;
        insert contract;
        Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
        contractItem.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        insert contractItem;
        Agreement__c agreement = QW_TestDataFactory.createAgreement();
        agreement.Account__c = accounts.Id;
        agreement.Actual_Sales__c = admin.Id;
        insert agreement;
        SAP_Product__c material = new SAP_Product__c(
            Name = '26',
            Product_Code__c = '26'
        );
        insert material;
        Agreement_Component__c agreementItem = QW_TestDataFactory.createAgreementItemById(agreement.Id);
        agreementItem.SAP_Materiel_No__c = material.Id;
        insert agreementItem;
        Component_Task_Book__c mda = QW_TestDataFactory.createComponentTaskBook();
        mda.iOrder__c = agreement.Id;
        insert mda;
        agreementItem.MDA__c = mda.Id;
        update agreementItem;
        Amendment_Agreement__c amendment = QW_TestDataFactory.createAmendmentAgreement();
        amendment.Agreement__c = agreement.Id;
        amendment.Stage__c = 'Approved';
        insert amendment;
        Amendment_Agreement_Product__c amendmentItem = QW_TestDataFactory.createAmendmentAgreementItemById(amendment.Id);
        insert amendmentItem;
        Payment__c payment = QW_TestDataFactory.createPayment();
        payment.China_Project__c = project.Id;
        payment.China_Contract__c = contract.Id;
        payment.China_Order__c = agreement.Id;
        payment.Amendment_Agreement__c = amendment.Id;
        insert payment;
        project.Stage__c = 'Price Approved';
        project.Probability__c = '50%';
        project.GM_Approval__c = 'Approved';
        project.Actual_Sales__c = admin.Id;
        update project;
    }

    @isTest 
    static void test_init() {
        RC_RedirectController ctrl = new RC_RedirectController(
            new ApexPages.StandardSetController([SELECT Id FROM Account LIMIT 1])
        );
    }

    @isTest 
    static void test_syncOA() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=syncOA&id=' + [SELECT Id FROM Account][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_quickOrder() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=quickOrder&id=' + [SELECT Id FROM Opportunity][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_CommissionApplication() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=CommissionApplication&id=' + [SELECT Id FROM leanx__lg_Contract__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_createAmendmentAgreement() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=createAmendmentAgreement&id=' + [SELECT Id FROM Agreement__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_CreateContract() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=createContract&id=' + [SELECT Id FROM leanx__pm_Project__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_resetApprovalStatus() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=resetApprovalStatus&id=' + [SELECT Id FROM leanx__lg_Contract__c][0].Id +
                '&fields=Review_Status_Finance__c=')
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_createContract2() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=refreshContract&id=' + [SELECT Id FROM leanx__lg_Contract__c][0].Id +
                '&projectId=' + [SELECT Id FROM leanx__pm_Project__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_CreateOrder() {
        RC_RedirectController ctrl = new RC_RedirectController();
        leanx__lg_Contract__c contract = [SELECT Id FROM leanx__lg_Contract__c][0];
        contract.Stage__c = 'Counter Signed';
        update contract;
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=CreateOrder&id=' + contract.Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_createAmendmentAgreement2() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=createAmendmentAgreement2&id=' + [SELECT Id FROM Agreement__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_RefreshOrder() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=refreshOrder&id=' + [SELECT Id FROM Amendment_Agreement__c][0].Id +
                '&orderId=' +  + [SELECT Id FROM Agreement__c][0].Id +
                '&name=test+order'
            )
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_PaymentInformation() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=PaymentInformation&id=' + [SELECT Id FROM leanx__lg_Contract__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_syncOrder() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=syncOrder&id=' + [SELECT Id FROM Agreement__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_printPDF() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=printPDF&id=' + [SELECT Id FROM leanx__lg_Contract__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_printTerminationPDF() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=printTerminationPDF&id=' + [SELECT Id FROM leanx__lg_Contract__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_printAmendmentPDF() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=printAmendmentPDF&id=' + [SELECT Id FROM Amendment_Agreement__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_shareTo() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=shareTo&id=' + [SELECT Id FROM Amendment_Agreement__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest
    static void test_printMDA() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=printMDA&id=' + [SELECT Id FROM Component_Task_Book__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest
    static void test_createMDA() {
        RC_RedirectController ctrl = new RC_RedirectController();
        leanx__lg_Contract__c contract = [SELECT Id FROM leanx__lg_Contract__c][0];
        Contract_Component__c contractItem1 = QW_TestDataFactory.createIContractItemById(contract.Id);
        contractItem1.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        Contract_Component__c contractItem2 = QW_TestDataFactory.createIContractItemById(contract.Id);
        contractItem2.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        Contract_Component__c contractItem3 = QW_TestDataFactory.createIContractItemById(contract.Id);
        contractItem3.Product__c = [SELECT Id FROM leanx__hr_Resource__c][0].Id;
        insert contractItem1;
        insert contractItem2;
        insert contractItem3;
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=createMDA&id=' + contract.Id +
                '&p1=' + contractItem1.Id +
                '&p2=' + contractItem2.Id +
                '&p3=' + contractItem3.Id +
                '&itemObject=Contract_Component__c' +
                '&parentField=iContract__c'
            )
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_ProductMaintenance() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=ProductMaintenance&id=' + [SELECT Id FROM leanx__pm_Project__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_checkPermission() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=checkPermission&id=' + [SELECT Id FROM leanx__pm_Project__c][0].Id)
        );
        ctrl.redirect();
    }

    @isTest 
    static void test_orderNotice() {
        RC_RedirectController ctrl = new RC_RedirectController();
        Test.setCurrentPageReference(
            new PageReference('/Redirect?action=orderNotice&id=' + [SELECT Id FROM Agreement__c][0].Id)
        );
        ctrl.redirect();
    }
}