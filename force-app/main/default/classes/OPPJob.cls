/*
 *  Create by Snake 
 *  批量处理发货信息。
 */

global with sharing class OPPJob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{  
   
public List<Opportunity> olst=new List<Opportunity>();

    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
        String xx;
        String yy;
         String zz;
           String Query;
                Query = 'SELECT ID,Name, OwnerId,Owner.Name,Owner.BMO_specialist__r.Name,AccountId,Account.SAP_External_ID__c,Actual_Sales_Name__c,Contract_No__c, Sales_1__c,Sales_1_percentage__c,Sales_2__c,Sales_2_percentage__c,Sales_3__c,Sales_3_percentage__c,StageName,Probability, Lost_Reason__c,Trade_Term__c,Original_Owner_BD_MG__c, Total_Quantity__c,IsNDA__c,Region__c,recordtype.name,Opportunity_Type__c,CloseDate,Order_Type__c,Order_reason__c,Total_Price__c,Total_MW__c,Frame_Contract_opportunity__c,Type_of_Inventory_or_Production__c,Cross_Region__c,Customer_Delivery_Date__c,Regional_Head__c,Confirmed_ETD__c,Sales_Region__c,Destination_Country__c,Sales_type__c,Destination_Port__c,Project_related_or_not__c,delivey_point__c,Project__r.Name,Instruction__c,Departure_Factory__c,Seller__c,Excluding_VAT__c,Warranty_On_Material_and_Workmanship__c, Warranty_Insurance__c,EPC__c,Contact_Info_of_EPC__c,Financing_Bank__c,Owner_of_Project__c,Contact_Info_of_Owner__c,Detailed_address_of_project__c,Warehouse_or_Factory__c,Number_of_Containers__c,Local_Warehouse__c,Warehouse_Premium__c,Land_Freight_China__c,Land_Freight_Oversea__c,Ocean_Freight__c,Payment_Term_Description__c,Commission_Type__c,Commission_Payee__c,Reason_of_apply_for_insurance__c,Commision__c,Unit_Price_Without_Commission__c,Rebate__c,Discount__c, Special_Terms__c,RegionUserID__c,Competitor__c,Competitor_products__c,Competitor_price__c, Price_Approval_Status__c, Price_Approval_Feedback_Comments__c,Sales_manager_approval__c,GM_approval_Feedback__c,currencyisocode,Cross_region_GM_approval__c,Cross_region_GM_feedback__c,CEO_Approval_Status__c,Contract_Approver__c, CEO_Approval_comments__c,CFO_Approval_Status__c,CFO_Approval_comments__c,VP_Approval_Status__c,VP_Approval_comments__c FROM Opportunity '; 

        return Database.getQueryLocator(Query);
              }   
    global void execute (Database.BatchableContext bc, List<Opportunity> ordLst)
    {  
            for(Opportunity o :OrdLst){
                        SAPBATCHOPP.getOpportunityInfo(o.Id);                
            }
           
    }   
    global void finish(Database.BatchableContext bc)
    {

        system.debug('finished');
    }
}