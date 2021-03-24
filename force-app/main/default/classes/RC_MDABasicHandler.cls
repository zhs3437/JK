public without sharing class RC_MDABasicHandler extends TriggerHandler {
    public List<Component_Task_Book__c> mdaOlds;
    public List<Component_Task_Book__c> mdaNews;
    public Map<Id, Component_Task_Book__c> mdaOldMap;
    public Map<Id, Component_Task_Book__c> mdaNewMap;
    public RC_MDABasicHandler () {
        mdaOlds = new List<Component_Task_Book__c>((List<Component_Task_Book__c>) Trigger.old);
        mdaNews = new List<Component_Task_Book__c>((List<Component_Task_Book__c>) Trigger.new);
        mdaOldMap = new Map<Id, Component_Task_Book__c>();
        if (Trigger.oldMap != null) mdaOldMap.putAll((Map<Id, Component_Task_Book__c>) Trigger.oldMap);
        mdaNewMap = new Map<Id, Component_Task_Book__c>();
        if (Trigger.newMap != null) mdaNewMap.putAll((Map<Id, Component_Task_Book__c>) Trigger.newMap);
    }

    public override void beforeInsert() {
        getMaterial();
    }
    
    public override void beforeUpdate() {
        getMaterial();
    }

    // Frame_B_side_Height__c, Frame_Color__c, Module_Level__c
    private void getMaterial() {
        List<StaticResource> srs = [SELECT Id, Body FROM StaticResource WHERE Name = 'RC_MDA_Mapping' LIMIT 1];
        if (srs.size() == 0) throw new QW_Utils.QWException('MDA物料特性匹配逻辑缺失 - RC_MDABasicHandler 26');
        Map<String, Object> mdaConfig = (Map<String, Object>)JSON.deserializeUntyped(srs[0].body.toString());
        for (String field : mdaConfig.keySet()) {
            Map<String, Object> valueMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(mdaConfig.get(field)));
            mdaConfig.put(field, valueMap);
        }
        List<String> keyField = new List<String>{'Frame_B_side_Height', 'Frame_Color', 'Module_Level'};
        Map<String, Id> charcMap = new Map<String, Id>();
        for (SAP_Product__c material : (List<SAP_Product__c>)Database.query(
                QW_Utils.getQueryBySObjectType('SAP_Product__c') + 
                ' WHERE Product_Name__c <> null' + 
                ' AND (Name LIKE \'26%\' OR Name LIKE \'27%\')' +
                ' ORDER BY CreatedDate')){
            // if (material.Frame_B_side_Height__c == null || material.Frame_Color__c == null || material.Grade_Level__c == null || material.Product_Name__c == null) return;
            // String value1 = (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(material.Frame_B_side_Height__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(material.Frame_B_side_Height__c) : '';
            // String value2 = (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(material.Frame_Color__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(material.Frame_Color__c) : '';
            // String value3 = (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(material.Grade_Level__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(material.Grade_Level__c) : '';
            String value1 = material.Frame_B_side_Height__c;
            String value2 = material.Frame_Color__c;
            String value3 = material.Grade_Level__c;
            String value4 = material.Product_Name__c;
            if (value1 == null || value2 == null || value3 == null || value4 == null) continue;
            charcMap.put(value1 + value2 + value3 + value4, material.Id);
        }

        for (Component_Task_Book__c mda : mdaNews) {
            String value1 = (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(mda.Frame_B_side_Height__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(mda.Frame_B_side_Height__c) : '';
            String value2 = (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(mda.Frame_Color__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(mda.Frame_Color__c) : '';
            String value3 = (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(mda.Module_Level__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(mda.Module_Level__c) : '';
            String value41 = mda.iModule_Type1_Name__c;
            String value42 = mda.iModule_Type2_Name__c;
            String value43 = mda.iModule_Type3_Name__c;
            // if (value1 == null || value2 == null || value3 == null) throw new QW_Utils.QWException('MDA物料特性填写缺失 - RC_MDABasicHandler 55');
            if (mda.ModuleType1__c != null || mda.iModule_Type1__c != null) mda.SAP_Materiel_No1__c = charcMap.get(value1 + value2 + value3 + value41);
            if (mda.Module_Type2__c != null || mda.iModule_Type2__c != null) mda.SAP_Materiel_No2__c = charcMap.get(value1 + value2 + value3 + value42);
            if (mda.Module_Type3__c != null || mda.iModule_Type3__c != null) mda.SAP_Materiel_No3__c = charcMap.get(value1 + value2 + value3 + value43);
        }
    }
}