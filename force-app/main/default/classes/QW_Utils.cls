public without sharing class QW_Utils {
    public static String accessToken;
    public static Boolean flag = false;
    public static QWConfig__c config;
    public static Long timeStamp = Datetime.now().getTime();

    public class QWException extends Exception {}

    public static String getAccessToken() {
        if (String.isNotBlank(QW_Utils.accessToken)) return QW_Utils.accessToken;
        config = QWConfig__c.getValues('Project');
        if (config == null) return null;
        if (config.LastModifyTimeStamp__c != null && 
            config.ExpireTime__c != null && 
            config.AccessToken__c != null && 
            config.LastModifyTimeStamp__c + config.ExpireTime__c * 1000 > timeStamp) {
            QW_Utils.accessToken = config.AccessToken__c;
            return config.AccessToken__c;
        }
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=' + config.get('Corpid__c') + '&corpsecret=' + config.get('Corpsecret__c'));
        HttpResponse response = new Http().send(request);
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        config.AccessToken__c = (String)body.get('access_token');
        config.ExpireTime__c = (Integer)body.get('expires_in');
        config.LastModifyTimeStamp__c = timeStamp;
        QW_Utils.flag = true;
        // updateConfig(JSON.serialize(config));
        QW_Utils.accessToken = (String)body.get('access_token');
        return QW_Utils.accessToken;
    }

    // @future
    public static void updateConfig() {
        if (QW_Utils.flag) update config;
    }

    public static Id getOwnerId() {
        return Id.valueOf((String)QWConfig__c.getValues('Project').get('OwnerId__c'));
    }

    public static Id getAccountRecordTypeId() {
        return Id.valueOf((String)QWConfig__c.getValues('Project').get('AccountRecordTypeId__c'));
    }

    public static Id getProjectRecordTypeId() {
        return Id.valueOf((String)QWConfig__c.getValues('Project').get('ProjectRecordTypeId__c'));
    }
    
    public static String getUserId(String code) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=' + getAccessToken() + '&code=' + code);
        HttpResponse response = new Http().send(request);
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        return (String)body.get('UserId');
    }
    
    public static Map<String, Object> getUserInfo(String userId) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token=' + getAccessToken() + '&userid=' + userId);
        HttpResponse response = new Http().send(request);
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        return body;
    }

    public static SObject transferDataToObject(Id fromId, String to, String fieldSetName, Map<String, String> specialMapping) {
        SObjectType toSObject = Schema.getGlobalDescribe().get(to);
        SObjectType fromSObject = fromId.getSobjectType();
        Schema.FieldSet fromFields = fromSObject.getDescribe().fieldSets.getMap().get(fieldSetName);
        String query = getQueryByFieldSet(fromSObject, fieldSetName);
        query += ' WHERE Id = \'' + fromId + '\'';
        SObject newRecord = toSObject.newSObject();
        for (SObject oldRecord : Database.query(query)) {
            for (Schema.FieldSetMember f : fromFields.getFields()) {
                String fieldPath = f.getFieldPath();
                if (specialMapping.containsKey(fieldPath)) newRecord.put(specialMapping.get(fieldPath), oldRecord.get(fieldPath));
                else newRecord.put(fieldPath, oldRecord.get(fieldPath));
            }
            newRecord.Id = null;
            System.debug(newRecord);
            break;
        }
        return newRecord;
    }

    public static String getQueryByFieldSet(SObjectType st, String fieldSetName, String fieldOthers) {
        Schema.FieldSet fromFields = st.getDescribe().fieldSets.getMap().get(fieldSetName);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fromFields.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        if (String.isNotBlank(fieldOthers)) query += fieldOthers;
        query += 'Id FROM ' + String.valueOf(st.getDescribe().getName());
        return query;
    }

    public static String getQueryByFieldSet(SObjectType st, String fieldSetName) {
        return QW_Utils.getQueryByFieldSet(st, fieldSetName, null);
    }

    public static String dateToString (Date day) {
        String dateStr;
        if (day != null) {
            dateStr = String.valueOf(day.year()) + '-' + 
                      String.valueOf(day.month()).leftPad(2, '0') + '-' + 
                      String.valueOf(day.day()).leftPad(2, '0');
        }
        return dateStr;
    }

    public static String getQueryBySObjectType(SObjectType st){
        return getQueryBySObjectType(st, null);
    }
    public static String getQueryBySObjectType(String sObjectName){
        return getQueryBySObjectType(sObjectName, null);
    }

    public static String getQueryBySObjectType(String sObjectName, List<String> exFields){
        return getQueryBySObjectType(Schema.getGlobalDescribe().get(sObjectName), exFields);
    }
    
    public static String getQueryBySObjectType(SObjectType st, List<String> exFields){
        String query = 'SELECT ';
        Map<String, Schema.SObjectField> fieldMap = st.getDescribe().fields.getMap();
        Set<String> skipFields = new Set<String>{'Id', 'BillingAddress', 'ShippingAddress', 'OtherAddress', 'MailingAddress', 'Address'};
        for (Schema.SObjectField field : fieldMap.values()){
            String fieldName = field.getDescribe().getName();
            if (skipFields.contains(fieldName)) continue;
            query += fieldName + ', ';
        }
        if (exFields != null) for (String fieldName : exFields) query += fieldName + ', ';
        query += 'Id FROM ' + String.valueOf(st.getDescribe().getName());
        return query;
    }

    public static Boolean permssionSetCheck(Id userId, String permissionName) {
        List<PermissionSetAssignment> psas = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :userId];
        Boolean flag = false;
        for (PermissionSetAssignment psa : psas) {
            if (permissionName == psa.PermissionSet.Name) flag = true;
        }
        return flag;
    }

    public static void insertPermissionSetAssignmentByProfile (String permissionName, String profileName) {
        if (String.isBlank(profileName) || String.isBlank(permissionName)) throw new QW_Utils.QWException('分配权限集异常：参数无效');
        List<User> users = [SELECT Id FROM User WHERE Profile.Name LIKE :profileName AND IsActive = true];
        List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE Name LIKE :permissionName];
        List<PermissionSetAssignment> psas = new List<PermissionSetAssignment>();
        for (User user : users) {
            for (PermissionSet p : ps) {
                psas.add(new PermissionSetAssignment(
                    AssigneeId = user.Id,
                    PermissionSetId = p.Id
                )); 
            }
        }

        insert psas;
    }

    public static void shareRecordsToUser (Set<Id> recordIds, User user) {
        List<SObject> shares = new List<SObject>();
        for (Id recordId : recordIds) {
            SObject share = QW_Utils.shareRecordToUser(recordId, user);
            if (share != null) shares.add(share);
        }

        insert shares;
    }

    public static SObject shareRecordToUser (Id recordId, User user) {
        Schema.SObjectType sobjectType = recordId.getSobjectType();
        String objectName = sobjectType.getDescribe().getName();
        List<SObject> records = Database.query(
            QW_Utils.getQueryBySObjectType(
                objectName) + 
                ' WHERE Id = \'' + recordId + '\'');
        if (records.size() == 0 || (Id) records[0].get('OwnerId') == user.Id) return null;
        String objectShareName = sobjectType.getDescribe().isCustom() ? objectName.replaceAll('__c$', '__Share') : objectName + 'Share';
        Schema.SObjectType sobjectShareType = Schema.getGlobalDescribe().get(objectShareName);
        List<SObject> shares = Database.query(
            QW_Utils.getQueryBySObjectType(
                objectShareName) + 
                ' WHERE ParentId = \'' + recordId + '\'' +
                ' AND UserOrGroupId = \'' + user.Id + '\'');
        if (shares.size() > 0) return null;
        SObject share = sobjectShareType.newSObject();
        share.put('AccessLevel', 'Edit');
        share.put('ParentId', recordId);
        share.put('UserOrGroupId', user.Id);
        share.put('RowCause', 'Manual');
        return share;
    }
}