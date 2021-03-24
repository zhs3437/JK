public class OASync_Acc {
   
    public Static String retVal;
    Account acc = new Account();    
   
    public String errorMsg = '';
    public List<Log__c> lst_log {get;set;}
    public String Seller = '';
    public String salesGroup = '';
    public String salesRegion = '';
    public String accountCountry = '';
    // structure
    public OASync_Acc(){
    }    
    // generate basic data
    public void generateData(Account acc){
        this.acc = acc;
    }
    
    public void sync(){
        system.debug('------Sync Start');
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
            String todayTime = String.valueOf(Date.today());
            Seller = SapMap.getSellerCode(acc.Ledger_Name__c);
            salesGroup = SapMap.getsalesRegion(acc.Sales_Group__c);
            salesRegion = SapMap.getOwnerRegion(acc.Sales_Region__c);
            accountCountry = SapMap.getCountryOACode(acc.Country__c);
            system.debug('====国家：'+SapMap.getCountryOACode(acc.Country__c));
            system.debug('====Seller' + Seller);
            system.debug('====Seller' + acc.Ledger_Name__c);
            system.debug('====salesGroup' + salesGroup);
            //webservicesWorkflowWeaver00000.Customerinfo  customerInfo = new webservicesWorkflowWeaver00000.Customerinfo();
            //webservicesWorkflowWeaver888.Customerinfo  customerInfo = new webservicesWorkflowWeaver888.Customerinfo();
		    webservicesWorkflowWeaver.Customerinfo 				customerInfo 	= new webservicesWorkflowWeaver.Customerinfo(); 
            
            	customerInfo.CRMNO							= acc.SAP_External_ID__c;										// 返回SAP客户ID
                customerInfo.IBANCode						= acc.IBAN_Code__c;												// IBAN code
                customerInfo.SWIFTCode						= acc.SWIFT_Code__c;											// SWIFI code
                customerInfo.accountAllocationGroup			= acc.Account_Allocation_Group__c;							// 账户分配组
                customerInfo.accountGroup					= acc.Account_Group__c;												// 客户组
                customerInfo.accountHolder					= acc.Account_Holder__c;										// 开户人
                customerInfo.bankAccount					= acc.Bank_Account__c;											// 银行账户
                customerInfo.bankCity						= acc.Bank_City__c;												// 银行城市
                customerInfo.bankCode						= acc.Bank_Code__c;												// 银行代码
                customerInfo.bankCountry					= acc.Bank_Country__c;											// 银行国家
                customerInfo.bankName						= acc.Bank_Name__c;												// 银行名称
                customerInfo.vatno                          = acc.VAT_NO__c;                                                //客户VAT NO
                customerInfo.ydregin                        = acc.GST_Classification_Region__c;                             //印度分类地区
                customerInfo.bankRegion						= acc.Bank_Region__c;											// 银行区域
                customerInfo.bankStreet						= acc.Bank_Street__c;											// 银行街道
                customerInfo.contractCurrency				= acc.CurrencyIsoCode.subString(0,3);//acc.Contract_Currency__c;										// 客户货币
            if(String.isEmpty(accountCountry)){
                customerInfo.country						= acc.Country__c;
            }else{
                customerInfo.country						= SapMap.getCountryOACode(acc.Country__c);//'US 美国';//acc.Country__c;	// 客户国家
            }
            	customerInfo.creator						= acc.OA_UserName__c;										// 客户所有人的SAP Id号
                customerInfo.distributionchannel			= acc.Distribution_channel__c;									// 分销渠道
                customerInfo.emergencylevel					= acc.OA_Emergency_level__c;//'1';//acc.Emergency_level__c;										// 紧急程度
            if(String.isEmpty(Seller)){
                customerInfo.ledgerName						= acc.Ledger_Name__c;	// 账套名称
            }else {
                customerInfo.ledgerName						= Seller;// 账套名称
            }            												
                customerInfo.name							= acc.Name;														// 客户名
                customerInfo.operateType					= '新增';//acc.Operate_Type__c;//'0';										// 操作类型
                customerInfo.ownerName						= acc.Owner.Name;												// 销售员
                customerInfo.phone							= acc.Phone;													// 客户电话
                customerInfo.productGroup					= acc.Product_Group__c;											// 产品组
                customerInfo.salesDept						= acc.Sales_Dept__c;											// 销售部门
            
            
                customerInfo.guojia						    = acc.billingcountry;											// 国家
                customerInfo.jiedao							= acc.BillingStreet;											// 街道
                customerInfo.zhou					        = acc.billingstate;											    // 州
                customerInfo.chengshi						= acc.billingcity;											    // 城市
            
            
            if(String.isEmpty(salesGroup)){
				customerInfo.salesGroup						= acc.Sales_Group__c;                
            }else {
                customerInfo.salesGroup						= salesGroup; 
            }
            												// 销售组
                customerInfo.salesOrg						= acc.Sales_Org__c;												// 销售组织
            if(String.isEmpty(salesRegion)){
                customerInfo.salesRegion					= acc.Sales_Region__c;											// 销售地区
            }else{
                customerInfo.salesRegion					= salesRegion;
            }           	
                customerInfo.search_x						= acc.Search__c;												// 搜索
                customerInfo.streetRoomNumber				= acc.Street_Room_Number__c;									// 街道/房号
            	customerInfo.subjectGroup					= acc.Subject_Group__c;											// 科目组
                customerInfo.taxpayerIdentificationNo		= acc.Taxpayer_Identification_No__c;							// 纳税人识别号
                customerInfo.title							= 'CRM新增客户主数据流程-' + acc.OA_UserName__c + '-' +String.valueOf(Date.today());												// 标题
                if (acc.Country_Scope__c == '国内') {
                    customerInfo.GJFL = '0';
                }else if (acc.Country_Scope__c == '欧盟') {
                    customerInfo.GJFL = '1';
                }else if (acc.Country_Scope__c == '美国') {
                    customerInfo.GJFL = '2';
                }else if (acc.Country_Scope__c == '澳大利亚') {
                    customerInfo.GJFL = '3';
                }else if (acc.Country_Scope__c == '新西兰') {
                    customerInfo.GJFL = '4';
                }else if (acc.Country_Scope__c == '英国') {
                    customerInfo.GJFL = '5';
                }else if (acc.Country_Scope__c == '加拿大') {
                    customerInfo.GJFL = '6';
                }else{
					customerInfo.GJFL = '7';
                }                
                customerInfo.ABA                            = acc.Routing_Number_ABA__c;//outing Number（ABA） 
                customerInfo.BSB                            = acc.BSB_Number__c;//BSB Number
                customerInfo.SCQSH                          = acc.SC_No__c;//SC清算号
                customerInfo.CCQSH                          = acc.CC_No__c;//CC清算号
                customerInfo.GSZCH                          = acc.Company_Registration_No__c;//公司注册号
                customerInfo.SH                             = acc.Tax_No__c;//税号
                //customerInfo.ZJSJ                           = acc.Applicant_Direct_Superior__c;//申请人直属上级
            system.debug('-------customerInfo:' + customerInfo);
            //OAserviceServicesWeaverComCn.SapServiceHttpPort service	= new OAserviceServicesWeaverComCn.SapServiceHttpPort();
            //OAserviceServicesWeaverComCn.CrmServiceHttpPort service = new OAserviceServicesWeaverComCn.CrmServiceHttpPort();
            //AsyncCrmserviceServicesWeaverComCn.AsyncCrmServiceHttpPort OAservice = new AsyncCrmserviceServicesWeaverComCn.AsyncCrmServiceHttpPort();
            //OAservice.timeout_x = 240000;
            //webservicesCustomerWeaverComCn00000.CrmServiceHttpPort   service = new  webservicesCustomerWeaverComCn00000.CrmServiceHttpPort ();
            crmserviceServicesWeaverComCn.CrmServiceHttpPort service = new crmserviceServicesWeaverComCn.CrmServiceHttpPort();
            service.timeout_x = 60000;

            // system.debug('======' + service.createCustomerWorkFlow(customerInfo));
            retVal =service.createCustomerWorkFlow(customerInfo);
            system.debug('-----retVal.length();  : ' + retVal.length());
            if(retVal.length()<20 ){
            acc.OA_External_ID__c = retVal;
            }
            if(retVal.length()>=20){
            acc.OA_External_ID__c = retVal.substring(20);
            }
            
            acc.Title__c = 'CRM新增客户主数据流程-' + acc.OA_UserName__c + '-' + todayTime;
            update acc;
            //retVal	= service.createCustomerWorkFlow(customerInfo);
            system.debug('-----  : ' + retVal);
            //return retVal;
        }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
            errorMsg = ex.getMessage();
            system.debug('------->Exception:' + errorMsg );
        }
        
        SapTools.uploadLogList.add(log);
        //return retVal;
        
    }
}