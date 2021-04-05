@isTest 
private class testContractTrigger {
    static PageReference pageRef;
    static ContractControllerCreate ext; 
    public static testMethod void onTest(){
        //prepare test data
        //testPrepare testdata = new testPrepare();
        //Opportunity op = testdata.o1;
        
        Account acc = new Account(Name = 'JinkoFullNamefortest',Customer_Grading__c='VIP',Sinosure_Buyer_s_Code__c='SN0000X',Cooperation_method__c='OEM',User__c=UserInfo.getUserId());
        acc.Company_Email__c = 'winhunter@qq.com';
        insert acc;
        
        Opportunity opp = new Opportunity(name='2MW-JKM180-20120101',AccountId=acc.id,
            CloseDate = Date.today(), StageName='Close Won',Probability=100,delivey_point__c='sad', Jinko_Parent_Company_Guarantee_needed__c = 'NO');
        insert opp;
        
        //new a controller for standard page
        Contract con = new Contract();
        con.Opportunity__c = opp.Id;
        RecordType rt = [Select id,name from RecordType where name=:'Inventory Contract'];
        con.RecordTypeId = rt.Id;
        //User data
        /*UserRole[] urs = [Select Id,Name From UserRole Where Name = 'VP, Finance'];
        UserRole ur;
        if(urs.size() == 0){
            ur = new UserRole(Name='VP, Finance');
            insert ur;
        }
        else{
            ur=urs[0];
        }
        User[] us = [Select Id From User Where UserRoleId=:ur.Id limit 1];
        User u;
        Profile[] prs =[Select Id From Profile Where UserType='Standard'];
        Profile prf = prs[0];
        if(us.size() == 0){
            u = new User(LastName='VPF',Email='test@jinkosolar.com',UserRoleId=ur.Id,ProfileId=prf.Id,
            Username='test@jinkosolar.com.dev', Alias='Jinko', CommunityNickname='Jinko', TimeZoneSidKey='Asia/Shanghai', LocaleSidKey='zh_CN', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
            insert u;
        }*/
        
        //init the extension controller
        
        ApexPages.StandardController sc = new ApexPages.standardController(con);
        ext = new ContractControllerCreate(sc);
        ext.con.Contract_NO__c = '2011-JKZJXS-0000-000x';
        Contract[] contrs = [Select Id,Contract_NO__c From Contract Where Opportunity__c =: opp.Id ];
        /*delete contrs;
        contrs = [Select Id,Contract_NO__c From Contract Where Opportunity__c =: op.Id ]; // new Contract[0];
        System.assertEquals(contrs.size(), 0);*/
        
        //test the onCreate function
        ext.onCreate();
        //check result
        /*contrs = [Select Id,Contract_NO__c From Contract Where Opportunity__c =: op.Id ];
        System.assertNotEquals(contrs.size(), 0);
        //System.assertEquals(contrs[0].Contract_NO__c, '2011-JKZJXS-ZQPM-1984');
        
        /*
        //test contract update
        con = contrs[0];
        con.Opportunity__c = op.Id;
        con.Approval_Status__c = 'Pending';
        update con;
        //check result
        
        // System.assertEquals(opp.Contract_Approval__c, 'Pending');
        
        con.Approval_Status__c = 'Rejected';
        update con;
        //check result
        opp = [Select Contract_Approval__c,Id From Opportunity Where Id =: con.Opportunity__c limit 1];
        //System.assertEquals(opp.Contract_Approval__c, 'Rejected');
        
        con.Approval_Status__c = 'Approved';
        update con;
        */
        /*
        Opportunity opp = [Select Contract_Approval__c,Id From Opportunity Where Id =: con.Opportunity__c limit 1];
        //check result
        opp = [Select Contract_Approval__c,Id From Opportunity Where Id =: con.Opportunity__c limit 1];
        // System.assertEquals(opp.Contract_Approval__c, 'Approved');
        
        //  Test David Code , by Javen 2013-1-25
        /*Contract test_c01 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0001', Payment_Method__c = '100% Prepayment',Trade_term__c = 'EXW Factory'  ) ;
        Contract test_c02 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0002', Payment_Method__c = '100% O/A',Trade_term__c = 'FOB Shanghai / Ningbo'  ) ;
        Contract test_c03 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0003', Payment_Method__c = 'Prepayment +O/A',Trade_term__c = 'CIP'  ) ;
        Contract test_c04 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0004', Payment_Method__c = '100%OA+ L/C',Trade_term__c = 'CIF'  ) ;
        Contract test_c05 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0005', Payment_Method__c = 'Prepayment+OA + L/C',Trade_term__c = 'DAP'  ) ;
        Contract test_c06 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0006', Payment_Method__c = '100%OA+Bank Guarantee',Trade_term__c = 'DDP'  ) ;
        Contract test_c07 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0007', Payment_Method__c = 'Prepayment + OA+Bank Guarantee',Trade_term__c = 'DAP'  ) ;
        Contract test_c08 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0008,', Payment_Method__c = '100%OA+Parent Guarantee',Trade_term__c = 'EXW Factory'  ) ;
        Contract test_c09 = new Contract( AccountId=op.AccountId ,Opportunity__c=op.Id ,Contract_NO__c = '2011-JKZJXS-130125-0009,', Payment_Method__c = 'Prepayment + OA+ Parent Guarantee',Trade_term__c = 'EXW Factory'  ) ;
        
            
        List<Contract> lstContract = new List<Contract>();
        lstContract.add(test_c01);
        lstContract.add(test_c02);
        lstContract.add(test_c03);
        lstContract.add(test_c04);
        lstContract.add(test_c05);
        lstContract.add(test_c06);
        lstContract.add(test_c07);
        lstContract.add(test_c08);
        lstContract.add(test_c09);  
        
        Test.startTest();
        Database.insert(lstContract);
        Test.stopTest();*/
            
    }
}