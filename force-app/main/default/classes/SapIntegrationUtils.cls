public class SapIntegrationUtils {
    
    public static List<Log__c> lst_log {get;set;}
    
    // Constructor
    public SapIntegrationUtils(){
        
        // generate basic data
        
        // generate basic log lst
        lst_log = new List<Log__c>();
        
    }
    
    // Generate Data
    public void generateData(){
        
    }
    
    // Sync SAP Product
    @future(callout=true)
    public static void syncSapProduct(){
        
        lst_log = new List<Log__c>();
        
        // init - log for recording every integration call
        Log__c log = new Log__c();
        
        try{
            // init - log details
            log.StartTime__c      = System.now();
            log.EndTime__c        = System.now();
            log.SuccessCount__c   = 0;
            log.TotalCount__c     = 0;
            log.Type__c           = 'SAP Product';
            log.SuccessIDs__c     = '';
            log.SAP_Error_Message__c = '';
            log.Error_Message__c     = '';
            
            // init - full CRM SAP Product lst
            List<SAP_Product__c> lst_full_crm_sapProduct = Database.query(Utils.MakeSelectSql('SAP_Product__c'));
            
            // init - full CRM SAP Product map
            Map<String,SAP_Product__c> map_crm_sapProduct = new Map<String,SAP_Product__c>();// product code - sap product
            
            // build - full CRM SAP Product map
            for(SAP_Product__c sapProduct : lst_full_crm_sapProduct){
                if(!map_crm_sapProduct.containsKey(sapProduct.Product_Code__c))
                    map_crm_sapProduct.put(sapProduct.Product_Code__c,sapProduct);
            }
            
            // init - insert lst
            List<SAP_Product__c> lst_insert_crm_sapProduct = new List<SAP_Product__c>();
            
            // init - update lst
            List<SAP_Product__c> lst_update_crm_sapProduct = new List<SAP_Product__c>();
            
            // TODO:取到SAP数据，循环遍历，查看crmMap中是否包含该物料号，如包含，通过最后更新日期比对，不相同则更新数据，加入更新列表。如不包含，加入新建列表
            Date start_date = Date.today().addDays(-Integer.valueOf(Label.SAP_Product_Read_Frequency));
            Date end_date   = Date.today();
            //Date start_date = Date.newInstance(2016, 5, 7);
            //Date end_date   = Date.newInstance(2016, 6, 8);
            
            // sap product sync integration
            sapProduct.ZCRM_MATERIAL_MASTER tool = new sapProduct.ZCRM_MATERIAL_MASTER();
            sapProduct.TABLE_OF_ZCRM_ZMADA result = tool.ZCRM_MATERIAL_MASTER(String.valueOf(start_date),String.valueOf(end_date),new sapProduct.TABLE_OF_ZCRM_ZMADA());
            
            // sap product delete integration : after sync product from sap ,we should tell sap which product has been synced , then sap will delete all these product from their temporary form
            sapProductDelete.ZCRM_DEL_MATERIAL tool_delete = new sapProductDelete.ZCRM_DEL_MATERIAL();
            sapProductDelete.TABLE_OF_ZCRM_ZMADA_01 T_ZCRM_ZMADA = new sapProductDelete.TABLE_OF_ZCRM_ZMADA_01();
            List<sapProductDelete.ZCRM_ZMADA_01> delete_lst = new List<sapProductDelete.ZCRM_ZMADA_01>();
            
            //foreach sap products
            for(sapProduct.ZCRM_ZMADA zcrm : result.item){
                if(zcrm != null){
                    
                    // is crmMap contains product code - update
                    if(map_crm_sapProduct.containsKey(zcrm.MATNR.subString(10,18))){
                        
                        // get sObject
                        SAP_Product__c sapProduct = map_crm_sapProduct.get(zcrm.MATNR.subString(10,18));
                        
                        System.debug('*************LAEDA: ' + zcrm.LAEDA);
                        System.debug('*************' + sapProduct.Id + ' LastModifiedDate: ' + sapProduct.LastModifiedDate);
                        
                        // compare last modified date
                        if(zcrm.LAEDA != '0000-00-00' && Date.valueOf(zcrm.LAEDA) == Date.newInstance(sapProduct.LastModifiedDate.Year(),sapProduct.LastModifiedDate.Month(),sapProduct.LastModifiedDate.Day())){
                            // the same day TODO: nothing
                        }else{
                            // not the same day TODO: update every field about this sap product,info depends on sap
                            transformSapProduct(sapProduct,zcrm);
                            
                            // add the sap product to update lst
                            lst_update_crm_sapProduct.add(sapProduct);
                            
                            // add delete element to delete lst
                            delete_lst.add(transformDeleteProduct(zcrm));
                        }
                    }else{
                        // not contains - insert
                        SAP_Product__c sapProduct = new SAP_Product__c();
                        transformSapProduct(sapProduct,zcrm);
                        
                        // add the sap product to insert lst
                        lst_insert_crm_sapProduct.add(sapProduct);
                        
                        // add delete element to delete lst
                        delete_lst.add(transformDeleteProduct(zcrm));
                    }
                }
            }
            
            // delete for sap
            if(delete_lst.size() > 0){
                
                T_ZCRM_ZMADA.item = new sapProductDelete.ZCRM_ZMADA_01[delete_lst.size()];
                for(sapProductDelete.ZCRM_ZMADA_01 zcrm : delete_lst){
                    T_ZCRM_ZMADA.item.add(zcrm);
                    // log delete material num and sync count
                    log.SuccessIDs__c += 'delete:' + zcrm.MATNR + ' / ';
                }
                
                tool_delete.ZCRM_DEL_MATERIAL(T_ZCRM_ZMADA);
                
                System.debug('&&&&&&&&&&& delete size: '+delete_lst.size());
                
                log.TotalCount__c += delete_lst.size();
            }
            
            // insert
            if(lst_insert_crm_sapProduct.size()>0){
                insert lst_insert_crm_sapProduct;//DML
                
                // log insert sf ids and success count
                for(SAP_Product__c sapProd : lst_insert_crm_sapProduct){
                    log.SuccessIDs__c += 'insert:' + sapProd.Id + ' & material no:' + sapProd.Product_Code__c + ' / ';
                }
                log.SuccessCount__c += lst_insert_crm_sapProduct.size();
                
                // sync crm product module
                generateCrmProduct(lst_insert_crm_sapProduct,log);
            }
            
            // update
            if(lst_update_crm_sapProduct.size()>0){
                update lst_update_crm_sapProduct;//DML
                
                // log update sf ids and success count
                for(SAP_Product__c sapProd : lst_update_crm_sapProduct){
                    log.SuccessIDs__c += 'update:' + sapProd.Id + ' & material no:' + sapProd.Product_Code__c + ' / ';
                }
                log.SuccessCount__c += lst_update_crm_sapProduct.size();
            }
            
        }catch(Exception ex){
            // log crm error msg
            log.Error_Message__c = ex.getMessage();
        }
        
        lst_log.add(log);
        
        // upload log
        uploadLog();
    }
    
    // insert log lst and clear log lst
    public static void uploadLog(){
        try{
            if(lst_log.size()>0){
                insert lst_log;
                lst_log = new List<Log__c>();
            }
        }catch(Exception ex){
            System.debug('----------> '+ex.getMessage());
        }
    }
    
    // by using crm sap product and sap product
    public static void transformSapProduct(SAP_Product__c sapProduct, sapProduct.ZCRM_ZMADA zcrm){
        sapProduct.Bus_bars_of_cell__c       = zcrm.ZS4B+'-'+zcrm.ZS4BT;//电池片主栅线条数特性值+电池片主栅线条数描述
        sapProduct.Cell_Len__c               = zcrm.ZS41+'-'+zcrm.ZS41T;//电池片边长特性值+电池片边长描述
        sapProduct.Cell_Number__c            = zcrm.ZS42+'-'+zcrm.ZS42T;//组件电池片数特性值+组件电池片数描述
        sapProduct.Certification__c          = zcrm.ZS43+'-'+zcrm.ZS43T;//组件认证类型特性值+组件认证类型描述
        sapProduct.Color_of_Module__c        = zcrm.ZS49+'-'+zcrm.ZS49T;//组件颜色特性值+组件颜色描述
        sapProduct.Grade__c                  = zcrm.ZS47+'-'+zcrm.ZS47T;//组件等级特性值+组件等级描述
        sapProduct.Model_Type__c             = zcrm.ZS01+'-'+zcrm.ZS01T;//晶体类型特性值+晶体类型描述
        sapProduct.OEM_Flag__c               = zcrm.ZS48+'-'+zcrm.ZS48T;//组件OEM标识特性值+组件OEM标识描述
        sapProduct.performance__c            = zcrm.ZS46+'-'+zcrm.ZS46T;//组件性能特性值+组件性能描述
        sapProduct.Power_W__c                = zcrm.ZS44+'-'+zcrm.ZS44T;//组件功率（W）特性值+组件功率（W）描述
        sapProduct.Product_Code__c           = zcrm.MATNR.subString(10,18);//物料号
        sapProduct.Product_Description__c    = zcrm.MAKTX;//物料描述
        sapProduct.Product_Name__c           = zcrm.BISMT;//版型
        sapProduct.Special_required__c       = zcrm.ZS4A+'-'+zcrm.ZS4AT;//特殊信息特性值+特殊信息描述
        sapProduct.Type_of_module__c         = zcrm.ZS45+'-'+zcrm.ZS45T;//组件类型特性值+组件类型描述
        sapProduct.SAP_Last_Modified_By__c   = zcrm.AENAM;
        sapProduct.SAP_Last_Modified_Date__c = zcrm.LAEDA;
        sapProduct.CurrencyIsoCode           = 'USD';
    }
    
    // by using sap zcrm change to sap delete zcrm
    public static sapProductDelete.ZCRM_ZMADA_01 transformDeleteProduct(sapProduct.ZCRM_ZMADA zcrm){
        sapProductDelete.ZCRM_ZMADA_01 zcrm_delete = new sapProductDelete.ZCRM_ZMADA_01();
        
        zcrm_delete.ZS4B  = zcrm.ZS4B;
        zcrm_delete.ZS4BT = zcrm.ZS4BT;
        zcrm_delete.ZS41  = zcrm.ZS41;
        zcrm_delete.ZS41T = zcrm.ZS41T;
        zcrm_delete.ZS42  = zcrm.ZS42;
        zcrm_delete.ZS42T = zcrm.ZS42T;
        zcrm_delete.ZS43  = zcrm.ZS43;
        zcrm_delete.ZS43T = zcrm.ZS43T;
        zcrm_delete.ZS49  = zcrm.ZS49;
        zcrm_delete.ZS49T = zcrm.ZS49T;
        zcrm_delete.ZS47  = zcrm.ZS47;
        zcrm_delete.ZS47T = zcrm.ZS47T;
        zcrm_delete.ZS01  = zcrm.ZS01;
        zcrm_delete.ZS01T = zcrm.ZS01T;
        zcrm_delete.ZS48  = zcrm.ZS48;
        zcrm_delete.ZS48T = zcrm.ZS48T;
        zcrm_delete.ZS46  = zcrm.ZS46;
        zcrm_delete.ZS46T = zcrm.ZS46T;
        zcrm_delete.ZS44  = zcrm.ZS44;
        zcrm_delete.ZS44T = zcrm.ZS44T;
        zcrm_delete.MATNR = zcrm.MATNR;
        zcrm_delete.MAKTX = zcrm.MAKTX;
        zcrm_delete.BISMT = zcrm.BISMT;
        zcrm_delete.ZS4A  = zcrm.ZS4A;
        zcrm_delete.ZS4AT = zcrm.ZS4AT;
        zcrm_delete.ZS45  = zcrm.ZS45;
        zcrm_delete.ZS45T = zcrm.ZS45T;
        zcrm_delete.AENAM = zcrm.AENAM;
        zcrm_delete.LAEDA = zcrm.LAEDA;
        
        return zcrm_delete;
    }
    
    // by using insert sap products to generate crm products - 这里可能遗留一个问题，当CRM端发生Sap Product删除操作时，需要删除之前新增的CRM Product，未来如果该情况大量出现，可以做trigger自动控制
    public static void generateCrmProduct(List<SAP_Product__c> lst_insert_crm_sapProduct, Log__c log){
        
        List<Product2> productList     = new List<Product2>();
        List<PricebookEntry> entryList = new List<PricebookEntry>();
        List<PricebookEntry> standardentryList = new List<PricebookEntry>();
        Set<String> proname =new Set<String>();
        // full price book
        List<Pricebook2> bookList = [SELECT ID,Name,CurrencyIsoCode FROM Pricebook2 WHERE IsActive =: true AND Name != 'Standard Price Book'];
        
        // standard price book
        Pricebook2 standard_pb = [Select Id From Pricebook2 Where Name = 'Standard Price Book' limit 1];
        List<Product2> productList2     = [Select name From Product2 ];
        for(Product2 p:productList2){
            proname.add(p.name);
        }
        if(lst_insert_crm_sapProduct.size() > 0){
            for(SAP_Product__c sapProd : lst_insert_crm_sapProduct){
                if(sapProd.Product_Name__c != null && !proname.contains(sapProd.Product_Name__c)){
                    // create product
                    Product2 prod = new Product2();
                    prod.Name               = sapProd.Product_Name__c;
                    prod.Cell_Type__c       = sapProd.Model_Type__c.contains('P') ? 'Poly' : sapProd.Model_Type__c.contains('M') ? 'Mono' : 'N/A';
                    prod.IsActive           = true;
                    prod.SAP_Materiel_No__c = sapProd.Product_Code__c;
                    prod.Maximum_Power_at_STC_Pmax__c = integer.valueof(sapProd.Power_W__c.substring(0,3));
                    Prod.CurrencyIsoCode    = 'USD';
                    // add product2 element
                    productList.add(prod);
                    proname.add(sapProd.Product_Name__c);
                }
            }
            
            // insert products
            if(productList.size() > 0)insert productList;
            
            for(Product2 prod : productList){
                // create standard price
                PricebookEntry standard_entry1 = new PricebookEntry();
                standard_entry1.IsActive = true;
                standard_entry1.Pricebook2Id = standard_pb.Id;
                standard_entry1.Product2Id = prod.Id;
                standard_entry1.UseStandardPrice = false;
                standard_entry1.UnitPrice = 1;
                standard_entry1.CurrencyIsoCode = 'AUD';
                
                PricebookEntry standard_entry2 = new PricebookEntry();
                standard_entry2.IsActive = true;
                standard_entry2.Pricebook2Id = standard_pb.Id;
                standard_entry2.Product2Id = prod.Id;
                standard_entry2.UseStandardPrice = false;
                standard_entry2.UnitPrice = 1;
                standard_entry2.CurrencyIsoCode = 'CAD';
                
                PricebookEntry standard_entry3 = new PricebookEntry();
                standard_entry3.IsActive = true;
                standard_entry3.Pricebook2Id = standard_pb.Id;
                standard_entry3.Product2Id = prod.Id;
                standard_entry3.UseStandardPrice = false;
                standard_entry3.UnitPrice = 1;
                standard_entry3.CurrencyIsoCode = 'CNY';
                
                PricebookEntry standard_entry4 = new PricebookEntry();
                standard_entry4.IsActive = true;
                standard_entry4.Pricebook2Id = standard_pb.Id;
                standard_entry4.Product2Id = prod.Id;
                standard_entry4.UseStandardPrice = false;
                standard_entry4.UnitPrice = 1;
                standard_entry4.CurrencyIsoCode = 'EUR';
                
                PricebookEntry standard_entry5 = new PricebookEntry();
                standard_entry5.IsActive = true;
                standard_entry5.Pricebook2Id = standard_pb.Id;
                standard_entry5.Product2Id = prod.Id;
                standard_entry5.UseStandardPrice = false;
                standard_entry5.UnitPrice = 1;
                standard_entry5.CurrencyIsoCode = 'GBP';
                
                PricebookEntry standard_entry6 = new PricebookEntry();
                standard_entry6.IsActive = true;
                standard_entry6.Pricebook2Id = standard_pb.Id;
                standard_entry6.Product2Id = prod.Id;
                standard_entry6.UseStandardPrice = false;
                standard_entry6.UnitPrice = 1;
                standard_entry6.CurrencyIsoCode = 'JPY';
                
                PricebookEntry standard_entry7 = new PricebookEntry();
                standard_entry7.IsActive = true;
                standard_entry7.Pricebook2Id = standard_pb.Id;
                standard_entry7.Product2Id = prod.Id;
                standard_entry7.UseStandardPrice = false;
                standard_entry7.UnitPrice = 1;
                standard_entry7.CurrencyIsoCode = 'USD';
                
                PricebookEntry standard_entry8 = new PricebookEntry();
                standard_entry8.IsActive = true;
                standard_entry8.Pricebook2Id = standard_pb.Id;
                standard_entry8.Product2Id = prod.Id;
                standard_entry8.UseStandardPrice = false;
                standard_entry8.UnitPrice = 1;
                standard_entry8.CurrencyIsoCode = 'ZAR';
                
                PricebookEntry standard_entry9 = new PricebookEntry();
                standard_entry9.IsActive = true;
                standard_entry9.Pricebook2Id = standard_pb.Id;
                standard_entry9.Product2Id = prod.Id;
                standard_entry9.UseStandardPrice = false;
                standard_entry9.UnitPrice = 1;
                standard_entry9.CurrencyIsoCode = 'MYR';
                
                PricebookEntry standard_entry10 = new PricebookEntry();
                standard_entry10.IsActive = true;
                standard_entry10.Pricebook2Id = standard_pb.Id;
                standard_entry10.Product2Id = prod.Id;
                standard_entry10.UseStandardPrice = false;
                standard_entry10.UnitPrice = 1;
                standard_entry10.CurrencyIsoCode = 'INR';
                
                standardentryList.add(standard_entry1);
                standardentryList.add(standard_entry2);
                standardentryList.add(standard_entry3);
                standardentryList.add(standard_entry4);
                standardentryList.add(standard_entry5);
                standardentryList.add(standard_entry6);
                standardentryList.add(standard_entry7);
                standardentryList.add(standard_entry8);
                standardentryList.add(standard_entry9);
                standardentryList.add(standard_entry10);
                
                insert standardentryList;
                
                // create price book entry
                for(Pricebook2 pb : bookList){
                    PricebookEntry entry = new PricebookEntry();
                    entry.IsActive = true;
                    entry.Pricebook2Id = pb.Id;
                    entry.Product2Id = prod.Id;
                    entry.UseStandardPrice = false;
                    entry.UnitPrice = 1;
                    if(pb.Name.contains('AUD')){
                        system.debug('----pb1' + pb.Name);
                        entry.CurrencyIsoCode = 'AUD' ;
                    }
                    if(pb.Name.contains('USD')){
                        system.debug('----pb2' + pb.Name);
                        entry.CurrencyIsoCode = 'USD' ;
                    }
                    if(pb.Name.contains('JPY') ){
                        system.debug('----pb3' + pb.Name);
                        entry.CurrencyIsoCode = 'JPY' ;
                    }
                    if(pb.Name.contains('CAD') ){
                        system.debug('----pb4' + pb.Name);
                        entry.CurrencyIsoCode = 'CAD' ;
                    }
                    if(pb.Name.contains('CNY') ){
                        system.debug('----pb5' + pb.Name);
                        entry.CurrencyIsoCode = 'CNY' ;
                    }
                    if(pb.Name.contains('EUR')){
                        system.debug('----pb6' + pb.Name);
                        entry.CurrencyIsoCode = 'EUR' ;
                    }
                    if(pb.Name.contains('GBP')){
                        system.debug('----pb7' + pb.Name);
                        entry.CurrencyIsoCode = 'GBP' ;
                    }
                    if(pb.Name.contains('ZAR')){
                        system.debug('----pb8' + pb.Name);
                        entry.CurrencyIsoCode = 'ZAR' ;
                    }
                    if(pb.Name=='Malaysian Ringgit'){
                        system.debug('----pb8' + pb.Name);
                        entry.CurrencyIsoCode = 'MYR' ;
                    }
                    if(pb.Name=='INR'){
                        system.debug('----pb9' + pb.Name);
                        entry.CurrencyIsoCode = 'INR' ;
                    }
                    system.debug('@@--' + entry.CurrencyIsoCode);
                    // add price book entry element
                    entryList.add(entry);
                }
                log.SuccessIDs__c += 'insert crm product:' + prod.Id + ' / ';
            }
            
            system.debug('------entryList' + entryList);
            // insert pricebook entry
            if(entryList.size() > 0)insert entryList;
            
        }
    }
    
}