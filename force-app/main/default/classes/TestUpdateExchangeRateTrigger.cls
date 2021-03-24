@isTest
public class TestUpdateExchangeRateTrigger {

    static testMethod void myUnitTest() {
        Account a = new Account(Name='TestUpdateExchangeRateTrigger');
        insert a;
        a.Internal_Credit_Limit__c = 10000.00;
        a.Sinosure_Credit_Limit__c = 20000.00;
        a.Already_Used_Credit__c = 5000.00;
        //a.Total_Credit_Limit__c = a.Internal_Credit_Limit__c+a.Sinosure_Credit_Limit__c;
        //a.New_Available_Credit__c = a.Total_Credit_Limit__c - a.Already_Used_Credit__c;
        update a;
        /*system.Label.Rate_For_GBP_Credit = '0.15';
        system.Label.Rate_For_EUR_Credit = '0.15';
        system.Label.Rate_For_AUD_Credit = '0.15';
        system.Label.Rate_For_CAD_Credit = '0.15';
        system.Label.JYP_Rate_Credit = '0.15';
        system.Label.Rate_For_ZAR_Credit = '0.15';**/
        
        //a.Exchanged_Amount__c = 'GBP' + (Decimal.valueOf(a.New_Available_Credit__c) / system.Label.Rate_For_GBP_Credit);
                     
        
        /*account.Exchanged_Amount__c = 'EUR 2000';
                     
        
        account.Exchanged_Amount__c = 'AUD 2000';
                     
        
        account.Exchanged_Amount__c = 'CAD 2000';
                     
        
        account.Exchanged_Amount__c = 'JPY 2000';
                     
       
        account.Exchanged_Amount__c = 'ZAR 2000';**/
                    
       
        
    }
}