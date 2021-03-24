@isTest
public class ContractSortCtrlTest {
    static testmethod void test(){
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract c = TestHelper.createContract(acc.Id,false);
        c.Contract_NO__c ='222';
        c.Opportunity__c = opp.Id;
        List<Contract> ConList = new List<Contract>();
        insert c;
        ApexPages.currentPage().getParameters().put('id',acc.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(ConList);
        ContractSortCtrl mdpc = new ContractSortCtrl(ctrl);
        mdpc.ChangedId = '0';
        mdpc.UpDataList();
        mdpc.TopDataList();
        mdpc.DownDataList();
        mdpc.TailDataList();
        mdpc.doSave();     
        
       
        }
}