/**
 * 
 * create By jason 20160605
 * 合同和补充协议 的审批人
 */
@isTest
private class SubmitReviewHelperTest {
    private static testMethod void getContractAustraliaReviewList() {
        ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        Account acc = TestHelper.createAccount(true);
          Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id, false);
        con.RecordTypeId = AustraliaRecordTypeId;
        con.Opportunity__c =opp.Id;
        insert con;
        SubmitReviewHelper.getContractReviewList(con.id);
    }
    
    private static testMethod void getContract1MWJapanReviewList() {
        ID Japan1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        Account acc = TestHelper.createAccount(true);
          Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id, false);
        con.RecordTypeId = Japan1MWRecordTypeId;
        con.Opportunity__c =opp.Id;
        insert con;
        SubmitReviewHelper.getContractReviewList(con.id);
    }
    
    private static testMethod void getContract1MWStandardReviewList() {
        ID Standard1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        Account acc = TestHelper.createAccount(true);
          Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id, false);
        con.RecordTypeId = Standard1MWRecordTypeId;
        con.Opportunity__c =opp.Id;
        insert con;
        SubmitReviewHelper.getContractReviewList(con.id);
    }
    
    private static testMethod void getContractReviewList() {
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        Account acc = TestHelper.createAccount(true);
          Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id, false);
        con.RecordTypeId = IntercompanyRecordTypeId;
        con.Opportunity__c =opp.Id;
        insert con;
        SubmitReviewHelper.getContractReviewList(con.id);
    }
    
}