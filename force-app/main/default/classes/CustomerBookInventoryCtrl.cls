global without sharing class CustomerBookInventoryCtrl {
     global String requestId{get;set;}
    global Apply_Inventory__c aic{get;set;}
    global String productName{get;set;}
    global Integer  invListSize{get;set;}
    global List<String> warehouseLst {get;set;}
    global String warehouse{get;set;}
    global Integer dsLstSize{get;set;}
    global String isSelectwarehouse{get;set;}
    global List<Distribution_Stock__c> dsLst{get;set;}
    global Distribution_Stock__c ds{get;set;}
    global List<Inventory__c> invList{get;set;}
    global List<Product2> p{get;set;}
    public List<History> HistoryList{get;set;}
    public List<OpportunityLineItem> itemsLst{get;set;}
    public List<String> testLst{get;set;} 
    public Integer testLstSize{get;set;} 
    public String setCharliy{get;set;}
    public List<String> proName{get;set;}
    public List<Customer_Book_Inventory__c> customBookInventory{get;set;}
    public String prod{get;set;}
    public String hisLst{get;set;}
    public class History{
        public boolean isSelect     { get; set; }
        public String  ID           {get;set;}
        public List<Inventory__c> invList{ get; set; }
        public History(){
            ID  = '1';
            isSelect = false;
            invList = new List<Inventory__c>();
        }
         public void hac(Inventory__c tip){
            invList.add(tip);
        }
    }
    public List<HistoryS> HistoryListS{get;set;}
     public class HistoryS{
        public boolean isSelect     { get; set; }
        public String  ID           {get;set;}
        public List<Customer_Book_Inventory__c> cbILst{ get; set; }
        public HistoryS(){
            ID  = '1';
            isSelect = false;
            cbILst = new List<Customer_Book_Inventory__c>();
        }
         public void hac(Customer_Book_Inventory__c tip){
            cbILst.add(tip);
        }
    }    
    global List<Inventory__c> icLst{get;set;}
    global List<id> keyID  {get;set;}
    global String editID   {get;set;}
    global String bookID   {get;set;}
    global String saveID   {get;set;}
    global String deleteID {get;set;}
     global String editIDS   {get;set;}
    global String bookIDS  {get;set;}
    global String saveIDS  {get;set;}
    global String deleteIDS {get;set;}
    
    public CustomerBookInventoryCtrl(ApexPages.StandardController ctrl){
       // requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('hisLst'+hisLst);
        keyID = new List<id>();
        aic = new Apply_Inventory__c() ;
        editID = null;
        deleteID = null;
        saveID = null;
        editIDS = null;
        deleteIDS = null;
        saveIDS = null;
        proName = new List<String>();
        p = [Select name,id from Product2];
        for(Product2 pro:p){
            proName.add(pro.Name);
        }
        for(integer i=0;i<proName.size();i++){
            if(prod==null){
                prod = proName.get(i);
            }else{
                prod =prod+','+proName.get(i);
            }
            
        }
        system.debug('history'+HistoryList);
        icLst = new List<Inventory__c>();
        customBookInventory = new List<Customer_Book_Inventory__c>();
     //   itemsLst = new List<OpportunityLineItem>();
        testLst = new List<String>();
        testLstSize = testLst.size();
      //  system.debug('testLst-->'+testLst);

        for(integer i=0;i<testLst.size();i++){
            if(setCharliy==null){
                setCharliy = testLst.get(i);
            }else{
                setCharliy =setCharliy+','+testLst.get(i);
            }
            
        }
        //JSONObejct json = JSONObject.fromObject(setCharliy);
      //   mdmcData1 = new Set<String>();
    ////    mdmcData1.add('aa');
      //  mdmcData1.add('bb');
    //    mdmcData1.add('cc');
    //    system.debug('mdmcData1-->'+mdmcData1);
       //  Set mdmcData=['aa', 'bb', 'cac','dd','e'];
       //  
       customBookInventory = InventoryModeList();
           dsLstSize =   customBookInventory.size(); 
    }

//客服库存管理同步到SAP
  public PageReference SyncSAPChangeStatus (){
        Integer i = 0;
        List<String> glLst = new List<String>();
        for(HistoryS his : HistoryListS){
            for(Customer_Book_Inventory__c tt : his.cbILst){
                if(tt.isSelect__c=='true'){
                    system.debug('tt'+tt.Product__c);
                    i=i+1;
                    glLst.add(tt.id);
                      system.debug('tt'+tt.isSelect__c);
                    tt.isSelect__c = null;
                      system.debug('tt'+tt.isSelect__c);
                }
            }
        
            SAPCustomDelivery.getDisStockAlone1(glLst);
        
            
        }
        //update ai;        
        system.debug('12344');
        system.debug('Start 123');
        //SAPPassTest.getDisStock(requestId);
        return null;
            
    }


    
    public List<Customer_Book_Inventory__c> InventoryModeList(){
        List<Customer_Book_Inventory__c> gl = new List<Customer_Book_Inventory__c>{};
         try {
           gl = [Select id,Name,Status__c,isSelect__c,Product__c,Total_MW__c,SAP_Short_Materiel_No__c,
                             Date_of_delivery__c,SAP_TYPE__c,SAP_TYPES__c,AccountName__c,
                             Remarks__c,Distribution_Quantity__c,SAP_W_H__c,SAP_Materiel_No__c,SAP_Message__c,
                             SAP_BLNO__c,SAP_LGORT__c,SAP_WERKS__c from Customer_Book_Inventory__c];
             system.debug('gl'+gl.size());
             for(Customer_Book_Inventory__c gs:gl){
                 if(gs.SAP_Short_Materiel_No__c !=null){
                   gs.SAP_Short_Materiel_No__c =  gs.SAP_Short_Materiel_No__c.remove('0000000000');   
                 }
                
                 system.debug('sap'+gs.SAP_TYPES__c);
                 if(gs.SAP_TYPES__c== null){
                     gs.SAP_TYPE__c = '未同步';
                 }
             }
            //insert gss;
         system.debug('requestID'+requestId);
           
             if(gl.size()>0){
                HistoryListS = new List<HistoryS>();
                HistoryS h = new HistoryS();
                for(Customer_Book_Inventory__c tip:gl){
                       // h = new History();
                       //   HistoryList.add(h);
                       h.hac(tip);
            }
                HistoryListS.add(h);
            }
        } catch (QueryException e){
            system.debug(e.getMessage());
        }
            
        return gl;
    }        
    
    
    global PageReference saveEditCustom() {
        try {
            for(Customer_Book_Inventory__c newPay : customBookInventory){
            	
                if(newPay.ID == editIDS){
                    newPay.isSelect__c =null;
                    update newPay;
                }
                 if(newPay.Status__c=='Cancel' && newPay.SAP_TYPE__c=='未同步' ){
                      delete newPay; 
                 }
                // SAPPassTest.getDisStock(requestId);
               /**
                if(newPay.Status__c=='Cancel'){
                    
                    SAPPassTest.getDisStock(requestId);
                   /**
                    if(newPay.SAP_TYPES__c=='E' && newPay.SAP_Message__c !='' ){
                         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '同步失败无法删除'));
                    }else if(newPay.SAP_TYPES__c=='S'){
                        delete newPay; 
                    }else if(newPay.SAP_TYPES__c==''){
                         delete newPay; 
                    }
                   */
              //  }
               
            }
            
        } catch (DMLException e) {
            system.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, ' Error Message：'+e.getMessage()));
            system.debug('1111111');
        }
       // for(Inventory__c newiv : icLst){
       //  if(newiv.ID == editID){
       //      Distribution_Stock__c ds = new Distribution_Stock__c();
       //     ds.Status__c = newiv.Status__c;           
       //    ds.Inventory__c = newiv.id;
       //   ds.Apply_Inventory__c = newiv.Book_Stock__c;
       //    ds.Distribution_Quantity__c = newiv.Quantity__c;
       //     ds.BL_No__c = newiv.BL_NO__c; 
       //    ds.Product_Type__c = newiv.Product_Type__c;
       //    dsLst.add(ds);
       // }
         
       //        }
        //insert dsLst;
        
        
        return null;
    }
    
    public void SearchProduct(){
        warehouseLst = new List<String>();
        system.debug('hisLst'+hisLst);
        system.debug('start SearchProduct');
        system.debug('warehouse'+warehouse);
        if(warehouse!=null){
            warehouseLst = warehouse.split(',');
        }
        system.debug('productName'+productName);
         isSelectwarehouse = warehouse;
        invList  = new  List<Inventory__c>();
        SapSync_Inventory delivery_tool = new SapSync_Inventory();
      //  system.debug('productName--->'+productName);
        system.debug('isSelectwarehouse-->'+isSelectwarehouse);
        system.debug('start generateData');
        system.debug('productName------>'+productName);
        system.debug('isSelectwarehouse----->'+isSelectwarehouse);
       delivery_tool.generateData(productName,isSelectwarehouse);
        system.debug('stop generateDate');
        invList=delivery_tool.sync(productName,isSelectwarehouse);
        system.debug('invList'+invList);
        if(invList == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '未找到数据'));
        }else{
           if(invList.size()>0){
                HistoryList = new List<History>();
                History h = new History();
                for(Inventory__c tip:invList){
                                h.hac(tip);
                  
                }
   
        HistoryList.add(h);

  
                 
    }  
        }
       
    }
    
   global void Book(){
        saveID = bookID;
        Integer i =0;
        system.debug('bookId'+bookID);
        for(History his : HistoryList){
            for(Inventory__c tt : his.invList){
                if(tt.isSelect_c__c==false){
                  i = i+1;  
                }
            }
            system.debug('i'+i);
            if(i== his.invList.size()){
                bookID = null;
                saveID = null;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '请勾选')); 
            }
              
        }
    }
     public PageReference CancelPaymentRequest () {
         system.debug('bookID'+bookID);
         
        editId             = '';
        return null;
          }
    
    global PageReference saveEditPayment() {
  
        List<Inventory__c> testProductLst = new List<Inventory__c>();
        Integer Error =0;
        Integer NumberHeight =0;
        Integer ErrorNumber = 0;
        try {
           
            for(History his : HistoryList){
                  for(Inventory__c newPay : his.invList){
                    if((newPay.InputNumber__c==null||newPay.InputNumber__c=='')&& newPay.isSelect_c__c==true){
                        Error = Error+1;
                    }else{
                        if(newPay.isSelect_c__c==true){
                            if(newPay.InputNumber__c.contains('-')){
                                ErrorNumber = ErrorNumber+1;
                            }
                       if( newPay.Quantity__c>=Integer.valueOf(newPay.InputNumber__c)){
                        newPay.Quantity__c = newPay.Quantity__c-Integer.valueOf(newPay.InputNumber__c);
                           testProductLst.add(newPay);
                       }else if(newPay.Quantity__c<Integer.valueOf(newPay.InputNumber__c)){
                           NumberHeight = NumberHeight+1;
                       }
                     }
            } 
                }  
            }
            if(Error !=0 || NumberHeight !=0 ||ErrorNumber!=0){
                if(Error !=0){
                   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Please fill in quantity'));   
                }else if(NumberHeight !=0){
                      ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '数值大'));
                }else if(ErrorNumber !=0){
                      ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '不能为负'));
                }
                
                 for(History his : HistoryList){
                  for(Inventory__c newPay : his.invList){
                    if((newPay.InputNumber__c==null||newPay.InputNumber__c=='')&& newPay.isSelect_c__c==true){
                        Error = Error+1;
 
                    }else{
                        if(newPay.isSelect_c__c==true){
                       if( newPay.Quantity__c>=Integer.valueOf(newPay.InputNumber__c)){
                        newPay.Quantity__c = newPay.Quantity__c+Integer.valueOf(newPay.InputNumber__c);
                           testProductLst.add(newPay);
                       }
                     }
            } 
                //if(newPay.Id == deleteID){
                 //   return null;
               // }
                newPay.isSelect_c__c =false;
               bookId = null;
                }  
            }
                return null;
                
            }
            
            if(testProductLst.size()>0){
                //update testProductLst;
                system.debug('testProductLst'+testProductLst.size());
            }
                              
            
        } catch (DMLException e) {
            system.debug(e.getMessage());
        }
       
         List<Inventory__c> icLsts =new List<Inventory__c>();
        system.debug('start for');
        for(Inventory__c cw : testProductLst){
             system.debug('start for');   
           if(cw.InputNumber__c==null||cw.InputNumber__c==''){
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Please fill in quantity'));
           }else{
                Inventory__c ic = new Inventory__c();
                ic.Quantity__c = cw.Quantity__c;
                ic.UDate__c = cw.UDate__c;
                ic.MAKTX__c = cw.MAKTX__c;
                //ic.Product_Type__c = cw.Product_Name__c;
                system.debug('ic'+ic.Quantity__c);
                 for(Product2 pc:p){
                    
                    if(cw.ProductName__c == pc.Name ){
                    ic.Product_Type__c = pc.id;
                      }
                   
            }
                ic.SapFactory__c = cw.SapFactory__c;
               ic.Warehouse2__c = cw.Warehouse2__c;
                ic.Guaranteed_Date__c = cw.Guaranteed_Date__c;
                ic.BL_NO__c = cw.BL_NO__c;
                ic.Total_MWS__c	 = String.valueOf((double.valueOf(cw.Power_Rate__c))*(cw.Quantity__c));
               ic.Power_Rate__c = cw.Power_Rate__c;
               ic.InputNumber__c = cw.InputNumber__c;
               ic.Status__c = cw.Status__c;
               ic.WarehouseG__c = cw.Warehouse__c;
               ic.SAP_W_H__c = cw.SAP_W_H__c;
            //ic.Book_Stock__c = requestId;

            ic.KeyField__c = cw.KeyField__c;
            ic.Account_Name__c =aic.Account_Name__c;
            ic.Factory__c = aic.Factory__c;
             
          // icLsts.add(ic);
          // insert ic;

             // system.debug('invList'+invList.size());
               if( icLst.size()>0){
                   for(Inventory__c ii :icLst){
                       if(ii.KeyField__c != ic.KeyField__c ){
                            icLsts.add(ic); 
                       }
                   }
               }   
              else {
                    icLsts.add(ic); 
              }
        
           keyID.add(ic.KeyField__c);  
           
           }
            
         }
        //system.debug('icLsts-->'+icLsts.size());   
      //  system.debug('keyID-->'+keyID);

         List <Inventory__c> KeyIc = [Select id,KeyField__c,Guaranteed_Date__c,Total_MWS__c,Factory__c,SapFactory__c,Quantity__c,InputNumber__c,Warehouse2__c ,BL_NO__c from Inventory__c where KeyField__c in:keyID];
       system.debug('KeyIc-->'+KeyIc.size());
        List <Inventory__c> insertIc = new List<Inventory__c>();
        system.debug('123456');
        List<Inventory__c> updateIc = new List<Inventory__c>();

        for(Inventory__c kic:KeyIc){
            for(Inventory__c ics:icLsts){
                system.debug('kic.KeyField__c-->'+kic.KeyField__c);
                 system.debug('ics.KeyField__c-->'+ics.KeyField__c);
                if(kic.KeyField__c==ics.KeyField__c && kic.BL_NO__c == ics.BL_NO__c){
                    kic.Guaranteed_Date__c = ics.Guaranteed_Date__c;
                    kic.InputNumber__c = ics.InputNumber__c;
                    kic.Quantity__c =  ics.Quantity__c;
                    kic.Product_Type__c = ics.Product_Type__c;
                    kic.Total_MWS__c = ics.Total_MWS__c;
                    kic.UDate__c = ics.UDate__c;
                    kic.MAKTX__c = ics.MAKTX__c;
                    kic.Power_Rate__c = ics.Power_Rate__c;
                    kic.Factory__c = ics.Factory__c;
                    kic.SapFactory__c = ics.SapFactory__c;
                    kic.Warehouse2__c = ics.Warehouse2__c;
                    kic.BL_NO__c = ics.BL_NO__c;
                    kic.SAP_W_H__c = ics.SAP_W_H__c;
                    updateIc.add(kic);
                    system.debug('update'+updateIc.size());
                }
                
            }
           
           // updateIc.add(kic);
            // system.debug('update.size'+updateIc.size());
        }
    
        system.debug('1111');
       // system.debug('icLsts-->'+icLsts.size());

        for(Inventory__c ics:icLsts){
            Integer i = 0;
            for(Inventory__c kic:KeyIc){
                if(kic.KeyField__c==ics.KeyField__c && kic.BL_NO__c == ics.BL_NO__c){
                    i=i+1;
                }
            }
            if(i==0){
                insertIc.add(ics); 
            }
        }
   
       List<Distribution_Stock__c> dsLsts = new List<Distribution_Stock__c>();
       List<Customer_Book_Inventory__c>    customBookInventoryLsts = new List<Customer_Book_Inventory__c>();
       Customer_Book_Inventory__c          customBook = new Customer_Book_Inventory__c();
        
        
        //updateIc = updateIc.stream().distinct().collect(Collectors.toList());  
       // HashSet h = new HashSet(updateIc);   
      if(updateIc.size()>0){
          system.debug('updateIc'+updateIc.size());
          for(Inventory__c inven : updateIc){
            update inven;
          }
           
             for(Inventory__c ic :updateIc){
            customBook = new Customer_Book_Inventory__c();
            //ds.Date_of_delivery__c = ic.Guaranteed_Date__c;
          //  customBook.BL_No__c = ic.BL_NO__c;
         //   ds.Apply_Inventory__c = requestId;
        //    ds.Payment_Term__c = ais.Trade_Term__c;
          //  customBook.Inventory__c = ic.Id;
//            customBook.Factory__c = ic.Factory__c;
            system.debug('1111'+ic.Total_MW__c);
            system.debug('ic.TotalMWS'+ic.Total_MW__c);
            customBook.Distribution_Quantity__c =Integer.valueOf(ic.InputNumber__c);
         //   customBook.Old_Distribution_Quantity__c =  customBook.Distribution_Quantity__c;
            customBook.Total_MW__c = String.valueOf((double.valueOf(ic.Power_Rate__c))*(customBook.Distribution_Quantity__c));
            customBook.Status__c = 'Unbook';
            customBook.Status_Old__c ='Unbook';
         //   ds.Contract_PO_PI__c = opp.Contract__c;
            customBook.Product__c = ic.Product_Type__c;
            customBook.SAP_TYPE__c ='未同步';   
            customBook.SAP_Materiel_No__c = ic.KeyField__c;
            customBook.SAP_Short_Materiel_No__c = ic.KeyField__c;
            
            customBook.SAP_WERKS__c = ic.SapFactory__c;
            customBook.SAP_LGORT__c = ic.Warehouse2__c;
            customBook.SAP_BLNO__c = ic.BL_NO__c;
            customBook.SAP_W_H__c = ic.SAP_W_H__c;
            customBookInventoryLsts.add(customBook);
            
        }
       }

      //  system.debug('insertIc.size()-->'+insertIc.size());
    system.debug('insertIc.size()'+insertIc.size());
        if(insertIc.size()>0){
         
          //  system.debug('insertIc'+insertIc);
           insert insertIc;
              for(Inventory__c ic :insertIc){
            customBook = new Customer_Book_Inventory__c();
           // ds.Date_of_delivery__c = ic.Guaranteed_Date__c;
          //  ds.Total_MW__c = ic.Total_MWS__c;
         //   ds.Payment_Term__c = ais.Trade_Term__c;
          //  customBook.BL_No__c = ic.BL_NO__c;
           // ds.Apply_Inventory__c = requestId;
         //   ds.Inventory__c = ic.Id;
            customBook.Distribution_Quantity__c = Integer.valueOf(ic.InputNumber__c);
          //  customBook.Old_Distribution_Quantity__c =  customBook.Distribution_Quantity__c;
            customBook.Total_MW__c = String.valueOf((double.valueOf(ic.Power_Rate__c))*(customBook.Distribution_Quantity__c));
            customBook.Status__c = 'Unbook';
            customBook.Status_Old__c='Unbook';
         //   ds.Contract_PO_PI__c = opp.Contract__c;
            customBook.Product__c = ic.Product_Type__c;
        //    customBook.Factory__c = ic.Factory__c;
            customBook.SAP_TYPE__c ='未同步';
            customBook.SAP_Materiel_No__c = ic.KeyField__c;
            customBook.SAP_Short_Materiel_No__c = ic.KeyField__c;
            customBook.SAP_WERKS__c = ic.SapFactory__c;
            customBook.SAP_LGORT__c = ic.Warehouse2__c;
            customBook.SAP_BLNO__c = ic.BL_NO__c;  
            customBook.Total_MW__c = ic.Total_MWS__c;
            customBook.SAP_W_H__c = ic.SAP_W_H__c;
          
            customBookInventoryLsts.add(customBook);
        }
            system.debug('insertIc'+insertIc.size());
            insertIc.clear();
    
        }
            
        if(customBookInventoryLsts.size()>0){
                insert customBookInventoryLsts;
            }

        saveID = null;  
         List<Inventory__c> newtestProductLst = new List<Inventory__c>();
        for(Inventory__c tt :testProductLst){
            if(tt.isSelect_c__c){
                tt.isSelect_c__c =false;
                tt.InputNumber__c ='';
                newtestProductLst.add(tt);
            }
        }
     
    
       bookId = null;
        return null;  
                
    }
        

}