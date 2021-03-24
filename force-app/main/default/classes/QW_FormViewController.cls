public without sharing class QW_FormViewController {
    public PageReference verify() {
        String recordId = ApexPages.currentPage().getParameters().get('userId');
        QWUser__c user = getUser(recordId);
        if (user == null) return new PageReference('/apex/QW_Error?msg=获取用户信息失败');
        else return null;
    }

    public static QWUser__c getUser(String userId) {
        List<QWUser__c> users = [
            SELECT Id,
                   Name,
                   Region__c,
                   Email__c,
                   RegionScope__c,
                   isRegionLeader__c
            FROM QWUser__c
            WHERE Id =: userId
            AND   IsActive__c = true
        ];
        if (users.size() > 0) return users[0];
        else return null;
    }

    // @RemoteAction
    // public static List<Account> inputValue(String inputValue) {
    //     System.debug('输入值--->'+inputValue);
    //     String searchAccounts = 'Select Name From Account Where Name = '+ '\'' + inputValue + '\'  ';
    //     List<Account> accounts = Database.query(searchAccounts);
    //     return accounts;
    // }

    @RemoteAction
    public static List<Project__c> getForms(String dataStr) {
        System.debug('----getForms----');
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String userId = (String)data.get('userId');
        String provinceId = (String)data.get('provinceId');
        // TODO : ensure user projects
        QWUser__c user = getUser(userId);
        String userId18 = Id.valueOf(userId);
        String regionScopeStr = String.isNotEmpty(user.RegionScope__c) ? user.RegionScope__c.replace(';', '\',\'') : '';
        String region = user.Region__c;
        String query = 'SELECT Id, Name '
                     + 'FROM Project__c '
                     + 'WHERE OwnerId = \'' + QW_Utils.getOwnerId() + '\' ';
        if (user.Region__c != 'All') {
            query += 'AND (CreatedByQWUser__c =: userId18 OR (RegionAccount__r.Province__c IN (\'' + regionScopeStr + '\') AND RegionAccount__r.Province__c != null ) ';
            if (user.isRegionLeader__c == true) query += 'OR CreatedByQWUser__r.Region__c =: region ';
            query += ') ';
        }
        if (String.isNotEmpty(provinceId)) query += 'AND RegionAccount__c =: provinceId ';
        query += 'AND RegionAccount__r.IsRegionAccount__c = true ';
        query += 'ORDER BY CreatedDate DESC';
        List<Project__c> forms = Database.query(query);
        return forms;
    }

    @RemoteAction
    public static List<Account> getAccounts() {
        System.debug('getAccounts');
        List<Account> accs = [
            SELECT Id,
                   Name 
            FROM Account 
            WHERE RecordTypeId =: QW_Utils.getAccountRecordTypeId()
            AND OwnerId =: QW_Utils.getOwnerId()
            AND IsRegionAccount__c = true];
        return accs;
    }
}