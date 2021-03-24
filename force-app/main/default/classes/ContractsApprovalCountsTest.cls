@isTest
public class ContractsApprovalCountsTest {
    static testMethod void myTest(){
         Product2 p          = TestHelper.createProduct2();
        PricebookEntry pbe  = TestHelper.createPricebookEntry(p.id);
        Account acc         = TestHelper.createAccount();
        	    Contract con        = TestHelper.createContract(acc.Id,false);
        con.ApprovalCounts__c = 0;con.Trade_Term__c='2';con.Destination_Country__c='a';
        con.Seller__c='b';con.Commision__c=20;con.Expect_Price_and_Comments__c='20';con.DocumentID__c='212';
        insert con;
        
        
        List<Product_Detail__c> ConlineLst = new List<Product_Detail__c>();
        Product_Detail__c a = new Product_Detail__c();
        a.Contract_PO_PI__c=con.Id;a.Total_Price__c=2;
        a.Quantity__c=2;a.UnitPrice__c=2;a.Junction_Box_Type__c='NS-Non smart module';
        a.Battery_Type__c='Normal Cell';a.Bus_bars_of_cell__c='2-2BB';
        a.Certification__c='0-NO';a.Grade__c='A-Grade A';
        a.Special_required__c='0-commonly';a.Guaranteed_Delivery_Date__c = Date.today();
        ConlineLst.add(a);
        insert a;
        List<Payment__c> payLst = new List<Payment__c>();
        Payment__c b = new Payment__c();
        b.Contract__c=con.Id;b.Percentage__c=0.2;b.Down_Balance_Payment__c='Down Payment';b.Payment_Method__c='T/T';b.Days__c=2;b.Payment_Term__c='after PO date';
        insert b;
        Folder f = [select id from Folder limit 1];
        string tempFolderId = f.id;
        ContractsApprovalCounts OppAC = new ContractsApprovalCounts();
        ContractsApprovalCounts.ClickPriceApproval(con.Id);
        Product_Detail__c prodtail = TestHelper.createProductDetail(false);
		prodtail.Contract_PO_PI__c = con.Id;
		insert prodtail;
        List<Payment__c> payLst1 = new List<Payment__c>();
        Payment__c b1 = new Payment__c();
        b1.Contract__c=con.Id;b1.Percentage__c=0.2;b1.Down_Balance_Payment__c='Down Payment';b1.Payment_Method__c='T/T';b1.Days__c=2;b1.Payment_Term__c='after PO date';
        insert b1;
        ContractsApprovalCounts.ClickPriceApproval(con.Id);
        b.Contract__c=null;
        update b;
         ContractsApprovalCounts.ClickPriceApproval(con.Id);
        //a.Contract_PO_PI__c=null;
        //update a;
        update ConlineLst;
                 ContractsApprovalCounts.ClickPriceApproval(con.Id);
    }
}