/**
 *create by Jason 2010720
 */
@isTest
public class AmendmentPurchaseAgreementCtrlTester {
	public static testMethod void amendmentTest() {
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
        Amendment__c am = TestHelper.createAmendment(false);
        am.Amendment_Point__c = 'Specification of The Goods';
        am.Contract__c=con.id;
        insert am;
      	
        am.Account_Holder__c='123';
        update am;
        Information_of_Seller__c seller = new Information_of_Seller__c();
        seller.Address__c = 'Xuri Area, Shangrao Ecnomic Development Zone, Jiangxi Province';
        seller.Authorized_Signatory__c = ' ';
        seller.Title__c = ' ';
        seller.Seller__c = 'Jinko Solar Import and Export Co., Ltd.';
        insert seller;
        
        ApexPages.currentPage().getParameters().put('id',am.Id);
              
        AmendmentPurchaseAgreementCtrl apa = new AmendmentPurchaseAgreementCtrl();
        //apa.tt = apa.TodayTime.TodayTime();
        apa.tod = Date.today();
        apa.requestId = am.Id;
        apa.recordType = am.RecordTypeId;
        apa.runTest();
        
    }
}