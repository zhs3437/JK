@RestResource(urlMapping='/CrmToPLMMDACtrl2/*')
global without sharing class RC_CrmToPLMMDACtrl {
    
    @HttpPost
    global static String doPost() {
        RestRequest req = RestContext.request;
        Map<string,string> Str= req.headers;
        system.debug('Srt'+Str);
        String MDANAME=Str.get('MDAID');
        if(MDANAME !=null){
            String SQL=UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c)+ ' ' +
                                          'Where name =: MDANAME';
            SQL=SQL.replace('moduletype1__c', 'ModuleType1__r.name');
            SQL=SQL.replace('module_type2__c','Module_Type2__r.name');
            SQL=SQL.replace('module_type3__c', 'Module_Type3__r.name');
            SQL=SQL.replace('imodule_type1__c', 'iModule_Type1__r.Name');
            SQL=SQL.replace('imodule_type2__c','iModule_Type2__r.Name');
            SQL=SQL.replace('imodule_type3__c', 'iModule_Type3__r.Name');
            System.debug(SQL);
            List<Component_Task_Book__c> objList = Database.query(SQL);
            if(objList.size()>0){
                Component_Task_Book__c obj=objlist[0];
                ToPLMInformation toPLM = new ToPLMInformation();
                toPLM.CT1=obj.Cell_Type1__c;toPLM.CT2=obj.Cell_Type2__c;toPLM.CT3=obj.Cell_Type3__c;
                toPLM.MT1 = obj.ModuleType1__r.name != null ? obj.ModuleType1__r.name : obj.iModule_Type1__r.Name;
                toPLM.MT2 = obj.Module_Type2__r.name != null ? obj.Module_Type2__r.name : obj.iModule_Type2__r.Name;
                toPLM.MT3 = obj.Module_Type3__r.name != null ? obj.Module_Type3__r.name : obj.iModule_Type3__r.Name;
                toPLM.MS1=obj.Module_Series1__c;
                toPLM.MS2=obj.Module_Series2__c;
                toPLM.CQ1=obj.Cell_Quantity1__c;
                toPLM.CQ2=obj.Cell_Quantity2__c;
                toPLM.MS3=obj.Module_Series3__c;
                toPLM.CQ3=obj.Cell_Quantity3__c;
                toPLM.PC=obj.Product_Certificate__c;
                toPLM.AC=obj.Additional_Certificate__c;
                toPLM.RMC=obj.Mandatory_certification__c;    
                toPLM.PT=obj.Power_Tolerance__c;
                toPLM.SV=obj.System_Voltage__c;
                toPLM.AP=obj.Additional_power__c;
                toPLM.WA=obj.Warranty__c;
                toPLM.BOM=obj.BOM__c;toPLM.CP=obj.Cell__c;
                toPLM.JBB=obj.Junction_Box_brand__c;
                toPLM.JBCL=obj.Junction_Box_Cable_Length__c;
                toPLM.JBC=obj.Junction_Box_Connector__c;
                toPLM.RCT=obj.Rear_cover__c;
                toPLM.RCM=obj.Rear_Cover_Material__c;
                toPLM.FGT=obj.Front_Glass__c;
                toPLM.GT=obj.Glass_Thickness__c;
                toPLM.FBSH=obj.Frame_B_side_Height__c;
                toPLM.FC=obj.Frame_Color__c;
                toPLM.FT=obj.Frame_Type__c;
                toPLM.CTOSF=obj.C_side_type_of_short_frame__c;
                toPLM.EVA=obj.EVA__C;
                toPLM.LRF=obj.LRF__c;
                toPLM.PA=obj.Package__c;
                toPLM.PT2=obj.Project_Type__c;
                toPLM.NA=obj.Nameplate__c;
                toPLM.SM=obj.Shipping_Mark__c;
                toPLM.BEP=obj.Barcode_encoding_principle__c;
                toPLM.SR=obj.String_Ribbon__c;
                toPLM.CC=obj.Cell_Color__c;
                toPLM.CS=obj.Current_Sorting__c;
                toPLM.CSS=obj.Current_Sorting_Style__c;
                toPLM.CSS2=obj.Color_Sorting_style__c;
                toPLM.ASMC=obj.Additional_Shipping_Mark_Color_Label__c;
                toPLM.TS=obj.Transportation_style__c;
                toPLM.PSBC=obj.On_site_monitor_by_Client_or_3rd_party__c;
                toPLM.LT=obj.Lab_tests__c;
                toPLM.PIAF=obj.Pre_shipping_Inspection_factory__c;
                toPLM.RCCR=obj.Regional_customs_clearance_request__c;
                toPLM.SAFOP=obj.Special_Approval_for_order_production__c;
                toPLM.NOTE=obj.Note__c;
                toPLM.DVITC=obj.DS_Version_in_the_Contract_Text__c;
                toPLM.DS=obj.Deviation_sheet__c;
                toPLM.MDA=obj.NAME;
                toPLM.DC=obj.Destination_Country__c;
                toPLM.CON=obj.Contract_Number__c;
                toPLM.CN=obj.Client_Name__c;
                toPLM.QQ=obj.Order_Quantities__c;
                toPLM.SDO=obj.Sales_director_opinions__c;
                toPLM.SDOS=obj.Sales_director_opinions__c;
                toPLM.TMO=obj.Technical_manager_Shanghai_Comments__c;
                toPLM.TMA=obj.Technical_manager_Shanghai__c;
                List<Component_Task_Book__c> objList2=[select id,OWNER.Phone,
                                                       lastmodifieddate,Owner.NAME,Owner.email,Order__r.name from Component_Task_Book__c where  name =: MDANAME];
               if(objList2.size()>0){
                obj=objList2[0];
                toPLM.ORD=obj.Order__r.name;
                toPLM.SR2=obj.Owner.NAME;
                toPLM.CP2=obj.OWNER.Phone;
                toPLM.EMAIL=obj.Owner.email;
                toPLM.SD=String.valueOf(obj.lastmodifieddate);
              
                
                
               
               }
                   
                    
            String Jsonsforder = null;
            Jsonsforder =JSON.serialize(toPLM);
                 Return Jsonsforder;
            }else{
                Return '没有数据';
            }
            
        }
        else{Return 'MDA-ID为空无法查询';}
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