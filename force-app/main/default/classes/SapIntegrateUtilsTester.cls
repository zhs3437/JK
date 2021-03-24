@isTest
public class SapIntegrateUtilsTester {
    static testMethod void sapUtils(){
        Log__c l = new Log__c();
        insert l;
        List<Log__c> logLst = new List<Log__c>();
        logLst.add(l);
        Account acc = TestHelper.createAccount(false);
        acc.Name = 'aa';
        acc.SAP_External_ID__c = null;
        insert acc;
        List<Account> accLst = new List<Account>();
        accLst.add(acc);
        
        User u = new User();
        u.Username				= 'u1'+System.now().getTime()+'@qq.com';
        u.LastName				= 'hao';
        u.Email					= 'winhunter@qq.com';
        u.Alias					= 'UHao';
        u.CommunityNickname		= 'y';
        u.TimeZoneSidKey		= 'Asia/Shanghai';
        u.LocaleSidKey			= 'en_US';
        u.EmailEncodingKey		= 'ISO-8859-1';
        u.ProfileId				= UserInfo.getProfileId();
        u.LanguageLocaleKey		= 'en_US';
        insert u;
        
        List<User> uLst = new List<User>();
        uLst.add(u);
        
        Contract con = TestHelper.createContract(acc.Id);
        List<Contract> conLst = new List<Contract>();
        conLst.add(con);
        /*
        sapAccount.TABLE_OF_ZKNB1 TABLE_OF_ZKNB1 = new sapAccount.TABLE_OF_ZKNB1();
        sapAccount.TABLE_OF_ZKNVV TABLE_OF_ZKNVV = new sapAccount.TABLE_OF_ZKNVV();
        sapAccount.TABLE_OF_ZSCRM001_1 TABLE_OF_ZSCRM001_1 = new sapAccount.TABLE_OF_ZSCRM001_1();
        //sapAccount.ZCRMSDD_CREAT_CUSTOMER ZCRMSDD_CREAT_CUSTOMER = new sapAccount.ZCRMSDD_CREAT_CUSTOMER();
        sapAccount.ZCRMSDD_CREAT_CUSTOMER_element ZCRMSDD_CREAT_CUSTOMER_element = new sapAccount.ZCRMSDD_CREAT_CUSTOMER_element();
        sapAccount.ZCRMSDD_CREAT_CUSTOMERResponse_element ZCRMSDD_CREAT_CUSTOMERResponse_element= new sapAccount.ZCRMSDD_CREAT_CUSTOMERResponse_element();
        sapAccount.ZKNB1 ZKNB1= new sapAccount.ZKNB1();
        sapAccount.ZKNVV ZKNVV = new sapAccount.ZKNVV();
        sapAccount.ZSCRM001 ZSCRM001 = new sapAccount.ZSCRM001();
        sapAccount.ZSCRM001_1 ZSCRM001_1 = new sapAccount.ZSCRM001_1();
        
        sapAccount.ZCRMSDD_CREAT_CUSTOMER mode = new sapAccount.ZCRMSDD_CREAT_CUSTOMER();
        */
        SapIntegrateUtils siu = new SapIntegrateUtils();
        siu.generateData();
        siu.SynAccount();
        siu.SynContract();
    }
}