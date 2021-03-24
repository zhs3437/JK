/*
 * This interface is used to get obejct with fields details for DW system.
 * URL: /services/apexrest/DWObjectDetailsRestAPI
 * Date: 3/2021
 */
@RestResource(urlMapping='/DWObjectDetailsRestAPI/*')
global without sharing class DWObjectDetailsRestAPI {
    private static List<String> AllObjectAPINames = new List<String>{'Account', 'Contract', 'Contact', 'Opportunity', 'OpportunityLineItem', 'Order', 'Amendment__c', 'Amendment_Order_Product__c', 'Amendment_Payment__c', 'Payment__c', 'User', 'Quote', 'Lead', 'leanx__pm_Project__c', 'Product_Detail__c', 'OrderItem'};
    
    @HttpGet
    global static void doGet() {
        RestRequest restReq = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');
        List<ObjInfo> Objs = new List<ObjInfo>();
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String objApiName : AllObjectAPINames){
            ObjInfo obj = new ObjInfo();
            obj.objectLabel = schemaMap.get(objApiName).getDescribe().label;
            obj.objectApiName = objApiName;
            obj.fields = new List<FieldInfo>();
            // Get fields
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objApiName).getDescribe().fields.getMap();
            for(Schema.SObjectField sfield : fieldMap.Values()) {
                Schema.describeFieldResult dfield = sfield.getDescribe();
                FieldInfo fieldItem = new FieldInfo();
                fieldItem.fieldLabel = dfield.getlabel();
                fieldItem.fieldApiName = dfield.getname();
                fieldItem.fieldHelpText = dfield.getInlineHelpText() != null?dfield.getInlineHelpText():'';
                fieldItem.fieldLength = 255;
                fieldItem.IsStandard = !dfield.isCustom();
                //field type:String/Integer/Decimal/Textarea/Reference(Id)/Datetime/Date/Picklist/Id
                fieldItem.fieldType = String.valueOf(dfield.getType()).toLowerCase();
                String picklistValues = '';
                if(fieldItem.fieldType == 'textarea' || fieldItem.fieldType == 'base64' || fieldItem.fieldType == 'combobox') {
                        fieldItem.fieldLength = dfield.getLength() > 4000 ? 4000 : dfield.getLength();
                }
                if(fieldItem.fieldType == 'picklist' || fieldItem.fieldType == 'multipicklist'){
                    for(Schema.PicklistEntry picklistEntry : dfield.getPicklistValues()){
                        picklistValues += picklistEntry.getValue() + ';';
                    }
                    if(picklistValues.length() > 0){
                        picklistValues = picklistValues.substring(0, picklistValues.length()-1); 
                        if(picklistValues.length() > 4000) {
                            picklistValues = picklistValues.substring(0, 4000); 
                        }
                        fieldItem.fieldLength = picklistValues.length();
                    }
                }
                fieldItem.picklistValues = picklistValues;
                obj.fields.add(fieldItem);
            }
            Objs.add(obj);
        }
        response.responseBody = Blob.valueOf(JSON.Serialize(Objs));    
    }
    
    Class ObjInfo {
        public String objectLabel;
        public String objectApiName;
        public List<FieldInfo> fields;
    }
    
    Class FieldInfo{
        public String fieldLabel;
        public String fieldApiName;
        public String fieldType;
        public String fieldHelpText;
        public Integer fieldLength;
        public Boolean IsStandard;
        public String picklistValues;
    }
}