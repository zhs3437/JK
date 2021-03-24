public class SapSync_StatusChange {
       public List<Log__c> lst_log {get;set;}
    public String invproductName {get;set;}
    public  List<Distribution_Stock__c> syncDisStockLst {get;set;}
    public SapNewEccStatusChange.StatusChange_element[]  StatusChangeList{get;set;}
 
  //  public List<sapEccUnbook.Unbook_element>  book{get;set;}
  //  public List<sapEccUnbook.UnbookReturn_element> unbookList{get;set;}
   // public 
    // structure
    public SapSync_StatusChange(){
        
    }
     // generate basic data
    public void generateData(List<Distribution_Stock__c> DisStockList){
        system.debug('1234');
        syncDisStockLst=DisStockList;
         StatusChangeList =new List<SapNewEccStatusChange.StatusChange_element>();
        system.debug('syncDisStockLst-->'+syncDisStockLst);
         system.debug('5678');
    }
    
     public List<SapNewEccStatusChange.StatusChangeReturn_element> sync(){
         system.debug('1234');
         //  system.debug('syncDisStockLst-->'+syncDisStockLst);
       // System.debug('syncDisStockLst.size()-->'+syncDisStockLst.size());
           // init - log for recording every integration call
        Log__c log = new Log__c();
       try{
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'StatusChange';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
          
          Date timeTest = Date.today();
           for(Distribution_Stock__c DisSto : syncDisStockLst){
             SapNewEccStatusChange.StatusChange_element 	syncInvent 	= new SapNewEccStatusChange.StatusChange_element();
             String  NewSTATUS  = DisSto.Status__c;
             NewSTATUS = SapMap.InventoryStatusValue(NewSTATUS);
               system.debug('NewSTATUS-->'+NewSTATUS);
             String  OldSTATUS  = DisSto.Status_Old__c;
              OldSTATUS = SapMap.InventoryStatusValue(OldSTATUS);
                 system.debug('OldSTATUS-->'+OldSTATUS);
             syncInvent.WERKS                      ='1250';//工厂地
               system.debug('WERKS-->'+ syncInvent.WERKS);
             syncInvent.LGORT                      =DisSto.SAP_W_H__c;//仓库地
               system.debug('LGORT-->'+ syncInvent.LGORT);
             syncInvent.STATUS_NEW                 =NewSTATUS;//新状态
             syncInvent.STATUS_OLD                 =OldSTATUS;//新状态
               
             syncInvent.BLNO                       =DisSto.SAP_BLNO__c;//提单号   
               system.debug('BLNO-->'+ syncInvent.BLNO);
             syncInvent.MATNR                      =DisSto.SAP_Materiel_No__c;//物料号
               system.debug('MATNR-->'+ syncInvent.MATNR);
             syncInvent.BISMT                      =DisSto.Product__c;//产品名    
               system.debug('BISMT-->'+ syncInvent.BISMT);
             system.debug('DisSto.Distribution_Quantity__c-->'+DisSto.Distribution_Quantity__c);
             syncInvent.QYP_PC                     =String.valueof(DisSto.Distribution_Quantity__c);//数量预订
            // syncInvent.LIFNR                      ='1000589';//客户
             syncInvent.NAME1                      =DisSto.Account__c;//客户名
              syncInvent.SALESNO                   =DisSto.Sales__c;//销售号
             syncInvent.CONTNO                     =DisSto.Contract_PO_PI__c;//合同号
              system.debug('DisSto.id---->'+DisSto.id);
             syncInvent.ZCRMNO                     =DisSto.Id;//DisSto.Id;//预定编号 CRM中 Distribution_Stock__c ID  
             String RDATE                          =String.valueOf(timeTest);
              RDATE                                =RDATE.remove('-'); 
              RDATE                                =RDATE.remove(' 00:00:00'); 
             syncInvent.RDATE                      =RDATE;//String.valueof(DisSto.Date_of_delivery__c);//需求交货日期
             syncInvent.ZTERMS                     =DisSto.Payment_Term__c;//付款条款  
             syncInvent.UNAME                      ='';//操作人员名
             syncInvent.RDATE1                     ='';//Confrim的日期
             syncInvent.CODATE                     ='';//complete日期
             syncInvent.BDATE                      ='';//Book Date
             syncInvent.ZTERM                      ='';//付款
             syncInvent.REMARK                     ='';//DisSto.InputNumber__c;//备注
 
            StatusChangeList.add(syncInvent);
             
           }
         
          
           SapNewCrmStatusChange.HTTPS_Port             service = new  SapNewCrmStatusChange.HTTPS_Port();   
           service.timeout_x = 60000;
           SapNewEccStatusChange.StatusChangeReturn_element[] StatusChangeL =service.SI_CRM2ECC_StatusChange_Out(StatusChangeList);

           
           system.debug('  StatusChangeL.size()--->'+  StatusChangeL);
           return StatusChangeL;
       }catch(Exception ex){
           
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
           system.debug('ex.getMessage()-->'+ex.getMessage());
           system.debug('ex.getMessage()-->'+ex.getStackTraceString());
        }
         SapTools.uploadLogList.add(log);
             return null;
     }


}