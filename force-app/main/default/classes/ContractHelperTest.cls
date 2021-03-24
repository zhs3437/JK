@isTest
public class ContractHelperTest {
	
	//日本快速流程 Frame
    private static testMethod void getContractRecordTypeIdJapanMWFrame(){        
        List<Payment__c> payments = new List<Payment__c>();
        //ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        opp.Customer_Type__c = 'Frame';
        opp.Payment_Term_Description__c = 'L/C';
        opp.Trade_Term__c = 'CIF';
        opp.Allow_new_process_for_Japan_picklist__c = 'allow';
        opp.Special_Terms__c = '';
        opp.Payment_1MW_Approve__c = true;
        opp.SELLER__c = 'ジンコソーラージャパン株式会社';
        insert opp;
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 2000;
        item.Total_Power_W__c = 800;
        insert item;
        opp = [select id,Region__c,Price_Approval_Status__c,Destination_Country__c,whether_pick_up_batch__c,Sales_manager_approval__c,RecordTypeId,RecordType.Name,Total_Quantity__c,Total_MW__c,Special_Terms__c,Allow_new_process_for_Japan_picklist__c,Payment_1MW_Approve__c,Customer_Type__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
		system.debug('~~~~'+opp.Customer_Type__c+opp.Allow_new_process_for_Japan_picklist__c+opp.Payment_Term_Description__c+ opp.Total_Quantity__c+opp.SELLER__c+opp.Trade_term__c);
        //System.assertEquals(Japan1MWRecordTypeId, rtId);
        
    }
    private static testMethod void refreshRecord(){          
        Account acc = TestHelper.createAccount();
        Contract con = Testhelper.createContract(acc.Id);
        ContractHelper.refreshRecord(con);
    }
    private static testMethod void contractChanged(){          
        Account acc = TestHelper.createAccount();
        Contract con1 = Testhelper.createContract(acc.Id);
        Contract con2 = Testhelper.createContract(acc.Id);
        ContractHelper.contractChanged(con1, con2);
        ContractHelper.contractChanged2(con1, con2);
        ContractHelper.contractChangedRemarks(con1);
        ContractHelper.contractChangedRemarks2(con1);
    }
    
    
    private static testMethod void refreshDateRecordTypeId(){          
        List<Payment__c> payments = new List<Payment__c>();
        //ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        opp.Customer_Type__c = 'Frame';
        opp.Payment_Term_Description__c = 'L/C';
        opp.Trade_Term__c = 'CIF';
        opp.Allow_new_process_for_Japan_picklist__c = 'allow';
        opp.Special_Terms__c = '';
        opp.Payment_1MW_Approve__c = true;
        opp.SELLER__c = 'ジンコソーラージャパン株式会社';
        insert opp;
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 2000;
        item.Total_Power_W__c = 800;
        insert item;
        opp = [select id,Region__c,Destination_Country__c,Price_Approval_Status__c,whether_pick_up_batch__c,Sales_manager_approval__c,RecordTypeId,RecordType.Name,Total_Quantity__c,Total_MW__c,Special_Terms__c,Allow_new_process_for_Japan_picklist__c,Payment_1MW_Approve__c,Customer_Type__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.refreshDateRecordTypeId(opp);
    }
/*
    private static testMethod void getContractRecordTypeIdJapanTest(){        
        List<Payment__c> payments = new List<Payment__c>();
        ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Australia Standard Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		//Japan Standard Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is Jinko Standard Japan
        opp.Customer_Type__c = 'Frame';
        opp.Payment_Term_Description__c ='T/T';
        opp.Allow_new_process_for_Japan_picklist__c = 'allow';
        
        //贸易方式DDP or EXW
        opp.Trade_Term__c = 'DDP';
        //买方 是日本公司名
        opp.Seller__c = 'ジンコソーラージャパン株式会社';
        
        insert opp;
        //数量小于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id);
        opp = [select id,Total_Quantity__c,Total_MW__c,Allow_new_process_for_Japan_picklist__c,Customer_Type__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
		system.debug('~~~~'+opp.Customer_Type__c+opp.Allow_new_process_for_Japan_picklist__c+opp.Payment_Term_Description__c+ opp.Total_Quantity__c+opp.SELLER__c+opp.Trade_term__c);
        System.assertEquals(JapanRecordTypeId, rtId);
        
    }
*/
/*
    private static testMethod void getContractRecordTypeIdJapan1Test(){        
        List<Payment__c> payments = new List<Payment__c>();
        ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Australia Standard Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		//Japan Standard Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is Jinko Standard Japan
        opp.Customer_Type__c = 'Jinko Standard Japan';
        opp.Payment_Term_Description__c ='T/T';
        //opp.Allow_new_process_for_Japan_picklist__c = 'allow';
        
        //贸易方式DDP or EXW
        opp.Trade_Term__c = 'DDP';
        //买方 是日本公司名
        opp.Seller__c = 'ジンコソーラージャパン株式会社';
        
        insert opp;
        //数量小于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id);
        opp = [select id,Total_Quantity__c,Total_MW__c,Allow_new_process_for_Japan_picklist__c,Customer_Type__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
		system.debug('~~~~'+opp.Customer_Type__c+opp.Allow_new_process_for_Japan_picklist__c+opp.Payment_Term_Description__c+ opp.Total_Quantity__c+opp.SELLER__c+opp.Trade_term__c);
        System.assertEquals(JapanRecordTypeId, rtId);
        
    }
 */   
    private static testMethod void getContractRecordTypeIdTest(){        
        List<Payment__c> payments = new List<Payment__c>();
        //ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		// Japan Standard Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is Australia Standard Contract
        opp.Payment_Term_Description__c ='T/T';
        opp.Destination_Country__c = 'Australia';
        //贸易方式DDP or EXW
        opp.Trade_Term__c = 'DDP';
        //买方 是澳大利亚公司名
        opp.Seller__c = 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';
        opp.whether_pick_up_batch__c = 'True';
        insert opp;
        //数量小于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id);
        opp = [select id,Region__c,Payment_1MW_Approve__c,Destination_Country__c,Special_Terms__c,RecordTypeId,RecordType.Name,Total_MW__c,Total_Quantity__c,Allow_new_process_for_Japan_picklist__c,Customer_Type__c,whether_pick_up_batch__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
        //System.assertEquals(AustraliaRecordTypeId, rtId);
    }
    private static testMethod void getContractRecordTypeId1Test(){        
        List<Payment__c> payments = new List<Payment__c>();
        //ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		// Japan Standard Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is Australia Standard Contract
        opp.Payment_Term_Description__c ='T/T';
        //贸易方式DDP or EXW
        opp.Trade_Term__c = 'EXW';
        //买方 是澳大利亚公司名
        opp.Seller__c = 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';
        insert opp;
        //数量小于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id);
        opp = [select id,Region__c,Payment_1MW_Approve__c,Destination_Country__c,Special_Terms__c,RecordTypeId,RecordType.Name,Total_MW__c,Total_Quantity__c,Allow_new_process_for_Japan_picklist__c,Customer_Type__c,whether_pick_up_batch__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
        //System.assertEquals(AustraliaRecordTypeId, rtId);
    }
    private static testMethod void getContractRecordTypeId1MWJapanTest(){        
        List<Payment__c> payments = new List<Payment__c>();
        //ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		// Japan Standard Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is Australia Standard Contract
        opp.Customer_Type__c = 'Jinko Standard Japan';
        opp.Payment_1MW_Approve__c = true;
        opp.Allow_new_process_for_Japan_picklist__c = 'allow';
        //贸易方式DDP or EXW
        opp.Trade_Term__c = 'CIF';
        opp.Payment_Term_Description__c = 'L/C';
        //买方 是澳大利亚公司名
        opp.Seller__c = 'Jinko Solar Co., Ltd.';
        insert opp;
        //数量小于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 3000;
        item.Total_Power_W__c = 800;
        insert item;
        opp = [select id,Region__c,Destination_Country__c,RecordType.Name,Total_Quantity__c,Allow_new_process_for_Japan_picklist__c,Price_Approval_Status__c,Sales_manager_approval__c,RecordTypeId,Special_Terms__c,Total_MW__c,Payment_1MW_Approve__c,Customer_Type__c,whether_pick_up_batch__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
        System.debug('日本1MW'+opp.Payment_1MW_Approve__c);
        System.debug('日本1MW'+opp.Total_MW__c);
        System.debug('日本1MW'+opp.Customer_Type__c);
        System.debug('日本1MW'+opp.Allow_new_process_for_Japan_picklist__c);
        System.debug('日本1MW'+opp.Payment_Term_Description__c);
        System.debug('日本1MW'+ opp.Total_Quantity__c);
        System.debug('日本1MW'+opp.SELLER__c);
        System.debug('日本1MW'+opp.Trade_term__c);

        //System.assertEquals(Japan1MWRecordTypeId, rtId);
    }
    private static testMethod void getContractRecordTypeId1MWAustraliaTest(){        
        List<Payment__c> payments = new List<Payment__c>();
       // ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		// Australia 1MW Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is Australia Standard Contract
        opp.Payment_1MW_Approve__c = true;
        opp.RecordTypeId = '0126F000001BRq2';
        opp.Destination_Country__c = 'Australia';
        opp.Trade_Term__c = 'CIF';
        opp.Payment_Term_Description__c = 'L/C';
        insert opp;
        //数量大于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 3000;
        item.Total_Power_W__c = 800;
        insert item;
        opp = [select id,Region__c,Destination_Country__c,Total_Quantity__c,RecordType.Name,Allow_new_process_for_Japan_picklist__c,Price_Approval_Status__c,Sales_manager_approval__c,RecordTypeId,Special_Terms__c,Total_MW__c,Payment_1MW_Approve__c,Customer_Type__c,whether_pick_up_batch__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
        System.debug('澳大利亚1MW'+opp.Payment_1MW_Approve__c);
        System.debug('澳大利亚1MW'+opp.Total_MW__c);
        System.debug('澳大利亚1MW'+opp.RecordType.name);
        System.debug('澳大利亚1MW'+opp.Payment_Term_Description__c);
        System.debug('澳大利亚1MW'+ opp.Total_Quantity__c);
        System.debug('澳大利亚1MW'+opp.Trade_term__c);

        //System.assertEquals(Standard1MWRecordTypeId, rtId);
    }
    /*
    private static testMethod void getContractRecordTypeId1MWAustraliaTest1(){        
        List<Payment__c> payments = new List<Payment__c>();
        //ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		// Australia 1MW Contract        
        Account acc1 = TestHelper.createAccount();
        Opportunity opp1 = TestHelper.createOpportunity(acc1.Id, false);
        //Customer Type is Australia Standard Contract
        opp1.Payment_1MW_Approve__c = true;
        opp1.RecordTypeId = '0126F000001BRq2';
        opp1.Trade_Term__c = 'FOB';
        opp1.Payment_Term_Description__c = 'L/C';
        insert opp1;
        //数量大于2800片
        Product2 prod1 = TestHelper.createProduct2();
        PricebookEntry Pricebook1 = TestHelper.createPriceBookEntry(prod1.id);
        OpportunityLineItem item1 = TestHelper.createOpportunityLineItem(opp1.Id, Pricebook1.id,false);
        item1.Quantity = 3000;
        item1.Total_Power_W__c = 800;
        insert item1;
        opp1 = [select id,Total_Quantity__c,RecordType.Name,Allow_new_process_for_Japan_picklist__c,Price_Approval_Status__c,Sales_manager_approval__c,RecordTypeId,Special_Terms__c,Total_MW__c,Payment_1MW_Approve__c,Customer_Type__c,whether_pick_up_batch__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        ID rtId = ContractHelper.getContractRecordTypeId(opp1);
        System.debug('澳大利亚1MW'+opp1.Payment_1MW_Approve__c);
        System.debug('澳大利亚1MW'+opp1.Total_MW__c);
        System.debug('澳大利亚1MW'+opp1.RecordType.name);
        System.debug('澳大利亚1MW'+opp1.Payment_Term_Description__c);
        System.debug('澳大利亚1MW'+ opp1.Total_Quantity__c);
        System.debug('澳大利亚1MW'+opp1.Trade_term__c);

        System.assertEquals(Standard1MWRecordTypeId, rtId);
    }
*/
    /*
    private static testMethod void getContractRecordTypeId1MWTest(){        
        List<Payment__c> payments = new List<Payment__c>();
       // ID JapanRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Japan Standard Contract').getRecordTypeId();
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        
		// Japan Standard Contract        
        Account acc = TestHelper.createAccount();
        Opportunity opp = TestHelper.createOpportunity(acc.Id, false);
        //Customer Type is global 1MW 
        opp.Payment_1MW_Approve__c = true;
        opp.RecordTypeId = '012900000007Qf2';
        opp.Trade_Term__c = 'CIF';
        opp.Destination_Country__c = 'Australia';
        opp.Special_Terms__c = '';
        opp.Payment_Term_Description__c = 'L/C';
        opp.Payment_1MW_Approve__c = true;
        opp.Sales_manager_approval__c = 'Approved';
        opp.Price_Approval_Status__c = 'Approved';
        insert opp;
        //数量大于2800片
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Total_Power_W__c = 800;
        insert item;
        opp = [select id,Total_Quantity__c,RecordType.Name,Allow_new_process_for_Japan_picklist__c,Price_Approval_Status__c,Sales_manager_approval__c,RecordTypeId,Special_Terms__c,Total_MW__c,Payment_1MW_Approve__c,Customer_Type__c,whether_pick_up_batch__c,Payment_Term_Description__c,SELLER__c,Trade_term__c from Opportunity];
        opp.Sales_manager_approval__c = 'Approved';
        opp.Price_Approval_Status__c = 'Approved';
        ID rtId = ContractHelper.getContractRecordTypeId(opp);
        System.debug('全球1MW'+opp.Payment_1MW_Approve__c);
        System.debug('全球1MW'+opp.Total_MW__c);
        System.debug('全球1MW'+opp.RecordType.name);
        System.debug('全球1MW'+opp.Payment_Term_Description__c);
        System.debug('全球1MW'+ opp.Total_Quantity__c);
        System.debug('全球1MW'+opp.Trade_term__c);
        System.debug('全球1MW'+opp.Sales_manager_approval__c);
        System.debug('全球1MW'+opp.Price_Approval_Status__c);

        System.assertEquals(Standard1MWRecordTypeId, rtId);
    }
   */
    @isTest(SeeAllData=true)
    private static void setBankInfo(){
    	List<BackInfo__c> bankinfos = [Select id,Short_Name__c From BackInfo__c];
		Map<string,BackInfo__c> BackInfoMap = new Map<string,BackInfo__c>();
		for(BackInfo__c bi: bankinfos){
			BackInfoMap.put(bi.Short_Name__c,bi);
		}
    	Account acc = TestHelper.createAccount();
   		Contract con = TestHelper.createContract(acc.id,false);
        con.Contract_NO__c = TestHelper.nextNumberS();
        insert con;
        
        list<string> SELLERLst = new list<string>{'ジンコソーラージャパン株式会社',
        										'JinkoSolar (Switzerland) AG',
        										'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD',
        										'JinkoSolar GmbH',
        										'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA',
        										'JinkoSolar (U.S.) Inc',
        										'JINKOSOLAR (PTY) LTD',
        										'Jinkosolar Technology Limited',
        										'JinkoSolar Canada Co., Ltd.'};
        list<string> CurrencyIsoCodeLst = new list<string>{'USD','JPY','EUR','AUD','GBP','ZAR','CAD'};
       	
       	for(String str : SELLERLst){
	    	for(String s : CurrencyIsoCodeLst){
		    	con.SELLER__c = str;
		    	con.CurrencyIsoCode = s;
		    	ContractHelper.setBankInfo(con,BackInfoMap);
	    	}
       	}
    }

/*
    private static testMethod void contractChanged(){
    	
    	Account acc = TestHelper.createAccount();
    	Account acc1 = TestHelper.createAccount();
    	
    	Opportunity opp = TestHelper.createOpportunity(acc.Id);
        Product2 prod = TestHelper.createProduct2();
        PricebookEntry Pricebook = TestHelper.createPriceBookEntry(prod.id);
        OpportunityLineItem item = TestHelper.createOpportunityLineItem(opp.Id, Pricebook.id,false);
        item.Quantity = 3000;
        insert item;
        
   		Contract con_new = TestHelper.createContract(acc.id,false);
   		con_new.Trade_term__c = 'DDP';
   		con_new.SELLER__c = 'Jinkosolar Technology Limited';
   		insert con_new;
   		
   		Opportunity opp1 = TestHelper.createOpportunity(acc1.Id);
        Product2 prod1 = TestHelper.createProduct2();
        PricebookEntry Pricebook1 = TestHelper.createPriceBookEntry(prod1.id);
        OpportunityLineItem item1 = TestHelper.createOpportunityLineItem(opp1.Id, Pricebook1.id,false);
        item1.Quantity = 10000;
        insert item1;
   		Contract con_old = TestHelper.createContract(acc1.id,false);
   		con_old.Trade_term__c = 'CIF';
   		con_old.SELLER__c = 'JinkoSolar Canada Co., Ltd.';
        //con_old.RecordTypeId = ContractHelper.getContractRecordTypeId(opp1);
   		insert con_old;
   		
    	ContractHelper.contractChanged(con_new,con_old);
    	ContractHelper.contractChanged2(con_new,con_old);
    }
    
*/    
    
    private static testMethod void contractChangedRemarks(){
    	Account acc = TestHelper.createAccount();
   		Contract con = TestHelper.createContract(acc.id,false);
        con.Payment_Term_Description__c = 'T/T';
        insert con;
        list<string> warrantyLst = new list<string>{'10 standard warranty',
        										'10 linear warranty'};
        list<string> tradeTermLst = new list<string>{'DDP','EXW'};
       	list<string> sinosureLst  = new list<string>{'False','True','null'};
       	for(String str : warrantyLst){
	    	for(String st : tradeTermLst){
	    		for(String s : sinosureLst){
		    		con.Trade_term__c = st;
			    	con.Warranty_On_Material_and_Workmanship__c = str;
			    	con.Sinosure_Confirmed__c = s;
			    	ContractHelper.contractChangedRemarks(con);
			    	ContractHelper.contractChangedRemarks2(con);
	    		}
	    	}
       	}
    	
    	
    }
    
    
    
}