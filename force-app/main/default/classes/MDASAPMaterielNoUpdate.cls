public class MDASAPMaterielNoUpdate {
    public  List<Component_Task_Book__c> UpdateOppItem(Set<String> Id ,Map<String,Component_Task_Book__c> newmdaMap){
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
                    if(material.Product_Name__c =='JKM345M-72'){
                        System.debug('value1-->'+value1);
                         System.debug('value2-->'+value2);
                         System.debug('value3-->'+value3);
                         System.debug('value4-->'+value4);
                        System.debug('material.Product_Name__c-->'+material.Product_Name__c); 
                    }
                               
            if (value1 == null || value2 == null || value3 == null || value4 == null) continue;
            charcMap.put(value1 + value2 + value3 + value4, material.Id);
        }
        List<Component_Task_Book__c> mdaNews = new  List<Component_Task_Book__c>();
        mdaNews = [Select Id,ModuleType1__c,ModuleType1__r.Name,Module_Type2__c,Module_Type2__r.Name,Module_Type3__c,Module_Type3__r.Name,
                          Frame_B_side_Height__c,Frame_Color__c,Module_Level__c,SAP_Materiel_No1__c,SAP_Materiel_No2__c,SAP_Materiel_No3__c
                   From Component_Task_Book__c where Id IN:Id
                  ];
        system.debug('mdaNews-->'+mdaNews.size());
        List<Component_Task_Book__c> updateMDA = new List<Component_Task_Book__c>();
        for (Component_Task_Book__c mda : mdaNews) {
            Component_Task_Book__c newmda = new Component_Task_Book__c();
            if(newmdaMap.get(mda.id) !=null){
            newmda = newmdaMap.get(mda.id);
           String value1 = (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(newmda.Frame_B_side_Height__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(newmda.Frame_B_side_Height__c) : '';
            String value2 = (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(newmda.Frame_Color__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(newmda.Frame_Color__c) : '';
            String value3 = (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(newmda.Module_Level__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(newmda.Module_Level__c) : '';
                   
            system.debug('value1-->'+value1);
            system.debug('value2-->'+value2);
            system.debug('value3-->'+value3);
            system.debug('mda.ModuleType1__r.Name-->'+mda.ModuleType1__r.Name);
          
            // if (value1 == null || value2 == null || value3 == null) throw new QW_Utils.QWException('MDA物料特性填写缺失 - RC_MDABasicHandler 55');
            if (newmda.ModuleType1__c != null) newmda.SAP_Materiel_No1__c = charcMap.get(value1 + value2 + value3 + mda.ModuleType1__r.Name);
            if (newmda.Module_Type2__r != null) newmda.SAP_Materiel_No2__c = charcMap.get(value1 + value2 + value3 + mda.Module_Type2__r.Name);
            if (newmda.Module_Type3__r != null) newmda.SAP_Materiel_No3__c = charcMap.get(value1 + value2 + value3 + mda.Module_Type3__r.Name);
            System.debug('newmda.SAP_Materiel_No1__c-->'+newmda.SAP_Materiel_No1__c);
            updateMDA.add(newmda);
          }
        }
        return updateMDA;
        
    }
    
    public  List<Component_Task_Book__c> InsertOppItem(Set<String> Id ){
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
                    if(material.Product_Name__c =='JKM345M-72'){
                        System.debug('value1-->'+value1);
                         System.debug('value2-->'+value2);
                         System.debug('value3-->'+value3);
                         System.debug('value4-->'+value4);
                        System.debug('material.Product_Name__c-->'+material.Product_Name__c); 
                    }
                               
            if (value1 == null || value2 == null || value3 == null || value4 == null) continue;
            charcMap.put(value1 + value2 + value3 + value4, material.Id);
        }
        List<Component_Task_Book__c> mdaNews = new  List<Component_Task_Book__c>();
        mdaNews = [Select Id,ModuleType1__c,ModuleType1__r.Name,Module_Type2__c,Module_Type2__r.Name,Module_Type3__c,Module_Type3__r.Name,
                          Frame_B_side_Height__c,Frame_Color__c,Module_Level__c,SAP_Materiel_No1__c,SAP_Materiel_No2__c,SAP_Materiel_No3__c
                   From Component_Task_Book__c where Id IN:Id
                  ];
        system.debug('mdaNews-->'+mdaNews.size());
        List<Component_Task_Book__c> updateMDA = new List<Component_Task_Book__c>();
        for (Component_Task_Book__c mda : mdaNews) {
           String value1 = (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(mda.Frame_B_side_Height__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_B_side_Height')).get(mda.Frame_B_side_Height__c) : '';
            String value2 = (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(mda.Frame_Color__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Frame_Color')).get(mda.Frame_Color__c) : '';
            String value3 = (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(mda.Module_Level__c) != null ? (String) ((Map<String, Object>)mdaConfig.get('Module_Level')).get(mda.Module_Level__c) : '';
        
           
            system.debug('value1-->'+value1);
            system.debug('value2-->'+value2);
            system.debug('value3-->'+value3);
            system.debug('mda.ModuleType1__r.Name-->'+mda.ModuleType1__r.Name);
          
            // if (value1 == null || value2 == null || value3 == null) throw new QW_Utils.QWException('MDA物料特性填写缺失 - RC_MDABasicHandler 55');
            if (mda.ModuleType1__c != null) mda.SAP_Materiel_No1__c = charcMap.get(value1 + value2 + value3 + mda.ModuleType1__r.Name);
            if (mda.Module_Type2__r != null) mda.SAP_Materiel_No2__c = charcMap.get(value1 + value2 + value3 + mda.Module_Type2__r.Name);
            if (mda.Module_Type3__r != null) mda.SAP_Materiel_No3__c = charcMap.get(value1 + value2 + value3 + mda.Module_Type3__r.Name);
            System.debug('mda.SAP_Materiel_No1__c-->'+mda.SAP_Materiel_No1__c);
            updateMDA.add(mda);
        }
        if(updateMDA.size()>0){
            update updateMDA;
        }
        return updateMDA;
        
    }

}