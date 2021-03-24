@isTest(SeeAllData=false)
public class TestHelper {
    
    public static Integer nextNumber = 0;
    
    public static Integer nextNumber() {
        nextNumber++;
        return nextNumber;
    }
    public static String nextNumberS() {
        return String.valueOf(nextNumber());
    }
    
    public static Campaign createCampaign(){
        return createCampaign(true);
    }
    public static Campaign createCampaign(boolean isSave){
        Campaign aCampaign = new Campaign();   
        aCampaign.Name              = 'Test';
        aCampaign.StartDate         = Date.Today();  
        aCampaign.Status            = 'Planned';     
        if(isSave) insert aCampaign;
        return aCampaign;
    }
    public static Lead createLead(){
        return createLead(true);
    }
    public static Lead createLead(boolean isSave){
        Lead aLead              = new Lead();   
        aLead.LastName      = 'Test';
        aLead.Company       = 'Test';    
        aLead.Status        = 'Open';    
        if(isSave) insert aLead;    
        return aLead;
    }
    public static Account createAccount(){
        return createAccount(true);
    }
    public static Account createAccount(boolean isSave){
        Account aAccount                = new Account();
        aAccount.Name       = 'Test';   
        aAccount.VAT_NO__c='06950176';  
        if(isSave) insert aAccount;
        system.debug('~~~~~>aAccount:' + aAccount);
        
        return aAccount;
    }
    
    public static Contact createContact(){
        return createContact(true);
    }
    public static Contact createContact(boolean isSave){
        Contact aContact                = new Contact();
        aContact.firstName      = 'Test';
        aContact.LastName       = 'Test';   
        if(isSave) insert aContact;    
        return aContact;
    }
    
    public static Contract createContract(id accountID){
        return createContract(accountID,true);
    }
    public static Contract createContract(id accountID,boolean isSave){
        
        Contract con = new Contract(
            AccountID          = accountID,
            Contract_NO__c     = nextNumberS()
        );
        if ( isSave ) {
            insert con; 
        }
        system.debug('~~~~~~~~~>con:' + con);
        return con;
    }
    
    public static Opportunity createOpportunity(id accountID){
        return createOpportunity(accountID,true);
    }
    public static Opportunity createOpportunity(id accountID,boolean isSave){
        
        Opportunity opp = new Opportunity(
            Name               = '2MW-JKM180-20120101',
            AccountID          = accountID,
            CloseDate          = Date.today(),
            Pricebook2Id       = Test.getStandardPriceBookID(),
            amount             = 1200.00,
            StageName          = 'PO Imminent',
            Region__c          ='ROA',
            Actual_Sales_Name__c ='arda',
            delivey_point__c   ='sa',
            Probability        = 80
        );
        if ( isSave ) {
            insert opp; 
            opp.Pricebook2Id = Test.getStandardPriceBookID();
            update opp;
        }
        return opp;
    }
    
    public static OpportunityLineItem createOpportunityLineItem(ID OpportunityID, ID PricebookEntryID ) {
        return createOpportunityLineItem(OpportunityID, PricebookEntryID, true);
    }
    public static OpportunityLineItem createOpportunityLineItem(ID OpportunityID, ID PricebookEntryID, Boolean doInsert ) {
        OpportunityLineItem oppLineItem = new OpportunityLineItem(
            OpportunityId               = OpportunityID,
            Quantity                    = 100,
            //TotalPrice                  = 120.00,
            UnitPrice                   = 1,
            PricebookEntryId            = PricebookEntryID,
            Battery_Type__c             = 'Normal Cell', 
            Bus_bars_of_cell__c         = '2-2BB', 
            Certification__c            = '1-TUV', 
            Color_of_Module__c          = '3-Black frame and white backsh', 
            Grade__c                    = 'A-Grade A', 
            Special_required__c         = '0-commonly', 
            Type_of_module__c           = 'NS-Non smart module', 
            Guaranteed_Delivery_Date__c = Date.Today()
        );
        system.debug('oppLineItem-->'+oppLineItem);
        if ( doInsert) insert oppLineItem;   
        return oppLineItem;         
    }
    public static OrderItem createOrderItem(ID OrderID, ID PricebookEntryID ) {
        return createOrderItem(OrderID, PricebookEntryID, true);
    }
    public static OrderItem createOrderItem(ID OrderID, ID PricebookEntryID, Boolean doInsert ) {
        OrderItem orderItem = new OrderItem(
            Quantity                    = 100,
            PricebookEntryId            = PricebookEntryID,
            OrderID                     =OrderID,
            UnitPrice                   =100
        );
        if ( doInsert) insert orderItem;   
        return orderItem;       
    }
    
