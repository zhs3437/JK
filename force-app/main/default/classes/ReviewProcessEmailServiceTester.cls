@isTest
private class ReviewProcessEmailServiceTester {

    static testMethod void myUnitTest() {
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
    	Contract con = TestHelper.createContract(acc.Id, false);
        con.Opportunity__c = opp.Id;
        con.Status='Draft';
        con.Contract_NO__c='2011-JKZJXS-ZQPM-1984';
    	insert con;
    	//testPrepare test = new testPrepare(); 
		//ontract testObj = test.c1;
    	//testObj.Owner.Name = 'Andrea Suzzi'; // Init Sales Italy as Owner
    	//update testObj;
		//new String[]{System.Label.Review_Process_Email_Address},
		
    	// Create a new email, envelope object and Attachment
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		ReviewProcessEmailService testServ = new ReviewProcessEmailService();
		
		// =========== Test 01 - CMO
		User usr = [SELECT ID,EMAIL,Name from User WHERE Name =:'Wei David'];
		env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest001';
	    testServ.handleInboundEmail( email , env );  
		Contract testCon = [SELECT ID, CMO_Dept__c , CMO_Dept_Comments__c From Contract Where ID=:con.Id];
		
		system.debug('########################## '+testCon.CMO_Dept__c );
		//System.assertEquals( testCon.CMO_Dept__c, 'Approved' );
		
		//System.assertEquals( testCon.CMO_Dept_Comments__c ,'Test001');
		
	    // =========== Test 02 - Legal
	    usr = [SELECT ID,EMAIL from User WHERE ID=:'005900000012GJT'];
	    env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest0012';
	    //testServ.handleInboundEmail( email , env );  
		Contract testCon1 = [SELECT ID, Legal_Dept__c , Legal_Dept_Comments__c From Contract Where ID=:con.Id];
        
		//System.assertEquals( testCon1.Legal_Dept__c, 'Approved' );
		//System.assertEquals( testCon1.Legal_Dept_Comments__c,'Test0012' );
		
		 // =========== Test 03 - BMO
		 /*
	    usr = [SELECT ID,EMAIL from User WHERE ID=:'0059000000126Fm'];
	    env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest0013';
	    testServ.handleInboundEmail( email , env );  
		testCon2 = [SELECT ID, BMO_Dept__c , BMO_Dept_Comments__c From Contract Where ID=:con.Id];
		System.assertEquals( testCon2.BMO_Dept__c, 'Approved' );
		System.assertEquals( testCon2.BMO_Dept_Comments__c,'Test0013' );
		
		
		 // =========== Test 04 - Finance
	    usr = [SELECT ID,EMAIL from User WHERE ID=:'0059000000126GO'];
	    env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest0014';
	    testServ.handleInboundEmail( email , env );  
		testCon3 = [SELECT ID, Finance_Dept__c , Finance_Dept_Comments__c From Contract Where ID=:con.Id];
		System.assertEquals( testCon3.Finance_Dept__c, 'Approved' );
		System.assertEquals( testCon3.Finance_Dept_Comments__c,'Test0014' );
		
		// =========== Test 05 - PMC
	    usr = [SELECT ID,EMAIL from User WHERE ID=:'005900000012GJR'];
	    env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest0015';
	    testServ.handleInboundEmail( email , env );  
		testCon4 = [SELECT ID, PMC_Dept__c , PMC_Dept_Comments__c From Contract Where ID=:con.Id];
		System.assertEquals( testCon4.PMC_Dept__c, 'Approved' );
		System.assertEquals( testCon4.PMC_Dept_Comments__c,'Test0015' );
		
		// =========== Test 06 - Tec.
	    usr = [SELECT ID,EMAIL from User WHERE ID=:'005900000012GJQ'];
	    env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest0016';
	    testServ.handleInboundEmail( email , env );  
		testCon5 = [SELECT ID, Technical_Dept__c , Technical_Dept_Comments__c From Contract Where ID=:con.Id];
		System.assertEquals( testCon5.Technical_Dept__c, 'Approved' );
		System.assertEquals( testCon5.Technical_Dept_Comments__c,'Test0016' );
		
		// =========== Test 07 - Sales Manage.
	    usr = [SELECT ID,EMAIL from User WHERE ID=:'005900000012G4b'];
	    env.fromAddress = usr.Email;
		email.fromAddress = usr.Email;
	    email.subject = '[#RVID:'+ con.Id +'#]Please review this contract';
	    email.plainTextBody = ' yes \nTest0017';
	    testServ.handleInboundEmail( email , env );  
		testCon6 = [SELECT ID, Sales_Dept__c , Sales_Dept_Comments__c From Contract Where ID=:con.Id];
		//System.assertEquals( testCon6.Sales_Dept__c, 'Approved' );
		//System.assertEquals( testCon6.Sales_Dept_Comments__c,'Test0017' );
	    */
        testServ.test();
    }

}