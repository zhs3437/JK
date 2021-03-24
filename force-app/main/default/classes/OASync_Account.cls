public class OASync_Account {
    
    public Static String retVal;
    //Account acc = new Account();    
    Order ord = new Order();
    public String errorMsg = '';
    public List<Log__c> lst_log {get;set;}
    public String Seller = '';
    public String salesGroup = '';
    public String salesRegion = '';
    public String accountCountry = '';
    // structure
    public OASync_Account(){
    }    
    // generate basic data
    public void generateData(Order ord){
        this.ord = ord;
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
            // tool
            /*
            OAwebservicesWorkflowWeaver.PrePaymentMainInfo		mainInfo		= new OAwebservicesWorkflowWeaver.PrePaymentMainInfo();
            OAwebservicesWorkflowWeaver.PrePaymentDetailInfo	detailInfo		= new OAwebservicesWorkflowWeaver.PrePaymentDetailInfo();
            OAwebservicesWorkflowWeaver.PrePaymentTotalInfo		totalInfo		= new OAwebservicesWorkflowWeaver.PrePaymentTotalInfo();            
       		OAwebservicesWorkflowWeaver.Customerinfo			customerInfo	= new OAwebservicesWorkflowWeaver.Customerinfo();
            OAwebservicesWorkflowWeaver.DeliveryMainInfo		deliveryInfo	= new OAwebservicesWorkflowWeaver.DeliveryMainInfo();   
*/            
            Seller = SapMap.getSellerCode(ord.SELLER__c);
            salesGroup = SapMap.getsalesRegion(ord.Sales_Group__c);
            salesRegion = SapMap.getOwnerRegion(ord.Sales_Region__c);
            accountCountry = SapMap.getCountryOACode(ord.Buyer__r.Country__c);
            system.debug('====国家：'+SapMap.getCountryOACode(ord.Buyer__r.Country__c));
            system.debug('====Seller' + Seller);
            system.debug('====salesGroup' + salesGroup);
            //webservicesWorkflowWeaver11111.Customerinfo  customerInfo = new webservicesWorkflowWeaver11111.Customerinfo();
			//webservicesWorkflowWeaver.Customerinfo 				customerInfo 	= new webservicesWorkflowWeaver.Customerinfo(); 
            webservicesWorkflowWeaver.Customerinfo            customerInfo  = new webservicesWorkflowWeaver.Customerinfo();
            //webservicesWorkflowWeaver.Customerinfo              customerInfo    = new webservicesWorkflowWeaver.Customerinfo(); 
            	customerInfo.CRMNO							= ord.SAP_External_ID__c;										// 返回SAP客户ID
                customerInfo.IBANCode						= ord.IBAN_Code__c;												// IBAN code
                customerInfo.SWIFTCode						= ord.SWIFT_Code__c;											// SWIFI code
                customerInfo.accountAllocationGroup			= ord.Account_Allocation_Group__c;							// 账户分配组
                customerInfo.accountGroup					= ord.Account_Group__c;												// 客户组
                customerInfo.accountHolder					= ord.Account_Holder__c;										// 开户人
                customerInfo.bankAccount					= ord.Bank_Account__c;											// 银行账户
                customerInfo.bankCity						= ord.Bank_City__c;												// 银行城市
                customerInfo.bankCode						= ord.Bank_Code__c;												// 银行代码
                customerInfo.bankCountry					= ord.Bank_Country__c;											// 银行国家
                customerInfo.bankName						= ord.Bank_Name__c;												// 银行名称
                customerInfo.bankRegion						= ord.Bank_Region__c;											// 银行区域
                customerInfo.vatno                          = ord.VAT_NO__c;                                                //客户VAT NO
                customerInfo.ydregin                        = ord.GST_Classification_Region__c;                             //印度分类地区
                customerInfo.bankStreet						= ord.Bank_Street__c;											// 银行街道
                customerInfo.contractCurrency				= ord.CurrencyIsoCode.subString(0,3);//acc.Contract_Currency__c;										// 客户货币
            if(String.isEmpty(accountCountry)){
                customerInfo.country						= ord.Buyer__r.Country__c;
            }else{
                customerInfo.country						= SapMap.getCountryOACode(ord.Buyer__r.Country__c);//'US 美国';//acc.Country__c;	// 客户国家
            }
            	customerInfo.creator						= ord.Account_Owner_Sap_Id__c;										// 客户所有人的SAP Id号
                customerInfo.distributionchannel			= ord.Distribution_channel__c;									// 分销渠道
                customerInfo.emergencylevel					= ord.OA_Emergency_level__c;//'1';//acc.Emergency_level__c;										// 紧急程度
            if(String.isEmpty(Seller)){
                customerInfo.ledgerName						= ord.SELLER__c;	// 账套名称
            }else {
                customerInfo.ledgerName						= Seller;// 账套名称
            }            												
                customerInfo.name							= ord.Buyer__r.Name;														// 客户名
                customerInfo.operateType					= '新增';//ord.Operate_Type__c;//'0';										// 操作类型
                customerInfo.ownerName						= ord.Contract_Owner__r.Name;												// 销售员
                customerInfo.phone							= ord.Buyer__r.Phone;													// 客户电话
                customerInfo.productGroup					= ord.Product_Group__c;											// 产品组
                customerInfo.salesDept						= ord.Sales_Dept__c;											// 销售部门
            if(String.isEmpty(salesGroup)){
				customerInfo.salesGroup						= ord.Sales_Group__c;                
            }else {
                customerInfo.salesGroup						= salesGroup; 
            }
            												// 销售组
                customerInfo.salesOrg						= ord.Sales_Org__c;												// 销售组织
            if(String.isEmpty(salesRegion)){
                customerInfo.salesRegion					= ord.Sales_Region__c;											// 销售地区
            }else{
                customerInfo.salesRegion					= salesRegion;
            }           	
                customerInfo.search_x						= ord.Search__c;												// 搜索
                customerInfo.streetRoomNumber				= ord.Street_Room_Number__c;									// 街道/房号
            	customerInfo.subjectGroup					= ord.Subject_Group__c;											// 科目组
                customerInfo.taxpayerIdentificationNo		= ord.Taxpayer_Identification_No__c;							// 纳税人识别号
                customerInfo.title							= ord.Account_Title__c;													// 标题
                if (ord.Country_Scope__c == '国内') {
                    customerInfo.GJFL = '0';
                }else if (ord.Country_Scope__c == '欧盟') {
                    customerInfo.GJFL = '1';
                }else if (ord.Country_Scope__c == '美国') {
                    customerInfo.GJFL = '2';
                }else if (ord.Country_Scope__c == '澳大利亚') {
                    customerInfo.GJFL = '3';
                }else if (ord.Country_Scope__c == '新西兰') {
                    customerInfo.GJFL = '4';
                }else if (ord.Country_Scope__c == '英国') {
                    customerInfo.GJFL = '5';
                }else if (ord.Country_Scope__c == '加拿大') {
                    customerInfo.GJFL = '6';
                }else {
					customerInfo.GJFL = '7';
                }
                
                customerInfo.ABA                            = ord.Routing_Number_ABA__c;//outing Number（ABA） 
                customerInfo.BSB                            = ord.BSB_Number__c;//BSB Number
                customerInfo.SCQSH                          = ord.SC_No__c;//SC清算号
                customerInfo.CCQSH                          = ord.CC_No__c;//CC清算号
                customerInfo.GSZCH                          = ord.Company_Registration_No__c;//公司注册号
                customerInfo.SH                             = ord.Tax_No__c;//税号
                //customerInfo.ZJSJ                           = ord.Applicant_Direct_Superior__c;//申请人直属上级
            
            system.debug('-------customerInfo:' + customerInfo);
            

            //webservicesCustomerWeaverComCn11111.CrmServiceHttpPort   service = new  webservicesCustomerWeaverComCn11111.CrmServiceHttpPort ();
            
            crmserviceServicesWeaverComCn.CrmServiceHttpPort service = new crmserviceServicesWeaverComCn.CrmServiceHttpPort();
            //crmserviceServicesWeaverComCn.CrmServiceHttpPort service = new crmserviceServicesWeaverComCn.CrmServiceHttpPort();
            service.timeout_x = 60000;
            //system.debug('=======' + service.createCustomerWorkFlow(customerInfo));
            retVal = service.createCustomerWorkFlow(customerInfo);
            //retVal =service.createCustomerWorkFlow(customerInfo);
            ord.OA_External_ID__c = retVal;
            update ord;
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