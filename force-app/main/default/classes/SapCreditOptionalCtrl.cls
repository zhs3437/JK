public class SapCreditOptionalCtrl {
	
	class Credit{
            public String companyName{get;set;}
            public String companyNum{get;set;}
            
            //SAP提供的字段
            public String KLIMK{get;set;}//授信额度
            public String WAERS{get;set;}//信贷货币  无值时 = CNY
            public String CTLPC{get;set;}//风险类别
            public String RTEXT{get;set;}//风险类别描述
            public String OBLEG{get;set;}//已使用信贷额度总额
            public String ACREDIT{get;set;}//可用信用额度
            public String KLPRZ{get;set;}//超出信贷比例
            public String SKFOR{get;set;}//应收账款
            public String SSOBL{get;set;}//特别往来债务
            public String SAUFT{get;set;}//销售值
            public String ZITEMVALUE{get;set;}//最早未清应收账款金额
            public String OLESETITEM{get;set;}//最早未清应收账款天数
            public String ZOVPERCENT{get;set;}//最早未清超出的比例
        }
        
        class Message{
            public String TYPE_x{get;set;}
            public String ID{get;set;}
            public String NUMBER_x{get;set;}
            public String MESSAGE{get;set;}
            public String LOG_NO{get;set;}
            public String LOG_MSG_NO{get;set;}
            public String MESSAGE_V1{get;set;}
            public String MESSAGE_V2{get;set;}
            public String MESSAGE_V3{get;set;}
            public String MESSAGE_V4{get;set;}
        }
        
        public Credit credit{get;set;}
        public Message message{get;set;}
        
        public SapCreditOptionalCtrl () {
            AccountId = ApexPages.currentPage().getParameters().get('accid');
        }
        
        public String AccountId{get;set;}
        
        public void SAP1010(){
        	try{
                String accId = AccountId;
                Account acc = [SELECT Id,Name,SAP_External_ID__c FROM Account WHERE Id =: accId];
                if(acc.SAP_External_ID__c != null){
                    sapCredit.ZSDO0004 sap =  new sapCredit.ZSDO0004();
                    sapCredit.ZSDO0004Response_element result = sap.ZSDO0004('1010','', acc.Id);
                    System.debug('*******************accId: '+acc.Id);
                    getData(result);
                }else{
                    ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'Error!Because of this account hadnt existed in SAP system');
                    ApexPages.addMessage(m);
                }
            }catch(Exception e){
                ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'发生异常，可能是SAP服务器出现了一点问题导致您无法正常观察信用数据，请重新尝试刚才的操作回到本页面\nError! Perhaps the SAP server collapse . please click the button again to show this modules again');
                ApexPages.addMessage(m);
                System.debug( e );
            }
        }
        
        public void SAP1020(){
        	try{
                String accId = AccountId;
                Account acc = [SELECT Id,Name,SAP_External_ID__c FROM Account WHERE Id =: accId];
                if(acc.SAP_External_ID__c != null){
                    sapCredit.ZSDO0004 sap =  new sapCredit.ZSDO0004();
                    sapCredit.ZSDO0004Response_element result = sap.ZSDO0004('1020','', acc.Id);
                    getData(result);
                }else{
                    ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'Error!Because of this account hadnt existed in SAP system');
                    ApexPages.addMessage(m);
                }
            }catch(Exception e){
                ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'发生异常，可能是SAP服务器出现了一点问题导致您无法正常观察信用数据，请重新尝试刚才的操作回到本页面\nError! Perhaps the SAP server collapse . please click the button again to show this modules again');
                ApexPages.addMessage(m);
                System.debug( e );
            }
        }
        
        public void SAP1030(){
        	try{
                String accId = AccountId;
                Account acc = [SELECT Id,Name,SAP_External_ID__c FROM Account WHERE Id =: accId];
                if(acc.SAP_External_ID__c != null){
                    sapCredit.ZSDO0004 sap =  new sapCredit.ZSDO0004();
                    sapCredit.ZSDO0004Response_element result = sap.ZSDO0004('1030','', acc.Id);
                    getData(result);
                }else{
                    ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'Error!Because of this account hadnt existed in SAP system');
                    ApexPages.addMessage(m);
                }
            }catch(Exception e){
                ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'发生异常，可能是SAP服务器出现了一点问题导致您无法正常观察信用数据，请重新尝试刚才的操作回到本页面\nError! Perhaps the SAP server collapse . please click the button again to show this modules again');
                ApexPages.addMessage(m);
                System.debug( e );
            }
        }
        
        public void SAP1040(){
        	try{
                String accId = AccountId;
                Account acc = [SELECT Id,Name,SAP_External_ID__c FROM Account WHERE Id =: accId];
                if(acc.SAP_External_ID__c != null){
                    sapCredit.ZSDO0004 sap =  new sapCredit.ZSDO0004();
                    sapCredit.ZSDO0004Response_element result = sap.ZSDO0004('1040','', acc.Id);
                    getData(result);
                }else{
                    ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'Error!Because of this account hadnt existed in SAP system');
                    ApexPages.addMessage(m);
                }
            }catch(Exception e){
                ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.WARNING,'发生异常，可能是SAP服务器出现了一点问题导致您无法正常观察信用数据，请重新尝试刚才的操作回到本页面\nError! Perhaps the SAP server collapse . please click the button again to show this modules again');
                ApexPages.addMessage(m);
                System.debug( e );
            }
        }
        
        
        public void getData(sapCredit.ZSDO0004Response_element result){
        	credit = new Credit();
            message = new Message();
            
            /*信用额度信息*/
            if(result.IT_DATA.ZKLIMK!=null)credit.KLIMK = result.IT_DATA.ZKLIMK;
            if(result.IT_DATA.ZWAERS!=null)credit.WAERS = result.IT_DATA.ZWAERS;
            if(result.IT_DATA.ZCTLPC!=null)credit.CTLPC = result.IT_DATA.ZCTLPC;
            if(result.IT_DATA.ZRTEXT!=null)credit.RTEXT = result.IT_DATA.ZRTEXT;
            if(result.IT_DATA.ZOBLEG!=null)credit.OBLEG = result.IT_DATA.ZOBLEG;
            if(result.IT_DATA.ZACREDIT!=null)credit.ACREDIT = result.IT_DATA.ZACREDIT;
            if(result.IT_DATA.ZKLPRZ!=null)credit.KLPRZ = result.IT_DATA.ZKLPRZ;
            if(result.IT_DATA.ZSKFOR!=null)credit.SKFOR = result.IT_DATA.ZSKFOR;
            if(result.IT_DATA.ZSSOBL!=null)credit.SSOBL = result.IT_DATA.ZSSOBL;
            if(result.IT_DATA.ZSAUFT!=null)credit.SAUFT = result.IT_DATA.ZSAUFT;
            if(result.IT_DATA.ZITEMVALUE!=null)credit.ZITEMVALUE = result.IT_DATA.ZITEMVALUE;
            if(result.IT_DATA.OLESETITEM!=null)credit.OLESETITEM = result.IT_DATA.OLESETITEM;
            
            /*传回Message信息*/
            if(result.RETURN_x.TYPE_x!=null)message.TYPE_x = result.RETURN_x.TYPE_x;
            if(result.RETURN_x.ID!=null)message.ID = result.RETURN_x.ID;
            if(result.RETURN_x.NUMBER_x!=null)message.NUMBER_x = result.RETURN_x.NUMBER_x;
            if(result.RETURN_x.MESSAGE!=null)message.MESSAGE = result.RETURN_x.MESSAGE;
            if(result.RETURN_x.LOG_NO!=null)message.LOG_NO = result.RETURN_x.LOG_NO;
            if(result.RETURN_x.LOG_MSG_NO!=null)message.LOG_MSG_NO = result.RETURN_x.LOG_MSG_NO;
            if(result.RETURN_x.MESSAGE_V1!=null)message.MESSAGE_V1 = result.RETURN_x.MESSAGE_V1;
            if(result.RETURN_x.MESSAGE_V2!=null)message.MESSAGE_V2 = result.RETURN_x.MESSAGE_V2;
            if(result.RETURN_x.MESSAGE_V3!=null)message.MESSAGE_V3 = result.RETURN_x.MESSAGE_V3;
            if(result.RETURN_x.MESSAGE_V4!=null)message.MESSAGE_V4 = result.RETURN_x.MESSAGE_V4;
        }
        
        public static void runTest(){
            String run = 'Run Test';
            run = 'Run Test';
            run = 'Run Test';
        }
	
}