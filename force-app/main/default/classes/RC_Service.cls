public abstract class RC_Service {

    public abstract String execute (Map<String, Object> paramsMap);

    protected RestRequest request;
    protected RestResponse response;

    public RC_Service init (RestRequest request, RestResponse response) {
        this.request  = request;
        this.response = response;
        return this;
    }

    private final static String get = 'GET';
    private final static String post = 'POST';
    
    // #1
    public class contract extends RC_Service {

        public override String execute (Map<String, Object> params) {
            try {
                if (this.request.httpMethod == get) return getContract(params);
                return JSON.serialize(new Map<String, Object>{
                    'status'=> 'error',
                    'msg' => 'no such method'
                });
            } catch (Exception e) {
                return JSON.serialize(new Map<String, Object>{
                    'status'=> 'error',
                    'msg' => e.getMessage()
                });
            }
        }

        public String getContract(Map<String, Object> params) {
            Boolean isCN = true;
            Map<String, Object> result = new Map<String, Object>();
            Id recordId = Id.valueOf((String)params.get('id'));
            Schema.SObjectType sobjectType = recordId.getSobjectType();
            String objectName = sobjectType.getDescribe().getName();
            List<SObject> contracts = Database.query(
                QW_Utils.getQueryBySObjectType(
                    sobjectType) + 
                    ' WHERE Id = \'' + recordId + '\'');
            if (objectName == 'Contract') objectName = 'Account';
            else if (objectName == 'Amendment__c') objectName = 'Order';
            sobjectType = Schema.getGlobalDescribe().get(objectName);
            String objectShareName = sobjectType.getDescribe().isCustom() ? objectName.replaceAll('__c$', '__Share') : objectName + 'Share';
            if (objectName == 'Account') recordId = Id.valueOf((String)contracts[0].get('AccountId'));
            else if (objectName == 'Order') recordId = Id.valueOf((String)contracts[0].get('Order__c'));
            List<SObject> shares;
            if (objectName == 'Account') shares = Database.query(
                QW_Utils.getQueryBySObjectType(
                    objectShareName) + 
                    ' WHERE AccountId = \'' + recordId + '\'');
            else if (objectName == 'Order') shares = Database.query(
                QW_Utils.getQueryBySObjectType(
                    objectShareName) + 
                    ' WHERE OrderId = \'' + recordId + '\'');
            else shares = Database.query(
                QW_Utils.getQueryBySObjectType(
                    objectShareName) + 
                    ' WHERE ParentId = \'' + recordId + '\'');
                    
            List<Object> permissions = new List<Object>();
            Set<Id> userOrGroupIds = new Set<Id>();
            for (SObject share : shares){
                userOrGroupIds.add(Id.valueOf((String)share.get('UserOrGroupId')));
            }

            Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email, Profile.Name, Department FROM User WHERE Id IN :userOrGroupIds AND IsActive = true]);
            
            Map<Id, List<GroupMember>> groupIdMembersMap = new Map<Id, List<GroupMember>>();
            Set<Id> groupUserId = new Set<Id>();
            for (GroupMember member : [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN :userOrGroupIds]) {
                groupUserId.add(member.UserOrGroupId);
                if (groupIdMembersMap.containsKey(member.GroupId)) groupIdMembersMap.get(member.GroupId).add(member);
                else groupIdMembersMap.put(member.GroupId, new List<GroupMember>{member});
            }

            String AccessLevel = 'AccessLevel';
            if (objectName == 'Account') AccessLevel = 'AccountAccessLevel';
            else if (objectName == 'Order') AccessLevel = 'OrderAccessLevel';

            Map<Id, User> memberMap = new Map<Id, User>([SELECT Id, Email, Profile.Name, Department FROM User WHERE Id IN :groupUserId AND IsActive = true]);
            String validEmailSuffix = '@jinkosolar.com';
            List<List<String>> titles = new List<List<String>>{
                new List<String>{'SOC', '财务', '法务', '物流', '技术', '销售', '销售支持'},
                new List<String>{'SOC', 'finance', 'legal', 'logistic', 'tech', 'sales', 'support'}
            };
            Integer index = objectName == 'Account' || objectName == 'Order' ? 1 : 0;
            for (SObject share : shares){
                String userOrGroupId = (String)share.get('UserOrGroupId');
                if (userMap.containsKey(userOrGroupId)) {
                    String email = userMap.get(userOrGroupId).Email;
                    String profileName = userMap.get(userOrGroupId).Profile.Name;
                    String departmentName = userMap.get(userOrGroupId).Department;
                    // email = email.contains('xiazhicn.com') ? 'gongyi.shi@jinkosolar.com' : email;
                    if (!email.contains(validEmailSuffix)) continue;
                    if (email.contains('.dev')) continue;
                    // TODO
                    // if (email == 'cn.finance@jinkosolar.com' || email == 'legal.cn@jinkosolar.com') continue;
                    String title = '';
                    if (profileName == 'China - BMO' || departmentName == 'BMO') title = titles[index][0];
                    else if (profileName == 'China - Finance' || departmentName == 'Finance') title = titles[index][1];
                    else if (profileName == 'China - Legal' || departmentName == 'Legal') title = titles[index][2];
                    else if (profileName == 'China - Logistic' || departmentName == 'Logistic') title = titles[index][3];
                    else if (profileName == 'China - Technical' || departmentName == 'Technical') title = titles[index][4];
                    else if (profileName == 'China - Sales' || departmentName == 'Sales') title = titles[index][5];
                    else if (profileName == 'China - Sales Support' || departmentName == 'Sales Support') title = titles[index][6];
                    else if (profileName == 'System Administrator') title = '系统管理员';
                    permissions.add(new Map<String, Object>{
                        'email' => email,
                        'userId' => userOrGroupId,
                        'accessLevel' => share.get(AccessLevel),
                        'rowCause' => share.get('RowCause'),
                        'title' => title
                    });
                } else if (groupIdMembersMap.containsKey(userOrGroupId)) {
                    for (GroupMember member : groupIdMembersMap.get(userOrGroupId)) {
                        if (!memberMap.containsKey(member.UserOrGroupId)) continue;
                        String email = memberMap.get(member.UserOrGroupId).Email;
                        String profileName = memberMap.get(member.UserOrGroupId).Profile.Name;
                        String departmentName = memberMap.get(member.UserOrGroupId).Department;
                        if (!email.contains(validEmailSuffix)) continue;
                        if (email.contains('.dev')) continue;
                        // TODO
                        // if (email == 'cn.finance@jinkosolar.com' || email == 'legal.cn@jinkosolar.com') continue;
                        String title = '';
                        if (profileName == 'China - BMO' || departmentName == 'BMO') title = titles[index][0];
                        else if (profileName == 'China - Finance' || departmentName == 'Finance') title = titles[index][1];
                        else if (profileName == 'China - Legal' || departmentName == 'Legal') title = titles[index][2];
                        else if (profileName == 'China - Logistic' || departmentName == 'Logistic') title = titles[index][3];
                        else if (profileName == 'China - Technical' || departmentName == 'Technical') title = titles[index][4];
                        else if (profileName == 'China - Sales' || departmentName == 'Sales') title = titles[index][5];
                        else if (profileName == 'China - Sales Support' || departmentName == 'Sales Support') title = titles[index][6];
                        else if (profileName == 'System Administrator') title = '系统管理员';
                        permissions.add(new Map<String, Object>{
                            'email' => email,
                            'userId' => member.UserOrGroupId,
                            'accessLevel' => share.get(AccessLevel),
                            'rowCause' => share.get('RowCause'),
                            'title' => title
                        });
                    }
                }
            }
            
            result.put('permission', permissions);
            result.put('status', 'success');
            return JSON.serialize(result);
        }
    }
    
    // #2
    public class comments extends RC_Service {

        public override String execute (Map<String, Object> params) {
            
            if (this.request.httpMethod == post) {
                postComments();
            }
            
            Map<String, Object> result = new Map<String, Object>();
            result.put('status', 'success');
            return JSON.serialize(result);
        }

        void postComments() {
            Map<String, Object> requestBody = (Map<String, Object>)JSON.deserializeUntyped(this.request.requestBody.toString());
            String comment = requestBody.containsKey('comment') ? (String)requestBody.get('comment') : null;
            if (String.isBlank(comment)) return;

            String communityId = null;
            String userId = (String)requestBody.get('user_sfid');
            String userEmail = (String)requestBody.get('user_email');
            String userADName = (String)requestBody.get('user_ad_name');
            Id targetUserOrGroupOrRecordId = Id.valueOf((String)requestBody.get('contract_sfid'));
            String contractFileName = (String)requestBody.get('contract_file_name');
            String contractFileVersion = (String)requestBody.get('contract_version');
            List<Object> mentionUserIds = ((List<Object>)requestBody.get('comment_mention_user_sfid'));

            SharePoint_Event__c e = new SharePoint_Event__c(
                Action_Type__c = (String)requestBody.get('action'),
                Related_User__c = userId,
                // Related_Contract__c = targetUserOrGroupOrRecordId,
                UserId__c = userId,
                UserADName__c = userADName,
                UserEmail__c = userEmail,
                ContractId__c = targetUserOrGroupOrRecordId,
                ContractFileName__c = contractFileName,
                ContractVersion__c = contractFileVersion,
                Body__c = (String)this.request.requestBody.toString(),
                Event_Datetime__c = System.now()
            );
            Map<String, Object> spFieldMapping = (Map<String, Object>) JSON.deserializeUntyped(System.Label.RC_SP_Lookup_Mapping);
            List<SObject> contracts = Database.query(
                QW_Utils.getQueryBySObjectType(
                    targetUserOrGroupOrRecordId.getSobjectType()) + 
                    ' WHERE Id = \'' + targetUserOrGroupOrRecordId + '\'');
            if (contracts.size() > 0) e.put((String)spFieldMapping.get(targetUserOrGroupOrRecordId.getSobjectType().getDescribe().getName()), targetUserOrGroupOrRecordId);
            insert e;

            ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
            input.subjectId = targetUserOrGroupOrRecordId;
            input.feedElementType = ConnectApi.FeedElementType.FEEDITEM;
            
            ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegment;
            ConnectApi.MentionSegmentInput mentionSegment;
            ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
            ConnectApi.MarkupEndSegmentInput markupEndSegment;
            
            messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
            markupBeginSegment.markupType = ConnectApi.MarkupType.PARAGRAPH;
            messageInput.messageSegments.add(markupBeginSegment);

            // From
            textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = 'From ';
            messageInput.messageSegments.add(textSegment);
            
            if (String.isNotBlank(userId)) {
                mentionSegment = new ConnectApi.MentionSegmentInput();
                mentionSegment.id = userId;
                messageInput.messageSegments.add(mentionSegment);
            } else {
                textSegment = new ConnectApi.TextSegmentInput();
                textSegment.text = userADName;
                messageInput.messageSegments.add(textSegment);
            }

            markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
            markupEndSegment.markupType = ConnectApi.MarkupType.PARAGRAPH;
            messageInput.messageSegments.add(markupEndSegment);
            markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
            markupBeginSegment.markupType = ConnectApi.MarkupType.PARAGRAPH;
            messageInput.messageSegments.add(markupBeginSegment);

            // To
            textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = 'To ';
            messageInput.messageSegments.add(textSegment);
            
            Boolean flag = true;
            for (Object mentionUserId : mentionUserIds) {
                if (mentionUserId == null) continue;
                flag = false;
                mentionSegment = new ConnectApi.MentionSegmentInput();
                mentionSegment.id = (String) mentionUserId;
                messageInput.messageSegments.add(mentionSegment);
            }

            // if true, remove To
            if (flag) messageInput.messageSegments.remove(messageInput.messageSegments.size() - 1);

            markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
            markupEndSegment.markupType = ConnectApi.MarkupType.PARAGRAPH;
            messageInput.messageSegments.add(markupEndSegment);
            markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
            markupBeginSegment.markupType = ConnectApi.MarkupType.PARAGRAPH;
            messageInput.messageSegments.add(markupBeginSegment);
            
            textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = comment;
            messageInput.messageSegments.add(textSegment);

            markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
            markupEndSegment.markupType = ConnectApi.MarkupType.PARAGRAPH;
            messageInput.messageSegments.add(markupEndSegment);

            input.body = messageInput;
            
            if (!Test.isRunningTest()) ConnectApi.ChatterFeeds.postFeedElement(communityId, input);
        }
    }

    // #3
    public class event extends RC_Service {

        public override String execute (Map<String, Object> params) {
            Map<String, Object> result = new Map<String, Object>();
            try {
                // if (this.request.httpMethod == get) return getEvent(params);
                if (this.request.httpMethod == post) return postEvent();
                return JSON.serialize(new Map<String, Object>{
                    'status'=> 'error',
                    'msg' => 'no such method'
                });
            } catch (Exception e) {
                result.put('status', 'error');
                result.put('msg', e.getMessage());
            }
            return JSON.serialize(result);
        }

        // String getEvent (Map<String, Object> params) {
        //     Map<String, Object> result = new Map<String, Object>();
        //     String contractId = (String)params.get('id');
        //     return null;
        // }

        String postEvent() {
            Map<String, Object> result = new Map<String, Object>();
            Map<String, Object> requestBody = (Map<String, Object>)JSON.deserializeUntyped(this.request.requestBody.toString());
            Map<String, Object> userMap = (Map<String, Object>)requestBody.get('user');
            Map<String, Object> contractMap = (Map<String, Object>)requestBody.get('contract');
            Id recordId = String.isNotBlank((String)contractMap.get('sfid')) ? Id.valueOf((String)contractMap.get('sfid')) : null;
            SharePoint_Event__c e = new SharePoint_Event__c(
                Action_Type__c = (String)requestBody.get('action'),
                Related_User__c = String.isNotBlank((String)userMap.get('sfid')) ? Id.valueOf((String)userMap.get('sfid')) : null,
                // Related_Contract__c = recordId,
                UserId__c = (String)userMap.get('sfid'),
                UserADName__c = (String)userMap.get('ad_name'),
                UserEmail__c = (String)userMap.get('email'),
                ContractId__c = (String)contractMap.get('sfid'),
                ContractSPId__c = (String)contractMap.get('spid'),
                ContractFileName__c = (String)contractMap.get('file_name'),
                ContractUrl__c = (String)contractMap.get('url'),
                ContractVersion__c = (String)contractMap.get('version'),
                Body__c = (String) this.request.requestBody.toString(),
                Event_Datetime__c = System.now()
            );
            Map<String, Object> spFieldMapping = (Map<String, Object>) JSON.deserializeUntyped(System.Label.RC_SP_Lookup_Mapping);
            List<SObject> contracts = Database.query(
                QW_Utils.getQueryBySObjectType(
                    recordId.getSobjectType()) + 
                    ' WHERE Id = \'' + recordId + '\'');
            if (contracts.size() > 0) e.put((String)spFieldMapping.get(recordId.getSobjectType().getDescribe().getName()), recordId);
            insert e;
            result.put('status', 'success');
            return JSON.serialize(result);
        }
    }

    public class mda extends RC_Service {
        
        public override String execute (Map<String, Object> params) {
            Map<String, Object> result = new Map<String, Object>();
            try {
                // if (this.request.httpMethod == get) return getEvent(params);
                if (this.request.httpMethod == post) return getMDA();
                return JSON.serialize(new Map<String, Object>{
                    'status'=> 'error',
                    'msg' => 'no such method'
                });
            } catch (Exception e) {
                result.put('status', 'error');
                result.put('msg', e.getMessage());
            }
            return JSON.serialize(result);
        }
        
        String getMDA() {
            Map<String, Object> result = new Map<String, Object>();
            String mdaName = this.request.headers.get('MDAID');
            
            String sql = QW_Utils.getQueryBySObjectType('Component_Task_Book__c') + 
                ' WHERE Name = :mdaName';
            sql = sql.replace('ModuleType1__c', 'ModuleType1__r.Name')
            .replace('Module_Type2__c','Module_Type2__r.Name')
            .replace('Module_Type3__c', 'Module_Type3__r.Name')
            .replace('iModule_Type1__c', 'iModule_Type1__r.Name')
            .replace('iModule_Type2__c','iModule_Type2__r.Name')
            .replace('iModule_Type3__c', 'iModule_Type3__r.Name');
            System.debug(sql);
            List<Component_Task_Book__c> mdas = Database.query(sql);
            if(mdas.size()>0){
                Component_Task_Book__c mda = mdas[0];
                ToPLMInformation toPLM = new ToPLMInformation();
                toPLM.CT1 = mda.Cell_Type1__c;
                toPLM.CT2 = mda.Cell_Type2__c;
                toPLM.CT3 = mda.Cell_Type3__c;
                toPLM.MT1 = mda.ModuleType1__r.name != null ? mda.ModuleType1__r.name : mda.iModule_Type1__r.Name;
                toPLM.MT2 = mda.Module_Type2__r.name != null ? mda.Module_Type2__r.name : mda.iModule_Type2__r.Name;
                toPLM.MT3 = mda.Module_Type3__r.name != null ? mda.Module_Type3__r.name : mda.iModule_Type3__r.Name;
                toPLM.MS1 = mda.Module_Series1__c;
                toPLM.MS2 = mda.Module_Series2__c;
                toPLM.CQ1 = mda.Cell_Quantity1__c;
                toPLM.CQ2 = mda.Cell_Quantity2__c;
                toPLM.MS3 = mda.Module_Series3__c;
                toPLM.CQ3 = mda.Cell_Quantity3__c;
                toPLM.PC = mda.Product_Certificate__c;
                toPLM.AC = mda.Additional_Certificate__c;
                toPLM.RMC = mda.Mandatory_certification__c;    
                toPLM.PT = mda.Power_Tolerance__c;
                toPLM.SV = mda.System_Voltage__c;
                toPLM.AP = mda.Additional_power__c;
                toPLM.WA = mda.Warranty__c;
                toPLM.BOM = mda.BOM__c;
                toPLM.CP = mda.Cell__c;
                toPLM.JBB = mda.Junction_Box_brand__c;
                toPLM.JBCL = mda.Junction_Box_Cable_Length__c;
                toPLM.JBC = mda.Junction_Box_Connector__c;
                toPLM.RCT = mda.Rear_cover__c;
                toPLM.RCM = mda.Rear_Cover_Material__c;
                toPLM.FGT = mda.Front_Glass__c;
                toPLM.GT = mda.Glass_Thickness__c;
                toPLM.FBSH = mda.Frame_B_side_Height__c;
                toPLM.FC = mda.Frame_Color__c;
                toPLM.FT = mda.Frame_Type__c;
                toPLM.CTOSF = mda.C_side_type_of_short_frame__c;
                toPLM.EVA = mda.EVA__C;
                toPLM.LRF = mda.LRF__c;
                toPLM.PA = mda.Package__c;
                toPLM.PT2 = mda.Project_Type__c;
                toPLM.NA = mda.Nameplate__c;
                toPLM.SM = mda.Shipping_Mark__c;
                toPLM.BEP = mda.Barcode_encoding_principle__c;
                toPLM.SR = mda.String_Ribbon__c;
                toPLM.CC = mda.Cell_Color__c;
                toPLM.CS = mda.Current_Sorting__c;
                toPLM.CSS = mda.Current_Sorting_Style__c;
                toPLM.CSS2 = mda.Color_Sorting_style__c;
                toPLM.ASMC = mda.Additional_Shipping_Mark_Color_Label__c;
                toPLM.TS = mda.Transportation_style__c;
                toPLM.PSBC = mda.On_site_monitor_by_Client_or_3rd_party__c;
                toPLM.LT = mda.Lab_tests__c;
                toPLM.PIAF = mda.Pre_shipping_Inspection_factory__c;
                toPLM.RCCR = mda.Regional_customs_clearance_request__c;
                toPLM.SAFOP = mda.Special_Approval_for_order_production__c;
                toPLM.NOTE = mda.Note__c;
                toPLM.DVITC = mda.DS_Version_in_the_Contract_Text__c;
                toPLM.DS = mda.Deviation_sheet__c;
                toPLM.MDA = mda.NAME;
                toPLM.DC = mda.Destination_Country__c;
                toPLM.CON = mda.Contract_Number__c;
                toPLM.CN = mda.Client_Name__c;
                toPLM.QQ = mda.Order_Quantities__c;
                toPLM.SDO = mda.Sales_director_opinions__c;
                toPLM.SDOS = mda.Sales_director_opinions__c;
                toPLM.TMO = mda.Technical_manager_Shanghai_Comments__c;
                toPLM.TMA = mda.Technical_manager_Shanghai__c;
                List<Component_Task_Book__c> objList2=[select id,OWNER.Phone,
                                                       lastmodifieddate,Owner.NAME,Owner.email,Order__r.name from Component_Task_Book__c where  name =: MDANAME];
               if(objList2.size()>0){
                    mda=objList2[0];
                    toPLM.ORD=mda.Order__r.name;
                    toPLM.SR2=mda.Owner.NAME;
                    toPLM.CP2=mda.OWNER.Phone;
                    toPLM.EMAIL=mda.Owner.email;
                    toPLM.SD=String.valueOf(mda.lastmodifieddate);
                }

                return JSON.serialize(toPLM);
            }else{
                return '没有数据';
            }
        }
    }

    public class ToPLMInformation{
        public String MT1{get; set;}
        public String MT2{get; set;}
        public String MT3{get; set;}
        public String CT1{get; set;}
        public String CT2{get; set;}
        public String CT3{get; set;}
        public String MS1{get; set;}
        public String MS2{get; set;}
        public String MS3{get; set;}
        public String CQ1{get; set;}
        public String CQ2{get; set;}
        public String CQ3{get; set;}
        public String PC{get; set;}
        public String AC{get; set;}
        public String RMC{get; set;}
        public String PT{get; set;}
        public String SV{get; set;}
        public String AP{get; set;}
        public String WA{get; set;}
        public String BOM{get; set;}
        public String CP{get; set;}
        public String JBB{get; set;}
        public String JBCL{get; set;}
        public String JBC{get; set;}
        public String RCT{get; set;}
        public String RCM{get; set;}
        public String FGT{get; set;}
        public String GT{get; set;}
        public String FBSH{get; set;}
        public String FC{get; set;}
        public String FT{get; set;}
        public String CTOSF{get; set;}
        public String EVA{get; set;}
        public String LRF{get; set;}
        public String PA{get; set;}
        public String PT2{get; set;}
        public String NA{get; set;}
        public String SM{get; set;}
        public String BEP{get; set;}
        public String SR{get; set;}
        public String CC{get; set;}
        public String CS{get; set;}
        public String CSS{get; set;}
        public String CSS2{get; set;}
        public String ASMC{get; set;}
        public String TS{get; set;}
        public String PSBC{get; set;}
        public String LT{get; set;}
        public String PIAF{get; set;}
        public String RCCR{get; set;}
        public String SAFOP{get; set;}
        public String NOTE{get; set;}
        public String DVITC{get; set;}
        public String DS{get; set;}
        public String ORD{get; set;}
        public String CON{get; set;}
        public String MDA{get; set;}
        public String SR2{get; set;}
        public String CP2{get; set;}
        public String EMAIL{get; set;}
        public String SD{get; set;}
        public String CN{get; set;}
        public String DC{get; set;}
        public String QQ{get; set;}
        public String SDO{get; set;} 
        public String SDOS{get; set;}
        public String SDOD{get; set;}
        public String TMO{get; set;}
        public String TMOS{get; set;}
        public String TMOD{get; set;}
        public String TMA{get; set;}
    }
}