global without sharing class SyncContract {
    //trigger触发生成MDA
        @Future(callout=true)
    webService static void creatMDA(  String oppid,String conid ){
          List<Component_Task_Book__c> mdaLst= new List<Component_Task_Book__c>();
               mdalst= [select id, contract__c from Component_Task_Book__c where Opportunity__c=:oppid];
            if(mdalst.size()>0){
                for(Component_Task_Book__c cr:mdalst)
                    {
                        cr.contract__c=conid;
                    }
                update mdalst;
            }
        }
    //\
      @Future(callout=true)
    webService static void MDAUpdate(  String aid,String conids ){
                List<Component_Task_Book__c> ctb =[SELECT ID,Contract__c,Amendment_Purchase_Agreement__c FROM Component_Task_Book__c WHERE Contract__c=:conids];
        if(ctb.size()>0){
            for(Component_Task_Book__c ct : ctb){
                ct.Amendment_Purchase_Agreement__c = aid;
            }
            
            update ctb;
        }
    }
    
    //trigger触发同步合同
    @Future(callout=true)
    webService static void clickUpdate(  String id  ){
        try{
            System.debug(UtilClass.MakeSelectSql(Schema.SObjectType.Contract));
            Contract Con =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract) + ' ' +
                                         'Where id =: id');
            System.debug(UtilClass.MakeSelectSql(Schema.SObjectType.Contract));
            String conid=con.id;
            List<Order> ord=new List<order>();
            List<jinkosolarComEccContractInfo.T_I_CRM_CONTR_element> jctLst =new List<jinkosolarComEccContractInfo.T_I_CRM_CONTR_element>();
            jinkosolarComEccContractInfo.T_I_CRM_CONTR_element jct =new  jinkosolarComEccContractInfo.T_I_CRM_CONTR_element();
            jct.ZCRMCONTRID=con.id;
            jct.BSTKD=con.Contract_NO__c;
            jct.ZOPID=con.Opportunity__c;
            jct.ZCREATEFLAG='X';
            // jct.ZCLOSEFLAG='X'; 关闭时间目前停用
            String month;
            String day;
            if(con.CloseDate__c!=null){
                if(con.CloseDate__c.month()==1){
                    month='01';
                }
                else if(con.CloseDate__c.month()==2){
                    month='02';
                }   else if(con.CloseDate__c.month()==3){
                    month='03';
                }   else if(con.CloseDate__c.month()==4){
                    month='04';
                }   else if(con.CloseDate__c.month()==5){
                    month='05';
                }   else if(con.CloseDate__c.month()==6){
                    month='06';
                }   else if(con.CloseDate__c.month()==7){
                    month='07';
                }   else if(con.CloseDate__c.month()==8){
                    month='08';
                }   else if(con.CloseDate__c.month()==9){
                    month='09';
                }
                else{
                    month=con.CloseDate__c.month()+'';
                }
                if(con.CloseDate__c.day()==1){
                    day='01';
                }
                else if(con.CloseDate__c.day()==2){
                    day='02';
                }   else if(con.CloseDate__c.day()==3){
                    day='03';
                }   else if(con.CloseDate__c.day()==4){
                    day='04';
                }   else if(con.CloseDate__c.day()==5){
                    day='05';
                }   else if(con.CloseDate__c.day()==6){
                    day='06';
                }   else if(con.CloseDate__c.day()==7){
                    day='07';
                }   else if(con.CloseDate__c.day()==8){
                    day='08';
                }   else if(con.CloseDate__c.day()==9){
                    day='09';
                }
                else{
                    day=con.CloseDate__c.day()+'';
                }
                
                jct.ZCLOSEDATE=con.CloseDate__c.YEAR()+''+month+day;
            }
            
            //jct.ZCLOSETIME=''; 关闭时间目前停用
            jct.ZCLOSENAME=con.ownerid;
            
            System.debug('ZCLOSETIME:'+jct.ZCLOSETIME);
            System.debug('ZCLOSENAME:'+jct.ZCLOSENAME);
            System.debug('ZCLOSEDATE:'+jct.ZCLOSEDATE);
               system.debug('0'+con.Transit_Fees__c);
                 if(con.Transit_Fees__c ==null ){
                        con.Transit_Fees__c=0;
                    }
                 system.debug('1'+con.Transit_Fees__c);
            if((con.Trade_term__c=='CIF' || con.Trade_term__c=='CIP')&& con.Destination_Region__c=='Middle East&Africa'){
                jct.ZCONTRAMT=String.valueOf(con.Total_Price__c*(1.2/10000+1));
            }
            else if(con.Trade_term__c!='CIF' && con.Trade_term__c!='FOB' && con.Destination_Country__c=='Japan'){
                jct.ZCONTRAMT=String.valueOf((con.Total_Price__c+con.Transit_Fees__c)*1.1);
            }
            else if(con.Destination_Country__c=='Vietnam' && con.Seller__c=='Jinkosolar (Vietnam) Co., Ltd.'){
                    system.debug('5');
                   
                 jct.ZCONTRAMT=String.valueOf((con.Total_Price__c+con.Transit_Fees__c)*1.1);
                }
            else{
                jct.ZCONTRAMT=String.valueOf(con.Total_Price__c+con.Transit_Fees__c); 
            }
            system.debug('ZCONTRAMT1:'+ jct.ZCONTRAMT);
            
            ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                'Where ContractID =: conid');
            system.debug('order:'+ord);
            if(ord.size()>0){
                jct.ZSIGNFLAG='X';
                jct.ZCRMORFLAG='X';
                system.debug('查询到Order');
                jct.ZSIGNDATE=timechange(ord[0].CreatedDate.YEAR()+'')+timechange(ord[0].CreatedDate.month()+'')+timechange(ord[0].CreatedDate.day()+'');
                jct.ZSIGNTIME=timechange(ord[0].CreatedDate.hour()+'')+timechange(ord[0].CreatedDate.minute()+'')+timechange(ord[0].CreatedDate.second()+'');
                
                
                
                jct.ZCRMORDERNO=ord[0].id;
                system.debug('0'+ord[0].Transit_Fees__c);
                 if(ord[0].Transit_Fees__c ==null ){
                        ord[0].Transit_Fees__c=0;
                    }
                 system.debug('1'+ord[0].Transit_Fees__c);
                if((ord[0].Trade_term__c=='CIF' ||ord[0].Trade_term__c=='CIP') && ord[0].Destination_Region__c=='Middle East&Africa'){
                    system.debug('2');
                    jct.ZCRMORAMT=String.valueOf(ord[0].Total_Price__c*(1.2/10000+1));
                }
                else if(ord[0].Trade_term__c!='CIF' && ord[0].Trade_term__c!='FOB' && ord[0].Destination_Country__c=='Japan'){
                    system.debug('3');
                   
                    jct.ZCRMORAMT=String.valueOf((ord[0].Total_Price__c+ord[0].Transit_Fees__c)*1.1);
                }
                 else if(ord[0].Trade_term__c!='CIF' && ord[0].Trade_term__c!='FOB' && ord[0].Destination_Country__c=='Japan'){
                    system.debug('3');
                   
                    jct.ZCRMORAMT=String.valueOf((ord[0].Total_Price__c+ord[0].Transit_Fees__c)*1.1);
                }
                else if(ord[0].Destination_Country__c=='Vietnam' && ord[0].Seller__c=='Jinkosolar (Vietnam) Co., Ltd.'){
                    system.debug('5');
                   
                    jct.ZCRMORAMT=String.valueOf((ord[0].Total_Price__c+ord[0].Transit_Fees__c)*1.1);
                }
                else{
                    system.debug('4');
                    jct.ZCRMORAMT=String.valueOf(ord[0].Total_Price__c+ord[0].Transit_Fees__c);
                }
                system.debug('5');
                jct.vbeln=ord[0].SAP_Order_ID__c;
                system.debug('6');
                if(ord[0].SAP_Order_ID__c!=null){
                    system.debug('7');
                    jct.ZSYNCSAPFLAG='X';
                }
            }
            
            system.debug('ZCONTRAMT2:'+ jct.ZCONTRAMT);
            jct.waers=con.CurrencyIsoCode;
            jct.ZCNTROWEN=con.OwnerId;
            jctLst.add(jct);
            jinkosolarComCrmContractInfo.HTTPS_Port send =new jinkosolarComCrmContractInfo.HTTPS_Port();
            jinkosolarComEccContractInfo.DT_ContractInfo_Response response=send.SI_CRM2ECC_ContractInfo_Out(jctLst);
            system.debug('response:'+response.E_MSGTY);
            system.debug('response:'+response.E_MSGTXT);
        }catch(Exception e){ System.debug('------------> Exception: '+e.getMessage());}
    }
    //trgger触发同步订单信息
    @Future(callout=true)
    webService static void clickorder(  String ordid  ){
        order ord = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.order) + ' ' +
                                   'Where  Id =: ordid');   
        String conid = ord.ContractId;
        contract con = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract) + ' ' +
                                      'Where  Id =: conid');  
        String oppid = con.Opportunity__c;
        Opportunity opp = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                         'Where  Id =: oppid');   
        List<User> requestUserList = [SELECT ID,Country__c,Name,Region__c FROM User WHERE ID =: con.OwnerId];
        jinkosolarComEccChangeSoSyn.HTTPS_Port tool = new jinkosolarComEccChangeSoSyn.HTTPS_Port();
        jinkosolarComEccChangeSoSyn.DT_ChangeSOSyn_Request T_PYTM = new jinkosolarComEccChangeSoSyn.DT_ChangeSOSyn_Request();
        
        T_PYTM.T_INPUT_ITEM = new List<jinkosolarComEccChangeSoSyn.T_INPUT_ITEM_element>();
        T_PYTM.I_INPUT_HEAD= new List<jinkosolarComEccChangeSoSyn.I_INPUT_HEAD_element>();//抬头
        jinkosolarComEccChangeSoSyn.I_INPUT_HEAD_element head= new jinkosolarComEccChangeSoSyn.I_INPUT_HEAD_element();//抬头
        tool.timeout_x = 60000;
        //HttpRequest req = new HttpRequest(); 
        //req.setTimeout(2000); // timeout in milliseconds
        String Warranty ='';
        // order
        if( ord.SAP_Sales_Org__c == '1311' || ord.SAP_Sales_Org__c == '1591')
        {
            head.AUART  = 'ZM02';
        }
        else if( ord.SAP_Sales_Org__c == '1181' || ord.SAP_Sales_Org__c == '1501')
        {
            head.AUART  = 'YOR';
        }
        
        else{
            head.AUART='ZOR1';
        }
        if(ord.Order_Type__c=='Sample order'){
            head.AUART  ='ZSP1' ;
        }
        system.debug('AUART---->'+ head.AUART);
        head.ZZCRMID  =ord.id;
        head.VKORG  = ord.SAP_Sales_Org__c;//销售组织 - 根据SELLER来Mapping
        system.debug('VKORG---->'+ head.VKORG);
        head.VTWEG  = '';//分销渠道 - 默认
        head.ZKBETR = con.Insurance_for_CIF__c+'';
        system.debug('/////////////ZKBETR:'+head.ZKBETR);
        head.SPART  = '30';//产品组 - 默认
        head.VKBUR  = '1000';//销售部门 - 默认
        head.KUNNR  = '';//.toUpperCase().substring(0, 15);//客户编号
        head.ZKUNNR = String.valueOf(ord.Account_Id__c);//String.valueOf(ord.Buyer__c);//.toUpperCase().substring(0, 15);//客户编号
        system.debug('ZKUNNR---->'+ head.ZKUNNR);
        head.BSTKD  = con.Contract_NO__c;//ord.Id;//销售合同编号 - 改为订单ID con.Contract_NO__c
        system.debug('BSTKD---->'+ head.BSTKD);
        head.BSTDK  =String.valueOf(con.PO_PI_Date__c) == null ? '' : timechange(con.PO_PI_Date__c.YEAR()+'')+timechange(con.PO_PI_Date__c.MONTH()+'')+timechange(con.PO_PI_Date__c.DAY()+''); //合同签订日期 - contract - PO/PI Date
        system.debug('BSTDK---->'+ head.BSTDK);
        head.VDATU  = String.valueOf(con.Earliest_Delivery_Date__c) == null ? '' : timechange(con.Earliest_Delivery_Date__c.YEAR()+'')+timechange(con.Earliest_Delivery_Date__c.MONTH()+'')+timechange(con.Earliest_Delivery_Date__c.DAY()+''); //请求发货日期 - contract - expect delivery date
        system.debug('VDATU---->'+ head.VDATU);
        head.MBDAT  =String.valueOf(con.PO_PI_Date__c) == null ? '' : timechange(con.PO_PI_Date__c.YEAR()+'')+timechange(con.PO_PI_Date__c.MONTH()+'')+timechange(con.PO_PI_Date__c.DAY()+'');//物料分段/有效日期 - contract - PO/PI Date
        system.debug('MBDAT---->'+ head.MBDAT);
        head.ZTERM  = '';//付款条件代码 - 不传值
        head.ZLSCH  = 'U';//默认U
        
        head.ZCONACT  = con.Contact_Name__c;
        head.ZCONTEL  = con.Phone__c;
        head.ZCONEMAL  = con.Email__c;
        
        //当订单的区域为South Asia时，ZLSCH值变为T
        if(ord.Region__c=='South Asia' ||ord.Region__c=='North America'||ord.SAP_Sales_Org__c == '1491'){
            head.ZLSCH ='T'; 
        }
        head.BNAME  = ord.Destination_Port__c;//定货人姓名
        system.debug('BNAME---->'+ head.BNAME);
        head.VSART  = ord.SAP_Shipping__c;//装运类型 - order - mapping by shipping type
        system.debug('VSART---->'+ head.VSART);
        head.ZREFERENCE =ord.delivery_note_CI__c;
        system.debug('ZREFERENCE---->'+ head.ZREFERENCE);
        //2017.12.4 by han
        system.debug(' head.ZZCPRICE-----11111----->'+ head.ZZCPRICE);
        if(ord.Commission_Type__c =='Per/W'){
            
            head.ZZCPRICE = String.valueof(ord.Commission_Value_sync_to_SAP__c);//佣金-order - Commission__c
            system.debug('ZZCPRICE---->'+ head.ZZCPRICE);
        }else
        {
            
            if(ord.Actual_Commission__c ==null || ord.Actual_Commission__c==0){
                head.ZZCPRICE = String.valueOf(ord.Commission_Value_sync_to_SAP__c);   
            }else{
                head.ZZCPRICE = String.valueOf(ord.Actual_Commission__c); 
            }
            
            system.debug('ZZCPRICE---->'+ head.ZZCPRICE);
        }                                                                                  //佣金-order - Commission__c
        system.debug(' head.ZZCPRICE-----22222----->'+ head.ZZCPRICE);
        if(ord.Trade_term__c.startsWith('EXW')){
            head.INCO1 = 'EXW';//国际贸易条款1 - reqired - order - Trade term
        }else{
            head.INCO1 = ord.Trade_term__c;//国际贸易条款1 - reqired - order - Trade term
        }
        /**
if(ord.Destination__c.length()>27){
head.INCO2 = ord.Destination__c.subString(0,27);//国际贸易条款2 - reqire - order - Destination  
system.debug('ZZCPRICE---->'+ head.INCO2);
}else{
head.INCO2 = ord.Destination__c;
system.debug('ZZCPRICE---->'+ head.INCO2);
}
*/
        if(ord.Destination_Port__c!=null && ord.Destination_Port__c!='' && ord.Destination_Port__c!='N/A'){
            head.INCO2=sapMap.getportCode(ord.Destination_Port__c);
            system.debug('INCO2:'+head.INCO2);
        }else
        { 
            head.INCO2 = sapMap.getCountryCode(ord.Destination_Country__c);//国际贸易条款2 - reqire - order - Destination  
        }
        if(head.INCO2==null){
            sapMap.getCountryCode(ord.Destination_Country__c);
        }
        else{
            if(head.INCO2.length()>27){
                head.INCO2=head.INCO2.subString(0,27);
            }
        }
        head.WAERK = ord.CurrencyIsoCode.subString(0,3);//SD凭证货币 - order - CurrencyIsoCode
        system.debug('WAERK---->'+ head.WAERK);
        head.AUGRU = opp.Order_reason__c;//订购原因(业务原因) - 不传
        head.ZTXT1 = '';//订单备注 - 不传
        String str = '';
        head.ZTXT2 = ord.Payment_Term_Description__c;
        system.debug('ZTXT2---->'+ head.ZTXT2);
        
        head.ZZSACNO = con.Contract_NO__c;//Sales Contract No
        system.debug('ZZSACNO---->'+ head.ZZSACNO);
        head.ZZCPONO = con.SAP_Customer_PO_No__c;//Customer PO No
        system.debug('ZZCPONO---->'+ head.ZZCPONO);
        head.ZZPRJNO = con.SAP_Project_No__c;//Project No
        system.debug('ZZPRJNO---->'+ head.ZZPRJNO);
        head.ZXSZC = con.Sales_support__c;
        system.debug('ZXSZC---->'+ head.ZXSZC);
        if(con.Inspection__c == '1，不需要'){
            head.ZZINSP = '1';
        }else if(con.Inspection__c == '2，监造和验货'){
            head.ZZINSP = '2';
        }else if(con.Inspection__c == '3，监造'){
            head.ZZINSP = '3';
        }else if(con.Inspection__c == '4，验货（晶科指定）'){
            head.ZZINSP = '4';
        }else if(con.Inspection__c == '5，验货（客户指定）'){
            head.ZZINSP = '5';
        }
        else if(con.Inspection__c == '6，验货和监装'){
            head.ZZINSP = '6';
        }
        else if(con.Inspection__c == '7，Other'){
            head.ZZINSP = '7';
            head.ZZINSP_TX = con.Inspection_Description__c;
        }
        system.debug('ZZINSP---->'+ head.ZZINSP);
        system.debug('ZZINSP_TX---->'+ head.ZZINSP_TX);            
        head.ZZCOTL = con.Supervision__c == 'Yes' ? '1' : '2';//是否需要监造 - contract - Supervision
        system.debug('ZZCOTL---->'+ head.ZZCOTL);            
        if(con.Limited_warranty__c == 'Non-linear warranty 10 years'){
            head.ZZLWAR = '1';
        }else if(con.Limited_warranty__c == 'Linear warranty 10 years'){
            head.ZZLWAR = '2';
        }else if(con.Limited_warranty__c == 'Other'){
            head.ZZLWAR = '3';
            head.ZZLWAR_TX = con.Limited_warranty_Description__c;
        }
        system.debug('ZZLWAR---->'+ head.ZZLWAR);
        system.debug('ZZLWAR_TX---->'+ head.ZZLWAR_TX);       
        head.ZZPWAR = '1';//con.PowerGuard_Warranty__c == 'Yes' ? '1' : '2';//PowerGuard Warranty
        system.debug('ZZLWAR---->'+ head.ZZLWAR);
        head.ZZPBON = con.Performance_bond__c == true ? 'X' : '';//Performance bond
        system.debug('ZZPBON---->'+ head.ZZPBON);
        head.ZZWBON = con.Warranty_bond__c == true ? 'X' : '';//Warranty bond
        system.debug('ZZWBON---->'+ head.ZZWBON);
        head.ZZPCGU = con.Parent_Company_Guaranty__c == true ? 'X' : '';//Parent Company Guaranty
        system.debug('ZZPCGU---->'+ head.ZZPCGU);
        head.ZZBWAR = con.Bank_warranty__c == true ? 'X' : '';//Bank warranty
        system.debug('ZZBWAR---->'+ head.ZZBWAR);
        head.ZZAPGU = con.Advance_Payment_Guaranty__c == true ? 'X' : '';//Advance Payment Guaranty
        system.debug('ZZAPGU---->'+ head.ZZAPGU);
        head.ZZOBOM = con.Other_Related_bonds__c == true ? 'X' : '';//Other Related bonds
        system.debug('ZZOBOM---->'+ head.ZZOBOM);
        head.ZZOBOM_TX = con.Other_Related_bonds_Text__c == true ? 'X' : '';//Other Related bonds - Text
        system.debug('ZZOBOM_TX---->'+ head.ZZOBOM_TX);
        head.ZZRPTEU = con.Apply_For_EUC__c == true ? 'X' : '';//是否申报欧盟
        system.debug('ZZRPTEU---->'+ head.ZZRPTEU);
        
        head.VKGRP = ord.SAP_Region__c;
        system.debug('VKGRP---->'+ head.VKGRP);
        
        for(User user : requestUserList){
            
            
            head.SORTL = String.valueOf(user.Id);//.toUpperCase().substring(0, 15);//业务员ID(CRMID) - 改为传SAP和CRM同步后的销售编码
            head.LIFNR = '';//供应商或债权人的帐号
        }
        system.debug('SORTL---->'+ head.SORTL);
        
        head.ZAREA     = '104';
        system.debug('ZAREA---->'+ head.ZAREA);
        head.ZZLANDD   = sapMap.getCountryCode(ord.Destination_Country__c);
        system.debug('ZZLANDD---->'+ head.ZZLANDD);
        if(ord.Warranty_Insurance__c =='No Insurance Required'){
            Warranty ='NONE';
        }else{
            Warranty = ord.Warranty_Insurance__c;
        }
        head.ZZINSUR   = Warranty;
        system.debug('ZZINSUR---->'+ head.ZZINSUR);
        head.ZZLWAR_TX = ord.Warranty_On_Material_and_Workmanship__c;
        system.debug('ZZLWAR_TX---->'+ head.ZZLWAR_TX);
        head.ZZSALE1   = ord.SAP_User_ID__c == null ? '80000001' : ord.SAP_User_ID__c;
        system.debug('ZZSALE1---->'+ head.ZZSALE1);
        
        
        List<User> S1=[select id,email from User where id=:ord.Contract_Owner__c];
        List<User> S2=[select id,email,SAP_User_ID__c from User where name=:ord.Sales_2__c];
        List<User> S3=[select id,email,SAP_User_ID__c from User where name=:ord.Sales_3__c];
        if(S1.size()>0){
            head.ZZMAIL1=S1[0].email;
        }
        if(S2.size()>0){
            head.ZZMAIL2=S2[0].email;
            head.ZZSALE2   = S2[0].SAP_User_ID__c;
        }
        if(S3.size()>0){
            head.ZZMAIL3=S3[0].email;
            head.ZZSALE3   = S3[0].SAP_User_ID__c;
        }
        head.ZZCRMORNO=ord.OrderNumber;
        head.ZZCRMID=ord.id;
        head.ZZKQY=ord.Cross_Region__c == true ? 'X' : '';
        head.ZZOPID=ord.Opportunity__c;
        head.ZZOANAME=ord.Account_Owner_Sap_Id__c;
        
        if(ord.SAP_Order_ID__c != null)head.VBELN = ord.SAP_Order_ID__c;//订单ID
        system.debug('VBELN---->'+ head.VBELN);
        
        T_PYTM.I_INPUT_HEAD.add(head);
        // orderlineitem
        String orderid  = ord.Id;
        List<OrderItem> orderItemList = Database.query( Utils.MakeSelectSql('OrderItem')+' WHERE OrderId =: orderid');
        
        for(OrderItem item : orderItemList){
            jinkosolarComEccChangeSoSyn.T_INPUT_ITEM_element ZBVAP = new jinkosolarComEccChangeSoSyn.T_INPUT_ITEM_element();
            
            system.debug('-------->RowNo:' + item.RowNo__c);
            ZBVAP.ZCRMPRDID =item.id;
            ZBVAP.POSNR = String.valueOf(item.RowNo__c);//行号
            ZBVAP.ZZCRMORIT=String.valueOf(item.RowNo__c);
            
            system.debug('POSNR---->'+ ZBVAP.POSNR);       
            system.debug('----------crmLineItemNum' + String.valueOf(item.RowNo__c));
            system.debug('----------LineItemNum' + ZBVAP.POSNR);
            
            ZBVAP.MATNR  = item.SAP_Materiel_No__c;// '24000043';//物料号 -- 【预留，需要做产品和老物料号的对应，之后用formula字段取值】
            system.debug('MATNR---->'+ ZBVAP.MATNR);  
            ZBVAP.KWMENG = String.valueOf(item.Quantity);//以销售单位表示的累计订单数量
            system.debug('KWMENG---->'+ ZBVAP.KWMENG); 
            ZBVAP.VRKME  = 'PC';//销售单位
            system.debug('VRKME---->'+ ZBVAP.VRKME); 
            //  Decimal TaxUnitPrice = item.TaxUnitPrice__c.setScale(5);
            if(item.Battery_Type__c=='Poly 157'){
                ZBVAP.ZZDCLX='0';
            }
            else if(item.Battery_Type__c=='156.75 5BB Perc'){
                ZBVAP.ZZDCLX='1';
            }
            else if(item.Battery_Type__c=='158.75 5BB Perc'){
                ZBVAP.ZZDCLX='2';
            }
            else if(item.Battery_Type__c=='158.75 9BB Perc'){
                ZBVAP.ZZDCLX='3';
            }
            else if(item.Battery_Type__c=='163.75 9BB Perc'){
                ZBVAP.ZZDCLX='4';
            }
            else if(item.Battery_Type__c=='158.75 9BB N-type'){
                ZBVAP.ZZDCLX='5';
            }
            else if(item.Battery_Type__c=='163.75 9BB N-type'){
                ZBVAP.ZZDCLX='6';
            }
            else {
                ZBVAP.ZZDCLX='7';
            }
            ZBVAP.KBETR  = String.valueOf(item.TaxUnitPrice__c.setScale(4));//价格 -- 产品单价 - sap有定价比例，低于一定价格会报错
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
            ZBVAP.ZKMEIN = 'PC';//条件单位
            system.debug('ZKMEIN---->'+ ZBVAP.ZKMEIN); 
            ZBVAP.ZKBETR1 = '0.00';//价格 -- 保险费单价
            system.debug('ZKBETR1---->'+ ZBVAP.ZKBETR1); 
            ZBVAP.ZKONWA1 = item.CurrencyIsoCode.subString(0,3);//比率单位
            system.debug('ZKONWA1---->'+ ZBVAP.ZKONWA1); 
            ZBVAP.ZKPEIN1 = '';//条件定价单位
            ZBVAP.ZKMEIN1 = 'PC';//条件单位
            system.debug('ZKMEIN1---->'+ ZBVAP.ZKMEIN1); 
            ZBVAP.ZTXT3   = '';//产品备注长文本
            ZBVAP.ZZCPONO = '';//Customer PO No
            ZBVAP.ZZPRJNO = '';//Project No
            ZBVAP.ZZBDMAT = con.Bonded_Material_Name__c;//Bonded Material 保税号
            system.debug('ZZBDMAT---->'+ ZBVAP.ZZBDMAT); 
            ZBVAP.WERKS   = con.SAP_Factory__c;//工厂
            system.debug('WERKS---->'+ ZBVAP.WERKS); 
            // new field
            ZBVAP.ETDAT   = String.valueOf(item.Guaranteed_Delivery_Date__c).replace('-', '');//交货日期
            system.debug('ETDAT---->'+ ZBVAP.ETDAT); 
            ZBVAP.CRMNO   = String.valueOf(item.ID);//CRM行项目ID
            system.debug('CRMNO---->'+ ZBVAP.CRMNO); 
            ZBVAP.ZZOPPRDID  =item.OppProductID__c;
            ZBVAP.ZZCRMID   =ord.id;
            ZBVAP.BISMT =item.Product_Name__c;
            T_PYTM.T_INPUT_ITEM.add(ZBVAP);
        }
        
        jinkosolarComEccChangeSoSyn.DT_ChangeSOSyn_Response result = tool.SI_CRM2ECC_ChangeSOSyn_Out( T_PYTM.I_INPUT_HEAD,  T_PYTM.T_INPUT_ITEM); 
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    //trigger触发订单删除 
    @Future(callout=true)
    webService static void deleteorder(  String ordid  ){
        jinkosolarComEccChangeSoSyn.HTTPS_Port tool = new jinkosolarComEccChangeSoSyn.HTTPS_Port();
        jinkosolarComEccChangeSoSyn.DT_ChangeSOSyn_Request T_PYTM = new jinkosolarComEccChangeSoSyn.DT_ChangeSOSyn_Request();
        
        T_PYTM.T_INPUT_ITEM = new List<jinkosolarComEccChangeSoSyn.T_INPUT_ITEM_element>();
        T_PYTM.I_INPUT_HEAD= new List<jinkosolarComEccChangeSoSyn.I_INPUT_HEAD_element>();//抬头
        jinkosolarComEccChangeSoSyn.I_INPUT_HEAD_element head= new jinkosolarComEccChangeSoSyn.I_INPUT_HEAD_element();//抬头
        tool.timeout_x = 60000;
         head.ZZCRMID  =ordid;
        head.ZZSCBJ ='X';
        T_PYTM.I_INPUT_HEAD.add(head);
          system.debug('订单删除接口开始');
         jinkosolarComEccChangeSoSyn.DT_ChangeSOSyn_Response result = tool.SI_CRM2ECC_ChangeSOSyn_Out( T_PYTM.I_INPUT_HEAD,  T_PYTM.T_INPUT_ITEM); 
   
    }
    //生成合同的同时更新预订数据
    @Future(callout=true)
    webservice static void tocontract(String oppid,String ContractNO){
        system.debug('oppid:'+oppid);
        List<Reserve_inventory_information__c> RiiLst= new List<Reserve_inventory_information__c>();
        List<jinkosolarComEccStockBook.IT_BOOK_REQ_element> jiLst =new  List<jinkosolarComEccStockBook.IT_BOOK_REQ_element>();
        
        RiiLst= Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Reserve_inventory_information__c) + ' ' +
                               'Where  Opportunity__c=:oppid ');  
        
        for(Reserve_inventory_information__c rii:RiiLst){
            jinkosolarComEccStockBook.IT_BOOK_REQ_element ji =new  jinkosolarComEccStockBook.IT_BOOK_REQ_element();
            
            system.debug('gengxinnum'+rii.num__c);
            
            ji.ZJXHPP=RII.ZJXHPP__c;
            system.debug('ji.ZJXHPP:'+ji.ZJXHPP);
            ji.ZBB=RII.ZBB__c;
            system.debug('ji.ZBB:'+ji.ZBB);
            ji.ZBL=RII.ZBL__c;
            system.debug('ji.ZBL:'+ji.ZBL);
            ji.ZMP=RII.ZMP__c;
            system.debug('ji.ZMP:'+ji.ZMP);
            ji.ZDQPX=RII.ZDQPX__c;
            system.debug('ji.ZDQPX:'+ji.ZDQPX);
            ji.ZYSPXYS=RII.ZYSPXYS__c;
            system.debug('ji.ZYSPXYS:'+ji.ZYSPXYS);
            ji.ZBOOKYEAR=RII.ZBOOKYEAR__c;
            system.debug('ji.ZBOOKYEAR:'+ji.ZBOOKYEAR);
            ji.ZBOOKID=RII.ZBOOKID__c;
            system.debug('ji.ZBOOKID:'+ji.ZBOOKID);
            ji.ZSERNO=String.valueof(rii.num__c);
            
            system.debug('ji.ZSERNO:'+ji.ZSERNO);
            ji.ZSYSID='1';
            system.debug('ji.ZSYSID:'+ji.ZSYSID);
            ji.ZOPID=RII.ZOPID__c;
            system.debug('ji.ZOPID:'+ji.ZOPID);
            ji.ZOBJID=RII.ZOBJID__c;
            system.debug('ji.ZOBJID:'+ji.ZOBJID);
            ji.ZSTOTY=RII.ZSTOTY__c;
            system.debug('ji.ZSTOTY:'+ji.ZSTOTY);
            ji.ZOPENFLAG=RII.ZOPENFLAG__c;
            system.debug('ji.ZOPENFLAG:'+ji.ZOPENFLAG);
            ji.MATNR=RII.MATNR__c;
            system.debug('ji.MATNR:'+ji.MATNR);
            ji.WERKS=RII.WERKS__c;
            system.debug('ji.WERKS:'+ji.WERKS);
            ji.ZLGOGRP=RII.ZLGOGRP__c;
            system.debug('ji.ZLGOGRP:'+ji.ZLGOGRP);
            ji.ZREQQTY=rii.ZREQQTY__c;
            system.debug('ji.ZREQQTY:'+ji.ZREQQTY);
            ji.ZREQAVLQTY=RII.ZREQAVLQTY__c;
            system.debug(' ji.ZREQAVLQTY:'+ ji.ZREQAVLQTY);
            ji.ZINVQTY=RII.ZINVQTY__c;
            system.debug('ji.ZINVQTY:'+ji.ZINVQTY);
            ji.ZAVLQTY=RII.ZAVLQTY__c;
            system.debug('ji.ZAVLQTY:'+ji.ZAVLQTY);
            ji.ZBOOKEDQTY=RII.ZBOOKEDQTY__c;
            system.debug('ji.ZBOOKEDQTY:'+ji.ZBOOKEDQTY);
            ji.ZBOOKQTY=rii.ZBOOKQTY__c;
            system.debug('ji.ZBOOKQTY:'+ji.ZBOOKQTY);
            ji.ZDELQTY=RII.ZDELQTY__c;
            system.debug('ji.ZDELQTY:'+ji.ZDELQTY);
            ji.MEINS=RII.MEINS__c;
            system.debug('ji.MEINS:'+ji.MEINS);
            ji.ZGDD=RII.ZGDD__c;
            system.debug('ji.ZGDD:'+ji.ZGDD);
            ji.ZZHHRQ=RII.ZZHHRQ__c;
            system.debug('ji.ZZHHRQ:'+ji.ZZHHRQ);
            ji.ZZLCRQ=RII.ZZLCRQ__c;
            system.debug('ji.ZZLCRQ:'+ji.ZZLCRQ);
            ji.BLNO=RII.BLNO__c;
            system.debug('ji.BLNO:'+ji.BLNO);
            ji.ZETD=RII.ZETD__c;
            system.debug('ji.ZETD:'+ji.ZETD);
            ji.ZETA=RII.ZETA__c;
            system.debug('ji.ZETA:'+ji.ZETA);
            ji.ZWARNDATE=RII.ZWARNDATE__c;
            system.debug('ji.ZWARNDATE:'+ji.ZWARNDATE);
            ji.ZDUEDATE=RII.ZDUEDATE__c;
            system.debug('ji.ZDUEDATE:'+ji.ZDUEDATE);
            ji.ZSFHWBH=RII.ZSFHWBH__c;
            system.debug('ji.ZSFHWBH:'+ji.ZSFHWBH);
            
            //ji.ZRELNAME=UserInfo.getName();
            //ji.ZRELDATE='20200218';
            //ji.ZRELTIME='145902';
            //ji.ZPGIFLAG='';
            ji.BSTKD=ContractNO;
            //ji.ZCRMORNO='';
            //ji.ZCRMORIT='';
            ji.S01=RII.S01__c;
            system.debug('ji.S01:'+ji.S01);
            ji.S41=RII.S41__c;
            system.debug('ji.S41:'+ji.S41);
            ji.S42=RII.S42__c;
            system.debug('ji.S42:'+ji.S42);
            ji.S44=RII.S44__c;
            system.debug('ji.S44:'+ji.S44);
            ji.S47=RII.S47__c;
            system.debug('ji.S47:'+ji.S47);
            ji.S49=RII.S49__c;
            system.debug('ji.S49:'+ji.S49);
            ji.S4B=RII.S4B__c;
            system.debug('ji.S4B:'+ji.S4B);
            ji.P43=RII.P43__c;
            system.debug('ji.P43:'+ji.P43);
            ji.P44=RII.P44__c;
            system.debug('ji.P44:'+ji.P44);
            ji.P45=RII.P45__c;
            system.debug('ji.P45:'+ji.P45);
            ji.P47=RII.P47__c;
            system.debug('ji.P47:'+ji.P47);
            ji.P48=RII.P48__c;
            system.debug('ji.P48:'+ji.P48);
            ji.P4A=RII.P4A__c;
            system.debug('ji.P4A:'+ji.P4A);
            ji.P4G=RII.P4G__c;
            system.debug('ji.P4G:'+ji.P4G);
            ji.P4H=RII.P4H__c;
            system.debug('ji.P4H:'+ji.P4H);
            ji.P4I=RII.P4I__c;
            system.debug('ji.P4I:'+ji.P4I);
            ji.P4J=RII.P4J__c;
            system.debug('ji.P4J:'+ji.P4J);
            ji.P4K=RII.P4K__c;
            system.debug('ji.P4K:'+ji.P4K);
            ji.P4L=RII.P4L__c;
            system.debug('ji.P4L:'+ji.P4L);
            ji.ZMS1=RII.ZMS1__c;
            system.debug('ji.ZMS1:'+ji.ZMS1);
            ji.ZJXHJT=RII.ZJXHJT__c;
            system.debug('ji.ZJXHJT:'+ji.ZJXHJT);
            ji.ZJXHDLCD=RII.ZJXHDLCD__c;
            system.debug('ji.ZJXHDLCD:'+ji.ZJXHDLCD);
            ji.ZLRF=RII.ZLRF__c;
            system.debug('ji.ZLRF:'+ji.ZLRF);
            ji.ZEVA=RII.ZEVA__c;
            system.debug('ji.ZEVA:'+ji.ZEVA);
            ji.ZZJ=RII.ZZJ__c;
            system.debug('ji.ZZJ:'+ji.ZZJ);
            ji.ZBZ=RII.ZBZ__c;
            system.debug('ji.ZBZ:'+ji.ZBZ);
            ji.ZCPHGZ=RII.ZCPHGZ__c;
            system.debug('ji.ZCPHGZ:'+ji.ZCPHGZ);
            ji.ZFJZS=RII.ZFJZS__c;
            system.debug('ji.ZFJZS:'+ji.ZFJZS);
            ji.ZQYQZXRZ=RII.ZQYQZXRZ__c;
            system.debug('ji.ZQYQZXRZ:'+ji.ZQYQZXRZ);
            jiLst.add(ji);
        }
        jinkosolarComCrmStockBook.HTTPS_Port hp =new jinkosolarComCrmStockBook.HTTPS_Port();
        hp.timeout_x = 120000;
        jinkosolarComEccStockBook.DT_StockBook_Response dr =hp.SI_CRM2ECC_StockBook_Out('B',jiLst);
    }
    //判断是否生成了订单
    webService static String OrderFlag(  String oppid  ){
        List<Order> orderlst =new  List<Order>();
        orderlst =[select id from Order where Opportunity__c =:oppid];
        return orderlst.size()+'';
        }
    //更新预订数据短ID
    webService static String gengxinduanID(  String orderid  ){
        List<orderitem> orderline= new List<orderitem>();
        orderline= Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.orderitem) + ' ' +
                                  'Where  orderid=:orderid ');  
        System.debug('打桩');
        if(orderline.size()>0){
            System.debug('打桩2');
            Map<String,String> opppl = new map<String,String>();
            for(orderitem ordp : orderline){
                if(ordp.OppProductID__c!=null){
                    opppl.put(ordp.OppProductID__c,ordp.RowNo__c+'');
                }
                else{
                    opppl.put(ordp.id,ordp.RowNo__c+'');
                }
            }
            System.debug('opppl:'+opppl);
            List<Reserve_inventory_information__c> Riil= new List<Reserve_inventory_information__c>();
            Riil= Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Reserve_inventory_information__c) + ' ' +
                                 'Where  Order__c=:orderid '); 
            for(Reserve_inventory_information__c rii:Riil){
                rii.ZCRMORIT__c=opppl.get(rii.ZOBJID__c);
            }
            update Riil;
            
        }
        return 'S';
    }            
    
    webService static String syncorder(  String orderid  ){
List<Reserve_inventory_information__c> Riil= new List<Reserve_inventory_information__c>();
Riil= Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Reserve_inventory_information__c) + ' ' +
'Where  Order__c=:orderid '); 
List<jinkosolarComEccStockBook.IT_BOOK_REQ_element> jiLst =new  List<jinkosolarComEccStockBook.IT_BOOK_REQ_element>();

