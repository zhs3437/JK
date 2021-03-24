@isTest
public class ROAQuoteCtrlTest {
    static testmethod void test(){
        Account a = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(a.id);
        OpportunityLineItem opplin =TestHelper.createOpportunityLineItem(opp.id,'01u6F00000BFoT7');
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ROAQuoteCtrl rq =new ROAQuoteCtrl(null);
        }
}