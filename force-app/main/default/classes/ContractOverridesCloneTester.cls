@isTest
private class ContractOverridesCloneTester {

    public static testMethod void testClone(){
        Account acc = TestHelper.createAccount();
        Contract c = TestHelper.createContract(acc.Id,false);
        c.Contract_NO__c = '555';
        insert c;
        
        /*
    	system.debug('------------- prepare date ----------------');
    	testPrepare test = new testPrepare();
    	system.debug( test.c1.Id +'   ddddddddddddddddddddddd' );
    	*/
    	ApexPages.currentPage().getParameters().put('id', c.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ContractOverridesClone coc = new ContractOverridesClone(sc);
        coc.cpyContract.Contract_NO__c = 'test_value';
        coc.doSave();
       
    }
}