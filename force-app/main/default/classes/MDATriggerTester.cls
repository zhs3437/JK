@isTest
public class MDATriggerTester {
    static testMethod void myUnitTest() {
        String name = 'test' + Math.random() + '@example.org';
        Profile p = [select id from profile where name='系统管理员' or name='System Administrator'];
        User u1 = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
        User u = new User();
            u.alias = 'testuser';
            u.email=name;
            u.emailencodingkey='UTF-8';
            u.lastname='Testing';
            u.languagelocalekey='en_US';
            u.localesidkey='en_US';
            u.profileid = p.id;
            u.timezonesidkey='America/Los_Angeles';
            u.username=name;
            u.communityNickname = 'test' + Math.random();
            u.BMO_specialist__c = u1.Id;
        insert u;
        /*
        Order ord = TestHelper.createOrder(false);
        ord.Contract_Owner__c = u.Id;
        insert ord;
*/
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
        Component_Task_Book__c ctb = TestHelper.createComponentTaskBook(con,false);
        insert ctb;
        ctb.Technical_manager_Shanghai__c='Approved';
        update ctb;
    }
}