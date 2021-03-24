/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@isTest
private class OpptyProductTest {

    static testMethod void myUnitTest() {
        Product2 product1                = TestHelper.createProduct2();
  
        PricebookEntry pbe1              = TestHelper.createPricebookEntry(product1.id);

        Account acct                     = TestHelper.createAccount();
        Opportunity opp                  = TestHelper.createOpportunity(acct.id);
        Contract con = TestHelper.createContract(acct.Id);
        OpportunityLineItem oppLineItem1 = TestHelper.createOpportunityLineItem(opp.id, pbe1.id); 

        con.SELLER__c='JINKO SOLAR TECHNOLOGY SDN.BHD.';
        
        }
}