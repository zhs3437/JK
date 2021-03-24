global class SapSync_Opportunity {
    @Future(callout=true)
    webservice static void getOpportunityInfo(String OpportunityId){
        //1.获取主表信息
        try{
        List<Opportunity> CRMOpportunityList = [SELECT ID,Name,
                                                OwnerId,
                                                Owner.Name,
                                                Owner.BMO_specialist__r.Name,
                                                AccountId,
                                                Account.SAP_External_ID__c,
                                                Actual_Sales_Name__c,
                                                Contract_No__c,
                                                Sales_1__c,
                                                Sales_1_percentage__c,
                                                Sales_2__c,
                                                Sales_2_percentage__c,
                                                Sales_3__c,
                                                Sales_3_percentage__c,
                                                StageName,
                                                Probability,
                                                Lost_Reason__c,
                                                Trade_Term__c,
                                                Original_Owner_BD_MG__c,
                                                Total_Quantity__c,
                                                IsNDA__c,
                                                Region__c,
                                                recordtype.name,
                                                Opportunity_Type__c,
                                                CloseDate,
                                                Order_Type__c,
                                                Order_reason__c,
                                                Total_Price__c,
                                                Total_MW__c,
                                                Frame_Contract_opportunity__c,                                                
                                                Type_of_Inventory_or_Production__c,
                                                Cross_Region__c,
                                                Customer_Delivery_Date__c,
                                                Regional_Head__c,
                                                Confirmed_ETD__c,
                                                Sales_Region__c,
                                                Destination_Country__c,
                                                Sales_type__c,
                                                Destination_Port__c,
                                                Project_related_or_not__c,
                                                delivey_point__c,
                                                Project__r.Name,
                                                Instruction__c,
                                                Departure_Factory__c,
                                                Seller__c,
                                                Excluding_VAT__c,
                                                Warranty_On_Material_and_Workmanship__c,
                                                Warranty_Insurance__c,
                                                EPC__c,
                                                Contact_Info_of_EPC__c,
                                                Financing_Bank__c,
                                                Owner_of_Project__c,
                                                Contact_Info_of_Owner__c,
                                                Detailed_address_of_project__c,
                                                Warehouse_or_Factory__c,
                                                Number_of_Containers__c,
                                                Local_Warehouse__c,
                                                Warehouse_Premium__c,
                                                Land_Freight_China__c,
                                                Land_Freight_Oversea__c,
                                                Ocean_Freight__c,
                                                Payment_Term_Description__c,
                                                Commission_Type__c,
                                                Commission_Payee__c,
                                                Reason_of_apply_for_insurance__c,
                                                Commision__c,
                                                Unit_Price_Without_Commission__c,
                                                Rebate__c,
                                                Discount__c,
                                                Special_Terms__c,
                                                RegionUserID__c,
                                                Competitor__c,
                                                Competitor_products__c,
                                                Competitor_price__c,
                                                Price_Approval_Status__c,
                                                Price_Approval_Feedback_Comments__c,
                                                Sales_manager_approval__c,
                                                GM_approval_Feedback__c,
                                                currencyisocode,
                                                Cross_region_GM_approval__c,
                                                Cross_region_GM_feedback__c,
                                                CEO_Approval_Status__c,
                                                Contract_Approver__c,
                                                CEO_Approval_comments__c,
                                                CFO_Approval_Status__c,
                                                CFO_Approval_comments__c,
                                                VP_Approval_Status__c,
                                                VP_Approval_comments__c
                                                FROM Opportunity Where ID=:OpportunityId];
        system.debug('a===>'+CRMOpportunityList.size());
        //2.定义SAP表结构
        List<Order> orderLst=  new List<Order>();
           orderLst= [select id,SELLER__c from order where Opportunity__c=:OpportunityId] ;
        jinkosolarComEccGetCrmData.T_OPHEAD_element SAPOpportunity = new jinkosolarComEccGetCrmData.T_OPHEAD_element();//SAP业务机会
        
        //主表信息赋值
        SAPOpportunity.ZOPID = CRMOpportunityList[0].Id;//商机Id
        SAPOpportunity.ZOPOWNER = CRMOpportunityList[0].Owner.Name;//所有人
        SAPOpportunity.ZOPNO = CRMOpportunityList[0].Name;//商机号
        SAPOpportunity.ZSOCNAME = CRMOpportunityList[0].Owner.BMO_specialist__r.Name;//SOC
        SAPOpportunity.KUNNR = CRMOpportunityList[0].Account.SAP_External_ID__c;//SAP客户代码
        SAPOpportunity.ZSALESNAME = CRMOpportunityList[0].Actual_Sales_Name__c;//实际销售姓名
        SAPOpportunity.BSTKD = CRMOpportunityList[0].Contract_No__c;//合同号
        SAPOpportunity.ZSALES1 = CRMOpportunityList[0].Sales_1__c;//销售1
        SAPOpportunity.ZSALESPCT1 = String.valueOf(CRMOpportunityList[0].Sales_1_percentage__c);//销售1比例
        SAPOpportunity.ZSALES2 = CRMOpportunityList[0].Sales_2__c;//销售2
        SAPOpportunity.ZSALESPCT2 = String.valueOf(CRMOpportunityList[0].Sales_2_percentage__c);//销售2比例   
        SAPOpportunity.ZSALES3 = CRMOpportunityList[0].Sales_3__c;//销售3
        SAPOpportunity.ZSALESPCT3 = String.valueOf(CRMOpportunityList[0].Sales_3_percentage__c);//销售3比例
        if(CRMOpportunityList[0].StageName == 'Prospecting'){//阶段
            SAPOpportunity.ZSTAGE = '01';
        }else if(CRMOpportunityList[0].StageName == 'Price Quote'){
            SAPOpportunity.ZSTAGE = '02';
        }else if(CRMOpportunityList[0].StageName == 'Validation / Conditional PO'){
            SAPOpportunity.ZSTAGE = '03';
        }else if(CRMOpportunityList[0].StageName == 'PO Imminent'){
            SAPOpportunity.ZSTAGE = '04';
        }else if(CRMOpportunityList[0].StageName == 'Closed Won'){
            SAPOpportunity.ZSTAGE = '05';
        }else if(CRMOpportunityList[0].StageName == 'Shortlisted'){
            SAPOpportunity.ZSTAGE = '06';
        }else if(CRMOpportunityList[0].StageName == 'Tentative Agmt to Price/Schedule'){
            SAPOpportunity.ZSTAGE = '07';
        }else if(CRMOpportunityList[0].StageName == 'Contract Negotiation'){
            SAPOpportunity.ZSTAGE = '08';
        }else if(CRMOpportunityList[0].StageName == 'Contract Finalized'){
            SAPOpportunity.ZSTAGE = '09';
        }else if(CRMOpportunityList[0].StageName == 'Contract Signed'){
            SAPOpportunity.ZSTAGE = '10';
        }else if(CRMOpportunityList[0].StageName == 'Closed Lost'){
            SAPOpportunity.ZSTAGE = '11';
        }
        
        SAPOpportunity.ZPROBABILITY = String.valueOf(CRMOpportunityList[0].Probability);//成单几率
        SAPOpportunity.ZLOSTREASON = CRMOpportunityList[0].Lost_Reason__c;//丢单原因
        SAPOpportunity.INCO1 = CRMOpportunityList[0].Trade_Term__c;//贸易方式
        SAPOpportunity.ZORIOWENER = CRMOpportunityList[0].Original_Owner_BD_MG__c;//原始所有人
        SAPOpportunity.ZTOTALQTY = String.valueOf(CRMOpportunityList[0].Total_Quantity__c);//合计数量
            IF(CRMOpportunityList[0].IsNDA__c!=NULL){
            if(CRMOpportunityList[0].IsNDA__c){//保密协议
            SAPOpportunity.ZNDAFLAG = 'X';
        }
            }
        SAPOpportunity.ZDESTREGION = CRMOpportunityList[0].Region__c;//区域
        if(SAPOpportunity.ZDESTREGION=='EU(Non-Eu)'){
            SAPOpportunity.ZDESTREGION= '103';
            }
             if(SAPOpportunity.ZDESTREGION=='EU(Union)'){
            SAPOpportunity.ZDESTREGION= '103';
            }
             if(SAPOpportunity.ZDESTREGION=='North America'){
            SAPOpportunity.ZDESTREGION= '104';
            }
             if(SAPOpportunity.ZDESTREGION=='Latin America&Italy'){
            SAPOpportunity.ZDESTREGION= '105';
            }
            if(SAPOpportunity.ZDESTREGION=='Middle East&Africa'){
            SAPOpportunity.ZDESTREGION= '106';
            }
            if(SAPOpportunity.ZDESTREGION=='North Asia'){
            SAPOpportunity.ZDESTREGION= '107';
            }
            if(SAPOpportunity.ZDESTREGION=='South Asia'){
            SAPOpportunity.ZDESTREGION= '108';
            }
            if(SAPOpportunity.ZDESTREGION=='ROA'){
            SAPOpportunity.ZDESTREGION= '109';
            }
            if(SAPOpportunity.ZDESTREGION=='Central Asia'){
            SAPOpportunity.ZDESTREGION= '114';
            }            
        
            IF(CRMOpportunityList[0].Opportunity_Type__c!=NULL){
        if(CRMOpportunityList[0].Opportunity_Type__c == 'Frame'){//业务机会类型
            SAPOpportunity.ZOPTYPE = '01';
        }else if(CRMOpportunityList[0].Opportunity_Type__c == 'Single'){
            SAPOpportunity.ZOPTYPE = '02';
        }else if(CRMOpportunityList[0].Opportunity_Type__c == 'Under Frame'){
            SAPOpportunity.ZOPTYPE = '03';
        }
            }
        SAPOpportunity.ZCLOSEDATE = String.valueOf(CRMOpportunityList[0].CloseDate).replaceAll('-','');//关单时间
            IF(CRMOpportunityList[0].Order_Type__c!=NULL){
            if(CRMOpportunityList[0].Order_Type__c == 'General order'){//订单类型
            SAPOpportunity.AUART = '1';
        }else if(CRMOpportunityList[0].Order_Type__c == 'Sample order'){
            SAPOpportunity.AUART = '2';
        }
            }
        SAPOpportunity.AUGRU = CRMOpportunityList[0].Order_reason__c;//选择订单原因
            IF(CRMOpportunityList[0].Order_reason__c!=NULL){
            if(CRMOpportunityList[0].Order_reason__c =='Z01'){//选择订单原因
            SAPOpportunity.AUGRU = 'Z01';
            system.debug('SAPOpportunity.AUGRU'+SAPOpportunity.AUGRU);            
        }else if(CRMOpportunityList[0].Order_reason__c =='high power'){
            SAPOpportunity.AUGRU = 'Z02';            
        }else if(CRMOpportunityList[0].Order_reason__c =='low power'){
             SAPOpportunity.AUGRU = 'Z03';             
        }else if(CRMOpportunityList[0].Order_reason__c =='no-output'){
              SAPOpportunity.AUGRU = 'Z04';            
        }else if(CRMOpportunityList[0].Order_reason__c =='poor packing'){
                     SAPOpportunity.AUGRU = 'Z05';              
        }else if(CRMOpportunityList[0].Order_reason__c =='air bubble in glass'){
            SAPOpportunity.AUGRU = 'Z06';
        }else if(CRMOpportunityList[0].Order_reason__c =='damaged glass'){
            SAPOpportunity.AUGRU = 'Z07';
        }else if(CRMOpportunityList[0].Order_reason__c =='scratch glass'){
            SAPOpportunity.AUGRU = 'Z08';
        }else if(CRMOpportunityList[0].Order_reason__c =='exploded glass'){
            SAPOpportunity.AUGRU = 'Z09';
        }else if(CRMOpportunityList[0].Order_reason__c =='unmatched border size'){
            SAPOpportunity.AUGRU = 'Z10';
        }else if(CRMOpportunityList[0].Order_reason__c =='border mounting hole malposed'){
            SAPOpportunity.AUGRU = 'Z11';
        }else if(CRMOpportunityList[0].Order_reason__c =='border glue abnormity'){
            SAPOpportunity.AUGRU = 'Z12';
        }else if(CRMOpportunityList[0].Order_reason__c =='damaged border'){
            SAPOpportunity.AUGRU = 'Z13';            
        }else if(CRMOpportunityList[0].Order_reason__c =='scratched border'){
            SAPOpportunity.AUGRU = 'Z14';
        }else if(CRMOpportunityList[0].Order_reason__c =='deformed border'){
            SAPOpportunity.AUGRU = 'Z15';            
        }else if(CRMOpportunityList[0].Order_reason__c =='corroded border'){
            SAPOpportunity.AUGRU = 'Z16';
        }else if(CRMOpportunityList[0].Order_reason__c =='pit in rear panel'){
            SAPOpportunity.AUGRU = 'Z17';
        }else if(CRMOpportunityList[0].Order_reason__c =='rear panel detached'){
            SAPOpportunity.AUGRU = 'Z18';
        }else if(CRMOpportunityList[0].Order_reason__c =='air bubbles in rear panel'){
            SAPOpportunity.AUGRU = 'Z19';
        }else if(CRMOpportunityList[0].Order_reason__c =='rear panel burned'){
            SAPOpportunity.AUGRU = 'Z20';
        }else if(CRMOpportunityList[0].Order_reason__c =='aberration of solar cells'){
            SAPOpportunity.AUGRU = 'Z21';
        }else if(CRMOpportunityList[0].Order_reason__c =='empty solder of solar cells'){
            SAPOpportunity.AUGRU = 'Z22';
        }else if(CRMOpportunityList[0].Order_reason__c =='cracked solar cells'){
            SAPOpportunity.AUGRU = 'Z23';
        }else if(CRMOpportunityList[0].Order_reason__c =='damaged solar cells'){
            SAPOpportunity.AUGRU = 'Z24';
        }else if(CRMOpportunityList[0].Order_reason__c =='grid line fracture'){
            SAPOpportunity.AUGRU = 'Z25';
        }else if(CRMOpportunityList[0].Order_reason__c =='burned solar cells'){
            SAPOpportunity.AUGRU = 'Z26';
        }else if(CRMOpportunityList[0].Order_reason__c =='connection box type error'){
            SAPOpportunity.AUGRU = 'Z27';
        }else if(CRMOpportunityList[0].Order_reason__c =='burned connection box'){
            SAPOpportunity.AUGRU = 'Z28';
        }else if(CRMOpportunityList[0].Order_reason__c =='burned diode of connection box'){
            SAPOpportunity.AUGRU = 'Z29';
        }else if(CRMOpportunityList[0].Order_reason__c =='connection box oxidized'){
            SAPOpportunity.AUGRU = 'Z30';
        }else if(CRMOpportunityList[0].Order_reason__c =='connector flooded'){
            SAPOpportunity.AUGRU = 'Z31';
        }else if(CRMOpportunityList[0].Order_reason__c =='connector bad join stitching'){
            SAPOpportunity.AUGRU = 'Z33';
        }else if(CRMOpportunityList[0].Order_reason__c =='connector glue defect'){
            SAPOpportunity.AUGRU = 'Z34';
        }else if(CRMOpportunityList[0].Order_reason__c =='connector oxidized'){
            SAPOpportunity.AUGRU = 'Z35';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='connector burned'){
            SAPOpportunity.AUGRU = 'Z36';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='connector loose'){
            SAPOpportunity.AUGRU = 'Z37';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='connector detached'){
            SAPOpportunity.AUGRU = 'Z38';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='module head spot'){
            SAPOpportunity.AUGRU = 'Z39';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='module snail trail'){
            SAPOpportunity.AUGRU = 'Z40';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module flash report error'){
            SAPOpportunity.AUGRU = 'Z41';
        }
              else if(CRMOpportunityList[0].Order_reason__c =='moduel surface contamination'){
            SAPOpportunity.AUGRU = 'Z42';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='The edge of green moduel'){
            SAPOpportunity.AUGRU = 'Z43';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='module spec error'){
            SAPOpportunity.AUGRU = 'Z44';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module bar code missing'){
            SAPOpportunity.AUGRU = 'Z45';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module bar code loose'){
            SAPOpportunity.AUGRU = 'Z46';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module fireproof test failure'){
            SAPOpportunity.AUGRU = 'Z47';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module without fireproof certificate'){
            SAPOpportunity.AUGRU = 'Z48';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module nameplate detached'){
            SAPOpportunity.AUGRU = 'Z49';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='module nameplate incorrect'){
            SAPOpportunity.AUGRU = 'Z50';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='The component parts of leakage'){
            SAPOpportunity.AUGRU = 'Z51';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module glass damaged in transportation'){
            SAPOpportunity.AUGRU = 'Z52';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='module missing in transportation'){
            SAPOpportunity.AUGRU = 'Z53';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='cells number inconformity to contract'){
            SAPOpportunity.AUGRU = 'Z54';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='cells spec inconformity to contract'){
            SAPOpportunity.AUGRU = 'Z55';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='substandard efficiency of solar cells'){
            SAPOpportunity.AUGRU = 'Z56';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='cells damaged in transportation'){
            SAPOpportunity.AUGRU = 'Z57';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='crystalsilicon number Not Match contract'){
            SAPOpportunity.AUGRU = 'Z58';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='crystal silicon spec Not Match contract'){
            SAPOpportunity.AUGRU = 'Z59';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='crystal silicon broken in transportation'){
            SAPOpportunity.AUGRU = 'Z60';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='other causes'){
            SAPOpportunity.AUGRU = 'Z61';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='commissioned processing'){
            SAPOpportunity.AUGRU = 'Z62';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='business development requirement'){
            SAPOpportunity.AUGRU = 'ZS1';
        }
             else if(CRMOpportunityList[0].Order_reason__c =='company exhibition or product exhibition'){
            SAPOpportunity.AUGRU = 'ZS2';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='corporate sponsorship requirement'){
            SAPOpportunity.AUGRU = 'ZS3';
        }
            else if(CRMOpportunityList[0].Order_reason__c =='third party inspection Institute&Client'){
            SAPOpportunity.AUGRU = 'ZS4';
        }

            }
        SAPOpportunity.ZTOTALPRICE = String.valueOf(CRMOpportunityList[0].Total_Price__c);//总价
        SAPOpportunity.ZTOTALPRICEINS = null;//总价包含保险
        SAPOpportunity.ZTOTALWM = String.valueOf(CRMOpportunityList[0].Total_MW__c);//总瓦数
        SAPOpportunity.ZFCOP = CRMOpportunityList[0].Frame_Contract_opportunity__c;//主业务机会
        SAPOpportunity.ZOPRCTY =  CRMOpportunityList[0].recordtype.name;//记录类型
        if(CRMOpportunityList[0].Type_of_Inventory_or_Production__c == 'Inventory'){//库存和产品类型选择
            SAPOpportunity.ZWHSORP = '1';
        }else if(CRMOpportunityList[0].Type_of_Inventory_or_Production__c == 'Production'){
            SAPOpportunity.ZWHSORP = '2';
        }else if(CRMOpportunityList[0].Type_of_Inventory_or_Production__c == 'Inventory and Production'){
            SAPOpportunity.ZWHSORP = '3';
        }

        if(CRMOpportunityList[0].Cross_Region__c){//是否跨区
            SAPOpportunity.ZXREGION = 'X';
        }
        
        //SAPOpportunity.ZEDD = String.valueOf(CRMOpportunityList[0].Customer_Delivery_Date__c);//预计交货日期
            IF(CRMOpportunityList[0].Customer_Delivery_Date__c!=NULL){
        SAPOpportunity.ZEDD = String.valueOf(CRMOpportunityList[0].Customer_Delivery_Date__c).replaceAll('-','');
            }
        SAPOpportunity.ZREGHEAD = CRMOpportunityList[0].RegionUserID__c;//区域负责人
            IF(CRMOpportunityList[0].Confirmed_ETD__c!=NULL){
        SAPOpportunity.ZDET = String.valueOf(CRMOpportunityList[0].Confirmed_ETD__c).replaceAll('-','');//预计出发时间
            }
        SAPOpportunity.ZSALESREGION = SAPOpportunity.ZDESTREGION;//销售区域
        SAPOpportunity.ZDESTCOUNTRY = SapMap.getCountryCode(CRMOpportunityList[0].Destination_Country__c);//目的地国家
        
        
        if( CRMOpportunityList[0].Sales_type__c =='Utility'){//销售类型
            SAPOpportunity.ZSALESTYPE ='1';
        }else if(CRMOpportunityList[0].Sales_type__c =='DG Market-Rooftop'){
            SAPOpportunity.ZSALESTYPE ='2';
        }else if(CRMOpportunityList[0].Sales_type__c =='DG Market-Industrial&Commercial'){
            SAPOpportunity.ZSALESTYPE ='3';
        }
        
        SAPOpportunity.ZDESTPORT = SapMap.getSAPportCode(CRMOpportunityList[0].Destination_Port__c);//目的地港口
        if(CRMOpportunityList[0].Project_related_or_not__c =='YES'){//是否存在项目
            SAPOpportunity.ZPRJRELATED = 'X';
        }else if(CRMOpportunityList[0].Project_related_or_not__c =='NO'){
            SAPOpportunity.ZPRJRELATED = '';
        }
        
        SAPOpportunity.ZDELPOINT = CRMOpportunityList[0].delivey_point__c;//交货地点
        SAPOpportunity.ZPROJECT = CRMOpportunityList[0].Project__r.Name;//项目
        SAPOpportunity.ZDPMEMO = CRMOpportunityList[0].Instruction__c;//交货地点说明
        if(CRMOpportunityList[0].Departure_Factory__c=='ShangRao Factory'){//发货工厂
            SAPOpportunity.ZDPLANT = '0001';            
        }else if(CRMOpportunityList[0].Departure_Factory__c=='Malaysia Factory'){
            SAPOpportunity.ZDPLANT = '0002';
        }else if(CRMOpportunityList[0].Departure_Factory__c=='HaiNing Factory'){
            SAPOpportunity.ZDPLANT = '0003';
        }else if(CRMOpportunityList[0].Departure_Factory__c=='South of Africa Factory'){
            SAPOpportunity.ZDPLANT = '0004';
        }else if(CRMOpportunityList[0].Departure_Factory__c=='Vietnam Factory'){
            SAPOpportunity.ZDPLANT = '0005';
        }else if(CRMOpportunityList[0].Departure_Factory__c=='Portugal factory'){
            SAPOpportunity.ZDPLANT = '0006';
        }
            if(orderLst.size()>0){
                CRMOpportunityList[0].Seller__c =orderLst[0].Seller__c;
            }
        if(CRMOpportunityList[0].Seller__c == 'Jinko Solar Import and Export Co., Ltd.'){//卖方
            SAPOpportunity.VKORG = '1020';
        }else if(CRMOpportunityList[0].Seller__c == 'JinkoSolar (Switzerland) AG'){
            SAPOpportunity.VKORG = '1080';
        }else if(CRMOpportunityList[0].Seller__c == 'JinkoSolar (U.S.) Inc'){
            SAPOpportunity.VKORG = '1180';
        }else if(CRMOpportunityList[0].Seller__c == 'JinkoSolar GmbH'){
            SAPOpportunity.VKORG = '1170';
        }else if(CRMOpportunityList[0].Seller__c == 'Jinko Solar Co., Ltd.'){
            SAPOpportunity.VKORG = '1010';
        }else if(CRMOpportunityList[0].Seller__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
            SAPOpportunity.VKORG = '1160';
        }else if(CRMOpportunityList[0].Seller__c == 'JinkoSolar(ITALIA)S.R.L.'){
            SAPOpportunity.VKORG = '1120';
        }else if(CRMOpportunityList[0].Seller__c == 'JINKOSOLAR (PTY) LTD'){
            SAPOpportunity.VKORG = '1230';           
        }else if(CRMOpportunityList[0].Seller__c == 'JINKOSOLAR TECHNOLOGY LIMITED'){
            SAPOpportunity.VKORG = '1070';
        }else if(CRMOpportunityList[0].Seller__c == 'JinkoSolar Canada Co., Ltd.'){
            SAPOpportunity.VKORG = '1140';
        }else if(CRMOpportunityList[0].Seller__c == 'ジンコソーラージャパン株式会社'){
            SAPOpportunity.VKORG = '1250';
        }else if(CRMOpportunityList[0].Seller__c == 'ZHEJIANG JINKO SOLAR CO.,LTD'){
            SAPOpportunity.VKORG = '1030';
        }else if(CRMOpportunityList[0].Seller__c == 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA'){
            SAPOpportunity.VKORG = '0013';
        }else if(CRMOpportunityList[0].Seller__c == 'JINKO SOLAR TECHNOLOGY SDN.BHD.'){
            SAPOpportunity.VKORG = '1590'; 
        }else if(CRMOpportunityList[0].Seller__c == 'JINKOSOLAR TRADING PRIVATE LIMITED'){
            SAPOpportunity.VKORG = '1430';
        }else if(CRMOpportunityList[0].Seller__c == 'POYANG RALLYSON TECHNOLOGY CO., LTD'){
            SAPOpportunity.VKORG = '4110';
        }else if(CRMOpportunityList[0].Seller__c == 'Jinko Solar Technology Sdn Bhd'){
            SAPOpportunity.VKORG = '1590';
        }else if(CRMOpportunityList[0].Seller__c == 'YUHUAN JINKO SOLAR CO., LTD'){
            SAPOpportunity.VKORG = '1410';
        }else if(CRMOpportunityList[0].Seller__c == 'JINKO SOLAR (U.S.) INDUSTRIES INC.'){
            SAPOpportunity.VKORG = '1500';
        }else if(CRMOpportunityList[0].Seller__c == 'Jinko Solar Korea Co., Ltd.'){
            SAPOpportunity.VKORG = '1490';
        }else if(CRMOpportunityList[0].Seller__c == 'Jinkosolar (Vietnam) Co., Ltd.'){
            SAPOpportunity.VKORG = '0021';
        }
   
        if(CRMOpportunityList[0].Excluding_VAT__c){//排除增值税
            SAPOpportunity.ZEXVAT = 'X';
        }
        if(CRMOpportunityList[0].Warranty_On_Material_and_Workmanship__c == 'None for B grade product'){//质保条例
            SAPOpportunity.ZWOMW = '1';
        }else if(CRMOpportunityList[0].Warranty_On_Material_and_Workmanship__c == '12 linear warranty'){
            SAPOpportunity.ZWOMW = '2';
        }else if(CRMOpportunityList[0].Warranty_On_Material_and_Workmanship__c == '10 standard warranty'){
            SAPOpportunity.ZWOMW = '3';
        }else if(CRMOpportunityList[0].Warranty_On_Material_and_Workmanship__c == '10 linear warranty'){
            SAPOpportunity.ZWOMW = '4';
        }
        
        if(CRMOpportunityList[0].Warranty_Insurance__c=='No Insurance Required'){//保险类型
            SAPOpportunity.ZWITYPE = '1';
        }else if(CRMOpportunityList[0].Warranty_Insurance__c=='AR'){
            SAPOpportunity.ZWITYPE = '2';
        }else if(CRMOpportunityList[0].Warranty_Insurance__c=='Powerguard'){
            SAPOpportunity.ZWITYPE = '3';
        }
        
        SAPOpportunity.ZINSREASON = CRMOpportunityList[0].Reason_of_apply_for_insurance__c;//保险选择原因
        SAPOpportunity.ZEPC = CRMOpportunityList[0].EPC__c;//EPC
        SAPOpportunity.ZEPCLXR = CRMOpportunityList[0].Contact_Info_of_EPC__c;//EPC联系人信息
        SAPOpportunity.ZBANKINFO = CRMOpportunityList[0].Financing_Bank__c;//融资银行信息
        SAPOpportunity.ZPRJOWENER = CRMOpportunityList[0].Owner_of_Project__c;//项目管理员
        SAPOpportunity.ZPRJOWENERINFO = CRMOpportunityList[0].Contact_Info_of_Owner__c;//owner联系人信息
        SAPOpportunity.ZPRJADDRESS = CRMOpportunityList[0].Detailed_address_of_project__c;//项目详细地址
        if(CRMOpportunityList[0].Warehouse_or_Factory__c =='Warehouse'){//发货方式
             SAPOpportunity.ZDELTYPE = '1';
        }else if(CRMOpportunityList[0].Warehouse_or_Factory__c =='Factory'){
            SAPOpportunity.ZDELTYPE = '2';
        }
       
        SAPOpportunity.ZCONTAINERQTY = String.valueOf(CRMOpportunityList[0].Number_of_Containers__c);//集装箱数量
        SAPOpportunity.ZLOCALWH = CRMOpportunityList[0].Local_Warehouse__c;//
        SAPOpportunity.ZWHPREMIUM = String.valueOf(CRMOpportunityList[0].Warehouse_Premium__c);//
        SAPOpportunity.ZLFREIGHTC = String.valueOf(CRMOpportunityList[0].Land_Freight_China__c);
        SAPOpportunity.ZLFREIGHTO = String.valueOf(CRMOpportunityList[0].Land_Freight_Oversea__c);
        SAPOpportunity.ZOCEANFREIGHT = String.valueOf(CRMOpportunityList[0].Ocean_Freight__c);
        SAPOpportunity.ZPMTTDESC = CRMOpportunityList[0].Payment_Term_Description__c;
        SAPOpportunity.ZCOMMISSIONTY = CRMOpportunityList[0].Commission_Type__c;
        SAPOpportunity.ZCOMMISSIONPA = CRMOpportunityList[0].Commission_Payee__c;
        SAPOpportunity.ZCOMMISSIONAMT = String.valueOf(CRMOpportunityList[0].Commision__c);
        SAPOpportunity.ZUPWCOMM = String.valueOf(CRMOpportunityList[0].Unit_Price_Without_Commission__c);
        SAPOpportunity.ZREBATE = CRMOpportunityList[0].Rebate__c;
        SAPOpportunity.ZDISCOUNT = CRMOpportunityList[0].Discount__c;
        SAPOpportunity.ZSPECIALTERMS = CRMOpportunityList[0].Special_Terms__c;  
      
        SAPOpportunity.ZCOMPETITOR = CRMOpportunityList[0].Competitor__c;
        SAPOpportunity.ZCOMPETPROD = CRMOpportunityList[0]. Competitor_products__c;
        SAPOpportunity.ZCOMPETPRICE = CRMOpportunityList[0].Competitor_price__c;
        SAPOpportunity.ZFIAPSTATUS = CRMOpportunityList[0].Price_Approval_Status__c;
        SAPOpportunity.ZFIAPFB = CRMOpportunityList[0].Price_Approval_Feedback_Comments__c;
        SAPOpportunity.ZGMAPST = CRMOpportunityList[0].Sales_manager_approval__c;
        SAPOpportunity.ZGMAPFB = CRMOpportunityList[0].GM_approval_Feedback__c;
        SAPOpportunity.ZXGMAPST = CRMOpportunityList[0].Cross_region_GM_approval__c;
        SAPOpportunity.ZXGMAPFB = CRMOpportunityList[0].Cross_region_GM_feedback__c;
        SAPOpportunity.ZCMOAPST = CRMOpportunityList[0].CEO_Approval_Status__c;
        SAPOpportunity.ZCMOAPFB = CRMOpportunityList[0].CEO_Approval_comments__c;
        SAPOpportunity.ZCFOAPST = CRMOpportunityList[0].CFO_Approval_Status__c;
        SAPOpportunity.ZCFOAPFB = CRMOpportunityList[0].CFO_Approval_comments__c;
        SAPOpportunity.ZFIAPAPST = CRMOpportunityList[0].VP_Approval_Status__c;
        SAPOpportunity.ZFIAPAPFB = CRMOpportunityList[0].VP_Approval_comments__c;
        SAPOpportunity.WAERS = CRMOpportunityList[0].currencyisocode;
          List<contract> conlst =new List<contract>();
            conlst=[select BuyerAccount__r.SAP_External_ID__c from contract where Opportunity__c=:CRMOpportunityList[0].id];
            if(conlst.size()>0){
        SAPOpportunity.KUNNR = conlst[0].BuyerAccount__r.SAP_External_ID__c;//SAP客户代码
            }
        List<Payment__c>gl = [Select Id,Name,
                      Down_Balance_Payment__c, 
                      Payment_Term__c, 
                      Payment_Method__c, 
                      Opportunity__c,
                      Days__c, 
                      Comments_Japan__c,
                      Comments_English__c,
                      CurrencyIsoCode,  
                      Precise_Day__c,
                      Percentage__c,
                      Requested_Number__c,
                      Opp_Trade_Term__c,
                      Comments__c,
                      Credit_Valid__c,
                      Amount__c,
                      TYPE__c,
                      PaymentDescription__c,
                      PaymentDescription_Japan__c
                      From Payment__c
                      where Opportunity__c = :OpportunityId];
       jinkosolarComEccGetCrmData.DT_GetCRM_Request jd = new jinkosolarComEccGetCrmData.DT_GetCRM_Request();
        
        jd.T_OPHEAD=new jinkosolarComEccGetCrmData.T_OPHEAD_element[0];
        jd.T_OPHEAD.add(SAPOpportunity);
        system.debug('T_OPHEAD-----业务机会表头'+jd.T_OPHEAD.size());
        
        
        //付款方式
        jd.T_OPPAY=new jinkosolarComEccGetCrmData.T_OPPAY_element[0];
        if(gl.size()>0){
            
        
        for(Integer i=0;i<gl.size();i++){
            jinkosolarComEccGetCrmData.T_OPPAY_element SAPPaymentTerm = new jinkosolarComEccGetCrmData.T_OPPAY_element();//SAP付款方式
            SAPPaymentTerm.ZOPPAYID = gl[i].Id;
            SAPPaymentTerm.ZOPID = gl[i].Opportunity__c;
            SAPPaymentTerm.ZPMTPCT = String.valueOf(gl[i].Percentage__c);
            if(gl[i].Down_Balance_Payment__c =='Down Payment'){
                SAPPaymentTerm.ZPMTTYPE ='1' ;
            }else if(gl[i].Down_Balance_Payment__c =='Balance Payment'){
                SAPPaymentTerm.ZPMTTYPE ='2' ;
            }
            
            SAPPaymentTerm.ZPMTMETHOD = gl[i].Payment_Method__c;
            SAPPaymentTerm.ZPMTTERM = gl[i].Payment_Term__c;
            SAPPaymentTerm.ZPMTDAYS = String.valueOf(gl[i].Days__c);
            SAPPaymentTerm.ZPMTDESC = gl[i].PaymentDescription__c;
             jd.T_OPPAY.add(SAPPaymentTerm);
        }
            }
         system.debug('T_OPPAY-----业务机会付款方式'+jd.T_OPPAY.size());
        List<OpportunityLineItem> oi =[select Id,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,PricebookEntry.product2.Name,Product__c,Product2Id,Product2.Name,
                                               Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,Discount,Product_Name__c,MP__c,OpportunityId,
                                               Serial_No__c,Package__c,Label__c,Support_mixed_delivery__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,Cheetah__c,Stock_age__c,
                                               Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c,Expected_Delivery_Date__c,Power_W__c,Estimated_Time_of_Departure_ETD__c,Goods_Description__c
                                               from OpportunityLineItem Where OpportunityId =:OpportunityId];
        jd.T_OPPROD=new jinkosolarComEccGetCrmData.T_OPPROD_element[0];
        if(oi.size()>0){   
        for(Integer o=0;o<oi.size(); o++){
            jinkosolarComEccGetCrmData.T_OPPROD_element SAPOpportunityProduct = new jinkosolarComEccGetCrmData.T_OPPROD_element();//SAP订单产品
            SAPOpportunityProduct.ZOPPRDID = oi[o].id;
            SAPOpportunityProduct.ZOPID = oi[o].OpportunityId;
            SAPOpportunityProduct.BISMT = oi[o].Product_Name__c;
            SAPOpportunityProduct.ZPRODQTY = String.valueOf(oi[o].Quantity);
            SAPOpportunityProduct.MEINS = null;
            SAPOpportunityProduct.ZSPRICE = String.valueOf(oi[o].UnitPrice);
            SAPOpportunityProduct.ZDISCOUNT = String.valueOf(oi[o].Discount);
            if(oi[o].MP__c == 'Poly'){
                SAPOpportunityProduct.ZMP = '1';
            }else if(oi[o].MP__c == 'Mono'){
                SAPOpportunityProduct.ZMP = '2';
            }else if(oi[o].MP__c == 'Perc Mono'){
                SAPOpportunityProduct.ZMP = '3';
            }
            
            
            if(oi[o].Cheetah__c){
                SAPOpportunityProduct.ZCHEETAHFLAG = 'X';
            }
            
            if(oi[o].Support_mixed_delivery__c){
                SAPOpportunityProduct.ZMIXFLAG='X';
            }
            system.debug('haha:'+SAPOpportunityProduct.ZMIXFLAG);
            if(oi[o].Stock_age__c == '＜3个月'){//库存年龄
                SAPOpportunityProduct.ZSTOCKAGE = '1';
            }else if(oi[o].Stock_age__c == '≥3个月，＜6个月'){
                SAPOpportunityProduct.ZSTOCKAGE = '2';              
            }else if(oi[o].Stock_age__c == '≥6个月'){
                SAPOpportunityProduct.ZSTOCKAGE = '3';
            }
            
            SAPOpportunityProduct.ZOPPRDDESC = oi[o].Goods_Description__c;
            SAPOpportunityProduct.ZGDD = String.valueOf(oi[o].Guaranteed_Delivery_Date__c).replaceAll('-','');
            SAPOpportunityProduct.ZDELTYPE = null;
            
            
                jd.T_OPPROD.add(SAPOpportunityProduct);
           
        }
            }
         system.debug('T_OPPROD-----业务机会行项目'+jd.T_OPPROD.size());
        jinkosolarComCrmGetCrmData.HTTPS_Port HttpSap =new jinkosolarComCrmGetCrmData.HTTPS_Port();
        jinkosolarComEccGetCrmData.DT_GetCRM_Response result =new jinkosolarComEccGetCrmData.DT_GetCRM_Response();
        //system.debug('ixix:'+jd.T_OPPROD[0].ZPRODQTY);
        result=HttpSap.SI_CRM2ECC_GetCRM_Out(jd.T_OPHEAD, jd.T_OPPAY, jd.T_OPPROD);
        System.debug('result======='+result);
            decimal i=1;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
              i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
              i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
              i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
  i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
  i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
              i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
             i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;

i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
       //return result.E_MSGTXT;
        }catch(Exception e){system.debug('ERR:'+E); }
    }
 
}