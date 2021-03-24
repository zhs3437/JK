@isTest
public without sharing class RC_ServiceTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
        System.runAs(admin){
            leanx__lg_Contract__c contract = QW_TestDataFactory.createIContract();
            insert contract;
            Contract_Component__c contractItem = QW_TestDataFactory.createIContractItemById(contract.Id);
            insert contractItem;
            User user = QW_TestDataFactory.createUser('test@jinkosolar.com', [SELECT Id FROM Profile WHERE Profile.Name = 'China - Sales'][0].Id);
            insert user;
            leanx__lg_Contract__Share contractShare = new leanx__lg_Contract__Share(
                ParentId = contract.Id,
                AccessLevel = 'Edit',
                UserOrGroupId = user.Id
            );
            insert contractShare;
            Group g = QW_TestDataFactory.createGroup();
            insert g;
            GroupMember groupMember = QW_TestDataFactory.createGroupMember(g.Id, user.Id);
            insert groupMember;
            leanx__lg_Contract__Share contractShareGroup = new leanx__lg_Contract__Share(
                ParentId = contract.Id,
                AccessLevel = 'Edit',
                UserOrGroupId = g.Id
            );
            insert contractShareGroup;
            
            Component_Task_Book__c mda = QW_TestDataFactory.createComponentTaskBook();
            mda.iContract__c = contract.Id;
            insert mda;
        }
    }

    @isTest 
    static void test_init() {
        RC_Service.contract service = new RC_Service.contract();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/rc/contract';
        Restcontext.request = request;
        Restcontext.response = response;
        RC_Rest.sql();
        RC_Rest.dml();
    }

    @isTest 
    static void test_contract() {
        RC_Service.contract service = new RC_Service.contract();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'GET';
        service.init(request, response);
        service.execute(new Map<String, Object>{
            'id' => [SELECT Id FROM leanx__lg_Contract__c][0].Id
        });
    }

    @isTest()
    static void test_comments() {
        RC_Service.comments service = new RC_Service.comments();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{' +
            '"action": "chatter",' +
            '"user_sfid": "' + [SELECT Id FROM User][0].Id + '",' +
            '"user_email": "",' +
            '"user_ad_name": "",' +
            '"contract_sfid": "' + [SELECT Id FROM leanx__lg_Contract__c][0].Id + '",' +
            '"contract_file_name": "Test.docx",' +
            '"contract_version": "0.1",' +
            '"comment": "Hi, @Neo Thanks @Nick Thanks",' +
            '"comment_mention_user_sfid": ["' + [SELECT Id FROM User][0].Id + '", null]' +
        '}');
        service.init(request, response);
        service.execute(new Map<String, Object>{});
    }

    @isTest 
    static void test_event() {
        RC_Service.event service = new RC_Service.event();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{' +
            '"action": "upload",' +
            '"user": {' +
                '"sfid": null,' +
                '"ad_name": "",' +
                '"email": ""' +
            '},' +
            '"contract": {' +
                '"sfid": "' + [SELECT Id FROM leanx__lg_Contract__c][0].Id + '",' +
                '"spid": "",' +
                '"file_name": "",' +
                '"url": "",' +
                '"version": ""' +
            '}' +
        '}');
        service.init(request, response);
        service.execute(new Map<String, Object>{});
    }

    @isTest 
    static void test_mda() {
        RC_Service.mda service = new RC_Service.mda();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.headers.put('MDAID', [SELECT Id, Name FROM Component_Task_Book__c LIMIT 1][0].Name);
        service.init(request, response);
        service.execute(new Map<String, Object>{});
    }
}