@isTest
public class CommonUtilsTester {
    public static testMethod void onTestSendMail(){
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
        //user1.Contract_Approver__c = user1.Id;
        //user1.Contract_Review__c = user1.Id;
        //user1.BMO_specialist__c = user1.Id;
        insert user1;
		
        List<User> users = new List<User>();
        users.add(user1);
        
        Account acc = TestHelper.createAccount(false);
        acc.Name = 'JinkoFullNamefortest';
        acc.Customer_Grading__c='VIP';
        acc.Sinosure_Buyer_s_Code__c='SN0000X';
        acc.Cooperation_method__c='OEM';
        acc.User__c=UserInfo.getUserId();
        acc.Company_Email__c = 'winhunter@qq.com';
        //acc.BillingAddress = 'qwer';
        //acc.BillingGeocodeAccuracy = 't';
        acc.BillingLatitude = 1;
        acc.BillingLongitude = 2;
        acc.BillingCity	= 'q';
        acc.BillingPostalCode = 'w';
        acc.BillingState = 'e';
        acc.BillingStreet = 'r';
        insert acc;
        
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
    	Contract con = TestHelper.createContract(acc.Id, false);
        con.Opportunity__c = opp.Id;
        con.Status='Draft';
        con.Contract_NO__c='2011-JKZJXS-ZQPM-1984';
        insert con;
        
		//testPrepare testdata = new testPrepare('mini prepare');
		CommonUtils.SendReviewMail(new List<string>{'winhunter@qq.com'},con.Id);
		
		// test  sendMailForGradingAccount	
        List<Account> accs = new List<Account>();
        accs.add(acc);
        //Account[] accs = new Account[]{testdata.acc};
        CommonUtils.sendMailForGradingAccount( accs );
        
        CommonUtils.SendBasicMail(new String[]{'hao.javen@gmail.com'}, 'TEST_SUBJECT', 'TEST_BODY', null);
        //CommonUtils.sendEmailWithTemplate(users, con.Id, 'TEST_SUBJECT');
        CommonUtils.SendAmendmentReviewMail(new String[]{'hao.javen@gmail.com'}, con.Id);
	
		Account a = (Account)CommonUtils.GetObjByID('Account',acc.id);
		System.assertEquals(acc.id,a.id);	
        CommonUtils m =new CommonUtils();
        m.runTest();
	}

	
	public static testMethod void onTest(){
		System.assert( CommonUtils.MakeSelectSql('Account').startsWith('select'));
		try{
			CommonUtils.MakeSelectSql('NotExistObject');
			System.assert(false);
		}catch(CommonUtils.MakeSqlException ex){
			System.assert(true);
		}
        
	}

}