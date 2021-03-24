/**
 *
 *create by Jason 2010706
 */
@isTest
private class AmendmentSendEmailCtrlTest {

    private static testMethod void myUnitTest() {
        User user1 = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
        User user2 = TestHelper.createUser(UserInfo.getProfileId(), 'u2@163.com', true);
        set<User > userLst = new set<User >();
        userLst.add(user1);
        userLst.add(user2);
        
        user1.Contract_Approver__c = user2.Id;
        user1.Contract_Review__c = user2.Id;
        user1.BMO_specialist__c = user2.Id;
        
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id);
		Amendment__c   am  = TestHelper.createAmendment(true);
        am.Contract_No__c = con.Contract_NO__c;
        update am;
        list<Amendment__c>  ams = new  list<Amendment__c>();
        ams.add(am);
        
        ApexPages.StandardController sc = new ApexPages.StandardController( con );
        system.debug('合同'+con + '合同sc' + sc);
        
        ApexPages.currentPage().getParameters().put('id',am.Id);
        AmendmentSendEmailCtrl ase = new AmendmentSendEmailCtrl(sc);
        system.debug('合同'+con + '合同sc' + sc + '合同ase'+ase);

        //ase.approverList = userLst;
        ase.con = con;
        ase.am = am;
        ase.approverList = new List<AmendmentSendEmailCtrl.Approver>();
        ase.approverList.add(new AmendmentSendEmailCtrl.Approver(user1.Email,user1.Username,'finance',user1.Id));
        ase.UnselectAll();
        ase.SelectAll();
        ase.sendMail();
		ase.runTest();
        
    }
}