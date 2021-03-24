/**
 * Add by Javen, 20130115, for work piece(20130115-00004) 
 */
@isTest
private class ContractInlineSectionTester {

    static testMethod void myUnitTest() {
    	/*
    	testPrepare testDat = new testPrepare();
    	Contract con = testDat.c1;
    	con.PO_Remarks_1__c = 'TestSection01';
    	con.PO_Remarks_2__c = 'TestSection02';
    	con.PO_Remarks_3__c = 'TestSection03';
    	con.PO_Remarks_4__c = 'TestSection04';
    	con.PO_Remarks_5__c = 'TestSection05';
    	con.PO_Remarks_6__c = 'TestSection06';
    	con.PO_Remarks_7__c = 'TestSection07';
    	con.PO_Remarks_8__c = null;
    	con.PO_Remarks_9__c = null;
    	con.PO_Remarks_10__c = null;
    	con.PO_Remarks_11__c = null;
    	con.PO_Remarks_12__c = null;
    	con.PO_Remarks_13__c = null;
    	
    	update con;
        */
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
    	Contract con = TestHelper.createContract(acc.Id, false);
        con.Opportunity__c = opp.Id;
        con.Status='Draft';
        con.Contract_NO__c='2011-JKZJXS-ZQPM-1984';
        con.PO_Remarks_1__c = 'TestSection01';
    	con.PO_Remarks_2__c = 'TestSection02';
    	con.PO_Remarks_3__c = 'TestSection03';
    	con.PO_Remarks_4__c = 'TestSection04';
    	con.PO_Remarks_5__c = 'TestSection05';
    	con.PO_Remarks_6__c = 'TestSection06';
    	con.PO_Remarks_7__c = 'TestSection07';
    	con.PO_Remarks_8__c = null;
    	con.PO_Remarks_9__c = null;
    	con.PO_Remarks_10__c = null;
    	con.PO_Remarks_11__c = null;
    	con.PO_Remarks_12__c = null;
    	con.PO_Remarks_13__c = null;
        //con.BillingAddress = 'q';
        con.BillingCity = 'w';
        con.BillingState = 'e';
        con.BillingStreet = 'r';
        con.BillingPostalCode = 't';
        insert con;
        
    	ApexPages.StandardController sc = new ApexPages.StandardController( con );
    	ContractInlineSection ext = new ContractInlineSection( sc );
    	// Unit Test - 001 
    	system.assertEquals( con.Id , ext.con.Id );
    	// Unit Test - 002
    	system.assertEquals( con.PO_Remarks_1__c, ext.con.PO_Remarks_1__c );
    	
    	// Unit Test - 003
    	ext.doNewLine();
    	system.assertEquals( ext.con.PO_Remarks_8__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.con.PO_Remarks_8__c , null );
    	
    	ext.con.PO_Remarks_8__c = 'TestSection08';
    	ext.doSave();
    	
    	// Unit Test - 004
    	ext.doNewLine();
    	system.assertEquals( ext.con.PO_Remarks_9__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.con.PO_Remarks_9__c , null );
    	ext.con.PO_Remarks_9__c = 'TestSection09';
    	
    	// Unit Test - 005
    	ext.doNewLine();
    	system.assertEquals( ext.con.PO_Remarks_10__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.con.PO_Remarks_10__c , null );
    	ext.con.PO_Remarks_10__c = 'TestSection10';
    	
    	// Unit Test - 006
    	ext.doNewLine();
    	system.assertEquals( ext.con.PO_Remarks_11__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.con.PO_Remarks_11__c , null );
    	ext.con.PO_Remarks_11__c = 'TestSection11';
    	
    	// Unit Test - 007
    	ext.doNewLine();
    	system.assertEquals( ext.con.PO_Remarks_12__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.con.PO_Remarks_12__c , null );
		ext.con.PO_Remarks_12__c = 'TestSection12';
		
    	// Unit Test - 008
    	ext.doNewLine();
    	system.assertEquals( ext.con.PO_Remarks_13__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.con.PO_Remarks_13__c , null );
		ext.con.PO_Remarks_13__c = 'TestSection13';
		
		// Unit Test - 009
		ext.doSave();
		
		Contract res = [SELECT ID, PO_Remarks_1__c, PO_Remarks_2__c , PO_Remarks_3__c, PO_Remarks_4__c ,
							PO_Remarks_5__c ,PO_Remarks_6__c , PO_Remarks_7__c, PO_Remarks_8__c, PO_Remarks_9__c,
					    	PO_Remarks_10__c, PO_Remarks_11__c,PO_Remarks_12__c , PO_Remarks_13__c 
					    		From Contract Where ID=:con.Id ];
    	
    	system.assertEquals( res.PO_Remarks_1__c , 'TestSection01');
    	system.assertEquals( res.PO_Remarks_2__c , 'TestSection02');
    	system.assertEquals( res.PO_Remarks_3__c , 'TestSection03');
    	system.assertEquals( res.PO_Remarks_4__c , 'TestSection04');
    	system.assertEquals( res.PO_Remarks_5__c , 'TestSection05');
    	system.assertEquals( res.PO_Remarks_6__c , 'TestSection06');
    	system.assertEquals( res.PO_Remarks_7__c , 'TestSection07');
    	system.assertEquals( res.PO_Remarks_8__c , 'TestSection08');
    	system.assertEquals( res.PO_Remarks_9__c , 'TestSection09' );
    	system.assertEquals( res.PO_Remarks_10__c , 'TestSection10');
    	system.assertEquals( res.PO_Remarks_11__c , 'TestSection11');
    	system.assertEquals( res.PO_Remarks_12__c , 'TestSection12');
    	system.assertEquals( res.PO_Remarks_13__c , 'TestSection13');
		
    }
}