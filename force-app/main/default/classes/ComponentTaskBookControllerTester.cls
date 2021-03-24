/**
 * 
 * create by fanzr 20161228
 * 
 */
@isTest()
public class ComponentTaskBookControllerTester {
    public static testMethod void componentTest(){
        User u = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
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

        ApexPages.currentPage().getParameters().put('id',ctb.Id);
        ComponentTaskBookController  ctbc = new ComponentTaskBookController(); 
        ctbc.tod =Date.today();
        ctbc.approveDate=Date.today();
        ctbc.containsOther=ctb.Additional_Certificate__c.replace('IEC62716(Ammonia)','') + ctb.Additional_Certificate_Text__c;
        ctbc.requestId = ctb.Id;
        ctbc.runTest();
   }

}