    public static Product2 createProduct2(){
        return createProduct2(true);
    }
    
    public static Product2 createProduct2(boolean isSave){
        Product2 p = new Product2();
        p.Maximum_Power_at_STC_Pmax__c = 300;
        p.name ='Product' + Math.random();
        p.IsActive = true;
        if(isSave){
            insert p;
        }
        return p;
    }
    public static Attachment createAttachment(id parentId){
        return createAttachment(true,parentId);
    }
    
    public static Attachment createAttachment(boolean isSave,id parentId){
        Attachment a = new Attachment();
        a.name ='Attachment' + Math.random();
        a.Body = Blob.valueOf('this is Attachment body');
        a.ParentId = parentId;
        if(isSave){insert a;}
        return a;
    }
    
    public static PriceBookEntry createPriceBookEntry(ID productID){
        return createPriceBookEntry(productID,true);
    }
    
    public static PriceBookEntry createPriceBookEntry(ID productID,boolean isSave){
        PriceBookEntry a =new PriceBookEntry(
            PriceBook2ID= Test.getStandardPriceBookID(),
            product2ID= productID,
            unitPrice = 120,
            //UseStandardPrice =false,
            isActive = true
        );
        if(isSave)insert a;
        return a;
    }
    
    public static Task createTask(){
        return createTask(true);
    }
    public static Task createTask(boolean isSave){
        Task aTask = new Task();
        aTask.OwnerId = UserInfo.getUserId();
        aTask.Subject = 'test';
        aTask.priority='Normal';
        aTask.status = '进行中';
        aTask.description = 'test';  
        aTask.activityDate =date.today();
        if(isSave) insert aTask;
        return aTask;
    }
    
    public static User createSystemAdminUser(){
        Profile p = [select id from profile where name='System Administrator' limit 1];
        String name = 'test' + Math.random() + '@example.com';
        return createUser(p.id,name,true);
    }
    
    
    
    public static User createUser(id ProfileId,string username,boolean isSave) {
        User aUser = new User(
            alias = 'testuser',
            email=username,
            emailencodingkey='UTF-8',
            lastname='Testing',
            languagelocalekey='en_US',
            City='Shanghai',
            Phone='15100008888',
            Country='China',
            localesidkey='en_US',
            profileid = ProfileId,
            MobilePhone='1090123213', 
            PostalCode='10000001',
            isActive = true,
            timezonesidkey='America/Los_Angeles',
            username=username,
            communityNickname = 'test' + Math.random()
        );
        if(isSave) insert aUser;
        return aUser;
    }
    
    public static Inventory__c createInventory(){
        return createInventory(true);
    }
    public static Inventory__c createInventory(boolean isSave){
        Inventory__c aInventory= new Inventory__c();   
        //aInventory.Stock_Location__c      = 'Stock_Location';
        //aInventory.SAP_Materiel_No__c         = 'SAP_Materiel_No';
        aInventory.Quantity__c              = 1000;
        if(isSave) insert aInventory;    
        return aInventory;
    }
    
    /**
    *  add by jason  20160621
    */
    //start
    
//by 20170222    

    public static SubmitForReview__c createSubmitForReview(){
        return createSubmitForReview(true);
    }
    public static SubmitForReview__c createSubmitForReview(boolean isSave){
        Order ord = createOrder();
        Amendment__c am = new Amendment__c();
        am.Amendment_Point__c = 'Quantity';
        am.Order__c = ord.Id;
        insert am;
        SubmitForReview__c aSubmit= new SubmitForReview__c();   
        //aSubmit.Id                = 'a0Xp00000007vks';
        aSubmit.Amendment__c    = am.id;    
        aSubmit.Status__c       = 'Approved';
        aSubmit.Remarks__c      = 'ok';
        if(isSave) insert aSubmit;    
        return aSubmit;
    }

