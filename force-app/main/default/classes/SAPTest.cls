@isTest
private class SAPTest {
	
	@IsTest(SeeAllData=true)
    static void TestSAPIntegration() {
    	
        //SapIntegrateUtils utils = new SapIntegrateUtils();
        //utils.SYN();
        SapIntegrationRunner.Run();
        
        SapMap.getAreaCode('Canada');
        SapMap.getCountryCode('Afghanistan');
        SapMap.getSalesGroup('Italy');
        System.debug('********* '+ SapMap.getEU('null'));
        
        sapAccount3 sapacc = new sapAccount3();
        sapacc.runTest();
        sapContract1008 sapcon = new sapContract1008();
        sapcon.runTest();
        sapCredit cred = new sapCredit();
        cred.runTest();
        
        sapContractLastest scl = new sapContractLastest();
        scl.runTest();
        sapAccountLastest  sal = new sapAccountLastest();
        sal.runTest();
        
        /*
        Account acc = [SELECT ID,Name FROM Account limit 1];
        SapCreditVFCtrl vf = new SapCreditVFCtrl(new ApexPages.StandardController(acc));*/
        SapCreditVFCtrl.runTest();
        SapCreditOptionalCtrl.runTest();
        
        SapTestPageCtrl stpc = new SapTestPageCtrl();
        stpc.doTest();
        
        SapWebserviceUtils.runTest();
        
        ContractProductDetailBasicInfoCtrl pdb = new ContractProductDetailBasicInfoCtrl();
        pdb.runTest();
        ExecuteProductionScheduleDetailsInsert epsd = new ExecuteProductionScheduleDetailsInsert();
        epsd.runTest();
    }
    
}