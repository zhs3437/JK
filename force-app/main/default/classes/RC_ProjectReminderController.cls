public without sharing class RC_ProjectReminderController {
    @RemoteAction
    public static Object init(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String id = (String)data.get('id');
        Map<Id, SObject> approvalMap = new Map<Id, SObject>(Database.query(
            QW_Utils.getQueryBySObjectType(ProcessInstance.getSObjectType()) +
            ' WHERE TargetObjectId = \'' + id + '\''
        ));
        String ids = '\'\'';
        for (Id approvalId : approvalMap.keySet()) {
            if (String.isNotEmpty(ids)) ids += ',';
            ids += '\'' + approvalId + '\'';
        }
        return new Map<String, Object>{
            'project' => [
                SELECT Id,
                       Name,
                       Stage__c,
                       RecordType.DeveloperName,
                       Total_Power_W__c,
                       GM_Approval__c
                FROM leanx__pm_Project__c 
                WHERE Id = :id
            ][0],
            'payments' => Database.query(
                QW_Utils.getQueryBySObjectType(Payment__c.getSObjectType()) +
                ' WHERE China_Project__c = \'' + id + '\''
            ),
            'approvals' => approvalMap.values(),
            'approvalItem' => Database.query(
                QW_Utils.getQueryBySObjectType(ProcessInstanceNode.getSObjectType()) +
                ' WHERE ProcessInstanceId IN (' + ids + ')'
            ),
            'items' => [
                SELECT Id,
                       Power_W__c,
                       Name,
                       IsMDAPass__c
                FROM leanx__pm_ProjectMember__c
                WHERE leanx__Project__c = :id
            ]};
    }
}