    public static Order createOrder(){
        return createOrder(true);
    }
    public static Order createOrder(boolean isSave){
        Account acc = createAccount();
        Order aOrder= new Order();   
        aOrder.Buyer__c = acc.Id;
        aOrder.BillingCountry = 'aaa';
        aOrder.BillingPostalCode = 'bbb';
        aOrder.BillingState = 'ccc';
        aOrder.BillingCity = 'ddd';
        aOrder.BillingStreet = 'eee';
        aOrder.Contract_No__c = 'MCXXXX13QXtest';
        aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
        aOrder.AccountId = acc.Id;
        aOrder.EffectiveDate = Date.today();
        aOrder.Status = 'Draft';
        if(isSave) insert aOrder;    
        return aOrder;
    }

    public static OrderItem createOrderItem(){
        return createOrderItem(true);
    }
    public static OrderItem createOrderItem(boolean isSave){
        OrderItem aOrderItem= new OrderItem();   
        aOrderItem.Battery_Type__c = 'Normal Cell';
        aOrderItem.Bus_bars_of_cell__c = '3-3BB';
        aOrderItem.Certification__c = '1-TUV';
        aOrderItem.Color_of_frame_and_backsheet__c = '1-Black';
        aOrderItem.Connector__c = 'JK00M';
        aOrderItem.Grade__c = 'A-Grade A'; 
        aOrderItem.Guaranteed_Delivery_Date__c = Date.today();
        aOrderItem.Length_of_Junction_Box_wiring__c = '1000mm';
        aOrderItem.Special_required__c = '0-commonly';
        //aOrderItem.Total_Price__c = 1;
        aOrderItem.Type_of_module__c = 'NS-Non smart module';
        aOrderItem.UnitPrice = 2;
        if(isSave) insert aOrderItem;    
        return aOrderItem;
    }
    
    public static Amendment__c createAmendment(){
        return createAmendment(true);
    }
    public static Amendment__c createAmendment(boolean isSave){
        Order ord = createOrder();
        Amendment__c aAmendment= new Amendment__c();   
        aAmendment.Billing_Address__c = '';
        aAmendment.SEQ__c = 1;
        aAmendment.Total_MW__c = 0.7800;
        aAmendment.Order__c = ord.Id ;
        
        if(isSave) insert aAmendment;    
        return aAmendment;
    }
    
    public static Component_Task_Book__c createComponentTaskBook(Order ord){
        return createComponentTaskBook(ord,true);
    }
    public static Component_Task_Book__c createComponentTaskBook(Order ord,boolean isSave){
        Component_Task_Book__c aComponentTaskBook= new Component_Task_Book__c(
            Order__c = ord.Id,
            RecordTypeId = Schema.SObjectType.Component_Task_Book__c.getRecordTypeInfosByName().get('oversea').getRecordTypeId(),
            Frame_B_side_Height__c = '30mm frame',
            Frame_Color__c = 'Silver',
            Module_Level__c = 'A级',
            Product_Certificate__c = 'IEC61215: 2005 (TUV certified)',
            Rear_cover__c = 'White Backsheet',
            Frame_Type__c = 'Standard Frame',
            LRF__c = 'Shall use',
            Junction_Box_brand__c = 'Jinko Integrate',
            Junction_Box_Cable_Length__c = '900mm',
            Junction_Box_Connector__c = 'Standard_JK03M',
            EVA__c = 'Optional_keep same for whole order',
            Front_Glass__c = 'ARC',
            Glass_Thickness__c = '2.0mm',
            Rear_Cover_Material__c = 'Decide by factory',
            Additional_Certificate__c = 'No need',
            Package__c = 'Standard packing method for Dual-glass frameless modules',
            C_side_type_of_short_frame__c = 'Without frame',
            Nameplate__c = 'Standard',
            Shipping_Mark__c = 'Jinko Standard',
            Current_Sorting_Style__c = 'No need',
            Color_Sorting_style__c = 'No Need',
            Additional_Shipping_Mark_Color_Label__c = 'No Need',
            Cell__c = 'Not acceptable',
            Warranty__c = 'Standard',
            BOM__c='Standard Certified BOM',
            Power_Tolerance__c='Each module: 0~+3%',
            System_Voltage__c='1500V',
            Additional_power__c='No',
            Special_Approval_for_order_production__c='No',
            On_line_Audit__c='No Need',
            Pre_shipping_Inspection_factory__c='No Need',
            Lab_tests__c='Jinko laboratory',
            Cell_Quantity1__c='72',
            Cell_Type1__c='Other',
            Cell_Quantity2__c='72',
            Cell_Type2__c='Other',
            Cell_Quantity3__c='72',
            Cell_Type3__c='Other',
            Transportation_style__c = 'Land',
            On_site_monitor_by_Client_or_3rd_party__c = 'No Need',
            Technical_manager_Shanghai__c='Approved'
        );
        if(isSave){
             insert aComponentTaskBook;
             update aComponentTaskBook;
        } 
        return aComponentTaskBook;
    }
    
