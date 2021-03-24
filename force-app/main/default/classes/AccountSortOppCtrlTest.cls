@isTest
public class AccountSortOppCtrlTest {
    static testmethod void test(){
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        List<Opportunity> ConList = new List<Opportunity>();
        ApexPages.currentPage().getParameters().put('id',acc.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(ConList);
        AccountSortOppCtrl mdpc = new AccountSortOppCtrl(ctrl);
        mdpc.ChangedId = '0';
        mdpc.UpDataList();
        mdpc.TopDataList();
        mdpc.DownDataList();
        mdpc.TailDataList();
        mdpc.doSave();     
        
       
        }
}