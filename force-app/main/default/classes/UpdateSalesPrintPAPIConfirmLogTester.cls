/* Create Byn Jason 20161021*/
@isTest
public class UpdateSalesPrintPAPIConfirmLogTester {
    private static testMethod void updateSalesPrintLog(){
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016102100';
        con.Trade_term__c  = 'EXW';
        insert con;
        Payment__c pay = new Payment__c();
        pay.Down_Balance_Payment__c = 'Down Payment';
        pay.Percentage__c           =  100;
        pay.Days__c                 =  60;
        pay.Payment_Term__c         = 'at sight';
        pay.Contract__c				= con.Id;
        pay.Comments__c			 = '';
        pay.Credit_Valid__c		 = true;
        pay.Payment_Method__c       = 'T/T'; 
        pay.Payment_Term__c         = 'after PO date';
        insert pay;
        List<Payment__c> payLst = new List<Payment__c>();
        payLst.add(pay);
        UpdateSalesPrintPAPIConfirmLog.submit(con.id);
        UpdateSalesPrintPAPIConfirmLog.cancel(con.id);
    }	
}