      public static Component_Task_Book__c createComponentTaskBook(Opportunity opp){
        return createComponentTaskBook(opp,true);
    }
    public static Component_Task_Book__c createComponentTaskBook(Opportunity opp,boolean isSave){
        Component_Task_Book__c aComponentTaskBook= new Component_Task_Book__c(
            Opportunity__c = opp.Id,
            RecordTypeId = Schema.SObjectType.Component_Task_Book__c.getRecordTypeInfosByName().get('oversea').getRecordTypeId(),
            Frame_B_side_Height__c = '30mm frame',
            Frame_Color__c = 'Silver',
            Module_Level__c = 'A级',
            Product_Certificate__c = 'IEC61215: 2005 (TUV certified)',
            Rear_cover__c = 'White Backsheet',
            Frame_Type__c = 'Standard Frame',
            LRF__c = 'Shall use',
            Junction_Box_brand__c = 'Jinko Integrate',
            Junction_Box_Cable_Length__c = '900mm',
            Junction_Box_Connector__c = 'Standard_JK03M',
            EVA__c = 'Optional_keep same for whole order',
            Front_Glass__c = 'ARC',
            Glass_Thickness__c = '2.0mm',
            Rear_Cover_Material__c = 'Decide by factory',
            Additional_Certificate__c = 'No need',
            Package__c = 'Standard packing method for Dual-glass frameless modules',
            C_side_type_of_short_frame__c = 'Without frame',
            Nameplate__c = 'Standard',
            Shipping_Mark__c = 'Jinko Standard',
            Current_Sorting_Style__c = 'No need',
            Color_Sorting_style__c = 'No Need',
            Additional_Shipping_Mark_Color_Label__c = 'No Need',
            Cell__c = 'Not acceptable',
            Warranty__c = 'Standard',
            BOM__c='Standard Certified BOM',
            Power_Tolerance__c='Each module: 0~+3%',
            System_Voltage__c='1500V',
            Additional_power__c='No',
            Special_Approval_for_order_production__c='No',
            On_line_Audit__c='No Need',
            Pre_shipping_Inspection_factory__c='No Need',
            Lab_tests__c='Jinko laboratory',
            Cell_Quantity1__c='72',
            Cell_Type1__c='Other',
            Cell_Quantity2__c='72',
            Cell_Type2__c='Other',
            Cell_Quantity3__c='72',
            Cell_Type3__c='Other',                              
            Transportation_style__c = 'Land',                                        
            On_site_monitor_by_Client_or_3rd_party__c='No Need',
            Technical_manager_Shanghai__c='Approved'
            );   
            if(isSave){
                insert aComponentTaskBook;
                update aComponentTaskBook;
            } 
            return aComponentTaskBook;
        }
 
