public with sharing class AddOppProductCtrl {
    public Integer nextTempid = 0;
    public Double dagui;
    public Double xiaogui;
    public Double unitW;
    public Double SmallC;
    public Double BigC;
    public String CountryAustralia {
        get{
            return JK_PicklistConstant.AUSTRALIA;
        }
        set;
    }
    
    /*
    * -------------------------------------------------------------------------------------
    *    Constructors
    * -------------------------------------------------------------------------------------
    */
    public AddOppProductCtrl() {}
    
    // Constructor for Extension to an Opportunity standardController
    public AddOppProductCtrl(ApexPages.standardController std) {
        opp = (Opportunity)std.getRecord();
        loadOpportunity(opp.id);
        loadProducts();
        pullProducts();
        loadCatalog();
        
        idToDelete = null;
        
        if ( opp.pricebook2id == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                                                       'You must choose a pricebook before adding products.'
                                                      ));
        }
    }
    
    /*-------------------------------------------------------------------------------------
    * currentProducts and catalog
    *
    * These two main lists drive the two pageBlockTables
    *
    * -------------------------------------------------------------------------------------
    */
    
    public List<currentProductsItem> currentProducts { get; set; }
    public List<pricebookentryTableItem> catalog { get; set; }
    public List<pricebookentryTableItem> catalog2 { 
        get {
            loadCatalog();
            return this.catalog;
        }
        set; 
    }
    
    /*
    *    Variable to hold the opportunity
    */
    public Opportunity opp { get; set; }
    
    
    /*
    * -------------------------------------------------------------------------------------
    *    Methods to initialize the opportunity record and the lists
    * -------------------------------------------------------------------------------------
    */
    
    
    public void loadOpportunity(ID OpportunityID) {
        String [] accessFields = new String [] {'Id',
                                                'Name',
                                                'pricebook2id',
                                                'amount'
                                                };
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Opportunity.fields.getMap();
        for (String fieldToCheck : accessFields) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                           'Insufficient access')); 
                return;
            }
        }
        opp = [ Select Id, Name, pricebook2id, pricebook2.Name,Trade_Term__c,Destination_Port__c,Number_of_Containers__c,
               amount,Region__c,RecordType.Name,RecordTypeId,Sales_Region__c,Destination_Country__c,Test_code_Australia__c ,Ocean_Freight__c,
               Number_of_Small_Containers__c,
               Owner.Region__c, CurrencyIsoCode
               From Opportunity
               Where id = :OpportunityID
              ];
    }
    
    public  void loadCatalog() {
        try{
            catalog = new List<pricebookentryTableItem>();
            
            String [] accessFields = new String [] {'Id',
                'Name',
                'pricebook2id',
                'product2id',
                'unitprice'
                };
            Map<String,Schema.SObjectField> m = Schema.SObjectType.pricebookentry.fields.getMap();
            for (String fieldToCheck : accessFields) {
                if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                               'Insufficient access')); 
                    return;
                }
            }
            String testid='%'+opp.Id+'%';
            
            if (opp.RecordType.Name == 'USA') {
                for (Pricebookentry p : 
                     [ Select id, 
                      Name, 
                      pricebook2id, 
                      product2id,
                      Product2.Name, 
                      unitprice,
                      productcode, 
                      CurrencyIsoCode,
                      IsActive,
                      product2.Description,
                      product2.Non_Modul__c,
                      product2.Family, 
                      product2.Cable_Length__c,
                      product2.Maximum_Power_at_STC_Pmax__c,
                      Product2.Maximum_Power_at_Current_Imp_A__c ,
                      Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                      product2.IsActive,
                      product2.Product_Module_PM__c,
                      product2.Frame_Color_Cost_Black__c,
                      product2.Frame_Color_Cost_Silver__c,
                      product2.Back_Sheet_Color_Cost_Black_B__c,
                      product2.Back_sheet_Color_Cost_Black_W__c,
                      Product2.CreatedDate,
                      Product2.SAP_Materiel_No__c,
                      product2.Applicable_Area__c,
                      Product2.Cell_Type__c
                      from pricebookentry
                      where isactive = true and isdeleted = false
                      and product2.IsActive = true
                      and pricebook2id = :opp.pricebook2id                 
                      and CurrencyIsoCode = : opp.CurrencyIsoCode
                      and product2.Applicable_Area__c =: 'USA' 
                      and product2.ApplicationProductOppId__c = :''
                      //and Product2.RecordType.Name = 'Watt-based'
                      //order by product2.Maximum_Power_at_STC_Pmax__c desc
                     ] ) {                  
                         catalog.add(new pricebookentryTableItem(p));    
                     }
                     system.debug('======>>:' + catalog.size());
                for (Pricebookentry p : 
                     [ Select id, 
                      Name, 
                      pricebook2id, 
                      product2id,
                      Product2.Name, 
                      unitprice,
                      productcode, 
                      CurrencyIsoCode,
                      IsActive,
                      product2.Description,
                      product2.Non_Modul__c,
                      product2.Family, 
                      product2.Cable_Length__c,
                      product2.Maximum_Power_at_STC_Pmax__c,
                      Product2.Maximum_Power_at_Current_Imp_A__c ,
                      Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                      product2.IsActive,
                      product2.Product_Module_PM__c,
                      product2.Frame_Color_Cost_Black__c,
                      product2.Frame_Color_Cost_Silver__c,
                      product2.Back_Sheet_Color_Cost_Black_B__c,
                      product2.Back_sheet_Color_Cost_Black_W__c,
                      Product2.CreatedDate,
                      Product2.SAP_Materiel_No__c,
                      product2.Applicable_Area__c,
                      Product2.Cell_Type__c
                      from pricebookentry
                      where isactive = true and isdeleted = false
                      and product2.IsActive = true
                      and pricebook2id = :opp.pricebook2id                 
                      and CurrencyIsoCode = : opp.CurrencyIsoCode
                      and product2.Applicable_Area__c =: 'USA' 
                      and product2.ApplicationProductOppId__c = :opp.id
                      //and Product2.RecordType.Name = 'Watt-based'
                      //order by product2.Maximum_Power_at_STC_Pmax__c desc
                     ] ) {
                        catalog.add(new pricebookentryTableItem(p));
                    }
                     
                    system.debug('======>>:' + catalog.size());
            }else if(opp.RecordType.Name == 'Energy Storage System'){
                for (Pricebookentry p : [ Select id, 
                                                Name, 
                                                pricebook2id, 
                                                product2id, 
                                                unitprice,
                                                productcode,
                                                Product2.Name, 
                                                CurrencyIsoCode,
                                                IsActive,
                                                product2.Description,
                                                product2.Non_Modul__c,
                                                product2.Family, 
                                                product2.Cable_Length__c,
                                                product2.Maximum_Power_at_STC_Pmax__c,
                                                Product2.Maximum_Power_at_Current_Imp_A__c ,
                                                Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                                                product2.IsActive,
                                                product2.Product_Module_PM__c,
                                                product2.Frame_Color_Cost_Black__c,
                                                product2.Frame_Color_Cost_Silver__c,
                                                product2.Back_Sheet_Color_Cost_Black_B__c,
                                                product2.Back_sheet_Color_Cost_Black_W__c,
                                                Product2.CreatedDate,
                                                Product2.SAP_Materiel_No__c,
                                                product2.Applicable_Area__c,
                                                Product2.Cell_Type__c,
                                                Product2.Energy_Storage__c
                                            from pricebookentry
                                            where isactive = true and isdeleted = false
                                            and product2.IsActive = true
                                            and pricebook2id = :opp.pricebook2id                 
                                            and CurrencyIsoCode = : opp.CurrencyIsoCode
                                            and Product2.Energy_Storage__c =true
                                            and product2.ApplicationProductOppId__c = :''
                     ] ) {
                         
                         
                    catalog.add(new pricebookentryTableItem(p));
                }
                for (Pricebookentry p : [ Select id, 
                                                Name, 
                                                pricebook2id, 
                                                product2id, 
                                                unitprice,
                                                productcode,
                                                Product2.Name, 
                                                CurrencyIsoCode,
                                                IsActive,
                                                product2.Description,
                                                product2.Non_Modul__c,
                                                product2.Family, 
                                                product2.Cable_Length__c,
                                                product2.Maximum_Power_at_STC_Pmax__c,
                                                Product2.Maximum_Power_at_Current_Imp_A__c ,
                                                Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                                                product2.IsActive,
                                                product2.Product_Module_PM__c,
                                                product2.Frame_Color_Cost_Black__c,
                                                product2.Frame_Color_Cost_Silver__c,
                                                product2.Back_Sheet_Color_Cost_Black_B__c,
                                                product2.Back_sheet_Color_Cost_Black_W__c,
                                                Product2.CreatedDate,
                                                Product2.SAP_Materiel_No__c,
                                                product2.Applicable_Area__c,
                                                Product2.Cell_Type__c,
                                                Product2.Energy_Storage__c
                                                from pricebookentry
                                                where isactive = true and isdeleted = false
                                                and product2.IsActive = true
                                                and pricebook2id = :opp.pricebook2id                 
                                                and CurrencyIsoCode = : opp.CurrencyIsoCode
                                                and Product2.Energy_Storage__c =true
                                                and product2.ApplicationProductOppId__c like: testid
                                                ] ) {
                    catalog.add(new pricebookentryTableItem(p));
                }
                system.debug('======>>:' + catalog.size());       
            }else{
                for (Pricebookentry p : 
                     [ Select id, 
                      Name, 
                      pricebook2id, 
                      product2id, 
                      unitprice,
                      productcode,
                      Product2.Name, 
                      CurrencyIsoCode,
                      IsActive,
                      product2.Description,
                      product2.Non_Modul__c,
                      product2.Family, 
                      product2.Cable_Length__c,
                      product2.Maximum_Power_at_STC_Pmax__c,
                      Product2.Maximum_Power_at_Current_Imp_A__c ,
                      Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                      product2.IsActive,
                      product2.Product_Module_PM__c,
                      product2.Frame_Color_Cost_Black__c,
                      product2.Frame_Color_Cost_Silver__c,
                      product2.Back_Sheet_Color_Cost_Black_B__c,
                      product2.Back_sheet_Color_Cost_Black_W__c,
                      Product2.CreatedDate,
                      Product2.SAP_Materiel_No__c,
                      product2.Applicable_Area__c,
                      Product2.Cell_Type__c
                      from pricebookentry
                      where isactive = true and isdeleted = false
                      and product2.IsActive = true
                      and pricebook2id = :opp.pricebook2id
                      and Product2.Energy_Storage__c =false
                      and CurrencyIsoCode = : opp.CurrencyIsoCode
                      and product2.ApplicationProductOppId__c = :''
                     ] ) {
                         
                         
                        catalog.add(new pricebookentryTableItem(p));
                        for(pricebookentryTableItem c : catalog){
                            system.debug(c);
                        }
                    }
                    system.debug('======>>:' + catalog.size());
                for (Pricebookentry p : 
                     [ Select id, 
                      Name, 
                      pricebook2id, 
                      product2id, 
                      unitprice,
                      productcode,
                      Product2.Name, 
                      CurrencyIsoCode,
                      IsActive,
                      product2.Description,
                      product2.Non_Modul__c,
                      product2.Family, 
                      product2.Cable_Length__c,
                      product2.Maximum_Power_at_STC_Pmax__c,
                      Product2.Maximum_Power_at_Current_Imp_A__c ,
                      Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                      product2.IsActive,
                      product2.Product_Module_PM__c,
                      product2.Frame_Color_Cost_Black__c,
                      product2.Frame_Color_Cost_Silver__c,
                      product2.Back_Sheet_Color_Cost_Black_B__c,
                      product2.Back_sheet_Color_Cost_Black_W__c,
                      Product2.CreatedDate,
                      Product2.SAP_Materiel_No__c,
                      product2.Applicable_Area__c,
                      Product2.Cell_Type__c
                      from pricebookentry
                      where isactive = true and isdeleted = false
                      and product2.IsActive = true
                      and Product2.Energy_Storage__c =false
                      and pricebook2id = :opp.pricebook2id                 
                      and CurrencyIsoCode = : opp.CurrencyIsoCode
                      and product2.ApplicationProductOppId__c like: testid
                     ] ) {
                    catalog.add(new pricebookentryTableItem(p));
                }
                system.debug('======>>:' + catalog.size());
            }
            
        }
        catch(Exception ex){
            system.debug('---------------------------loadCatalog');
            //ApexPages.addMessage(ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            //system.debug(ex.getMessage());
            //system.debug(ex.getStackTraceString());
            
        }
    }
    public void loadProducts() {
        
        
        String [] accessFields = new String [] {'Id',
                                                'ServiceDate',
                                                'UnitPrice',
                                                'ListPrice',
                                                'TotalPrice',
                                                'Quantity'
                                                };
        Map<String,Schema.SObjectField> m = Schema.SObjectType.OpportunityLineItem.fields.getMap();
        for (String fieldToCheck : accessFields) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                           '333333333333333Insufficient access')); 
                return;
            }
        }
        
        currentProducts = new List<currentProductsItem>();  
        for ( OpportunityLineItem oli : 
             [ Select id, 
              Product_Type__c,
              PricebookEntry.Name, 
              PricebookEntry.Product2.Cable_Length__c, 
              PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c, 
              PricebookEntry.Product2.Maximum_Power_at_Current_Imp_A__c,
              PricebookEntry.Product2.IsActive,
              PricebookEntry.ProductCode,  
              PricebookEntry.Product2.Frame_Color_Cost_Black__c,
              PricebookEntry.Product2.Frame_Color_Cost_Silver__c,
              PricebookEntry.Product2.Back_Sheet_Color_Cost_Black_B__c,
              PricebookEntry.Product2.Back_sheet_Color_Cost_Black_W__c,
              ServiceDate, 
              UnitPrice, 
              ListPrice, 
              TotalPrice__c,  
              TotalPrice,
              Quantity,
              MP__c,
              Battery_Type__c,         
              Wire_Length__c,
              Connector__c, 
              Type_of_module__c, 
              Color_of_Module__c, 
              Special_required__c, 
              Number_of_Cells__c,
              Weight__c,
              Cable_length_UK__c,
              Dimensions__c,
              Bus_bars_of_cell__c,
              Guaranteed_Delivery_Date__c , 
              Guaranteed_Delivery_Date_japan__c,
              Expected_Delivery_Date__c,
              Expected_Delivery_Date_ETA__c,
              Estimated_Time_of_Departure_ETD__c,
              Estimated_Time_of_Departure_ETD_7__c,
              Special_Lable__c,
              Certification__c, 
              Estimated_Time_of_Departure__c, 
              EVA__c, 
              FOB_Sales_Price__c,
              Power_W__c, 
              Total_MW__c, 
              Cell_Appearance__c,
              Grade__c,               
              Junction_Box__c, 
              Discount,
              Frame_B_side_Height__c,
              Tolerance__c,
              Inventorytype__c,
              Stock_age__c,
              Module_size__c,
              Cheetah__c,
              Test_code__c ,
              Opp_Description__c,
              Goods_Description__c,
              Back_Sheet_Color__c,
              Frame_Color__c,
              Product2.Product_Module_PM__c
              From OpportunityLineItem
              Where Opportunityid = :opp.id
              //and pricebook2id = : opp.pricebook2id
              //Order by PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c desc
             ]) {
                nextTempid++; 
                currentProducts.add(new currentProductsItem(oli,oli.TotalPrice__c,nextTempid));
                system.debug('nextTempid***' + nextTempid);
                 
             }
        
        system.debug('currentProductsLOAD**' + currentProducts);  
    }
    
    
    public List<OpportunityLineItem> pullProducts() {
        List<OpportunityLineItem> out = new List<OpportunityLineItem>();
        List<currentProductsItem> newEntries = new List<currentProductsItem>();
        
        for (currentProductsItem x : currentProducts) {
            OpportunityLineItem objOpportunityItem = x.data;
            // 2021/3/25 Samba Start
            Boolean hasABWithPM = false;
            if(objOpportunityItem.Product2.Product_Module_PM__c != null && objOpportunityItem.Product2.Product_Module_PM__c.contains('AB')) {
                hasABWithPM = true;
            }
            x.hasABWithPM = hasABWithPM;
            if(objOpportunityItem == null) continue;
            if(x.isOneLineContainer  && x.RequestedContainers > 1) {          
                out.add(objOpportunityItem);
                if (objOpportunityItem.id != null ) {
                    pendingDeletes.add(new OpportunityLineItem(ID = objOpportunityItem.id ));                   
                }  
            } else { 
                system.debug('x***x*' + x);
                newEntries.add(x);
                out.add(objOpportunityItem);
            }    
        }
        system.debug('currentProducts**' + currentProducts);  
        currentProducts.clear();
        currentProducts.addAll(newEntries);
        Double BigContain = 0;
        Double SmallContain = 0;
        Double Quan = 0;
        Double bic = 0;
        Double totalW = 0;
        Map<String,Port_freight_maintenance__c> getPortNameMap = new Map<String,Port_freight_maintenance__c>();
        for (Port_freight_maintenance__c port : [SELECT Name, 
                                                            Warehouse_Premium__c,
                                                            Warehouse_Premium_Small__c,
                                                            Type__c,
                                                            Land_Freight_Oversea__c
                                                     FROM Port_freight_maintenance__c where Type__c=:'port']) {
                                                         if (port.Type__c == 'port') getPortNameMap.put(port.Name, port);}
        if(opp.Destination_Port__c!=null){
            Port_freight_maintenance__c port = getPortNameMap.get(opp.Destination_Port__c);
            SYSTEM.debug('PORT'+port);
            List<Product_Container__c> oc = [Select id,X20_foot_flat_cabinet__c,X40_foot_flat_cabinet__c,Short_Name__c,Germany_Short_Name__c from Product_Container__c];
            Map<String,Product_Container__c> pcList = new Map<String,Product_Container__c>();
            system.debug('oc'+oc);
            for(Product_Container__c o :oc){
                pcList.put(o.Short_Name__c,o);
                if(o.Germany_Short_Name__c !=null){
                    pcList.put(o.Germany_Short_Name__c,o);
                }
                
            }
            Set<String> pcKey = pcList.keySet();
            if(out.size()>0&&out!=null){
                system.debug('opp'+opp.Trade_Term__c);
                if(opp.Trade_Term__c!=null && (opp.Trade_Term__c.startswith('C')||opp.Trade_Term__c.startswith('D'))){
                    system.debug('111'+out.size());
                    for(OpportunityLineItem o:out){
                        system.debug('out'+o);
                        Boolean flags = true;
                        for(String p:pcKey){ 
                            system.debug('out'+o);
                            if((o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endswith(p)) || (o.PricebookEntry.name.Startswith('MM')&&o.PricebookEntry.name.endswith(p))){
                                system.debug(p);
                                flags = false;
                                Quan += o.Quantity;
                                Product_Container__c pcs =  pcList.get(p);
                                system.debug('pcs'+pcs);
                                BigContain += pcs.X40_foot_flat_cabinet__c;
                                SmallContain += pcs.X20_foot_flat_cabinet__c;
                                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
                                
                            }
                        }
                        if(flags == true){
                            BigContain = -1;
                            SmallContain = -1;
                            xiaogui = 0;
                            dagui = 0;
                            SmallC = 0;
                            BigC = 0;
                            unitW = 0;
                            //totalW =0;
                            system.debug('1');
                            break;
                        }
                    }
                }else{
                    BigContain = -1;
                    SmallContain = -1;
                    xiaogui = 0;
                    dagui = 0;
                    SmallC = 0;
                    BigC = 0;
                    unitW = 0;
                }
                system.debug('BigContain'+BigContain);
                system.debug('SmallContain'+SmallContain);
                if(out.size()!=0&&(BigContain!=-1&&BigContain!=0&&SmallContain!=0)){
                    if(opp.Region__c =='North America'||(port!=null&&port.Warehouse_Premium_Small__c==null)){
                        BigC = BigContain/out.size();//大柜平均数
                        Double BigCons = Quan/BigC;//大柜柜数
                        dagui = Math.ceil(BigCons);
                        xiaogui = 0;
                    }else{
                        system.debug('1');
                        SmallC = SmallContain/out.size();//小柜平均数
                        BigC = BigContain/out.size();//大柜平均数
                        Double BigCons = Quan/BigC;//大柜柜数
                        dagui = Math.floor(BigCons); //大柜柜数整数
                        system.debug('SmallC'+SmallC);
                        system.debug('BigC'+BigC);
                        system.debug('BigCons'+BigCons);
                        system.debug('dagui'+dagui);
                        //小柜柜数
                        if(BigCons>=1){
                            system.debug('Quan'+Quan);
                            system.debug('dagui'+(dagui*BigC));
                            system.debug('SmallC'+SmallC);
                            System.debug('(Quan-(dagui*BigC))/SmallC'+((Quan-(dagui*BigC))/SmallC));
                            xiaogui = Math.ceil((Quan-(dagui*BigC))/SmallC);
                        }
                        if(BigCons<1){
                            Double SmallCons = Quan/SmallC;//柜数
                            xiaogui = Math.ceil(SmallCons);
                        }
                    }
                }
                system.debug('xiaogui'+xiaogui);
                Double daguichengben = 0;
                if(port!=null&&port.Warehouse_Premium__c!=null){
                    daguichengben = port.Warehouse_Premium__c*dagui;//总成本
                }
                //system.debug('daguichengben'+daguichengben);
                //system.debug('port.Warehouse_Premium_Small__c'+port.Warehouse_Premium_Small__c);
                system.debug(xiaogui);
                Double xiaoguichengben = 0;
                if(port!=null&&port.Warehouse_Premium_Small__c!=null){
                    xiaoguichengben = port.Warehouse_Premium_Small__c*xiaogui;//小柜成本
                }
                system.debug('xiaoguichengben'+xiaoguichengben);
                if(totalW!=0&&totalW!=null){
                    unitW = (daguichengben+xiaoguichengben)/totalW;
                }
                system.debug('unitW'+unitW);
            }
        }
        
        return out;
    }
    
    /*
* -------------------------------------------------------------------------------------
*    A few methods to sort the catalog
*    These are tied to action methods on the VF page
* -------------------------------------------------------------------------------------
*/
    
    public String sortField  { get; set; }
    
    public void sortCatalog() {
        catalog = sortProductList(catalog, sortField);
        
    }
    public List<pricebookentryTableItem> sortProductList(List<pricebookentryTableItem> inList, String sortField) {
        if ( inList.size() == 0 || inList.size() == 1) { 
            return inList;
        }
        Map<String,List<pricebookentryTableItem>> tmpMap = new Map<String,List<pricebookentryTableItem>>();
        
        Set<String> keys = new Set<String>();
        
        for ( pricebookentryTableItem p : inList) {
            String sortValue = '';
            Decimal sortValueNum = 0;
            if ( sortField == 'Name')               {  sortValue    = p.data.Name; }
            if ( sortField == 'Productcode')        {  sortValue    = p.data.Productcode; }
            if ( sortField == 'Family')             {  sortValue    = p.data.Product2.Family; }
            if ( sortField == 'Cable_Length__c')    {  sortValue    = p.data.Product2.Cable_Length__c; }
            if ( sortField == 'Maximum_Power_at_STC_Pmax__c') {  sortValueNum = p.data.Product2.Maximum_Power_at_STC_Pmax__c; }
            if ( sortField == 'unitPrice')          {  sortValueNum = p.data.unitPrice; }
            
            if ( sortValue == '' && sortValueNum > 0 ) {
                if ( sortValueNum < 100 ) {
                    sortValue += '0';
                }
                if ( sortValueNum < 10 ) {
                    sortValue += '0';
                }
                sortValue += sortValueNum.format();
            }
            keys.add(sortValue);
            List<pricebookentryTableItem> tmpList;
            if ( tmpMap.containsKey(sortValue)) {
                tmpList = tmpMap.get(sortValue);
            }
            else {
                tmpList = new List<pricebookentryTableItem>();
            }
            tmpList.add(p);
            tmpMap.put(sortValue,tmpList);
        }
        
        List<String> listKeys = new List<String>();
        for ( String k : keys) { listKeys.add(k); }
        listKeys.sort();
        
        List<pricebookentryTableItem> outList = new List<pricebookentryTableItem>();
        
        for ( String k : listKeys ) {
            for ( pricebookentryTableItem p : tmpMap.get(k) ) {
                outList.add(p);
            }
        }
        return outList;
    }    
    
    public String getProductNamesSpaceDelimited() {
        String result = '';
        for ( pricebookentryTableItem item : catalog ) {
            result += item.data.name + ';';
        }
        return result;
    }
    
    /*
* -------------------------------------------------------------------------------------
*    Cancel Method
*     NOTE:  QuickSaved records are saved.  Cancel does not affect those records.
* -------------------------------------------------------------------------------------
*/
    public PageReference Cancel() {
        PageReference r = new PageReference('/' + opp.id);
        return r;
    }
    
    /*
* -------------------------------------------------------------------------------------
*    Save Methods
* -------------------------------------------------------------------------------------
*/
    
    // Not used
    
    public void Save() {
        SaveChanges();
    }
    
    // Quick Save
    
    public void SaveChanges() {
        if ( ActuallySave()) {
            loadProducts();
            loadOpportunity(opp.id);
        }
        return;
    }
    
    // Save
    
    public PageReference SaveAndReturn() {
        if ( ActuallySave() ) {
          /*  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'Mr.Wang'};
            String[] ccAddresses = new String[] {'ww13664190234@163.com'};
            email.setToAddresses(toAddresses); //邮箱用户名
            email.setCcAddresses(ccAddresses); //邮箱地址
            email.setSubject('show count'); //邮件头
            email.setHtmlBody('query Count');//邮件内容
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });*/

            PageReference r = new PageReference('/' + opp.id);
            return r;
        }
        else {
            return null;
        }
    }
    
    /*
* This is the method that does the actual saving
* Returns TRUE for success
*         FALSE for failure
*/
    
    public Boolean ActuallySave() {
        // See if the user changed any Panels, Pallets, or Containers
        // Should this be done in Javascript?
        try {
            for ( currentProductsItem x : currentProducts) {
                x.clearErrors();
            }
            
            if (!OpportunityLineItem.sObjectType.getDescribe().isUpdateable()){
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR,'you can not update product line item.'));
                return false;
            }
           
                       
        
         
            List<OpportunityLineItem> newupsert=    pullProducts();
            // 2021/3/25 Samba Start
            OpportunityLineItemGrossMarginHandler handler = new OpportunityLineItemGrossMarginHandler();
            Double rate = handler.getCodeRateMap().containsKey(opp.CurrencyIsoCode) ? handler.getCodeRateMap().get(opp.CurrencyIsoCode) : 1;

            for(OpportunityLineItem oppItem : newupsert) {
                if(oppItem.Back_Sheet_Color__c == 'Black & Black') {
                      oppItem.Back_Sheet_Color_Additional_Cost_Per_W__c = (oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != null && oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != 0 && oppItem.PricebookEntry.Product2.Back_Sheet_Color_Cost_Black_B__c != null) ? oppItem.PricebookEntry.Product2.Back_Sheet_Color_Cost_Black_B__c / oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c : oppItem.PricebookEntry.Product2.Back_Sheet_Color_Cost_Black_B__c;
                  } else if(oppItem.Back_Sheet_Color__c == 'Black & White') {
                      oppItem.Back_Sheet_Color_Additional_Cost_Per_W__c = (oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != null && oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != 0 && oppItem.PricebookEntry.Product2.Back_sheet_Color_Cost_Black_W__c != null) ? oppItem.PricebookEntry.Product2.Back_sheet_Color_Cost_Black_W__c / oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c : oppItem.PricebookEntry.Product2.Back_sheet_Color_Cost_Black_W__c;
                  }
                  oppItem.Back_Sheet_Color_Additional_Cost_Per_W__c = oppItem.Back_Sheet_Color_Additional_Cost_Per_W__c == null ? 0 : oppItem.Back_Sheet_Color_Additional_Cost_Per_W__c * rate;
                  
                  if(oppItem.Frame_Color__c == 'Black') {
                    oppItem.Frame_Color_Additional_Cost_Per_W__c = (oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != null && oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != 0 && oppItem.PricebookEntry.Product2.Frame_Color_Cost_Black__c != null) ? oppItem.PricebookEntry.Product2.Frame_Color_Cost_Black__c / oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c : oppItem.PricebookEntry.Product2.Frame_Color_Cost_Black__c;
                  } else if(oppItem.Frame_Color__c == 'Silver') {
                    oppItem.Frame_Color_Additional_Cost_Per_W__c = (oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != null && oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c != 0 && oppItem.PricebookEntry.Product2.Frame_Color_Cost_Silver__c != null) ? oppItem.PricebookEntry.Product2.Frame_Color_Cost_Silver__c / oppItem.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c : oppItem.PricebookEntry.Product2.Frame_Color_Cost_Silver__c;
                  }
                  oppItem.Frame_Color_Additional_Cost_Per_W__c = oppItem.Frame_Color_Additional_Cost_Per_W__c == null ? 0 : oppItem.Frame_Color_Additional_Cost_Per_W__c * rate;
            }
            // End
            opp.Number_of_Containers__c = dagui;
            opp.Number_of_Small_Containers__c = xiaogui;
            system.debug('20201218:'+opp.Ocean_Freight__c);
            system.debug('20201218:'+OpportunityLineItemGrossMarginHandler.oceanNeedChangeIds);
            if(opp.Ocean_Freight__c==0 || opp.Ocean_Freight__c ==null || OpportunityLineItemGrossMarginHandler.oceanNeedChangeIds.contains(opp.Id)){
                if(opp.Region__c != 'Middle East&Africa' && opp.Region__c != 'MENA' && opp.Region__c != 'SSA'){
                    opp.Ocean_Freight__c = unitW;
                }
            }
            opp.Average_capacity_of_Containers__c = String.valueOf(SmallC)+';'+String.valueOf(BigC);
            OpportunityLineItemGrossMarginHandler.AverageY=opp.Average_capacity_of_Containers__c;
            OpportunityLineItemGrossMarginHandler.xiaoguiY= opp.Number_of_Small_Containers__c;
            OpportunityLineItemGrossMarginHandler.daguiY=opp.Number_of_Containers__c;
            OpportunityLineItemGrossMarginHandler.outY=newupsert;
            upsert newupsert;
            update opp;
           
       
             
            
           
              
            system.debug('dagui'+dagui);
            system.debug('dagui'+xiaogui);
            system.debug('dagui'+unitW);
            system.debug('dagui'+SmallC);
            system.debug('dagui'+BigC);
            
            List<contract> conLst =[select id from contract where Opportunity__c =:opp.id];
            if(conLst.size()>0){
                
                
            }
            // Now do any pending deletes
            if ( pendingDeletes.size() >0 ) {
                if (!OpportunityLineItem.sObjectType.getDescribe().isDeletable()){
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,'you can not delete product line item.'));
                    return false;
                }
                /*     if(opp.Region__c= 'Middle East&Africa'&& (data.Quantity /24!=0 || data.Quantity / 22 !=0))
{
ApexPages.addMessage(new ApexPages.Message(
ApexPages.Severity.ERROR,'Not Special Packaging Requirement'));
return false;
} */
                delete pendingDeletes;
                pendingDeletes.clear();
            }
            
            
        }
        catch (DMLException dmlex ) {
            for ( Integer i = 0; i < dmlex.getNumDml(); i++) {
                
                String errorMsg = dmlex.getDmlMessage(i);
                Integer rowError = dmlex.getDmlIndex(i);
                system.debug('rowError ***'+ rowError ); 
                currentProducts[rowError].RecordErrorMsg = errorMsg;
                
                for ( String fld : dmlex.getDmlFieldNames(i) ) {
                    
                    if ( fld == 'UnitPrice') {
                        currentProducts[rowError].UnitPriceErrorMsg = 'Must be greater than zero';
                    }
                    if ( fld == 'Quantity') {
                        currentProducts[rowError].QuantityErrorMsg = 'Must be greater than zero';
                    }
                }
            }
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,'Some records have errors.  Please correct the errors.'));
            return false;
            
        }
        catch (Exception ex ) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,'Errors!!'));
            return false;
        }
        
        return true;
        
    }
    
    /*
* -------------------------------------------------------------------------------------
*    AddProducts methods
* -------------------------------------------------------------------------------------
*/
    
    public void AddProducts() {
        
        
        // Added By Leo 2018 05 16. 为美国区设定默认产品值
        /* String [] prodname =new String []{'JKM360M-72-V','JKM365M-72-V','JKM370M-72-V','JKM375M-72-V','JKM380M-72-V',
'JKM385M-72-V','JKM390M-72-V','JKM395M-72-V','JKM400M-72-V','JKM320PP-72-V',
'JKM325PP-72-V','JKM330PP-72-V','JKM335PP-72-V','JKM290M-60B','JKM295M-60B',
'JKM300M-60B','JKM300M-60','JKM305M-60','JKM310M-60','JKM315M-60','JKM370M-72H-V',
'JKM375M-72H-V','JKM380M-72H-V','JKM385M-72H-V','JKM390M-72H-V','JKM395M-72H-V',
'JKM400M-72H-V','JKM405M-72H-V'}; */
        List<OpportunityLineItem> list_Oppline = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> map_proname =new  Map<String,OpportunityLineItem>();
        list_Oppline=[Select Id,Product2Id,MP__c,
                      Product_Type__c,
                      Battery_Type__c,         
                      Wire_Length__c,
                      Connector__c, 
                      Type_of_module__c, 
                      Color_of_Module__c,
                      Grade__c,
                      Special_required__c, 
                      Bus_bars_of_cell__c,
                      Special_Lable__c,
                      Certification__c,
                      Test_code__c,
                      Opp_Description__c,
                      Product2.Name From OpportunityLineItem where  Opportunityid =:'0066F00000rqinlQAA'];
        //沙盒Oppty: 0060l000003xdg6AAA    Prod Oppty: 0066F00000rqinlQAA
        system.debug('********list_Oppline*******'+list_Oppline);
        if(list_Oppline.size()>0){
            for(OpportunityLineItem oil1 :list_Oppline)
            {
                map_proname.put(oil1.Product2.Name, oil1);
            }
            system.debug('________*map_proname******'+map_proname);
        }
        
        for (pricebookentryTableItem entry : catalog ) { 
            if ( entry.isSelected ) {
                OpportunityLineItem newOLI = new OpportunityLineItem(
                    OpportunityId     = opp.id,
                    PricebookEntryId  = entry.data.id,
                    quantity          = 0,
                    UnitPrice         = entry.data.unitprice  // -- Need to compute discount rules first
                    
                );
                system.debug('************entry.data.Product2.Name********'+entry.data.Product2.Name);
                newOLI.PriceBookEntry = entry.data;
                if(opp.RecordType.Name =='USA' && map_proname !=null && map_proname.get(entry.data.Product2.Name) !=null){
                    newOLI.MP__c = map_proname.get(entry.data.Product2.Name).MP__c;
                    newOLI.Battery_Type__c =map_proname.get(entry.data.Product2.Name).Battery_Type__c;         
                    newOLI.Wire_Length__c =map_proname.get(entry.data.Product2.Name).Wire_Length__c;
                    newOLI.Connector__c =map_proname.get(entry.data.Product2.Name).Connector__c; 
                    newOLI.Type_of_module__c =map_proname.get(entry.data.Product2.Name).Type_of_module__c; 
                    newOLI.Color_of_Module__c =map_proname.get(entry.data.Product2.Name).Color_of_Module__c; 
                    newOLI.Special_required__c =map_proname.get(entry.data.Product2.Name).Special_required__c; 
                    newOLI.Bus_bars_of_cell__c =map_proname.get(entry.data.Product2.Name).Bus_bars_of_cell__c;
                    //  newOLI.Guaranteed_Delivery_Date__c ; 
                    // newOLI.Guaranteed_Delivery_Date_japan__c;
                    // newOLI.Expected_Delivery_Date__c;
                    // newOLI.Expected_Delivery_Date_ETA__c;
                    //  newOLI.Estimated_Time_of_Departure_ETD__c;
                    //  newOLI.Estimated_Time_of_Departure_ETD_7__c;
                    newOLI.Special_Lable__c =map_proname.get(entry.data.Product2.Name).Special_Lable__c;
                    newOLI.Certification__c =map_proname.get(entry.data.Product2.Name).Certification__c;
                    //  newOLI.Estimated_Time_of_Departure__c,;
                    // newOLI.EVA__c; 
                    // newOLI.Power_W__c; 
                    // newOLI.Total_MW__c; 
                    // newOLI.Cell_Appearance__c;
                    newOLI.Grade__c =map_proname.get(entry.data.Product2.Name).Grade__c;               
                    // newOLI.Junction_Box__c; 
                    // newOLI.Discount__c;
                    // newOLI.Tolerance__c;
                    // newOLI.Module_size__c
                }
                //newOLI.Recommended_Discount__c = 0;// DiscountEngine.getRecommendedDiscount(newOLI, opp.id,  entry.data.product2id );
                newOLI.UnitPrice = entry.data.unitprice ;//* ( 100 - newOLI.Recommended_Discount__c )/100.0;
                IF(entry.data.product2.Non_Modul__c==true){
                    
                    newOLI.MP__c ='Poly';
                    newOLI.Battery_Type__c ='/';
                    newOLI.Wire_Length__c ='1000mm';
                    newOLI.ConnectorLine__c ='MC4';
                    newOLI.Connector__c ='MC4';
                    newOLI.Type_of_module__c ='NS-Non smart module';
                    newOLI.Color_of_Module__c ='3-Black frame and white backsh';
                    newOLI.Special_required__c ='0-commonly';
                    newOLI.Bus_bars_of_cell__c ='2-2BB';
                }
                //Connector
                if(entry.data.product2.name.Startswith('JK03M')||entry.data.product2.name.Startswith('JK06M')||entry.data.product2.name.Startswith('MC4')||entry.data.product2.name.Startswith('JKT')){
                    newOLI.Product_Type__C ='Connector';
                    newOLI.Main_Type__c = 'Connector';
                }
                //New Tiger
                else if((entry.data.product2.name.Startswith('JKM')||entry.data.product2.name.Startswith('MM'))&&entry.data.product2.name.contains('LM')&&!entry.data.product2.name.contains('N')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('BD')||entry.data.product2.name.contains('BG')){
                        newOLI.Product_Type__C ='New Tiger-P-DG';
                    }else if(entry.data.product2.name.contains('T')||entry.data.product2.name.contains('BB')){
                        newOLI.Product_Type__C ='New Tiger-P-TB';
                    }else{
                        newOLI.Product_Type__C ='New Tiger-P';
                    }
                }
                   //N Type
                else if(((entry.data.product2.name.contains('BDV') && !entry.data.product2.name.contains('BDVP'))||entry.data.product2.name.contains('N-'))&& entry.data.product2.name.contains('HLM')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('6T')){
                        newOLI.Product_Type__C ='N-Tiger-60M';
                    }else if(entry.data.product2.name.contains('6R')||entry.data.product2.name.contains('66')){
                        newOLI.Product_Type__C ='N-Tiger-66M';
                    }
                }
                //P Type
                else if(entry.data.product2.name.contains('HLM')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('6T')||entry.data.product2.name.contains('60H')){
                        newOLI.Product_Type__C ='P-Tiger-60MH';
                    }
                    else if(entry.data.product2.name.contains('7T')||entry.data.product2.name.contains('72')){
                        if(entry.data.product2.name.contains('BD')){
                          newOLI.Product_Type__C ='P-Tiger-72BD';
                        }else if(entry.data.product2.name.contains('TV')){
                          newOLI.Product_Type__C ='P-Tiger-72BT';
                        }else{
                          newOLI.Product_Type__C ='P-Tiger-72MH';
                        }
                    }
                }
                //P Type Pro
                else if(entry.data.product2.name.contains('L4')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(entry.data.product2.name.contains('6T')||entry.data.product2.name.contains('60H')){
                        newOLI.Product_Type__C ='P-Tiger Pro-60MH';
                    }
                    else if(entry.data.product2.name.contains('7T')||entry.data.product2.name.contains('72H')){
                        if(entry.data.product2.name.contains('BDVP')){
                          newOLI.Product_Type__C ='P-Tiger Pro-72BD';
                        }else if(entry.data.product2.name.contains('TV')){
                          newOLI.Product_Type__C ='P-Tiger Pro-72BT';
                        }else{
                          newOLI.Product_Type__C ='P-Tiger Pro-72MH';
                        }
                    }
                    else if(entry.data.product2.name.contains('7R')||entry.data.product2.name.contains('78')){
                          newOLI.Product_Type__C ='P-Tiger Pro-78BT';
                    }
                }
                
                //Smart
                else if(entry.data.product2.name.Startswith('JKMS')||entry.data.product2.name.Startswith('SMM')){
                    newOLI.Main_Type__c = 'Smart';
                    if(entry.data.product2.name.contains('TI')){
                        newOLI.Product_Type__C ='Smart-TI';
                    }else if(entry.data.product2.name.contains('TG')){
                        newOLI.Product_Type__C ='Smart-TG';
                    }else if(entry.data.product2.name.contains('MX')){
                        newOLI.Product_Type__C ='Smart-MX';
                    }else{
                        newOLI.Product_Type__C ='Smart';
                    }
                }
                
                //Tiger Pro
                else if(entry.data.product2.name.Startswith('JKM')&& !entry.data.product2.name.contains('JKMS')&&entry.data.product2.name.contains('L4')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }
                else if(entry.data.product2.name.Startswith('MM')&&entry.data.product2.name.contains('LD')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }

                //Tiger
                else if(entry.data.product2.name.Startswith('JKM')&& !entry.data.product2.name.contains('JKMS')&&entry.data.product2.name.contains('L3')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger-P-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(entry.data.product2.name.Startswith('MM')&&entry.data.product2.name.contains('LC')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger-N-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger-N-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger-P-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger-P-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(entry.data.product2.name.contains('JKSM3')){
                    newOLI.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    newOLI.Product_Type__C ='Tiger-P';
                }
                else if(entry.data.product2.name.contains('JKSN3')){
                    newOLI.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    newOLI.Product_Type__C ='Tiger-N';
                }  
                
                /*plus*/
                else if(entry.data.product2.name.startsWith('JKM') && !entry.data.product2.name.contains('JKMS')&&(entry.data.product2.name.contains('66')||entry.data.product2.name.contains('78'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        system.debug('entry.data.product2.name'+entry.data.product2.name);
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan Plus-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan Plus-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan Plus-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan Plus-P-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan Plus-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan Plus-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                else if(entry.data.product2.name.startsWith('MM') &&(entry.data.product2.name.contains('66')||entry.data.product2.name.contains('78'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        system.debug('entry.data.product2.name'+entry.data.product2.name);
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan Plus-N-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan Plus-N-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan Plus-N-SG';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan Plus-P-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan Plus-P-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan Plus-P-SG';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                
                /*Swan*/
                else if(entry.data.product2.name.contains('JKM')&& (entry.data.product2.name.contains('BDVP')||entry.data.product2.name.contains('BD')||entry.data.product2.name.contains('-T')||entry.data.product2.name.contains('-D'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan-N-TB';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BDVP')){
                            newOLI.Product_Type__C ='Swan-P-DG';
                        }else if(entry.data.product2.name.contains('BD')){
                            system.debug('junjun');
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan-P-TB';
                        }
                    }
                }
                else if(entry.data.product2.name.contains('MM')&& (entry.data.product2.name.contains('BG')||entry.data.product2.name.contains('BB')||entry.data.product2.name.contains('MG'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan-N-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan-N-SG';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan-P-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            system.debug('junjun');
                            newOLI.Product_Type__C ='Swan-P-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan-P-SG';
                        }
                    }
                }
                
                /*Eagle*/
                else if((entry.data.product2.name.contains('JKM')||entry.data.product2.name.Startswith('MM'))&& entry.data.product2.name.contains('P-')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('H')){
                        system.debug('111111');
                        newOLI.Product_Type__C ='Eagle Poly-HC';
                    }else if(!entry.data.product2.name.contains('H')){
                        system.debug('22222');
                        newOLI.Product_Type__C ='Eagle Poly-FC';
                    }
                }
                
                /*Cheetah*/
                else if(entry.data.product2.name.contains('JKM') && !entry.data.product2.name.contains('JKMS')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(entry.data.product2.name.substring(3, 6));
                    if(entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=390){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            system.debug('junjunV3');
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    newOLI.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                else if(entry.data.product2.name.Startswith('MM')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(entry.data.product2.name.substring(2, 5));
                    if(entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=390){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            system.debug('junjunV3');
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    newOLI.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                //Cell Type
                if(newOLI.Main_Type__c == 'Cheetah(Swan)'){
                    newOLI.Battery_Type__c = '158.75';
                }else if(newOLI.Main_Type__c == 'Tiger'||newOLI.Main_Type__c == 'Tiger Pro'){
                    if(entry.data.product2.name.contains('L3')){
                       newOLI.Battery_Type__c = '163.75';
                    }else if(entry.data.product2.name.contains('LM')){
                       newOLI.Battery_Type__c = '166';
                    }else if(entry.data.product2.name.contains('L4')){
                       newOLI.Battery_Type__c = '182';
                    }
                }else if(entry.data.product2.name.contains('PP')){
                       newOLI.Battery_Type__c = '156.75 poly';
                }else if(entry.data.product2.name.contains('72HL')||entry.data.product2.name.contains('72HBL')||entry.data.product2.name.contains('60HL')||entry.data.product2.name.contains('60HBL')){
                       newOLI.Battery_Type__c = '158.75';
                }else{
                       newOLI.Battery_Type__c = 'Others';
                }
                // 2021/3/25 Samba Start
                Boolean hasABWithPM = false;
                if(entry.data.product2.Product_Module_PM__c != null && entry.data.product2.Product_Module_PM__c.contains('AB')) {
                    hasABWithPM = true;
                    newOLI.Frame_Color__c = 'Black';
                } else {
                    newOLI.Back_Sheet_Color__c = 'Black & White';
                }
                newOLI.Back_Sheet_Color_Additional_Cost_Per_W__c = 0;
                newOLI.Frame_Color_Additional_Cost_Per_W__c = 0;
                // End

                //else{
                  //  newOLI.Product_Type__C ='';
               // }
                
                
                /*if(entry.data.product2.name.contains('JK03M')){
newOLI.Product_Type__C ='Connector';
newOLI.MP__c ='Connector';
}
if(entry.data.product2.name.contains('BDV') && !entry.data.product2.name.contains('BDVP')){
System.debug('是老虎型');
newOLI.Product_Type__C ='Swan-N-BD';
newOLI.MP__c ='Perc Mono';
}
else if(entry.data.product2.name.contains('BDVP') || entry.data.product2.name.contains('BDP')){
System.debug('是老虎型');
newOLI.Product_Type__C ='Swan-P-BD';
newOLI.MP__c ='Perc Mono';
}
else if(entry.data.product2.name.contains('TV')){
System.debug('是老虎型');
newOLI.Product_Type__C ='Swan-TV';
newOLI.MP__c ='Perc Mono';
}
else IF(entry.data.product2.name.contains('PP') || entry.data.product2.name.contains('P')){
newOLI.Product_Type__C ='Eagle Poly';
newOLI.MP__c ='Poly';
}
else{
system.debug('判断是不是天鹅');
IF(entry.data.product2.name.startsWith('JKM') && !entry.data.product2.name.startsWith('JKMS')){
system.debug('JKM');
integer MW =Integer.valueOf(entry.data.product2.name.substring(3, 6));
if(entry.data.product2.name.contains('H')){
if(entry.data.product2.name.contains('60')){
if(MW>=325){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=395){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
}else{
if(entry.data.product2.name.contains('60')){
if(MW>=320){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=390){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}                        
}
}
IF(entry.data.product2.name.startsWith('JKMS')){
system.debug('JKMS');
integer MW =Integer.valueOf(entry.data.product2.name.substring(4, 7));                   
if(entry.data.product2.name.contains('H')){
if(entry.data.product2.name.contains('60')){
if(MW>=325){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=395){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
}else{
if(entry.data.product2.name.contains('60')){
if(MW>=320){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=390){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}

}
}

}*/
                nextTempid++;
                currentProductsItem proxyCurrentProductsItem = new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid);
                proxyCurrentProductsItem.hasABWithPM = hasABWithPM;
                currentProducts.add(proxyCurrentProductsItem);
                
                // Clear checkbox
                entry.isSelected = false;
            }
        }
    }
    /*
* -------------------------------------------------------------------------------------
*    AddProduct methods
* -------------------------------------------------------------------------------------
*/
    public String NewProductID { get; set; }
    
    public void AddProduct() {
        if ( NewProductID == '000000000000000' ) {
            return;
        }
        
        // Added By Leo 2018 05 16. 为美国区设定默认产品值
        /*  String [] prodname =new String []{'JKM360M-72-V','JKM365M-72-V','JKM370M-72-V','JKM375M-72-V','JKM380M-72-V',
'JKM385M-72-V','JKM390M-72-V','JKM395M-72-V','JKM400M-72-V','JKM320PP-72-V',
'JKM325PP-72-V','JKM330PP-72-V','JKM335PP-72-V','JKM290M-60B','JKM295M-60B',
'JKM300M-60B','JKM300M-60','JKM305M-60','JKM310M-60','JKM315M-60','JKM370M-72H-V',
'JKM375M-72H-V','JKM380M-72H-V','JKM385M-72H-V','JKM390M-72H-V','JKM395M-72H-V',
'JKM400M-72H-V','JKM405M-72H-V'};   */
        List<OpportunityLineItem> list_Oppline = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> map_proname =new  Map<String,OpportunityLineItem>();
        list_Oppline=[Select Id,Product2Id,MP__c,
                      Battery_Type__c,         
                      Wire_Length__c,
                      Connector__c, 
                      Type_of_module__c, 
                      Color_of_Module__c,
                      Grade__c,
                      Product_Type__c,
                      Special_required__c, 
                      Bus_bars_of_cell__c,
                      Special_Lable__c,
                      Certification__c, 
                      Test_code__c,
                      Opp_Description__c,
                      Product2.Name From OpportunityLineItem where  Opportunityid =:'0066F00000rqinlQAA'];
        //沙盒Oppty: 0060l000003xdg6AAA    Prod Oppty: 0066F00000rqinlQAA
        system.debug('********list_Oppline*******'+list_Oppline);
        if(list_Oppline.size()>0){
            for(OpportunityLineItem oil1 :list_Oppline)
            {
                map_proname.put(oil1.Product2.Name, oil1);
            }
            system.debug('________*map_proname******'+map_proname);
        }
        
        for (pricebookentryTableItem entry : catalog ) { 
            if ( entry.data.product2id == NewProductID ) {
                OpportunityLineItem newOLI = new OpportunityLineItem(
                    OpportunityId     = opp.id,
                    PricebookEntryId  = entry.data.id,
                    quantity          = 0,
                    UnitPrice         = entry.data.unitprice  // -- Need to compute discount rules first
                );
                newOLI.PriceBookEntry = entry.data;
                IF(entry.data.product2.Non_Modul__c==true){
                    newOLI.MP__c ='Poly';
                    newOLI.Battery_Type__c ='Normal Cell';
                    newOLI.Wire_Length__c ='1000mm';
                    newOLI.ConnectorLine__c ='MC4';
                    newOLI.Connector__c ='MC4';
                    newOLI.Type_of_module__c ='NS-Non smart module';
                    newOLI.Color_of_Module__c ='3-Black frame and white backsh';
                    newOLI.Special_required__c ='0-commonly';
                    newOLI.Bus_bars_of_cell__c ='2-2BB';
                }
                if(opp.RecordType.Name =='USA' && map_proname !=null && map_proname.get(entry.data.Product2.Name) !=null){
                    newOLI.MP__c = map_proname.get(entry.data.Product2.Name).MP__c;
                    newOLI.Battery_Type__c =map_proname.get(entry.data.Product2.Name).Battery_Type__c;         
                    newOLI.Wire_Length__c =map_proname.get(entry.data.Product2.Name).Wire_Length__c;
                    newOLI.Connector__c =map_proname.get(entry.data.Product2.Name).Connector__c; 
                    newOLI.Type_of_module__c =map_proname.get(entry.data.Product2.Name).Type_of_module__c; 
                    newOLI.Color_of_Module__c =map_proname.get(entry.data.Product2.Name).Color_of_Module__c; 
                    newOLI.Special_required__c =map_proname.get(entry.data.Product2.Name).Special_required__c; 
                    newOLI.Bus_bars_of_cell__c =map_proname.get(entry.data.Product2.Name).Bus_bars_of_cell__c;
                    //  newOLI.Guaranteed_Delivery_Date__c ; 
                    // newOLI.Guaranteed_Delivery_Date_japan__c;
                    // newOLI.Expected_Delivery_Date__c;
                    // newOLI.Expected_Delivery_Date_ETA__c;
                    //  newOLI.Estimated_Time_of_Departure_ETD__c;
                    //  newOLI.Estimated_Time_of_Departure_ETD_7__c;
                    newOLI.Special_Lable__c =map_proname.get(entry.data.Product2.Name).Special_Lable__c;
                    newOLI.Certification__c =map_proname.get(entry.data.Product2.Name).Certification__c;
                    //  newOLI.Estimated_Time_of_Departure__c,;
                    // newOLI.EVA__c; 
                    // newOLI.Power_W__c; 
                    // newOLI.Total_MW__c; 
                    // newOLI.Cell_Appearance__c;
                    newOLI.Grade__c =map_proname.get(entry.data.Product2.Name).Grade__c;               
                    // newOLI.Junction_Box__c; 
                    // newOLI.Discount__c;
                    // newOLI.Tolerance__c;
                    // newOLI.Module_size__c
                }
                system.debug('entry.data.product2.name'+entry.data.product2.name);
                //newOLI.Recommended_Discount__c = 0;
                newOLI.UnitPrice = entry.data.unitprice ;//* ( 100 - newOLI.Recommended_Discount__c )/100.0;
                //Connector
                if(entry.data.product2.name.Startswith('JK03M')||entry.data.product2.name.Startswith('JK06M')||entry.data.product2.name.Startswith('MC4')||entry.data.product2.name.Startswith('JKT')){
                    newOLI.Product_Type__C ='Connector';
                    newOLI.Main_Type__c = 'Connector';
                }
                //New Tiger
                else if((entry.data.product2.name.Startswith('JKM')||entry.data.product2.name.Startswith('MM'))&&entry.data.product2.name.contains('LM')&&!entry.data.product2.name.contains('N')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('BD')||entry.data.product2.name.contains('BG')){
                        newOLI.Product_Type__C ='New Tiger-P-DG';
                    }else if(entry.data.product2.name.contains('T')||entry.data.product2.name.contains('BB')){
                        newOLI.Product_Type__C ='New Tiger-P-TB';
                    }else{
                        newOLI.Product_Type__C ='New Tiger-P';
                    }
                }
                   //N Type
                else if(((entry.data.product2.name.contains('BDV') && !entry.data.product2.name.contains('BDVP'))||entry.data.product2.name.contains('N-'))&& entry.data.product2.name.contains('HLM')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('6T')){
                        newOLI.Product_Type__C ='N-Tiger-60M';
                    }else if(entry.data.product2.name.contains('6R')||entry.data.product2.name.contains('66')){
                        newOLI.Product_Type__C ='N-Tiger-66M';
                    }
                }
                //P Type
                else if(entry.data.product2.name.contains('HLM')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('6T')||entry.data.product2.name.contains('60H')){
                        newOLI.Product_Type__C ='P-Tiger-60MH';
                    }else if(entry.data.product2.name.contains('7T')||entry.data.product2.name.contains('72')){
                        if(entry.data.product2.name.contains('BD')){
                          newOLI.Product_Type__C ='P-Tiger-72BD';
                        }else if(entry.data.product2.name.contains('TV')){
                          newOLI.Product_Type__C ='P-Tiger-72BT';
                        }else{
                          newOLI.Product_Type__C ='P-Tiger-72MH';
                        }
                    }
                }
                //P Type Pro
                else if(entry.data.product2.name.contains('L4')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(entry.data.product2.name.contains('6T')||entry.data.product2.name.contains('60H')){
                        newOLI.Product_Type__C ='P-Tiger Pro-60MH';
                    }else if(entry.data.product2.name.contains('7T')||entry.data.product2.name.contains('72H')){
                        if(entry.data.product2.name.contains('BDVP')){
                          newOLI.Product_Type__C ='P-Tiger Pro-72BD';
                        }else if(entry.data.product2.name.contains('TV')){
                          newOLI.Product_Type__C ='P-Tiger Pro-72BT';
                        }else{
                          newOLI.Product_Type__C ='P-Tiger Pro-72MH';
                        }
                    }else if(entry.data.product2.name.contains('7R')||entry.data.product2.name.contains('78')){
                          newOLI.Product_Type__C ='P-Tiger Pro-78BT';
                    }
                }
                //Smart
                else if(entry.data.product2.name.Startswith('JKMS')||entry.data.product2.name.Startswith('SMM')){
                    newOLI.Main_Type__c = 'Smart';
                    if(entry.data.product2.name.contains('TI')){
                        newOLI.Product_Type__C ='Smart-TI';
                    }else if(entry.data.product2.name.contains('TG')){
                        newOLI.Product_Type__C ='Smart-TG';
                    }else if(entry.data.product2.name.contains('MX')){
                        newOLI.Product_Type__C ='Smart-MX';
                    }else{
                        newOLI.Product_Type__C ='Smart';
                    }
                }
                
                //Tiger Pro
                else if(entry.data.product2.name.Startswith('JKM')&& !entry.data.product2.name.contains('JKMS')&&entry.data.product2.name.contains('L4')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }
                else if(entry.data.product2.name.Startswith('MM')&&entry.data.product2.name.contains('LD')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }

                //Tiger
                else if(entry.data.product2.name.Startswith('JKM')&& !entry.data.product2.name.contains('JKMS')&&entry.data.product2.name.contains('L3')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger-P-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(entry.data.product2.name.Startswith('MM')&&entry.data.product2.name.contains('LC')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger-N-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger-N-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger-P-DG';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger-P-SG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(entry.data.product2.name.contains('JKSM3')){
                    newOLI.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    newOLI.Product_Type__C ='Tiger-P';
                }
                else if(entry.data.product2.name.contains('JKSN3')){
                    newOLI.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    newOLI.Product_Type__C ='Tiger-N';
                }  
                
                /*plus*/
                else if(entry.data.product2.name.startsWith('JKM') && !entry.data.product2.name.contains('JKMS')&&(entry.data.product2.name.contains('66')||entry.data.product2.name.contains('78'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        system.debug('entry.data.product2.name'+entry.data.product2.name);
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan Plus-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan Plus-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan Plus-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan Plus-P-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan Plus-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan Plus-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                else if(entry.data.product2.name.startsWith('MM') &&(entry.data.product2.name.contains('66')||entry.data.product2.name.contains('78'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        system.debug('entry.data.product2.name'+entry.data.product2.name);
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan Plus-N-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan Plus-N-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan Plus-N-SG';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan Plus-P-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan Plus-P-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan Plus-P-SG';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                
                /*Swan*/
                else if(entry.data.product2.name.contains('JKM')&& (entry.data.product2.name.contains('BDVP')||entry.data.product2.name.contains('BD')||entry.data.product2.name.contains('-T')||entry.data.product2.name.contains('-D'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan-N-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan-N-TB';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BDVP')){
                            newOLI.Product_Type__C ='Swan-P-DG';
                        }else if(entry.data.product2.name.contains('BD')){
                            system.debug('junjun');
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(entry.data.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan-P-SG';
                        }else if(entry.data.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan-P-TB';
                        }
                    }
                }
                else if(entry.data.product2.name.contains('MM')&& (entry.data.product2.name.contains('BG')||entry.data.product2.name.contains('BB')||entry.data.product2.name.contains('MG'))){
                    system.debug('entry.data.product2.name'+entry.data.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan-N-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan-N-SG';
                        }
                    }else if(!entry.data.product2.name.contains('N')){
                        if(entry.data.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan-P-DG';
                        }else if(entry.data.product2.name.contains('BB')){
                            system.debug('junjun');
                            newOLI.Product_Type__C ='Swan-P-TB';
                        }else if(entry.data.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan-P-SG';
                        }
                    }
                }
                
                /*Eagle*/
                else if((entry.data.product2.name.contains('JKM')||entry.data.product2.name.Startswith('MM'))&& entry.data.product2.name.contains('P-')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(entry.data.product2.name.contains('H')){
                        system.debug('111111');
                        newOLI.Product_Type__C ='Eagle Poly-HC';
                    }else if(!entry.data.product2.name.contains('H')){
                        system.debug('22222');
                        newOLI.Product_Type__C ='Eagle Poly-FC';
                    }
                }
                
                /*Cheetah*/
                else if(entry.data.product2.name.contains('JKM') && !entry.data.product2.name.contains('JKMS')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(entry.data.product2.name.substring(3, 6));
                    if(entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=390){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            system.debug('junjunV3');
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    newOLI.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                else if(entry.data.product2.name.Startswith('MM')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(entry.data.product2.name.substring(2, 5));
                    if(entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!entry.data.product2.name.contains('H')){
                        if(entry.data.product2.name.contains('N')){
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                if(MW>=390){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!entry.data.product2.name.contains('N')){
                            system.debug('junjunV3');
                            if(entry.data.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(entry.data.product2.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    newOLI.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                
                else{
                    newOLI.Product_Type__C ='';
                }
                 //Cell Type
                if(newOLI.Main_Type__c == 'Cheetah(Swan)'){
                    newOLI.Battery_Type__c = '158.75';
                }else if(newOLI.Main_Type__c == 'Tiger'||newOLI.Main_Type__c == 'Tiger Pro'){
                    if(entry.data.product2.name.contains('L3')){
                       newOLI.Battery_Type__c = '163.75';
                    }else if(entry.data.product2.name.contains('LM')){
                       newOLI.Battery_Type__c = '166';
                    }else if(entry.data.product2.name.contains('L4')){
                       newOLI.Battery_Type__c = '182';
                    }
                }else if(entry.data.product2.name.contains('PP')){
                       newOLI.Battery_Type__c = '156.75 poly';
                }else if(entry.data.product2.name.contains('72HL')||entry.data.product2.name.contains('72HBL')||entry.data.product2.name.contains('60HL')||entry.data.product2.name.contains('60HBL')){
                       newOLI.Battery_Type__c = '158.75';
                }else{
                       newOLI.Battery_Type__c = 'Others';
                }
                /*   if(entry.data.product2.name.contains('JK03M')){
newOLI.Product_Type__C ='Connector';
newOLI.MP__c ='Connector';
}
if(entry.data.product2.name.contains('BDV') && !entry.data.product2.name.contains('BDVP')){
System.debug('是老虎型');
newOLI.Product_Type__C ='Swan-N-BD';
newOLI.MP__c ='Perc Mono';
}
else if(entry.data.product2.name.contains('BDVP') || entry.data.product2.name.contains('BDP')){
System.debug('是老虎型');
newOLI.Product_Type__C ='Swan-P-BD';
newOLI.MP__c ='Perc Mono';
}
else if(entry.data.product2.name.contains('TV')){
System.debug('是老虎型');
newOLI.Product_Type__C ='Swan-TV';
newOLI.MP__c ='Perc Mono';
}
else IF(entry.data.product2.name.contains('PP') || entry.data.product2.name.contains('P')){
newOLI.Product_Type__C ='Eagle Poly';
newOLI.MP__c ='Poly';
}
else{
system.debug('判断是不是天鹅');
IF(entry.data.product2.name.startsWith('JKM') && !entry.data.product2.name.startsWith('JKMS')){
system.debug('JKM');
integer MW =Integer.valueOf(entry.data.product2.name.substring(3, 6));
if(entry.data.product2.name.contains('H')){
if(entry.data.product2.name.contains('60')){
if(MW>=325){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=395){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
}else{
if(entry.data.product2.name.contains('60')){
if(MW>=320){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=390){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}                        
}
}
IF(entry.data.product2.name.startsWith('JKMS')){
system.debug('JKMS');
integer MW =Integer.valueOf(entry.data.product2.name.substring(4, 7));                   
if(entry.data.product2.name.contains('H')){
if(entry.data.product2.name.contains('60')){
if(MW>=325){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=395){
newOLI.Product_Type__C ='Cheetah-HC';
newOLI.MP__c ='Perc Mono';
}
}
}else{
if(entry.data.product2.name.contains('60')){
if(MW>=320){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}
if(entry.data.product2.name.contains('72')){
if(MW>=390){
newOLI.Product_Type__C ='Cheetah-FC';
newOLI.MP__c ='Perc Mono';
}
}

}
}

}*/
                // 2021/3/26 Samba Start
                Boolean hasABWithPM = false;
                if(entry.data.product2.Product_Module_PM__c != null && entry.data.product2.Product_Module_PM__c.contains('AB')) {
                    hasABWithPM = true;
                    newOLI.Frame_Color__c = 'Black';
                } else {
                    newOLI.Back_Sheet_Color__c = 'Black & White';
                }
                newOLI.Back_Sheet_Color_Additional_Cost_Per_W__c = 0;
                newOLI.Frame_Color_Additional_Cost_Per_W__c = 0;
                // End
                nextTempid++;
                currentProductsItem proxyCurrentProductsItem = new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid);
                proxyCurrentProductsItem.hasABWithPM = hasABWithPM;
                currentProducts.add(proxyCurrentProductsItem);
                break;
            }
        }
    }    
    /*
* -------------------------------------------------------------------------------------
*    Clone Line Items (many)
* -------------------------------------------------------------------------------------
*/
    
    public void CloneLineItems() {
        // We can't add items to a list while it is being iterated.
        List<currentProductsItem> newEntries = new List<currentProductsItem>();
        for ( currentProductsItem entry : currentProducts ) {
            if ( entry.isSelected ) {
                OpportunityLineItem newOLI = entry.data.clone(false,true,false,false);
                newOLI.OpportunityID = opp.id;
                newOLI.TotalPrice = null;  // can only specify unitPrice OR totalPrice not both
                nextTempid++;
                newEntries.add(new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid));
            }
        }
        currentProducts.addAll(newEntries);
    }
    /*
* -------------------------------------------------------------------------------------
*    Clone Line Item  -- just one
*      reuses NewProductID
* -------------------------------------------------------------------------------------
*/
    public String SelectedLineItem { get; set; }
    
    public void CloneLineItem() {
        // We can't add items to a list while it is being iterated.
        List<currentProductsItem> newEntries = new List<currentProductsItem>();
        for ( currentProductsItem entry : currentProducts ) {
            if ( entry.getid() == SelectedLineItem ) {
                OpportunityLineItem newOLI = entry.data.clone(false,true,false,false);
                newOLI.OpportunityID = opp.id;
                newOLI.TotalPrice = null;  // can only specify unitPrice OR totalPrice not both
                nextTempid++;
                newEntries.add(new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid));
            }
        }
        currentProducts.addAll(newEntries);
    }
    
    /*
* -------------------------------------------------------------------------------------
*    Change Line Item
* -------------------------------------------------------------------------------------
*/
    
    List<OpportunityLineItem> pendingDeletes = new List<OpportunityLineItem>();
    
    
    public void ChangeLineItem() {
        if ( NewProductID == '000000000000000' ) {
            return;
        }       
        // We can't add items to a list while it is being iterated.
        currentProductsItem newEntry ;
        PricebookEntry newPricebookentry = null;
        
        for (pricebookentryTableItem entry : catalog ) { 
            if ( entry.data.product2id == NewProductID ) {
                newPricebookentry = entry.data;
            }
        }
        
        if ( newPricebookentry == null ) {
            // throw error ... Chosen product does not have a pricebook entry in the current catalog.
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,'The chosen product does not have a pricebook entry in the current catalog.  Please try a different product.'));
            return ;         
        }
        
        for ( Integer x = 0; x < currentProducts.size(); x++) {
            if ( currentProducts[x].getid() == SelectedLineItem ) {
                currentProductsItem oldEntry = currentProducts[x];
                
                
                OpportunityLineItem newOLI = currentProducts[x].data.clone(false,true,true,false);
                newOLI.PricebookEntryId    = newPricebookentry.id;
                newOLI.PricebookEntry      = newPricebookentry;
                newOLI.OpportunityID       = opp.id;
                newOLI.TotalPrice          = null;  // can only specify unitPrice OR totalPrice not both
                system.debug('对比newOLI.PricebookEntry '+newOLI.PricebookEntry );  
                system.debug('对比oldOLI.PricebookEntry '+currentProducts[x].data.PricebookEntry ); 
                if((newOLI.PricebookEntry.name==currentProducts[x].data.PricebookEntry.name+'-V' || newOLI.PricebookEntry.name+'-V'==currentProducts[x].data.PricebookEntry.name)
                  ){
                      newOLI.sameproduct__c=true;
                  }
                //Connector
                if(newPricebookentry.product2.name.Startswith('JK03M')||newPricebookentry.product2.name.Startswith('JK06M')||newPricebookentry.product2.name.Startswith('MC4')||newPricebookentry.product2.name.Startswith('JKT')){
                    newOLI.Product_Type__C ='Connector';
                    newOLI.Main_Type__c = 'Connector';
                }
                //New Tiger
                else if((newPricebookentry.product2.name.Startswith('JKM')||newPricebookentry.product2.name.Startswith('MM'))&&newPricebookentry.product2.name.contains('LM')&&!newPricebookentry.product2.name.contains('N')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(newPricebookentry.product2.name.contains('BD')||newPricebookentry.product2.name.contains('BG')){
                        newOLI.Product_Type__C ='New Tiger-P-DG';
                    }else if(newPricebookentry.product2.name.contains('T')||newPricebookentry.product2.name.contains('BB')){
                        newOLI.Product_Type__C ='New Tiger-P-TB';
                    }else{
                        newOLI.Product_Type__C ='New Tiger-P';
                    }
                }
                   //N Type
                else if(((newPricebookentry.product2.name.contains('BDV') && !newPricebookentry.product2.name.contains('BDVP'))||newPricebookentry.product2.name.contains('N-'))&& newPricebookentry.product2.name.contains('HLM')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(newPricebookentry.product2.name.contains('6T')){
                        newOLI.Product_Type__C ='N-Tiger-60M';
                    }else if(newPricebookentry.product2.name.contains('6R')||newPricebookentry.product2.name.contains('66')){
                        newOLI.Product_Type__C ='N-Tiger-66M';
                    }
                }
                //P Type
                else if(newPricebookentry.product2.name.contains('HLM')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(newPricebookentry.product2.name.contains('6T')||newPricebookentry.product2.name.contains('60H')){
                        newOLI.Product_Type__C ='P-Tiger-60MH';
                    }else if(newPricebookentry.product2.name.contains('7T')||newPricebookentry.product2.name.contains('72')){
                        if(newPricebookentry.product2.name.contains('BD')){
                          newOLI.Product_Type__C ='P-Tiger-72BD';
                        }else if(newPricebookentry.product2.name.contains('TV')){
                          newOLI.Product_Type__C ='P-Tiger-72BT';
                        }else{
                          newOLI.Product_Type__C ='P-Tiger-72MH';
                        }
                    }
                }
                //P Type Pro
                else if(newPricebookentry.product2.name.contains('L4')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(newPricebookentry.product2.name.contains('6T')||newPricebookentry.product2.name.contains('60H')){
                        newOLI.Product_Type__C ='P-Tiger Pro-60MH';
                    }else if(newPricebookentry.product2.name.contains('7T')||newPricebookentry.product2.name.contains('72H')){
                        if(newPricebookentry.product2.name.contains('BDVP')){
                          newOLI.Product_Type__C ='P-Tiger Pro-72BD';
                        }else if(newPricebookentry.product2.name.contains('TV')){
                          newOLI.Product_Type__C ='P-Tiger Pro-72BT';
                        }else{
                          newOLI.Product_Type__C ='P-Tiger Pro-72MH';
                        }
                    }else if(newPricebookentry.product2.name.contains('7R')||newPricebookentry.product2.name.contains('78')){
                          newOLI.Product_Type__C ='P-Tiger Pro-78BT';
                    }
                }
                //Smart
                else if(newPricebookentry.product2.name.Startswith('JKMS')||newPricebookentry.product2.name.Startswith('SMM')){
                    newOLI.Main_Type__c = 'Smart';
                    if(newPricebookentry.product2.name.contains('TI')){
                        newOLI.Product_Type__C ='Smart-TI';
                    }else if(newPricebookentry.product2.name.contains('TG')){
                        newOLI.Product_Type__C ='Smart-TG';
                    }else if(newPricebookentry.product2.name.contains('MX')){
                        newOLI.Product_Type__C ='Smart-MX';
                    }else{
                        newOLI.Product_Type__C ='Smart';
                    }
                }
                
                //Tiger Pro
                else if(newPricebookentry.product2.name.Startswith('JKM')&& !newPricebookentry.product2.name.contains('JKMS')&&newPricebookentry.product2.name.contains('L4')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }
                else if(newPricebookentry.product2.name.Startswith('MM')&&newPricebookentry.product2.name.contains('LD')){
                    newOLI.Main_Type__c = 'Tiger Pro';
                    if(newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger Pro-N-DG';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger Pro-N-SG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger Pro-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-N';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger Pro-P-DG';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger Pro-P-SG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger Pro-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger Pro-P';
                        }
                    }
                }

                //Tiger
                else if(newPricebookentry.product2.name.Startswith('JKM')&& !newPricebookentry.product2.name.contains('JKMS')&&newPricebookentry.product2.name.contains('L3')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger-N-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger-N-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-N';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Tiger-P-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Tiger-P-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Tiger-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(newPricebookentry.product2.name.Startswith('MM')&&newPricebookentry.product2.name.contains('LC')){
                    newOLI.Main_Type__c = 'Tiger';
                    if(newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger-N-DG';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger-N-SG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-N';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Tiger-P-DG';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Tiger-P-SG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Tiger-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Tiger-P';
                        }
                    }
                }
                else if(newPricebookentry.product2.name.contains('JKSM3')){
                    newOLI.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    newOLI.Product_Type__C ='Tiger-P';
                }
                else if(newPricebookentry.product2.name.contains('JKSN3')){
                    newOLI.Main_Type__c = 'Tiger';
                    system.debug('是老虎型');
                    newOLI.Product_Type__C ='Tiger-N';
                }  
                
                /*plus*/
                else if(newPricebookentry.product2.name.startsWith('JKM') && !newPricebookentry.product2.name.contains('JKMS')&&(newPricebookentry.product2.name.contains('66')||newPricebookentry.product2.name.contains('78'))){
                    system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                    system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(newPricebookentry.product2.name.contains('N')){
                        system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan Plus-N-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan Plus-N-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan Plus-N-TB';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan Plus-P-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan Plus-P-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan Plus-P-TB';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                else if(newPricebookentry.product2.name.startsWith('MM') &&(newPricebookentry.product2.name.contains('66')||newPricebookentry.product2.name.contains('78'))){
                    system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                    system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(newPricebookentry.product2.name.contains('N')){
                        system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan Plus-N-DG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan Plus-N-TB';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan Plus-N-SG';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-N';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan Plus-P-DG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan Plus-P-TB';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan Plus-P-SG';
                        }else{
                            newOLI.Product_Type__C ='Cheetah Plus-P';
                        }
                    }
                }
                
                /*Swan*/
                else if(newPricebookentry.product2.name.contains('JKM')&& (newPricebookentry.product2.name.contains('BDVP')||newPricebookentry.product2.name.contains('BD')||newPricebookentry.product2.name.contains('-T')||newPricebookentry.product2.name.contains('-D'))){
                    system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BD')){
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan-N-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan-N-TB';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BDVP')){
                            newOLI.Product_Type__C ='Swan-P-DG';
                        }else if(newPricebookentry.product2.name.contains('BD')){
                            system.debug('junjun');
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(newPricebookentry.product2.name.contains('-D')){
                            newOLI.Product_Type__C ='Swan-P-SG';
                        }else if(newPricebookentry.product2.name.contains('-T')){
                            newOLI.Product_Type__C ='Swan-P-TB';
                        }
                    }
                }
                else if(newPricebookentry.product2.name.contains('MM')&& (newPricebookentry.product2.name.contains('BG')||newPricebookentry.product2.name.contains('BB')||newPricebookentry.product2.name.contains('MG'))){
                    system.debug('entry.data.product2.name'+newPricebookentry.product2.name);
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan-N-DG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            newOLI.Product_Type__C ='Swan-N-TB';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan-N-SG';
                        }
                    }else if(!newPricebookentry.product2.name.contains('N')){
                        if(newPricebookentry.product2.name.contains('BG')){
                            newOLI.Product_Type__C ='Swan-P-DG';
                        }else if(newPricebookentry.product2.name.contains('BB')){
                            system.debug('junjun');
                            newOLI.Product_Type__C ='Swan-P-TB';
                        }else if(newPricebookentry.product2.name.contains('MG')){
                            newOLI.Product_Type__C ='Swan-P-SG';
                        }
                    }
                }
                
                /*Eagle*/
                else if((newPricebookentry.product2.name.contains('JKM')||newPricebookentry.product2.name.Startswith('MM'))&& newPricebookentry.product2.name.contains('P-')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    if(newPricebookentry.product2.name.contains('H')){
                        system.debug('111111');
                        newOLI.Product_Type__C ='Eagle Poly-HC';
                    }else if(!newPricebookentry.product2.name.contains('H')){
                        system.debug('22222');
                        newOLI.Product_Type__C ='Eagle Poly-FC';
                    }
                }
                
                /*Cheetah*/
                else if(newPricebookentry.product2.name.contains('JKM') && !newPricebookentry.product2.name.contains('JKMS')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(newPricebookentry.product2.name.substring(3, 6));
                    if(newPricebookentry.product2.name.contains('H')){
                        if(newPricebookentry.product2.name.contains('N')){
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!newPricebookentry.product2.name.contains('N')){
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!newPricebookentry.product2.name.contains('H')){
                        if(newPricebookentry.product2.name.contains('N')){
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                if(MW>=390){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!newPricebookentry.product2.name.contains('N')){
                            system.debug('junjunV3');
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    newOLI.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                else if(newPricebookentry.product2.name.Startswith('MM')){
                    newOLI.Main_Type__c = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(newPricebookentry.product2.name.substring(2, 5));
                    if(newPricebookentry.product2.name.contains('H')){
                        if(newPricebookentry.product2.name.contains('N')){
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-N-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!newPricebookentry.product2.name.contains('N')){
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=325){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                if(MW>=395){
                                    newOLI.Product_Type__C ='Cheetah-P-HC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!newPricebookentry.product2.name.contains('H')){
                        if(newPricebookentry.product2.name.contains('N')){
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                if(MW>=390){
                                    newOLI.Product_Type__C ='Cheetah-N-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!newPricebookentry.product2.name.contains('N')){
                            system.debug('junjunV3');
                            if(newPricebookentry.product2.name.contains('-60')){
                                if(MW>=320){
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    newOLI.Product_Type__C ='Eagle Perc-FC';
                                }
                            }
                            if(newPricebookentry.product2.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    newOLI.Product_Type__C ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    newOLI.Product_Type__C ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                 //Cell Type
                if(newOLI.Main_Type__c == 'Cheetah(Swan)'){
                    newOLI.Battery_Type__c = '158.75';
                }else if(newOLI.Main_Type__c == 'Tiger'||newOLI.Main_Type__c == 'Tiger Pro'){
                    if(newPricebookentry.product2.name.contains('L3')){
                       newOLI.Battery_Type__c = '163.75';
                    }else if(newPricebookentry.product2.name.contains('LM')){
                       newOLI.Battery_Type__c = '166';
                    }else if(newPricebookentry.product2.name.contains('L4')){
                       newOLI.Battery_Type__c = '182';
                    }
                }else if(newPricebookentry.product2.name.contains('PP')){
                       newOLI.Battery_Type__c = '156.75 poly';
                }else if(newPricebookentry.product2.name.contains('72HL')||newPricebookentry.product2.name.contains('72HBL')||newPricebookentry.product2.name.contains('60HL')||newPricebookentry.product2.name.contains('60HBL')){
                       newOLI.Battery_Type__c = '158.75';
                }else{
                       newOLI.Battery_Type__c = 'Others';
                }
                
               // else{
                 //   newOLI.Product_Type__C ='';
               // }
                nextTempid++;
                newEntry = new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid);
                
                // Check to see if the item being replaced exists in the DB or not
                // If so, add to pending deletes so that it can be deleted when
                // the user clicks Save or Quick Save
                if ( currentProducts[x].data.id != null ) {
                    pendingDeletes.add(new OpportunityLineItem(ID = currentProducts[x].data.id ));
                }
                
                //  This SHOULD put the new entry in the same spot as the old.
                currentProducts[x] = newEntry;
                
                break;
            }
        }
    }
    
    
    
    
    /*
* -------------------------------------------------------------------------------------
*    DeleteRow methods
* -------------------------------------------------------------------------------------
*/
    
    
    public String idToDelete { get; set; }
    
    
    public void DeleteRow() {
        system.debug('DeleteRow called with idToDelete=' + idToDelete);
        if ( idToDelete == null ) {
            return;
        }
        
        if (!OpportunityLineItem.sObjectType.getDescribe().isDeletable()){
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,'you can not delete product line item.'));
            return;
        }
        for ( Integer x = 0; x < currentProducts.size(); x++ ) {
            if ( idToDelete == currentProducts[x].getid() ) {
                if ( currentProducts[x].data.id != null ) {
                    delete currentProducts[x].data;
                }
                currentProducts.remove(x);
                break;
            }
        }
    }
    
    
    public void loadPage() {    
    }
    
    public class currentProductsItem {
        public Boolean isSelected          { get; set; }
        public OpportunityLineItem data    { get; set; }
        public Boolean hasABWithPM         { get; set; }
        public Integer tempid              { get; set; }
        public Integer QuantityInteger     { get; set; }
        public Decimal RequestedPanels     { get; set; }
        public Decimal RequestedPallets    { get; set; }
        public Decimal RequestedContainers { get; set; }
        public Decimal ListPrice           { get; set; }
        
        public String  RecordErrorMsg      { get; set; }
        public String  UnitPriceErrorMsg   { get; set; }
        public String  QuantityErrorMsg    { get; set; }
        public Boolean isOneLineContainer  { get; set; }
        
        /*
        * Inner class constructor
        */
        public currentProductsItem(OpportunityLineItem d, Decimal SalesPrice, Integer tid) {
            this.data              = d;
            this.isSelected        = false;
            this.tempid            = tid;
            this.isOneLineContainer = false;
            this.RecordErrorMsg    = '';
            this.UnitPriceErrorMsg = '';
            this.QuantityErrorMsg  = '';
            
            if ( this.getneedsSaving() ) {
                this.RecordErrorMsg = 'Record is not saved';
            }
            if ( this.data.Quantity != null ) {
                this.QuantityInteger = Integer.valueOf(this.data.quantity);
            }
            else {
                this.QuantityInteger = null;
            }
            /*
                if ( this.data.Panels__c != null ) {
                this.RequestedPanels = this.data.Panels__c;   
                }
                else { 
                this.RequestedPanels = null;
                }
                if ( this.data.Pallets__c != null ) {
                this.RequestedPallets = this.data.Pallets__c;
                }
                else {
                this.RequestedPallets = null;
                }
                if ( this.data.Containers__c != null ) {
                this.RequestedContainers = this.data.Containers__c;
                }
                else {
                this.RequestedContainers = null;
                }

                if ( this.data.List__c != null ) {
                this.ListPrice = this.data.List__c;
                }
                else {
                this.ListPrice = SalesPrice;
                }
            */  
        }
        
        /*
        *  Set the id to a temporary auto-number if this is an unsaved record.
        */
        public String getid() {
            if ( this.data.id != null ) {
                return this.data.id;
            }
            else {
                return 'TEMP-' + this.tempid;
            }
        }
        
        /*
        *  Method to assist visual-aid to determine if the record has been saved or not
        */
        public Boolean getneedsSaving() {
            if ( this.data.id == null ) {
                return true;
            }
            else {
                return false;
            }
        }        
        
        /*
        *  Before saving a record, this method is called to clear out error messages.
        *  The error handling routines fill the error messages after an attempted save.
        */
        public void clearErrors() {
            this.RecordErrorMsg    = '';
            this.UnitPriceErrorMsg = '';
            this.QuantityErrorMsg  = '';
        }
    }
    /*-------------------------------------------------------------------------------------
    * Inner Class
    *
    * pricebookentryTableItem :  Wrapper class to hold the Catalog of products available for this Opportunity.
    *                            Pricebookentry plus a checkbox
    *
    * -------------------------------------------------------------------------------------
    */
    public class pricebookentryTableItem {
        public Boolean isSelected { get; set; }
        public Pricebookentry data { get; set; }
        
        public pricebookentryTableItem(Pricebookentry d) {
            this.data = d;
            this.isSelected = false;
        }
    }
    /*
    * -------------------------------------------------------------------------------------
    *    end of class
    * -------------------------------------------------------------------------------------
    */
    
}