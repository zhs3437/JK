global class AddQuoteProductCtrl {
      public Integer nextTempid = 0;
    public class currentProductsItem {
        public Boolean isSelected          { get; set; }
        public QuoteLineItem data    { get; set; }
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


        public currentProductsItem(QuoteLineItem d, Decimal SalesPrice, Integer tid) {

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

            
        }

        public String getid() {
            if ( this.data.id != null ) {
                return this.data.id;
            }
            else {
                return 'TEMP-' + this.tempid;
            }
        }

        public Boolean getneedsSaving() {
            if ( this.data.id == null ) {
                return true;
            }
            else {
                return false;
            }
        }        
            
 
        public void clearErrors() {
            this.RecordErrorMsg    = '';
            this.UnitPriceErrorMsg = '';
            this.QuantityErrorMsg  = '';

        }


    }


    public class pricebookentryTableItem {
        public Boolean isSelected { get; set; }
        public Pricebookentry data { get; set; }
        
        public pricebookentryTableItem(Pricebookentry d) {
            this.data = d;
            this.isSelected = false;
        }
    }
    

    public AddQuoteProductCtrl() {
        
    }

    public Opportunity opp { get; set; }
    public Quote quote { get; set; }
     public String QuoteID { get; set; }
    public AddQuoteProductCtrl(ApexPages.StandardController std) {
       System.debug('报价行添加产品开始---->');
       if (!Test.isRunningTest()){ std.addFields(new List<String>{ 'Pricebook2id'});}
         QuoteID=ApexPages.currentPage().getParameters().get('Id');
           System.debug('得到QuoteID-->'+QuoteID);
         quote =[Select id,OpportunityId,Pricebook2id, pricebook2.Name from Quote where Id =:QuoteID];
        System.debug('得到quote对象-->'+quote);
        
         opp = [Select  Id, Name, pricebook2id,Trade_Term__c, pricebook2.Name,
               amount,Region__c,RecordType.Name,RecordTypeId from Opportunity where id =:quote.OpportunityId];
        loadQuote(quote.id);
        loadProducts();
        loadCatalog();
        idToDelete = null;
        
        if ( quote.pricebook2id == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                'You must choose a pricebook before adding products.'
            ));
        }
    }


    public List<currentProductsItem> currentProducts { get; set; }
    public List<pricebookentryTableItem> catalog { get; set; }

 

    public void loadQuote(ID QuoteID) {
              String [] accessFields = new String [] {'Id',
                                             'Name',
                                             'pricebook2id'
                 // , 'amount'
                  };
      Map<String,Schema.SObjectField> m = Schema.SObjectType.Quote.fields.getMap();
      for (String fieldToCheck : accessFields) {
        if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
          'Insufficient access')); 
          return;
        }
      }
      quote = [ Select Id, Name,pricebook2id,RecordType.Name, pricebook2.Name
              From Quote
              Where id = :QuoteID
            ];
        }
    /*
    public void loadOpportunity(ID OpportunityID) {
      String [] accessFields = new String [] {'Id',
                                             'Name',
                                             'pricebook2id',
                                             'amount'};
      Map<String,Schema.SObjectField> m = Schema.SObjectType.Opportunity.fields.getMap();
      for (String fieldToCheck : accessFields) {
        if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
          'Insufficient access')); 
          return;
        }
      }
      opp = [ Select Id, Name, pricebook2id, pricebook2.Name,
               amount,Region__c,RecordType.Name,RecordTypeId
              From Opportunity
              Where id = :OpportunityID
            ];
    }
    */
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
      if (quote.RecordType.Name == 'USA') {
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
                  product2.Family, 
                  product2.Cable_Length__c,
                  product2.Maximum_Power_at_STC_Pmax__c,
                  Product2.Maximum_Power_at_Current_Imp_A__c ,
                  Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                  product2.IsActive,
                  Product2.CreatedDate,
                  Product2.SAP_Materiel_No__c,
                  product2.Applicable_Area__c,
                  Product2.Cell_Type__c
                  from pricebookentry
                  where isactive = true and isdeleted = false
                  and pricebook2id = :quote.pricebook2id                 
                  and CurrencyIsoCode = : quote.CurrencyIsoCode
                  and product2.Applicable_Area__c =: 'USA'   
                  Limit 950

                  //and Product2.RecordType.Name = 'Watt-based'
                  //order by product2.Maximum_Power_at_STC_Pmax__c desc
                 ] ) {

                     catalog.add(new pricebookentryTableItem(p));
                     system.debug('======>>:' + catalog.size());
                    
             }
        }else
        {
            system.debug('非美国');
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
                  product2.Family, 
                  product2.Cable_Length__c,
                  product2.Maximum_Power_at_STC_Pmax__c,
                  Product2.Maximum_Power_at_Current_Imp_A__c ,
                  Product2.Maximum_Power_at_Voltage_Vmp_V__c ,
                  product2.IsActive,
                  Product2.CreatedDate,
                  Product2.SAP_Materiel_No__c,
                  product2.Applicable_Area__c,
                  Product2.Cell_Type__c
                  from pricebookentry
                  where isactive = true and isdeleted = false
                  and pricebook2id = :quote.pricebook2id                 
                  and CurrencyIsoCode = : quote.CurrencyIsoCode                  
                   Limit 950
                 ] ) {


                     catalog.add(new pricebookentryTableItem(p));
                     system.debug('======>>:' + catalog.size());
                    
             }
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
      Map<String,Schema.SObjectField> m = Schema.SObjectType.QuoteLineItem.fields.getMap();
      for (String fieldToCheck : accessFields) {
        if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
          '333333333333333Insufficient access')); 
          return;
        }
      }

      currentProducts = new List<currentProductsItem>();  
        for ( QuoteLineItem oli : 
             [ Select id, 
              PricebookEntry.Name, 
              PricebookEntry.Product2.Cable_Length__c, 
              PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c, 
              PricebookEntry.Product2.Maximum_Power_at_Current_Imp_A__c,
              PricebookEntry.Product2.IsActive,
              PricebookEntry.ProductCode,  
              ServiceDate, 
              UnitPrice, 
              ListPrice,
              TotalPrice,
              Quantity,
              MP__c,
              Battery_Type__c,         
              Wire_Length__c,
              ConnectorLine__c, 
              Type_of_module__c, 
              Color_of_Module__c, 
              Special_required__c, 
              Bus_bars_of_cell__c,
              Guaranteed_Delivery_Date__c , 
              Guaranteed_Delivery_Date_japan__c,
              Expected_Delivery_Date__c,
              Expected_Delivery_Date_ETA__c,
              Estimated_Time_of_Departure_ETD__c,
              Estimated_Time_of_Departure_ETD_7__c,
              Special_Label__c,
              Certification__c, 
              Estimated_Time_of_Departure__c, 
              EVA__c, 
              Power_W__c, 
              Total_MW__c, 
              FOB_Sales_Price__c,
              Cell_Appearance__c,
              Grade__c,               
              Junction_Box__c, 
              Discount,
              Tolerance__c,
              Module_size__c
              From QuoteLineItem
              Where Quoteid = :Quote.id
              //and pricebook2id = : opp.pricebook2id
              //Order by PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c desc
             ]) {
                 nextTempid++; 
                 currentProducts.add(new currentProductsItem(oli,oli.TotalPrice,nextTempid));
                 system.debug('nextTempid***' + nextTempid);
                 
             }
        
        system.debug('currentProductsLOAD**' + currentProducts);  
      }
    

    public List<quoteLineItem> pullProducts() {
        List<quoteLineItem> out = new List<quoteLineItem>();
        List<currentProductsItem> newEntries = new List<currentProductsItem>();
            
        for ( currentProductsItem x : currentProducts) {
          
            if (x.isOneLineContainer  && x.RequestedContainers > 1) {          
               /* decimal palletsPerContainer = x.data.PricebookEntry.Product2.Pallets_per_40ft_Container__c;
                decimal panelsPerPallet  = x.data.PricebookEntry.Product2.Modules_per_Pallet__c;
                decimal quantityPerPanel = x.data.PricebookEntry.Product2.Watts_per_panel__c;
                if (( quantityPerPanel == null || quantityPerPanel == 0  ) || ( panelsPerPallet  == null || panelsPerPallet  == 0  ) ||
                ( palletsPerContainer == null || palletsPerContainer == 0 )) {
                    out.add(x.data); 
                } */

                /*else {  
            for (integer i=0; i<  x.RequestedContainers.round(system.roundingMode.CEILING); i++) {
                 OpportunityLineItem newOLI = x.data.clone(false,true,false,false);
                 newOLI.OpportunityID = opp.id;
                 newOLI.TotalPrice = null; // can only specify unitPrice OR totalPrice not both
                 Decimal container;
                 if((i+1) < x.RequestedContainers.round(system.roundingMode.CEILING)) {
                     container = 1;
                 } else if((i+1) ==  x.RequestedContainers.round(system.roundingMode.CEILING)) {                        
                     container  = x.RequestedContainers - i;  
               } 
                                 
                      Decimal newPallets    = container  * palletsPerContainer ;
                      Decimal newPanels     = newPallets * panelsPerPallet  ;
                      newOLI.Quantity   = newPanels * quantityPerPanel ;    
                          newOLI.watts__c = newOLI.Quantity;
                      system.debug('newOLI**' + newOLI);
                      nextTempid++;
                      currentProductsItem currentProd = new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid);
                      currentProd.QuantityInteger =  Integer.valueOf(newOLI.quantity);
                      currentProd.RequestedPanels = ( newOLI.PricebookEntry.Product2.Watts_per_panel__c > 0) ? newOLI.quantity / newOLI.PricebookEntry.Product2.Watts_per_panel__c : null; 
                      currentProd.RequestedPallets = ( newOLI.PricebookEntry.Product2.Modules_per_Pallet__c >0) ? currentProd.RequestedPanels / newOLI.PricebookEntry.Product2.Modules_per_Pallet__c : null; 
                      currentProd.RequestedContainers =  ( newOLI.PricebookEntry.Product2.Pallets_per_40ft_Container__c > 0) ? currentProd.RequestedPallets / newOLI.PricebookEntry.Product2.Pallets_per_40ft_Container__c : null; 
                      newEntries.add(currentProd);
                      out.add(newOLI); 
                  }*/
                  out.add(x.data); 
                  
                  if ( x.data.id != null ) {
                      pendingDeletes.add(new quoteLineItem(ID = x.data.id ));                   
                  }
              //}   
            } else { 
                  system.debug('x***x*' + x);
                  newEntries.add(x);
                  out.add(x.data);
            }    
        }
        system.debug('currentProducts**' + currentProducts);  
        currentProducts.clear();
        currentProducts.addAll(newEntries);        
        system.debug('currentProducts**' + currentProducts);  
        system.debug('newEntries**' + newEntries);  
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
        PageReference r = new PageReference('/' + quote.id);
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
            loadquote(quote.id);
        }
        return;
    }
    
    // Save
    
    public PageReference SaveAndReturn() {
        if ( ActuallySave() ) {
            PageReference r = new PageReference('/' + quote.id);
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
            
             upsert pullProducts();

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
                quoteLineItem newOLI = new quoteLineItem(
                     quoteId     = quote.id,
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
                      newOLI.ConnectorLine__c =map_proname.get(entry.data.Product2.Name).Connector__c; 
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
                      newOLI.Special_Label__c =map_proname.get(entry.data.Product2.Name).Special_Lable__c;
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
                
                nextTempid++;
                currentProducts.add(new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid));
                
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
              Special_required__c, 
              Bus_bars_of_cell__c,
              Special_Lable__c,
              Certification__c, 
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
                quoteLineItem newOLI = new quoteLineItem(
                     quoteId     = quote.id,
                     PricebookEntryId  = entry.data.id,
                     quantity          = 0,
                     UnitPrice         = entry.data.unitprice  // -- Need to compute discount rules first
                );
                newOLI.PriceBookEntry = entry.data;

                    if(opp.RecordType.Name =='USA' && map_proname !=null && map_proname.get(entry.data.Product2.Name) !=null){
                      newOLI.MP__c = map_proname.get(entry.data.Product2.Name).MP__c;
                      newOLI.Battery_Type__c =map_proname.get(entry.data.Product2.Name).Battery_Type__c;         
                      newOLI.Wire_Length__c =map_proname.get(entry.data.Product2.Name).Wire_Length__c;
                      newOLI.ConnectorLine__c =map_proname.get(entry.data.Product2.Name).Connector__c; 
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
                      newOLI.Special_Label__c =map_proname.get(entry.data.Product2.Name).Special_Lable__c;
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

                //newOLI.Recommended_Discount__c = 0;
                newOLI.UnitPrice = entry.data.unitprice ;//* ( 100 - newOLI.Recommended_Discount__c )/100.0;
                
                nextTempid++;
                currentProducts.add(new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid));
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
                quoteLineItem newOLI = entry.data.clone(false,true,false,false);
                newOLI.quoteID = quote.id;
             //   newOLI.TotalPrice = null;  // can only specify unitPrice OR totalPrice not both
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
                quoteLineItem newOLI = entry.data.clone(false,true,false,false);
                newOLI.quoteID = quote.id;
              //  newOLI.TotalPrice = null;  // can only specify unitPrice OR totalPrice not both
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
        
    List<quoteLineItem> pendingDeletes = new List<quoteLineItem>();
    
    
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
  

                quoteLineItem newOLI = currentProducts[x].data.clone(false,true,true,false);
                newOLI.PricebookEntryId    = newPricebookentry.id;
                newOLI.PricebookEntry      = newPricebookentry;
                newOLI.quoteID       = quote.id;
                //newOLI.TotalPrice          = null;  // can only specify unitPrice OR totalPrice not both


                nextTempid++;
                newEntry = new currentProductsItem(newOLI, newOLI.UnitPrice, nextTempid);

                // Check to see if the item being replaced exists in the DB or not
                // If so, add to pending deletes so that it can be deleted when
                // the user clicks Save or Quick Save
                if ( currentProducts[x].data.id != null ) {
                    pendingDeletes.add(new quoteLineItem(ID = currentProducts[x].data.id ));
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
    webservice static void sync(String  quoteid){

    ID Oppid;//业务机会ID



    if(Quoteid!=null){
       Quote q =[select id,Opportunityid from quote where id =: quoteid];
        Oppid = q.Opportunityid;
        List<QuoteLineItem> QLst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.QuoteLineItem) + ' ' +
                                  'where Quoteid =: quoteid');
        //得到改报价单下 所有的报价行
        List<opportunityLineItem> oppLst = [select id from opportunityLineItem where Opportunityid =:Oppid];
        //得到业务机会下 所有的业务机会产品
         List<opportunityLineItem> deleteoppitem =new List<opportunityLineItem>();
       if(oppLst.size()>0){
           for(opportunityLineItem oppitem:oppLst){
           deleteoppitem.add(oppitem);
           }
           delete deleteoppitem;
           //删除业务机会下 所有的业务机会产品
           }
        List<opportunityLineItem> OitemLst = new List<opportunityLineItem>();
        for(QuoteLineItem qitem:QLst){
            system.debug('qitem-->'+qitem.Cell_Type__c);
            opportunityLineItem oppit =new opportunityLineItem();
            oppit.Opportunityid=Oppid;
            oppit.Product2id=qitem.Product2id;
            oppit.Quantity=qitem.Quantity;
            oppit.Battery_Type__c=qitem.Battery_Type__c;
            oppit.UnitPrice=qitem.UnitPrice;
            oppit.MP__c=qitem.MP__c;
            oppit.Certification__c=qitem.Certification__c;
            oppit.Wire_Length__c=qitem.Wire_Length__c;
            oppit.ConnectorLine__c=qitem.ConnectorLine__c;
            oppit.Type_of_module__c=qitem.Type_of_module__c;
            oppit.Grade__c=qitem.Grade__c;
            oppit.Color_of_Module__c=qitem.Color_of_Module__c;
            oppit.Special_required__c=qitem.Special_required__c;
            oppit.Bus_bars_of_cell__c=qitem.Bus_bars_of_cell__c;
            oppit.Guaranteed_Delivery_Date__c=qitem.Guaranteed_Delivery_Date__c;
            oppit.Guaranteed_Delivery_Date_japan__c=qitem.Guaranteed_Delivery_Date_japan__c;
            oppit.Expected_Delivery_Date__c=qitem.Expected_Delivery_Date__c;
            oppit.FOB_Sales_Price__c=qitem.FOB_Sales_Price__c;
  OitemLst.add(oppit);
        }
                insert OitemLst;   
    }


            
            
            
            
        }
    
    public void loadPage() {    
   }

    /*
    * -------------------------------------------------------------------------------------
    *    end of class
    * -------------------------------------------------------------------------------------
    */


}