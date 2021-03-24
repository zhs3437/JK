@isTest
public class OppDiffCtrlTest {
static testMethod void myTest(){
    		Product2 p          = TestHelper.createProduct2();
	    PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
	    Account acc         = TestHelper.createAccount();
	    Opportunity opp       = TestHelper.createOpportunity(acc.id);
    String requestId=opp.Id;
    OppDiffCtrl.History a=new  OppDiffCtrl.History();
    a.DiffMW=1;
    a.DiffPow=2;
    a.DiffPrice=3;
    a.DiffQuantity=4;
    Opportunity_Differences__c oppd =new Opportunity_Differences__c();
    oppd.Opp_Total_MW_New__c=0;
    a.add(oppd);
    ApexPages.StandardController sd=null;
    Opportunity_Differences__c oppDiff=new Opportunity_Differences__c();
    oppDiff.Opportunity__c=opp.Id;
    oppDiff.ApprovalNumbers__c='1';

    oppDiff.Opp_Total_MW_New__c=10;
    oppDiff.Opp_Total_MW_Old__c=9;
    oppDiff.Opp_Total_Power_New__c=10;
    oppDiff.Opp_Total_Power_Old__c=9;
    oppDiff.Opp_Total_Price_New__c=10;
    oppDiff.Opp_Total_Price_Old__c=9;
    oppDiff.Opp_Total_Quantity_New__c=10;
    oppDiff.Opp_Total_Quantity_Old__c=9;

    insert oppDiff;
    List<Opportunity_Differences__c> oppDiffLst=new List<Opportunity_Differences__c>();
    oppDiffLst.add(oppDiff);
    system.debug('hahaha+++++'+oppDiff.Id);
    update oppDiffLst;
    OpportunityLineItem_Difference__c opplinDiff =new OpportunityLineItem_Difference__c();
    opplinDiff.Opportunity_Difference__c=oppDiff.Id;
    opplinDiff.ApprovalNumbers__c='1';
    a.addOpplinDiff(opplinDiff);
    insert opplinDiff;
    PaymentDifference__c paydiff= new PaymentDifference__c();
    paydiff.ApprovalNumbers__c='1';
    paydiff.Opportunity_Difference__c=oppDiff.Id;
    a.addpayDiff(paydiff);
    insert paydiff;
    ApexPages.currentPage().getParameters().put('id',opp.Id);
    Double DiffMW=1;
    Double DiffPow=2;
    Double DiffPrice=3;
    Integer DiffQuantity=4;
    system.debug('12345678--'+opplinDiff);
    OppDiffCtrl b= new OppDiffCtrl(sd);
}
}