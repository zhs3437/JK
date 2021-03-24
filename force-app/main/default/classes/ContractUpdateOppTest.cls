@isTest
private class ContractUpdateOppTest {
    static testMethod void myUnitTest() {
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
        opp.stageName='PO Imminent';
        update opp;
        System.debug('走进测试类------------>');
        System.debug('opp------------>'+opp);
        System.debug('opp------------>'+opp.Id);
        RecordType re=[select id,name from RecordType where name=:'1MW Australia Contract'];
        Contract c = TestHelper.createContract(acc.Id,false);
        c.Legal_Dept__c = 'Approved';
        c.BMO_Dept__c = 'Approved' ;
        c.CMO_Dept__c = 'Approved';
        c.RecordTypeId = re.id;
        c.Contract_NO__c ='222';
        c.Opportunity__c = opp.Id;
        c.Region__c='EU(Union)';
        insert c;
        //ContractUpdateOpp aaa = new ContractUpdateOpp();
        ContractUpdateOpp.main(c.Id);
        Individual_Teams__c it = new Individual_Teams__c();
        it.name='123';
		it.Contract__c=c.id;
		insert it;
        RecordType re2=[select id,name from RecordType where name=:'Frame Contract'];
        //c.Judicial_Confirmation_Statemen__c ='1';
        c.RecordTypeId = re2.Id;
        update c;
                
        ContractUpdateOpp.main(c.Id);
    }
}