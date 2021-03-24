public class SapSync_Account {
    
    public Account account;
    public List<Contact> requestContactList = new List<Contact>();
    public List<User>    requestUserList    = new List<User>();
    public String errorMsg = '';
    
    public String sales_org    = '';//销售组织
    public String company_code = '';//公司代码
    
    public List<Log__c> lst_log {get;set;}
    
    // structure
    public SapSync_Account(){
        lst_log = new List<Log__c>();
    }
    
    // generate basic data - requestIds = account ids
    public void generateData(Account acc, Order ord){
        if(acc != null){
            account = acc;
            Set<ID> ownerids = new Set<ID>();
            ownerids.add(account.OwnerId);
            String accid = acc.Id;
            requestContactList = Database.query( Utils.MakeSelectSql('Contact') + ' WHERE AccountId =: accid');
            requestUserList    = [SELECT ID,Country__c FROM User WHERE ID in: ownerids];
            sales_org    = ord.SAP_Sales_Org__c;
            company_code = ord.SAP_Company_Code__c;
        }
    }
    
    public void sync(){
        // init - log for recording every integration call
        Log__c log = new Log__c();
        
        try{
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'Account';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
            
            
            // external id must be null
            if(account != null && account.SAP_External_ID__c == null){
                // tools and list
                sapAccount.ZCRMSDD_CREAT_CUSTOMER mode = new sapAccount.ZCRMSDD_CREAT_CUSTOMER();
                sapAccount.ZSCRM001 zsc = new sapAccount.ZSCRM001();//客户主数据
                sapAccount.TABLE_OF_ZKNB1 IT_KNB1 = new sapAccount.TABLE_OF_ZKNB1();//公司主数据集合
                sapAccount.TABLE_OF_ZKNVV IT_KNVV = new sapAccount.TABLE_OF_ZKNVV();//销售组织集合
                sapAccount.TABLE_OF_ZSCRM001_1 IT_ZSCRM001_1 = new sapAccount.TABLE_OF_ZSCRM001_1();//联系人集合
                
                //---- 1.客户主数据打包 ----
                zsc.ZKUNNR = String.valueOf(account.Id).toUpperCase().substring(0, 15);//CRM客户编号 //'1aaazzzx25';
                
                zsc.FORMOFADDR = 'SF01';//称谓文本
                zsc.KTOKD      = 'Z002';//客户帐户组
                zsc.REGION     = '';//地区（省/自治区/直辖市、县）
                zsc.NAME       = account.AccountName2__c != null ? account.AccountName2__c : account.Name;//名称1
                zsc.STCEG      = '';//原contract.VAT_No__c
                zsc.STREET_LNG = account.BillingStreet == null ? account.Country__c : account.BillingStreet;//街道
                zsc.COUNTRYISO = SapMap.getCountryCode(account.Country__c);//国家的ISO代码
                zsc.E_MAIL     = account.Company_Email__c;//电子邮件地址
                zsc.TAXKD      = '1';//客户税分类
                zsc.TEL_EXTENS = '';//分机号（第一个电话号）
                zsc.TEL1_NUMBR = account.Phone;//区号+号码（第一个电话号）
                zsc.FAX_NUMBER = account.Fax;//拨号+编号（第一个电话号）
                zsc.TELF1      = '';//第一个电话号
                zsc.SPRAS      = 'E';//语言
                zsc.POSTL_COD1 = account.BillingPostalCode == null ? '000000' : account.BillingPostalCode;//城市邮政编码
                zsc.LAND1      = SapMap.getCountryCode(account.Country__c);//国家代码
                
                if(account.Name.Length() >= 18){
                    zsc.SORT1 = account.Name.substring(0,17);//检索项1--简称
                }else{
                    zsc.SORT1 = account.Name;
                }
                
                for(User user : requestUserList){
                    if(user.Id == account.OwnerId){
                        zsc.LIFNR = String.valueOf(user.Id).toUpperCase().substring(0, 15);//供应商或债权人的帐号 -- 给Salesforce销售ID
                    }   
                }    
                
                //---- 2.联系人主数据打包 ----
                for(Contact contact : requestContactList){
                    if(contact.AccountId == account.Id){
                        sapAccount.ZSCRM001_1 zsc1 = new sapAccount.ZSCRM001_1();
                        zsc1.NAME1 = contact.LastName + contact.FirstName;
                        zsc1.PARGE = contact.Gender__c;
                        zsc1.TELF1 = contact.Phone;
                        
                        IT_ZSCRM001_1.item.add(zsc1);
                    }
                }
                
                //---- 3.销售组织数据打包 ----
                sapAccount.ZKNVV knvv = new sapAccount.ZKNVV();
                knvv.VKORG = sales_org;//销售组织
                knvv.BZIRK = SapMap.getAreaCode(account.Country__c);//销售地区
                knvv.VKBUR = '1000';//销售部门
                knvv.KDGRP = account.SAP_Customer_Group__c;//客户组
                knvv.WAERS = account.CurrencyIsoCode.subString(0,3);//货币码
                for(User user : requestUserList){
                    if(user.Id == account.OwnerId){
                        if(user.Country__c != null){
                            knvv.VKGRP = SapMap.getSalesGroup(user.Country__c);//销售组 
                        }else{
                            knvv.VKGRP = '103';
                        }
                    }
                }
                IT_KNVV.item.add(knvv);
                
                //---- 4.公司主数据打包 ----
                sapAccount.ZKNB1 zknb1 = new sapAccount.ZKNB1();
                zknb1.BUKRS = company_code;//公司代码
                zknb1.AKONT ='';//总账中的统驭科目
                IT_KNB1.item.add(zknb1);
                
                // use tool
                sapAccount.ZCRMSDD_CREAT_CUSTOMERResponse_element result = new sapAccount.ZCRMSDD_CREAT_CUSTOMERResponse_element();
                result = mode.ZCRMSDD_CREAT_CUSTOMER(zsc, IT_KNB1, IT_KNVV, IT_ZSCRM001_1);
                
                // S=SUCCESS; E=ERROR
                if( 'S'.equalsIgnoreCase( result.RESULT ) ){
                    log.SuccessIDs__c += 'account sync: '+ account.Id + '/';
                    account.SAP_External_ID__c = result.IS_KUNNR;
                    log.SuccessCount__c++;
                }else{
                    log.FailureIDs__c += 'account sync failed : '+ account.Id + '/';
                    log.SAP_Error_Message__c += result.MESSTXT;
                    errorMsg = result.MESSTXT;
                }
                
            }
            
        }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
            errorMsg = ex.getMessage();
        }
        
        SapTools.uploadLogList.add(log);
        
    }
    
}