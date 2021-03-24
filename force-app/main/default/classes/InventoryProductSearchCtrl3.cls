global without sharing class InventoryProductSearchCtrl3 {
    global Inventory__c iv{get;set;}
    global List<Inventory__c> icLst{get;set;}
    global Integer dsLstSize{get;set;}
    global String requestId{get;set;}
    global String deleteID {get;set;}
    global String editID   {get;set;} 
    global String bookID   {get;set;}
    global Inventory__c ivs{get;set;}
    global Distribution_Stock__c currentItem {get;set;}
    global Boolean isSpilit {get;set;}// true - 进入拆分 / false - 选择产品
    global String requestQuantity {get;set;}//需要拆分的条数
    global Distribution_Stock__c ds{get;set;}
    global List<Distribution_Stock__c> dsLst{get;set;}
    global  List<Distribution_Stock__c> spilitLst {get;set;}
    global Apply_Inventory__c ai{get;set;}
    global String Status {get;set;}
    public String SapInvoice{get;set;}
    public String SapInvoiceflag{get;set;}
    global User us{get;set;}
    public List<Distribution_Stock__c> newDsLst{get;set;}
    public String SyncSapInformation{get;set;} 
    global String qua{get;set;}
    global String salesReder{get;set;}//销售不可见预定库存的按钮
    global List<Distribution_Stock__c> gl{get;set;}
    public List<History> HistoryList{get;set;}
    public class History{
        public boolean isSelect     { get; set; }
        public String  ID           {get;set;}
        public List<Distribution_Stock__c> gl{ get; set; }
        public History(){
            ID  = '1';
            isSelect = false;
            gl = new List<Distribution_Stock__c>();
        }
        public void hac(Distribution_Stock__c tip){
            gl.add(tip);
        }
    }
    //public InventoryProductSearchCtrl3(){}
    
    public InventoryProductSearchCtrl3(ApexPages.StandardController ctrl){
        requestId = ApexPages.currentPage().getParameters().get('id');
        SyncSapInformation = null;
        deleteID = null;
        editID = null;
        SapInvoiceflag = null;
        isSpilit = false;
        iv = new Inventory__c();
        currentItem = new Distribution_Stock__c();
        ds = new Distribution_Stock__c();
        dsLst = InventoryModeList();
        dsLstSize =   dsLst.size();
        SapInvoice = null;
        ai = new Apply_Inventory__c();
        us = new User();
        String str = UserInfo.getUserRoleId();
        spilitLst = new List<Distribution_Stock__c>();
        User uss =[Select id,Name,UserRoleId from User where Id =:'0056F000004TaI0'];
        //统计预留库存呢中存在的发票号
        newDsLst=[Select Id,SAP_Invoice__c,SAP_Delivery_order_no__c from Distribution_Stock__c ]; 
        for(Distribution_Stock__c newDs : newDsLst){
            if(String.isNotEmpty(newDs.SAP_Invoice__c) && String.isNotEmpty(newDs.SAP_Delivery_order_no__c)){
                if(SapInvoice ==null){
                    SapInvoice = newDs.SAP_Invoice__c;
                }else{
                    SapInvoice = SapInvoice +','+newDs.SAP_Invoice__c;
                }
                
            }
        }
        
        if(str=='00E90000000MemhEAC' || str=='00E90000000JFUQEA4'){
            salesReder = 'false'; 
        }else{
            system.debug('111');
            salesReder = 'true';
        }
    }
    
    // Mode Data
    public List<Distribution_Stock__c> InventoryModeList(){
        List<Distribution_Stock__c> gl = new List<Distribution_Stock__c>{};
            try {
                system.debug('requestId-->'+requestId);
                gl = [Select id,Name,BL_NO__c,Status__c,isSelect_c__c,Product_Type__c,Total_MW__c,Order__c,Inventory__c,SAP_Short_Materiel_No__c,
                      Date_of_delivery__c,Contract_PO_PI__c,Payment_Term__c,SAP_TYPE__c,SAP_TYPES__c,Account__c,SAP_Invoice__c,OrderRowNo__c,
                      Apply_Inventory__c,InputNumber__c,Distribution_Quantity__c,SAPOrderID__c,SAP_W_H__c,SAP_Materiel_No__c,SAP_Delivery_order_no__c,SAP_Message__c,
                      SAP_BLNO__c,SAP_LGORT__c,SAP_WERKS__c from Distribution_Stock__c where Apply_Inventory__c=:requestId And Distribution_Quantity__c !=0];
                system.debug('gl'+gl.size());
                for(Distribution_Stock__c gs:gl){
                    if(gs.SAP_Short_Materiel_No__c !=null){
                        gs.SAP_Short_Materiel_No__c =  gs.SAP_Short_Materiel_No__c.remove('0000000000');   
                    }
                    if(gs.SAP_TYPES__c== null){
                        gs.SAP_TYPE__c = '未同步';
                    }
                }
                //insert gss;
                system.debug('requestID'+requestId);
                
                if(gl.size()>0){
                    HistoryList = new List<History>();
                    History h = new History();
                    for(Distribution_Stock__c tip:gl){
                        // h = new History();
                        //   HistoryList.add(h);
                        h.hac(tip);
                    }
                    HistoryList.add(h);
                }
            } catch (QueryException e){
                system.debug(e.getMessage());
            }
        
        return gl;
    }        
    
    
    
    //global void deleProduct(){
    //    if(deleteID != null && deleteID != ''){
    //         iv = [SELECT ID,Name FROM Inventory__c WHERE ID =: deleteID];
    //       system.debug('ac'+iv);
    //       delete iv;
    //   }
    //}
    
    global PageReference saveEditPayment() {
        try {
            for(Distribution_Stock__c newPay : dsLst){
                
                if(newPay.ID == editID){
                  if(SapInvoice !=null){
                        system.debug('SapInvoice-->'+SapInvoice);
                        System.debug('SapInvoice.indexOf(newPay.SAP_Invoice__c)-->'+SapInvoice.indexOf(newPay.SAP_Invoice__c));
                        System.debug('newPay.SAP_Invoice__c)-->'+newPay.SAP_Invoice__c);
                        if(SapInvoice.indexOf(newPay.SAP_Invoice__c)>-1  && (newPay.SAP_Invoice__c !=null && newPay.SAP_Invoice__c !='')){
                            for(Distribution_Stock__c newPayV1 : newDsLst){
                                System.debug('123');
                                if(newPayV1.Id == newPay.Id && String.isNotEmpty(newPayV1.SAP_Invoice__c)){
                                    if( newPayV1.SAP_Invoice__c != newPay.SAP_Invoice__c){
                                            update newPay;
                                            editID = null;
                                    }else{
                                        if(String.isEmpty(newPayV1.SAP_Delivery_order_no__c)){
                                             update newPay;
                                            editID = null; 
                                            
                                        }else{
                                             SapInvoiceflag ='true';
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '发票号重复')); 
                                            return null;
                                        }
                                       
                                    }
                                    /**
                                    if(newPayV1.SAP_Delivery_order_no__c !=null ){
                                        if( newPayV1.SAP_Invoice__c == newPay.SAP_Invoice__c){
                                            update newPay;
                                            editID = null;
                                        }
                                        else {
                                            SapInvoiceflag ='true';
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '发票号重复')); 
                                            return null;  
                                        }  
                                    } else{
                                        if( newPayV1.SAP_Invoice__c == newPay.SAP_Invoice__c){
                                            update newPay;
                                            editID = null;
                                        }
                                   
                                    }
*/
                                }
                            }
                        }else{
                            update newPay;
                            editID = null;
                        }
                    }
                    
                }
                if(newPay.Status__c=='Cancel' && newPay.SAP_TYPE__c=='未同步' ){
                    delete newPay; 
                    editID = null;
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
    
    // public PageReference CancelPaymentRequest () {
    //    icLst        = InventoryModeList();
    //    editID             = '';
    //    return null;
    // }
    public PageReference CancelPaymentRequest () {
        editID             = '';
        return null;
    }
    
    
    public PageReference SyncSAPChangeStatus (){
        Integer i = 0;
        List<String> glLst = new List<String>();
        ai = [select id,name,Approval_Status__c from Apply_Inventory__c where id=:requestId];
        system.debug('111'+ai.Approval_Status__c);
        for(History his : HistoryList){
            for(Distribution_Stock__c tt : his.gl){
                if(tt.isSelect_c__c==true){
                    system.debug('tt'+tt.Product_Type__c);
                    i=i+1;
                    glLst.add(tt.id);
                    system.debug('tt'+tt.isSelect_c__c);
                    tt.isSelect_c__c = false;
                    system.debug('tt'+tt.isSelect_c__c);
                    if(tt.SAP_TYPES__c == 'S'){
                        ai.Approval_Status__c = 'Approved';
                        system.debug('sss'+tt.SAP_TYPES__c);
                    }
                }
            }
            if(i==his.gl.size()){
                SAPPassTest.getDisStock(requestId);
            }else{
                SAPPassTest.getDisStockAlone1(glLst);
            }
            
        }
        update ai;        
        system.debug('12344');
        system.debug('Start 123');
        //SAPPassTest.getDisStock(requestId);
        return null;
        
    }
    public PageReference SyncSAPCompleteStatus (){
        system.debug('12344');
        system.debug('Start 123');
        List<Distribution_Stock__c> syncDisStockLst = new List<Distribution_Stock__c>();
        // syncDisStockLst = [Select id,Account__c,Name,Apply_Inventory__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Date_of_delivery__c,Distribution_Quantity__c,ETA__c,ETD__c,Factory__c,Inventory__c,Payment_Term__c,
        //                        Product__c,InputNumber__c,Sales__c,SAP_Materiel_No__c,SAP_Message__c,SAP_TYPE__c,Status__c,Status_Old__c,Total_MW__c,WERKS__c from Distribution_Stock__c where  Apply_Inventory__c =:requestId];
        system.debug('start SapTools');
        SapTools.getCompleteStatus(requestId);
        return null;
    }
    /**
public PageReference SyncSAPWareHouseStatus (){
system.debug('12344');
system.debug('Start 123');
List<Distribution_Stock__c> syncDisStockLst = new List<Distribution_Stock__c>();
// syncDisStockLst = [Select id,Account__c,Name,Apply_Inventory__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Date_of_delivery__c,Distribution_Quantity__c,ETA__c,ETD__c,Factory__c,Inventory__c,Payment_Term__c,
//                        Product__c,InputNumber__c,Sales__c,SAP_Materiel_No__c,SAP_Message__c,SAP_TYPE__c,Status__c,Status_Old__c,Total_MW__c,WERKS__c from Distribution_Stock__c where  Apply_Inventory__c =:requestId];
system.debug('start SapTools');
SapTools.getWareHouseChange(requestId);
return null;
}
*/
    public PageReference SyncSAPCreateDN (){
        system.debug('12344');
        system.debug('Start 123');
        List<Distribution_Stock__c> syncDisStockLst = new List<Distribution_Stock__c>();
        // syncDisStockLst = [Select id,Account__c,Name,Apply_Inventory__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Date_of_delivery__c,Distribution_Quantity__c,ETA__c,ETD__c,Factory__c,Inventory__c,Payment_Term__c,
        //                        Product__c,InputNumber__c,Sales__c,SAP_Materiel_No__c,SAP_Message__c,SAP_TYPE__c,Status__c,Status_Old__c,Total_MW__c,WERKS__c from Distribution_Stock__c where  Apply_Inventory__c =:requestId];
        system.debug('start SapTools');
        // SapTools.getSAPCreateDN(requestId);
        Integer i = 0;
        String ord = null;
        String deliveryDate = null;
        SyncSapInformation = null;
        String IfcreateDelivery =null;//判断所选的数据中是否有已经创建好的交货单的
        String ConOrdId = null;
        List<String> glLst = new List<String>();
        for(History his : HistoryList){
            for(Distribution_Stock__c tt : his.gl){
                if(tt.isSelect_c__c==true){
                    ord = tt.Order__c;
                    glLst.add(tt.Id);
                    i=i+1;
                    tt.isSelect_c__c = false;
                    system.debug(' tt.SAP_Delivery_order_no__c-->'+ tt.SAP_Delivery_order_no__c);
                    if(tt.Status__c =='Released' && ( tt.SAP_Delivery_order_no__c!=null) ){
                        IfcreateDelivery='true';
                    }
                    if(String.isEmpty(String.valueOf(tt.Date_of_delivery__c))){
                        deliveryDate ='true';
                    }
                }
            }
            system.debug('i-->'+i);
            if(i==his.gl.size()){
                if(deliveryDate=='true'){
                    system.debug('IfcreateDelivery-->'+IfcreateDelivery);
                    // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '交货单发货日不能为空'));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '交货单发货日不能为空'));
                    system.debug('start error');
                }
                else if( IfcreateDelivery=='true'){
                    
                    system.debug('IfcreateDelivery-->'+IfcreateDelivery);
                    // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '交货单已申请不能再申请'));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '交货单已申请不能再申请'));
                    system.debug('start error');
                    //  return null;
                }
                else{
                    //  system.debug('IfcreateDelivery-->'+IfcreateDelivery);
                    SapTools.getSAPCreateDN(ord);
                    //  system.debug('stop  getSAPCreateDN-->');
                }
            }
            else{
                if(deliveryDate=='true'){
                    system.debug('IfcreateDelivery-->'+IfcreateDelivery);
                    // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '交货单发货日不能为空'));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '交货单发货日不能为空'));
                    system.debug('start error');
                }
                else if( IfcreateDelivery=='true'){
                    system.debug('IfcreateDelivery-->'+IfcreateDelivery);
                    //  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '交货单已申请不能再申请'));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '交货单已申请不能再申请'));
                    system.debug('start error');
                    // return null;
                }else{
                    system.debug('ord-->'+ord);
                    system.debug('glLst-->'+glLst);
                    system.debug('IfcreateDelivery-->'+IfcreateDelivery);
                    SapTools.getSAPNewCreateDN(ord,glLst);
                }
                
            }
        }
        system.debug('SyncSapInformation-->'+SyncSapInformation);
        if(SyncSapInformation=='E'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, '预留的物料号与同步到SAP中的物料号不一致'));  
        }
        return null;
    }
    public PageReference SyncSAPCancelDN (){
        system.debug('12344');
        system.debug('Start 123');
        List<Distribution_Stock__c> syncDisStockLst = new List<Distribution_Stock__c>();
        // syncDisStockLst = [Select id,Account__c,Name,Apply_Inventory__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Date_of_delivery__c,Distribution_Quantity__c,ETA__c,ETD__c,Inventory__c,Payment_Term__c,
        //                        Product__c,InputNumber__c,Sales__c,SAP_Materiel_No__c,SAP_Message__c,SAP_TYPE__c,Status__c,Status_Old__c,Total_MW__c,WERKS__c from Distribution_Stock__c where  Apply_Inventory__c =:requestId];
        system.debug('start SapTools');
        Integer i = 0;
        String ord = null;
        List<String> glLst = new List<String>();
        for(History his : HistoryList){
            for(Distribution_Stock__c tt : his.gl){
                if(tt.isSelect_c__c==true){
                    ord = tt.Order__c;
                    glLst.add(tt.Id);
                    i=i+1;
                    tt.isSelect_c__c = false;
                }
            }
            if(i==his.gl.size()){
                SapTools.getSAPCancelDN(ord);
            }else{
                system.debug('ord-->'+ord);
                system.debug('glLst-->'+glLst);
                SapTools.getSAPNewCancelDN(ord,glLst);
            }
        }
        
        //SapTools.getSAPCancelDN(requestId);
        return null;
    }
    
    /*webservice static String sendToSomeOne(String conid,String name, String emailTemplateName){
List<User> recipient= [SELECT ID,Name,Email FROM User WHERE Name =: name];
System.debug('----->recipient:'  + recipient);
System.debug('----->recipient:'  + emailTemplateName);
Utils.sendEmailWithTemplate(recipient, conid, emailTemplateName);
System.debug('----->是否发送:'  + recipient);
return '';
}
webservice static String sendToSomeOneId(String conid,Id usId, String emailTemplateName){
List<User> recipient= [SELECT ID,Name,Email FROM User WHERE ID =: usId];
System.debug('----->recipient:'  + recipient);
System.debug('----->recipient:'  + emailTemplateName);
Utils.sendEmailWithTemplate(recipient, conid, emailTemplateName);
System.debug('----->是否发送:'  + recipient);
return '';
}
*/
    public void goSpilit(){
        isSpilit = true;
        
        for(History his : HistoryList){
            for(Distribution_Stock__c tt : his.gl){
                if(tt.isSelect_c__c==true){
                    system.debug('tt.inventory-->'+tt.Inventory__c);
                    spilitLst.add(tt);              
                    currentItem = tt;
                }
            }
        }
        /**
if(requestItemId != null && requestPricebookEntryId != null){
isSpilit = true;
for(Inventory__c inventory : Inventorys){
if(inventory.Id == requestItemId){
unitPrice = inventory.UnitPrice__c;
spilitItemList.add(inventory);
currentItem = inventory;
}
}
}
*/
    }
    
    public void addItem(){
        system.debug('requestQuantity-->'+requestQuantity);
        system.debug('currentItem-->'+currentItem);
        if(requestQuantity != null && currentItem != null){
            try{
                System.debug('spilitLst-->'+spilitLst.size());
                if(spilitLst.size() > 0){
                    spilitLst = new List<Distribution_Stock__c>();
                    spilitLst.add(currentItem);
                }
                system.debug('123');
                for(Integer i = 1 ; i < Integer.valueOf(requestQuantity) ; i++ ){
                    system.debug('456');
                    Distribution_Stock__c item = currentItem.clone(false, true);
                    item.Distribution_Quantity__c  = 0;
                    item.Total_Quantity__c = currentItem.Distribution_Quantity__c;
                    spilitLst.add(item);
                }
                
            }catch(TypeException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Error Message : Please fill in integer!'));
            }
        }
    }
    
    global PageReference saveSplitItem() {
        List<Distribution_Stock__c> updatesplitLst = new List<Distribution_Stock__c>();
        List<Distribution_Stock__c> insertsplitLst = new List<Distribution_Stock__c>();
        Decimal  TotalQuantity = 0;
        Boolean  IFMore = false;//判断拆分的数据的总数量是否与老数据一致
        for(Distribution_Stock__c tt : spilitLst){
            Integer oldDistribution = 0;
            if(tt.isSelect_c__c ==true){
                for(History his : HistoryList){
                    for(Distribution_Stock__c oldtt : his.gl){
                        if(tt.Id == oldtt.Id){
                            tt.isSelect_c__c = false;
                            updatesplitLst.add(tt);
                            oldDistribution = oldDistribution +1;
                            TotalQuantity = TotalQuantity + tt.Distribution_Quantity__c;
                        }
                    }
                }
                if(oldDistribution ==0){
                    tt.isSelect_c__c = false;
                    system.debug('tt.inventory-->'+tt.inventory__c);
                    TotalQuantity = TotalQuantity + tt.Distribution_Quantity__c;
                    insertsplitLst.add(tt);
                }
            }
        }
        System.debug('TotalQuantity-->'+TotalQuantity);
        for(Distribution_Stock__c tt : spilitLst){
            system.debug('tt.Total_Quantity__c-->'+tt.Total_Quantity__c);
            if(tt.Total_Quantity__c != TotalQuantity && tt.Total_Quantity__c !=null ){
                IFMore = true;
            }
        }
        if(IFMore==true){
            system.debug('报错信息');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'拆分的数量与之前数量不一致'));
            
            
        }
        else{
            
            if(updatesplitLst !=null){
                update updatesplitLst;
            }
            if(insertsplitLst !=null){
                insert  insertsplitLst;
            }
            isSpilit = false;
        }        
        
        return null;
    }
    
}