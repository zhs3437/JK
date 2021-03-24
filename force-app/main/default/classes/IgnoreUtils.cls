global without sharing class IgnoreUtils {
     public IgnoreUtils() {}
    
    //这是一个trigger的控制开关
    public static Boolean isTriggerDisabled()
    {
        if(!Test.isRunningTest()){
            GlobalSetting__c globalSetting = GlobalSetting__c.getInstance();
            if (globalSetting != null && globalSetting.Ignore_Trigger__c) {
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }

}