public without sharing class SapSync_Order {
  Map<String, Component_Task_Book__c> itemNameCTBMaps = new Map<String, Component_Task_Book__c>();
 Order ord = new Order();
 List<User> requestUserList = new List<User>();
 Contract con = new Contract();
 Opportunity  opp = new Opportunity ();
 public String errorMsg = '';
 public List<Log__c> lst_log {get;set;}
 
 // structure
 public SapSync_Order(){
 }    
 // generate basic data,
 public void generateData(Order ord){
     this.ord = ord;
     String conid = ord.ContractId;
     con = Database.query( Utils.MakeSelectSql('Contract')+' WHERE Id =: conid'); 
     String oppid = con.Opportunity__c;
     opp = Database.query( Utils.MakeSelectSql('Opportunity')+' WHERE Id =: oppid'); 
     requestUserList = [SELECT ID,Country__c,Name,Region__c FROM User WHERE ID =: con.OwnerId];//Database.query( Utils.MakeSelectSql('User'));
 }
 
 public String sync(String msg){
     // init - log for recording every integration call
     Log__c log = new Log__c();
     String T;
     try{
            List<Component_Task_Book__c> ctbs = (List<Component_Task_Book__c>)Database.query(
                QW_Utils.getQueryBySObjectType(
                    'Component_Task_Book__c') + 
                    ' WHERE Order__c = \'' + ord.Id + '\'' + 
                    ' ORDER BY CreatedDate');
            for (Component_Task_Book__c ctb : ctbs) {
                if ((String) ctb.get('ModuleType1__c') != null) itemNameCTBMaps.put(Id.valueOf((String)ctb.get('ModuleType1__c')), (Component_Task_Book__c) ctb);
                if ((String) ctb.get('Module_Type2__c') != null) itemNameCTBMaps.put(Id.valueOf((String)ctb.get('Module_Type2__c')), (Component_Task_Book__c) ctb);
                if ((String) ctb.get('Module_Type3__c') != null) itemNameCTBMaps.put(Id.valueOf((String)ctb.get('Module_Type3__c')), (Component_Task_Book__c) ctb);
            }
              system.debug('itemNameCTBMaps:'+itemNameCTBMaps);
           List<StaticResource> srs = [SELECT Id, Body FROM StaticResource WHERE Name = 'RC_MDA_Mapping' LIMIT 1];
     if (srs.size() == 0) throw new QW_Utils.QWException('MDA物料特性匹配逻辑缺失');
     String mdaConfig = srs[0].body.toString();
     // Map<String, Map<String, Object>> mdaMaps = new Map<String, Map<String, Object>>();// (Map<String,Map<String,String>>)JSON.deserialize(json, Map<String,Map<String,String>>.class);
     Map<String, Object> mdaMaps = (Map<String, Object>)JSON.deserializeUntyped(mdaConfig);
     for (String key1 : mdaMaps.keySet()) {
         Map<String, Object> valueMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(mdaMaps.get(key1)));
         mdaMaps.put(key1, valueMap);
     }
        system.debug('mdaMaps:'+mdaMaps);
         // init - log details
         log.StartTime__c      = System.now();
         log.EndTime__c        = System.now();
         log.SuccessCount__c   = 0;
         log.TotalCount__c     = 0;
         log.Type__c           = 'Order';
         log.SuccessIDs__c     = '';
         log.SAP_Error_Message__c = '';
         log.Error_Message__c     = '';
         // tool
         jinkosolarComEccCreateSoSyn.HTTPS_Port tool = new jinkosolarComEccCreateSoSyn.HTTPS_Port();
         jinkosolarComEccCreateSoSyn.DT_CreateSOSyn_Request T_PYTM = new jinkosolarComEccCreateSoSyn.DT_CreateSOSyn_Request();//付款方式
         T_PYTM.T_INPUT_PAY = new List<jinkosolarComEccCreateSoSyn.T_INPUT_PAY_element>();
         T_PYTM.T_INPUT_ITEM = new List<jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element>();
         T_PYTM.I_INPUT_HEAD= new jinkosolarComEccCreateSoSyn.I_INPUT_HEAD_element();//抬头
           T_PYTM.T_CFGS = new List<jinkosolarComEccCreateSoSyn.T_CFGS_element>();//抬头
         tool.timeout_x = 60000;
         //HttpRequest req = new HttpRequest(); 
         //req.setTimeout(2000); // timeout in milliseconds
         String Warranty ='';
         // order
         if( ord.SAP_Sales_Org__c == '1311' || ord.SAP_Sales_Org__c == '1591')
         {
              T_PYTM.I_INPUT_HEAD.AUART  = 'ZM02';
         }
         else if( ord.SAP_Sales_Org__c == '1181' || ord.SAP_Sales_Org__c == '1501')
         {
              T_PYTM.I_INPUT_HEAD.AUART  = 'YOR';
         }
          else if( con.RecordTypeId=='0121e0000002zCbAAI')
         {
              T_PYTM.I_INPUT_HEAD.AUART  = 'ZCIR';
         }
         else{
             T_PYTM.I_INPUT_HEAD.AUART='ZOR1';
         }
         if(ord.Order_Type__c=='Sample order'){
         T_PYTM.I_INPUT_HEAD.AUART  ='ZSP1' ;
             }
         system.debug('AUART---->'+ T_PYTM.I_INPUT_HEAD.AUART);
         
         T_PYTM.I_INPUT_HEAD.VKORG  = ord.SAP_Sales_Org__c;//销售组织 - 根据SELLER来Mapping
            system.debug('VKORG---->'+ T_PYTM.I_INPUT_HEAD.VKORG);
         T_PYTM.I_INPUT_HEAD.VTWEG  = '';//分销渠道 - 默认
         //T_PYTM.I_INPUT_HEAD.ZKBETR = con.Insurance_for_CIF__c+'';
        // system.debug('/////////////ZKBETR:'+T_PYTM.I_INPUT_HEAD.ZKBETR);
         T_PYTM.I_INPUT_HEAD.SPART  = '30';//产品组 - 默认
         T_PYTM.I_INPUT_HEAD.VKBUR  = '1000';//销售部门 - 默认
         T_PYTM.I_INPUT_HEAD.KUNNR  = '';//.toUpperCase().substring(0, 15);//客户编号
         T_PYTM.I_INPUT_HEAD.ZKUNNR = String.valueOf(ord.Account_Id__c);//String.valueOf(ord.Buyer__c);//.toUpperCase().substring(0, 15);//客户编号
          system.debug('ZKUNNR---->'+ T_PYTM.I_INPUT_HEAD.ZKUNNR);
         T_PYTM.I_INPUT_HEAD.zkunnrship  = String.valueOf(ord.Account_Id__c);//售达方 - 根据SELLER来Mapping
         T_PYTM.I_INPUT_HEAD.BSTKD  = con.Contract_NO__c;//ord.Id;//销售合同编号 - 改为订单ID con.Contract_NO__c
         system.debug('BSTKD---->'+ T_PYTM.I_INPUT_HEAD.BSTKD);
         T_PYTM.I_INPUT_HEAD.BSTDK  =String.valueOf(con.PO_PI_Date__c) == null ? '' : con.PO_PI_Date__c.YEAR()+'/'+con.PO_PI_Date__c.MONTH()+'/'+con.PO_PI_Date__c.DAY(); //合同签订日期 - contract - PO/PI Date
         system.debug('BSTDK---->'+ T_PYTM.I_INPUT_HEAD.BSTDK);
         T_PYTM.I_INPUT_HEAD.VDATU  = String.valueOf(con.Earliest_Delivery_Date__c) == null ? '' : con.Earliest_Delivery_Date__c.YEAR()+'/'+con.Earliest_Delivery_Date__c.MONTH()+'/'+con.Earliest_Delivery_Date__c.DAY(); //请求发货日期 - contract - expect delivery date
            system.debug('VDATU---->'+ T_PYTM.I_INPUT_HEAD.VDATU);
         //T_PYTM.I_INPUT_HEAD.TDDAT  = con.ETD__c;//请求交货日期--选填
         //system.debug('TDDAT---->'+ T_PYTM.I_INPUT_HEAD.TDDAT);
         T_PYTM.I_INPUT_HEAD.MBDAT  =String.valueOf(con.PO_PI_Date__c) == null ? '' : con.PO_PI_Date__c.YEAR()+'/'+con.PO_PI_Date__c.MONTH()+'/'+con.PO_PI_Date__c.DAY();//物料分段/有效日期 - contract - PO/PI Date
           system.debug('MBDAT---->'+ T_PYTM.I_INPUT_HEAD.MBDAT);
         T_PYTM.I_INPUT_HEAD.ZTERM  = '';//付款条件代码 - 不传值
         T_PYTM.I_INPUT_HEAD.ZLSCH  = 'U';//默认U      付款方式
         
                     T_PYTM.I_INPUT_HEAD.ZCONACT  = con.Contact_Name__c;
         T_PYTM.I_INPUT_HEAD.ZCONTEL  = con.Phone__c;
         T_PYTM.I_INPUT_HEAD.ZCONEMAL  = con.Email__c;
         
         //当订单的区域为South Asia时，ZLSCH值变为T
         List<User> owners = [Select id,region__c from user where id=:ord.ownerid];
         if(ord.Region__c=='South Asia' || (owners.size() > 0 && owners[0].Region__c=='North America') ||ord.SAP_Sales_Org__c == '1491'){//付款方式 更新了北美跨区的单子取owner的区域，不取订单区域
            T_PYTM.I_INPUT_HEAD.ZLSCH ='T'; 
         }
         
         T_PYTM.I_INPUT_HEAD.BNAME  = ord.Destination_Port__c;//定货人姓名
           system.debug('BNAME---->'+ T_PYTM.I_INPUT_HEAD.BNAME);
         T_PYTM.I_INPUT_HEAD.VSART  = ord.SAP_Shipping__c;//装运类型 - order - mapping by shipping type
           system.debug('VSART---->'+ T_PYTM.I_INPUT_HEAD.VSART);
         T_PYTM.I_INPUT_HEAD.ZREFERENCE =ord.delivery_note_CI__c;
         system.debug('ZREFERENCE---->'+ T_PYTM.I_INPUT_HEAD.ZREFERENCE);
         //2017.12.4 by han
         system.debug(' T_PYTM.I_INPUT_HEAD.ZZCPRICE-----11111----->'+ T_PYTM.I_INPUT_HEAD.ZZCPRICE);
         if(ord.Commission_Type__c =='Per/W'){
             //保留两位小数:
             //Decimal d=ord.Commission__c*1000;
             //d =d.setScale(2);
            T_PYTM.I_INPUT_HEAD.ZZCPRICE = String.valueof(ord.Commission_Value_sync_to_SAP__c);//佣金-order - Commission__c
               system.debug('ZZCPRICE---->'+ T_PYTM.I_INPUT_HEAD.ZZCPRICE);
         }else
        {
             //Decimal d=(ord.Commission__c/(ord.Total_MW__c*1000000))*1000;
             //d =d.setScale(2);
            if(ord.Actual_Commission__c ==null || ord.Actual_Commission__c==0){
             T_PYTM.I_INPUT_HEAD.ZZCPRICE = String.valueOf(ord.Commission_Value_sync_to_SAP__c);   
            }else{
             T_PYTM.I_INPUT_HEAD.ZZCPRICE = String.valueOf(ord.Actual_Commission__c); 
            }
             
             system.debug('ZZCPRICE---->'+ T_PYTM.I_INPUT_HEAD.ZZCPRICE);
        }                                                                                  //佣金-order - Commission__c
         system.debug(' T_PYTM.I_INPUT_HEAD.ZZCPRICE-----22222----->'+ T_PYTM.I_INPUT_HEAD.ZZCPRICE);
         if(ord.Trade_term__c!=null){
         if(ord.Trade_term__c.startsWith('EXW')){
             T_PYTM.I_INPUT_HEAD.INCO1 = 'EXW';//国际贸易条款1 - reqired - order - Trade term
         }else{
             T_PYTM.I_INPUT_HEAD.INCO1 = ord.Trade_term__c;//国际贸易条款1 - reqired - order - Trade term
         }
         }
         /**
         if(ord.Destination__c.length()>27){
             T_PYTM.I_INPUT_HEAD.INCO2 = ord.Destination__c.subString(0,27);//国际贸易条款2 - reqire - order - Destination  
               system.debug('ZZCPRICE---->'+ T_PYTM.I_INPUT_HEAD.INCO2);
         }else{
             T_PYTM.I_INPUT_HEAD.INCO2 = ord.Destination__c;
               system.debug('ZZCPRICE---->'+ T_PYTM.I_INPUT_HEAD.INCO2);
         }
*/
         if(ord.Destination_Port__c!=null && ord.Destination_Port__c!='' && ord.Destination_Port__c!='N/A'){
        String portcode=sapMap.getportCode(ord.Destination_Port__c);
             portcode=sapmap.changeCode(portcode,ord.Destination_Country__c);
             T_PYTM.I_INPUT_HEAD.INCO2=portcode;
             system.debug('INCO2:'+T_PYTM.I_INPUT_HEAD.INCO2);
             }else
                 { 
             T_PYTM.I_INPUT_HEAD.INCO2 = sapMap.getCountryCode(ord.Destination_Country__c);//国际贸易条款2 - reqire - order - Destination  
               }
         if(T_PYTM.I_INPUT_HEAD.INCO2==null || T_PYTM.I_INPUT_HEAD.INCO2==''){
             T_PYTM.I_INPUT_HEAD.INCO2=sapMap.getCountryCode(ord.Destination_Country__c);
         }
         else{
         if(T_PYTM.I_INPUT_HEAD.INCO2.length()>27){
             T_PYTM.I_INPUT_HEAD.INCO2=T_PYTM.I_INPUT_HEAD.INCO2.subString(0,27);
         }
         }
         T_PYTM.I_INPUT_HEAD.WAERK = ord.CurrencyIsoCode.subString(0,3);//SD凭证货币 - order - CurrencyIsoCode
            system.debug('WAERK---->'+ T_PYTM.I_INPUT_HEAD.WAERK);
         T_PYTM.I_INPUT_HEAD.AUGRU = opp.Order_reason__c;//订购原因(业务原因) - 不传
         T_PYTM.I_INPUT_HEAD.ZTXT1 = '';//订单备注 - 不传
         String str = '';
         T_PYTM.I_INPUT_HEAD.ZTXT2 = ord.Payment_Term_Description__c;
         system.debug('ZTXT2---->'+ T_PYTM.I_INPUT_HEAD.ZTXT2);
         /**
         if(ord.Payment_Term_Description__c.length()>130){
             T_PYTM.I_INPUT_HEAD.ZTXT2 = ord.Payment_Term_Description__c;//付款备注 - order - Payment Term Description
             str = ord.Payment_Term_Description__c;
             system.debug('----:' + T_PYTM.I_INPUT_HEAD.ZTXT2 + ord.Payment_Term_Description__c.length());
             system.debug('-----' + str.length());
         }else{
             T_PYTM.I_INPUT_HEAD.ZTXT2 = ord.Payment_Term_Description__c;
             system.debug('----:' + T_PYTM.I_INPUT_HEAD.ZTXT2);
         }
         */
         T_PYTM.I_INPUT_HEAD.ZZSACNO = con.Contract_NO__c;//Sales Contract No
          system.debug('ZZSACNO---->'+ T_PYTM.I_INPUT_HEAD.ZZSACNO);
         T_PYTM.I_INPUT_HEAD.ZZCPONO = con.SAP_Customer_PO_No__c;//Customer PO No
          system.debug('ZZCPONO---->'+ T_PYTM.I_INPUT_HEAD.ZZCPONO);
         T_PYTM.I_INPUT_HEAD.ZZPRJNO = con.SAP_Project_No__c;//Project No
          system.debug('ZZPRJNO---->'+ T_PYTM.I_INPUT_HEAD.ZZPRJNO);
         T_PYTM.I_INPUT_HEAD.ZXSZC = con.Sales_support__c;
            system.debug('ZXSZC---->'+ T_PYTM.I_INPUT_HEAD.ZXSZC);
            if(con.Inspection__c == '1，不需要') T_PYTM.I_INPUT_HEAD.ZZINSP = '1';
            else if(con.Inspection__c == '2，监造和验货') T_PYTM.I_INPUT_HEAD.ZZINSP = '2';
            else if(con.Inspection__c == '3，监造') T_PYTM.I_INPUT_HEAD.ZZINSP = '3';
            else if(con.Inspection__c == '4，验货（晶科指定）') T_PYTM.I_INPUT_HEAD.ZZINSP = '4';
            else if(con.Inspection__c == '5，验货（客户指定）') T_PYTM.I_INPUT_HEAD.ZZINSP = '5';
            else if(con.Inspection__c == '6，验货和监装') T_PYTM.I_INPUT_HEAD.ZZINSP = '6';
            else if(con.Inspection__c == '7，Other') {
                T_PYTM.I_INPUT_HEAD.ZZINSP = '7';
                T_PYTM.I_INPUT_HEAD.ZZINSP_TX = con.Inspection_Description__c;
            }
            system.debug('ZZINSP---->'+ T_PYTM.I_INPUT_HEAD.ZZINSP);
               system.debug('ZZINSP_TX---->'+ T_PYTM.I_INPUT_HEAD.ZZINSP_TX);            
         T_PYTM.I_INPUT_HEAD.ZZCOTL = con.Supervision__c == 'Yes' ? '1' : '2';//是否需要监造 - contract - Supervision
            system.debug('ZZCOTL---->'+ T_PYTM.I_INPUT_HEAD.ZZCOTL);            
         if(con.Limited_warranty__c == 'Non-linear warranty 10 years'){
             T_PYTM.I_INPUT_HEAD.ZZLWAR = '1';
         }else if(con.Limited_warranty__c == 'Linear warranty 10 years'){
             T_PYTM.I_INPUT_HEAD.ZZLWAR = '2';
         }else if(con.Limited_warranty__c == 'Other'){
             T_PYTM.I_INPUT_HEAD.ZZLWAR = '3';
             T_PYTM.I_INPUT_HEAD.ZZLWAR_TX = con.Limited_warranty_Description__c;
         }
          system.debug('ZZLWAR---->'+ T_PYTM.I_INPUT_HEAD.ZZLWAR);
          system.debug('ZZLWAR_TX---->'+ T_PYTM.I_INPUT_HEAD.ZZLWAR_TX);       
         T_PYTM.I_INPUT_HEAD.ZZPWAR = '1';//con.PowerGuard_Warranty__c == 'Yes' ? '1' : '2';//PowerGuard Warranty
           system.debug('ZZLWAR---->'+ T_PYTM.I_INPUT_HEAD.ZZLWAR);
         T_PYTM.I_INPUT_HEAD.ZZPBON = con.Performance_bond__c == true ? 'X' : '';//Performance bond
           system.debug('ZZPBON---->'+ T_PYTM.I_INPUT_HEAD.ZZPBON);
         T_PYTM.I_INPUT_HEAD.ZZWBON = con.Warranty_bond__c == true ? 'X' : '';//Warranty bond
           system.debug('ZZWBON---->'+ T_PYTM.I_INPUT_HEAD.ZZWBON);
         T_PYTM.I_INPUT_HEAD.ZZPCGU = con.Parent_Company_Guaranty__c == true ? 'X' : '';//Parent Company Guaranty
           system.debug('ZZPCGU---->'+ T_PYTM.I_INPUT_HEAD.ZZPCGU);
         T_PYTM.I_INPUT_HEAD.ZZBWAR = con.Bank_warranty__c == true ? 'X' : '';//Bank warranty
           system.debug('ZZBWAR---->'+ T_PYTM.I_INPUT_HEAD.ZZBWAR);
         T_PYTM.I_INPUT_HEAD.ZZAPGU = con.Advance_Payment_Guaranty__c == true ? 'X' : '';//Advance Payment Guaranty
           system.debug('ZZAPGU---->'+ T_PYTM.I_INPUT_HEAD.ZZAPGU);
         T_PYTM.I_INPUT_HEAD.ZZOBOM = con.Other_Related_bonds__c == true ? 'X' : '';//Other Related bonds
           system.debug('ZZOBOM---->'+ T_PYTM.I_INPUT_HEAD.ZZOBOM);
         T_PYTM.I_INPUT_HEAD.ZZOBOM_TX = con.Other_Related_bonds_Text__c == true ? 'X' : '';//Other Related bonds - Text
           system.debug('ZZOBOM_TX---->'+ T_PYTM.I_INPUT_HEAD.ZZOBOM_TX);
         T_PYTM.I_INPUT_HEAD.ZZRPTEU = con.Apply_For_EUC__c == true ? 'X' : '';//是否申报欧盟
           system.debug('ZZRPTEU---->'+ T_PYTM.I_INPUT_HEAD.ZZRPTEU);
         
         T_PYTM.I_INPUT_HEAD.VKGRP = ord.SAP_Region__c;
           system.debug('VKGRP---->'+ T_PYTM.I_INPUT_HEAD.VKGRP);
         
         for(User user : requestUserList){
             /*
             if(user.Country__c != null){
                 T_PYTM.I_INPUT_HEAD.VKGRP = SapMap.getSalesGroup(user.Country__c);//销售组 - user - mapping by country
                 system.debug('----->user:' + user.Name);
                 system.debug('----->user.country:' + user.Country__c);
                 system.debug('----->SapMap.getSalesGroup(user.Country__c):' + SapMap.getSalesGroup(user.Country__c));
             }else{
                 T_PYTM.I_INPUT_HEAD.VKGRP = '103';
             }
             */    
             
             T_PYTM.I_INPUT_HEAD.SORTL = String.valueOf(user.Id);//.toUpperCase().substring(0, 15);//业务员ID(CRMID) - 改为传SAP和CRM同步后的销售编码
             T_PYTM.I_INPUT_HEAD.LIFNR = '';//供应商或债权人的帐号
         }
           system.debug('SORTL---->'+ T_PYTM.I_INPUT_HEAD.SORTL);
         /**
         // new field
          if(ord.Payment_Term_Description__c.length()>130){
             T_PYTM.I_INPUT_HEAD.ZTXT3 = ord.Payment_Term_Description__c.subString(0,130);//付款备注 - order - Payment Term Description
          }else{
             T_PYTM.I_INPUT_HEAD.ZTXT3 = ord.Payment_Term_Description__c;
          }
         */
         T_PYTM.I_INPUT_HEAD.ZAREA     = '104';
             //ord.Region__c;
          system.debug('ZAREA---->'+ T_PYTM.I_INPUT_HEAD.ZAREA);
         T_PYTM.I_INPUT_HEAD.ZZLANDD   = sapMap.getCountryCode(ord.Destination_Country__c);
            system.debug('ZZLANDD---->'+ T_PYTM.I_INPUT_HEAD.ZZLANDD);
         if(ord.Warranty_Insurance__c =='No Insurance Required'){
            Warranty ='NONE';
         }else{
            Warranty = ord.Warranty_Insurance__c;
         }
         T_PYTM.I_INPUT_HEAD.ZZINSUR   = Warranty;
          system.debug('ZZINSUR---->'+ T_PYTM.I_INPUT_HEAD.ZZINSUR);
         T_PYTM.I_INPUT_HEAD.ZZLWAR_TX = ord.Warranty_On_Material_and_Workmanship__c;
          system.debug('ZZLWAR_TX---->'+ T_PYTM.I_INPUT_HEAD.ZZLWAR_TX);
         T_PYTM.I_INPUT_HEAD.ZZSALE1   = ord.SAP_User_ID__c == null ? '80000001' : ord.SAP_User_ID__c;
          system.debug('ZZSALE1---->'+ T_PYTM.I_INPUT_HEAD.ZZSALE1);
         
         
         List<User> S1=[select id,email from User where id=:ord.Contract_Owner__c];
         system.debug('2021/1/14');
         List<User> S2=[select id,email,SAP_User_ID__c from User where name=:ord.Sales_2__c];
         List<User> S3=[select id,email,SAP_User_ID__c from User where name=:ord.Sales_3__c];
          system.debug('2021/1/14'+S2.size());
           system.debug('2021/1/14'+S3.size());
         if(S1.size()>0){
             system.debug('2021/1/14'+S1.size());
         T_PYTM.I_INPUT_HEAD.ZZMAIL1=S1[0].email;
         }
           if(S2.size()>0){
         T_PYTM.I_INPUT_HEAD.ZZMAIL2=S2[0].email;
               T_PYTM.I_INPUT_HEAD.ZZSALE2   = S2[0].SAP_User_ID__c;
         }
          if(S3.size()>0){
         T_PYTM.I_INPUT_HEAD.ZZMAIL3=S3[0].email;
              T_PYTM.I_INPUT_HEAD.ZZSALE3   = S3[0].SAP_User_ID__c;
         }
          system.debug('2021/1/14');
         T_PYTM.I_INPUT_HEAD.ZZCRMORNO=ord.OrderNumber;
         T_PYTM.I_INPUT_HEAD.ZZKQY=ord.Cross_Region__c == true ? 'X' : '';
         T_PYTM.I_INPUT_HEAD.ZZOPID=ord.Opportunity__c;
         T_PYTM.I_INPUT_HEAD.ZZDTSP=msg=='1'? 'X' : '';
         
         system.debug('2021/1/14');
         for (Component_Task_Book__c ctb : ctbs) {
         if(String.isNotEmpty(ctb.Frame_B_side_Height__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Frame_B_side_Height')).get(ctb.Frame_B_side_Height__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Frame_B_side_Height');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Frame_B_side_Height__c;
            
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Frame_Color__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Frame_Color')).get(ctb.Frame_Color__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Frame_Color');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Frame_Color__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Module_Level__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Module_Level')).get(ctb.Module_Level__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Module_Level');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Module_Level__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Product_Certificate__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Product_Certificate')).get(ctb.Product_Certificate__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Product_Certificate');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Product_Certificate__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Rear_cover__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Rear_cover')).get(ctb.Rear_cover__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Rear_cover');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Rear_cover__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Frame_Type__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Frame_Type')).get(ctb.Frame_Type__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Frame_Type');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Frame_Type__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.LRF__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('LRF')).get(ctb.LRF__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - LRF');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.LRF__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Junction_Box_brand__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE =  (String) ((Map<String, Object>)mdaMaps.get('Junction_Box_brand')).get(ctb.Junction_Box_brand__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Junction_Box_brand');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Junction_Box_brand__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Junction_Box_Cable_Length__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Junction_Box_Cable_Length')).get(ctb.Junction_Box_Cable_Length__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Junction_Box_Cable_Length');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Junction_Box_Cable_Length__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Junction_Box_Connector__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Junction_Box_Connector')).get(ctb.Junction_Box_Connector__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Junction_Box_Connector');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Junction_Box_Connector__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.EVA__c)){
                jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                mdaMetrial.MDAID = ctb.Name;
                system.debug('2021/1/14');
                mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('EVA')).get(ctb.EVA__c);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - EVA');
                mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                mdaMetrial.VALUE_TXT = ctb.EVA__c;
                T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Front_Glass__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Front_Glass_Type')).get(ctb.Front_Glass__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Front_Glass_Type');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Front_Glass__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Glass_Thickness__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Glass_Thickness')).get(ctb.Glass_Thickness__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Glass_Thickness');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Glass_Thickness__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Rear_Cover_Material__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Rear_Cover_Material')).get(ctb.Rear_Cover_Material__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Rear_Cover_Material');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Rear_Cover_Material__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Mandatory_certification__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Mandatory_certification')).get(ctb.Mandatory_certification__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Mandatory_certification');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Mandatory_certification__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Additional_Certificate__c)){
              for (String ac : ctb.Additional_Certificate__c.split(';')) {
                 jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
                 mdaMetrial.MDAID = ctb.Name;
                 mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Additional_Certificate')).get(ac);
                if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Additional_Certificate');
                 mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
                 mdaMetrial.VALUE_TXT = ac;
                 T_PYTM.T_CFGS.add(mdaMetrial);
             }
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Package__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Package')).get(ctb.Package__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Package');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Package__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Current_Sorting__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Current_Sorting')).get(ctb.Current_Sorting__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Current_Sorting');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.Current_Sorting__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
              system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.C_side_type_of_short_frame__c)){
             jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
             mdaMetrial.MDAID = ctb.Name;
             mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('C_side_type_of_short_frame')).get(ctb.C_side_type_of_short_frame__c);
            if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - C_side_type_of_short_frame');
             mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
             mdaMetrial.VALUE_TXT = ctb.C_side_type_of_short_frame__c;
             T_PYTM.T_CFGS.add(mdaMetrial);
         }
                system.debug('2021/1/14');
         if(String.isNotEmpty(ctb.Nameplate__c)){
           jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
           mdaMetrial.MDAID = ctb.Name;
           mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Nameplate')).get(ctb.Nameplate__c);
        //    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Nameplate');
           mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
           mdaMetrial.VALUE_TXT = ctb.Nameplate__c;
           T_PYTM.T_CFGS.add(mdaMetrial);
       }
                system.debug('2021/1/14');
       if(String.isNotEmpty(ctb.Shipping_Mark__c)){
           jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
           mdaMetrial.MDAID = ctb.Name;
           mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Shipping_Mark')).get(ctb.Shipping_Mark__c);
        //    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Shipping_Mark');
           mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
           mdaMetrial.VALUE_TXT = ctb.Shipping_Mark__c;
           T_PYTM.T_CFGS.add(mdaMetrial);
       }
                system.debug('2021/1/14');
       if(String.isNotEmpty(ctb.Current_Sorting_Style__c)){
           jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
           mdaMetrial.MDAID = ctb.Name;
           mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Current_Sorting_Style')).get(ctb.Current_Sorting_Style__c);
        //    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Current_Sorting_Style');
           mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
           mdaMetrial.VALUE_TXT = ctb.Current_Sorting_Style__c;
           T_PYTM.T_CFGS.add(mdaMetrial);
       }
                system.debug('2021/1/14');
       if(String.isNotEmpty(ctb.Color_Sorting_style__c)){
           jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
           mdaMetrial.MDAID = ctb.Name;
           mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Color_Sorting_Style')).get(ctb.Color_Sorting_style__c);
        //    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Color_Sorting_Style');
           mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
           mdaMetrial.VALUE_TXT = ctb.Color_Sorting_style__c;
           T_PYTM.T_CFGS.add(mdaMetrial);
       }
                system.debug('2021/1/14');
       if(String.isNotEmpty(ctb.Additional_Shipping_Mark_Color_Label__c)){
           jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
           mdaMetrial.MDAID = ctb.Name;
           mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Additional_Shipping_Mark_Color_Label')).get(ctb.Additional_Shipping_Mark_Color_Label__c);
        //    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Additional_Shipping_Mark_Color_Label');
           mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
           mdaMetrial.VALUE_TXT = ctb.Additional_Shipping_Mark_Color_Label__c;
           T_PYTM.T_CFGS.add(mdaMetrial);
       }
                system.debug('2021/1/14');
       if(String.isNotEmpty(ctb.Cell__c)){
           jinkosolarComEccCreateSoSyn.T_CFGS_element mdaMetrial = new jinkosolarComEccCreateSoSyn.T_CFGS_element();
           mdaMetrial.MDAID = ctb.Name;
           mdaMetrial.VALUE = (String) ((Map<String, Object>)mdaMaps.get('Cell')).get(ctb.Cell__c);
        //    if (mdaMetrial.VALUE == null) throw new QW_Utils.QWException(ctb.Name + ' 特性错误 / Value Error - Cell');
           mdaMetrial.CHARC = mdaMetrial.VALUE != null ? mdaMetrial.VALUE.substring(0, 4) : null;
           mdaMetrial.VALUE_TXT = ctb.Cell__c;
           T_PYTM.T_CFGS.add(mdaMetrial);
       }
         System.debug(T_PYTM.T_CFGS);
     }
     
         
         
         if(ord.Cross_Region__c==true){
             if(ord.Contract_Owner__c=='005900000012G4M' || ord.Contract_Owner__c=='0056F000009rGL9'){
                  T_PYTM.I_INPUT_HEAD.ZZOANAME='qing.tian';
             }else if(ord.Seller_Region__c=='Key Account' ||ord.Seller_Region__c=='Central Asia' ){
                   T_PYTM.I_INPUT_HEAD.ZZOANAME='qing.tian';
             }
            
             else{
T_PYTM.I_INPUT_HEAD.ZZOANAME='xueli.sun';                   
             }
         }else{
                       T_PYTM.I_INPUT_HEAD.ZZOANAME=ord.Account_Owner_Sap_Id__c;
         }
         
         



            if(ord.SAP_Order_ID__c != null)T_PYTM.I_INPUT_HEAD.VBELN = ord.SAP_Order_ID__c;//订单ID
            system.debug('VBELN---->'+ T_PYTM.I_INPUT_HEAD.VBELN);          
            // orderlineitem
            String orderid  = ord.Id;
            List<OrderItem> orderItemList = Database.query(
                QW_Utils.getQueryBySObjectType(
                    'OrderItem',
                    new List<String>{'Order.Inventory_Type__c'}) + 
                ' WHERE OrderId =: orderid');
            // List<SapMap__c> orderItems = Database.query(
            //     QW_Utils.getQueryBySObjectType(
            //         'SapMap__c',
            //         new List<String>{'Agreement_Component__r.MDA__c', 'Agreement_Component__r.Battery_Type__c'}
            //     ) + ' WHERE Agreement__c = \'' + ord.Id + '\'');     

            for(OrderItem item : orderItemList){
                system.debug(item.Product2id);
                jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element ZBVAP = new jinkosolarComEccCreateSoSyn.T_INPUT_ITEM_element();

                system.debug('-------->RowNo:' + item.RowNo__c);
                ZBVAP.POSNR = String.valueOf(item.RowNo__c);//行号
                ZBVAP.ZZCRMORIT=String.valueOf(item.RowNo__c);

                system.debug('POSNR---->'+ ZBVAP.POSNR);       
                system.debug('----------crmLineItemNum' + String.valueOf(item.RowNo__c));
                system.debug('----------LineItemNum' + ZBVAP.POSNR);
                
                ZBVAP.MATNR = item.SAP_Materiel_No__c;// '24000043';//物料号 -- 【预留，需要做产品和老物料号的对应，之后用formula字段取值】
                system.debug('MATNR---->'+ ZBVAP.MATNR);
                system.debug('MDA---->'+ item.MDA__c);
                if (ZBVAP.MATNR == null) throw new QW_Utils.QWException(item.RowNo__c + ' row materiel number missing');

                // 产品等级 (转库存, 库存不用MDA)
                ZBVAP.ZTXT3 = item.Order != null ? item.Order.Inventory_Type__c : null;
                // TODO - MDA
                Component_Task_Book__c ctb = item.Product2Id != null ? itemNameCTBMaps.get(item.Product2Id) : null;
                if (ZBVAP.MATNR.startsWith('26') && ctb == null && ZBVAP.ZTXT3 != 'Inventory(Own inventory)') throw new QW_Utils.QWException(item.RowNo__c + ' row MDA missing, please check you order\'s [inventory type]');
                // if (ZBVAP.MATNR.startsWith('26')) ZBVAP.MDAID = ctb.Name;
                if (ZBVAP.MATNR.startsWith('26')) ZBVAP.MDAID = ctb != null ? ctb.Name : null;
                ZBVAP.KWMENG = String.valueOf(item.Quantity);//以销售单位表示的累计订单数量
                system.debug('KWMENG---->'+ ZBVAP.KWMENG); 
                ZBVAP.VRKME  = 'PC';//销售单位
                system.debug('VRKME---->'+ ZBVAP.VRKME); 
                // Decimal TaxUnitPrice = item.TaxUnitPrice__c.setScale(5);
                if(item.Product_Series__c=='Eagle Poly') ZBVAP.ZHYLZD3='0';
                else if(item.Product_Series__c=='Swan-P-BD') ZBVAP.ZHYLZD3='1';
                else if(item.Product_Series__c=='Swan-N-BD') ZBVAP.ZHYLZD3='2';
                else if(item.Product_Series__c=='Swan-TV') ZBVAP.ZHYLZD3='3';
                else if(item.Product_Series__c=='Cheetah-HC') ZBVAP.ZHYLZD3='4';
                else if(item.Product_Series__c=='Cheetah-FC') ZBVAP.ZHYLZD3='5';
                else if(item.Product_Series__c=='Connector') ZBVAP.ZHYLZD3='6';
                else if(item.Product_Series__c=='Smart-TI') ZBVAP.ZHYLZD3='7';
                else if(item.Product_Series__c=='Smart-TG') ZBVAP.ZHYLZD3='8';
                else if(item.Product_Series__c=='Smart-MX') ZBVAP.ZHYLZD3='9';
                else if(item.Product_Series__c=='Smart') ZBVAP.ZHYLZD3='10';
                else if(item.Product_Series__c=='Tiger-N-DG') ZBVAP.ZHYLZD3='11';
                else if(item.Product_Series__c=='Tiger-N-TB') ZBVAP.ZHYLZD3='12';
                else if(item.Product_Series__c=='Tiger-N') ZBVAP.ZHYLZD3='13';
                else if(item.Product_Series__c=='Tiger-P-DG') ZBVAP.ZHYLZD3='14';
                else if(item.Product_Series__c=='Tiger-P-TB') ZBVAP.ZHYLZD3='15';
                else if(item.Product_Series__c=='Tiger-P') ZBVAP.ZHYLZD3='16';
                else if(item.Product_Series__c=='Tiger') ZBVAP.ZHYLZD3='17';
                else if(item.Product_Series__c=='Swan Plus-N-DG') ZBVAP.ZHYLZD3='18';
                else if(item.Product_Series__c=='Swan Plus-N-TB') ZBVAP.ZHYLZD3='19';
                else if(item.Product_Series__c=='Swan Plus-P-DG') ZBVAP.ZHYLZD3='20';
                else if(item.Product_Series__c=='Swan Plus-P-TB') ZBVAP.ZHYLZD3='21';
                else if(item.Product_Series__c=='Cheetah Plus-N') ZBVAP.ZHYLZD3='22';
                else if(item.Product_Series__c=='Cheetah Plus-P') ZBVAP.ZHYLZD3='23';
                else if(item.Product_Series__c=='Swan-N-DG') ZBVAP.ZHYLZD3='24';
                else if(item.Product_Series__c=='Swan-N-TB') ZBVAP.ZHYLZD3='25';
                else if(item.Product_Series__c=='Swan-P-DG') ZBVAP.ZHYLZD3='26';
                else if(item.Product_Series__c=='Swan-P-TB') ZBVAP.ZHYLZD3='27';
                else if(item.Product_Series__c=='Eagle Poly-HC') ZBVAP.ZHYLZD3='28';
                else if(item.Product_Series__c=='Eagle Poly-FC') ZBVAP.ZHYLZD3='29';
                else if(item.Product_Series__c=='Eagle Perc-HC') ZBVAP.ZHYLZD3='30';
                else if(item.Product_Series__c=='Eagle Perc-FC') ZBVAP.ZHYLZD3='31';
                else if(item.Product_Series__c=='Cheetah-N-HC') ZBVAP.ZHYLZD3='32';
                else if(item.Product_Series__c=='Cheetah-N-FC') ZBVAP.ZHYLZD3='33';
                else if(item.Product_Series__c=='Cheetah-P-HC') ZBVAP.ZHYLZD3='34';
                else if(item.Product_Series__c=='Cheetah-P-FC') ZBVAP.ZHYLZD3='35';
                else if(item.Product_Series__c=='Others') ZBVAP.ZHYLZD3='36';
                else ZBVAP.ZZDCLX='';
                
                if(item.Battery_Type__c=='Poly 157') ZBVAP.ZZDCLX='0';
                else if(item.Battery_Type__c=='156.75 5BB Perc') ZBVAP.ZZDCLX='1';
                else if(item.Battery_Type__c=='158.75 5BB Perc') ZBVAP.ZZDCLX='2';
                else if(item.Battery_Type__c=='158.75 9BB Perc') ZBVAP.ZZDCLX='3';
                else if(item.Battery_Type__c=='163.75 9BB Perc') ZBVAP.ZZDCLX='4';
                else if(item.Battery_Type__c=='158.75 9BB N-type') ZBVAP.ZZDCLX='5';
                else if(item.Battery_Type__c=='163.75 9BB N-type') ZBVAP.ZZDCLX='6';
                else  ZBVAP.ZZDCLX='7';
                ZBVAP.KBETR  = String.valueOf(item.TaxUnitPrice__c.setScale(5));//价格 -- 产品单价 - sap有定价比例，低于一定价格会报错
                system.debug('KBETR---->'+ ZBVAP.KBETR); 
                ZBVAP.KONWA  = item.CurrencyIsoCode.subString(0,3);//比率单位
                system.debug('KONWA---->'+ ZBVAP.KONWA); 
                ZBVAP.KPEIN  = '';//条件定价单位
                
                ZBVAP.KMEIN  = 'W';//条件单位
                system.debug('KMEIN---->'+ ZBVAP.KMEIN); 
                ZBVAP.ZKBETR = '0.00';//价格 -- 海运费单价
                system.debug('ZKBETR---->'+ ZBVAP.ZKBETR); 
                ZBVAP.ZKONWA = item.CurrencyIsoCode.subString(0,3);//比率单位
                system.debug('ZKONWA---->'+ ZBVAP.ZKONWA); 
                ZBVAP.ZKPEIN = '';//条件定价单位
                ZBVAP.BSTKD_E= item.Test_code__c;// po Number
                ZBVAP.ZKMEIN = 'PC';//条件单位
                system.debug('ZKMEIN---->'+ ZBVAP.ZKMEIN); 
                ZBVAP.ZKBETR1 = '0.00';//价格 -- 保险费单价
                system.debug('ZKBETR1---->'+ ZBVAP.ZKBETR1); 
                ZBVAP.ZKONWA1 = item.CurrencyIsoCode.subString(0,3);//比率单位
                system.debug('ZKONWA1---->'+ ZBVAP.ZKONWA1); 
                ZBVAP.ZKPEIN1 = '';//条件定价单位
                ZBVAP.ZKMEIN1 = 'PC';//条件单位
                system.debug('ZKMEIN1---->'+ ZBVAP.ZKMEIN1); 
                ZBVAP.ZZCPONO = '';//Customer PO No
                ZBVAP.ZZPRJNO = '';//Project No
                ZBVAP.ZZBDMAT = con.Bonded_Material_Name__c;//Bonded Material 保税号
                system.debug('ZZBDMAT---->'+ ZBVAP.ZZBDMAT); 
                ZBVAP.WERKS   = con.SAP_Factory__c;//工厂
                system.debug('WERKS---->'+ ZBVAP.WERKS); 
                // new field
                //ZBVAP.ETDAT   = String.valueOf(item.Guaranteed_Delivery_Date__c).replace('-', '');//交货日期
                ZBVAP.ETDAT   = QW_Utils.dateToString(item.Guaranteed_Delivery_Date__c).replace('-', '');//交货日期 
                system.debug('ETDAT---->'+ ZBVAP.ETDAT); 
                ZBVAP.CRMNO   = String.valueOf(item.ID);//CRM行项目ID
                system.debug('CRMNO---->'+ ZBVAP.CRMNO); 
                T_PYTM.T_INPUT_ITEM.add(ZBVAP);
            }
     
         String JPpayment='';
         // payment
         List<Payment__c> payList = Database.query( Utils.MakeSelectSql('Payment__c')+' WHERE Order__c =: orderid');
         for(Payment__c pay : payList){
             jinkosolarComEccCreateSoSyn.T_INPUT_PAY_element PYTM2 = new jinkosolarComEccCreateSoSyn.T_INPUT_PAY_element();
             PYTM2.ZZRATPZ = String.valueOf(pay.Percentage__c);//这个SAP端需要能接收100%
              system.debug('ZZRATPZ---->'+  PYTM2.ZZRATPZ); 
             PYTM2.ZZPYP   = pay.Down_Balance_Payment__c;
              system.debug('ZZPYP---->'+  PYTM2.ZZPYP); 
             PYTM2.CRMPM   = pay.Payment_Method__c;
              system.debug('CRMPM---->'+  PYTM2.CRMPM); 
             PYTM2.ZZDAYS  = String.valueOf(pay.Days__c);
              system.debug('ZZDAYS---->'+  PYTM2.ZZDAYS); 
             PYTM2.ZZPYTM  = pay.Payment_Term__c;
             IF(ord.Region__c=='North Asia' && pay.Payment_Term__c!=null){
                 PYTM2.ZZPYTM=PYTM2.ZZPYTM.replace('X',String.valueOf(pay.Days__c));
                 PYTM2.ZZPYTM=PYTM2.ZZPYTM.replace('x%',String.valueOf(pay.Percentage__c)+'%');
             }
             JPpayment='---'+JPpayment+PYTM2.ZZPYTM;
              system.debug('ZZPYTM---->'+  PYTM2.ZZPYTM); 
             PYTM2.ZJZR    = String.valueOf(pay.Precise_Day__c);
              system.debug('ZJZR---->'+  PYTM2.ZJZR); 
             PYTM2.ZZCMNT  = pay.Comments__c;
              system.debug('ZZCMNT---->'+  PYTM2.ZZCMNT); 
             PYTM2.ZZCRDFLG = pay.Credit_Valid__c == true ? 'X' : '';//CRM Payment新增是否占用信用额度字段
              system.debug('ZZCRDFLG---->'+  PYTM2.ZZCRDFLG); 
            T_PYTM.T_INPUT_PAY.add(PYTM2);
         }
         if(ord.Region__c=='North Asia' && ord.Destination_Country__c=='Japan'){
         //   T_PYTM.I_INPUT_HEAD.ZTXT2= JPpayment;
         }
         system.debug('测试日本地区描述:'+T_PYTM.I_INPUT_HEAD.ZTXT2);
         // result
          system.debug('1-->'+T_PYTM.I_INPUT_HEAD);
          system.debug('2-->'+T_PYTM.T_INPUT_ITEM);
          system.debug('3-->'+T_PYTM.T_INPUT_PAY);
          system.debug('3-->'+T_PYTM.T_CFGS);
         jinkosolarComEccCreateSoSyn.DT_CreateSOSyn_Response result = tool.SI_CRM2ECC_CreateSOSyn_Out( T_PYTM.I_INPUT_HEAD,  T_PYTM.T_INPUT_ITEM, T_PYTM.T_INPUT_PAY,T_PYTM.T_CFGS); 
          system.debug('result-->'+result.RESULT);
         if( 'S'.equalsIgnoreCase( result.RESULT ) ){
             log.SuccessIDs__c += 'order sync: '+ ord.Id + ' & sap order id: ' + result.I_VBELN + '/';
             log.SuccessCount__c++;
             
             // give the sap order id to crm
               system.debug('result.I_VBELN-->'+result.I_VBELN);
             if(result.I_VBELN != null)ord.SAP_Order_ID__c = result.I_VBELN;
                system.debug('result.I_VBELN-->'+result.I_VBELN);
              system.debug('result.I_VBELN-->'+result.MESSTXT);
         }else{
             log.FailureIDs__c += 'order sync failed : '+ ord.Id + '/';
             log.SAP_Error_Message__c += result.MESSTXT;
             errorMsg = result.MESSTXT;
         }
         T=result.MESSTXT;
         
    }
     catch(Exception ex){
         // log crm error msg
         log.Error_Message__c = ex.getMessage();
         errorMsg = ex.getMessage();
         system.debug('------->Exception:' + errorMsg );
     }
        
     SapTools.uploadLogList.add(log);
return T;
     
 }
}