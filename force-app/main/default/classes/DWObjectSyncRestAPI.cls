/*
 * This is sync data interface from Salesforce to DW.
 * URL: /services/apexrest/DWObjectSyncRestAPI
 * Parameters: 
 * tableName -> Salesforce Object API Name
 * syncTime  -> Get System Records with SystemModstamp > syncTime (long type)
 * Label.DW_Filter_Field_API_Name_With_Object -> billingaddress,shippingaddress,otheraddress,mailingaddress
 * Label.DW_Set_Default_Page_Size -> 100
 * Label.DW_Set_MAX_Page_Size -> 200
 * Label.DW_Process_Big_Content_Field -> textarea,base64,combobox
 * Label.DW_Maximum_Number_Of_Repeat -> 1800
 * Date: 3/2021
 */
@RestResource(urlMapping='/DWObjectSyncRestAPI/*')
global without sharing class DWObjectSyncRestAPI {
    private static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    private static Integer pageSize = Integer.valueOf(Label.DW_Set_Default_Page_Size);

    @HttpGet
    global static void doGet() {
        RestRequest restReq = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');

        String tableName = restReq.params.get('tableName'); // object api name
        String syncTime = restReq.params.get('syncTime');  // if syncTime is not null, continue calling the interface
        String maxLength = restReq.params.get('maxLength'); // if maxLength = 1, return the field max length 4000, else no limit
        String pageSizeProxy = restReq.params.get('pageSize');
        Integer pageNumber = String.isNotEmpty(restReq.params.get('pageNumber')) ? Integer.valueOf(restReq.params.get('pageNumber')) : 0;
        String responseBody = '';
        
        TableObj tableObj = new TableObj();
        
        Integer records = Database.countQuery('select count() from ' + tableName);
        tableObj.totalRecords = records;

        try {
            if(String.isNotEmpty(pageSizeProxy)) {
                if(Integer.valueOf(pageSizeProxy) < Integer.valueOf(Label.DW_Set_MAX_Page_Size)) {
                    pageSize = Integer.valueOf(pageSizeProxy);
                }
            }
            if(String.isEmpty(syncTime)) {
                syncTime = String.valueOf(Datetime.now().addDays(-1).getTime());
                tableObj.syncTime = Datetime.now().addDays(-1).getTime();
            }
            List<sObject> objectRecords = Database.query(spellSQL(tableName, syncTime, pageNumber));
            // start: process the same LastModifiedDate data
            Datetime prevLastModifiedDate = null;
            Integer i = 1;
            tableObj.records = new List<sObject>();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(tableName).getDescribe().fields.getMap();
            Boolean duplicateRecord = false;
            if(objectRecords.size() > 1) {
                Datetime dtFirst = (Datetime)objectRecords[0].get('LastModifiedDate');
                Datetime dtLast = (Datetime)objectRecords[objectRecords.size() - 1].get('LastModifiedDate');

                List<sObject> objectRecordsProxy = Database.query('select Id from ' + tableName + ' where LastModifiedDate=' + dtLast.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
                if(dtFirst != dtLast && objectRecordsProxy.size() > Integer.valueOf(Label.DW_Maximum_Number_Of_Repeat)) {
                    duplicateRecord = true;
                }
            }
            for(sObject item : objectRecords) {
                if(maxLength == '1') {
                    for(Schema.SObjectField sfield : fieldMap.Values()) {
                        Schema.describeFieldResult dfield = sfield.getDescribe();
                        if(Label.DW_Filter_Field_API_Name_With_Object.contains(dfield.getName())) {
                            continue;
                        }
                        String fieldType = String.valueOf(dfield.getType()).toLowerCase();
                        if(Label.DW_Process_Big_Content_Field.contains(fieldType)) {
                            String processContent = (String)item.get(dfield.getName());
                            if(processContent != null && processContent.length() >= Integer.valueOf(Label.DW_Set_Content_MAX_Length)) {
                                item.put(dfield.getName(), processContent.substring(0, Integer.valueOf(Label.DW_Set_Content_MAX_Length)));
                            }
                        }
                    }
                }
                if(prevLastModifiedDate == null) {
                    prevLastModifiedDate = (Datetime)item.get('LastModifiedDate');
                }
                Datetime lastModifiedDate = (Datetime)item.get('LastModifiedDate');
                if(pageNumber != 0 && prevLastModifiedDate != lastModifiedDate) {
                    pageNumber = 0;
                    tableObj.syncTime = prevLastModifiedDate.getTime();
                    break;
                } else {
                    if(i <= pageSize) {
                        if(prevLastModifiedDate != lastModifiedDate && duplicateRecord) {
                            pageNumber = 0;
                            tableObj.syncTime = lastModifiedDate.getTime();
                            break;
                        }
                        tableObj.records.add(item);
                    } else {
                        if(lastModifiedDate == prevLastModifiedDate) {
                            pageNumber += 1;
                        }
                    }
                    if(prevLastModifiedDate != lastModifiedDate) {
                        prevLastModifiedDate = lastModifiedDate;
                    }
                }
                i ++;
            }
            // end 
            tableObj.pageSize = tableObj.records.size();
            if(tableObj.records.size() == objectRecords.size()) {
                pageNumber = 0;
                if(objectRecords.size() > 0) {
                    Datetime dtValue = (Datetime)tableObj.records[tableObj.records.size() - 1].get('LastModifiedDate');
                    tableObj.syncTime = dtValue.getTime();
                } else {
                    tableObj.syncTime = Long.valueOf(syncTime);
                }
                tableObj.EOF = true;
            }
            tableObj.pageNumber = pageNumber;
            if(tableObj.records.size() > 0) {
                Datetime dtValue = (Datetime)tableObj.records[tableObj.records.size() - 1].get('LastModifiedDate');
                if(pageNumber == 0) {
                    tableObj.syncTime = dtValue.getTime();
                } else if(String.isNotEmpty(syncTime)) {
                    tableObj.syncTime = Long.valueOf(syncTime);
                } else {
                    Datetime dtFirstValue = (Datetime)tableObj.records[0].get('LastModifiedDate');
                    tableObj.syncTime = dtFirstValue.getTime();
                }
            }
            responseBody = JSON.serialize(tableObj);
        } catch(Exception ex) {
            responseBody = JSON.serialize(new Map<String, Object> {
                'Status' => 'Error',
                'Error' => ex.getMessage()
            });
        }
        response.responseBody = Blob.valueOf(responseBody);    
    }

    public static String spellSQL(String tableName, String syncTime, Integer pageNumber) {
        // Get fields
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(tableName).getDescribe().fields.getMap();
        String sqlFields = '';
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.describeFieldResult dfield = sfield.getDescribe();
            if(Label.DW_Filter_Field_API_Name_With_Object.contains(dfield.getName())) {
                continue;
            }
            sqlFields += dfield.getName() + ',';
        }
        sqlFields = sqlFields.substring(0, sqlFields.length() - 1);
        String filterSQL = '';
        if(String.isNotEmpty(syncTime)) {
            Long systemModstamp = Long.valueOf(syncTime);
            syncTime = DateTime.newInstance(systemModstamp).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            filterSQL = ' where LastModifiedDate > ' + syncTime + ' ';
        }
        sqlFields = 'select ' + sqlFields + ' from ' + tableName + filterSQL + ' order by LastModifiedDate, Id asc limit ' +  (pageSize + 1) + ' offset ' + (pageSize * pageNumber);
        return sqlFields;
    }

    Class TableObj {
        public Long syncTime;
        public Boolean EOF = false;
        public Integer totalRecords;
        public Integer pageSize;
        public Integer pageNumber;
        public List<sObject> records;
    }
}