@isTest
public class ContractTimeCtrlTest {
         Static testMethod void myTest(){
     Account acc = TestHelper.createAccount();  
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c 					= 'CIF';
        //opp.Total_MW__c					= 0.1;
        opp.Payment_1MW_Approve__c 			= true;
        opp.delivey_point__c				= 'sad';
        opp.Warranty_On_Material_and_Workmanship__c = '10 standard warranty';
        opp.Region__c ='North Asia';
        opp.Destination_Country__c ='Hong Kong';
        opp.Seller__c ='Jinko Solar Import and Export Co., Ltd.';
        insert opp;
        Information_of_Seller__c ios =new Information_of_Seller__c();
        ios.Address__c ='123';
        ios.Seller__c ='Jinko Solar Import and Export Co., Ltd.';
         insert ios;
        Payment__c pay =TestHelper.createPayment(opp.Id);
        Contract con =TestHelper.createContract(acc.Id,false);
         con.BuyerAccount__c = acc.Id;
         con.SELLER__c ='Jinko Solar Import and Export Co., Ltd.';
         con.Payment_Term__c ='CIF';
         con.Contract_Active_Time__c = datetime.now().addDays(-10);
         con.CMO_Dept__c ='Pending';
         con.BMO_Dept__c ='Pending';
         con.BMO_Dept_New__c ='Pending';
         con.Finance_Dept__c ='Pending';
         con.Technical_Dept__c = 'Pending';
         con.SendEmailToGMTime__c = datetime.now().addHours(-5);
         con.SendEmailToBMOTime__c = datetime.now().addHours(-5);
         con.SendToFinanceTime__c = datetime.now().addHours(-5);
         con.SendEmailToTechnicalTime__c = datetime.now().addHours(-5);
         con.SendToLegalTime__c  = datetime.now().addHours(-37);
        // con.delivey_point__c ='sad';
         con.Warranty_On_Material_and_Workmanship__c ='10 standard warranty';
         con.Region__c ='North Asia';
         con.Destination_Country__c='Hong Kong';
             con.Opportunity__c=opp.id;
         insert con;
              con.Status ='Activated';
         update con;
             
          ApexPages.currentPage().getParameters().put('id', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
          ContractTimeCtrl  ctc = new ContractTimeCtrl(sc);
             ctc.incrementCounter();
         }

}