@isTest
public class PIJinkoApaTest {
    private static testMethod void ContractPreview(){
        Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'EXW';
		insert opp;
		Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm();
		Payment__c pay = TestHelper.createPayment(opp.Id);
		Opportunity opp2 = [select id,Payment_Term_Description__c,Payment_1MW_Approve__c from Opportunity where id =: opp.Id];
		
		delete pay;
        
		Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.id;
        insert con;
		pay = TestHelper.createPayment(opp.Id,false);
        pay.Contract__c = con.id;
        insert pay;
        Amendment__c am = TestHelper.createAmendment();
        am.Opportunity__c = opp.id;
        update am;
        ApexPages.currentPage().getParameters().put('id', am.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(am);
        PIJinkoApa newPi = new PIJinkoApa(sc);
    }
    
}