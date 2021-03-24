/**
* @author Jason
*/
@isTest
private class OASync_AccTest {

    static testMethod void test_all() {

        Test.startTest();
        Log__c l = new Log__c();
        l.Error_Message__c = 'ceshi';
        insert l;
        List<Log__c> lst = new List<Log__c>();
        lst.add(l);
		
		OASync_Acc oASync_Acc = new OASync_Acc();

		Account acc = TestHelper.createAccount(false);
        acc.Name = 'Name1';
        acc.SAP_External_ID__c = '1003650';                                                                 // SAP External ID
        acc.OA_UserName__c = 'sherry.ma';                                                                     // OA UserName
        acc.Phone = '110';                                                                                    // Phone
        acc.Country__c = '';                                                                          // Country
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
        acc.Sales_Dept__c = '1000 业务部' ;                                                                            // Sales Dept
        acc.Account_Group__c = '03 零售商';
        acc.Account_Holder__c  = 'holder';
        acc.CurrencyIsoCode= 'USD';
        acc.Sales_Org__c                                = '1021 晶科进出口销售组织';                                             // 销售组织
        acc.SWIFT_Code__c                               = '001';
        insert acc;
        
		//  test generateData
		oASync_Acc.generateData(acc);

		//  test sync
		oASync_Acc.sync();
        oASync_Acc.Seller = 'Jinko Solar Import and Export Co., Ltd.';
        oASync_Acc.lst_log = lst;
        oASync_Acc.accountCountry = 'USA';
        oASync_Acc.salesGroup = 'EU';
        oASync_Acc.salesRegion = 'ROA';

        Test.stopTest();

    }


}