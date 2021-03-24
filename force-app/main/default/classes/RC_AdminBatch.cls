global without sharing class RC_AdminBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    public String action;
    public Map<String, Object> config;

    // Database.executeBatch(
    //     new RC_AdminBatch(
    //         'Sync Report',
    //         new Map<String, Object>{
    //             'batchSize' => 2000,
    //             'toAddresses' => 'neo.yang@xiazhicn.com'
    //         }
    //     ), 
    //     2000
    // );

    // RC_AdminBatch schedule = new RC_AdminBatch(
    //     'Sync Report',
    //     new Map<String, Object>{
    //         'batchSize' => 500,
    //         'toAddresses' => 'neo.yang@xiazhicn.com',
    //         'syncNew' => true
    //     });
    // System.schedule(
    //     'Sync Report',
    //     '0 45 * * * ?',
    //     schedule
    // );

    global void execute(SchedulableContext sc) {
        Integer batchSize = this.config != null && this.config.get('batchSize') != null ? Integer.valueOf(this.config.get('batchSize')) : null;
        if (batchSize != null) Database.executeBatch(this, batchSize);
        else Database.executeBatch(this);
    }

    public RC_AdminBatch (String action) {
        this.action = action;
        this.config = new Map<String, Object>();
    }

    public RC_AdminBatch (String action, Map<String, Object> config) {
        this.action = action;
        this.config = config;
    }

    global Database.QueryLocator start (Database.BatchableContext bc){
        if (this.action == 'product') return getProduct();
        else if (this.action == 'Sync Report') return getSync();
        else if (this.action == 'Delete Sync Report') return getDeleteSync();
        else if (this.action == 'Sync Material') return getMaterial();
        else return null;
    }
    
    global void execute (Database.BatchableContext bc, List<SObject> records) {
        System.debug('records size' + records.size());
        if (this.action == 'product') updateRecords(records);
        else if (this.action == 'Sync Report') sync(records);
        else if (this.action == 'Delete Sync Report') deleteSync(records);
        // else if (this.action == 'Sync Material') getMaterial();
    }
    
    global void finish (Database.BatchableContext bc) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [
            SELECT Id,
                   Status,
                   NumberOfErrors,
                   JobItemsProcessed,
                   TotalJobItems,
                   CreatedBy.Email
            FROM AsyncApexJob 
            WHERE Id = :BC.getJobId()
        ];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses;
        if (this.config.containsKey('toAddresses')) toAddresses = ((String) this.config.get('toAddresses')).split('[,]');
        else toAddresses = new List<String>{a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Job ' + this.action + ' Completed : ' + a.Status);
        mail.setPlainTextBody(
            'The batch Apex job processed ' + a.TotalJobItems +
            ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if (this.action == 'Sync Report' || this.action == 'Delete Sync Report') {
            Integer syncLimit = Integer.valueOf(this.config.get('limit'));
            Integer count = Integer.valueOf(this.config.get('count'));
            Integer batchSize = this.config.get('batchSize') != null ? Integer.valueOf(this.config.get('batchSize')) : null;
            if (syncLimit <= count) return;
            this.config.put('count', count);
            RC_AdminBatch batch = new RC_AdminBatch(
                this.action,
                this.config
            );
            if (batchSize != null) Database.executeBatch(batch, batchSize);
            else Database.executeBatch(batch);
        } else if (this.action == 'Sync Material') {
            if (!this.config.containsKey('flag') || !(Boolean)this.config.get('flag')) return;
            RC_AdminBatch batch = new RC_AdminBatch(
                this.action,
                this.config
            );
            Database.executeBatch(batch);
        }
    }

    private Database.QueryLocator getProduct () {
        return Database.getQueryLocator('SELECT Id FROM Product2');
    }

    private void updateRecords (List<SObject> records) {
        update records;
    }

    private Database.QueryLocator getMaterial () {
        syncMaterial();
        return Database.getQueryLocator('SELECT Id FROM SAP_Product__c LIMIT 1');
    }

    private Database.QueryLocator getSync () {
        String mappingResource = this.config.containsKey('mappingResource') ? (String) this.config.get('mappingResource') : 'RC_Fields_Mapping';
        List<StaticResource> srs = [SELECT Id, Body FROM StaticResource WHERE Name =: mappingResource LIMIT 1];
        if (srs.size() == 0) return null;
        Integer count = this.config.containsKey('count') ? Integer.valueOf(this.config.get('count')) : 0;
        Map<String, Object> syncConfig = (Map<String, Object>) JSON.deserializeUntyped(srs[0].Body.toString());
        List<Object> syncObjects = ((List<Object>) JSON.deserializeUntyped(JSON.serialize(syncConfig.get('objects'))));
        if (syncObjects.size() <= count) return null;
        this.config.put('limit', syncObjects.size());
        this.config.put('count', count + 1);
        Map<String, Object> syncObjectConfig = (Map<String, Object>) syncObjects[count];
        Map<String, Object> syncFieldsConfig = (Map<String, Object>) ((List<Object>) JSON.deserializeUntyped(JSON.serialize(syncConfig.get('fields'))))[count];
        String targetObjectName = syncObjectConfig.keySet().iterator().next();
        this.config.put('targetObjectName', targetObjectName);
        this.config.put('syncFieldsConfig', syncFieldsConfig);
        String query = QW_Utils.getQueryBySObjectType((String) syncObjectConfig.values()[0]);
        String syncDay = DateTime.newInstance(Date.today().addDays(-1), Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
        String syncTime = DateTime.newInstance(Date.today().addDays(-1), Time.newInstance(0, 0, 0, 0)).format('hh:mm:ss.SSSZ');
        if (this.config.get('syncNew') != null && Boolean.valueOf(this.config.get('syncNew'))) query += ' WHERE LastModifiedDate > ' + syncDay + 'T' + syncTime;
        if (this.config.get('queryWhere') != null) query += (String) this.config.get('queryWhere');
        return Database.getQueryLocator(
            query
        );
    }

    private Database.QueryLocator getDeleteSync () {
        String mappingResource = this.config.containsKey('mappingResource') ? (String) this.config.get('mappingResource') : 'RC_Fields_Mapping';
        List<StaticResource> srs = [SELECT Id, Body FROM StaticResource WHERE Name =: mappingResource LIMIT 1];
        if (srs.size() == 0) return null;
        Integer count = this.config.containsKey('count') ? Integer.valueOf(this.config.get('count')) : 0;
        Map<String, Object> syncConfig = (Map<String, Object>) JSON.deserializeUntyped(srs[0].Body.toString());
        List<Object> syncObjects = ((List<Object>) JSON.deserializeUntyped(JSON.serialize(syncConfig.get('objects'))));
        if (syncObjects.size() <= count) return null;
        this.config.put('limit', syncObjects.size());
        this.config.put('count', count + 1);
        Map<String, Object> syncObjectConfig = (Map<String, Object>) syncObjects[count];
        // Map<String, Object> syncFieldsConfig = (Map<String, Object>) ((List<Object>) JSON.deserializeUntyped(JSON.serialize(syncConfig.get('fields'))))[count];
        String targetObjectName = syncObjectConfig.keySet().iterator().next();
        String sourceObjectName = (String) syncObjectConfig.values()[0];
        this.config.put('targetObjectName', targetObjectName);
        this.config.put('sourceObjectName', sourceObjectName);
        // String query = QW_Utils.getQueryBySObjectType(targetObjectName);
        String query = 'SELECT Id, ExterId__c FROM ' + targetObjectName;
        // if (this.config.get('syncNew') != null && Boolean.valueOf(this.config.get('syncNew'))) query += ' WHERE LastModifiedDate > ' + Datetime.now().addDays(-1).format();
        // if (this.config.get('queryWhere') != null) query += (String) this.config.get('queryWhere');
        query += ' WHERE Sales_Dept__c = \'Sales Oversea\'';
        return Database.getQueryLocator(
            query
        );
    }

    private void sync (List<SObject> records) {
        skipTrigger();
        String targetObjectName = (String) this.config.get('targetObjectName');
        Map<String, Object> syncFieldsConfig = (Map<String, Object>) this.config.get('syncFieldsConfig');
        SObjectType targetObjectType = Schema.getGlobalDescribe().get(targetObjectName);
        List<SObject> targets = new List<SObject>();
        for (SObject sourceObject : records) {
            SObject targetObject = targetObjectType.newSObject();
            for (String fieldName : syncFieldsConfig.keySet()) {
                Object value = !((String) syncFieldsConfig.get(fieldName)).contains('\'') ? sourceObject.get((String) syncFieldsConfig.get(fieldName)) : null;
                // if (value == null) continue;
                if (fieldName.contains('.')) {
                    if (value == null) continue;
                    String parent = fieldName.split('[.]')[0];
                    String exterField = fieldName.split('[.]')[1];
                    SObjectType parentObjectType = targetObjectType.getDescribe().fields.getMap().get(parent).getDescribe().getReferenceTo()[0];
                    SObject parentObject = parentObjectType.newSObject();
                    parentObject.put(exterField, value);
                    targetObject.putSObject(parent.replaceAll('__c$', '__r'), parentObject);
                }
                else if (((String) syncFieldsConfig.get(fieldName)).contains('\'')) targetObject.put(fieldName, ((String) syncFieldsConfig.get(fieldName)).remove('\''));
                else if (value != null && fieldName == 'Name' && String.valueOf(value).length() > 80) targetObject.put(fieldName, String.valueOf(value).left(80));
                else targetObject.put(fieldName, value);
            }
            // System.debug('Revision_Completed_SOC__c : ' + targetObject.get('Revision_Completed_SOC__c'));
            targets.add(targetObject);
        }
        Database.upsert(targets, targetObjectType.getDescribe().fields.getMap().get('ExterId__c'), true);
    }

    private void deleteSync (List<SObject> records) {
        skipTrigger();
        String targetObjectName = (String) this.config.get('targetObjectName');
        String sourceObjectName = (String) this.config.get('sourceObjectName');
        Map<Id, Id> existIdRecordIdMap = new Map<Id, Id>();
        for (SObject targetRecord : records) {
            Id existId = (Id)targetRecord.get('ExterId__c');
            if (existId != null) existIdRecordIdMap.put(existId, (Id)targetRecord.get('Id'));
        }
        Set<Id> existIds = existIdRecordIdMap.keySet();
        Map<Id, SObject> sourceRecordMap = new Map<Id, SObject>(Database.query(
            // QW_Utils.getQueryBySObjectType(sourceObjectName)
            'SELECT Id FROM ' + sourceObjectName + ' WHERE Id IN: existIds'
        ));
        Set<Id> sourceIds = sourceRecordMap.keySet();
        Set<Id> deleteIds = new Set<Id>();
        for (Id existId : existIds) {
            if (!sourceIds.contains(existId)) deleteIds.add(existIdRecordIdMap.get(existId));
        }
        Database.delete(new List<Id>(deleteIds), false);
    }

    private void skipTrigger () {
        TriggerHandler.bypass('RC_ProjectBasicHandler');
        TriggerHandler.bypass('RC_ProjectGrossMarginHandler');
        TriggerHandler.bypass('RC_ProjectComponentBasicHandler');
        TriggerHandler.bypass('RC_ProjectComponentGrossMarginHandler');
        TriggerHandler.bypass('RC_ContractBasicHandler');
        TriggerHandler.bypass('RC_ContractGrossMarginHandler');
        TriggerHandler.bypass('RC_ContractComponentBasicHandler');
        TriggerHandler.bypass('RC_ContractComponentGrossMarginHandler');
    }

    // Sync SAP Product
    // @future(callout=true)
    public void syncMaterial() {
        Decimal count = this.config.containsKey('count') ? (Decimal) this.config.get('count') : 0;
        System.debug('count :' + count);
        List<SAP_Product__c> materials = new List<SAP_Product__c>();
        RC_ComCrmCrmMaterialsData.HTTPS_Port tool = new RC_ComCrmCrmMaterialsData.HTTPS_Port();
        tool.timeout_x = 120000;
        RC_ComCrmCrmMaterialsData.DT_MaterialsData_Response result = tool.SI_CRM2ECC_MaterialsData_Out(null);
        if (result.ET_MODMAT == null || result.ET_MODMAT.size() == 0) {
            this.config.put('flag', false);
            throw new QW_Utils.QWException('material null: count ' + count);
        }
        this.config.put('count', count + 1);
        Set<String> validCHR = new Set<String>{'T001', 'T002', 'T003'};
        List<RC_ComCrmCrmMaterialsData.ET_MODMAT_element> rcemelist = result.ET_MODMAT;
        List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element> rcemechrctlist = result.ET_MODMATCHRCT;
        Map<String,List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element>> rcemechrctMaps = new Map<String,List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element>>();
        List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element> newrcemechrctlist;
        if(rcemechrctlist != null && rcemechrctlist.size()>0){
            for(RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element rcemechrct : rcemechrctlist){
                newrcemechrctlist = new List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element>();
                if (!validCHR.contains(rcemechrct.ATNAM)) continue;
                if(rcemechrctMaps.get(rcemechrct.MATNR) != null){
                    newrcemechrctlist = rcemechrctMaps.get(rcemechrct.MATNR);
                    newrcemechrctlist.add(rcemechrct);
                }else{
                    newrcemechrctlist.add(rcemechrct);
                }
                rcemechrctMaps.put(rcemechrct.MATNR,newrcemechrctlist);
            }
        }
        for(RC_ComCrmCrmMaterialsData.ET_MODMAT_element rceme : rcemelist){
            SAP_Product__c material = new SAP_Product__c();
            String matnr = rceme.MATNR.remove(' ');
            material.Name = matnr;
            material.Product_Code__c = matnr;
            material.Product_Name__c = rceme.BISMT;
            material.Product_Description__c = rceme.MAKTX;
        
            if(rcemechrctMaps.get(rceme.MATNR) != null){
                List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element> newrcemelist2 = rcemechrctMaps.get(rceme.MATNR);
                transformSapProduct(material,newrcemelist2,rceme.MATNR);
            }
            materials.add(material);
        }
        System.debug('materials ++++' + materials.size());
        if(materials.size()>0){
            SObjectType targetObjectType = Schema.getGlobalDescribe().get('SAP_Product__c');
            Database.upsert(materials, targetObjectType.getDescribe().fields.getMap().get('Product_Code__c'), true);//DML
            
            // log update sf ids and success count
            // for(SAP_Product__c sapProd : materials){
            //     log.SuccessIDs__c += 'update:' + sapProd.Id + ' & material no:' + sapProd.Product_Code__c + ' / ';
            // }
            // log.SuccessCount__c += materials.size();
        }
    }

    // insert log lst and clear log lst
    // public static void uploadLog( List<Log__c> lst_log){
    //     try{
    //         if(lst_log.size()>0){
    //             insert lst_log;
    //             lst_log = new List<Log__c>();
    //         }
    //     }catch(Exception ex){
    //         System.debug('----------> '+ex.getMessage());
    //     }
    // }
  
    // by using crm sap product and sap product
    public static void transformSapProduct(SAP_Product__c materials, List<RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element> rcemechrctlist,String matnr){
        Boolean flag_T001 = false;
        Boolean flag_T002 = false;
        Boolean flag_T003 = false;
        for(RC_ComCrmCrmMaterialsData.ET_MODMATCHRCT_element rcemechrct : rcemechrctlist){
            if (rcemechrct.ATNAM == 'T001' && !flag_T001){
                materials.Frame_B_side_Height__c = rcemechrct.ATWRT;
                flag_T001 = true;
            } else if (rcemechrct.ATNAM == 'T002' && !flag_T002){
                materials.Frame_Color__c = rcemechrct.ATWRT;
                flag_T002 = true;
            } else if (rcemechrct.ATNAM == 'T003' && !flag_T003){
                materials.Grade_Level__c = rcemechrct.ATWRT;
                flag_T003 = true;
            }
            if (flag_T001 && flag_T002 && flag_T003) return;
        }
        if (!flag_T001) materials.Frame_B_side_Height__c = null;
        if (!flag_T002) materials.Frame_Color__c = null;
        if (!flag_T003) materials.Grade_Level__c = null;
    }
}