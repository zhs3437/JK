public without sharing class RC_ComponentTaskBookController {
    public String requestId{get;set;}
    public Component_Task_Book__c ctb {get;set;}
    public Date tod{get;set;}
    public Date approveDate{get;set;}
    public String containsOther{get;set;}
    private Integer lintNum=0;
    public RC_ComponentTaskBookController(){
        tod = Date.today(); 
        requestId = ApexPages.currentPage().getParameters().get('id');
        Id recordId = Id.valueOf(requestId);
        List<String> exFields = new List<String>{
            'iModule_Type1__r.Name',
            'iModule_Type2__r.Name',
            'iModule_Type3__r.Name',
            'ModuleType1__r.Name',
            'Module_Type2__r.Name',
            'Module_Type3__r.Name',
			'iContract__r.Contract_No__c',
            'iContract__r.Actual_Sales__r.Email',
            'iContract__r.Actual_Sales_Name__c',
            'iContract__r.Actual_Sales__r.MobilePhone'
        };
        ctb = (Component_Task_Book__c)Database.query(
            QW_Utils.getQueryBySObjectType(
                recordId.getSObjectType(), exFields) + 
                ' WHERE Id = \'' + recordId + '\'')[0];
        CsvStr cs = new CsvStr();       
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
}