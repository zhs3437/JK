global without sharing class RC_NonStandardOverseaController {
    global RC_NonStandardOverseaController () {}
    global RC_NonStandardOverseaController (ApexPages.StandardController stdController) {} 

    @RemoteAction
    global static Object init(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        Map<String, Object> spFieldMapping = (Map<String, Object>) JSON.deserializeUntyped(System.Label.RC_SP_Lookup_Mapping);
        Id recordId = Id.valueOf((String)data.get('id'));
        SObject contract = Database.query(
            QW_Utils.getQueryBySObjectType(
                recordId.getSObjectType()) + 
                ' WHERE Id = \'' + recordId + '\'')[0];
        
        Map<Id, SObject> approvalMap = new Map<Id, SObject>(Database.query(
            QW_Utils.getQueryBySObjectType(ProcessInstance.getSObjectType()) +
            ' WHERE TargetObjectId = \'' + recordId + '\''
        ));
        String ids = '\'\'';
        for (Id approvalId : approvalMap.keySet()) {
            if (String.isNotEmpty(ids)) ids += ',';
            ids += '\'' + approvalId + '\'';
        }
        return new Map<String, Object>{
            'contract' => contract,
            'events' => Database.query(
                QW_Utils.getQueryBySObjectType(
                    SharePoint_Event__c.getSObjectType()) + 
                    ' WHERE ' + (String)spFieldMapping.get(recordId.getSobjectType().getDescribe().getName()) + ' = \'' + recordId + '\'' + 
                    ' ORDER BY Event_Datetime__c DESC'),
            'owner' => Database.query(
                QW_Utils.getQueryBySObjectType(
                    User.getSObjectType()) + 
                    ' WHERE Id = \'' + UserInfo.getUserId() + '\'')[0],
            'approvals' => approvalMap.values(),
            'approvalItem' => Database.query(
                QW_Utils.getQueryBySObjectType(ProcessInstanceNode.getSObjectType()) +
                ' WHERE ProcessInstanceId IN (' + ids + ')'
            ),
            'user' => Database.query(
                QW_Utils.getQueryBySObjectType(
                    User.getSObjectType()) + 
                    ' WHERE Id = \'' + UserInfo.getUserId() + '\'')[0]
        };
    }

    @RemoteAction
    global static Object confirmRevise(String dataStr) {
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        Id recordId = Id.valueOf((String)data.get('id'));
        SObject contract = recordId.getSObjectType().newSObject(recordId);
        contract.put('Id', recordId);
        User currentUser = [
            SELECT Id, 
                   Profile.Name,
                   Department
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        String profileName = currentUser.Profile.Name;
        String departmentName = currentUser.Department;
        if (profileName == 'China - BMO' || departmentName == 'BMO') contract.put('Revision_Completed_SOC__c', true);
        else if (profileName == 'China - Finance' || departmentName == 'Finance') contract.put('Revision_Completed_Finance__c', true);
        else if (profileName == 'China - Legal' || departmentName == 'Legal') contract.put('Revision_Completed_Legal__c', true);
        else if (profileName == 'China - Logistic' || departmentName == 'Logistic') contract.put('Revision_Completed_Logistics__c', true);
        else if (profileName == 'China - Technical' || departmentName == 'Technical') contract.put('Revision_Completed_Technical__c', true);
        // else if (profileName == 'System Administrator') contract.put('Revision_Completed_SOC__c', true);
        else throw new QW_Utils.QWException('无操作权限');
        update contract;
        
        return new Map<String, Object>{
            'status' => 'success',
            'message' => 'confirm revise success'
        };
    }

    @RemoteAction
    global static Object confirmVersion(String dataStr) {
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        Id recordId = Id.valueOf((String)data.get('id'));
        Map<String, Object> spFieldMapping = (Map<String, Object>) JSON.deserializeUntyped(System.Label.RC_SP_Lookup_Mapping);
        SObject contract = recordId.getSObjectType().newSObject(recordId);
        User currentUser = [
            SELECT Id, 
                   Profile.Name,
                   Department 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        String profileName = currentUser.Profile.Name;
        String departmentName = currentUser.Department;
        if (profileName == 'China - Legal' || departmentName == 'Legal') contract.put('File_Version_Confirmed__c', true);
        else if (profileName == 'System Administrator') contract.put('File_Version_Confirmed__c', true);
        else throw new QW_Utils.QWException('无操作权限');
        update contract;
        SharePoint_Event__c e = new SharePoint_Event__c(
            Action_Type__c = 'confirm',
            Related_User__c = UserInfo.getUserId(),
            UserId__c = UserInfo.getUserId(),
            ContractId__c = recordId,
            Event_Datetime__c = System.now()
        );
        e.put((String)spFieldMapping.get(recordId.getSobjectType().getDescribe().getName()), recordId);
        insert e;
        return new Map<String, Object>{
            'status' => 'success',
            'message' => 'confirm version success'
        };
    }

    @RemoteAction
    global static Object startJoint(String dataStr) {
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        Id recordId = Id.valueOf((String)data.get('id'));
        SObject contract = Database.query(
            QW_Utils.getQueryBySObjectType(
                recordId.getSObjectType()) + 
                ' WHERE Id = \'' + recordId + '\'')[0];
        User currentUser = [
            SELECT Id, 
                   Profile.Name 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        String profileName = currentUser.Profile.Name;
        Decimal reviewTimes = contract.get('Joint_Review_Times__c') != null ? (Decimal)contract.get('Joint_Review_Times__c') : 0;
        Boolean versionConfirmed = (Boolean)contract.get('File_Version_Confirmed__c');
        contract.put('Joint_Review_Times__c', reviewTimes);
        if (reviewTimes == 0 || versionConfirmed) contract.put('Joint_Review_Times__c', reviewTimes + 1);
        else if (reviewTimes == 0 || versionConfirmed) contract.put('Joint_Review_Times__c', reviewTimes + 1);
        else if (reviewTimes == 0 || versionConfirmed) contract.put('Joint_Review_Times__c', reviewTimes + 1);
        // if (profileName != 'China - Sales' && profileName != 'China - Sales Support') throw new QW_Utils.QWException('无操作权限');
        
        contract.put('Revision_Completed_SOC__c', false);
        contract.put('Revision_Completed_Finance__c', false);
        contract.put('Revision_Completed_Legal__c', false);
        contract.put('Revision_Completed_Logistics__c', false);
        contract.put('Revision_Completed_Technical__c', false);
        contract.put('File_Version_Confirmed__c', false);
        update contract;
        return new Map<String, Object>{
            'status' => 'success',
            'message' => 'start joint review success'
        };
    }

    @RemoteAction
    global static Object deleteFile(String dataStr) {
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        Id recordId = Id.valueOf((String)data.get('id'));
        String fileName = (String)data.get('fileName');
        SObject event = Database.query(
            QW_Utils.getQueryBySObjectType(
                recordId.getSObjectType()) + 
                ' WHERE Id = \'' + recordId + '\'')[0];
        List<SObject> events = Database.query(
            QW_Utils.getQueryBySObjectType(
                recordId.getSObjectType()) + 
                ' WHERE ContractSPId__c = \'' + (String) event.get('ContractSPId__c') + '\'' +
                ' AND Id != \'' + recordId + '\'');
        User currentUser = [
            SELECT Id, 
                   Profile.Name,
                   Department
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        String profileName = currentUser.Profile.Name;
        String departmentName = currentUser.Department;
        // if (profileName == 'China - Sales Support' || departmentName == 'Sales Support') System.debug('Sales Support');
        // else if (profileName == 'System Administrator') System.debug('System Administrator');
        // else throw new QW_Utils.QWException('无操作权限');
        
        for (SObject e : events) {
            e.put('IsActive__c', false);
            e.put('ContractFileName__c', fileName);
            e.put('ContractUrl__c', 'http://spcn.jinkosolar.com:82/JinKoDoc/' + fileName);
        }
        update events;
        
        event.put('IsActive__c', false);
        event.put('ContractFileName__c', fileName);
        RC_NonStandardOverseaController.deleteFileByEvent(JSON.serialize(event));
        event.put('ContractUrl__c', 'http://spcn.jinkosolar.com:82/JinKoDoc/' + fileName);
        update event;
        
        return new Map<String, Object>{
            'status' => 'success',
            'message' => 'delete success'
        };
    }

    @future(callout=true)
    global static void deleteFileByEvent (String eventStr) {
        Map<String, Object> event = (Map<String, Object>) JSON.deserializeUntyped(eventStr);
        System.debug(event);
        Map<String, Object> params = new Map<String, Object>{
            'sfid' => event.get('ContractId__c'),
            'spid' => event.get('ContractSPId__c'),
            'owner_sfid' => event.get('UserId__c'),
            'owner_email' => event.get('UserEmail__c'),
            'file_name' => event.get('ContractFileName__c'),
            'related_user' => new List<Object>(),
            'url' => event.get('ContractUrl__c')
        };
        
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint('http://spcn.jinkosolar.com:8000/JinKo_Service.asmx/EditContract');
        request.setBody(JSON.serialize(params));
        HttpResponse response = new Http().send(request);
    }
}