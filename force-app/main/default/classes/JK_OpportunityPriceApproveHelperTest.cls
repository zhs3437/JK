/**
 * @author Miller
 * @date 2020-09-16
 * @description Test class for LATAM_ScheduledBroadcast
 */
@isTest
public class JK_OpportunityPriceApproveHelperTest {
    /**
     * @description 
     */
    @isTest
     static void testMethod1() {
        Test.startTest();
        Set<String> setGMEmailAddress = JK_OpportunityPriceApproveHelper.getGMEmailAddressByRegion('ROA');
        Test.stopTest();
        System.assert(setGMEmailAddress.size() > 0);
     }
}