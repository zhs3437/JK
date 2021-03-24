@isTest
public class ContractPreviewClickTest {
    private static testMethod void ContractClick(){
          Account acc = TestHelper.createAccount();  
     User user1 = TestHelper.createUser(UserInfo.getProfileId(), 'u1@trixpro.com', true);
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.Trade_Term__c 					= 'EXW';
        //opp.Total_MW__c					= 0.1;
        opp.Payment_1MW_Approve__c 			= true;
        opp.delivey_point__c				= 'sad';
        opp.Warranty_On_Material_and_Workmanship__c = '10 standard warranty';
        opp.Region__c ='ROA';
        opp.Destination_Country__c ='Australia';
        opp.Seller__c ='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';
        insert opp;
        Information_of_Seller__c ios =new Information_of_Seller__c();
        ios.Address__c ='123';
        ios.Seller__c ='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD';
         insert ios;
        Payment__c pay =TestHelper.createPayment(opp.Id);
        Contract con =TestHelper.createContract(acc.Id,false);
         con.BuyerAccount__c = acc.Id;
         con.SELLER__c ='JINKOSOLAR (PTY) LTD';
         con.CurrencyIsoCode= 'ZAR';
         con.Payment_Term__c ='EXW';
        // con.delivey_point__c ='sad';
         con.Warranty_On_Material_and_Workmanship__c ='10 standard warranty';
         con.Region__c ='ROA';
         con.Destination_Country__c='Australia';
         insert con;
         pay.Contract__c = con.Id;
         update pay;
         
         Standard_Template_Teams__c stt =new Standard_Template_Teams__c();
         stt.Name ='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c';
         stt.Flag__c ='Standard';
         stt.Type__c ='Contain';
         stt.Field_Values__c ='EXW:Down Payment:T/T:x% DP X days after the Execution Date';
         stt.Actual_Values__c='123';
         insert stt;
          Standard_Template_Teams__c stt1 =new Standard_Template_Teams__c();
         stt1.Name ='Trade_term__c';
         stt1.Flag__c ='Standard';
         stt1.Type__c ='Equal';
         stt1.Field_Values__c ='FOB';
         stt1.Actual_Values__c='FOB China Main Port';
         insert stt1;
          Standard_Template_Teams__c stt2 =new Standard_Template_Teams__c();
         stt2.Name ='Trade_term__c';
         stt2.Flag__c ='Standard';
         stt2.Type__c ='Contain';
         stt2.Field_Values__c ='CFR,CIF,CIP,CPT,DAT,DDU,EXW,FCA';
         stt2.Actual_Values__c='[123] [目的港口]';
         insert stt2;
         Standard_Template_Teams__c stt3 =new Standard_Template_Teams__c();
         stt3.Name ='Warranty_Insurance__c';
         stt3.Flag__c ='Standard';
         stt3.Type__c ='Contain';
         stt3.Field_Values__c ='10 standard warranty';
         stt3.Actual_Values__c='[123]';
         insert stt3;
           Standard_Template_Teams__c stt4 =new Standard_Template_Teams__c();
         stt4.Name ='Region__c:Destination_Country__c';
         stt4.Flag__c ='Standard';
         stt4.Type__c ='Equal';
         stt4.Field_Values__c ='ROA:Australia';
         stt4.Actual_Values__c='[123]';
         insert stt4;
         Standard_Template_Teams__c stt5 =new Standard_Template_Teams__c();
         stt5.Name ='Boolean1:Destination_Country__c:Region__c:SELLER__c:Boolean2:Boolean3';
         stt5.Flag__c ='Standard';
         stt5.Type__c ='Contain';
         stt5.Field_Values__c ='true:Australia:Region:JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD:false:true';
         stt5.Actual_Values__c='[123]';
         insert stt5;
        ApexPages.currentPage().getParameters().put('id', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        // ContractPreviewCtrl  cpc = new ContractPreviewCtrl(sc);
          ContractPreviewClick.Contract(con.id);
            ContractPreviewClick.runTest();

    }

}