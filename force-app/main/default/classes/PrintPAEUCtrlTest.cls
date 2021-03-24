@isTest
public class PrintPAEUCtrlTest {

    static testMethod void myUnitTest() {        
        Account acc = TestHelper.createAccount();
		Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
		opp.Trade_Term__c  = 'EXW';
        opp.Probability = 0.75;
        opp.StageName = 'PO Imminent';
        opp.RecordTypeId = '0126F000001MHOK';
		INSERT opp;
		
		Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.id;

        insert con;
    
         
        PrintPAEUCtrl pdf = new PrintPAEUCtrl(new ApexPages.StandardController(con));
        pdf.format = 'Pdf';
        List<SelectOption> formatList = pdf.getFormatItems();
        pdf.doBack();
        pdf.doGenerate();
       PrintPAEUCtrl pdf1 = new PrintPAEUCtrl(new ApexPages.StandardController(con));
        pdf1.format = 'Excel';
        List<SelectOption> formatLists = pdf1.getFormatItems();
        pdf1.doBack();
        pdf1.doGenerate();
      
    }
}