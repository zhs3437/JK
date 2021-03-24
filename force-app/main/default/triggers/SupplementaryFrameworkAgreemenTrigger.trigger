trigger SupplementaryFrameworkAgreemenTrigger on Supplementary_Framework_Agreement__c(before update, after update, before delete) {
    if (trigger.isupdate) {
        if (trigger.isBefore) {
            
            Set<Id> oppIdSet = new Set<Id>();
            for (Supplementary_Framework_Agreement__c newOpp : (List<Supplementary_Framework_Agreement__c>)trigger.new) {
                oppIdSet.add(newOpp.Opportunity__c);
            }
            Map<Id, Opportunity> opportunityMap;
            if (oppIdSet.size() != 0) {
                opportunityMap = new Map<Id, Opportunity>([SELECT Id, Roll_up_SFA_Counts__c FROM Opportunity WHERE Id IN :oppIdSet]);
            }
            
            Profile profile = [select id, name from profile where name='System Administrator' or name = '系统管理员'];
            
            Map<Id, Supplementary_Framework_Agreement__c> oppMap = (Map<Id, Supplementary_Framework_Agreement__c>)trigger.oldMap;
            for (Supplementary_Framework_Agreement__c newOpp : (List<Supplementary_Framework_Agreement__c>)trigger.new) {
                Supplementary_Framework_Agreement__c oldOpp = oppMap.get(newOpp.Id);
                //MOU 补充Opp锁定验证
                if (newOpp.Lock__c == oldOpp.Lock__c && newOpp.Lock__c ) {//&& UserInfo.getProfileId() != profile.Id
                    newOpp.addError(Label.SupplementaryFrameworkLockException, false);
                }
                //			if (newOpp.Approval_Progress__c == oldOpp.Approval_Progress__c && newOpp.Approval_Progress__c && UserInfo.getProfileId() != profile.Id) {
                //				newOpp.addError('Business opportunities are currently under approval', false);
                //			}
                
                //MOU 补充Opp上锁
                /*if (newOpp.SOC_Dept__c != oldOpp.SOC_Dept__c || newOpp.Finance_Price_Approval_Status__c != oldOpp.Finance_Price_Approval_Status__c ||
                    newOpp.GM_approval_Status__c != oldOpp.GM_approval_Status__c || newOpp.Legal_Dept__c != oldOpp.Legal_Dept__c ||
                    newOpp.Technical_Dept_Status__c != oldOpp.Technical_Dept_Status__c) {
                        if (newOpp.SOC_Dept__c == 'Approved' && newOpp.Finance_Price_Approval_Status__c == 'Approved' && newOpp.GM_approval_Status__c == 'Approved' && newOpp.Legal_Dept__c == 'Approved' &&
                            newOpp.Technical_Dept_Status__c == 'Approved') {
                                newOpp.Lock__c = true;
                            }
                    }*/
                
                //MOU 补充Opp重置审批验证
                if (opportunityMap.get(newOpp.Opportunity__c).Roll_up_SFA_Counts__c != 1) {
                    if (newOpp.Trade_Term__c != oldOpp.Trade_Term__c || newOpp.Destination_Port__c != oldOpp.Destination_Port__c || newOpp.Seller__c != oldOpp.Seller__c ||
                        newOpp.Destination_Country__c != oldOpp.Destination_Country__c || newOpp.Account__c != oldOpp.Account__c) {
                            //字段初始化
                            newOpp.SOC_Dept__c = '';
                            newOpp.Finance_Price_Approval_Status__c = '';
                            newOpp.GM_approval_Status__c = '';
                            newOpp.Legal_Dept__c = '';
                            newOpp.Technical_Dept_Status__c = '';
                            newOpp.Technical_Dept_Comments__c = '';
                            newOpp.SOC_Dept_Comments__c = '';
                            newOpp.Price_Approval_Feedback_Comments__c = '';
                            newOpp.GM_approval_Comments__c = '';
                            newOpp.Legal_Dept_Comments__c = '';
                        }
                }
                //MOU 补充opportunity信息完整性判断
                /*
* if (newOpp.Region__c == null && newOpp.Destination_Region_Text__c == null){
* newOpp.addError('If Destination Region does not have information, please fill in Destination Region Text', false);
* }
* if (newOpp.Opportunity_Type__c == null && newOpp.Opportunity_Type_Text__c == null){
* newOpp.addError('If Opportunity Type does not have information, please fill in Opportunity Type Text', false);
* }
* if (newOpp.Sales_type__c == null && newOpp.Sales_type_Text__c == null){
* newOpp.addError('If Sales type does not have information, please fill in Sales type Text', false);
* }
* if (newOpp.Project_related_or_not__c == null && newOpp.Project_related_or_not_Text__c == null){
* newOpp.addError('If Project related or not does not have information, please fill in Project related or not Text', false);
* }
* if (newOpp.GST_Classification_Region__c == null && newOpp.GST_Classification_Region_Text__c == null){
* newOpp.addError('If GST Classification Region does not have information, please fill in GST Classification Region Text', false);
* }
* if (newOpp.Type_of_Shipping__c == null && newOpp.Type_of_Shipping_Text__c == null){
* newOpp.addError('If Type of Shipping(基地--起运港) does not have information, please fill in Type of Shipping(基地--起运港) Text', false);
* }
* if (newOpp.Close_Date__c == null && newOpp.Close_Date_Text__c == null){
* newOpp.addError('If Close Date does not have information, please fill in Close Date Text', false);
* }
* if (newOpp.Type_of_Inventory_or_Production__c == null && newOpp.Warehouse_Stock_or_Production_Text__c == null){
* newOpp.addError('If Warehouse Stock or Production does not have information, please fill in Warehouse Stock or Production Text', false);
* }
* if (newOpp.Customer_Delivery_Date__c == null && newOpp.Expected_Delivery_Date_Text__c == null){
* newOpp.addError('If Expected Delivery Date does not have information, please fill in Expected Delivery Date Text', false);
* }
* if (newOpp.Confirmed_ETD__c == null && newOpp.Estimated_Time_of_Departure_Text__c == null){
* newOpp.addError('If Estimated Time of Departure does not have information, please fill in Estimated Time of Departure Text', false);
* }
* if (newOpp.Destination_Country__c == null && newOpp.Destination_Country_Text__c == null){
* newOpp.addError('If Destination Country of Departure does not have information, please fill in Destination Country Text', false);
* }
* if (newOpp.Destination_Port__c == null && newOpp.Destination_Port_Text__c == null){
* newOpp.addError('If Destination Port does not have information, please fill in Destination Port Text', false);
* }
* if (newOpp.Departure_Factory__c == null && newOpp.Departure_Factory_Text__c == null){
* newOpp.addError('If Departure Factory does not have information, please fill in Departure Factory Text', false);
* }
* if (newOpp.Seller__c == null && newOpp.Seller_Text__c == null){
* newOpp.addError('If Seller does not have information, please fill in Seller Text', false);
* }
* if (newOpp.Warranty_On_Material_and_Workmanship__c == null && newOpp.Warranty_On_Material_and_WorkmanshipText__c == null){
* newOpp.addError('If Warranty On Material and Workmanship does not have information, please fill in Warranty On Material and WorkmanshipText', false);
* }
* if (newOpp.Warranty_Insurance__c == null && newOpp.Warranty_Insurance_Text__c == null){
* newOpp.addError('If Warranty Insurance does not have information, please fill in Warranty Insurance Text', false);
* }
* if (newOpp.Order_reason__c == null && newOpp.Order_reason_Text__c == null){
* newOpp.addError('If Order reason does not have information, please fill in Order reason Text', false);
* }
* if (newOpp.Order_Type__c == null && newOpp.Order_Type_Text__c == null){
* newOpp.addError('If Order Type does not have information, please fill in Order Type Text', false);
* }
* if (newOpp.Warehouse_or_Factory__c == null && newOpp.Warehouse_or_Factory_Text__c == null){
* newOpp.addError('If Warehouse or Factory does not have information, please fill in Warehouse or Factory Text', false);
* }
* if (newOpp.Local_Warehouse__c == null && newOpp.Local_Warehouse_Text__c == null){
* newOpp.addError('If Local Warehouse does not have information, please fill in Local Warehouse Text', false);
* }
* if (newOpp.Installation_Type__c == null && newOpp.Installation_Type_Text__c == null){
* newOpp.addError('If Installation Type does not have information, please fill in Installation Type Text', false);
* }
* if (newOpp.Lead_Source__c == null && newOpp.Lead_Source_Text__c == null){
* newOpp.addError('If Lead Source does not have information, please fill in Lead Source Text', false);
* }
* if (newOpp.Sales_1_percentage__c == null && newOpp.Sales_1_percentage_Text__c == null){
* newOpp.addError('If Sales 1 percentage does not have information, please fill in Sales 1 percentage Text', false);
* }
* if (newOpp.Sales_2_percentage__c == null && newOpp.Sales_2_percentage_Text__c == null){
* newOpp.addError('If Sales 2 percentage does not have information, please fill in Sales 2 percentage Text', false);
* }
* if (newOpp.Sales_3_percentage__c == null && newOpp.Sales_3_percentage_Text__c == null){
* newOpp.addError('If Sales 3 percentage does not have information, please fill in Sales 3 percentage Text', false);
* }
* if (newOpp.Land_Freight_China__c == null && newOpp.Land_Freight_China_Text__c == null){
* newOpp.addError('If Land Freight(China) does not have information, please fill in Land Freight(China) Text', false);
* }
* if (newOpp.Land_Freight_Oversea__c == null && newOpp.Land_Freight_Oversea_Text__c == null){
* newOpp.addError('If Land Freight(Oversea) does not have information, please fill in Land Freight(Oversea) Text', false);
* }
* if (newOpp.Warehouse_Premium__c == null && newOpp.Warehouse_Premium_Text__c == null){
* newOpp.addError('If Warehouse Premium does not have information, please fill in Warehouse Premium Text', false);
* }
* if (newOpp.Ocean_Freight__c == null && newOpp.Ocean_Freight_Text__c == null){
* newOpp.addError('If Ocean Freight does not have information, please fill in Ocean Freight Text', false);
* }
*/
            }
        }
        if(trigger.isAfter){
            if(checkRecursive.runOnce7()){
                
                
                String opid;
                Boolean flag2 = false;
                String opname;
                for (Supplementary_Framework_Agreement__c newOpp : (List<Supplementary_Framework_Agreement__c>)trigger.new) {
                    opid = newOpp.Id;
                    flag2 = newOpp.Approval_Lock__c;       
                    opname = newOpp.Name;
                }
                if(opid !=null && flag2 && !opname.contains('V1')){
                    MOUOpportunityVersionUpdateController.turnaroundMOUFiled(opid);    
                }
                
                
            }            
        }
    }
    if (trigger.isdelete) {
        
    }
}