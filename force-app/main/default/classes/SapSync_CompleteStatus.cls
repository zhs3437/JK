public class SapSync_CompleteStatus {
     public List<Log__c> lst_log {get;set;}
    public String InventoryId   {get;set;}
    public List<SapEccCompleteStatus.CompleteStatus_element>  CompleteStatusLst{get;set;}
    public  SapEccCompleteStatus.CompleteStatusReturn_element[] returnList{get;set;}
    public SapEccCompleteStatus.Item_element[] ItemLst{get;set;}
     public SapSync_CompleteStatus(){
        
    }
     // generate basic data
    public void generateData(){
       // InventoryId = InventoryId;
    }
    public void sync( List<Distribution_Stock__c> syncDisStockLst){
        CompleteStatusLst = new List<SapEccCompleteStatus.CompleteStatus_element>();
        returnList        = new List<SapEccCompleteStatus.CompleteStatusReturn_element>();
        ItemLst           = new List<SapEccCompleteStatus.Item_element>();
           // init - log for recording every integration call
         system.debug('Start get Complete');
        Log__c log = new Log__c();
        Date timeTest = Date.today();
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
          // for(Distribution_Stock__c diss : syncDisStockLst){
           system.debug('For 124');
           
           for(Distribution_Stock__c diss : syncDisStockLst){
                SapEccCompleteStatus.CompleteStatus_element 	ConpleteStatus 	= new SapEccCompleteStatus.CompleteStatus_element(); 
           System.debug('123');
            ConpleteStatus.WERKS                      ='1250';//diss.SAP_WERKS__c工厂地
            ConpleteStatus.LGORT                      =diss.SAP_W_H__c;//仓库地
            ConpleteStatus.STATUS                     ='COMPLETE';//状态
            ConpleteStatus.BLNO                       =diss.BL_No__c;   
            ConpleteStatus.MATNR                      =diss.SAP_Materiel_No__c;//物料号
            ConpleteStatus.BISMT                      =diss.Product__c;//产品名
             String RDATE                          =String.valueOf(timeTest);
              RDATE                                =RDATE.remove('-'); 
              RDATE                                =RDATE.remove(' 00:00:00'); 
            ConpleteStatus.COMPLETE_DATE              =RDATE;
            System.debug('789');
            CompleteStatusLst.add(ConpleteStatus);  
      //  System.debug('CompleteStatusLst-->'+CompleteStatusLst);
           }
           System.debug('CompleteStatusLst.size()'+CompleteStatusLst.size());
          System.debug('Insert 123');           
             SapCrmCompleteStatus.HTTPS_Port             service = new  SapCrmCompleteStatus.HTTPS_Port();       
             service.timeout_x = 60000;
           system.debug('start sync');
              returnList =service.SI_CRM2ECC_CompleteStatus_Out(CompleteStatusLst);
           
           system.debug('returnList-->'+returnList.size());

           
           List<Distribution_Stock__c> NewsyncDisStockLst = new List<Distribution_Stock__c>();
           for(SapEccCompleteStatus.CompleteStatusReturn_element secs : returnList){
         
               ItemLst=secs.Item;
               system.debug('ItemLst.size()'+ItemLst.size());
               for(SapEccCompleteStatus.Item_element itemO : ItemLst){
                  for(Distribution_Stock__c dis : syncDisStockLst){

                  if(dis.Id == itemO.RESNO && dis.Status__c=='Released'){
                    
                      system.debug('Have Complete');
                      system.debug('secs.STATUS-->'+secs.STATUS);
                      system.debug(' secs.TYPE_x-->'+ secs.TYPE_x);
                         system.debug(' secs.MSG-->'+ secs.MSG);
                     
                   dis.Status__c = 'Completed';
                    system.debug('itemO.QYP_PC-->'+itemO.QYP_PC);
                String i = itemO.QYP_PC;
               i=i.replace('-', '');
               i=i.replace('_','');
               i=i.replace('-','');
               i=i.remove('-');
                   dis.Distribution_Quantity__c = Double.valueof(itemO.QYP_PC);
                   dis.SAP_TYPES__c ='S';
                   dis.SAP_TYPE__c ='已经发货';
                      update dis;
                      //NewsyncDisStockLst.add(dis);
               }
                          }
          
               }
               
           }
           //system.debug('NewsyncDisStockLst--->'+NewsyncDisStockLst.size());
           /**
           if(NewsyncDisStockLst !=null){
             
               system.debug('Before update-->');
                update NewsyncDisStockLst;
                 system.debug('Stop update-->');
           }
          */
       }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
           system.debug('123-->'+ex.getStackTraceString());
           system.debug('234-->'+ex.getTypeName());
        }
         SapTools.uploadLogList.add(log);
    }

}