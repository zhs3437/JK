/**
* @author huangxy
*/
@isTest
private class SyncAccCtrlTest {

    static testMethod void test_SyncAccCtrl() {
    	Account acc = TestHelper.createAccount(false);
        acc.Name = 'Name1';
		acc.SAP_External_ID__c = '1003650';                                                                 // SAP External ID
  		acc.Duplicated__c = false;                                                                            // Duplicated
  		acc.OA_UserName__c = 'sherry.ma';                                                                     // OA UserName
  		acc.Phone = '110';                                                                                    // Phone
  		acc.AccountOwner2nd__c = '0056F000006AduI';                                                           // Account Owner 2nd
  		acc.Company_Email__c = 'jdengo@celsia.com';                                                           // Company Email
  		acc.Website = 'http://na';                                                                            // Website
  		acc.Country__c = 'Colombia';                                                                          // Country
 		acc.Cooperation_method__c = 'Jinko';                                                                  // Cooperation method
 		acc.Customer_Business_Type__c = 'Utility; Independent Power Producer; Developer; Investor';           // Customer Business Type
  		acc.Account_Transfer__c = false;                                                                      // Account Transfer
  		acc.Year__c = '2016';                                                                                 // Year
  		acc.Bad_Debt__c = false;                                                                              // Bad Debt
  		acc.Blacklist__c = false;                                                                             // Blacklist
  		acc.Office_Address__c = 'Calle 15 # 29B-30 Autopista Cali - Yumbo; Colombia';                         // Office Address
  		acc.Account_Allocation_Group__c = '01 关联方-国内收入';                                                      // Account Allocation Group
  		acc.Search__c = 'Empresa de Energía del Pacífico S.A. E.S.P';                                         // Search
  		acc.Title__c = 'CRM新增客户主数据流程-sherry.ma-2017-05-05';                                                   // Title
  		acc.Ledger_Name__c = 'Jinko Solar Import and Export Co., Ltd.';                                       // Ledger Name
  		acc.Distribution_channel__c = '10 外销-集团外';                                                            // Distribution channel
  		acc.Product_Group__c = '10 硅片';                                                                       // Product Group
  		acc.Sales_Group__c = 'EU';                                                                            // Sales Group
  		acc.Sales_Region__c = 'EU(Union)';                                                                           // Sales Region
  		acc.Street_Room_Number__c = 'Colombia     Yumbo Calle 15 # 29B-30 Autopista Cali - Yumbo, Colombia';  // Street / Room Number
  		acc.Subject_Group__c = 'Z001 国内客户';                                                                   // Subject Group
  		acc.Taxpayer_Identification_No__c = '测试数据请忽略6666666';                                                 // Taxpayer Identification No
 		acc.Sales_Dept__c = '1000 业务部' ;                 															// Sales Dept
    	insert acc;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController( acc );
		SyncAccCtrl sac = new SyncAccCtrl(sc);
		sac.modeBasicData();
		sac.acc = acc;		
		sac.requestId = acc.Id;
		PageReference resultSaveMe = sac.SaveMe();
		sac.Sync();
		SyncAccCtrl.flg = false;
		SyncAccCtrl.isSave = false;
		SyncAccCtrl.isHidden = false;

        Test.stopTest();

    }
    static testMethod void test_SyncAccCtrl1() {
    	Account acc = TestHelper.createAccount(false);
        acc.Name = 'Name1';
		acc.SAP_External_ID__c = '1003650';                                                                 // SAP External ID
  		acc.Duplicated__c = false;                                                                            // Duplicated
  		acc.OA_UserName__c = 'sherry.ma';                                                                     // OA UserName
  		acc.Phone = '110';                                                                                    // Phone
  		acc.AccountOwner2nd__c = '0056F000006AduI';                                                           // Account Owner 2nd
  		acc.Company_Email__c = 'jdengo@celsia.com';                                                           // Company Email
  		acc.Website = 'http://na';                                                                            // Website
  		acc.Country__c = 'Colombia';                                                                          // Country
 		acc.Cooperation_method__c = 'Jinko';                                                                  // Cooperation method
 		acc.Customer_Business_Type__c = 'Utility; Independent Power Producer; Developer; Investor';           // Customer Business Type
  		acc.Account_Transfer__c = false;                                                                      // Account Transfer
  		acc.Year__c = '2016';                                                                                 // Year
  		acc.Bad_Debt__c = false;                                                                              // Bad Debt
  		acc.Blacklist__c = false;                                                                             // Blacklist
  		acc.Office_Address__c = 'Calle 15 # 29B-30 Autopista Cali - Yumbo; Colombia';                         // Office Address
  		acc.Account_Allocation_Group__c = '01 关联方-国内收入';                                                      // Account Allocation Group
  		acc.Search__c = 'Empresa de Energía del Pacífico S.A. E.S.P';                                         // Search
  		acc.Title__c = 'CRM新增客户主数据流程-sherry.ma-2017-05-05';                                                   // Title
  		acc.Ledger_Name__c = 'Jinko Solar Import and Export Co., Ltd.';                                       // Ledger Name
  		acc.Distribution_channel__c = '10 外销-集团外';                                                            // Distribution channel
  		acc.Product_Group__c = '10 硅片';                                                                       // Product Group
  		acc.Sales_Group__c = 'EU';                                                                            // Sales Group
  		acc.Sales_Region__c = 'EU(Union)';                                                                           // Sales Region
  		acc.Street_Room_Number__c = 'Colombia     Yumbo Calle 15 # 29B-30 Autopista Cali - Yumbo, Colombia';  // Street / Room Number
  		acc.Subject_Group__c = 'Z001 国内客户';                                                                   // Subject Group
  		acc.Taxpayer_Identification_No__c = '测试数据请忽略6666666';                                                 // Taxpayer Identification No
 		acc.Sales_Dept__c = '1000 业务部' ;                 															// Sales Dept
    	insert acc;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController( acc );
		SyncAccCtrl sac = new SyncAccCtrl(sc);
		sac.modeBasicData();
		sac.acc = acc;		
		sac.requestId = acc.Id;
		PageReference resultSaveMe = sac.SaveMe();
		sac.Sync();
		SyncAccCtrl.flg = true;
		SyncAccCtrl.isSave = false;
		SyncAccCtrl.isHidden = false;

        Test.stopTest();

    }


}