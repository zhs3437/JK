public class SapSync_CreateDn {
    public List<Log__c> lst_log {get;set;}
    public String InventoryId   {get;set;}
    public List<SapEccCreateDn.CreateDn_element>  CompleteStatusLst{get;set;}
    public  SapEccCreateDn.CreateDnReturn_element[] returnList{get;set;}
    public   String OrderItemNumber {get;set;}
    public String RTime {get;set;}
    public String DNStatus {get;set;}
    public SapSync_CreateDn(){
        
    }
    
    public void generateData(String SapDNStatus ){
        RTime=String.valueOf(Date.today());
        RTime=RTime.remove('-');
        RTime=RTime.remove(' 00:00:00');
        system.debug('RTime-->'+RTime);
        system.debug('Start SAP');
        OrderItemNumber  = null;
        DNStatus = SapDNStatus;
        CompleteStatusLst = new  List<SapEccCreateDn.CreateDn_element>();
        system.debug('DNStatus-->'+DNStatus);
    }
    
    public  List<SapEccCreateDn.CreateDnReturn_element> sync( List<Distribution_Stock__c> syncDisStockLst, List<OrderItem>  orderItemLst){
        Log__c log = new Log__c();
        system.debug('orderItemLst-->'+orderItemLst);
        system.debug('1234');
        
        try{
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'CreateDn';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
            system.debug('GOIN sync');
            String UserID = UserInfo.getUserId();//获取当前用户ID
            User us =[Select id,OA_Use_Id__c from User where Id =:UserID limit 1];
            for(Distribution_Stock__c diss : syncDisStockLst){
                List<String> OrderItemLstId = new  List<String>();
                SapEccCreateDn.CreateDn_element 	ConpleteStatus 	= new SapEccCreateDn.CreateDn_element(); 
                // System.debug('Released-->'+Released);
                if(diss.Status__c =='Released'){
                    
                    ConpleteStatus.WERKS                      ='1250';//diss.SAP_WERKS__c工厂地
                    ConpleteStatus.LGORT                      =diss.SAP_W_H__c;//仓库地
                
                    ConpleteStatus.STATUS                     ='RELEASED';//状态
                    ConpleteStatus.BLNO                       =diss.BL_No__c; 
          
                    ConpleteStatus.MATNR                      =diss.SAP_Materiel_No__c;//物料号
           
                    ConpleteStatus.BISMT                      =diss.Product__c;//产品名
                   
                    ConpleteStatus.OPRATION                   =DNStatus;  //操作状态
                
                    ConpleteStatus.QTY_PC                      =String.valueof(diss.Distribution_Quantity__c);//预定的数量
                
                    ConpleteStatus.RESNO                       =diss.Id;
              
                    if(us !=null){
                        
                        ConpleteStatus.Field1                       =  us.OA_Use_Id__c;        //'emily.yuan';  
                    
                    }
                  system.debug(' start for Order');
                    for(OrderItem Item:orderItemLst){
                        String IFExist = null;
                        system.debug('If start');
                          system.debug('Item.Product_Name__c-->'+Item.Product_Name__c);
                         system.debug('diss.Product__c-->'+diss.Product__c);
                         system.debug('diss.SAP_Delivery_order_no__c-->'+diss.SAP_Delivery_order_no__c);
                         system.debug('ConpleteStatus.OPRATION-->'+ConpleteStatus.OPRATION);
                        String ItemProductName = String.valueOf(Item.Product_Name__c);
                        String DissProductName = String.valueOf(diss.Product__c);
                        String DissDelivery = String.valueOf(diss.SAP_Delivery_order_no__c);
                        String ConpStatus = String.valueOf(ConpleteStatus.OPRATION);
                         String ItemRowNo = String.valueOf(Item.RowNo__c);
                        String DissRowNo = String.valueOf(diss.OrderRowNo__c);
                        String ItemMater = String.valueOf(Item.SAP_Materiel_No__c);
                        String dissMater = String.valueOf(diss.SAP_Short_Materiel_No__c);
                        system.debug('Item.RowNo__c---> '+ItemRowNo);
                            system.debug('diss.OrderRowNo__c---> '+DissRowNo);
                            system.debug('Item.SAP_Materiel_No__c---->'+ItemMater);
                            system.debug('diss.SAP_Short_Materiel_No__c---->'+dissMater);
                        if(ItemProductName ==DissProductName){
                            system.debug('true');
                        }
                        else {
                            system.debug('false');
                        }
                         if(DissDelivery ==null){
                            system.debug('true');
                        }
                        else {
                            system.debug('false');
                        }
                         if(ConpStatus =='CR'){
                            system.debug('true');
                        }
                        else {
                            system.debug('false');
                        }
                       
                        if(ItemProductName ==DissProductName && DissDelivery ==null && ConpStatus =='CR'){
                              system.debug('true');
                             system.debug('Start Into CR');
                                   
                            if(ItemMater == dissMater && ItemRowNo ==DissRowNo){
                                system.debug('SecondIf---> ');
                                ConpleteStatus.ZCRMNO                     =Item.Id;            //diss.Id;//diss.Id;//预定编号 CRM中 Distribution_Stock__c ID  
                                OrderItemNumber          = Item.Id;
                                ConpleteStatus.VBELN_VA                   =diss.SAPOrderID__c;//SAP OrderID
                                ConpleteStatus.ZZDLADD                    =diss.Destination__c;//CRM中送货地 
                                Date AfterDate                        =diss.Date_of_delivery__c; 
                                AfterDate                             =AfterDate.addDays(45);
                                String RDATE                          =String.valueOf(AfterDate); 
                                RDATE                                =RDATE.remove('-'); 
                                RDATE                                =RDATE.remove(' 00:00:00'); 
                                system.debug('RDATE-->'+RDATE);
                                ConpleteStatus.RDATE                      =RDATE;//String.valueOf(Date.today());//送货日
                                ConpleteStatus.ZZ_IVCNO                   =diss.SAP_Invoice__c;//发票号
                                if( ConpleteStatus.OPRATION =='CA'){
                                    ConpleteStatus.VBELN_VL                   =diss.SAP_Delivery_order_no__c;//SAP交货单号
                                    ConpleteStatus.POSNR_VL                   =diss.SAP_Delivery_Line_no__c;  //SAP交货单行项目
                                }
                                system.debug('start Add list');
                                CompleteStatusLst.add(ConpleteStatus);
                                System.debug('CompleteStatusLst.size()-->'+CompleteStatusLst.size());
                                system.debug('stop Add list');
                            }
                        }else if(Item.Product_Name__c ==diss.Product__c && diss.SAP_Delivery_order_no__c !=null && ConpleteStatus.OPRATION =='CA'){
                             system.debug('false');
                             system.debug('Start Into CA');
                            if(Item.SAP_Materiel_No__c == diss.SAP_Short_Materiel_No__c &&  Item.RowNo__c ==diss.OrderRowNo__c){
                                ConpleteStatus.ZCRMNO                     =Item.Id;            //diss.Id;//diss.Id;//预定编号 CRM中 Distribution_Stock__c ID  
                                ConpleteStatus.VBELN_VA                   =diss.SAPOrderID__c;//'0001001303';//SAP OrderID
                                ConpleteStatus.ZZDLADD                    =diss.Destination__c;//CRM中送货地
                                OrderItemNumber          = Item.Id;
                                 if(us !=null){
                                  ConpleteStatus.Field1                       =  us.OA_Use_Id__c;        //'emily.yuan';  
                                 }
                                //ConpleteStatus.Field1                       ='emily.yuan';
                                Date AfterDate                        =diss.Date_of_delivery__c;
                                
                                AfterDate                             =AfterDate.addDays(45);
                                String RDATE                          =String.valueOf(AfterDate);
                                
                                RDATE                                =RDATE.remove('-'); 
                                RDATE                                =RDATE.remove(' 00:00:00'); 
                                system.debug('RDATE-->'+RDATE);
                                ConpleteStatus.RDATE                      =RDATE;//String.valueOf(Date.today());//送货日
                                ConpleteStatus.ZZ_IVCNO                   =diss.SAP_Invoice__c;//发票号
                                if( ConpleteStatus.OPRATION =='CA'){
                                    ConpleteStatus.VBELN_VL                   =diss.SAP_Delivery_order_no__c;//SAP交货单号
                                    ConpleteStatus.POSNR_VL                   =diss.SAP_Delivery_Line_no__c;  //SAP交货单行项目
                                }
                                system.debug('start Add list');
                                CompleteStatusLst.add(ConpleteStatus);  
                                System.debug('CompleteStatusLst.size()-->'+CompleteStatusLst.size());
                                system.debug('stop Add list');
                              
                            }
                        }
                       
                        
                        
                           system.debug(' stop for CR');
                           system.debug(' stop for CA');

                        OrderItemLstId.add(Item.SAP_Materiel_No__c);
                    }
                    
                   system.debug(' stop for Order');
                    
                }
                
            }
            system.debug('stop for');
            SapCrmCreateDn.HTTPS_Port             service = new  SapCrmCreateDn.HTTPS_Port();   
            service.timeout_x = 60000;
            system.debug('start call service');
            
            
            SapEccCreateDn.CreateDnReturn_element[] StatusChangeL =service.SI_CRM2ECC_CreateDn_Out(CompleteStatusLst);
            system.debug('StatusChangeL-->');
            
            List<Distribution_Stock__c> dissLst = new List<Distribution_Stock__c>();
            for(Distribution_Stock__c diss : syncDisStockLst){
                for(SapEccCreateDn.CreateDnReturn_element sapReturn : StatusChangeL){
                    system.debug('sapReturn.RESNO-->'+sapReturn.RESNO);
                    if(sapReturn.TYPE_x=='S' && sapReturn.RESNO ==diss.Id){
                        diss.SAP_TYPES__c = sapReturn.TYPE_x;
                        diss.SAP_Delivery_order_no__c = sapReturn.VBELN_VL;
                        diss.SAP_Delivery_Line_no__c = sapReturn.POSNR_VL;
                        diss.SAP_Message__c = sapReturn.MSG;
                        diss.isSelect_c__c = false;
                        if(DNStatus=='CR'){
                            diss.SAP_TYPE__c    ='交货单申请成功';
                        }else if(DNStatus=='CA'){
                            diss.SAP_TYPE__c    ='交货单取消成功';
                            system.debug('');
                            diss.SAP_Delivery_order_no__c ='';
                        }
                        dissLst.add(diss);
                    }else if(sapReturn.TYPE_x=='E' && sapReturn.RESNO ==diss.Id){
                        system.debug('交货单失败');
                        diss.SAP_TYPES__c = sapReturn.TYPE_x;
                        if(DNStatus=='CR'){
                            diss.SAP_TYPE__c    ='交货单申请失败';
                        }else if(DNStatus=='CA'){
                            diss.SAP_TYPE__c    ='交货单取消失败';
                        }
                        
                        // diss.SAP_TYPE__c    ='交货单申请/取消失败';
                        diss.SAP_Message__c = sapReturn.MSG;
                        diss.isSelect_c__c = false;
                        dissLst.add(diss);
                    }
                    system.debug('sapReturn.VBELN_VL-->'+sapReturn.VBELN_VL);
                    system.debug('sapReturn.POSNR_VL-->'+sapReturn.POSNR_VL);
                    system.debug('sapReturn.TYPE_x-->'+sapReturn.TYPE_x);
                    system.debug('sapReturn.MSG-->'+sapReturn.MSG);
                }
            }
            system.debug('dissLst-->'+dissLst);
            if(dissLst !=null){
                update  dissLst;
            }
            return StatusChangeL;           
        }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
        }
        SapTools.uploadLogList.add(log);
        return null;
    }
    
}