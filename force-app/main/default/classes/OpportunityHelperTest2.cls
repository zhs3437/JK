@isTest
public class OpportunityHelperTest2 {
    static testMethod void myUnitTest() {
        Account acc = TestHelper.createAccount();
        Opportunity oppNew = TestHelper.createOpportunity(acc.Id);
        Opportunity oppOld = TestHelper.createOpportunity(acc.Id);
        List<Opportunity> newOppLst = new List<Opportunity>();
        newOppLst.add(oppNew);
        List<Opportunity> oldOppLst = new List<Opportunity>();
        oldOppLst.add(oppOld);
        Product2 p = TestHelper.createProduct2();
        PricebookEntry pbe = TestHelper.createPriceBookEntry(p.Id);
        OpportunityLineItem oli = TestHelper.createOpportunityLineItem(oppNew.Id, pbe.Id);
        List<OpportunityLineItem> oliLst = new List<OpportunityLineItem>();
        oliLst.add(oli);
        Payment__c pay = TestHelper.createPayment(oppNew.Id);
        List<Payment__c> payLst = new List<Payment__c>();
        payLst.add(pay);
        Set<ID> opIds = new Set<ID>();
        opIds.add(oppNew.Id);
           OpportunityHelper.changedFaOpp(newOppLst, oldOppLst);        
        OpportunityHelper.changedProduct(newOppLst, oldOppLst);
        OpportunityHelper.oppChLst(oppNew);
        OpportunityHelper.oppfa(oppNew);
        OpportunityHelper.oppIdLst(newOppLst);
        OpportunityHelper.oppLineItemLst(oppNew.Id);

        OpportunityHelper.SendEmail(newOppLst, oldOppLst);
        OpportunityHelper.updateAustralia(oldOppLst);
        OpportunityHelper.updateFiled(newOppLst);
        OpportunityHelper.UpdateSendOrNo(newOppLst, oldOppLst);
   
        OpportunityHelper.updateVolue3(newOppLst, oppNew);
    }
    
}