@isTest
public class AddOppItemCtrlTest {
    static testMethod void myTest(){
        ApexPages.StandardController std;
        Account acc         = TestHelper.createAccount();
        Product2 p2          = TestHelper.createProduct2();
        PricebookEntry pbe  = TestHelper.createPricebookEntry(p2.id);
        Opportunity opp         = TestHelper.createOpportunity(acc.id);
        Quote q =TestHelper.createQuote(opp.id);
        OpportunityLineItem oppitem =TestHelper.createOpportunityLineItem(opp.id,pbe.id);
        ApexPages.currentPage().getParameters().put('Id',opp.id);
        AddOppItemCtrl aoc =new AddOppItemCtrl(std);
        aoc.EditID=q.id;
        AddOppItemCtrl.number(opp.id);
        aoc.Edit();
       // aoc.UpdateQuoteItem();
        aoc.AddOppProduct();
        aoc.AddQuote();
        AddOppItemCtrl.UpdateQuoteItem2(opp.id);
        
    }
}