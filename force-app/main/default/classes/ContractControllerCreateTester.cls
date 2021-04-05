@isTest
public class ContractControllerCreateTester {
    private static testMethod void contractCreate(){
        Account acc = TestHelper.createAccount();  
        Opportunity o2 = new Opportunity();
        o2.name							= '2MW-JKM190-20130101';
        o2.AccountId					= acc.id;
        o2.Credit_Control_Approval__c	= true;
        o2.Price_Approval__c			= true; 
        o2.Green_Channel_Approval__c	= false;
        o2.CloseDate 					= Date.today(); 
        o2.StageName					= 'Close Won';
        o2.Probability					= 100;
        o2.delivey_point__c				= '231';
        o2.Jinko_Parent_Company_Guarantee_needed__c = 'NO';
        insert o2;
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c 					= 'CIF';
        //opp.Total_MW__c					= 0.1;
        opp.Payment_1MW_Approve__c 			= true;
       // opp.delivey_point__c				= 'sad';
        insert opp;
        
		RecordType rtt = [select r.Name, r.Id From RecordType r Where r.Name ='Intercompany Contract'];  
        Contract c1 = TestHelper.createContract(acc.Id, false);
        //c1.Sales_Region__c = 'Middle East&Africa';
        c1.AccountId		= acc.Id;
        c1.Opportunity__c	= o2.Id;
        c1.Status			= 'Draft';
        c1.Contract_NO__c	= '2011-JKZJXS-ZQPM-1984';
        c1.RecordTypeId		= rtt.Id;
        insert c1;
        
        system.debug('------------- prepare date done!----------------');
         // part one
        ApexPages.currentPage().getParameters().put('id', o2.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(c1);
        ContractControllerCreate crt = new ContractControllerCreate(sc);
        crt.onCreate();
        crt.runTest();
    }
}