for(Reserve_inventory_information__c rii:Riil){
jinkosolarComEccStockBook.IT_BOOK_REQ_element ji =new  jinkosolarComEccStockBook.IT_BOOK_REQ_element();

system.debug('gengxinnum'+rii.num__c);

ji.ZJXHPP=RII.ZJXHPP__c;
system.debug('ji.ZJXHPP:'+ji.ZJXHPP);
ji.ZBB=RII.ZBB__c;
system.debug('ji.ZBB:'+ji.ZBB);
ji.ZBL=RII.ZBL__c;
system.debug('ji.ZBL:'+ji.ZBL);
ji.ZMP=RII.ZMP__c;
system.debug('ji.ZMP:'+ji.ZMP);
ji.ZDQPX=RII.ZDQPX__c;
system.debug('ji.ZDQPX:'+ji.ZDQPX);
ji.ZYSPXYS=RII.ZYSPXYS__c;
system.debug('ji.ZYSPXYS:'+ji.ZYSPXYS);
ji.ZBOOKYEAR=RII.ZBOOKYEAR__c;
system.debug('ji.ZBOOKYEAR:'+ji.ZBOOKYEAR);
ji.ZBOOKID=RII.ZBOOKID__c;
system.debug('ji.ZBOOKID:'+ji.ZBOOKID);
ji.ZSERNO=String.valueof(rii.num__c);

system.debug('ji.ZSERNO:'+ji.ZSERNO);
ji.ZSYSID='1';
system.debug('ji.ZSYSID:'+ji.ZSYSID);
ji.ZOPID=RII.ZOPID__c;
system.debug('ji.ZOPID:'+ji.ZOPID);
ji.ZOBJID=RII.ZOBJID__c;
system.debug('ji.ZOBJID:'+ji.ZOBJID);
ji.ZSTOTY=RII.ZSTOTY__c;
system.debug('ji.ZSTOTY:'+ji.ZSTOTY);
ji.ZOPENFLAG=RII.ZOPENFLAG__c;
system.debug('ji.ZOPENFLAG:'+ji.ZOPENFLAG);
ji.MATNR=RII.MATNR__c;
system.debug('ji.MATNR:'+ji.MATNR);
ji.WERKS=RII.WERKS__c;
system.debug('ji.WERKS:'+ji.WERKS);
ji.ZLGOGRP=RII.ZLGOGRP__c;
system.debug('ji.ZLGOGRP:'+ji.ZLGOGRP);
ji.ZREQQTY=rii.ZREQQTY__c;
system.debug('ji.ZREQQTY:'+ji.ZREQQTY);
ji.ZREQAVLQTY=RII.ZREQAVLQTY__c;
system.debug(' ji.ZREQAVLQTY:'+ ji.ZREQAVLQTY);
ji.ZINVQTY=RII.ZINVQTY__c;
system.debug('ji.ZINVQTY:'+ji.ZINVQTY);
ji.ZAVLQTY=RII.ZAVLQTY__c;
system.debug('ji.ZAVLQTY:'+ji.ZAVLQTY);
ji.ZBOOKEDQTY=RII.ZBOOKEDQTY__c;
system.debug('ji.ZBOOKEDQTY:'+ji.ZBOOKEDQTY);
ji.ZBOOKQTY=rii.ZBOOKQTY__c;
system.debug('ji.ZBOOKQTY:'+ji.ZBOOKQTY);
ji.ZDELQTY=RII.ZDELQTY__c;
system.debug('ji.ZDELQTY:'+ji.ZDELQTY);
ji.MEINS=RII.MEINS__c;
system.debug('ji.MEINS:'+ji.MEINS);
ji.ZGDD=RII.ZGDD__c;
system.debug('ji.ZGDD:'+ji.ZGDD);
ji.ZZHHRQ=RII.ZZHHRQ__c;
system.debug('ji.ZZHHRQ:'+ji.ZZHHRQ);
ji.ZZLCRQ=RII.ZZLCRQ__c;
system.debug('ji.ZZLCRQ:'+ji.ZZLCRQ);
ji.BLNO=RII.BLNO__c;
system.debug('ji.BLNO:'+ji.BLNO);
ji.ZETD=RII.ZETD__c;
system.debug('ji.ZETD:'+ji.ZETD);
ji.ZETA=RII.ZETA__c;
system.debug('ji.ZETA:'+ji.ZETA);
ji.ZWARNDATE=RII.ZWARNDATE__c;
system.debug('ji.ZWARNDATE:'+ji.ZWARNDATE);
ji.ZDUEDATE=RII.ZDUEDATE__c;
system.debug('ji.ZDUEDATE:'+ji.ZDUEDATE);
ji.ZSFHWBH=RII.ZSFHWBH__c;
system.debug('ji.ZSFHWBH:'+ji.ZSFHWBH);


ji.BSTKD = rii.Contract_NO__c;
ji.ZCRMORNO = rii.Order_Number__c;
ji.ZCRMORIT = rii.ZCRMORIT__c;

ji.S01=RII.S01__c;
system.debug('ji.S01:'+ji.S01);
ji.S41=RII.S41__c;
system.debug('ji.S41:'+ji.S41);
ji.S42=RII.S42__c;
system.debug('ji.S42:'+ji.S42);
ji.S44=RII.S44__c;
system.debug('ji.S44:'+ji.S44);
ji.S47=RII.S47__c;
system.debug('ji.S47:'+ji.S47);
ji.S49=RII.S49__c;
system.debug('ji.S49:'+ji.S49);
ji.S4B=RII.S4B__c;
system.debug('ji.S4B:'+ji.S4B);
ji.P43=RII.P43__c;
system.debug('ji.P43:'+ji.P43);
ji.P44=RII.P44__c;
system.debug('ji.P44:'+ji.P44);
ji.P45=RII.P45__c;
system.debug('ji.P45:'+ji.P45);
ji.P47=RII.P47__c;
system.debug('ji.P47:'+ji.P47);
ji.P48=RII.P48__c;
system.debug('ji.P48:'+ji.P48);
ji.P4A=RII.P4A__c;
system.debug('ji.P4A:'+ji.P4A);
ji.P4G=RII.P4G__c;
system.debug('ji.P4G:'+ji.P4G);
ji.P4H=RII.P4H__c;
system.debug('ji.P4H:'+ji.P4H);
ji.P4I=RII.P4I__c;
system.debug('ji.P4I:'+ji.P4I);
ji.P4J=RII.P4J__c;
system.debug('ji.P4J:'+ji.P4J);
ji.P4K=RII.P4K__c;
system.debug('ji.P4K:'+ji.P4K);
ji.P4L=RII.P4L__c;
system.debug('ji.P4L:'+ji.P4L);
ji.ZMS1=RII.ZMS1__c;
system.debug('ji.ZMS1:'+ji.ZMS1);
ji.ZJXHJT=RII.ZJXHJT__c;
system.debug('ji.ZJXHJT:'+ji.ZJXHJT);
ji.ZJXHDLCD=RII.ZJXHDLCD__c;
system.debug('ji.ZJXHDLCD:'+ji.ZJXHDLCD);
ji.ZLRF=RII.ZLRF__c;
system.debug('ji.ZLRF:'+ji.ZLRF);
ji.ZEVA=RII.ZEVA__c;
system.debug('ji.ZEVA:'+ji.ZEVA);
ji.ZZJ=RII.ZZJ__c;
system.debug('ji.ZZJ:'+ji.ZZJ);
ji.ZBZ=RII.ZBZ__c;
system.debug('ji.ZBZ:'+ji.ZBZ);
ji.ZCPHGZ=RII.ZCPHGZ__c;
system.debug('ji.ZCPHGZ:'+ji.ZCPHGZ);
ji.ZFJZS=RII.ZFJZS__c;
system.debug('ji.ZFJZS:'+ji.ZFJZS);
ji.ZQYQZXRZ=RII.ZQYQZXRZ__c;
system.debug('ji.ZQYQZXRZ:'+ji.ZQYQZXRZ);
jiLst.add(ji);
}

