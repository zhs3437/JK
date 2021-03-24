@isTest 
public class testPrepare {
    public Account acc {get;set;}
    public Contact contact {get;set;}
    public Opportunity o1 {get;set;}
    public Opportunity o2 {get;set;}
    public OpportunityLineItem opls1 {get;set;}
    public OpportunityLineItem opls2 {get;set;}
    public Product2 p1 {get;set;}
    public Product2 p2 {get;set;}
    public Contract c1 {get;set;}
    public Contract c2 {get;set;}
    public Product_Detail__c pd1 {get;set;}
    public Product_Detail__c pd2 {get;set;}
    public User user1 {get;set;}
    public User user2 {get;set;}
    public testPrepare(){
        //prepare common data
        
        //create user
        user1 = new User(Username='u1'+System.now().getTime()+'@qq.com',Email='winhunter@qq.com',FirstName='javen',LastName='hao',Alias='UHao',ProfileId=UserInfo.getProfileId());
        user1.TimeZoneSidKey='Asia/Shanghai';user1.LocaleSidKey='en_US';user1.EmailEncodingKey='ISO-8859-1';user1.LanguageLocaleKey='en_US';
        
        insert user1; 
        
        //create user
        user2 = new User(Username='u2'+System.now().getTime()+'@mail.com',Email='testuser2@mail.com',FirstName='Test0202',LastName='TestUser',Alias='Tester',ProfileId=UserInfo.getProfileId());
        user2.TimeZoneSidKey='Asia/Shanghai';user2.LocaleSidKey='en_US';user2.EmailEncodingKey='ISO-8859-1';user2.LanguageLocaleKey='en_US';user2.BMO_specialist__c=user1.Id;user2.Contract_Approver__c=user1.Id;
        insert user2;
        
        //create account 
        acc = new Account(Name = 'JinkoFullNamefortest',Customer_Grading__c='VIP',Sinosure_Buyer_s_Code__c='SN0000X',Cooperation_method__c='OEM',User__c=UserInfo.getUserId());
        acc.Company_Email__c = 'winhunter@qq.com';
        insert acc;
        system.debug('----------------  prepare Account  done!  ----------------');
        // 
        contact = new Contact(LastName='Hao',AccountId=acc.Id);
        insert contact;
        
        //create opportunity
        o1 = new Opportunity(name='2MW-JKM180-20120101',AccountId=acc.id,
            CloseDate = Date.today(), StageName='Close Won',Probability=100,delivey_point__c='sad');
        insert o1;
        // Green_Channel_Approval__c
        o2 = new Opportunity(name='2MW-JKM190-20130101',AccountId=acc.id,Credit_Control_Approval__c=true,Price_Approval__c=true, Green_Channel_Approval__c=false,
            CloseDate = Date.today(), StageName='Close Won',Probability=100,delivey_point__c='sad');
        insert o2;
        system.debug('----------------  prepare opportunity  done!  ----------------');
        //create product
        p1 = new Product2(ProductCode = 'testProduct',
            Name = 'Test Product');
        insert p1;
        p2 = new Product2(ProductCode = 'testProduct2',
            Name = 'Test Product2');
        insert p2;
        system.debug('----------------  prepare product  done!  ----------------');
        //create pricebook Entry
        Pricebook2 pb = [Select Id From Pricebook2 Where Name = 'Standard Price Book' limit 1];
        PricebookEntry pbe = new PricebookEntry(Product2Id=p1.Id,Pricebook2Id=pb.Id,UnitPrice=10,UseStandardPrice=false,IsActive=true);
        insert pbe;
        PricebookEntry pbe2 = new PricebookEntry(Product2Id=p2.Id,Pricebook2Id=pb.Id,UnitPrice=20,UseStandardPrice=false,IsActive=true);
        insert pbe2;
        system.debug('----------------  prepare PricebookEntry  done!  ----------------');
        //create opportunity item
        opls1  = new OpportunityLineItem(OpportunityId=o1.Id,PricebookEntryId=pbe.Id, Quantity=100, TotalPrice=1000, Battery_Type__c= 'Normal Cell',                             
            Bus_bars_of_cell__c	= '2-2BB',Certification__c	= '1-TUV',Color_of_Module__c = '3-Black frame and white backsh', 
            Grade__c = 'A-Grade A', Special_required__c	= '0-commonly',Type_of_module__c = 'NS-Non smart module',Guaranteed_Delivery_Date__c	= Date.Today());
        insert opls1;
        opls2 = new OpportunityLineItem(OpportunityId=o1.Id,PricebookEntryId=pbe2.Id, Quantity=200, TotalPrice=4000,Battery_Type__c= 'Normal Cell',                             
            Bus_bars_of_cell__c	= '2-2BB',Certification__c	= '1-TUV',Color_of_Module__c = '3-Black frame and white backsh', 
            Grade__c = 'A-Grade A', Special_required__c	= '0-commonly',Type_of_module__c = 'NS-Non smart module',Guaranteed_Delivery_Date__c	= Date.Today());
        insert opls2;
        system.debug('----------------  prepare OpportunityLineItem  done!  ----------------');
        //create Contract
       // c1 = new Contract( AccountId=acc.Id,Opportunity__c=o2.Id,Status='Draft',Contract_NO__c='2011-JKZJXS-ZQPM-1984',BMO_Specialist__c=user2.BMO_specialist__c,Contract_Approver__c=user2.Contract_Approver__c);
       // insert c1;
      //  c2 = new Contract( AccountId=acc.Id,Opportunity__c=o2.Id,Status='Draft',Contract_NO__c='2011-JKZJXS-ZQPM-1985',BMO_Specialist__c=user2.BMO_specialist__c,Contract_Approver__c=user2.Contract_Approver__c);
      //  insert c2;
        system.debug('----------------  prepare Contract  done!  ----------------');
     //   pd1 = new Product_Detail__c(Contract_PO_PI__c=c1.Id,Product__c=p1.id);
    //    insert pd1;
     //   pd2 = new Product_Detail__c(Contract_PO_PI__c=c1.Id,Product__c=p2.id);
    //    insert pd2;
        system.debug('----------------  prepare Product Detail done!  ----------------');
    }
}