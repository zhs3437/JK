@isTest
public class Pijapantest {
    public static testMethod void submitTest(){
          Account acc = TestHelper.createAccount();  
        User user1 = TestHelper.createSystemAdminUser();
        
        Opportunity opp = TestHelper.createOpportunity(acc.Id,false);
        opp.OwnerId                        = user1.Id;
        opp.Trade_Term__c 					= 'CIF';
        //opp.Total_MW__c					= 0.1;
        opp.Payment_1MW_Approve__c 			= true;
        opp.delivey_point__c				= 'sad';
        opp.Warranty_On_Material_and_Workmanship__c = '10 standard warranty';
        opp.Region__c ='North Asia';
        opp.Destination_Country__c ='Hong Kong';
        opp.Seller__c ='JinkoSolar(ITALIA)S.R.L.';
        opp.CurrencyIsoCode ='ZAR';
        insert opp;
        Information_of_Seller__c ios =new Information_of_Seller__c();
        ios.Address__c ='123';
        ios.Seller__c ='JinkoSolar(ITALIA)S.R.L.';
        insert ios;
        Payment__c pay =TestHelper.createPayment(opp.Id);
        Contract con =TestHelper.createContract(acc.Id,false);
        con.OwnerId         = user1.Id;
        system.debug('con.OwnerId -->'+con.OwnerId );
        con.BuyerAccount__c = acc.Id;
        con.SELLER__c ='JinkoSolar(ITALIA)S.R.L.';
        con.CurrencyIsoCode= 'ZAR';
        con.Return_Deadline_of_Signed__c=date.today();
                con.PA_Date__c=date.today();
        con.Payment_Term__c ='DDP';
         con.Trade_term__c ='EXW';
        con.Common_Truck_Type__c='4t flatbed truck;4t wing truck;10t flatbed truck;10t wing truck;20t trailer';
        con.Special_Truck_Type__c='4t unic truck;10t unic truck';
        // con.delivey_point__c ='sad';
        con.Warranty_On_Material_and_Workmanship__c ='10 standard warranty';
        con.Region__c ='North Asia';
        con.Contract_Approver__c = user1.Id;
        system.debug('con.Contract_Approver__c-->'+con.Contract_Approver__c);
        
        con.Destination_Country__c='Hong Kong';
        con.AccountId = acc.Id;
        insert con;
        pay.Contract__c = con.Id;
        update pay;
                ApexPages.currentPage().getParameters().put('id', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
    PIJapan pi= new PIJapan(sc);
        pi.AddSave();
    }
    }