/*
 * This is sync data interface from Salesforce to DW.
 * URL: /services/apexrest/DWObjectSyncRestAPI
 * Parameters: 
 * tableName -> Salesforce Object API Name
 * syncType  -> all or upsert
 * syncTime  -> Get System Records with LastModifiedDate > syncTime (long type)
 * Date: 3/2021
 */
@RestResource(urlMapping='/DWObjectSyncRestAPI/*')
global without sharing class DWObjectSyncRestAPI {
    private static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    private static Integer pageSize = 100;

    @HttpGet
    global static void doGet() {
        RestRequest restReq = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');

        String tableName = restReq.params.get('tableName'); // object api name
        String syncType = restReq.params.get('syncType'); // all or upsert
        String syncTime = restReq.params.get('syncTime');  // if syncTime is not null, continue calling the interface
        String maxLength = restReq.params.get('maxLength'); // if maxLength = 1, return the field max length 4000, else no limit
        String pageSizeProxy = restReq.params.get('pageSize'); // if maxLength = 1, return the field max length 4000, else no limit
        String responseBody = '';
        try {
            if(String.isNotEmpty(pageSizeProxy)) {
                if(Integer.valueOf(pageSizeProxy) <= 300) {
                    pageSize = Integer.valueOf(pageSizeProxy);
                }
            }
        } catch (Exception ex) {
            pageSize = 100;
        }
        
        TableObj tableObj = new TableObj();
        
        Integer records = Database.countQuery('select count() from ' + tableName);
        tableObj.totalRecords = records;

        try {
            List<sObject> objectRecords = Database.query(spellSQL(tableName, syncType, syncTime));
            // start: process the same lastModifieddate data
            Datetime prevLastModifiedDate = null;
            Integer i = 1;
            tableObj.records = new List<sObject>();
            for(sObject item : objectRecords) {
                if(i <= pageSize) {
                    prevLastModifiedDate = (Datetime)item.get('LastModifiedDate');
                    tableObj.records.add(item);
                } else {
                    Datetime lastModifiedDate = (Datetime)item.get('LastModifiedDate');
                    if(lastModifiedDate == prevLastModifiedDate) {
                        tableObj.records.add(item);
                    } else {
                        break;
                    }
                }
                i ++;
            }
            // end 
            tableObj.pageSize = tableObj.records.size();
            if(tableObj.records.size() >= pageSize) {
                Datetime dtValue = (Datetime)tableObj.records[tableObj.records.size() - 1].get('LastModifiedDate');
                tableObj.syncTime = dtValue.getTime();
            } else {
                tableObj.EOF = true;
            }
            // Removes attributes
            responseBody = JSON.serialize(tableObj);
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
            List<Object> recordObjects = (List<Object>)results.get('records');
            for(Object obj : recordObjects) {
                Map<String, Object> objectAttributes = (Map<String, Object>)obj;
                if(maxLength == '1') {
                    for(String key : objectAttributes.keySet()) {
                        String fieldValue = String.valueOf(objectAttributes.get(key));
                        if(fieldValue != null && fieldValue.length() >= 4000) {
                            objectAttributes.put(key, (Object)(fieldValue.substring(0, 4000)));
                        }
                    }
                }
                objectAttributes.remove('attributes');
            }
            results.put('records', recordObjects);
            responseBody = JSON.serialize(results);
        } catch(Exception ex) {
            responseBody = JSON.serialize(new Map<String, Object> {
                'Status' => 'Error',
                'Error' => ex.getMessage()
            });
        }
        response.responseBody = Blob.valueOf(responseBody);    
    }

    public static String spellSQL(String tableName, String syncType, String syncTime) {
        // Get fields
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(tableName).getDescribe().fields.getMap();
        String sqlFields = '';
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.describeFieldResult dfield = sfield.getDescribe();
            if(dfield.getName() == 'billingaddress' || dfield.getName() == 'shippingaddress' || dfield.getName() == 'otheraddress' || dfield.getName() == 'mailingaddress') {
                continue;
            }
            sqlFields += dfield.getName() + ',';
        }
        sqlFields = sqlFields.substring(0, sqlFields.length() - 1);
        String filterSQL = '';
        if(syncType == 'upsert' && String.isEmpty(syncTime)) {
            syncTime = String.valueOf(Datetime.now().addDays(-1).getTime());
        }
        if(String.isNotEmpty(syncTime)) {
            Long lastModifiedDate = Long.valueOf(syncTime);
            syncTime = DateTime.newInstance(lastModifiedDate).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            filterSQL = ' where LastModifiedDate > ' + syncTime + ' ';
        }
        sqlFields = 'select ' + sqlFields + ' from ' + tableName + filterSQL + ' order by LastModifiedDate asc limit 500';
        return sqlFields;
    }

    Class TableObj {
        public Long syncTime;
        public Boolean EOF = false;
        public Integer totalRecords;
        public Integer pageSize;
        public List<sObject> records;
    }
}