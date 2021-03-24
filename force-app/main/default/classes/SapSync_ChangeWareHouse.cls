public class SapSync_ChangeWareHouse {
    public List<Log__c> lst_log {get;set;}
    public String InventoryId   {get;set;}
    public List<SapEccCompleteStatus.CompleteStatus_element>  CompleteStatusLst{get;set;}
    public  SapEccCompleteStatus.CompleteStatusReturn_element[] returnList{get;set;}
    public SapEccCompleteStatus.Item_element[] ItemLst{get;set;}
    public Map<String,Decimal> ChangeFnumber{get;set;}
    public Map<String,Decimal> ChangeTnumber{get;set;}
    public Map<String,Map<String,Decimal>> AllChangeFNumber{get;set;}
    public Decimal TotalTNumber {get;set;}
    public Decimal TotalFNumber {get;set;}
    public SapSync_ChangeWareHouse(){
        
    }
    // generate basic data
    public void generateData(){
        // InventoryId = InventoryId;
    }
    
    public void sync( List<Distribution_Stock__c> syncDisStockLst){
        CompleteStatusLst  = new List<SapEccCompleteStatus.CompleteStatus_element>();
        returnList         = new List<SapEccCompleteStatus.CompleteStatusReturn_element>();
        ItemLst            = new List<SapEccCompleteStatus.Item_element>();
        ChangeFnumber      = new  Map<String,Decimal>();
        ChangeTnumber      = new  Map<String,Decimal>();
        AllChangeFNumber = new  Map<String,Map<String,Decimal>>();
        TotalTNumber = 0;
        TotalFNumber = 0;         
        // init - log for recording every integration call
        system.debug('Start get Complete');
        Log__c log = new Log__c();
        try{
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'CompleteStatus';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
            System.debug('Start for');
            system.debug('syncDisStockLst-->'+syncDisStockLst);
            system.debug('syncDisStockLstSize-->'+syncDisStockLst.size());
            // for(Distribution_Stock__c diss : syncDisStockLst){
            system.debug('For 124');
            for(Distribution_Stock__c diss : syncDisStockLst){
                //if((diss.Status__c=='Booked' || diss.Status__c=='Confirmed' || diss.Status__c=='Released') &&  diss.BL_No__c=='EGLV050611'){
                if((diss.Status__c=='Booked' || diss.Status__c=='Confirmed' || diss.Status__c=='Released')){
                    SapEccCompleteStatus.CompleteStatus_element 	ConpleteStatus 	= new SapEccCompleteStatus.CompleteStatus_element(); 
                    System.debug('123');
                    ConpleteStatus.WERKS                      ='1250';//diss.SAP_WERKS__c工厂地
                    ConpleteStatus.LGORT                      ='';//diss.SAP_W_H__c;//仓库地
                    ConpleteStatus.STATUS                     =SapMap.InventoryStatusValue(diss.Status__c);//diss.Status__c;//状态
                    ConpleteStatus.BLNO                       =diss.BL_No__c;    
                    ConpleteStatus.MATNR                      =diss.SAP_Materiel_No__c;//物料号
                    ConpleteStatus.BISMT                      =diss.Product__c;//产品名
                    System.debug('789');
                    CompleteStatusLst.add(ConpleteStatus);  
                    
                }
                
                //  System.debug('CompleteStatusLst-->'+CompleteStatusLst);
            }
            System.debug('CompleteStatusLst.size()'+CompleteStatusLst.size());
            System.debug('Insert 123');           
            SapCrmCompleteStatus.HTTPS_Port             service = new  SapCrmCompleteStatus.HTTPS_Port();       
            service.timeout_x = 60000;
            system.debug('start sync');
            returnList =service.SI_CRM2ECC_CompleteStatus_Out(CompleteStatusLst);
            //List<String> SapBLst = new List<String>();
            system.debug('returnListSize===:'+returnList.size()+'--'+returnList);
            //by sam 2018-5-24 对比CRM中相同仓库和状态下的提单号、物料号相同的数量的差异
            //start
            
            calculateDisQty cDQ = new calculateDisQty();
            Map<string,Decimal> rt_blNo_sapM_NumMap = cDQ.totalNunberMethod('Released','T006');
            Map<string,Decimal> ct_blNo_sapM_NumMap = cDQ.totalNunberMethod('Confirmed','T006');
            Map<string,Decimal> bt_blNo_sapM_NumMap = cDQ.totalNunberMethod('Booked','T006');
            Map<string,Decimal> rf_blNo_sapM_NumMap = cDQ.F_totalNunberMethod('Released','T006');
            Map<string,Decimal> cf_blNo_sapM_NumMap = cDQ.F_totalNunberMethod('Confirmed','T006');
            Map<string,Decimal> bf_blNo_sapM_NumMap = cDQ.F_totalNunberMethod('Booked','T006');

            
            
            //默认的T仓，只对T仓做处理
 			cDQ.calDisMethod(returnList,'T006','Released',rt_blNo_sapM_NumMap,rf_blNo_sapM_NumMap);
            system.debug('==========Released==========');
            cDQ.calDisMethod(returnList,'T006','Confirmed',ct_blNo_sapM_NumMap,cf_blNo_sapM_NumMap);
            system.debug('==========Confirmed==========');
            cDQ.calDisMethod(returnList,'T006','Booked',bt_blNo_sapM_NumMap,bf_blNo_sapM_NumMap);
            system.debug('==========Booked==========');
        }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
            system.debug('123-->'+ex.getStackTraceString());
            system.debug('234-->'+ex.getTypeName());
        }
      //  SapTools.uploadLogList.add(log);
    }
 
}