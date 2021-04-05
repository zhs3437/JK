@isTest
public class SaveAsPDFTest {

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
		pay = TestHelper.createPayment(opp.Id,false);
        pay.Contract__c = con.id;
        insert pay;
        Test.startTest();
        
        Amendment__c am = TestHelper.createAmendment();
        SaveAsPDF.doCreatePA1MW(con.id);
        SaveAsPDF.doCreatePA1MWJapan(con.id);
        SaveAsPDF.doCreatePI1MW(con.id);
        SaveAsPDF.doCreatePI1MWJapan(con.id);
        SaveAsPDF.doCreateSAEn(am.Id);
        SaveAsPDF.doCreateSAGlobal(am.Id);

        Test.stopTest();
    }
}