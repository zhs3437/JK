@isTest
public class ProductSortCtrlTest {
    static testmethod void test(){
        Account a = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(a.id);
        List<Opportunity> OppList = new List<Opportunity>();
        OppList.add(opp);
        OpportunityLineItem opplin =TestHelper.createOpportunityLineItem(opp.id,'01u6F00000BFoT7');
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(OppList);
        ProductSortCtrl mdpc = new ProductSortCtrl(ctrl);
        mdpc.ChangedId = '0';
        mdpc.UpDataList();
        mdpc.TopDataList();
        mdpc.DownDataList();
        mdpc.TailDataList();
        mdpc.doSave();      
        }
}