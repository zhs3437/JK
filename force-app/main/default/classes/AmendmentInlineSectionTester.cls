/**
 *create by jason 2060524
 *
 */
@isTest
private class AmendmentInlineSectionTester {
    static testMethod void myUnitTest() {
    	Account acc = TestHelper.createAccount();
    	Order ord = new Order();
    	//ord.Contact_Name__c = 'zhangsan';
    	ord.AccountId = acc.Id;
    	ord.EffectiveDate = Date.today(); 
    	ord.Status = 'Draft';
    	insert ord;
		Amendment__c sa = new Amendment__c();
		sa.Order__c = ord.Id;
		sa.Amendment1__c = 'TestSection01';
		sa.Amendment2__c = 'TestSection02';
		sa.Amendment3__c = null;
		sa.Amendment4__c = null;
		sa.Amendment5__c = null;
		sa.Amendment6__c = null;
		sa.Amendment7__c = null;
    	insert sa;
    	
    	ApexPages.StandardController asa = new ApexPages.StandardController( sa );
    	AmendmentInlineSection ext = new AmendmentInlineSection( asa );
    	
    	system.assertEquals( sa.Amendment1__c, ext.sa.Amendment1__c );
    	
    	// Unit Test - 003
    	ext.doNewLine();
    	system.assertEquals( ext.sa.Amendment3__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.sa.Amendment3__c , null );
    	
    	ext.sa.Amendment3__c = 'TestSection03';
    	ext.doSave();
    	
    	// Unit Test - 004
    	ext.doNewLine();
    	system.assertEquals( ext.sa.Amendment4__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.sa.Amendment4__c , null );
    	ext.sa.Amendment4__c = 'TestSection04';
    	
    	// Unit Test - 005
    	ext.doNewLine();
    	system.assertEquals( ext.sa.Amendment5__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.sa.Amendment5__c , null );
    	ext.sa.Amendment5__c = 'TestSection05';
    	
    	// Unit Test - 006
    	ext.doNewLine();
    	system.assertEquals( ext.sa.Amendment6__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.sa.Amendment6__c , null );
    	ext.sa.Amendment6__c = 'TestSection06';
    	
    	// Unit Test - 007
    	ext.doNewLine();
    	system.assertEquals( ext.sa.Amendment7__c , ext.replaceText );
    	
    	ext.doDelLine();
    	system.assertEquals( ext.sa.Amendment7__c , null );
		ext.sa.Amendment7__c = 'TestSection07';
    	
    }
}