@isTest
public class ContractTemplat1MWCtrlTest {

    private static testMethod void submitTest(){
		Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'EXW';
		insert opp;
		Trade_term_and_payment_term__c ttapt = TestHelper.createTradeTermPaymentTerm();
		Payment__c pay = TestHelper.createPayment(opp.Id);
		Opportunity opp2 = [select id,Payment_Term_Description__c,Payment_1MW_Approve__c from Opportunity where id =: opp.Id];
		
		//system.assert(opp2.Payment_1MW_Approve__c);
		delete pay;
        
		Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.id;
        insert con;
        ContractTemplat1MWCtrl ctrl = new ContractTemplat1MWCtrl(new ApexPages.StandardController(con));
        ctrl = new ContractTemplat1MWCtrl();
        
    }
}