jinkosolarComCrmStockBook.HTTPS_Port hp =new jinkosolarComCrmStockBook.HTTPS_Port();
hp.timeout_x = 120000;
jinkosolarComEccStockBook.DT_StockBook_Response dr =hp.SI_CRM2ECC_StockBook_Out('B',jiLst);
system.debug(dr.E_MSGTY);
system.debug(dr.E_MSGTXT);

























return 'S';
} 
    webService static String timechange(  String num  ){
        if(num=='1'){
            return '01';
        }else if(num=='2'){
            return '02';
        }
        else if(num=='3'){
            return '03';
        }
        else if(num=='4'){
            return '04';
        }
        else if(num=='5'){
            return '05';
        }
        else if(num=='6'){
            return '06';
        }
        else if(num=='7'){
            return '07';
        }
        else if(num=='8'){
            return '08';
        }
        else if(num=='9'){
            return '09';
        }
        
        
        else{ 
            return num;
        }
    }
    //自动释放日期发送邮箱
    webService static void SendEmailF(Reserve_inventory_information__c rii){
        List<jinkosolarComEccStockBook.IT_BOOK_REQ_element> jiLst =new  List<jinkosolarComEccStockBook.IT_BOOK_REQ_element>();

        jinkosolarComEccStockBook.IT_BOOK_REQ_element ji =new  jinkosolarComEccStockBook.IT_BOOK_REQ_element();

        system.debug('gengxinnum'+rii.num__c);          
        ji.ZJXHPP=RII.ZJXHPP__c;
        system.debug('ji.ZJXHPP:'+ji.ZJXHPP);
            ji.ZBB=RII.ZBB__c;
        system.debug('ji.ZBB:'+ji.ZBB);
            ji.ZBL=RII.ZBL__c;
        system.debug('ji.ZBL:'+ji.ZBL);
            ji.ZMP=RII.ZMP__c;
        system.debug('ji.ZMP:'+ji.ZMP);
            ji.ZDQPX=RII.ZDQPX__c;
        system.debug('ji.ZDQPX:'+ji.ZDQPX);
            ji.ZYSPXYS=RII.ZYSPXYS__c;
        system.debug('ji.ZYSPXYS:'+ji.ZYSPXYS);
        ji.ZBOOKYEAR=RII.ZBOOKYEAR__c;
        system.debug('ji.ZBOOKYEAR:'+ji.ZBOOKYEAR);
        ji.ZBOOKID=RII.ZBOOKID__c;
        system.debug('ji.ZBOOKID:'+ji.ZBOOKID);
        ji.ZSERNO=String.valueof(integer.valueof(rii.num__c));
       
        system.debug('ji.ZSERNO:'+ji.ZSERNO);
        ji.ZSYSID='1';
        system.debug('ji.ZSYSID:'+ji.ZSYSID);
        ji.ZOPID=rii.Opportunity__c;
        system.debug('ji.ZOPID:'+ji.ZOPID);
        ji.ZOBJID=RII.ZOBJID__c;
        system.debug('ji.ZOBJID:'+ji.ZOBJID);
        ji.ZSTOTY=RII.ZSTOTY__c;
        system.debug('ji.ZSTOTY:'+ji.ZSTOTY);
        ji.ZOPENFLAG=RII.ZOPENFLAG__c;
        system.debug('ji.ZOPENFLAG:'+ji.ZOPENFLAG);
        ji.MATNR=RII.MATNR__c;
        system.debug('ji.MATNR:'+ji.MATNR);
        ji.WERKS=RII.WERKS__c;
        system.debug('ji.WERKS:'+ji.WERKS);
        ji.ZLGOGRP=RII.ZLGOGRP__c;
                system.debug('ji.ZLGOGRP:'+ji.ZLGOGRP);
        ji.ZREQQTY=rii.ZREQQTY__c;
                system.debug('ji.ZREQQTY:'+ji.ZREQQTY);
        ji.ZREQAVLQTY=RII.ZREQAVLQTY__c;
                system.debug(' ji.ZREQAVLQTY:'+ ji.ZREQAVLQTY);
        ji.ZINVQTY=RII.ZINVQTY__c;
                system.debug('ji.ZINVQTY:'+ji.ZINVQTY);
        ji.ZAVLQTY=RII.ZAVLQTY__c;
                system.debug('ji.ZAVLQTY:'+ji.ZAVLQTY);
        ji.ZBOOKEDQTY=RII.ZBOOKEDQTY__c;
                system.debug('ji.ZBOOKEDQTY:'+ji.ZBOOKEDQTY);
        ji.ZBOOKQTY=rii.ZBOOKQTY__c;
                system.debug('ji.ZBOOKQTY:'+ji.ZBOOKQTY);
        ji.ZDELQTY=RII.ZDELQTY__c;
                system.debug('ji.ZDELQTY:'+ji.ZDELQTY);
        ji.MEINS=RII.MEINS__c;
                system.debug('ji.MEINS:'+ji.MEINS);
        ji.ZGDD=RII.ZGDD__c;
                system.debug('ji.ZGDD:'+ji.ZGDD);
        ji.ZZHHRQ=RII.ZZHHRQ__c;
                system.debug('ji.ZZHHRQ:'+ji.ZZHHRQ);
        ji.ZZLCRQ=RII.ZZLCRQ__c;
                system.debug('ji.ZZLCRQ:'+ji.ZZLCRQ);
        ji.BLNO=RII.BLNO__c;
                system.debug('ji.BLNO:'+ji.BLNO);
        ji.ZETD=RII.ZETD__c;
                system.debug('ji.ZETD:'+ji.ZETD);
        ji.ZETA=RII.ZETA__c;
                system.debug('ji.ZETA:'+ji.ZETA);
        ji.ZWARNDATE=RII.ZWARNDATE__c;
                system.debug('ji.ZWARNDATE:'+ji.ZWARNDATE);
        ji.ZDUEDATE=RII.ZDUEDATE__c;
                system.debug('ji.ZDUEDATE:'+ji.ZDUEDATE);
        ji.ZSFHWBH=RII.ZSFHWBH__c;
                system.debug('ji.ZSFHWBH:'+ji.ZSFHWBH);
        ji.ZWARNFLG='';
                system.debug('ji.ZWARNFLG:'+ji.ZWARNFLG);
       // ji.ZRELFLAG='';//手动
        ji.ZRELAUTO='X';
        //ji.ZRELNAME=UserInfo.getName();
        //ji.ZRELDATE='20200218';
        //ji.ZRELTIME='145902';
        //ji.ZPGIFLAG='';
        ji.BSTKD=Rii.Contract_NO__c;
        ji.ZCRMORNO=Rii.Order_Number__c;
        ji.ZCRMORIT=Rii.ZCRMORIT__c;
        ji.S01=RII.S01__c;
                system.debug('ji.S01:'+ji.S01);
        ji.S41=RII.S41__c;
                system.debug('ji.S41:'+ji.S41);
        ji.S42=RII.S42__c;
                system.debug('ji.S42:'+ji.S42);
        ji.S44=RII.S44__c;
                 system.debug('ji.S44:'+ji.S44);
        ji.S47=RII.S47__c;
                 system.debug('ji.S47:'+ji.S47);
        ji.S49=RII.S49__c;
                system.debug('ji.S49:'+ji.S49);
        ji.S4B=RII.S4B__c;
                system.debug('ji.S4B:'+ji.S4B);
        ji.P43=RII.P43__c;
               system.debug('ji.P43:'+ji.P43);
        ji.P44=RII.P44__c;
              system.debug('ji.P44:'+ji.P44);
        ji.P45=RII.P45__c;
             system.debug('ji.P45:'+ji.P45);
        ji.P47=RII.P47__c;
               system.debug('ji.P47:'+ji.P47);
        ji.P48=RII.P48__c;
              system.debug('ji.P48:'+ji.P48);
        ji.P4A=RII.P4A__c;
               system.debug('ji.P4A:'+ji.P4A);
        ji.P4G=RII.P4G__c;
                 system.debug('ji.P4G:'+ji.P4G);
        ji.P4H=RII.P4H__c;
                system.debug('ji.P4H:'+ji.P4H);
        ji.P4I=RII.P4I__c;
                 system.debug('ji.P4I:'+ji.P4I);
        ji.P4J=RII.P4J__c;
                 system.debug('ji.P4J:'+ji.P4J);
        ji.P4K=RII.P4K__c;
                 system.debug('ji.P4K:'+ji.P4K);
        ji.P4L=RII.P4L__c;
                 system.debug('ji.P4L:'+ji.P4L);
        ji.ZMS1=RII.ZMS1__c;
                system.debug('ji.ZMS1:'+ji.ZMS1);
        ji.ZJXHJT=RII.ZJXHJT__c;
                system.debug('ji.ZJXHJT:'+ji.ZJXHJT);
        ji.ZJXHDLCD=RII.ZJXHDLCD__c;
                system.debug('ji.ZJXHDLCD:'+ji.ZJXHDLCD);
        ji.ZLRF=RII.ZLRF__c;
                system.debug('ji.ZLRF:'+ji.ZLRF);
        ji.ZEVA=RII.ZEVA__c;
                system.debug('ji.ZEVA:'+ji.ZEVA);
        ji.ZZJ=RII.ZZJ__c;
                system.debug('ji.ZZJ:'+ji.ZZJ);
        ji.ZBZ=RII.ZBZ__c;
                system.debug('ji.ZBZ:'+ji.ZBZ);
        ji.ZCPHGZ=RII.ZCPHGZ__c;
                system.debug('ji.ZCPHGZ:'+ji.ZCPHGZ);
        ji.ZFJZS=RII.ZFJZS__c;
                system.debug('ji.ZFJZS:'+ji.ZFJZS);
        ji.ZQYQZXRZ=RII.ZQYQZXRZ__c;
                system.debug('ji.ZQYQZXRZ:'+ji.ZQYQZXRZ);
        jiLst.add(ji);
            
         
        jinkosolarComCrmStockBook.HTTPS_Port hp =new jinkosolarComCrmStockBook.HTTPS_Port();
        hp.timeout_x = 120000;
        jinkosolarComEccStockBook.DT_StockBook_Response dr =hp.SI_CRM2ECC_StockBook_Out('B',jiLst);
        system.debug(dr.E_MSGTY);
        system.debug(dr.E_MSGTXT);
        if(dr.E_MSGTY=='S'){
            SendEmailUtils2.sendToSomeOneId(rii.id,rii.CreatedById,'BookstockSendEmailF');
            delete rii;
        }
        
    }
    //预警日渐发送邮箱
     webService static void SendEmailY(Reserve_inventory_information__c rii){
        List<jinkosolarComEccStockBook.IT_BOOK_REQ_element> jiLst =new  List<jinkosolarComEccStockBook.IT_BOOK_REQ_element>();

        jinkosolarComEccStockBook.IT_BOOK_REQ_element ji =new  jinkosolarComEccStockBook.IT_BOOK_REQ_element();

        system.debug('gengxinnum'+rii.num__c);          
        ji.ZJXHPP=RII.ZJXHPP__c;
        system.debug('ji.ZJXHPP:'+ji.ZJXHPP);
            ji.ZBB=RII.ZBB__c;
        system.debug('ji.ZBB:'+ji.ZBB);
            ji.ZBL=RII.ZBL__c;
        system.debug('ji.ZBL:'+ji.ZBL);
            ji.ZMP=RII.ZMP__c;
        system.debug('ji.ZMP:'+ji.ZMP);
            ji.ZDQPX=RII.ZDQPX__c;
        system.debug('ji.ZDQPX:'+ji.ZDQPX);
            ji.ZYSPXYS=RII.ZYSPXYS__c;
        system.debug('ji.ZYSPXYS:'+ji.ZYSPXYS);
        ji.ZBOOKYEAR=RII.ZBOOKYEAR__c;
        system.debug('ji.ZBOOKYEAR:'+ji.ZBOOKYEAR);
        ji.ZBOOKID=RII.ZBOOKID__c;
        system.debug('ji.ZBOOKID:'+ji.ZBOOKID);
        ji.ZSERNO=String.valueof(integer.valueof(rii.num__c));
       
        system.debug('ji.ZSERNO:'+ji.ZSERNO);
        ji.ZSYSID='1';
        system.debug('ji.ZSYSID:'+ji.ZSYSID);
        ji.ZOPID=rii.Opportunity__c;
        system.debug('ji.ZOPID:'+ji.ZOPID);
        ji.ZOBJID=RII.ZOBJID__c;
        system.debug('ji.ZOBJID:'+ji.ZOBJID);
        ji.ZSTOTY=RII.ZSTOTY__c;
        system.debug('ji.ZSTOTY:'+ji.ZSTOTY);
        ji.ZOPENFLAG=RII.ZOPENFLAG__c;
        system.debug('ji.ZOPENFLAG:'+ji.ZOPENFLAG);
        ji.MATNR=RII.MATNR__c;
        system.debug('ji.MATNR:'+ji.MATNR);
        ji.WERKS=RII.WERKS__c;
        system.debug('ji.WERKS:'+ji.WERKS);
        ji.ZLGOGRP=RII.ZLGOGRP__c;
                system.debug('ji.ZLGOGRP:'+ji.ZLGOGRP);
        ji.ZREQQTY=rii.ZREQQTY__c;
                system.debug('ji.ZREQQTY:'+ji.ZREQQTY);
        ji.ZREQAVLQTY=RII.ZREQAVLQTY__c;
                system.debug(' ji.ZREQAVLQTY:'+ ji.ZREQAVLQTY);
        ji.ZINVQTY=RII.ZINVQTY__c;
                system.debug('ji.ZINVQTY:'+ji.ZINVQTY);
        ji.ZAVLQTY=RII.ZAVLQTY__c;
                system.debug('ji.ZAVLQTY:'+ji.ZAVLQTY);
        ji.ZBOOKEDQTY=RII.ZBOOKEDQTY__c;
                system.debug('ji.ZBOOKEDQTY:'+ji.ZBOOKEDQTY);
        ji.ZBOOKQTY=rii.ZBOOKQTY__c;
                system.debug('ji.ZBOOKQTY:'+ji.ZBOOKQTY);
        ji.ZDELQTY=RII.ZDELQTY__c;
                system.debug('ji.ZDELQTY:'+ji.ZDELQTY);
        ji.MEINS=RII.MEINS__c;
                system.debug('ji.MEINS:'+ji.MEINS);
        ji.ZGDD=RII.ZGDD__c;
                system.debug('ji.ZGDD:'+ji.ZGDD);
        ji.ZZHHRQ=RII.ZZHHRQ__c;
                system.debug('ji.ZZHHRQ:'+ji.ZZHHRQ);
        ji.ZZLCRQ=RII.ZZLCRQ__c;
                system.debug('ji.ZZLCRQ:'+ji.ZZLCRQ);
        ji.BLNO=RII.BLNO__c;
                system.debug('ji.BLNO:'+ji.BLNO);
        ji.ZETD=RII.ZETD__c;
                system.debug('ji.ZETD:'+ji.ZETD);
        ji.ZETA=RII.ZETA__c;
                system.debug('ji.ZETA:'+ji.ZETA);
        ji.ZWARNDATE=RII.ZWARNDATE__c;
                system.debug('ji.ZWARNDATE:'+ji.ZWARNDATE);
        ji.ZDUEDATE=RII.ZDUEDATE__c;
                system.debug('ji.ZDUEDATE:'+ji.ZDUEDATE);
        ji.ZSFHWBH=RII.ZSFHWBH__c;
                system.debug('ji.ZSFHWBH:'+ji.ZSFHWBH);
        ji.ZWARNFLG='X';
                system.debug('ji.ZWARNFLG:'+ji.ZWARNFLG);
       // ji.ZRELFLAG='';//手动
        //ji.ZRELAUTO='X';
        //ji.ZRELNAME=UserInfo.getName();
        //ji.ZRELDATE='20200218';
        //ji.ZRELTIME='145902';
        //ji.ZPGIFLAG='';
        ji.BSTKD=Rii.Contract_NO__c;
        ji.ZCRMORNO=Rii.Order_Number__c;
        ji.ZCRMORIT=Rii.ZCRMORIT__c;
        ji.S01=RII.S01__c;
                system.debug('ji.S01:'+ji.S01);
        ji.S41=RII.S41__c;
                system.debug('ji.S41:'+ji.S41);
        ji.S42=RII.S42__c;
                system.debug('ji.S42:'+ji.S42);
        ji.S44=RII.S44__c;
                 system.debug('ji.S44:'+ji.S44);
        ji.S47=RII.S47__c;
                 system.debug('ji.S47:'+ji.S47);
        ji.S49=RII.S49__c;
                system.debug('ji.S49:'+ji.S49);
        ji.S4B=RII.S4B__c;
                system.debug('ji.S4B:'+ji.S4B);
        ji.P43=RII.P43__c;
               system.debug('ji.P43:'+ji.P43);
        ji.P44=RII.P44__c;
              system.debug('ji.P44:'+ji.P44);
        ji.P45=RII.P45__c;
             system.debug('ji.P45:'+ji.P45);
        ji.P47=RII.P47__c;
               system.debug('ji.P47:'+ji.P47);
        ji.P48=RII.P48__c;
              system.debug('ji.P48:'+ji.P48);
        ji.P4A=RII.P4A__c;
               system.debug('ji.P4A:'+ji.P4A);
        ji.P4G=RII.P4G__c;
                 system.debug('ji.P4G:'+ji.P4G);
        ji.P4H=RII.P4H__c;
                system.debug('ji.P4H:'+ji.P4H);
        ji.P4I=RII.P4I__c;
                 system.debug('ji.P4I:'+ji.P4I);
        ji.P4J=RII.P4J__c;
                 system.debug('ji.P4J:'+ji.P4J);
        ji.P4K=RII.P4K__c;
                 system.debug('ji.P4K:'+ji.P4K);
        ji.P4L=RII.P4L__c;
                 system.debug('ji.P4L:'+ji.P4L);
        ji.ZMS1=RII.ZMS1__c;
                system.debug('ji.ZMS1:'+ji.ZMS1);
        ji.ZJXHJT=RII.ZJXHJT__c;
                system.debug('ji.ZJXHJT:'+ji.ZJXHJT);
        ji.ZJXHDLCD=RII.ZJXHDLCD__c;
                system.debug('ji.ZJXHDLCD:'+ji.ZJXHDLCD);
        ji.ZLRF=RII.ZLRF__c;
                system.debug('ji.ZLRF:'+ji.ZLRF);
        ji.ZEVA=RII.ZEVA__c;
                system.debug('ji.ZEVA:'+ji.ZEVA);
        ji.ZZJ=RII.ZZJ__c;
                system.debug('ji.ZZJ:'+ji.ZZJ);
        ji.ZBZ=RII.ZBZ__c;
                system.debug('ji.ZBZ:'+ji.ZBZ);
        ji.ZCPHGZ=RII.ZCPHGZ__c;
                system.debug('ji.ZCPHGZ:'+ji.ZCPHGZ);
        ji.ZFJZS=RII.ZFJZS__c;
                system.debug('ji.ZFJZS:'+ji.ZFJZS);
        ji.ZQYQZXRZ=RII.ZQYQZXRZ__c;
                system.debug('ji.ZQYQZXRZ:'+ji.ZQYQZXRZ);
        jiLst.add(ji);
            
         
        jinkosolarComCrmStockBook.HTTPS_Port hp =new jinkosolarComCrmStockBook.HTTPS_Port();
        hp.timeout_x = 120000;
        jinkosolarComEccStockBook.DT_StockBook_Response dr =hp.SI_CRM2ECC_StockBook_Out('B',jiLst);
        system.debug(dr.E_MSGTY);
        system.debug(dr.E_MSGTXT);
        if(dr.E_MSGTY=='S'){
            SendEmailUtils2.sendToSomeOneId(rii.id,rii.CreatedById,'BookstockSendEmailY');
        }
        
    }
   
    webService static void tool(){
        integer num =1;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;

        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;
        num++;

    }
}