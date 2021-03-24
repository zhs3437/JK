@isTest
private class OASync_AccountTester {

    static testMethod void myUnitTest() {

        Test.startTest();
    	Log__c l = new Log__c();
        l.Error_Message__c = 'ceshi';
        insert l;
        List<Log__c> lst = new List<Log__c>();
        lst.add(l);
        Account acc = TestHelper.createAccount(false);
        acc.Country__c = '';
        acc.Phone = '123';        
        insert acc;

        Order ord = TestHelper.createOrder(False);
        ord.Account_Title__c							= 'tital';
        ord.Account_Allocation_Group__c					= '03 关联方-国外收入';
        ord.Account_Group__c							= '03 零售商';
        ord.Account_Holder__c							= 'holder';
        //ord.Buyer__r.Country__c									= SapMap.getCountryOACode('Andorra') ;//;	//acc.Country__c;												// 客户国家
        //acc.Owner.SAP_User_ID__c						= '80003777';										// 客户所有人的SAP Id号
        ord.Distribution_channel__c						= '10 外销-集团外';									// 分销渠道
        ord.Emergency_level__c							= '正常';//'1';//acc.Emergency_level__c;										// 紧急程度
        ord.Ledger_Name__c								= 'Jinko Solar Import and Export Co., Ltd.';											// 账套名称
        //acc.Name										= '';														// 客户名
        ord.Operate_Type__c								= '新增';//'0';//acc.Operate_Type__c;											// 操作类型
        //acc.Owner.Name									= '';												// 销售员
        //ord.Phone										= '';													// 客户电话
		ord.Product_Group__c							= '20 电池片';											// 产品组
		ord.Sales_Dept__c								= '3000 采购部';											// 销售部门
		ord.Sales_Group__c								= 'EU';											// 销售组
		ord.Sales_Org__c								= '1021 晶科进出口销售组织';												// 销售组织
 		ord.Sales_Region__c								= 'EU(Union)';											// 销售地区
		ord.Search__c									= 'search';												// 搜索
 		ord.Street_Room_Number__c						= 'street';									// 街道/房号
		ord.Subject_Group__c							= 'Z001 国内客户';											// 科目组
		ord.Taxpayer_Identification_No__c				= 'no';							// 纳税人识别号
		//ord.Title__c									= 'Account Test';
        ord.SWIFT_Code__c								= '001';
        ord.Buyer__c                                    = acc.Id;
        ord.CurrencyIsoCode                             = 'USD';
    	insert ord;
        
		OASync_Account oa = new OASync_Account();
        oa.generateData(ord);
        oa.sync();
        oa.Seller = 'Jinko Solar Import and Export Co., Ltd.';
        oa.lst_log = lst;
        oa.accountCountry = 'USA';
        oa.salesGroup = 'EU';
        oa.salesRegion = 'ROA';

        Test.stopTest();
    }
}