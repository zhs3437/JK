@isTest
public class CommissionTestCtrl {
    public static testMethod void submitTest(){
        // 第一个页面测试页面
        /**
        Account acc = TestHelper.createAccount();
         Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Land_Freight_China__c=1;
            opp.Land_Freight_Oversea__c=1;
            opp.Ocean_Freight__c=1;
        opp.Expect_Price_and_Comments__c='1';
        insert opp;
         ApexPages.currentPage().getParameters().put('id',opp.Id);
        ApexPages.standardController std    = new ApexPages.standardController(opp);
        OppPriceApprovalCtrl op =new OppPriceApprovalCtrl(std);
        op.Action1();
        op.Action2();
        op.Action3();
        //第二个页面测试页面
        CommissionApplicationVFCtrl cavf=new CommissionApplicationVFCtrl(std);
       cavf.blob1 =Blob.valueOf('this is Attachment body');
         cavf.blob1name ='this is Attachment body';
        cavf.blob14 =Blob.valueOf('this is Attachment body');
        cavf.blob14name ='this is Attachment body';
        cavf.blob15 =Blob.valueOf('this is Attachment body');
        cavf.blob15name ='this is Attachment body';
        cavf.blob16 =Blob.valueOf('this is Attachment body');
        cavf.blob16name ='this is Attachment body';
        cavf.blob17 =Blob.valueOf('this is Attachment body');
        cavf.blob17name ='this is Attachment body';
        cavf.blob23 =Blob.valueOf('this is Attachment body');
        cavf.blob23name ='this is Attachment body';
        cavf.blob24 =Blob.valueOf('this is Attachment body');
        cavf.blob24name ='this is Attachment body';
        cavf.blob25 =Blob.valueOf('this is Attachment body');
        cavf.blob25name ='this is Attachment body';
        cavf.blob26 =Blob.valueOf('this is Attachment body');
        cavf.blob26name ='this is Attachment body';
        cavf.blob27 =Blob.valueOf('this is Attachment body');
        cavf.blob27name ='this is Attachment body';
        cavf.blob29 =Blob.valueOf('this is Attachment body');
        cavf.blob29name ='this is Attachment body';
        cavf.blob211 =Blob.valueOf('this is Attachment body');
        cavf.blob211name ='this is Attachment body';
        cavf.blob213 =Blob.valueOf('this is Attachment body');
        cavf.blob213name ='this is Attachment body';
        cavf.blob212 =Blob.valueOf('this is Attachment body');
        cavf.blob212name ='this is Attachment body';
        cavf.blob215 =Blob.valueOf('this is Attachment body');
       cavf.blob215name ='this is Attachment body';
        cavf.blob219 =Blob.valueOf('this is Attachment body');
        cavf.blob219name ='this is Attachment body';
        
        cavf.Addsobj();
        
        
        CommissionApplicationVFCtrl cavf1=new CommissionApplicationVFCtrl(std);
       cavf1.blob1 =Blob.valueOf('this is Attachment body');
         cavf1.blob1name ='this is Attachment body';
        cavf1.blob14 =Blob.valueOf('this is Attachment body');
        cavf1.blob14name ='this is Attachment body';
        cavf1.blob15 =Blob.valueOf('this is Attachment body');
        cavf1.blob15name ='this is Attachment body';
        cavf1.blob16 =Blob.valueOf('this is Attachment body');
        cavf1.blob16name ='this is Attachment body';
        cavf1.blob17 =Blob.valueOf('this is Attachment body');
        cavf1.blob17name ='this is Attachment body';
        cavf1.blob23 =Blob.valueOf('this is Attachment body');
        cavf1.blob23name ='this is Attachment body';
        cavf1.blob24 =Blob.valueOf('this is Attachment body');
        cavf1.blob24name ='this is Attachment body';
        cavf1.blob25 =Blob.valueOf('this is Attachment body');
        cavf1.blob25name ='this is Attachment body';
        cavf1.blob26 =Blob.valueOf('this is Attachment body');
        cavf1.blob26name ='this is Attachment body';
        cavf1.blob27 =Blob.valueOf('this is Attachment body');
        cavf1.blob27name ='this is Attachment body';
        cavf1.blob29 =Blob.valueOf('this is Attachment body');
        cavf1.blob29name ='this is Attachment body';
        cavf1.blob211 =Blob.valueOf('this is Attachment body');
        cavf1.blob211name ='this is Attachment body';
        cavf1.blob213 =Blob.valueOf('this is Attachment body');
        cavf1.blob213name ='this is Attachment body';
        cavf1.blob212 =Blob.valueOf('this is Attachment body');
        cavf1.blob212name ='this is Attachment body';
        cavf1.blob215 =Blob.valueOf('this is Attachment body');
       cavf1.blob215name ='this is Attachment body';
        cavf1.blob219 =Blob.valueOf('this is Attachment body');
        cavf1.blob219name ='this is Attachment body';
        
        
        //对象内的页面
      String oppid=opp.Id;
        List<Commission_Application__c> calst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where Opportunity__c =: oppid');
        ApexPages.standardController std2    = new ApexPages.standardController(calst[0]);
        CommissionApplicationListCtrl ca =new CommissionApplicationListCtrl(std2);
        
        CommisionINFOCtrl cic =new CommisionINFOCtrl();
        cic.requestId=oppid;
        
        
         User user = new User(Username='u'+System.now().getTime()+'@163.com',
                             Email='jason_trixpro@163.com',
                             FirstName='jason',
                             LastName='jia',
                             Alias='UJia',
                             ProfileId=UserInfo.getProfileId());
        
        //user.Contract_Approver__c='Anita Li';
        user.TimeZoneSidKey='Asia/Shanghai';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='ISO-8859-1';
        user.LanguageLocaleKey='en_US';
        user.Region__c ='ROA';
        insert user;
        
        Opportunity testObj = TestHelper.createOpportunity(acc.Id);
        //testObj.OwnerId = '005900000014BfH'; // Init Sales :Ali Hamam 
    	//update testObj;
        
        // Create a new email, envelope object and Attachment
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        CommissionApproveEmailService testPriceApprove = new  CommissionApproveEmailService();
        
        User userTest = [SELECT ID,EMAIL,Name from User WHERE Name =:'Anita Li'];
		env.fromAddress = userTest.Email;
		email.fromAddress = userTest.Email;
	    email.subject = '[#RVID:'+ calst[0].id +'#]Please review this opportunity';
	    email.plainTextBody = ' reject \nTest002';
	    testPriceApprove.handleInboundEmail( email , env );  
		
        email.plainTextBody = ' yes \nTest001';
	    testPriceApprove.handleInboundEmail( email , env );  
		//Opportunity testOpp = [SELECT ID, Price_Approval_Status__c From Opportunity Where ID=:testObj.Id];
  
*/
}
}