@isTest
private class UtilsTest {

    static testMethod void myUnitTest() {
    	
    	Profile profile = [SELECT ID FROM Profile WHERE Name='System Administrator' limit 1];
    	User u = TestHelper.createUser(profile.Id, '10002@126.com', true);
    	List<User> recipients = new List<User>();
    	recipients.add(u);
    	
    	Account acc = TestHelper.createAccount();
    	Opportunity opp = TestHelper.createOpportunity(acc.Id);
    	
        Set<String> ignore = new Set<String>();
        ignore.add('Name');
        
        List<Set<String>> childIgnores = new List<Set<String>>();
        childIgnores.add(ignore);
        
        String []subobject = new String[1];
        subobject[0] = 'Name';
        String []reSubName = new String[1];
        reSubName[0] = 'Name';
        
        Utils.sendEmailWithTemplate(recipients,opp.Id ,'');
        Utils.MakeSelectSql('Account');
        Utils.MakeSelectSql('Account','test');
        Utils.MakeSelectSqlWithRename('Account','',ignore);
        Utils.MakeSelectSqlWithSubobject('Account' ,subobject , reSubName , ignore , childIgnores );
        Utils.GetObjByID('Account',acc.Id);
        Utils.makeUrlStr('http://www.10086.com');
        Utils.putPageParam(new PageReference('/'),'id',acc.Id);
        Utils.getPageParam('id');
    }
}