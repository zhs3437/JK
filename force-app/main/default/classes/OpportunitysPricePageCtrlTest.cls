/**
* 
* create by fanzr 20170801
* 
*/
@isTest
public class OpportunitysPricePageCtrlTest {
    static testMethod void OpportunitysPricePageCtrl() {
        List<Opportunity> oppLst =new  List<Opportunity>();
        Opportunity       opp   =new Opportunity();
        Opportunity       subopp   =new Opportunity();
        PriceBookEntry    pbe =new PriceBookEntry();
        List<OpportunityLineItem> oppLinLst =new  List<OpportunityLineItem>();
        OpportunityLineItem oppli =new OpportunityLineItem();
        /**
        Product2          p =new Product2();
        p.Maximum_Power_at_STC_Pmax__c = 300;
        p.name ='Product';
        p.IsActive = true;
        insert p;
        */
       // pbe.PriceBook2ID= Test.getStandardPriceBookID();
       // pbe.product2ID= p.Id;
      //  pbe.unitPrice = 120;
      //  pbe.isActive = true;
      //   insert pbe;
        opp.Name               = '2MW-JKM180-20120101';
        // opp.AccountID          = accountID;
        opp.CloseDate          = Date.today();
        //opp.Pricebook2Id       = pbe.Id;
        opp.amount             = 1200.00;
        opp.StageName          = 'PO Imminent';
        opp.Probability        = 80;
        opp.delivey_point__c   ='sad';
        insert opp;	
        
         subopp.Name               = '2MW-JKM180-20120101';
        // opp.AccountID          = accountID;
        subopp.CloseDate          = Date.today();
        subopp.faOpportunity__c   = opp.Id;
        //opp.Pricebook2Id       = pbe.Id;
        subopp.amount             = 1200.00;
        subopp.StageName          = 'PO Imminent';
        subopp.Probability        = 80;
         subopp.delivey_point__c   ='sad';
        insert subopp;	
    }
    
}