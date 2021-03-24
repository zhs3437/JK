@isTest
private class SyncAccountCtrlTester {
    
    static testMethod void syncAccountCtrl() {
        Account acc = TestHelper.createAccount();


        Product2 product = TestHelper.createProduct2();
		PricebookEntry priceBookEntry = TestHelper.createPriceBookEntry(product.Id, true);
		Order ord = TestHelper.createOrder(false);
        ord.Pricebook2Id = priceBookEntry.Pricebook2Id;
        ord.Account_Allocation_Group__c = '02 非关联方-国内收入';                                                                                                                                                                                       // Account Allocation Group
        ord.Account_Holder__c = '开户人（测试数据）';                                                                                                                                                                                                    // Account Holder
        ord.Account_Group__c = '01 集成商';                                                                                                                                                                                                        // Account Group
        ord.Bank_Account__c = '银行账户（测试数据）';                                                                                                                                                                                                     // Bank Account
        ord.Bank_Country__c = '中国（测试数据）';                                                                                                                                                                                                       // Bank Country
        ord.Bank_City__c = '银行所在城市（测试数据）';                                                                                                                                                                                                      // Bank City
        ord.Bank_Name__c = '银行名称（测试数据）';                                                                                                                                                                                                        // Bank Name
        ord.Bank_Code__c = '银行代码（测试数据）';                                                                                                                                                                                                        // Bank Code
        ord.Bank_Region__c = '银行地区（测试数据）';                                                                                                                                                                                                      // Bank Region
        ord.Distribution_channel__c = '10 外销-集团外';                                                                                                                                                                                              // Distribution channel
        ord.Bank_Street__c = '银行街道（测试数据）';                                                                                                                                                                                                      // Bank Street
        ord.Emergency_level__c = '正常';                                                                                                                                                                                                          // Emergency level
        ord.Product_Group__c = '10 硅片';                                                                                                                                                                                                         // Product Group
        ord.Ledger_Name__c = 'JinkoSolar International Limited';                                                                                                                                                                                // Ledger Name
        ord.Sales_Dept__c = '1000 业务部';                                                                                                                                                                                                         // Sales Dept
        ord.Search__c = 'Hanlog';                                                                                                                                                                                                               // Search
        ord.Sales_Group__c = 'ROA';                                                                                                                                                                                                             // Sales Group
        ord.Subject_Group__c = 'Z001 国内客户';                                                                                                                                                                                                     // Subject Group
        ord.Sales_Org__c = '1011 晶科能源销售组织';                                                                                                                                                                                                     // Sales Org
        ord.Street_Room_Number__c = 'Finland 37601   Valkeakoski Teollisuustie / PL 10';                                                                                                                                                        // Street / Room Number
        ord.Sales_Region__c = 'ROA';                                                                                                                                                                                                            // Sales Region
        ord.SWIFT_Code__c = 'SWIFT（测试数据）';                                                                                                                                                                                                      // SWIFT Code
        ord.Taxpayer_Identification_No__c = '测试数据请忽略';                                                                                                                                                                                          // Taxpayer Identification No
        ord.IBAN_Code__c = 'IBNA（测试数据）';                                                                                                                                                                                                        // IBAN Code
        ord.Routing_Number_ABA__c = 'ABA（测试数据）';                                                                                                                                                                                                // Routing Number (ABA)
        ord.BSB_Number__c = 'BSB（测试数据）';                                                                                                                                                                                                        // BSB Number
        ord.SC_No__c = 'SC（测试数据）';                                                                                                                                                                                                              // SC清算号
        ord.CC_No__c = 'cc（测试数据）';                                                                                                                                                                                                              // CC清算号
        ord.Company_Registration_No__c = '公司注册号（测试数据）';                                                                                                                                                                                         // Company Registration No.
        ord.Tax_No__c = '税号（测试数据）';                                                                                                                                                                                                             // Tax No.
        ord.Country_Scope__c = '欧盟';
        insert ord;     
        ApexPages.StandardController sc = new ApexPages.StandardController( ord );
        SyncAccountCtrl sac = new SyncAccountCtrl(sc);
        //sac.SyncAccountCtrl(controller);
        //sac.flg = true;
        SyncAccountCtrl.isSave = true;
        sac.modeBasicData();
        sac.ord= ord;
        sac.requestId = ord.Id;
        PageReference resultSaveMe = sac.SaveMe();
        sac.Sync();
        SyncAccountCtrl.flg = false;
        SyncAccountCtrl.isHidden = false;
        sac.updateAcc(acc);
        sac.SaveMe();
    }
}