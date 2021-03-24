global class SapIntegrateUtils {
    
    public  static String ACC_STCD1 = '121221212243';//税号
    
    public List<Contract> conList{get;set;}//合同
    public List<Account> accList{get;set;}//客户
    public List<Contact> tactList{get;set;}//联系人
    public List<User> userList{get;set;}//业务员
    public List<Product_Detail__c> prodList{get;set;}//订单条目
    public List<Production_Schedule_Detail__c> prodscheList{get;set;}//生产计划 -- 绑定在合同下
    
    public List<Contract> synContractList   = null;
    public List<Account> synAccountList     = null;
    public List<Log__c> lst_log             = null;
    
    public Contract contract{get;set;}
    
    // Accountid => Contract
    public Map<String,Contract>  map_accountId2contract = new Map<String,Contract>();
    // id => Account 
    public Map<String,Account>   map_id2account = new Map<String,Account>();
    
    public String conid {get;set;}//合同ID
    
    public SapIntegrateUtils(){
        lst_log = new List<Log__c>();
        synAccountList   = new List<Account>();
        synContractList  = new List<Contract>();
        generateData();
    }
    
    public void generateData(){
        
        System.debug('*************** 2222开始准备数据');
        
        String notPoint = 'NOT';//合同SAP销售组织为NULL标识时代表不是符合条件的四家公司
        String approvePoint = 'Approved';
        String noPoint = 'NO';//工厂字段为NULL不传

        // Query Contract 
        // conList = Database.query( Utils.MakeSelectSql('Contract')+' WHERE SAP_Sales_Org__c !=: notPoint AND Approval_Status__c =: approvePoint AND Sync_To_SAP__c =true AND SAP_External_ID__c =null AND SAP_Factory__c !=: noPoint AND LastModifiedDate >= ' + LABEL.JSI_CREATED_DATA_AFTER); 
        // update 20151018 : 现在只传一份合同
        conList = Database.query(Utils.MakeSelectSql('Contract')+' WHERE SAP_Sales_Org__c !=: notPoint AND Approval_Status__c =: approvePoint AND Sync_To_SAP__c =true AND SAP_External_ID__c =null AND SAP_Factory__c !=: noPoint AND ID=:conid AND LastModifiedDate >= ' + LABEL.JSI_CREATED_DATA_AFTER);
        if(conList.size() > 0)contract = conList[0];//只有一条contract
        
        // Query Account 
        List<ID> accIdList = new List<ID>();
        for(Contract con : conList){
            accIdList.add(con.AccountId);
            map_accountId2contract.put( con.AccountId , con );
        }
        accList = Database.query( Utils.MakeSelectSql('Account')+' WHERE Id in: accIdList'); 
        
        // Package Accounts
        for( Account acc : accList ){
            map_id2account.put( acc.Id, acc );
        }
        
        System.debug('############################开始数据准备2');
        
        // Query Contact
        Set<String> accountIds = map_id2account.keySet();
        tactList = Database.query( Utils.MakeSelectSql('Contact') + ' WHERE AccountId in :accountIds');
        
        // Query Users
        userList = Database.query( Utils.MakeSelectSql('User')); 
        List<ID> conIdList = new List<ID>();
        for(Contract con : conList){
            conIdList.add(con.Id);
        }
        
        System.debug('############################开始数据准备3');
        
        // Query Product Detail
        prodList = Database.query( Utils.MakeSelectSql('Product_Detail__c')+' WHERE Contract_PO_PI__c in: conIdList'); 
        
        // Query Production Schedule Detail
        prodscheList = Database.query( Utils.MakeSelectSql('Production_Schedule_Detail__c')+' WHERE Contract__c in: conIdList');
        
        System.debug('############################完成数据准备');
    }
    
    public void SynAccount(){
        System.debug('############################进入ACC同步');
        // login model - start
        Log__c log = new Log__c(
            Type__c='Account',
            StartTime__c = System.now()
        );
        Integer log_TotalCount      = 0;
        Integer log_SuccessCount    = 0;
        List<String> log_SuccessIDs = new List<String>();
        List<String> log_FailedIDs  = new List<String>();
        // Content : SFID=>Error Message$$
        List<String> log_SfErrorMsg = new List<String>();
        // Content : SFID=>Error Message$$
        List<String> log_SapErrorMsg= new List<String>();
        List<String> log_Details = new List<String>();
        // login model - end
        
        try{
        System.debug('############################进入ACC同步222');
            for(Account acc : this.accList){
                try{
                    // Get Contract by AccountId
                    Contract con = map_accountId2contract.get( acc.Id );
                    System.debug('**********con2: ' +con );
                    System.debug('**********acc.SAP_External_ID__c: ' +acc.SAP_External_ID__c);
                    System.debug('**********accID: ' +acc.Id + ' *** con.AccId: '+con.AccountId);
                    if(acc.Id == con.AccountId && acc.SAP_External_ID__c == null){
                        // login model - start
                        log_TotalCount++;
                        // login model - end
                        
                        sapAccountLastest.ZCRMSDD_CREAT_CUSTOMER mode = new sapAccountLastest.ZCRMSDD_CREAT_CUSTOMER();
                        sapAccountLastest.ZSCRM001 zsc = new sapAccountLastest.ZSCRM001();//客户主数据
                        sapAccountLastest.TABLE_OF_ZKNB1 IT_KNB1 = new sapAccountLastest.TABLE_OF_ZKNB1();//公司主数据集合
                        sapAccountLastest.TABLE_OF_ZKNVV IT_KNVV = new sapAccountLastest.TABLE_OF_ZKNVV();//销售组织集合
                        sapAccountLastest.TABLE_OF_ZSCRM001_1 IT_ZSCRM001_1 = new sapAccountLastest.TABLE_OF_ZSCRM001_1();//联系人集合
                        
                        //---- 1.客户主数据打包 ----
                        zsc.ZKUNNR = String.valueOf(acc.Id).toUpperCase().substring(0, 15);//CRM客户编号
                        System.debug('$$$$$$$$$$ 客户ID：'+zsc.ZKUNNR);
                        
                        zsc.FORMOFADDR = 'SF01';//称谓文本
                        zsc.KTOKD = 'Z002';//客户帐户组
                        zsc.NAME = acc.AccountName2__c != null ? acc.AccountName2__c : acc.Name;//名称1
                        
                        System.debug('############################进入ACC同步333');
                        
                        zsc.STCEG = contract.VAT_No__c;
                        
                        if(acc.Name.Length() >= 18){
                            zsc.SORT1 = acc.Name.substring(0,17);//检索项1--简称
                        }else{
                            zsc.SORT1 = acc.Name;
                        }
                        
                        zsc.STREET_LNG = acc.BillingStreet == null ? acc.Country__c : acc.BillingStreet;//街道
                        zsc.COUNTRYISO = SapMap.getCountryCode(acc.Country__c);//国家的ISO代码
                        
                        System.debug('%%%%%%%%%%%% 客户国家：'+acc.Country__c + ' 客户国家代码：'+ SapMap.getCountryCode(acc.Country__c));
                        
                        zsc.REGION = '';//地区（省/自治区/直辖市、县）
                        
                        /* 1.CRM取消传送此字段
                        zsc.STCD1= ACC_STCD1;//税号1
                        */
                        
                        zsc.E_MAIL = acc.Company_Email__c;//电子邮件地址
                        zsc.TAXKD = '1';//客户税分类
                        for(User user : userList){
                            if(user.Id == contract.OwnerId){
                                zsc.LIFNR = String.valueOf(user.Id).toUpperCase().substring(0, 15);//供应商或债权人的帐号 -- 给Salesforce销售ID
                                System.debug('$$$$$$$$$$ 用户ID：'+zsc.LIFNR);
                            }   
                        }
                        zsc.TEL_EXTENS = '';//分机号（第一个电话号）
                        zsc.TEL1_NUMBR = acc.Phone;//区号+号码（第一个电话号）
                        zsc.FAX_NUMBER = acc.Fax;//拨号+编号（第一个电话号）
                        zsc.TELF1 = '';//第一个电话号
                        zsc.SPRAS = 'E';//语言
                        zsc.POSTL_COD1 = acc.BillingPostalCode == null ? '000000' : acc.BillingPostalCode;//城市邮政编码
                        zsc.LAND1 = SapMap.getCountryCode(acc.Country__c);//国家代码
                        
                        //---- 2.联系人主数据打包 ----
                        for(Contact tact : tactList){
                            if(tact.AccountId == acc.Id){
                                sapAccountLastest.ZSCRM001_1 zsc1 = new sapAccountLastest.ZSCRM001_1();
                                zsc1.NAME1 = tact.LastName + tact.FirstName;
                                zsc1.PARGE = tact.Gender__c;
                                zsc1.TELF1 = tact.Phone;
                                
                                IT_ZSCRM001_1.item.add(zsc1);
                            }
                        }

                        //---- 3.销售组织数据打包 ----
                        sapAccountLastest.ZKNVV knvv = new sapAccountLastest.ZKNVV();
                        knvv.VKORG = con.SAP_Sales_Org__c;//销售组织
                        knvv.BZIRK = SapMap.getAreaCode(acc.Country__c);//销售地区
                        system.debug('%%%%%%%%' + knvv.BZIRK);
                        knvv.VKBUR = '1000';//销售部门
                        for(User user : userList){
                            if(user.Id == contract.OwnerId){
                                if(user.Country__c != null){
                                    knvv.VKGRP = SapMap.getSalesGroup(user.Country__c);//销售组 
                                    system.debug('%%%%%%%%%%%%%%%' + knvv.VKGRP);
                                }else{
                                    knvv.VKGRP = '103';
                                }
                            }
                        }
                        knvv.KDGRP = acc.SAP_Customer_Group__c;//客户组
                        knvv.WAERS = acc.CurrencyIsoCode.subString(0,3);//货币码
                        IT_KNVV.item.add(knvv);
                        
                        //---- 4.公司主数据打包 ----
                        sapAccountLastest.ZKNB1 zknb1 = new sapAccountLastest.ZKNB1();
                        zknb1.BUKRS= con.SAP_Company_Code__c;//公司代码
                        zknb1.AKONT='';//总账中的统驭科目
                        IT_KNB1.item.add(zknb1);
                        //System.debug('############################公司主数据打包');
                        
                        sapAccountLastest.ZCRMSDD_CREAT_CUSTOMERResponse_element result = new sapAccountLastest.ZCRMSDD_CREAT_CUSTOMERResponse_element();
                        try{
                            result = mode.ZCRMSDD_CREAT_CUSTOMER(zsc, IT_KNB1, IT_KNVV, IT_ZSCRM001_1);
                            System.debug('############################SAP account No: '+result.IS_KUNNR);
                            System.debug('############################CRM account No: '+result.IS_ZKUNNR);
                        }catch(Exception ex){
                            log_SfErrorMsg.add(  acc.Id+'=>'+String.valueOf(ex) );
                            log_FailedIDs.add( acc.Id );
                        }
                        
                        // S=SUCCESS; E=ERROR
                        if( 'S'.equalsIgnoreCase( result.RESULT ) ){
                            log_SuccessIDs.add( acc.Id );
                            acc.SAP_External_ID__c = result.IS_KUNNR;
                            synAccountList.add(acc);
                            log_SuccessCount++;
                            
                            log_Details.add( Json.serialize(zsc) );
                        }else{
                            log_FailedIDs.add( acc.Id );
                            // log-sap error message
                            log_SAPErrorMsg.add(  acc.Id+'=>'+ result.MESSTXT );
                        }
                        // login model - end
                    }
                }catch(Exception ex){
                    log_SfErrorMsg.add(  acc.Id+'=>'+String.valueOf(ex) );
                    log_FailedIDs.add( acc.Id );
                }
            }
        }catch(Exception ex){
            System.debug( '-----------------> Exception = ' + ex);
            log_SfErrorMsg.add(String.valueOf(ex) );
        }
        
        log.Error_Message__c     = String.join( log_SfErrorMsg , '\t$$\t' );
        log.SAP_Error_Message__c = String.join( log_SapErrorMsg , '\t$$\t' );
        log.SuccessIDs__c        = String.join( log_SuccessIDs , '\t$$\t' );
        log.FailureIDs__c        = String.join( log_FailedIDs , '\t$$\t' );
        log.EndTime__c           = System.now();
        log.SuccessCount__c      = log_successCount;
        log.TotalCount__c        = log_totalCount;
        
        //add by kane 201501012 : 
        log.Details__c           = String.join( log_Details , '\t$$\t');
        
        lst_log.add( log );
    }
    
    public void SynContract(){
        System.debug('############################进入订单集成');
        // login model - start
        Log__c log = new Log__c(
            Type__c='Contract',
            StartTime__c = System.now()
        );
        Integer log_TotalCount      = 0;
        Integer log_SuccessCount    = 0;
        List<String> log_SuccessIDs = new List<String>();
        List<String> log_FailedIDs  = new List<String>();
        // Content : SFID=>Error Message$$
        List<String> log_SfErrorMsg = new List<String>();
        // Content : SFID=>Error Message$$
        List<String> log_SapErrorMsg= new List<String>();
        List<String> log_Details = new List<String>();
        // login model - end
        try{
            for(Contract con : this.conList){
                try{
                    // Get Account by Contract's AccountId
                    Account acc = map_id2account.get( con.AccountId );
                    
                    System.debug('******************accId: '+acc.Id + '   ,,   '+con.AccountId);
                    System.debug('******************accId: '+String.valueOf(acc.Id).toUpperCase());
                    
                    if(acc.Id == con.AccountId ){
                        
                        // login model - start
                        log_TotalCount++;
                        // login model - end
                        
                        sapContractLastest.ZSDI0003 mode = new sapContractLastest.ZSDI0003();
                        sapContractLastest.ZVBAK IS_VBAK = new sapContractLastest.ZVBAK();
                        sapContractLastest.TABLE_OF_ZVBAP T_VBAP = new sapContractLastest.TABLE_OF_ZVBAP();
                        sapContractLastest.TABLE_OF_ZTSD030 T_ZTSD030 = new sapContractLastest.TABLE_OF_ZTSD030();//New
                        
                        //订单抬头
                        IS_VBAK.AUART = 'ZOR1';//销售凭证类型
                        IS_VBAK.VKORG = con.SAP_Sales_Org__c;//销售组织
                        IS_VBAK.VTWEG = '10';//分销渠道
                        IS_VBAK.SPART = '30';//产品组
                        IS_VBAK.VKBUR = '1000';//销售部门
                        for(User user : userList){
                            if(user.Id == con.OwnerId){
                                
                                if(user.Country__c != null){
                                    IS_VBAK.VKGRP = SapMap.getSalesGroup(user.Country__c);//销售组 
                                }else{
                                    IS_VBAK.VKGRP = '103';
                                }

                                IS_VBAK.SORTL = String.valueOf(user.Id).toUpperCase().substring(0, 15);//业务员ID(CRMID)
                                
                                System.debug('$$$$$$$$$$ 业务员2ID：'+IS_VBAK.SORTL);
                                
                                IS_VBAK.LIFNR = '';//供应商或债权人的帐号
                            }
                        }
                        IS_VBAK.KUNNR = String.valueOf(acc.Id).toUpperCase().substring(0, 15);//客户编号
                        IS_VBAK.ZKUNNR = String.valueOf(acc.Id).toUpperCase().substring(0, 15);//客户编号
                        
                        System.debug('$$$$$$$$$$ 客户2ID：'+IS_VBAK.KUNNR);
                        
                        IS_VBAK.BSTKD = con.Contract_NO__c;//销售合同编号
                        IS_VBAK.BSTDK = String.valueOf(con.PO_PI_Date__c) == null ? '' : String.valueOf(con.PO_PI_Date__c); //合同签订日期
                        IS_VBAK.VDATU = String.valueOf(con.Expected_Delivery_Date__c) == null ? '' : String.valueOf(con.Expected_Delivery_Date__c);//运输计划日期
                        IS_VBAK.TDDAT = con.ETD__c;//请求交货日期--必填
                        IS_VBAK.MBDAT = String.valueOf(con.PO_PI_Date__c) == null ? '' : String.valueOf(con.PO_PI_Date__c);//物料分段/有效日期
                        IS_VBAK.ZTERM = '';//付款条件代码
                        //IS_VBAK.ZLSCH = con.SAP_PaymentMethod__c;//付款方式
                        //更新为新的付款方式
                        List<Payment__c> payList = Database.query(Utils.MakeSelectSql('Payment__c')+' WHERE Contract__c =: conid');
                        if(payList.size()>0){
	                        for(Payment__c pay : payList){
	                        	if(pay.Payment_Method__c == 'T/T'){
	                        		IS_VBAK.ZLSCH = 'U';
	                        		break;
	                        	}else if (pay.Payment_Method__c == 'L/C'){
	                        		IS_VBAK.ZLSCH = 'L';
	                        	}
	                        }
                        }else{
                        	IS_VBAK.ZLSCH = 'U';
                        }
                        
                        IS_VBAK.BNAME = '';//定货人姓名
                        IS_VBAK.VSART = con.SAP_Shipping__c;//装运类型
                        if(con.Trade_term__c.startsWith('EXW')){
                            IS_VBAK.INCO1 = 'EXW';//国际贸易条款1
                        }else{
                            IS_VBAK.INCO1 = con.Trade_term__c;//国际贸易条款1
                        }
                        
                        /* 2.CRM顾问根据相应字段值做匹配，取出PORT信息并传输
                        IS_VBAK.INCO2 = 'SHANGRAO';//国际贸易条款2
                        */
                        IS_VBAK.INCO2 = con.Destination__c;//国际贸易条款2
                        
                        IS_VBAK.WAERK = con.CurrencyIsoCode.subString(0,3);//SD凭证货币
                        IS_VBAK.AUGRU = '';//订购原因(业务原因)
                        IS_VBAK.ZTXT1 = '';//订单备注
                        IS_VBAK.ZTXT2 = con.Payment_Term_Description__c;//付款备注
                        
                        
                        //add 2015/10/08
                        IS_VBAK.ZZSACNO = con.Contract_NO__c;//Sales Contract No
                        IS_VBAK.ZZCPONO = con.SAP_Customer_PO_No__c;//Customer PO No
                        IS_VBAK.ZZPRJNO = con.SAP_Project_No__c;//Project No
                        
                        if(con.Inspection__c == 'From Jinko'){
                            IS_VBAK.ZZINSP = '1';
                        }else if(con.Inspection__c == 'From Account'){
                            IS_VBAK.ZZINSP = '2';
                        }else if(con.Inspection__c == 'Other'){
                            IS_VBAK.ZZINSP = '3';
                            IS_VBAK.ZZINSP_TX = con.Inspection_Description__c;
                        }
                        
                        IS_VBAK.ZZCOTL = con.Supervision__c == 'Yes' ? '1' : '2';//是否需要监造  Supervision
                        
                        if(con.Limited_warranty__c == 'Non-linear warranty 10 years'){
                            IS_VBAK.ZZLWAR = '1';
                        }else if(con.Limited_warranty__c == 'Linear warranty 10 years'){
                            IS_VBAK.ZZLWAR = '2';
                        }else if(con.Limited_warranty__c == 'Other'){
                            IS_VBAK.ZZLWAR = '3';
                            IS_VBAK.ZZLWAR_TX = con.Limited_warranty_Description__c;
                        }
                        
                        IS_VBAK.ZZPWAR = con.PowerGuard_Warranty__c == 'Yes' ? '1' : '2';//PowerGuard Warranty
                        
                        IS_VBAK.ZZPBON = con.Performance_bond__c == true ? 'X' : '';//Performance bond
                        IS_VBAK.ZZWBON = con.Warranty_bond__c == true ? 'X' : '';//Warranty bond
                        IS_VBAK.ZZPCGU = con.Parent_Company_Guaranty__c == true ? 'X' : '';//Parent Company Guaranty
                        IS_VBAK.ZZBWAR = con.Bank_warranty__c == true ? 'X' : '';//Bank warranty
                        IS_VBAK.ZZAPGU = con.Advance_Payment_Guaranty__c == true ? 'X' : '';//Advance Payment Guaranty
                        IS_VBAK.ZZOBOM = con.Other_Related_bonds__c == true ? 'X' : '';//Other Related bonds
                        IS_VBAK.ZZOBOM_TX = con.Other_Related_bonds_Text__c == true ? 'X' : '';//Other Related bonds - Text
                        
                        //20141217
                        IS_VBAK.ZZRPTEU = con.Apply_For_EUC__c == true ? 'X' : SapMap.getEU(acc.Country__c) == null ? '' : 'X';//是否申报欧盟
                        
                        //订单明细
                        Integer lineNum = 10;//行项目编号
                        Map<String,Integer> lineNumMap = new Map<String,Integer>();
                        if(prodList != null){
                            for(Product_Detail__c prod : prodList){
                                if(prod.Contract_PO_PI__c == con.Id){
                                    sapContractLastest.ZVBAP ZBVAP = new sapContractLastest.ZVBAP();
                                    
                                    
                                    ZBVAP.POSNR = String.valueOf(lineNum);//销售凭证项目
                                    lineNumMap.put(prod.Id,lineNum);
                                    lineNum += 10;
                                    
                                    ZBVAP.MATNR =  prod.SAP_Product_Id__c;// '24000043';//物料号 -- 【预留，需要做产品和老物料号的对应，之后用formula字段取值】
                                    ZBVAP.KWMENG = String.valueOf(prod.Quantity__c);//以销售单位表示的累计订单数量
                                    ZBVAP.VRKME = 'PC';//销售单位
                                    ZBVAP.KBETR = String.valueOf(prod.Unit_Price__c.setScale(4));//价格 -- 产品单价
                                    ZBVAP.KONWA = prod.CurrencyIsoCode.subString(0,3);//比率单位
                                    ZBVAP.KPEIN = '';//条件定价单位
                                    ZBVAP.KMEIN = 'W';//条件单位
                                    ZBVAP.ZKBETR = String.valueOf(prod.Freight_Price__c.setScale(2));//价格 -- 海运费单价
                                    ZBVAP.ZKONWA = prod.CurrencyIsoCode.subString(0,3);//比率单位
                                    ZBVAP.ZKPEIN = '';//条件定价单位
                                    ZBVAP.ZKMEIN = 'PC';//条件单位
                                    ZBVAP.ZKBETR1 = String.valueOf(prod.Insurance_Price__c.setScale(2));//价格 -- 保险费单价
                                    ZBVAP.ZKONWA1 = prod.CurrencyIsoCode.subString(0,3);//比率单位
                                    ZBVAP.ZKPEIN1 = '';//条件定价单位
                                    ZBVAP.ZKMEIN1 = 'PC';//条件单位
                                    ZBVAP.ZTXT3 = '';//产品备注长文本
                                    ZBVAP.ZZCPONO = '';//Customer PO No
                                    ZBVAP.ZZPRJNO = '';//Project No
                                    ZBVAP.ZZBDMAT = con.Bonded_Material_Name__c;//Bonded Material 保税号
                                    ZBVAP.WERKS = con.SAP_Factory__c;//工厂
                                    
                                    T_VBAP.item.add(ZBVAP);
                                    
                                }
                            }
                        }
                        lineNum = 10;
                        
                        //生产计划 20150306
                        
                        //Q : 需要两个唯一标识，一个是CRM的订单ID，一个是CRM中订单明细的ID。SAP拿到CRM
                        //传来的生产计划后，根据这两个唯一标识，匹对传来的订单及订单明细ID，在SAP创建完订单和订单明细之后，
                        //将SAP中相关的ID赋到VBELN,POSNR这两个字段上
                        sapContractLastest.ZTSD030 ZTSD030 = new sapContractLastest.ZTSD030();
                        
                        Map<String,Integer> seqMap = new Map<String,Integer>();
                        for(Production_Schedule_Detail__c detail : prodscheList){
                            seqMap.put(detail.Product_Detail__c,1);
                        }
                        
                        if(prodscheList != null){
                            System.debug('&&&&&&&&&&&&&&&&& go into prodschelist1');
                            for(Production_Schedule_Detail__c detail : prodscheList){
                                if(detail.Contract__c == con.Id){
                                    System.debug('&&&&&&&&&&&&&&&&& go into prodschelist2');
                                    ZTSD030 = new sapContractLastest.ZTSD030();
                                    ZTSD030.VBELN = '';//订单编号
                                    ZTSD030.POSNR = String.valueOf(lineNumMap.get(detail.Product_Detail__c));//行项目编号
                                    ZTSD030.SEQNO = String.valueOf(seqMap.get(detail.Product_Detail__c));//序号 -- 自动增加1
                                    Integer seq = seqMap.get(detail.Product_Detail__c);
                                    seq++;
                                    seqMap.put(detail.Product_Detail__c,seq);
                                    
                                    ZTSD030.PCS = String.valueOf(detail.Quantity__c);//数量
                                    ZTSD030.REQEXDAT = String.valueOf(detail.Expected_ex_Work_Date__c) == null ? '' : String.valueOf(detail.Expected_ex_Work_Date__c);//要求离场时间
                                    ZTSD030.REQETD = String.valueOf(detail.Expected_ETD__c) == null ? '' : String.valueOf(detail.Expected_ETD__c);//要求离港时间
                                    ZTSD030.REMARKS = detail.Remarks__c == null ? '' : detail.Remarks__c;//备注
                                    ZTSD030.MEINS = 'PC';
                                    ZTSD030.MANDT = '';
                                    
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 POSNR '+ZTSD030.SEQNO+' :'+ZTSD030.POSNR);
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 SEQNO '+ZTSD030.SEQNO+' :'+ZTSD030.SEQNO);
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 PCS '+ZTSD030.SEQNO+' :'+ZTSD030.PCS);
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 REQEXDAT '+ZTSD030.SEQNO+' :'+ZTSD030.REQEXDAT);
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 REQETD '+ZTSD030.SEQNO+' :'+ZTSD030.REQETD);
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 REMARKS '+ZTSD030.SEQNO+' :'+ZTSD030.REMARKS);
                                    System.debug('^^^^^^^^^^^^^^^^^ ZTSD030 MEINS '+ZTSD030.SEQNO+' :'+ZTSD030.MEINS);
                                    
                                    T_ZTSD030.item.add(ZTSD030);
                                }
                            }
                        }
                        
                        sapContractLastest.ZSDI0003Response_element result = new sapContractLastest.ZSDI0003Response_element();
                        try{
                            result = mode.ZSDI0003(IS_VBAK, T_VBAP, T_ZTSD030);
                            // -- past -- result = mode.ZSDI0003(IS_VBAK, T_VBAP);
                        }catch(Exception ex){
                            log_SfErrorMsg.add(  con.Id+'=>'+String.valueOf(ex) );
                            log_FailedIDs.add( con.Id );
                        }
                        
                        // S=SUCCESS; E=ERROR
                        if( 'S'.equalsIgnoreCase( result.RESULT ) ){
                            log_SuccessIDs.add( con.Id );
                            con.SAP_External_ID__c = result.I_VBELN;
                            synContractList.add(con);
                            log_SuccessCount++;
                            
                            log_Details.add( Json.serialize(IS_VBAK) );
                        }else{
                            log_FailedIDs.add( con.Id );
                            // log-sap error message
                            log_SAPErrorMsg.add(  con.Id+'=>'+ result.MESSTXT );
                        }
                        // login model - end
                    }
                }catch(Exception ex){
                    log_SfErrorMsg.add(  con.Id+'=>'+String.valueOf(ex) );
                    log_FailedIDs.add( con.Id );
                }
            }
        }catch(Exception ex){
            System.debug( '-----------------> Exception = ' + ex);
            log_SfErrorMsg.add( String.valueOf(ex) );
        }
        
        log.Error_Message__c     = String.join( log_SfErrorMsg , '\t$$\t' );
        log.SAP_Error_Message__c = String.join( log_SapErrorMsg , '\t$$\t' );
        log.SuccessIDs__c        = String.join( log_SuccessIDs , '\t$$\t' );
        log.FailureIDs__c        = String.join( log_FailedIDs , '\t$$\t' );
        log.EndTime__c           = System.now();
        log.SuccessCount__c      = log_successCount;
        log.TotalCount__c        = log_totalCount;
        
        //add by kane 201501012 : 
        log.Details__c           = String.join( log_Details , '\t$$\t');
        
        lst_log.add( log );
    }
    
}