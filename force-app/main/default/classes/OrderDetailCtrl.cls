public class OrderDetailCtrl {
    public List<Amendment__c> ad{get;set;}
    public List<Order> odc{get;set;}
    public List<Order> ClList{get;set;}
    public List<Order> cp{get;set;}    
    public String Daterange {get;set;}
    public String pro {get;set;}
    public String display {get;set;}
    //public Date dat1 {get;set;}
   // public Date dat2 {get;set;}
    public String dat1 {get;set;}
     public String dat2 {get;set;}
    public String format{get;set;}
    public String viewUrl{get;set;}
    public ID viewId{get;set;}
    public ID setId{get;set;}
    public String prod{get;set;}
    
    public id ids;
    public String requestId{get;set;}
    public boolean displayflag{get;set;}
    
    public OrderDetailCtrl(ApexPages.StandardController scc){
          displayflag=false;
        requestId = ApexPages.currentPage().getParameters().get('id');
        dat1='';
        dat2='';
        String recordname = findObjectNameFromRecordIdPrefix(requestId);
        System.debug('recordname---------------->'+recordname);
        if(recordname=='Contract'){
            Sousuo();
        }else{
            SousuoInOrder();
        }


        
        
        
        
    }
    
    public List<SelectOption> getTimeItems() {
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('None','None')); 
        options.add(new SelectOption('this day','this day')); 
        options.add(new SelectOption('this week','this week')); 
        options.add(new SelectOption('this month','this month')); 
        options.add(new SelectOption('this quarter','tthis quarter')); 
        options.add(new SelectOption('this year','this year')); 
        options.add(new SelectOption('next week','next week')); 
        options.add(new SelectOption('next month','next month')); 
        options.add(new SelectOption('next quarter','next quarter')); 
        options.add(new SelectOption('next year','next year')); 
        return options; 
    }
    Public List<Recognition__c> renkuan{get;set;}
    
 /* public void queren(){ 
            if(Daterange.equals('this day')){
                  	dat1=date.today();
                  	dat2=date.today();
                }else if(Daterange.equals('this week')){
                    
                   
                }else if(Daterange.equals('this month')){
                   
                }else if(Daterange.equals('this quarter')){
                    
                }else if(Daterange.equals('this year')){
                    
                }else if(Daterange.equals('next week')){
                    
                }else if(Daterange.equals('next month')){
                    
                }else if(Daterange.equals('next quarter')){
                    
                }else if(Daterange.equals('next year')){
                    
                }

       
    }    */
    
    
    
    
    
    
    
    
    
    
    /*public void Sousuo(){
        system.debug('dat1:'+dat1);
        system.debug('dat2:'+dat2);
        id abc;
        List<Order> aa=[select id,Name,Contract_No__c from Order];
        for(Order ab:aa){
           // if(ab.Contract_No__c==prod){
                //abc=ab.id;
                odc.add(ab);
            prod='8010p000000puhR';
          //  }
        }
    }*/
    
     public void Sousuo(){
         renkuan = new List<Recognition__c>();
         /*if(renkuan.size()>0){
             renkuan.clear();
         }*/
         
         System.debug('renkuan---->1---'+renkuan.size());
         displayflag=false;
        system.debug('dat1:'+dat1);
        system.debug('dat2:'+dat2);
        id abc;
         System.debug('requestId=======>'+requestId);
        List<Contract> aa=[select id,Name,Contract_No__c,BuyerAccount__c,BuyerAccount__r.Name,BuyerAccount__r.SAP_External_ID__c from Contract where id =:requestId];
         
        jinkosolarComEccCrmGetRecognition RecognitionClass = new jinkosolarComEccCrmGetRecognition();
         jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Request req = new jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Request();
         req.I_INPUT = new List<jinkosolarComEccCrmGetRecognition.I_INPUT_element>();
         
        jinkosolarComEccCrmGetRecognition.I_INPUT_element RecognitionInput = new jinkosolarComEccCrmGetRecognition.I_INPUT_element();
         //RecognitionInput.NAME1=aa[0].BuyerAccount__r.Name;//客户名
         RecognitionInput.BSTKD=aa[0].Contract_No__c;//销售合同号
        // RecognitionInput.ZCDATE_from=getTime(dat1);
        // RecognitionInput.ZCDATE_to=getTime(dat2);
         RecognitionInput.ZCDATE_from=getTime2(dat1);
         System.debug('RecognitionInput.ZCDATE_from----->'+RecognitionInput.ZCDATE_from);
         System.debug('RecognitionInput.ZCDATE_to----->'+RecognitionInput.ZCDATE_to);
         RecognitionInput.ZCDATE_to=getTime2(dat2);
         RecognitionInput.KUNNR=aa[0].BuyerAccount__r.SAP_External_ID__c;
         req.I_INPUT.add(RecognitionInput);
         jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Response res = new jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Response();
         //res.T_OUTPUT.clear();
         jinkosolarComEccCrmGetRecognition.T_OUTPUT_element outputLst = new jinkosolarComEccCrmGetRecognition.T_OUTPUT_element();
         res.T_OUTPUT = new List<jinkosolarComEccCrmGetRecognition.T_OUTPUT_element>();
         
         jinkosolarComCrmCrmGetRecognition HttpCrm = new jinkosolarComCrmCrmGetRecognition();
         jinkosolarComCrmCrmGetRecognition.HTTPS_Port httpsport = new jinkosolarComCrmCrmGetRecognition.HTTPS_Port();
         res = httpsport.SI_CRM2ECC_GetRecognition_Out(req.I_INPUT);
         //renkuan = res.T_OUTPUT;
        
         if(res.T_OUTPUT==null || res.T_OUTPUT.size()==0){
             displayflag=true;
             return;
         }

         
         for(jinkosolarComEccCrmGetRecognition.T_OUTPUT_element a : res.T_OUTPUT){
             displayflag=true;
             Recognition__c r = new Recognition__c();
             r.Account_Name__c =a.NAME1;//客户名
             r.Amount_of_payment_received__c = a.ZRKJE;//到款金额
             r.billing_documents__c = a.ZSONO;//开票凭证
			 r.Clearing_amount__c = a.WRBTR;//清账金额
             r.Clearing_currency__c = a.WAERS;//清账货币
			 r.Commercial_invoice__c = a.ZINVNO;//发票号
			 r.Contract_Number__c = a.BSTKD;//合同号
             r.Country__c = a.ZZLANDD;//  国家 
             r.Cunccery__c = a.ZRJHB;//货币
             r.Date_of_payment__c = a.ZCDATE;//到款日期
            // r.Description_of_payment_type__c = a.ZKXTYPE_TXT;//款项类型描述
             
                if(a.ZKXTYPE_TXT=='预付款'){
                 r.Description_of_payment_type__c ='advance payment';
             }else if(a.ZKXTYPE_TXT=='尾款'){
                 r.Description_of_payment_type__c ='balance payment';
             }
             
             
             if(a.AUGDT=='00000000'){
                 r.Financial_clearing_time__c='';
             }else{
                 r.Financial_clearing_time__c = a.AUGDT;//财务清账时间
             }
             
             r.region__c = a.VKGRP;//区域
             //r.region_name__c = a.AREAT;//区域名称
             if(a.AREAT =='非洲及中东'){
               r.region_name__c = 'Middle East&Africa';//区域名称   
             }else if(a.AREAT =='欧洲区'){
                 r.region_name__c = 'EU';
             }else if(a.AREAT =='拉美及意大利'){
                 r.region_name__c = 'Latin America&Italy';
             }else if(a.AREAT =='ROA区'){
                 r.region_name__c = 'ROA';
             }else if(a.AREAT =='南亚区'){
                 r.region_name__c = 'South Asia';
             }else if(a.AREAT =='北美'){
                 r.region_name__c = 'North America';
             }else if(a.AREAT =='北亚区'){
                 r.region_name__c = 'North Asia';
             }else if(a.AREAT =='中亚区'){
                 r.region_name__c = 'Central Asia';
             }
             
             
             r.Type_of_payment__c = a.ZKXTYPE;//款项类型
             
          
                 
              renkuan.add(r);   
                 
         }
         
         
         
         
         
         
         System.debug('renkuan.size()------>'+renkuan.size());
    	 System.debug('renkuan------>'+renkuan);
         
         
         
         
         
    } 
    
        public static String getTime(Date da){
         String month;
        String day;
        String result = '';
        if(da!=null){
        if(da.month()==1){
            month='01';
        }
        else if(da.month()==2){
            month='02';
        }   else if(da.month()==3){
            month='03';
        }   else if(da.month()==4){
            month='04';
        }   else if(da.month()==5){
            month='05';
        }   else if(da.month()==6){
            month='06';
        }   else if(da.month()==7){
            month='07';
        }   else if(da.month()==8){
            month='08';
        }   else if(da.month()==9){
            month='09';
        }
            else{
                 month=da.month()+'';
            }
         if(da.day()==1){
            day='01';
        }
        else if(da.day()==2){
            day='02';
        }   else if(da.day()==3){
            day='03';
        }   else if(da.day()==4){
            day='04';
        }   else if(da.day()==5){
            day='05';
        }   else if(da.day()==6){
            day='06';
        }   else if(da.day()==7){
            day='07';
        }   else if(da.day()==8){
            day='08';
        }   else if(da.day()==9){
            day='09';
        }
            else{
                day=da.day()+'';
            }
            
              result=da.YEAR()+''+month+day;
        }
        
        return result;
    }
       public static String getTime2(String da){
        String result;
           result=da.replaceAll('-','');
        
        return result;
    }
    
    
     public void SousuoInOrder(){
         renkuan = new List<Recognition__c>();
         /*if(renkuan.size()>0){
             renkuan.clear();
         }*/
         
         System.debug('renkuan---->1---'+renkuan.size());
         displayflag=false;
        system.debug('dat1:'+dat1);
        system.debug('dat2:'+dat2);
        id abc;
         System.debug('requestId=======>'+requestId);
        List<Order> aa=[select id,Name,Contract.Contract_No__c,Buyer__c,Buyer__r.Name,Buyer__r.SAP_External_ID__c from Order where id =:requestId];
         
        jinkosolarComEccCrmGetRecognition RecognitionClass = new jinkosolarComEccCrmGetRecognition();
         jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Request req = new jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Request();
         req.I_INPUT = new List<jinkosolarComEccCrmGetRecognition.I_INPUT_element>();
         
        jinkosolarComEccCrmGetRecognition.I_INPUT_element RecognitionInput = new jinkosolarComEccCrmGetRecognition.I_INPUT_element();
         //RecognitionInput.NAME1=aa[0].BuyerAccount__r.Name;//客户名
         RecognitionInput.BSTKD=aa[0].Contract.Contract_No__c;//销售合同号
         System.debug('RecognitionInput.BSTKD------>'+RecognitionInput.BSTKD);
         //RecognitionInput.ZCDATE_from=getTime(dat1);
         //RecognitionInput.ZCDATE_to=getTime(dat2);
         RecognitionInput.ZCDATE_from=getTime2(dat1);
         RecognitionInput.ZCDATE_to=getTime2(dat2);
         RecognitionInput.KUNNR=aa[0].Buyer__r.SAP_External_ID__c;
         req.I_INPUT.add(RecognitionInput);
         jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Response res = new jinkosolarComEccCrmGetRecognition.DT_GetRecognition_Response();
         //res.T_OUTPUT.clear();
         jinkosolarComEccCrmGetRecognition.T_OUTPUT_element outputLst = new jinkosolarComEccCrmGetRecognition.T_OUTPUT_element();
         res.T_OUTPUT = new List<jinkosolarComEccCrmGetRecognition.T_OUTPUT_element>();
         
         jinkosolarComCrmCrmGetRecognition HttpCrm = new jinkosolarComCrmCrmGetRecognition();
         jinkosolarComCrmCrmGetRecognition.HTTPS_Port httpsport = new jinkosolarComCrmCrmGetRecognition.HTTPS_Port();
         res = httpsport.SI_CRM2ECC_GetRecognition_Out(req.I_INPUT);
         //renkuan = res.T_OUTPUT;
        
         if(res.T_OUTPUT==null || res.T_OUTPUT.size()==0){
             displayflag=true;
             return;
         }

         
         for(jinkosolarComEccCrmGetRecognition.T_OUTPUT_element a : res.T_OUTPUT){
             displayflag=true;
             Recognition__c r = new Recognition__c();
             r.Account_Name__c =a.NAME1;//客户名
             r.Amount_of_payment_received__c = a.ZRKJE;//到款金额
             r.billing_documents__c = a.ZSONO;//开票凭证
			 r.Clearing_amount__c = a.WRBTR;//清账金额
             r.Clearing_currency__c = a.WAERS;//清账货币
			 r.Commercial_invoice__c = a.ZINVNO;//发票号
			 r.Contract_Number__c = a.BSTKD;//合同号
             r.Country__c = a.ZZLANDD;//  国家 
             r.Cunccery__c = a.ZRJHB;//货币
             r.Date_of_payment__c = a.ZCDATE;//到款日期
            // r.Description_of_payment_type__c = a.ZKXTYPE_TXT;//款项类型描述
               if(a.ZKXTYPE_TXT=='预付款'){
                 r.Description_of_payment_type__c ='advance payment';
             }else if(a.ZKXTYPE_TXT=='尾款'){
                 r.Description_of_payment_type__c ='balance payment';
             }
             
             if(a.AUGDT=='00000000'){
                 r.Financial_clearing_time__c='';
             }else{
                 r.Financial_clearing_time__c = a.AUGDT;//财务清账时间
             }
             
             r.region__c = a.VKGRP;//区域
             //此处稍后再改
             if(a.AREAT =='非洲及中东'){
               r.region_name__c = 'Middle East&Africa';//区域名称   
             }else if(a.AREAT =='欧洲区'){
                 r.region_name__c = 'EU';
             }else if(a.AREAT =='拉美及意大利'){
                 r.region_name__c = 'Latin America&Italy';
             }else if(a.AREAT =='ROA区'){
                 r.region_name__c = 'ROA';
             }else if(a.AREAT =='南亚区'){
                 r.region_name__c = 'South Asia';
             }else if(a.AREAT =='北美'){
                 r.region_name__c = 'North America';
             }else if(a.AREAT =='北亚区'){
                 r.region_name__c = 'North Asia';
             }else if(a.AREAT =='中亚区'){
                 r.region_name__c = 'Central Asia';
             }
            
             r.Type_of_payment__c = a.ZKXTYPE;//款项类型
                 
              renkuan.add(r);   
                 
         }
         
         
         
         
         
         
         System.debug('renkuan.size()------>'+renkuan.size());
    	 System.debug('renkuan------>'+renkuan);
         
         
         
         
         
    }

    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);

            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();

            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                //if (!sObj.contains('__')) to exclude managed package objects

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);

                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }



    
    public void test(){
        String a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
           a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
          a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
    }
    
}