     public static Component_Task_Book__c createComponentTaskBook(Contract con){
        return createComponentTaskBook(con,true);
    }
    public static Component_Task_Book__c createComponentTaskBook(Contract con,boolean isSave){
        Component_Task_Book__c aComponentTaskBook= new Component_Task_Book__c(
            Contract__c = con.Id,
            RecordTypeId = Schema.SObjectType.Component_Task_Book__c.getRecordTypeInfosByName().get('oversea').getRecordTypeId(),
            Frame_B_side_Height__c = '30mm frame',
            Frame_Color__c = 'Silver',
            Module_Level__c = 'A级',
            Product_Certificate__c = 'IEC61215: 2005 (TUV certified)',
            Rear_cover__c = 'White Backsheet',
            Frame_Type__c = 'Standard Frame',
            LRF__c = 'Shall use',
            Junction_Box_brand__c = 'Jinko Integrate',
            Junction_Box_Cable_Length__c = '900mm',
            Junction_Box_Connector__c = 'Standard_JK03M',
            EVA__c = 'Optional_keep same for whole order',
            Front_Glass__c = 'ARC',
            Glass_Thickness__c = '2.0mm',
            Rear_Cover_Material__c = 'Decide by factory',
            Additional_Certificate__c = 'No need',
            Package__c = 'Standard packing method for Dual-glass frameless modules',
            C_side_type_of_short_frame__c = 'Without frame',
            Nameplate__c = 'Standard',
            Shipping_Mark__c = 'Jinko Standard',
            Current_Sorting_Style__c = 'No need',
            Color_Sorting_style__c = 'No Need',
            Additional_Shipping_Mark_Color_Label__c = 'No Need',
            Cell__c = 'Not acceptable',
            Warranty__c = 'Standard',
            BOM__c='Standard Certified BOM',
            Power_Tolerance__c='Each module: 0~+3%',
            System_Voltage__c='1500V',
            Additional_power__c='No',
            Special_Approval_for_order_production__c='No',
            On_line_Audit__c='No Need',
            Pre_shipping_Inspection_factory__c='No Need',
            Lab_tests__c='Jinko laboratory',
            Cell_Quantity1__c='72',
            Cell_Type1__c='Other',
            Cell_Quantity2__c='72',
            Cell_Type2__c='Other',
            Cell_Quantity3__c='72',
            Cell_Type3__c='Other',
            Transportation_style__c = 'Land',
            On_site_monitor_by_Client_or_3rd_party__c='No Need',
            Technical_manager_Shanghai__c='Approved'
            );   
            if(isSave){
                insert aComponentTaskBook;
                update aComponentTaskBook;
            } 
            return aComponentTaskBook;
        }
    public static Payment__c createPayment(String oppId){
        return createPayment(oppId, true);
    }
    public static Payment__c createPayment(String oppId,boolean isSave){
        Payment__c aPayment = new Payment__c();   
        aPayment.Down_Balance_Payment__c = 'Down Payment';
        aPayment.Percentage__c           =  100;
        aPayment.Days__c                 =  60;
        aPayment.Payment_Method__c       = 'L/C'; 
        aPayment.Payment_Term__c         = '100% OA by LC at sight';
        aPayment.Opportunity__c          = oppId; 
        //aPayment.Precise_Day__c            = Date.today();
        aPayment.Comments__c             = '';
        aPayment.Credit_Valid__c         = true;
        
        if(isSave) insert aPayment;    
        return aPayment;
    }
    public static Apply_Inventory__c createApplyInventory(){
        return createApplyInventory(true);
    }
    public static Apply_Inventory__c createApplyInventory(boolean isSave){
        Apply_Inventory__c aApplyInventory  = new Apply_Inventory__c();   
        aApplyInventory.Status__c           = 'Book';
        aApplyInventory.Material_No__c      = '1234';
        aApplyInventory.Quantity__c         = 1000;
        aApplyInventory.Due_Date__c         = Date.today();
        aApplyInventory.Reminder_Date__c    = Date.today()- 1;
        // aApplyInventory.Warehouse__c        = 'T005';
        if(isSave) insert aApplyInventory;    
        return aApplyInventory;
    }
    
