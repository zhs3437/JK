public without sharing class QW_FormDetailController {

    public PageReference verify() {
        String recordId = ApexPages.currentPage().getParameters().get('userId');
        QWUser__c user = getUser(recordId);
        if (user == null) return new PageReference('/apex/QW_Error?msg=获取用户信息失败');
        else return null;
    }

    @RemoteAction
    public static QWUser__c getUser(String userId) {
        List<QWUser__c> users = [
            SELECT Id,
                   Name,
                   Region__c
            FROM QWUser__c
            WHERE Id =: userId
        ];
        if (users.size() > 0) return users[0];
        else return null;
    }

    @RemoteAction
    public static List<Account> getAccounts() {
        List<Account> account = [
            SELECT Id,
                   Name
            FROM Account
            WHERE RecordTypeId =: QW_Utils.getAccountRecordTypeId()
            AND OwnerId =: QW_Utils.getOwnerId()
            AND IsRegionAccount__c = true
        ];
        if (account.size() > 0) return account;
        else return null;
    }

    @RemoteAction
    public static Object getForm(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String userId = (String)data.get('userId');
        String id = (String)data.get('id');
        Map<String, Object> result = new Map<String, Object>();
        // TODO : ensure whether user has project permission
        QWUser__c user = getUser(userId);
        // Campare create QWUser and current user, if diffenrent, redirect to error page
        List<Project__c> forms = [
            SELECT Id,
                   Name,
                   Project_Location__c, 
                   //ProjectCode__c,
                   ProjectOwner__c,
                   ProjectPlace__c,
                   ProjcetType__c,
                   MajorInvestor__c,
                   ProjectCapacity__c,
                   //ProductionTime__c,
                   //ElectricityPrice__c,
                   EPC__c,
                   //toLabel(Priority__c),
                   ImportantLevel__c,
                   ComponentType__c,
                   ComponentSupplier__c,
                   toLabel(IsDone__c),
                   Planned_Project_Close_Date__c,
                   InstalledQuantity__c,
                   Remarks__c,
                   //Probability__c,
                   CreatedByQWUser__c,
                   RegionAccount__c,
                   RegionAccount__r.Id,
                   RegionAccount__r.Name
            FROM Project__c WHERE Id =: id
            ORDER BY CreatedDate DESC
        ];
        if (forms.size() > 0) {
            Project__c form = forms[0];
            // if (form.QWUser__c == userId || user.Region__c == 'All') {
                result.put('status', 'success');
                result.put('data', form);
            // } else {
            //     result.put('status', 'error');
            //     result.put('msg', '权限不足');
            // }
        } else {
            result.put('status', 'error');
            result.put('msg', '数据不存在');
        }

        return result;
    }

    @RemoteAction
    public static Object setForm(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String action = (String)data.get('action');
        String userId = (String)data.get('userId');
        QWUser__c user = getUser(userId);
        String id = (String)data.get('id');
        Project__c form = (Project__c) JSON.deserialize((String)JSON.serialize(data.get('form')), Project__c.Class);
        Map<String, Object> result = new Map<String, Object>();
        // TODO : ensure whether user has project permission
        // if (String.isNotBlank(id) && form.QWUser__c != userId && user.Region__c != 'All') {
        //     result.put('status', 'error');
        //     result.put('msg', '权限不足');
        // } else 
        if (action != 'new') {
            form.LastModifiedByQWUser__c = userId;
            Database.SaveResult saveResult = Database.update(form);
            result.put('status', 'success');
            result.put('id', saveResult.getId());
        } else {
            form.CreatedByQWUser__c = userId;
            form.OwnerId = QW_Utils.getOwnerId();
            Database.SaveResult saveResult = Database.insert(form);
            result.put('status', 'success');
            result.put('id', saveResult.getId());
        }

        return result;
    }

    @RemoteAction
    public static Object setAccount(String dataStr) {
        System.debug('---------->>>>>' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String action = (String)data.get('action');
        String userId = (String)data.get('userId');
        QWUser__c user = getUser(userId);
        String id = (String)data.get('id');

        Account account = (Account) JSON.deserialize((String)JSON.serialize(data.get('account')), Account.Class);
        Map<String, Object> result = new Map<String, Object>();

        if (action != 'new') {
            Database.SaveResult saveResult = Database.update(account);
            result.put('status', 'success');
            result.put('id', saveResult.getId());
        } else {
            account.RecordTypeId = QW_Utils.getAccountRecordTypeId();
            account.Country__c = 'China';
            account.Destination_State__c = 'N/A';
            account.Customer_Business_Type__c = 'EPC';
            account.Phone = '11111111111';
            account.Company_Email__c = 'it@jinkosolar.com';
            account.Website = 'www.jinko.com';
            account.OwnerId = QW_Utils.getOwnerId();

            Database.SaveResult saveResult = Database.insert(account);
            result.put('status', 'success');
            result.put('id', saveResult.getId());
        }
        
        return result;
    }

    @RemoteAction
    public static Object deleteForm(String formStr) {
        Project__c form = (Project__c) JSON.deserialize(formStr, Project__c.Class);
        return Database.delete(form) ;
    }

    @RemoteAction
    public static Account getAccount(String id) {
        List<Account> accounts = [
            SELECT Id,
                   Name
            FROM Account 
            WHERE Id =: id
            ORDER BY Name];
        if(accounts.size() > 0) return accounts[0];
        else return null;
    }

    @RemoteAction
    public static Object deleteAccoount(String acc) {//删除用户信息
        Account account = (Account) JSON.deserialize(acc, Account.Class);
        return Database.delete(account);
    }
}