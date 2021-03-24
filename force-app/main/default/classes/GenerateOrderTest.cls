/*
 *create by Jason 20160708
 */

@isTest
private class GenerateOrderTest {

    static testMethod void GenerateOrder() {
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        QW_MockHttpResponseGenerator mock = new QW_MockHttpResponseGenerator();
        mock.responseElement = new jinkosolarComEccContractInfo.DT_ContractInfo_Response();
        Test.setMock(WebServiceMock.class, mock);
        Account acc = TestHelper.createAccount();
        //User user = TestHelper.createUser('00e90000000sjac', 'jason_trixpro@163.com', true);
        Opportunity opp = TestHelper.createOpportunity(acc.Id);
        BackInfo__c back = new BackInfo__c();
        back.Address__c = 'ssdd';
        back.Bank_Name__c = '三井住友銀行（銀行コード：0009）日本橋支店（支店コード：695）';
        back.BENEFICIARY_s_A_C__c = '2012638';
        back.BENEFICIARY_s_Address__c = '〒103-0026　東京都中央区日本橋兜町１３－２　兜町偕成ビル本館９F';
        back.BENEFICIARY_s_Name__c = 'ジンコソーラージャパン株式会社';
        back.SWIFT__c = 'SMBCJPJT';
        insert back;
        Contract con = TestHelper.createContract(acc.Id, false);
        con.Authorized_Representative__c                = 'aa';
        //con.Avg_Price_W__c                                = 22;
        con.BankInfo__c                                 = back.Id;
        con.Bank_Information_Content__c                 = 'BankInfo Name : 三井住友銀行（銀行コード：0009）日本橋支店（支店コード：695）';
        con.BuyerAccount__c                             = acc.Id;
        con.Commission_Type__c                          = 'Total Amount';
        con.Commission__c                               = 1;
        con.Contact_Name__c                             = 'Test';           
        con.Contract_NO__c                              = 'MCXXXX13Q2016070701';
        con.Customer_Business_Scale__c                  = 'Independent Power Producer';
        con.Customer_country__c                         = 'England';
        con.CurrencyIsoCode                             = 'USD';
        con.Destination__c                              = 'aa';
        con.Destination_Country__c                      = 'England';
        con.Email__c                                    = '123@jk.com';
        //con.EndDate                                       = Date.today();
        con.ContractTerm                                = 1;
        con.StartDate                                   = Date.today();
        con.ContractTerm                                = 12;
        con.Factory__c                                  = 'Ningbo W/H';
        con.Fax__c                                      = '15246223';
        con.Opportunity__c                              = opp.Id;
        con.Payment_Term_Description__c                 = 'L/C';
        con.Phone__c                                    = '13910111222211';
        con.Progress_Detail_1RD__c                      = 'ceshi';
        con.Region__c                                   = 'Central Asia';
        con.SAP_Customer_PO_No__c                       = '1144522';
        con.SAP_External_ID__c                          = '125633';
        con.SAP_Project_No__c                           = 'sap';
        con.SELLER__c                                   = 'ジンコソーラージャパン株式会社';
        con.Shipping_type__c                            = '海运';
        con.SPECIAL_TERMS__c                            = '1';
        con.Stage_1RD__c                                = 'Comments collecting';
        con.Supply_By__c                                = 'Production';
        con.Status                                      = 'Draft';
        //con.Tax__c                                        = 8;
        con.Tax_Rate__c                                 = 10;
        con.Title__c                                    = 'ww';
        con.Trade_term__c                               = 'CIF';
        con.Update_Time_1rd__c                          = DateTime.now();
        con.Warranty_Insurance__c                       = 'PG';
        con.Warranty_On_Material_and_Workmanship__c     = '10 linear warranty';
        //con.Pricebook2Id__c                               = '';
        con.BillingCity                                 = 'aaa';
        con.BillingCountry                              = 'bbb';
        con.BillingPostalCode                           = 'ccc';
        con.BillingState                                = 'ddd';
        con.BillingStreet                               = 'eee';
        insert con;
        TriggerHandler.bypass('RC_MDAReassignHandler');
        Component_Task_Book__c mda = QW_TestDataFactory.createComponentTaskBook();
        mda.Contract__c = con.Id;
        insert mda;
        Test.startTest();
        con.Approval_Status__c = 'Approved';
        update con;
        //con = (Contract)Utils.GetObjByID('Contract', con.Id);
        
        TriggerHandler.bypass('RC_ProductBasicHandler');
        Product2 product = TestHelper.createProduct2();
        
        //PricebookEntry priceBookEntry = TestHelper.createPriceBookEntry(product.Id, false);
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.PriceBook2ID= Test.getStandardPriceBookID();
        priceBookEntry.product2ID= product.Id;
        priceBookEntry.unitPrice = 120;
        priceBookEntry.UseStandardPrice =false;
        priceBookEntry.isActive = true;
        insert priceBookEntry;
        opp.Pricebook2Id = priceBookEntry.PriceBook2ID;
        update opp;
        Test.stopTest();
        //priceBookEntry = [select id,PriceBook2ID from PricebookEntry where  PriceBook2ID =: product.Id ];

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        pbeList.add(priceBookEntry);
        Product_Detail__c pd   = TestHelper.createProductDetail(false);
        
        pd.Product__c                                   = product.Id;
        pd.Quantity__c                                  = 125;
        pd.Total_Price__c                               = 452;
        pd.Total_MW__c                                  = 10;
        pd.Unit_Price__c                                = 2.3;
        pd.Contract_PO_PI__c                            = con.Id;
        insert pd;
        system.debug('~~~~~~~>pd.Contract_PO_PI__c:' + pd.Contract_PO_PI__c);
        
        pd = Database.query(
            QW_Utils.getQueryBySObjectType(
                'Product_Detail__c') + 
                ' WHERE Contract_PO_PI__c = \'' + con.Id + '\'');

        List<Product_Detail__c> pdList = new List<Product_Detail__c>();
        pdList.add(pd);
        
        Payment__c pay = TestHelper.createPayment(opp.Id,true);
        pay = [select id,
                        Opportunity__c,
                        Down_Balance_Payment__c,
                        Percentage__c,
                        Days__c,
                        Payment_Method__c,
                        Payment_Term__c,
                        Precise_Day__c,
                        Comments__c,
                        Credit_Valid__c
                        from Payment__c 
                        where Opportunity__c =: opp.Id];
        
        List<Payment__c> payList = new List<Payment__c>();
        payList.add(pay);
        
        /*
        ContentDocument cd  = [Select c.Id, 
                               (Select Id, 
                                LinkedEntityId, 
                                ContentDocumentId, 
                                ShareType, 
                                Visibility 
                                From ContentDocumentLinks) 
                               From ContentDocument c  
                               Limit 1];
        */
        
        ContentVersion cv=new ContentVersion(); 
            cv.Title='Header_Picture1'; 
            cv.PathOnClient='/' + cv.Title + '.doc'; 
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            cv.VersionData=bodyBlob; 
            cv.origin = 'H';
        insert cv;
        
        //ContentVersion cv = [Select c.VersionData, c.Title, c.Id, c.FileType, c.ContentDocumentId From ContentVersion c Where c.Id =: '068p0000000jFvBAAU'];
        ContentDocument  cd = [Select c.Title, c.OwnerId, c.Id, (Select Id, LinkedEntityId, ShareType, Visibility From ContentDocumentLinks) From ContentDocument c Limit 1];
        /*
        ContentDocumentLink cdl=new ContentDocumentLink();
        cdl.LinkedEntityId=con.id;
        cdl.ContentDocumentId=cv.ContentDocumentId;
        insert cdl;  
        */
        //ContentDocumentLink  cdl = [Select Id,ContentDocumentId From ContentDocumentLink Where LinkedEntityId =: con.Id ];
                
        List<ContentDocumentLink>       cdlList  = new List<ContentDocumentLink>();
        //cdlList.add();
        
        Map<ID,List<Product_Detail__c>> prodMap = new Map<ID,List<Product_Detail__c>>();
        prodMap.put(con.Id,pdList);
        
        Map<ID,List<PricebookEntry>> bookMap = new Map<ID,List<PricebookEntry>>();
        bookMap.put(con.Id,pbeList);
        
        Map<ID,List<Payment__c>> payMap = new Map<ID,List<Payment__c>>();
        payMap.put(con.Id,payList);
        
        Map<ID,List<ContentDocumentLink>>   cdlMap  = new Map<ID,List<ContentDocumentLink>>();
        cdlMap.put(con.Id,cdlList);

        GenerateOrder.generate(con, prodMap, bookMap, payMap, cdlMap);
        
        //GenerateOrder.generate(con, prodMap, bookMap, payMap);
        GenerateOrder go = new GenerateOrder();
        go.runTest();
    }
}