    public static Trade_term_and_payment_term__c createTradeTermPaymentTerm(){
        return createTradeTermPaymentTerm(true);
    }
    public static Trade_term_and_payment_term__c createTradeTermPaymentTerm(boolean isSave){
        Trade_term_and_payment_term__c aTradeTermPaymentTerm = new Trade_term_and_payment_term__c();   
        aTradeTermPaymentTerm.Payment_description__c       = 'Total purchase price of the Goods shall be paid by T/T by Buyer at least Y business days before picking up Goods.(Y≥2）';
        aTradeTermPaymentTerm.Payment_term__c              = '100%LC(at sight)'; 
        aTradeTermPaymentTerm.Trade_Term__c                = 'EXW';
        aTradeTermPaymentTerm.Delivery_Point__c            = 'china';
        if(isSave) insert aTradeTermPaymentTerm;    
        return aTradeTermPaymentTerm;
    }
    
    
    //创建Product_Detail__c
    
    public static Product_Detail__c createProductDetail(){
        return createProductDetail(true);
    }
    public static Product_Detail__c createProductDetail(boolean isSave){
        Product_Detail__c aProductDetail = new Product_Detail__c(); 
        //testPrepare tp = new testPrepare();
        aProductDetail.Battery_Type__c                              = 'Normal Cell';
        aProductDetail.Bus_bars_of_cell__c                          = '3-3BB';
        aProductDetail.Certification__c                             = '1-TUV';
        aProductDetail.Color_of_frame_and_backsheet__c              = '1-Black';
        aProductDetail.Connector__c                                 = 'JK00M';
        aProductDetail.Production_Description__c                    = 'Production_Description__c';
        aProductDetail.Grade__c                                     = 'A-Grade A';
        aProductDetail.Guaranteed_Delivery_Date__c                  = Date.today();
        aProductDetail.Guaranteed_Delivery_Date_japan__c            = Date.today();
        aProductDetail.Length_of_Junction_Box_wiring__c             = '1000mm';
        aProductDetail.Special_required__c                          = '0-commonly';
        aProductDetail.Junction_Box_Type__c                         = 'NS-Non smart module';
        if(isSave) insert aProductDetail;    
        return aProductDetail;
    }
    //create Quote  add By Jason  
    public static Quote createQuote(id opportunityID){
        return createQuote(opportunityID,true);
    }
    public static Quote createQuote(id opportunityID,boolean isSave){

        Quote q = new Quote(
            Name               = 'testQuote',
            OpportunityID          = opportunityID,
            Validity_Of_The_Offer__c = date.today(),
            Pricebook2Id       = Test.getStandardPriceBookID()
        );
        if ( isSave ) {
            insert q; 
            q.Pricebook2Id = Test.getStandardPriceBookID();
            update q;
        }
        return q;
    }
    //Create QuoteLineItem add By Jason 
    public static QuoteLineItem createQuoteLineItem(ID QuoteID, ID PricebookEntryID ) {
        return createQuoteLineItem(QuoteID, PricebookEntryID, true);
    }
    public static QuoteLineItem createQuoteLineItem(ID QuoteID, ID PricebookEntryID, Boolean doInsert ) {
        QuoteLineItem qLineItem = new QuoteLineItem(
            QuoteID               = QuoteID,
            Quantity                    = 100,
            UnitPrice                  = 120.00,
            PricebookEntryId            = PricebookEntryID
        );
        if ( doInsert) insert qLineItem;   
        return qLineItem;         
    }
    //Create Document By Jason 
    
    public static Document createDocument(){
        return createDocument(true);
    }
    
    public static Document createDocument(boolean isSave){
        Folder fol =  [SELECT Id,Name FROM Folder where AccessType='Public' and IsReadonly=false and Type='Document' limit 1];
        Document a = new Document();
        a.name ='Guide for Reset Password';
        a.Body = Blob.valueOf('this is Attachment body');
        a.FolderId = fol.id;
        if(isSave){insert a;}
        return a;
    }
    
    
    public static string getRecordTypeId(string objName,string recordTypeName){
        list<RecordType> lst = [Select SobjectType, Name, Id From RecordType where Name=:recordTypeName and SobjectType=: objName];
        if(lst.size()>0){
            return lst[0].id;
        }
        return '';
    }   
    
}