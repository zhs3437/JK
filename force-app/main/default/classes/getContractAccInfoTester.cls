@isTest
public class getContractAccInfoTester {
	public static testMethod void Test1() {
        Order ord = TestHelper.createOrder(false);
        ord.Account_Title__c							= 'tital';
        ord.Account_Allocation_Group__c					= '03 关联方-国外收入';
        ord.Account_Group__c							= '03 零售商';
        ord.Account_Holder__c							= 'holder';
        //ord.Buyer__r.Country__c									= SapMap.getCountryOACode('Andorra') ;//;	//acc.Country__c;												// 客户国家
        //acc.Owner.SAP_User_ID__c						= '80003777';										// 客户所有人的SAP Id号
        ord.Distribution_channel__c						= '10 外销-集团外';									// 分销渠道
        ord.Emergency_level__c							= '正常';//'1';//acc.Emergency_level__c;										// 紧急程度
        ord.Ledger_Name__c								= 'JinkoSolar Canada Co., Ltd.';											// 账套名称
        //acc.Name										= '';														// 客户名
        ord.Operate_Type__c								= '新增';//'0';//acc.Operate_Type__c;											// 操作类型
        //acc.Owner.Name									= '';												// 销售员
        //ord.Phone										= '';													// 客户电话
		ord.Product_Group__c							= '20 电池片';											// 产品组
		ord.Sales_Dept__c								= '3000 采购部';											// 销售部门
		ord.Sales_Group__c								= 'ROA';											// 销售组
		ord.Sales_Org__c								= '1021 晶科进出口销售组织';												// 销售组织
 		ord.Sales_Region__c								= 'EU(Union)';											// 销售地区
		ord.Search__c									= 'search';												// 搜索
 		ord.Street_Room_Number__c						= 'street';									// 街道/房号
		ord.Subject_Group__c							= 'Z001 国内客户';											// 科目组
		ord.Taxpayer_Identification_No__c				= 'no';							// 纳税人识别号
		//ord.Title__c									= 'Account Test';
        ord.SWIFT_Code__c								= '001';
        insert ord;
        
        getContractAccInfo.submit(ord.Id);
        
    }

    public static testMethod void Test2() {
        Account acc = TestHelper.createAccount(false);
        acc.Name = 'Name1';
        acc.Account_Allocation_Group__c                 = '03 关联方-国外收入';
        acc.Account_Group__c                            = '03 零售商';
        acc.Account_Holder__c                           = 'holder';
        acc.Distribution_channel__c                     = '10 外销-集团外';                                  // 分销渠道
        acc.Emergency_level__c                          = '正常';//'1';//acc.Emergency_level__c;                                      // 紧急程度
        acc.Ledger_Name__c                              = 'JinkoSolar Canada Co., Ltd.';                                            // 账套名称
        acc.Operate_Type__c                             = '新增';//'0';//acc.Operate_Type__c;                                         // 操作类型
        acc.Product_Group__c                            = '20 电池片';                                         // 产品组
        acc.Sales_Dept__c                               = '3000 采购部';                                           // 销售部门
        acc.Sales_Group__c                              = 'ROA';                                            // 销售组
        acc.Sales_Org__c                                = '1021 晶科进出口销售组织';                                             // 销售组织
        acc.Sales_Region__c                             = 'EU(Union)';                                         // 销售地区
        acc.Search__c                                   = 'search';                                             // 搜索
        acc.Street_Room_Number__c                       = 'street';                                 // 街道/房号
        acc.Subject_Group__c                            = 'Z001 国内客户';                                          // 科目组
        acc.Taxpayer_Identification_No__c               = 'no';                         // 纳税人识别号
        acc.Title__c                                    = 'Account Test';
        acc.SWIFT_Code__c                               = '001';                                                                           // Sales Dept
        insert acc;
        
        getContractAccInfo.submitOA(acc.Id);
              
    }
}