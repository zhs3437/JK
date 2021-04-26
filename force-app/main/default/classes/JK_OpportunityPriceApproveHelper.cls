/**
 * @author Miller Zhao
 * @date 2021-04-22
 * @description This class is used to get opportunity price approver
 */
public class JK_OpportunityPriceApproveHelper {

    /**
     * @param region region name
     * @return region GM Email Address set
     * @description get region GM Email Address by region name
     */
    public static Set<String> getGMEmailAddressByRegion(String region){
        return getEmailAddressByRegionAndRole(region, 'GM');
    }

    /**
     * @param region region name
     * @return region GM Email Address set
     * @description get region GM Email Address by region name
     */
    public static Set<String> getEmailAddressByRegionAndRole(String region, String role){
        Set<String> setEmailAddress = new Set<String>();
        try{
            if(String.isBlank(region) && String.isBlank(role)) return null;
            for(Region_Approver__mdt objRegionApproverMDT : [select Email__c
                                                                from Region_Approver__mdt 
                                                                where Active__c = true
                                                                AND Role__c = : role
                                                                AND Region__c =: region]){
                if(String.isNotBlank(objRegionApproverMDT.Email__c)){
                    setEmailAddress.addAll(objRegionApproverMDT.Email__c.split(','));
                }
            }
        }catch(Exception e){
            //error log
        }
        return setEmailAddress;
    }
}
