@isTest
public class ContractAfricaPriceApprovalTest {
    public static testMethod void testClone(){
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.id,false);
        opp.Excluding_VAT__c = true;
        insert opp;
        Contract c = TestHelper.createContract(acc.Id,false);
        c.Opportunity__c = opp.id;
        c.Region__c = 'Middle East&Africa';
        c.RecordTypeId = Standard1MWRecordTypeId;
        insert c;
        
        ContractAfricaPriceApproval capa = new ContractAfricaPriceApproval();
        capa.con = c;
        ContractAfricaPriceApproval.SendEmail(c.Id);      
        ContractAfricaPriceApproval.submit(c.Id);
    }

}