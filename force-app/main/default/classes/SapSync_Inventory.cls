public class SapSync_Inventory {
    public static string msg {get;set;}
    public static string Tokens {get;set;}
    public String[] str1{get;set;}
    public List<Log__c> lst_log {get;set;}
    public String invproductName {get;set;}
    public String invSelectWareHouse{get;set;}
    public List<String> warehouse {get;set;}
    public List<Inventory__c> invList{get;set;}
   // public List<sapEccUnbook.Unbook_element>  book{get;set;}
    public List<sapEccUnbook.UnbookReturn_element> unbookList{get;set;}
    public  sapEccUnbook.Unbook_element[] book {get;set;}
    public  sapEccUnbook.UnbookReturn_element[] returnList{get;set;}
    public Map<String, List<Inventory__c>> InventoryMap{get;set;}
    public SapSync_Inventory(){
        
    }
     // generate basic data
    public void generateData(String productName,String SelectWarehouse){
        system.debug('123341');
        book = new List<sapEccUnbook.Unbook_element>();
        System.debug('Go into generateData');
        invproductName = productName;
        invSelectWareHouse = SelectWarehouse;
        warehouse = new List<String>();
    }

     
    
    public List<Inventory__c> sync(String productName,String SelectWarehouse){
        List<String> syncWarehouse = new List<String>();
           // init - log for recording every integration call
        Log__c log = new Log__c();
        system.debug('invproductName-->'+invproductName);
       try{
           
           if(invSelectWareHouse !=null){
                warehouse = invSelectWareHouse.split(',');  
           for(String str : warehouse){
               String sapwarehous ='';
               sapwarehous = SapMap.getNewWH(str);
               system.debug('sapwarehous-->'+sapwarehous);
               for(String str1 : sapwarehous.split(',')){
                  syncWarehouse.add(str1); 
               }
           }
           }
             
            System.debug('invproductName-->'+invproductName);
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'Inventory';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
           if(invSelectWareHouse !=null){
               for(String str : syncWarehouse){
                 system.debug('123');
                   system.debug('Str');
                      //将要搜索的数据放到SAP给出的Unbook_element类中
             sapEccUnbook.Unbook_element 	Unbook 	= new sapEccUnbook.Unbook_element();
             system.debug('5678');
             Unbook.WERKS                      ='';//工厂地
             Unbook.LGORT                      =str;////仓库地
              system.debug('str-->'+str);
             Unbook.STATUS                     ='UNBOOK';//状态
             Unbook.BLNO                       ='';//提单号   
             Unbook.MATNR                      ='';//物料号
             system.debug('invproductName-->'+invproductName);
             Unbook.BISMT                      = invproductName;//'JKM260P-60';
           system.debug('Unbook-->'+Unbook);
           book.add(Unbook);  
               }
                      
           }
           else {
                          //将要搜索的数据放到SAP给出的Unbook_element类中
             sapEccUnbook.Unbook_element 	Unbook 	= new sapEccUnbook.Unbook_element();
             system.debug('5678');
             Unbook.WERKS                      ='';//工厂地
             Unbook.LGORT                      ='';//仓库地
             Unbook.STATUS                     ='UNBOOK';//状态
             Unbook.BLNO                       ='';//提单号   
             Unbook.MATNR                      ='';//物料号
             system.debug('invproductName-->'+invproductName);
             Unbook.BISMT                      = invproductName;
           system.debug('Unbook-->'+Unbook);
           book.add(Unbook); 
           }

      
           sapUnbook.HTTPS_Port             service = new  sapUnbook.HTTPS_Port();       
           service.timeout_x = 60000;
            system.debug('start service');
         
           //调用PI wsdl 中方法
           returnList = service.SI_CRM2ECC_Unbook_Out(book);
           
          // system.debug('returnList-->'+returnList.size());
           system.debug('stop service');
           invList = new List<Inventory__c>();
           List<String> ProName = new List<String>();
           for(sapEccUnbook.UnbookReturn_element seuu : returnList){
               Inventory__c inv = new Inventory__c();
               inv.BL_NO__c = seuu.BLNO;
               String i = seuu.QYP_PC;
             
               i=i.replace('-', '');
               i=i.replace('_','');
               i=i.replace('-','');
               i=i.remove('-');

               inv.Quantity__c = Double.valueof(i);
               inv.KeyField__c = seuu.MATNR;
               inv.ProductName__c = seuu.BISMT;
               inv.Production_No__c = seuu.INVBELN;
               inv.Status__c = seuu.STATUS;
               inv.Warehouse2__c = SapMap.getWH_Opposite(seuu.LGORT);
               inv.SAP_W_H__c  = seuu.LGORT;
               inv.Batch__c = seuu.CHARG;
               inv.Power_Rate__c = seuu.Power;
               inv.UDate__c = seuu.UDATE;
               inv.MAKTX__c = seuu.MAKTX;
               
               inv.Power_W__c = (Integer.valueof(inv.Power_Rate__c))*(inv.Quantity__c);
               inv.SapFactory__c = seuu.WERKS;
               //inv.Total_MW__c
               invList.add(inv);
           }
          
    
           if(invList.size()>0){
             //  system.debug('invList'+invList.size());
               return invList;
               
           }
           return null;
         //   system.debug('service.SI_CRM2ECC_Unbook_Out(book)-->'+service.SI_CRM2ECC_Unbook_Out(book));
        //   for(sapEccUnbook.UnbookReturn_element sDTs : service.SI_CRM2ECC_Unbook_Out(book)){
        //       unbookList.add(sDTs);
        //   }
        
       }
        catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
              system.debug('ex.getStackTraceString()-->'+ex.getStackTraceString());
               system.debug('Error_Message__c-->'+ex.getMessage());    
            system.debug('ex.getStackTraceString()-->'+ex);
               return null;      
        }
       // system.debug('start update log-->');
      //  SapTools.uploadLogList.add(log);
       //   system.debug('stop update log');
        //        SapTools.uploadList();
        //  return null;
    }

}