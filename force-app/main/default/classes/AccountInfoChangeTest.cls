@isTest
private class AccountInfoChangeTest {
    static testMethod void testMethod1() {


        Account acc=new Account();
        acc.Name='This is test';
        acc.Country__c='China';
        acc.Phone='122222222222222';
        acc.Company_Email__c='leo.wu@jinkosolar.com';
        acc.Website='www.addad.com';
        acc.Cooperation_method__c='Jinko';
        acc.Customer_Business_Type__c='Utility';
        acc.CurrencyIsoCode= 'AUD';
        acc.VAT_NO__c='BS 222222';
        acc.BillingCountry='China';
        acc.BillingStreet='Shouyang Road';
        acc.BillingCity='Shanghai';
        acc.BillingPostalCode='1111111';
        acc.BillingState='Shanghai 22';
        insert acc;

        acc.VAT_NO__c='AB 222 333';
        acc.Name='Not test';
        acc.BillingStreet='Dongjing Road';
        update acc;

        AccountInfoChange aic=new AccountInfoChange();
        aic.runTest();
    }
}