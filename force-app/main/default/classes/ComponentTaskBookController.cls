public class ComponentTaskBookController {
    public String requestId{get;set;}
    public Component_Task_Book__c ctb {get;set;}
    public Date tod{get;set;}
    public Date approveDate{get;set;}
    public String containsOther{get;set;}
    private Integer lintNum=0;
    public ComponentTaskBookController(){
        tod = Date.today(); 
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId !=null){
            ctb = [Select id,
                   name,
                   C_side_type_of_short_frame__c,
                   Additional_Shipping_Mark_Color_Label__c,
                   Regional_customs_clearance_request__c,
                   Frame_B_side_Height__c,
                   Frame_Color__c,
                   Rear_Cover_Material__c,
                   Frame_Type__c,
                   Destination_Country__c,
                   Glass_Thickness__c,
                   Client_Name_and_Order_Quantities__c,
                   Product_Certificate__c,
                   Product_Certificate_Text__c,
                   System_Voltage__c,
                   System_Voltage_Text__c,
                   Additional_Certificate__c,
                   Additional_Certificate_Text__c,
                   Additional_Certificate_other__c,
                   Power_Tolerance__c,
                   Power_Tolerance_Text__c,
                   BOM__c,
                   BOM_Fixed_Text__c,
                   BOM_Material_Fixed_Text__c,
                   Shipping_Mark__c,
                   Junction_Box_brand__c,
                   Junction_Box_brand_Text__c,
                   Junction_Box_Cable_Length__c,
                   Junction_Box_Cable_Length_Text__c,
                   Junction_Box_Connector__c,
                   Junction_Box_Connector_Text__c,
                   Package__c,
                   Project_Type__c,
                   Project_Type_Text__c,
                   Package_Text__c,
                   Cell__c,
                   Front_Glass__c,
                   Rear_cover__c,
                   Rear_cover_Text__c,
                   EVA__c,
                   EVA_Text__c,
                   Frame__c,
                   Nameplate__c,
                   Barcode_encoding_principle__c,
                   The_current_classification_standard__c,
                   Transportation_style__c,
                   Transportation_style_Text__c,
                   Warranty__c,
                   Pre_shipping_Inspection_by_Client__c,
                   On_site_monitor_by_Client_or_3rd_party__c,
                   On_site_monitor_by_Client_text__c,
                   Note__c,
                   Mandatory_certification__c,
                   // Contract_Number__r.ContractNumber,
                   //  Contract_Number__r.Contract_No__c,
                   //order__r.OrderNumber,
                   Contract__r.Owner.Name,
                   Contract__r.Owner.MobilePhone,
                   Contract__r.Owner.Email,
                   
                   // Order__r.Contract_Owner__r.Phone,
                   Order_Quantities__c,
                   Client_Name__c,
                   Special_Approval_for_order_production__c,
                   Additional_power__c,
                   Additional_power_Text__c,
                   LRF__c,
                   Current_Sorting__c,
                   Current_Sorting_Text__c,
                   On_line_Audit__c,
                   Deviation_sheet__c,
                   Pre_shipping_Inspection_factory__c,
                   Lab_tests__c,
                   Director_Signature__c,
                   Sales_director_opinions__c,
                   Technical_manager_assigns_tasks__c,
                   Designer__c,
                   Designing_dead_line__c,
                   Cell_Quantity1__c,
                  Cell_Quantity1_Text__c,
                   Cell_Type1__c,
                   Cell_Type1_Text__c,
                   Cell_Quantity2__c,
                  Cell_Quantity2_Text__c,
                   Cell_Type2__c,
                   Cell_Type2_Text__c,
                   Cell_Quantity3__c,
                 Cell_Quantity3_Text__c,
                   Cell_Type3__c,
                   Cell_Type3_Text__c,
                   ModuleType1__c,
                   Module_Type2__c,
                   Module_Type3__c,
                   ModuleType1__r.Name,
                   Module_Type2__r.Name,
                   Module_Type3__r.Name,
                   PCS1__c,
                   PCS2__c,
                   PCS3__c,
                   Comments1__c,
                   Comments2__c,
                   Comments3__c,
                   Total__c,
                   Technical_manager_Shanghai__c,
                   Technical_manager_Shanghai_Comments__c,
                   Signature__c,
                   Order__c,
                   Contract__c,
                   Contract__r.Contract_No__c,
                   Current_Sorting_Style__c,
                   Color_Sorting_style__c,
                   Current_Sorting_Style_Text__c,
                   OpportunityAccName__c,
                   Opportunity__c,
                     Module_Category1_Text__c,
                     Module_Category2_Text__c,
                     Module_Category3_Text__c,
                   Module_Series1__c,
                   Module_Series2__c,
                   Module_Series3__c,
                   Component_Series_Resistance__c,
                   Component_Series_Resistance_Text__c,
                   Cell_grid__c,
                   Cell_grid_Text__c,
                   Cell_Factory__c,
                     Junction_Box__c,
                   Junction_Box_Text__c,
                   Cell_grid_quantity__c,
                     Cell_grid_quantity_Text__c,
                   Connector__c,
                   Connector_Text__c,
                   LCR__c,
                   Module_Color_Text__c,
                   Module_Color__c,
                   Border_mounting_Text__c,
                   Border_mounting__c,
                   Total_annual__c,
                     Module_Certificate__c,
                   IF_EnglishPackage__c,
                   Package_Style__c,
                   Package_Style_Text__c,
                     Module_Certificate_Text__c,
                   Installation_instructions__c,
                     Installation_instructions_Text__c,
                   Color_Sorting_style_text__c,
                     Wrapping_film_text__c,
                     Wrapping_film__c,
                   Component_appearance_standard__c,
                     Component_appearance_standard_text__c,
                   EL_standard__c,
                     EL_standard_text__c,
                   EL_photo__c,
                   Lab_tests_text__c,
                   Component_power_test__c,
                     Inspection_or_supervision__c,
                   Inspection_or_supervision_time__c,
                   EL_Test__c,
                   EL_Test_Text__c,
                   Frame_Text__c,
                   Warranty_Text__c,
                   Other_requirements_for_materials__c,
                   If_use_EnglishNameplate__c,
                     Distribution_order_or_not__c,
                FF__c,
                     FF_Text__c,
                Front_Glass_Text__c,Opportunity__r.Actual_Sales_Name__c,
                Frame_B_side_Height_Text__c,
          DS_Version_in_the_Contract__c,
          DS_Version_in_the_Contract_Text__c,
          String_Ribbon__c,
                   Cell_Color__c                   
                   From Component_Task_Book__c
                   Where id =:requestId];
            CsvStr cs = new CsvStr();
            system.debug('~~~~~'+ctb.Contract__c);
            system.debug('~~~~~'+ctb.DS_Version_in_the_Contract__c);
      system.debug('~~~~~'+ctb.DS_Version_in_the_Contract_Text__c);            
            ctb.DS_Version_in_the_Contract_Text__c =cs.convertString(ctb.DS_Version_in_the_Contract_Text__c, 80);
            ctb.Module_Category1_Text__c                 =cs.convertString(ctb.Module_Category1_Text__c, 80);
            ctb.Module_Category2_Text__c                 =cs.convertString(ctb.Module_Category2_Text__c, 80);
            ctb.Module_Category3_Text__c                 =cs.convertString(ctb.Module_Category3_Text__c, 80);
            ctb.BOM_Fixed_Text__c              = cs.convertString(ctb.BOM_Fixed_Text__c, 80);
            ctb.BOM_Material_Fixed_Text__c          = cs.convertString(ctb.BOM_Material_Fixed_Text__c, 80);
            ctb.EVA_Text__c                = cs.convertString(ctb.EVA_Text__c, 80);      
            ctb.Junction_Box_brand_Text__c           = cs.convertString(ctb.Junction_Box_brand_Text__c, 80);               
            ctb.Junction_Box_Cable_Length_Text__c       = cs.convertString(ctb.Junction_Box_Cable_Length_Text__c, 80);
            ctb.Junction_Box_Connector_Text__c        = cs.convertString(ctb.Junction_Box_Connector_Text__c, 80);
            ctb.Note__c                  = cs.convertString(ctb.Note__c, 255);
            ctb.Package_Text__c              = cs.convertString(ctb.Package_Text__c, 80);
            ctb.Power_Tolerance_Text__c          = cs.convertString(ctb.Power_Tolerance_Text__c, 80);
            ctb.Pre_shipping_Inspection_by_Client_Text__c  = cs.convertString(ctb.Pre_shipping_Inspection_by_Client_Text__c, 80);
            ctb.Product_Certificate_Text__c        = cs.convertString(ctb.Product_Certificate_Text__c, 80);
            ctb.On_site_monitor_by_Client_text__c      = cs.convertString(ctb.On_site_monitor_by_Client_text__c, 80);
            ctb.Rear_cover_Text__c              = cs.convertString(ctb.Rear_cover_Text__c, 80);
            ctb.System_Voltage_Text__c            = cs.convertString(ctb.System_Voltage_Text__c, 80);
            ctb.Transportation_style_Text__c        = cs.convertString(ctb.Transportation_style_Text__c, 80);
            ctb.Current_Sorting_Style_Text__c               = cs.convertString(ctb.Current_Sorting_Style_Text__c, 80);
            ctb.Project_Type_Text__c               = cs.convertString(ctb.Project_Type_Text__c, 80);
            if(ctb.Additional_Certificate_Text__c == null){
                ctb.Additional_Certificate_other__c = ctb.Additional_Certificate__c;
            }else{
                ctb.Additional_Certificate_other__c = ctb.Additional_Certificate__c.replace('Other','') + ctb.Additional_Certificate_Text__c;
            }
            ctb.Note__c     = sendFild(ctb.Note__c  ,25,'\n');
            ctb.Additional_Certificate_other__c = cs.convertString(ctb.Additional_Certificate_other__c, 80);
            system.debug('-----Additional_Certificate__c' + ctb.Additional_Certificate_other__c);
            if(ctb.Technical_manager_Shanghai__c== 'Approved'){
                approveDate = Date.today();
            }
            
            if(ctb.On_site_monitor_by_Client_or_3rd_party__c == 'Yes, Consignee'){
                ctb.On_site_monitor_by_Client_text__c  = ctb.On_site_monitor_by_Client_or_3rd_party__c + ':' + ctb.On_site_monitor_by_Client_text__c;
                ctb.On_site_monitor_by_Client_text__c  = cs.convertString(ctb.On_site_monitor_by_Client_text__c, 80);
            }
            
        }
    }
     public String sendFild(String fild,Integer num,String sStr){
        integer b =1;
        String rStr='';
        while(true) {
            integer pLength = fild.length()/num+1;
            String rStrs = fild.mid((b-1)*num,num);
            rStr+=rStrs+sStr;
            if(b==pLength){
                break;
            } 
            lintNum++;
            b++;
        }
        return rStr;
    }
    public void runTest(){
        String run = 'Test';
    }
}