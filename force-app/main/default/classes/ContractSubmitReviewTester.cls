@isTest
private class ContractSubmitReviewTester {

    static testMethod void myUnitTest() {
        /*
        testPrepare test = new testPrepare();
        test.user1.Contract_Approver__c = test.user1.Id;
        test.user1.Contract_Review__c = test.user1.Id;
        test.user1.BMO_specialist__c = test.user1.Id;
        test.c1.Status = 'activated';
        test.c1.OwnerId = test.user1.Id;
        */
        User user1 = new User();
        user1.Username = 'u1'+System.now().getTime()+'@qq.com';
        user1.Email = 'winhunter@qq.com';
        user1.FirstName = 'javen';
        user1.LastName = 'hao';
        user1.Alias = 'UHao';
        user1.ProfileId = UserInfo.getProfileId();
        user1.TimeZoneSidKey='Asia/Shanghai';
        user1.LocaleSidKey='en_US';
        user1.EmailEncodingKey='ISO-8859-1';
        user1.LanguageLocaleKey='en_US';
        user1.Contract_Approver__c = user1.Id;
        user1.Contract_Review__c = user1.Id;
        user1.BMO_specialist__c = user1.Id;
        insert user1;
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract c = TestHelper.createContract(acc.Id,false);
        c.Contract_NO__c ='222';
        c.Opportunity__c = opp.Id;
        c.Region__c='South Asia';
        insert c;
        ApexPages.StandardController sc = new ApexPages.StandardController( c );
        ContractSubmitReview csr = new ContractSubmitReview( sc );
        csr.UnselectAll();
        csr.SelectAll();
        csr.approverList = new List<ContractSubmitReview.Approver>();
        //system.assertEquals(11,csr.approverList.size());
        
        csr.sendMail();
       csr.test();
    }
}