public without sharing class QW_RedirectController {
    public PageReference redirect() {
        String errormsg = '获取信息异常';
        try {
            String code = ApexPages.currentPage().getParameters().get('code');
            Map<String, Object> userInfo = QW_Utils.getUserInfo(QW_Utils.getUserId(code));
            List<QWUser__c> users = [SELECT Id FROM QWUser__c WHERE Email__c =: (String)userInfo.get('email')];
            return new PageReference('/apex/QW_FormView?userId=' + Id.valueOf(users[0].Id));
        } catch (Exception e) {
            
            return new PageReference('/apex/QW_Error?msg=' + errormsg);
        } finally {
            QW_Utils.updateConfig();
        }
    }
}