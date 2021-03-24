public with sharing class ContractControllerUpdate {
    
    public Contract con{get;set;}
    public Opportunity op{get;set;}
    public OpportunityLineItem[] opls{get;set;} 
    
    public ContractControllerUpdate( ApexPages.Standardcontroller sd ){
        String theId = ApexPages.currentPage().getParameters().get('id');
       	con  = CvtOpps2Contract.initCon( theId );
        //con = [Select Id ,Opportunity__c From Contract Where Id =:theId limit 1];
        //con = (Contract)sd.getRecord();
        op   = CvtOpps2Contract.initOpp( con.Opportunity__c  );     
        opls = CvtOpps2Contract.initOpls( op.Id );
    }
    
    
    public PageReference onUpdate(){
    	try{
        con = CvtOpps2Contract.CpyAccInfo(op, con);
        update con;
    
        // delete the old order lines
        Product_Detail__c[] ols = [Select Id, Name From Product_Detail__c WHERE Contract_PO_PI__c =: con.Id];
        delete ols;
        //new order lines according to the new opportunity
        ols = CvtOpps2Contract.CpyOppsLineItem(opls, con);
        insert ols;
        
        //update Distribution Stock's Contract ID
        CvtOpps2Contract.updateInventory( op, con);
        //update Distribution Stock's Contract ID
        CvtOpps2Contract.updateProductionScheduled( op, con);
        //return to the order standard page
        return new ApexPages.StandardController(con).view();
    	}
	    catch(DmlException e){
	        for (Integer i = 0; i < e.getNumDml(); i++) {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
	        }
	    }
	    return null;
    }
    
    public PageReference onCancel(){
        //return to the order standard page
        return new ApexPages.StandardController(con).view();
    }
    
    public void runTest(){
        String run = 'run test';
        run = 'run test';
        
    }
	public static testMethod void onTest(){
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Opportunity__c = opp.Id;
        con.Status='Draft';
        con.Contract_NO__c='2011-JKZJXS-ZQPM-1984';
        insert con;
        /*
		system.debug('------------- prepare date ----------------');
        testPrepare testdata = new testPrepare();
		*/
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        system.debug('------------- prepare date done!----------------');
     	 // part one
     	ApexPages.currentPage().getParameters().put('id', con.Id);
     	ContractControllerUpdate upd = new ContractControllerUpdate(sc);
     	upd.onUpdate();
        upd.onCancel();
        upd.runTest();
	}

}