public without sharing class RC_SapSync_Order {
    public Agreement__c agreement;
    public Boolean needClose;
    public Boolean isNew;

    public RC_SapSync_Order (Agreement__c agreement) {
        this.agreement = agreement;
        this.isNew = true;
        this.needClose = false;
    }
    
    public RC_SapSync_Order (Agreement__c agreement, Boolean isNew, Boolean needClose) {
        this.agreement = agreement;
        this.isNew = isNew;
        this.needClose = needClose;
    }
    
    public String sync(){
        this.agreement = agreement;
        User requestUser = [
            SELECT Id,
                   Country__c,
                   Email,
                   Name,
                   Region__c,
                   SAP_User_ID__c
            FROM User 
            WHERE Id =: agreement.Actual_Sales__c];
        List<Component_Task_Book__c> ctbs = (List<Component_Task_Book__c>)Database.query(
            QW_Utils.getQueryBySObjectType(
                'Component_Task_Book__c') + 
                ' WHERE iOrder__c = \'' + agreement.Id + '\'' + 
                ' ORDER BY CreatedDate');

        List<StaticResource> srs = [SELECT Id, Body FROM StaticResource WHERE Name = 'RC_MDA_Mapping' LIMIT 1];
        if (srs.size() == 0) throw new QW_Utils.QWException('MDA物料特性匹配逻辑缺失');
        String mdaConfig = srs[0].body.toString();
        // Map<String, Map<String, Object>> mdaMaps = new Map<String, Map<String, Object>>();// (Map<String,Map<String,String>>)JSON.deserialize(json, Map<String,Map<String,String>>.class);
        Map<String, Object> mdaMaps = (Map<String, Object>)JSON.deserializeUntyped(mdaConfig);
        for (String key1 : mdaMaps.keySet()) {
            Map<String, Object> valueMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(mdaMaps.get(key1)));
            mdaMaps.put(key1, valueMap);
        }
        Log__c log = new Log__c();
        log.StartTime__c = System.now();
        log.EndTime__c = System.now();
        log.SuccessCount__c = 0;
        log.TotalCount__c = 0;
        log.Type__c = 'ChinaOrder';
        log.SuccessIDs__c = '';
        log.SAP_Error_Message__c = '';
        log.Error_Message__c = '';
        // tool
        jinkosolarComEccCreateSoSyn.HTTPS_Port tool = new jinkosolarComEccCreateSoSyn.HTTPS_Port();
        jinkosolarComEccCreateSoSyn.DT_CreateSOSyn_Request T_PYTM = new jinkosolarComEccCreateSoSyn.DT_CreateSOSyn_Request();//付款方式
        T_PYTM.T_INPUT_PAY = new List<jinkosolarComEccCreateSoSyn.T_INPUT_PAY_element>();
        T_PYTM.T_INPUT_ITEM = new List<jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element>();
        T_PYTM.I_INPUT_HEAD = new jinkosolarComEccCreateSoSyn.I_INPUT_HEAD_element();//抬头
        T_PYTM.T_CFGS = new List<jinkosolarComEccCreateSoSyn.T_CFGS_element>();//抬头
        tool.timeout_x = 60000;
        // 销售凭证类型 - TODO 组织编号对应关系
        if ( agreement.SAP_Sales_Org__c == '1311' || agreement.SAP_Sales_Org__c == '1591'){
            T_PYTM.I_INPUT_HEAD.AUART  = 'ZM02';
        } else if ( agreement.SAP_Sales_Org__c == '1181' || agreement.SAP_Sales_Org__c == '1501'){
            T_PYTM.I_INPUT_HEAD.AUART  = 'YOR';
        } else {
            T_PYTM.I_INPUT_HEAD.AUART = 'ZOR1';
        }
        // 销售组织 - 根据SELLER来Mapping
        T_PYTM.I_INPUT_HEAD.VKORG  = agreement.SAP_Sales_Org__c;
        System.debug('VKORG---->'+ T_PYTM.I_INPUT_HEAD.VKORG);
        // 分销渠道 - 默认
        T_PYTM.I_INPUT_HEAD.VTWEG  = '';
        // 产品组 - 默认
        T_PYTM.I_INPUT_HEAD.SPART  = '30';
        // 销售部门 - 默认
        T_PYTM.I_INPUT_HEAD.VKBUR  = '1000';
        T_PYTM.I_INPUT_HEAD.KUNNR  = agreement.Buyer_SAP_Id__c;
        T_PYTM.I_INPUT_HEAD.ZKUNNR = agreement.Buyer_SAP_Id__c;
        // PO 号码
        T_PYTM.I_INPUT_HEAD.BSTKD  = agreement.Contract_No__c;
        System.debug('BSTKD---->'+ T_PYTM.I_INPUT_HEAD.BSTKD);
        // 请求交货日期 - contract - expect delivery date
        T_PYTM.I_INPUT_HEAD.VDATU  = agreement.Earliest_Delivery_Date__c == null ? '' : agreement.Earliest_Delivery_Date__c.year() + '/' + agreement.Earliest_Delivery_Date__c.month() + '/' + agreement.Earliest_Delivery_Date__c.day();
        System.debug('VDATU---->'+ T_PYTM.I_INPUT_HEAD.VDATU);
        // 合同签订日期 - contract - PO/PI Date - TODO
        T_PYTM.I_INPUT_HEAD.BSTDK  = agreement.CreatedDate.year() + '/' + agreement.CreatedDate.month() + '/' + agreement.CreatedDate.day();
        System.debug('BSTDK---->'+ T_PYTM.I_INPUT_HEAD.BSTDK);
        // 物料有效日期 - contract - PO/PI Date - TODO
        T_PYTM.I_INPUT_HEAD.MBDAT  = agreement.CreatedDate.year() + '/' + agreement.CreatedDate.month() + '/' + agreement.CreatedDate.day();
        System.debug('MBDAT---->'+ T_PYTM.I_INPUT_HEAD.MBDAT);
        // 付款条件代码 - 不传值
        T_PYTM.I_INPUT_HEAD.ZTERM  = '';
        // 付款方式 - 默认U
        T_PYTM.I_INPUT_HEAD.ZLSCH  = 'U';
        // 当订单的区域为South Asia时，ZLSCH值变为T
        // 更新了北美跨区的单子取owner的区域，不取订单区域
        if(agreement.Destination_Region__c == 'South Asia' || requestUser.Region__c == 'North America' || agreement.SAP_Sales_Org__c == '1491'){
            T_PYTM.I_INPUT_HEAD.ZLSCH ='T';
        }
        List<Contact> ccs = [
            SELECT Name,
                   Phone,
                   MobilePhone,
                   Email
            FROM   Contact 
            WHERE  AccountId = :agreement.Account__c];
        if (ccs.size() > 0) {
            T_PYTM.I_INPUT_HEAD.ZCONACT  = ccs[0].Name;
            T_PYTM.I_INPUT_HEAD.ZCONTEL  = ccs[0].MobilePhone;
            T_PYTM.I_INPUT_HEAD.ZCONEMAL  = ccs[0].Email;
        }
        // 定货人姓名
        T_PYTM.I_INPUT_HEAD.BNAME  = agreement.Destination_Port__c;
        System.debug('BNAME---->'+ T_PYTM.I_INPUT_HEAD.BNAME);
        // 装运类型 - order - mapping by shipping type
        T_PYTM.I_INPUT_HEAD.VSART  = agreement.SAP_Shipping__c;
        System.debug('VSART---->'+ T_PYTM.I_INPUT_HEAD.VSART);
        // 佣金
        T_PYTM.I_INPUT_HEAD.ZZCPRICE = String.valueOf(agreement.Commission_Per_W__c);
        System.debug('ZZCPRICE---->'+ T_PYTM.I_INPUT_HEAD.ZZCPRICE);
        // 国际贸易条款1 - reqired
        T_PYTM.I_INPUT_HEAD.INCO1 = agreement.Trade_Term__c != null ? agreement.Trade_Term__c : 'EXW';
        // 国际贸易条款2
        if(agreement.Destination_Port__c != null && agreement.Destination_Port__c != '' && agreement.Destination_Port__c != 'N/A'){
            String portcode = SapMap.getportCode(agreement.Destination_Port__c);
            portcode = sapmap.changeCode(portcode,agreement.Destination_Country__c);
            T_PYTM.I_INPUT_HEAD.INCO2 = portcode;
            System.debug('INCO2:'+T_PYTM.I_INPUT_HEAD.INCO2);
        }else{
            T_PYTM.I_INPUT_HEAD.INCO2 = SapMap.getCountryCode(agreement.Destination_Country__c); 
        }
        if(T_PYTM.I_INPUT_HEAD.INCO2 == null || T_PYTM.I_INPUT_HEAD.INCO2 == ''){
            T_PYTM.I_INPUT_HEAD.INCO2=SapMap.getCountryCode(agreement.Destination_Country__c);
        }else if(T_PYTM.I_INPUT_HEAD.INCO2.length()>27){
            T_PYTM.I_INPUT_HEAD.INCO2=T_PYTM.I_INPUT_HEAD.INCO2.subString(0,27);
        }
        // SD凭证货币 - order - CurrencyIsoCode
        T_PYTM.I_INPUT_HEAD.WAERK = agreement.CurrencyIsoCode.subString(0,3);
        System.debug('WAERK---->'+ T_PYTM.I_INPUT_HEAD.WAERK);
        // 针对付款条件的注释
        T_PYTM.I_INPUT_HEAD.ZTXT1 = '';
        // 针对订单的注释
        T_PYTM.I_INPUT_HEAD.ZTXT2 = agreement.Payment_Term_Description__c;
        System.debug('ZTXT2---->'+ T_PYTM.I_INPUT_HEAD.ZTXT2);
        // Sales Contract No
        T_PYTM.I_INPUT_HEAD.ZZSACNO = agreement.Contract_No__c;
        System.debug('ZZSACNO---->'+ T_PYTM.I_INPUT_HEAD.ZZSACNO);
        if (requestUser != null){
            if(requestUser.Country__c != null){
                T_PYTM.I_INPUT_HEAD.VKGRP = SapMap.getSalesGroup(requestUser.Country__c);//销售组 - user - mapping by country
                System.debug('----->user:' + requestUser.Name);
                System.debug('----->user.country:' + requestUser.Country__c);
                System.debug('----->SapMap.getSalesGroup(user.Country__c):' + SapMap.getSalesGroup(requestUser.Country__c));
            }else{
                T_PYTM.I_INPUT_HEAD.VKGRP = '103';
            }
            
            //业务员ID(CRMID) - 改为传SAP和CRM同步后的销售编码
            T_PYTM.I_INPUT_HEAD.SORTL = String.valueOf(requestUser.SAP_User_ID__c);
            //供应商或债权人的帐号
            T_PYTM.I_INPUT_HEAD.LIFNR = '';
        }
        System.debug('SORTL---->'+ T_PYTM.I_INPUT_HEAD.SORTL);

        // 付款备注 - Payment Term Description
        if(agreement.Payment_Term_Description__c != null && agreement.Payment_Term_Description__c.length()>130){
            T_PYTM.I_INPUT_HEAD.ZTXT3 = agreement.Payment_Term_Description__c.subString(0,130);
        }else{
            T_PYTM.I_INPUT_HEAD.ZTXT3 = agreement.Payment_Term_Description__c;
        }

        T_PYTM.I_INPUT_HEAD.ZAREA = '104';
        System.debug('ZAREA---->'+ T_PYTM.I_INPUT_HEAD.ZAREA);
        T_PYTM.I_INPUT_HEAD.ZZLANDD = SapMap.getCountryCode(agreement.Destination_Country__c);
        System.debug('ZZLANDD---->'+ T_PYTM.I_INPUT_HEAD.ZZLANDD);
        // 保险
        String Warranty ='';
        if(agreement.Warranty_Insurance__c == 'No Insurance Required'){
            Warranty ='NONE';
            // PowerGuard Warranty
            T_PYTM.I_INPUT_HEAD.ZZPWAR = '2';
        }else{
            Warranty = agreement.Warranty_Insurance__c;
            T_PYTM.I_INPUT_HEAD.ZZPWAR = '1';
        }
        T_PYTM.I_INPUT_HEAD.ZZINSUR = Warranty;

        System.debug('ZZINSUR---->'+ T_PYTM.I_INPUT_HEAD.ZZINSUR);
        T_PYTM.I_INPUT_HEAD.ZZLWAR_TX = agreement.Warranty_On_Material_and_Workmanship__c;
        System.debug('ZZLWAR_TX---->'+ T_PYTM.I_INPUT_HEAD.ZZLWAR_TX);
        T_PYTM.I_INPUT_HEAD.ZZSALE1   = agreement.SAP_User_ID__c == null ? '80000001' : agreement.SAP_User_ID__c;
        System.debug('ZZSALE1---->'+ T_PYTM.I_INPUT_HEAD.ZZSALE1);

        // 订单Id
        if (agreement.SAP_Order_ID__c != null) T_PYTM.I_INPUT_HEAD.VBELN = agreement.SAP_Order_ID__c;
        // Contract Owner Email
        T_PYTM.I_INPUT_HEAD.ZZMAIL1 = requestUser.Email;
        T_PYTM.I_INPUT_HEAD.ZZKQY = agreement.Cross_Region__c == true ? 'X' : '';
        T_PYTM.I_INPUT_HEAD.ZZOPID = agreement.Project__c;
        T_PYTM.I_INPUT_HEAD.ZZCRMORNO = agreement.Id;
        T_PYTM.I_INPUT_HEAD.ZZDTSP = '';

        // 物料特性
        for (Component_Task_Book__c ctb : ctbs) {
            if(String.isNotEmpty(ctb.Frame_B_side_Height__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Frame_B_side_Height')).get(ctb.Frame_B_side_Height__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Frame_B_side_Height');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Frame_B_side_Height__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Frame_Color__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Frame_Color')).get(ctb.Frame_Color__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Frame_Color');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Frame_Color__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Module_Level__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Module_Level')).get(ctb.Module_Level__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Module_Level');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Module_Level__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Product_Certificate__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Product_Certificate')).get(ctb.Product_Certificate__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Product_Certificate');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Product_Certificate__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Rear_cover__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Rear_cover')).get(ctb.Rear_cover__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Rear_cover');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Rear_cover__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Frame_Type__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Frame_Type')).get(ctb.Frame_Type__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Frame_Type');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Frame_Type__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.LRF__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('LRF')).get(ctb.LRF__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - LRF');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.LRF__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Junction_Box_brand__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE =  (String) ((Map<String, Object>)mdaMaps.get('Junction_Box_brand')).get(ctb.Junction_Box_brand__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Junction_Box_brand');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Junction_Box_brand__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Junction_Box_Cable_Length__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Junction_Box_Cable_Length')).get(ctb.Junction_Box_Cable_Length__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Junction_Box_Cable_Length');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Junction_Box_Cable_Length__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Junction_Box_Connector__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Junction_Box_Connector')).get(ctb.Junction_Box_Connector__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Junction_Box_Connector');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Junction_Box_Connector__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.EVA__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('EVA')).get(ctb.EVA__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - EVA');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.EVA__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Front_Glass__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Front_Glass_Type')).get(ctb.Front_Glass__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Front_Glass_Type');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Front_Glass__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Glass_Thickness__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Glass_Thickness')).get(ctb.Glass_Thickness__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Glass_Thickness');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Glass_Thickness__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Rear_Cover_Material__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Rear_Cover_Material')).get(ctb.Rear_Cover_Material__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Rear_Cover_Material');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Rear_Cover_Material__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Mandatory_certification__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Mandatory_certification')).get(ctb.Mandatory_certification__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Mandatory_certification');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Mandatory_certification__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Additional_Certificate__c)){
                for (String ac : ctb.Additional_Certificate__c.split(';')) {
                    jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                    mdaMetrial.MDAID = ctb.Name;
                    mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Additional_Certificate')).get(ac);
                    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Additional_Certificate');
                    mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                    mdaMetrial.VALUE_TXT = ac;
                    T_PYTM.T_CFGS.add(mdaMetrial);
                }
            }
            if(String.isNotEmpty(ctb.Package__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Package')).get(ctb.Package__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Package');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Package__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Current_Sorting__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Current_Sorting')).get(ctb.Current_Sorting__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Current_Sorting');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Current_Sorting__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.C_side_type_of_short_frame__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('C_side_type_of_short_frame')).get(ctb.C_side_type_of_short_frame__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - C_side_type_of_short_frame');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.C_side_type_of_short_frame__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Nameplate__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Nameplate')).get(ctb.Nameplate__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Nameplate');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Nameplate__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Shipping_Mark__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Shipping_Mark')).get(ctb.Shipping_Mark__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Shipping_Mark');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Shipping_Mark__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Current_Sorting_Style__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Current_Sorting_Style')).get(ctb.Current_Sorting_Style__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Current_Sorting_Style');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Current_Sorting_Style__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Color_Sorting_style__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Color_Sorting_Style')).get(ctb.Color_Sorting_style__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Color_Sorting_Style');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Color_Sorting_style__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Additional_Shipping_Mark_Color_Label__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Additional_Shipping_Mark_Color_Label')).get(ctb.Additional_Shipping_Mark_Color_Label__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Additional_Shipping_Mark_Color_Label');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Additional_Shipping_Mark_Color_Label__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
            if(String.isNotEmpty(ctb.Cell__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Cell')).get(ctb.Cell__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException('MDA物料特性匹配错误 - Cell');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.Cell__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
            }
        
            System.debug(T_PYTM.T_CFGS);
        }
        
        // orderlineitem
        if (this.isNew) {
            // List<SapMap__c> orderItems = Database.query(
            //     QW_Utils.getQueryBySObjectType(
            //         'SapMap__c',
            //         new List<String>{'Agreement_Component__r.MDA__c', 'Agreement_Component__r.Battery_Type__c', 'Agreement_Component__r.CurrencyIsoCode'}
            //     ) + ' WHERE Agreement__c = \'' + agreement.Id + '\'');
            // for(SapMap__c item : orderItems){
            //     jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element ZBVAP = new jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element();           
            //     // TODO : 拒绝原因
            //     // ZBVAP.ABGRU = '99';
            //     ZBVAP.ABGRU = needClose == true ? '99' : item.ABGRU__c;
            //     // 销售凭证项目
            //     // ZBVAP.POSNR = String.valueOf(item.RowNo__c);
            //     ZBVAP.POSNR = item.POSNR__c;
            //     System.debug('-------->RowNo:' + ZBVAP.POSNR);
            //     // CRM行项目ID
            //     ZBVAP.CRMNO = item.Id;
            //     System.debug('CRMNO---->'+ ZBVAP.CRMNO);
            //     ZBVAP.ZZCRMORIT = item.Id;
            //     System.debug('POSNR---->'+ ZBVAP.POSNR);
            //     // 物料号
            //     if (String.isBlank(item.MATNR__c)) throw new QW_Utils.QWException('补充SAP物料信息');
            //     if (String.isBlank(item.SAP_Materiel_No_Text__c)) throw new QW_Utils.QWException('补充SAP物料信息');
            //     ZBVAP.MATNR = item.MATNR__c;
            //     // MDA
            //     if (ZBVAP.MATNR.startsWith('26') && item.Agreement_Component__r.MDA__c == null) throw new QW_Utils.QWException('MDA 缺失');
            //     if (ZBVAP.MATNR.startsWith('26')) ZBVAP.MDAID = item.Agreement_Component__r.MDA__c;
            //     System.debug('MATNR---->'+ ZBVAP.MATNR);
            //     // 以销售单位表示的累计订单数量
            //     ZBVAP.KWMENG = item.KWMENG__c;
            //     System.debug('KWMENG---->'+ ZBVAP.KWMENG);
            //     // 销售单位
            //     ZBVAP.VRKME = 'PC';
            //     System.debug('VRKME---->'+ ZBVAP.VRKME);
            //     if (item.Agreement_Component__r.Battery_Type__c == 'Poly 157') ZBVAP.ZZDCLX='0';
            //     else if (item.Agreement_Component__r.Battery_Type__c == '156.75 5BB Perc') ZBVAP.ZZDCLX='1';
            //     else if (item.Agreement_Component__r.Battery_Type__c == '158.75 5BB Perc') ZBVAP.ZZDCLX='2';
            //     else if (item.Agreement_Component__r.Battery_Type__c == '158.75 9BB Perc') ZBVAP.ZZDCLX='3';
            //     else if (item.Agreement_Component__r.Battery_Type__c == '163.75 9BB Perc') ZBVAP.ZZDCLX='4';
            //     else if (item.Agreement_Component__r.Battery_Type__c == '158.75 9BB N-type') ZBVAP.ZZDCLX='5';
            //     else if (item.Agreement_Component__r.Battery_Type__c == '163.75 9BB N-type') ZBVAP.ZZDCLX='6';
            //     else ZBVAP.ZZDCLX='7';
            //     // 价格 -- 产品单价 - sap有定价比例，低于一定价格会报错
            //     // ZBVAP.KBETR = String.valueOf(item.Sales_Price__c.setScale(5));
            //     ZBVAP.KBETR = item.KBETR__c;
            //     System.debug('KBETR---->'+ ZBVAP.KBETR);
            //     // 条件货币
            //     // ZBVAP.KONWA = item.CurrencyIsoCode.subString(0,3);
            //     ZBVAP.KONWA = item.Agreement_Component__r.CurrencyIsoCode;
            //     System.debug('KONWA---->'+ ZBVAP.KONWA);
            //     // 定价单位
            //     ZBVAP.KPEIN  = '';
            //     // 计量单位
            //     ZBVAP.KMEIN  = 'W';
            //     System.debug('KMEIN---->'+ ZBVAP.KMEIN);
            //     // 价格 -- 海运费单价
            //     ZBVAP.ZKBETR = '0.00';
            //     System.debug('ZKBETR---->'+ ZBVAP.ZKBETR);
            //     // 条件货币
            //     // ZBVAP.ZKONWA = item.CurrencyIsoCode.subString(0,3);
            //     ZBVAP.KONWA = item.KONWA__c;
            //     System.debug('ZKONWA---->'+ ZBVAP.ZKONWA);
            //     // 定价单位
            //     ZBVAP.ZKPEIN = '';
            //     // 计量单位
            //     ZBVAP.ZKMEIN = 'PC';
            //     System.debug('ZKMEIN---->'+ ZBVAP.ZKMEIN);
            //     // 价格 -- 保险费单价
            //     ZBVAP.ZKBETR1 = '0.00';
            //     System.debug('ZKBETR1---->'+ ZBVAP.ZKBETR1);
            //     // 条件货币
            //     // ZBVAP.ZKONWA1 = item.CurrencyIsoCode.subString(0,3);
            //     ZBVAP.KONWA = item.KONWA__c;
            //     System.debug('ZKONWA1---->'+ ZBVAP.ZKONWA1);
            //     // 定价单位
            //     ZBVAP.ZKPEIN1 = '';
            //     // 计量单位
            //     ZBVAP.ZKMEIN1 = 'PC';
            //     System.debug('ZKMEIN1---->'+ ZBVAP.ZKMEIN1);
            //     // 产品备注长文本
            //     ZBVAP.ZTXT3   = '';
            //     // Customer PO No
            //     ZBVAP.ZZCPONO = '';
            //     // Project No
            //     ZBVAP.ZZPRJNO = '';
            //     // Bonded Material 保税号
            //     // ZBVAP.ZZBDMAT = agreement.Bonded_Material_Name__c;
            //     // System.debug('ZZBDMAT---->'+ ZBVAP.ZZBDMAT);
            //     ZBVAP.WERKS = agreement.SAP_Factory__c;//工厂
            //     System.debug('WERKS---->'+ ZBVAP.WERKS);
            //     // 交货日期
            //     // ZBVAP.ETDAT = String.valueOf(item.Guaranteed_Delivery_Date__c).replace('-', '');
            //     ZBVAP.ETDAT = String.valueOf(item.ETDAT__c).replace('-', '');
            //     System.debug('ETDAT---->'+ ZBVAP.ETDAT);
            //     T_PYTM.T_INPUT_ITEM.add(ZBVAP);
            // }
        } else {
            List<Agreement_Component__c> orderItemList = Database.query(
                QW_Utils.getQueryBySObjectType('Agreement_Component__c', new List<String>{'MDA__r.Name'}) + 
                ' WHERE Agreement__c = \'' + agreement.Id + '\'');       
            for(Agreement_Component__c item : orderItemList){
                jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element ZBVAP = new jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element();           
                // TODO : 拒绝原因
                // ZBVAP.ABGRU = '99';
                // 销售凭证项目
                ZBVAP.POSNR = String.valueOf(item.RowNo__c);
                System.debug('-------->RowNo:' + ZBVAP.POSNR);
                // CRM行项目ID
                ZBVAP.CRMNO = item.Id;
                System.debug('CRMNO---->'+ ZBVAP.CRMNO);
                ZBVAP.ZZCRMORIT = item.Id;
                System.debug('POSNR---->'+ ZBVAP.POSNR);
                // 物料号
                if (String.isBlank(item.SAP_Materiel_No_Text__c)) throw new QW_Utils.QWException('补充SAP物料信息');
                ZBVAP.MATNR = item.SAP_Materiel_No_Text__c;
                // 产品等级 (产品备注长文本, 转库存不用MDA)
                ZBVAP.ZTXT3 = item.Product_Grade__c;
                // MDA
                if (ZBVAP.MATNR.startsWith('26') && item.MDA__c == null && ZBVAP.ZTXT3 != 'Sluggish') throw new QW_Utils.QWException('MDA 缺失');
                if (ZBVAP.MATNR.startsWith('26')) ZBVAP.MDAID = item.MDA__c != null ? item.MDA__r.Name : null;
                System.debug('MATNR---->'+ ZBVAP.MATNR);
                // 以销售单位表示的累计订单数量
                ZBVAP.KWMENG = String.valueOf(item.Quantity__c);
                System.debug('KWMENG---->'+ ZBVAP.KWMENG);
                // 销售单位
                ZBVAP.VRKME = 'PC';
                System.debug('VRKME---->'+ ZBVAP.VRKME);
                if(item.Battery_Type__c=='Poly 157') ZBVAP.ZZDCLX='0';
                else if(item.Battery_Type__c=='156.75 5BB Perc') ZBVAP.ZZDCLX='1';
                else if(item.Battery_Type__c=='158.75 5BB Perc') ZBVAP.ZZDCLX='2';
                else if(item.Battery_Type__c=='158.75 9BB Perc') ZBVAP.ZZDCLX='3';
                else if(item.Battery_Type__c=='163.75 9BB Perc') ZBVAP.ZZDCLX='4';
                else if(item.Battery_Type__c=='158.75 9BB N-type') ZBVAP.ZZDCLX='5';
                else if(item.Battery_Type__c=='163.75 9BB N-type') ZBVAP.ZZDCLX='6';
                else ZBVAP.ZZDCLX='7';
                
                // 价格 -- 产品单价 - sap有定价比例，低于一定价格会报错
                ZBVAP.KBETR = String.valueOf(item.Sales_Price__c.setScale(5));
                System.debug('KBETR---->'+ ZBVAP.KBETR);
                // 条件货币
                ZBVAP.KONWA = item.CurrencyIsoCode.subString(0,3);
                System.debug('KONWA---->'+ ZBVAP.KONWA);
                // 定价单位
                ZBVAP.KPEIN  = '';
                // 计量单位
                ZBVAP.KMEIN  = 'W';
                System.debug('KMEIN---->'+ ZBVAP.KMEIN);
                // 价格 -- 海运费单价
                ZBVAP.ZKBETR = '0.00';
                System.debug('ZKBETR---->'+ ZBVAP.ZKBETR);
                // 条件货币
                ZBVAP.ZKONWA = item.CurrencyIsoCode.subString(0,3);
                System.debug('ZKONWA---->'+ ZBVAP.ZKONWA);
                // 定价单位
                ZBVAP.ZKPEIN = '';
                // 计量单位
                ZBVAP.ZKMEIN = 'PC';
                System.debug('ZKMEIN---->'+ ZBVAP.ZKMEIN);
                // 价格 -- 保险费单价
                ZBVAP.ZKBETR1 = '0.00';
                System.debug('ZKBETR1---->'+ ZBVAP.ZKBETR1);
                // 条件货币
                ZBVAP.ZKONWA1 = item.CurrencyIsoCode.subString(0,3);
                System.debug('ZKONWA1---->'+ ZBVAP.ZKONWA1);
                // 定价单位
                ZBVAP.ZKPEIN1 = '';
                // 计量单位
                ZBVAP.ZKMEIN1 = 'PC';
                System.debug('ZKMEIN1---->'+ ZBVAP.ZKMEIN1);
                // Customer PO No
                ZBVAP.ZZCPONO = '';
                // Project No
                ZBVAP.ZZPRJNO = '';
                // Bonded Material 保税号
                // ZBVAP.ZZBDMAT = agreement.Bonded_Material_Name__c;
                // System.debug('ZZBDMAT---->'+ ZBVAP.ZZBDMAT);
                ZBVAP.WERKS   = agreement.SAP_Factory__c;//工厂
                System.debug('WERKS---->'+ ZBVAP.WERKS);
                // 交货日期
                ZBVAP.ETDAT = String.valueOf(item.Guaranteed_Delivery_Date__c).replace('-', '');
                System.debug('ETDAT---->'+ ZBVAP.ETDAT);
                T_PYTM.T_INPUT_ITEM.add(ZBVAP);
            }
        }

        // payment
        List<Payment__c> payList = Database.query( Utils.MakeSelectSql('Payment__c')+' WHERE China_Order__c = \'' + agreement.Id + '\'');
        for(Payment__c pay : payList){
            jinkosolarComEccCreateSoSyn.T_INPUT_PAY_element payElement = new jinkosolarComEccCreateSoSyn.T_INPUT_PAY_element();
            payElement.ZZRATPZ = String.valueOf(pay.Percentage__c);//这个SAP端需要能接收100%
            System.debug('ZZRATPZ---->'+  payElement.ZZRATPZ);
            payElement.ZZPYP   = pay.Payment_Stage_China__c;
            System.debug('ZZPYP---->'+  payElement.ZZPYP);
            payElement.CRMPM   = pay.Payment_Method_China__c;// 'T/T'
            System.debug('CRMPM---->'+  payElement.CRMPM);
            payElement.ZZDAYS  = String.valueOf(pay.Days__c);
            System.debug('ZZDAYS---->'+  payElement.ZZDAYS);
            payElement.ZZPYTM  = pay.Payment_Term_China__c;
            System.debug('ZZPYTM---->'+  payElement.ZZPYTM);
            payElement.ZJZR    = String.valueOf(pay.Precise_Day__c);
            System.debug('ZJZR---->'+  payElement.ZJZR);
            payElement.ZZCMNT  = pay.Comments__c;
            System.debug('ZZCMNT---->'+  payElement.ZZCMNT);
            payElement.ZZCRDFLG = pay.Credit_Valid__c == true ? 'X' : '';//CRM Payment新增是否占用信用额度字段
            System.debug('ZZCRDFLG---->'+  payElement.ZZCRDFLG);
            T_PYTM.T_INPUT_PAY.add(payElement);
        }
        // result
        System.debug('1-->'+T_PYTM.I_INPUT_HEAD);
        System.debug('2-->'+T_PYTM.T_INPUT_ITEM);
        System.debug('3-->'+T_PYTM.T_INPUT_PAY);
        jinkosolarComEccCreateSoSyn.DT_CreateSOSyn_Response result = tool.SI_CRM2ECC_CreateSOSyn_Out( T_PYTM.I_INPUT_HEAD,  T_PYTM.T_INPUT_ITEM, T_PYTM.T_INPUT_PAY,T_PYTM.T_CFGS);
        System.debug('result-->'+result.RESULT);
        if('S'.equalsIgnoreCase( result.RESULT ) ){
            log.SuccessIDs__c += 'order sync: '+ agreement.Id + ' & sap order id: ' + result.I_VBELN + '/';
            log.SuccessCount__c++;           
            // give the sap order id to crm
            System.debug('result.I_VBELN-->'+result.I_VBELN);
            if(result.I_VBELN != null) agreement.SAP_Order_ID__c = result.I_VBELN;
            System.debug('result.MESSTXT-->'+result.MESSTXT);

        }else{
            log.FailureIDs__c += 'order sync failed : '+ agreement.Id + '/';
            log.SAP_Error_Message__c += result.MESSTXT;
        }
        //SapTools.uploadLogList.add(log);
        return JSON.serialize(result);
    }
}