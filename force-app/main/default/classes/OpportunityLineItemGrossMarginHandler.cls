public without sharing class OpportunityLineItemGrossMarginHandler {
    public List<OpportunityLineItem> items;
    public List<OrderItem> Orderitems;
    public List<OpportunityLineItem> existItems;
    public List<OrderItem> OrderexistItems;
    public List<Product_Detail__c> contractItems;
    public List<Product_Detail__c> existContractItems;
    Set<String> headerIds = new Set<String>();
    public Map<Id, Opportunity> opportunityIdMap;
    public Map<Id, order> orderIdMap;
    public Map<String, List<OpportunityLineItem>> oppIdItemsMap = new Map<String, List<OpportunityLineItem>>();
    public Map<String, List<OrderItem>> orderIdItemsMap = new Map<String, List<OrderItem>>();
    public Map<String, List<Product_Detail__c>> contractIdItemsMap = new Map<String, List<Product_Detail__c>>();
    public Map<Id, Contract> contractIdMap;
    public Map<Id, List<Payment__c>> opportunityIdPaymentsMap;
    public Map<Id, List<Payment__c>> orderIdPaymentsMap;
    public Set<String> productModules = new Set<String>();
    public static decimal daguiY ;
    public static decimal xiaoguiY ;
    public static decimal unitWY ;
    public static String AverageY ;
    public static List<OpportunityLineItem> outY;
    public Map<String, Double> codeRateMap;
    public Map<String, Port_freight_maintenance__c> portFreightNameMap;
    public Map<String, Port_freight_maintenance__c> countryFreightNameMap;

    public static Boolean skipTrigger = false;
    public static Set<Id> containerNeedChangeIds = new Set<Id>();
    public static Set<Id> oceanNeedChangeIds = new Set<Id>();
    public static Set<Id> landNeedChangeIds = new Set<Id>();
    public static Map<Id,OpportunityLineItem> NewProductItemMaps = new Map<Id,OpportunityLineItem>();
    
    public OpportunityLineItemGrossMarginHandler () {}

    public OpportunityLineItemGrossMarginHandler (Map<Id, Opportunity> opportunityIdMap) {
        // OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        Set<Id> opportunityId = new Set<Id>();
        for (Opportunity o : opportunityIdMap.values()){
            if (o.MOU_Type_Judgment__c == false) {
                opportunityId.add(o.Id);
            }
        }
        this.items = [
            SELECT Id, Product_name__c
            FROM OpportunityLineItem
            WHERE OpportunityId IN :opportunityId];
        if (this.items.size() == 0) return;
        update this.items;
    }
    public OpportunityLineItemGrossMarginHandler (Map<Id, Order> orderIdMap  ) {
        // OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        Set<Id> orderId = new Set<Id>();
        for (order o : orderIdMap.values()){  orderId.add(o.Id); }
        this.Orderitems = [
            SELECT Id, Product_name__c
            FROM Orderitem
            WHERE OrderId IN :orderId];
        if (this.Orderitems.size() == 0) return; update this.Orderitems;
    }
    public OpportunityLineItemGrossMarginHandler (Map<Id, Contract> contractIdMap) {
        // OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        this.contractItems = [
            SELECT Name
            FROM Product_Detail__c
            WHERE Contract_PO_PI__c IN :contractIdMap.keySet()];
        if (this.contractItems.size() == 0) return; update this.contractItems;
    }

    public OpportunityLineItemGrossMarginHandler (List<OpportunityLineItem> items) {
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        this.items = new List<OpportunityLineItem>();
        this.items.addAll(items);
        Set<String> oppItemsExistIds = new Set<String>();
        for (OpportunityLineItem item : items) {
            oppItemsExistIds.add(item.Id);
            headerIds.add(item.OpportunityId);
        }
        this.existItems = [
            SELECT Id,
                   OpportunityId,
                   UnitPrice,
                   CurrencyIsoCode,
                   Quantity,
                   Product_name__c,
                   Guaranteed_Delivery_Date__c,
                   Product_Type__c,
                   Product_Module__c,
                   MX_Cost_Per_W__c,
                   Back_Sheet_Color_Additional_Cost_Per_W__c,
                   Frame_Color_Additional_Cost_Per_W__c,
                   Power_W__c
            FROM OpportunityLineItem 
            WHERE OpportunityId IN :headerIds
            AND Id NOT IN :oppItemsExistIds];

        if (this.existItems != null) this.items.addAll(this.existItems);
        for (OpportunityLineItem item : this.items) {
            this.productModules.add(item.Product_Module__c);
            if (oppIdItemsMap.containsKey(item.OpportunityId)) oppIdItemsMap.get(item.OpportunityId).add(item);
            else oppIdItemsMap.put(item.OpportunityId, new List<OpportunityLineItem>{item});
        }
        calculateGrossMargin();
    }
    public OpportunityLineItemGrossMarginHandler (List<Product_Detail__c> items) {
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        this.contractItems = new List<Product_Detail__c>();
        this.contractItems.addAll(items);
        Set<String> contractItemsExistIds = new Set<String>();
        for (Product_Detail__c item : items) {
            contractItemsExistIds.add(item.Id);
            headerIds.add(item.Contract_PO_PI__c);
        }
        this.existContractItems = [
            SELECT Id,
                   Contract_PO_PI__c,
                   Payment_Cost_Per_W__c,
                   Insurence_Cost_Per_W__c,
                   Freight_Cost_Per_W__c,
                   Technology_Cost_Per_W__c,
                   Product_Cost__c,
                   Commision_Rebate_Cost_Per_W__c,
                   Estimated_Gross_Margin__c,
                   Confirmed_Gross_Margin__c,
                   Total_Gross_Margin__c,
                   Unit_Price__c,
                   CurrencyIsoCode,
                   Unit_WM__c,
                   Quantity__c,
                   Free_Power_W__c,
                   Third_Party_Test_Cost__c,
                   Transfer_Stock_Rate__c,
                   Special_Material_Cost_Per_W__c,
                   Additional_Cost_Per_W__c,
                   MX_Cost_Per_W__c,
                   Total_W__c
            FROM Product_Detail__c 
            WHERE Contract_PO_PI__c IN :headerIds
            AND Id NOT IN :contractItemsExistIds];

        if (this.existContractItems != null) this.contractItems.addAll(this.existContractItems);
        for (Product_Detail__c item : this.contractItems) {
            if (contractIdItemsMap.containsKey(item.Contract_PO_PI__c)) contractIdItemsMap.get(item.Contract_PO_PI__c).add(item);
            else contractIdItemsMap.put(item.Contract_PO_PI__c, new List<Product_Detail__c>{item});
        }
        calculateContractGrossMargin();
    }

        //Snake
    
    public OpportunityLineItemGrossMarginHandler (List<OrderItem> items) {
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        this.Orderitems = new List<OrderItem>();
        this.Orderitems.addAll(items);
        Set<String> orderItemsExistIds = new Set<String>();
        for (OrderItem item : items) {
            orderItemsExistIds.add(item.Id);
            headerIds.add(item.OrderId);
        }
        this.orderexistItems = [
            SELECT Id,
                   orderId,
                   UnitPrice,
                   CurrencyIsoCode,
                   Quantity,
                   Product_Name__c,
                   Guaranteed_Delivery_Date__c,
                   Product_Type__c,
                   Product_Module__c,
                   MX_Cost_Per_W__c,
                   Power_W__c
            FROM OrderItem 
            WHERE orderId IN :headerIds
            AND Id NOT IN :orderItemsExistIds];

        if (this.OrderexistItems != null) this.orderitems.addAll(this.orderexistItems);
        for (OrderItem item : this.orderitems) {
            this.productModules.add(item.Product_Module__c);
            if (orderIdItemsMap.containsKey(item.orderId)) orderIdItemsMap.get(item.OrderId).add(item);
            else orderIdItemsMap.put(item.OrderId, new List<OrderItem>{item});
        }
        calculateorderGrossMargin();
    }

    // Get Opportunity's insurence, freight, commission
    public Map<Id, Opportunity> getOpportunityIdMap () {
        if (this.opportunityIdMap == null){
            this.opportunityIdMap = new Map<Id, Opportunity>([
                SELECT Id,
                       Number_of_Containers__c,
                       Number_of_Small_Containers__c,
                       Land_Freight_China__c,
                       Ocean_Freight__c,
                       Ocean_Freight_Oversea__c,
                       Land_Freight_Oversea__c,
                       Region__c,
                       Destination_Port__c,
                       Destination_Country__c,
                       Trade_Term__c,
                       Local_Warehouse__c,
                       Warehouse_Premium__c,
                       Logistic_Special_Cost_Per_W__c,
                       Warranty_Insurance__c,
                       Commission_Type__c,
                       Commision__c,
                       Discount_Type__c,
                       Discount_new__c,
                       Total_Power__c,
                       Rebate_new__c,
                       Rebate_Type_new__c,
                       MOU_Type_Judgment__c,
                       Rate__c,
                       CurrencyIsoCode,
                       OwnerId,
                       Total_Price__c
                FROM Opportunity 
                WHERE Id IN :headerIds
                AND MOU_Type_Judgment__c = false]);
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.opportunityIdMap;
    }
            //Snake
        
    public Map<Id, order> getOrderIdMap () {
        if (this.orderIdMap == null){
            this.orderIdMap = new Map<Id, order>([
                SELECT Id,
                       Land_Freight_China__c,
                       Ocean_Freight_china__c,
                       Ocean_Freight_Oversea__c,
                       Land_Freight_Oversea__c,
                       Region__c,
                       Destination_Port__c,
                       Destination_Country__c,
                       Trade_Term__c,
                       Local_Warehouse__c,
                       Warehouse_Premium__c,
                       Logistic_Special_Cost_Per_W__c,
                       Warranty_Insurance__c,
                       Commission_Type__c,
                       Commission__c,
                       Discount_Type__c,
                       Discount_new__c,
                       Total_MW__c,
                       Rebate_new__c,
                       Rebate_Type__c,
                       Rate__c,
                       CurrencyIsoCode,
                       OwnerId,
                       Total_Price__c
                FROM order 
                WHERE Id IN :headerIds]);
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.orderIdMap;
    }
    
    public Map<Id, Contract> getContractIdMap () {
        Set<String> contractIds = new Set<String>();
        for(Product_Detail__c item : this.contractItems){
            contractIds.add(item.Contract_PO_PI__c);
        }
        if (this.contractIdMap == null){
            this.contractIdMap = new Map<Id, Contract>([
                SELECT Id,
                       Land_Freight_China__c,
                       Ocean_Freight__c,
                       Ocean_Freight_Oversea__c,
                       Land_Freight_Oversea__c,
                       Region__c,
                       Destination_Port__c,
                       Destination_Country__c,
                       Trade_term__c,
                       CurrencyIsoCode,
                       Warehouse_Premium__c,
                       Logistic_Special_Cost_Per_W__c,
                       Total_MW__c,
                       Local_Warehouse__c,
                       Total_Price__c
                FROM Contract 
                WHERE Id IN :contractIds]);
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.contractIdMap;
    }

    public Map<String, Double> getCodeRateMap() {
        if (this.codeRateMap == null) {
            this.codeRateMap = new Map<String, Double>();
            for (CurrencyType ct : [SELECT IsoCode,
                                           ConversionRate
                                    FROM CurrencyType]){
                this.codeRateMap.put(ct.IsoCode, ct.ConversionRate);
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.codeRateMap;
    }

    public Map<Id, List<Payment__c>> getOpportunityIdPaymentsMap() {
        if (this.opportunityIdPaymentsMap == null){
            this.opportunityIdPaymentsMap = new Map<Id, List<Payment__c>>();
            for (Payment__c payment : [SELECT Id,
                                              Down_Balance_Payment__c,
                                              Percentage__c,
                                              Payment_Method__c,
                                              Days__c,
                                              Opportunity__c
                                       FROM Payment__c
                                       WHERE Down_Balance_Payment__c = 'Balance Payment'
                                       AND Opportunity__c IN :headerIds]) {
                if (this.opportunityIdPaymentsMap.containsKey(payment.Opportunity__c)) this.opportunityIdPaymentsMap.get(payment.Opportunity__c).add(payment);
                else this.opportunityIdPaymentsMap.put(payment.Opportunity__c, new List<Payment__c>{payment});
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.opportunityIdPaymentsMap;
    }
        //Snake
        
    public Map<Id, List<Payment__c>> getOrderIdPaymentsMap() {
        if (this.orderIdPaymentsMap == null){
            this.orderIdPaymentsMap = new Map<Id, List<Payment__c>>();
            for (Payment__c payment : [SELECT Id,
                                              Down_Balance_Payment__c,
                                              Percentage__c,
                                              Payment_Method__c,
                                              Days__c,
                                             order__c,
                                              Opportunity__c
                                       FROM Payment__c
                                       WHERE Down_Balance_Payment__c = 'Balance Payment'
                                       AND Order__c IN :headerIds]) {
                if (this.orderIdPaymentsMap.containsKey(payment.order__c)) this.orderIdPaymentsMap.get(payment.order__c).add(payment);
                else this.orderIdPaymentsMap.put(payment.order__c, new List<Payment__c>{payment});
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.orderIdPaymentsMap;
    }

    // 1. payment term
    // Total $ * % * rate (1.2% / 3%/ 5%) / 365 * days / W
    public Decimal getPaymentCostByOpportunity (Opportunity opportunity, OpportunityLineItem item) {
        Decimal paymentCost = 0;
        List<Payment__c> payments = getOpportunityIdPaymentsMap().get(opportunity.Id);
        if (payments != null) {
            for (Payment__c payment : payments) {
                // Decimal term = payment.Percentage__c / 100 * opportunity.Total_Price__c * payment.Days__c / 365 / opportunity.Total_Power__c;
                Decimal term = payment.Percentage__c / 100 * item.UnitPrice * payment.Days__c / 365;
                if (payment.Payment_Method__c == 'L/C') paymentCost += term * 0.03;
                else paymentCost += term * 0.05;
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return paymentCost;
    }
        
    public Decimal getPaymentCostByOrder (Order order, OrderItem item) {
        Decimal paymentCost = 0;
        List<Payment__c> payments = getOrderIdPaymentsMap().get(order.Id);
        if (payments != null) {
            for (Payment__c payment : payments) {
                // Decimal term = payment.Percentage__c / 100 * opportunity.Total_Price__c * payment.Days__c / 365 / opportunity.Total_Power__c;
                Decimal term = payment.Percentage__c / 100 * item.UnitPrice * payment.Days__c / 365;
                if (payment.Payment_Method__c == 'L/C') paymentCost += term * 0.03;
                else paymentCost += term * 0.05;
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return paymentCost;
    }

    // 2. insurence
    // 0.001
    public Decimal getInsurenceCostByItem (Opportunity opportunity, OpportunityLineItem item) {
        Decimal insurenceCost = 0;
        insurenceCost = item.UnitPrice * 0.01;
        return insurenceCost;
    }
        //Snake
        
    public Decimal getInsurenceCostByOrderItem (Order order, OrderItem item) {
        Decimal insurenceCost = 0;
        insurenceCost = item.UnitPrice * 0.01;
        return insurenceCost;
    }

    public Map<String, Port_freight_maintenance__c> getPortNameMap (String type) {
        if (this.portFreightNameMap == null || this.countryFreightNameMap == null) {
            this.portFreightNameMap = new Map<String, Port_freight_maintenance__c>();
            this.countryFreightNameMap = new Map<String, Port_freight_maintenance__c>();
            for (Port_freight_maintenance__c port : [SELECT Name, 
                                                            Warehouse_Premium__c,
                                                            Type__c,
                                                            Warehouse_Premium_Small__c,
                                                            Land_Freight_Oversea__c
                                                     FROM Port_freight_maintenance__c]) {
                // Decimal containerPrice = port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
                if (port.Type__c == 'port') this.portFreightNameMap.put(port.Name, port);
                else if (port.Type__c == 'country') this.countryFreightNameMap.put(port.Name, port);
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        if (type == 'port') return this.portFreightNameMap;
        else if (type == 'country') return this.countryFreightNameMap;
        else return new Map<String, Port_freight_maintenance__c>();
    }

    public Map<String, Integer> regionContainerPowerMap = new Map<String, Integer>{
        'EU(Union)' => 238000,
        'EU(Non-Eu)' => 238000,
        'ROA' => 216088,
        'North Asia' => 221300,
        'South Asia' => 207495,
        'North America' => 234633,
        'Middle East&Africa' => 215790,
        'MENA' => 215790,
        'SSA' => 215790,
        'Latin America&Italy' => 218400,
        'Central Asia' => 207495
    };

    // 3. freight
    //  a. freight
    //  b. warehouse
    //  c. special
    public void setFreightCostByOpportunity (List<Opportunity> opportunities) {
        for (Opportunity o : opportunities) {
            this.getFreightCostByOpportunity(o, true, true);
        }
    }

    public Decimal getFreightCostByOpportunity (Opportunity opportunity, Boolean itemFlag, Boolean isInsert) {
        System.debug('----getFreightCostByOpportunity----');
         Decimal freightCost = 0;
        Boolean Emailflag = false;
        Decimal totalPower = getOppIdPowerMap().containsKey(opportunity.Id) ? getOppIdPowerMap().get(opportunity.Id) : opportunity.Total_Power__c; 
        Integer regionContainerPower = regionContainerPowerMap.get(opportunity.Region__c);

        // land China
        // Decimal landChina = opportunity.Land_Freight_China__c != null ? opportunity.Land_Freight_China__c : 0;
        Decimal landChina = 0;
        Double SmallC= 0;
        Double BigC= 0;
        Double BigContain = 0;
        Double SmallContain = 0;
        Double Quan = 0;
        Double bic = 0;
        Double totalW = 0;
        // ocean
        Port_freight_maintenance__c port = getPortNameMap('port').get(opportunity.Destination_Port__c);
        Decimal containerPrice = port != null && port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
        Decimal oceanChina = opportunity.Ocean_Freight__c != null ? opportunity.Ocean_Freight__c : 0;
        Decimal dagui = opportunity.Number_of_Containers__c != null ? opportunity.Number_of_Containers__c : 0;
        if(daguiY!=null){dagui=daguiY;}
        system.debug('20201216'+dagui);
        Decimal xiaogui = opportunity.Number_of_Small_Containers__c != null ? opportunity.Number_of_Small_Containers__c : 0;
        System.debug('xiaogui--->'+xiaogui);
        if(xiaoguiY!=null){xiaogui=xiaoguiY;}
        system.debug('20201216-->'+xiaogui);
        Decimal oceanOversea = opportunity.Ocean_Freight_Oversea__c != null ? opportunity.Ocean_Freight_Oversea__c : 0;
        List<OpportunityLineItem> out = [Select id,quantity,PricebookEntry.name,PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c from OpportunityLineItem where OpportunityId =:opportunity.id];
        if(outY!=null){out=outY;}
        List<Product_Container__c> oc = [Select id,X20_foot_flat_cabinet__c,X40_foot_flat_cabinet__c,Short_Name__c,Germany_Short_Name__c from Product_Container__c];
        Map<String,Product_Container__c> pcList = new Map<String,Product_Container__c>();
        for(Product_Container__c o :oc){
            pcList.put(o.Short_Name__c,o);
            if(o.Germany_Short_Name__c !=null){
                pcList.put(o.Germany_Short_Name__c,o);
            }
        }
        Set<String> pcKey = pcList.keySet();
        system.debug('pcKey'+pcKey);
        if (oceanNeedChangeIds.contains(opportunity.Id)  || isInsert) {
            /*if (regionContainerPower != null && opportunity.Region__c!='Middle East&Africa') oceanChina = containerPrice / regionContainerPower;
            else oceanChina = 0;*/
            
            for(OpportunityLineItem o:out){
                Boolean flags = true;
               for(String p:pcKey){ 
                    
            system.debug('out'+o);
             
             if((o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endswith(p)) || (o.PricebookEntry.name.Startswith('MM')&&o.PricebookEntry.name.endswith(p))){
                 if(NewProductItemMaps.get(o.id) !=null){
                     o.Quantity = NewProductItemMaps.get(o.id).Quantity;
                 }
                 system.debug(p);
                 flags = false;
                Quan += o.Quantity;
                Product_Container__c pcs =  pcList.get(p);
                system.debug('pcs'+pcs);
                BigContain += pcs.X40_foot_flat_cabinet__c;
                SmallContain += pcs.X20_foot_flat_cabinet__c;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
                
                 system.debug('Quan'+Quan);
                 system.debug('Quan'+BigContain);
                 system.debug('Quan'+SmallContain);
                 system.debug('Quan'+totalW);
            }/*else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-72HLM')){
                Quan += o.Quantity;
                BigContain += 682.0;
                SmallContain += 155.0;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
            }else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-72HLM-BDVP')){
                system.debug('1111');
                Quan += o.Quantity;
                system.debug('Quan'+Quan);
                BigContain += 700.0;
                system.debug('BigContain'+BigContain);
                SmallContain += 175.0;
                system.debug('SmallContain'+SmallContain);
                system.debug('Quantity'+o.Quantity);
                //system.debug('o.Product2.Maximum_Power_at_STC_Pmax__c'+o.Product2.Maximum_Power_at_STC_Pmax__c);
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
                system.debug('Quan'+Quan);
                system.debug('BigContain'+BigContain);
                system.debug('SmallContain'+SmallContain);
                system.debug('totalW'+totalW);
            }else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-60HL4')){
                Quan += o.Quantity;
                BigContain += 840.0;
                SmallContain += 210.0;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
            }else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-6TL4')){
                Quan += o.Quantity;
                BigContain += 840.0;
                SmallContain += 210.0;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
            }else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-7TL4')){
                Quan += o.Quantity;
                BigContain += 620.0;
                SmallContain += 155.0;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
            }else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-72HL4')){
                Quan += o.Quantity;
                BigContain += 620.0;
                SmallContain += 155.0;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
            }else if(o.PricebookEntry.name.Startswith('JKM')&&o.PricebookEntry.name.endsWith('M-7RL4')){
                Quan += o.Quantity;
                BigContain += 496.0;
                SmallContain += 124.0;
                totalW +=(o.Quantity*o.PricebookEntry.Product2.Maximum_Power_at_STC_Pmax__c);
            }*//*else{
                BigContain = 0;
                SmallContain = 0;
                //totalW =0;
                system.debug('1');
                //break;
            }*/
           }
                if(flags == true){
                    BigContain = -1;
                SmallContain = -1;
                    SmallC = 0;
                    BigC = 0;
                     xiaogui = 0;
                    dagui = 0;
                    oceanChina = 0;
                    
                    
                //totalW =0;
                system.debug('1');
                break;
                }
                System.debug('xiaogui--->'+xiaogui);
          }
            system.debug('BigContain'+BigContain);
            if(BigContain!=-1&&out.size()!=0){
                if(opportunity.Region__c =='North America'||(port!=null&&port.Warehouse_Premium_Small__c==null)){
                    BigC = BigContain/out.size();//大柜平均数
                    Double BigCons = Quan/BigC;//大柜柜数
                    if(daguiY==null) {dagui = Math.ceil(BigCons);}
                    if(xiaoguiY==null) {xiaogui = 0;}
                     System.debug('xiaogui--->'+xiaogui);
                }else{
                SmallC = SmallContain/out.size();//小柜平均数
                BigC = BigContain/out.size();//大柜平均数
                Double BigCons = Quan/BigC;//大柜柜数
                    if(daguiY==null) {dagui = Math.floor(BigCons);} //大柜柜数整数
                system.debug('SmallC'+SmallC);
                system.debug('BigC'+BigC);
                system.debug('BigCons'+BigCons);
                system.debug('dagui'+dagui);
                //小柜柜数
                if(BigCons>1){
                    system.debug('Quan'+Quan);
                    system.debug('dagui'+(dagui*BigC));
                    system.debug('SmallC'+SmallC);
                    System.debug('(Quan-(dagui*BigC))/SmallC'+((Quan-(dagui*BigC))/SmallC));
                    if(xiaoguiY==null) { xiaogui = Math.ceil((Quan-(dagui*BigC))/SmallC);}
                     System.debug('xiaogui--->'+xiaogui);
                }
                if(BigCons<1){
                   Double SmallCons = Quan/SmallC;//柜数
                    if(xiaoguiY==null) {xiaogui = Math.ceil(SmallCons);}
                    system.debug('bic'+bic);
                     System.debug('xiaogui--->'+xiaogui);
               }
                }
            }
            
            system.debug('xiaogui'+xiaogui);
            Double daguichengben = 0;
            if(port!=null&&port.Warehouse_Premium__c!=null){
                daguichengben = port.Warehouse_Premium__c*dagui;//总成本
            }
            system.debug('totalW'+totalW);
            system.debug('daguichengben'+daguichengben);
            system.debug(xiaogui);
            Double xiaoguichengben = 0;
            if(port!=null&&port.Warehouse_Premium_Small__c!=null){
             xiaoguichengben = port.Warehouse_Premium_Small__c*xiaogui;//小柜成本
            }
            system.debug('xiaoguichengben'+xiaoguichengben);
            if(totalW!=0&&totalW!=null){
            oceanChina = (daguichengben+xiaoguichengben)/totalW;
            }
        } 
        System.debug('--------oceanChina : ' + oceanChina);

        // land Oversea
        Port_freight_maintenance__c countryFreight = getPortNameMap('country').get(opportunity.Destination_Country__c);
        Decimal landOversea = opportunity.Land_Freight_Oversea__c != null ? opportunity.Land_Freight_Oversea__c : 0;
        if (landNeedChangeIds.contains(opportunity.Id) || isInsert) {
            if (countryFreight != null && countryFreight.Land_Freight_Oversea__c != null) landOversea = countryFreight.Land_Freight_Oversea__c ;
            else landOversea = 0;
        }
        System.debug('--------landOversea : ' + landOversea);
           if(xiaogui>1){
              dagui = dagui+1;   
              xiaogui = 0; 
            }
        if (new List<String>{'CFR', 'CIF', 'CIP', 'CPT', 'DAT'}.contains(opportunity.Trade_Term__c)) {
            System.debug('CFR, CIF, CIP, CPT, DAT');
            freightCost += landChina + oceanChina + oceanOversea;
            if(opportunity.Region__c != 'Middle East&Africa' && opportunity.Region__c != 'MENA' && opportunity.Region__c != 'SSA')
            {opportunity.Ocean_Freight__c = oceanChina;}
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;
            opportunity.Land_Freight_Oversea__c = null;
            opportunity.Number_of_Containers__c = dagui;
            opportunity.Number_of_Small_Containers__c = xiaogui;
            opportunity.Average_capacity_of_Containers__c = String.valueOf(SmallC)+';'+String.valueOf(BigC);
            if ((oceanChina == 0 || oceanOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'DAP', 'DDP', 'DPU', 'DDU'}.contains(opportunity.Trade_Term__c)) {
            System.debug('DAP, DDP, DPU, DDU');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            if(opportunity.Region__c != 'Middle East&Africa' && opportunity.Region__c != 'MENA' && opportunity.Region__c != 'SSA')
            {opportunity.Ocean_Freight__c = oceanChina;}
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;
            opportunity.Land_Freight_Oversea__c = landOversea;
            opportunity.Number_of_Containers__c = dagui;
            opportunity.Number_of_Small_Containers__c = xiaogui;
            opportunity.Average_capacity_of_Containers__c = String.valueOf(SmallC)+';'+String.valueOf(BigC);
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'FCA'}.contains(opportunity.Trade_Term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(opportunity.Local_Warehouse__c)) {
            System.debug('FCA Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            if(opportunity.Region__c != 'Middle East&Africa' && opportunity.Region__c != 'MENA' && opportunity.Region__c != 'SSA')
            {opportunity.Ocean_Freight__c = oceanChina;}
            opportunity.Ocean_Freight_Oversea__c = oceanOversea; opportunity.Land_Freight_Oversea__c = landOversea;
            opportunity.Number_of_Containers__c = dagui;opportunity.Number_of_Small_Containers__c = xiaogui;  
            opportunity.Average_capacity_of_Containers__c = String.valueOf(SmallC)+';'+String.valueOf(BigC);
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'EXW'}.contains(opportunity.Trade_Term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(opportunity.Local_Warehouse__c)) {
            System.debug('EXW Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            if(opportunity.Region__c != 'Middle East&Africa' && opportunity.Region__c != 'MENA' && opportunity.Region__c != 'SSA')
            {opportunity.Ocean_Freight__c = oceanChina;}
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;  opportunity.Land_Freight_Oversea__c = landOversea;
            opportunity.Number_of_Containers__c = dagui;opportunity.Number_of_Small_Containers__c = xiaogui; 
            opportunity.Average_capacity_of_Containers__c = String.valueOf(SmallC)+';'+String.valueOf(BigC);
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'FOB', 'FCA'}.contains(opportunity.Trade_Term__c)) {
            System.debug('FOB, FCA');
            freightCost += landChina;
            //opportunity.Ocean_Freight__c = null;
            //opportunity.Ocean_Freight_Oversea__c = null;opportunity.Land_Freight_Oversea__c = null;
            opportunity.Number_of_Containers__c = null; opportunity.Number_of_Small_Containers__c = null;
        } else {
            System.debug('other(EXW)');
            //opportunity.Ocean_Freight__c = null; opportunity.Ocean_Freight_Oversea__c = null;
            //opportunity.Land_Freight_Oversea__c = null; 
            opportunity.Number_of_Containers__c = null; opportunity.Number_of_Small_Containers__c = null;
        }

        System.debug('----containerNeedChangeIds: ' + containerNeedChangeIds);
        if (totalPower == null || totalPower == 0) return 0;
        /*if (containerNeedChangeIds.contains(opportunity.Id) && regionContainerPowerMap.containsKey(opportunity.Region__c)){
            opportunity.Number_of_Containers__c = dagui;
            opportunity.Number_of_Small_Containers__c = xiaogui; 

        }*/

        Decimal warehouseCost = opportunity.Warehouse_Premium__c != null ? opportunity.Warehouse_Premium__c : 0;
        freightCost += warehouseCost;

        Decimal specialCost = opportunity.Logistic_Special_Cost_Per_W__c != null ? opportunity.Logistic_Special_Cost_Per_W__c : 0;
        freightCost += specialCost;

        // TODO :
        system.debug('2020-12-10邮件发送+'+EmailFlag+itemFlag);
        if(EmailFlag){
            if(opportunity.MOU_Type_Judgment__c == false){
                //checkRecursive.EmailSend(1, opportunity);
                opportunity.IsOrNotRemindEmail__c = true;
            }
        }

        return freightCost;
    }
            //Snake        
    public Decimal getFreightCostByOrder (Order order, Boolean itemFlag) {
        System.debug('----getFreightCostByOpportunity----');
        Decimal freightCost = 0;
        Boolean Emailflag = false;
        Decimal totalPower = getOrderIdPowerMap().containsKey(order.Id) ? getOrderIdPowerMap().get(order.Id) : order.Total_MW__c*1000000;
        if (totalPower == null || totalPower == 0) return 0;
        Integer regionContainerPower;
        System.debug('----containerNeedChangeIds: ' + containerNeedChangeIds);
        if (containerNeedChangeIds.contains(order.Id) && regionContainerPowerMap.containsKey(order.Region__c)){
       
            regionContainerPower = regionContainerPowerMap.get(order.Region__c);
            Integer containerCount = Math.round(totalPower / regionContainerPower);
            if (containerCount < 1) containerCount = 1;
           if(order.Region__c!='Middle East&Africa' &&order.Region__c!='MENA'&&order.Region__c!='SSA'){order.Number_of_Containers__c = containerCount;}
                 system.debug('containerCount:'+containerCount);

        }

        // land China
     //   Decimal landChina = order.Land_Freight_China__c != null ? order.Land_Freight_China__c : 0;
        Decimal landChina =0;
        // ocean
        Port_freight_maintenance__c port = getPortNameMap('port').get(order.Destination_Port__c);
        Decimal containerPrice = port != null && port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
        Decimal oceanChina = order.Ocean_Freight_China__c != null ? order.Ocean_Freight_China__c : 0;
        Decimal oceanOversea = order.Ocean_Freight_Oversea__c != null ? order.Ocean_Freight_Oversea__c : 0;
        if (oceanNeedChangeIds.contains(order.Id)) {
            if (regionContainerPower != null && order.Region__c!='Middle East&Africa' &&order.Region__c!='MENA'&&order.Region__c!='SSA') oceanChina = containerPrice / regionContainerPower ;
            else oceanChina = 0;
        }
        System.debug('--------oceanChina : ' + oceanChina);


        // land Oversea
        Port_freight_maintenance__c countryFreight = getPortNameMap('country').get(order.Destination_Country__c);
        Decimal landOversea = order.Land_Freight_Oversea__c != null ? order.Land_Freight_Oversea__c : 0;
        if (landNeedChangeIds.contains(order.Id)) {
            if (countryFreight != null && countryFreight.Land_Freight_Oversea__c != null) landOversea = countryFreight.Land_Freight_Oversea__c ;
            else landOversea = 0;
        }
        System.debug('--------landOversea : ' + landOversea);

        if (new List<String>{'CFR', 'CIF', 'CIP', 'CPT', 'DAT'}.contains(order.Trade_Term__c)) {
            System.debug('CFR, CIF, CIP, CPT, DAT');
            freightCost += landChina + oceanChina + oceanOversea;
            order.Ocean_Freight_china__c = oceanChina;   order.Ocean_Freight_Oversea__c = oceanOversea; order.Land_Freight_Oversea__c = null;
            if ((oceanChina == 0 || oceanOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'DAP', 'DDP', 'DPU', 'DDU'}.contains(order.Trade_Term__c)) {
            System.debug('DAP, DDP, DPU, DDU');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            order.Ocean_Freight_china__c = oceanChina; order.Ocean_Freight_Oversea__c = oceanOversea; order.Land_Freight_Oversea__c = landOversea;
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'FCA'}.contains(order.Trade_Term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(order.Local_Warehouse__c)) {
            System.debug('FCA Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            order.Ocean_Freight_china__c = oceanChina; order.Ocean_Freight_Oversea__c = oceanOversea; order.Land_Freight_Oversea__c = landOversea;
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'EXW'}.contains(order.Trade_Term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(order.Local_Warehouse__c)) {
            System.debug('EXW Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            order.Ocean_Freight_china__c = oceanChina; order.Ocean_Freight_Oversea__c = oceanOversea;  order.Land_Freight_Oversea__c = landOversea;
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'FOB', 'FCA'}.contains(order.Trade_Term__c)) {
            System.debug('FOB, FCA');
            freightCost += landChina;
            order.Ocean_Freight_china__c = null;order.Ocean_Freight_Oversea__c = null;  order.Land_Freight_Oversea__c = null;
        } else {
            System.debug('other(EXW)');
            order.Ocean_Freight_china__c = null;order.Ocean_Freight_Oversea__c = null; order.Land_Freight_Oversea__c = null;
        }

        Decimal warehouseCost = order.Warehouse_Premium__c != null ? order.Warehouse_Premium__c : 0;
        freightCost += warehouseCost;  // totalPower;

        Decimal specialCost = order.Logistic_Special_Cost_Per_W__c != null ? order.Logistic_Special_Cost_Per_W__c : 0;
        freightCost += specialCost;

        // TODO :
        if(EmailFlag && !itemFlag){
           // if(order.MOU_Type_Judgment__c == false){
            //    checkRecursive.EmailSend(1, opportunity);
            //     opportunity.IsOrNotRemindEmail__c = true;
            //}
        }
        system.debug('freightCost:'+freightCost);
        return freightCost;
    }
    
    public Decimal getFreightCostByContract (Contract contract) {
        System.debug('----getFreightCostByContract----');
         Decimal freightCost = 0;
        Decimal totalPower = getContractIdPowerMap().containsKey(contract.Id) ? getContractIdPowerMap().get(contract.Id) : contract.Total_W__c;
        Integer regionContainerPower = regionContainerPowerMap.get(contract.Region__c);

        // land China
      //  Decimal landChina = contract.Land_Freight_China__c != null ? contract.Land_Freight_China__c : 0;
         Decimal landChina = 0;
        // ocean
        Port_freight_maintenance__c port = getPortNameMap('port').get(contract.Destination_Port__c);
        Decimal containerPrice = port != null && port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
        Decimal oceanChina = contract.Ocean_Freight__c != null ? contract.Ocean_Freight__c : 0;
        Decimal oceanOversea = contract.Ocean_Freight_Oversea__c != null ? contract.Ocean_Freight_Oversea__c : 0;
        if (oceanNeedChangeIds.contains(contract.Id)) {
            if (regionContainerPower != null && contract.Destination_Region__c!='Middle East&Africa' &&contract.Destination_Region__c!='MENA'&&contract.Destination_Region__c!='SSA') oceanChina = containerPrice / regionContainerPower ;
            else oceanChina = 0;
        }
        System.debug('--------oceanChina : ' + oceanChina);

        // land Oversea
        Port_freight_maintenance__c countryFreight = getPortNameMap('country').get(contract.Destination_Country__c);
        Decimal landOversea = contract.Land_Freight_Oversea__c != null ? contract.Land_Freight_Oversea__c : 0;
        if (landNeedChangeIds.contains(contract.Id)) {
            if (countryFreight != null && countryFreight.Land_Freight_Oversea__c != null) landOversea = countryFreight.Land_Freight_Oversea__c ;
            else landOversea = 0;
        }
        System.debug('--------landOversea : ' + landOversea);

        if (new List<String>{'CFR', 'CIF', 'CIP', 'CPT', 'DAT'}.contains(contract.Trade_term__c)) {
            System.debug('CFR, CIF, CIP, CPT, DAT');
            freightCost += landChina + oceanChina + oceanOversea;  contract.Ocean_Freight__c = oceanChina;contract.Ocean_Freight_Oversea__c = oceanOversea;contract.Land_Freight_Oversea__c = null;
        } else if (new List<String>{'DAP', 'DDP', 'DPU', 'DDU'}.contains(contract.Trade_term__c)) {
            System.debug('DAP, DDP, DPU, DDU');
            freightCost += landChina + oceanChina + oceanOversea + landOversea; contract.Ocean_Freight__c = oceanChina; contract.Ocean_Freight_Oversea__c = oceanOversea;  contract.Land_Freight_Oversea__c = landOversea;
       
        } else if (new List<String>{'FCA'}.contains(contract.Trade_term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(contract.Local_Warehouse__c)) {
            System.debug('FCA Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            contract.Ocean_Freight__c = oceanChina; contract.Ocean_Freight_Oversea__c = oceanOversea; contract.Land_Freight_Oversea__c = landOversea;
        } else if (new List<String>{'EXW'}.contains(contract.Trade_term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(contract.Local_Warehouse__c)) {
            System.debug('EXW Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            contract.Ocean_Freight__c = oceanChina;   contract.Ocean_Freight_Oversea__c = oceanOversea; contract.Land_Freight_Oversea__c = landOversea;
        } else if (new List<String>{'FOB', 'FCA'}.contains(contract.Trade_term__c)) {
            System.debug('FOB, FCA');
            freightCost += landChina; contract.Ocean_Freight__c = null;  contract.Ocean_Freight_Oversea__c = null;contract.Land_Freight_Oversea__c = null;  
                     
        } else {
            System.debug('other(EXW)');
            contract.Ocean_Freight__c = null; contract.Ocean_Freight_Oversea__c = null; contract.Land_Freight_Oversea__c = null;
        }

        if (totalPower == null || totalPower == 0) return 0;
        if (regionContainerPowerMap.containsKey(contract.Region__c)){
            Integer containerCount = Math.round(totalPower / regionContainerPower);
            if (containerCount < 1) containerCount = 1;
            if(contract.Region__c!='Middle East&Africa' &&contract.Region__c!='MENA'&&contract.Region__c!='SSA'){ contract.Number_of_Containers__c = containerCount;}

        }

        Decimal warehouseCost = contract.Warehouse_Premium__c != null ? contract.Warehouse_Premium__c : 0;
        freightCost += warehouseCost;  // totalPower;

        Decimal specialCost = contract.Logistic_Special_Cost_Per_W__c != null ? contract.Logistic_Special_Cost_Per_W__c : 0;
        freightCost += specialCost;

        return freightCost;
    }

    Map<String, Decimal> oppIdPowerMap;
    public Map<String, Decimal> getOppIdPowerMap () {
        if (oppIdPowerMap == null) {
            oppIdPowerMap = new Map<String, Decimal>();
            for (String id : this.oppIdItemsMap.keySet()) {
                Decimal power = 0;
                for (OpportunityLineItem item : this.oppIdItemsMap.get(id)) {
                    power += item.Quantity * item.Power_W__c;
                }
                this.oppIdPowerMap.put(id, power);
            }
        }
        return oppIdPowerMap;
    }
            //Snake
        
    Map<String, Decimal> orderIdPowerMap;
    public Map<String, Decimal> getOrderIdPowerMap () {
        if (orderIdPowerMap == null) {
            orderIdPowerMap = new Map<String, Decimal>();
            for (String id : this.orderIdItemsMap.keySet()) {
                Decimal power = 0;
                for (OrderItem item : this.orderIdItemsMap.get(id)) {
                    power += item.Quantity * item.Power_W__c;
                }
                this.orderIdPowerMap.put(id, power);
            }
        }
        return orderIdPowerMap;
    }
    
    Map<String, Decimal> contractIdPowerMap;
    public Map<String, Decimal> getContractIdPowerMap () {
        if (contractIdPowerMap == null) {
            contractIdPowerMap = new Map<String, Decimal>();
            for (String id : this.contractIdItemsMap.keySet()) {
                Decimal power = 0;
                for (Product_Detail__c item : this.contractIdItemsMap.get(id)) {
                    if (item.Quantity__c != null && item.Unit_WM__c != null) power += item.Quantity__c * item.Unit_WM__c;
                }
                this.contractIdPowerMap.put(id, power);
            }
        }
        return contractIdPowerMap;
    }

    // 4. technology
    //   a. free power : $ * (1 - pre W / suf W)
    //   b. transfer : $ * rate * 0.15
    //   c. test : mannul
    //   d. special material : mapping
    @RemoteAction
    public static Object getProductByContractId(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String contractId = (String)data.get('contractId');
        Map<String, Object> result = new Map<String, Object>();
        Map<Id, ItemWrapper> IdItemWrapperMap = new Map<Id, ItemWrapper>();

        for (Product_Detail__c item : [SELECT Id,
                                              Product__c,
                                              Product__r.Name,
                                              OppProductID__c,
                                              Total_W__c,
                                              Quantity__c,
                                              Unit_WM__c,
                                              Unit_Price__c,
                                              Estimated_Gross_Margin__c,
                                              Free_Power_W__c,
                                              Third_Party_Test_Cost__c,
                                              Transfer_Stock_Rate__c,
                                              CurrencyIsoCode,
                                              Special_Material_Cost_Per_W__c,
                                              Special_Material_Type__c,
                                              Additional_Cost_Per_W__c,
                                              MX_Cost_Per_W__c,
                                              Special_Material__c
                                       FROM Product_Detail__c 
                                       WHERE Contract_PO_PI__c = :contractId]){
            if (IdItemWrapperMap.containsKey(item.Product__c)) IdItemWrapperMap.get(item.Product__c).add(item);
            else IdItemWrapperMap.put(item.Product__c, new ItemWrapper(item));
        }

        result.put('data', IdItemWrapperMap.values());

        return result;
    }
    
    @RemoteAction
    public static Object setProductByContractId(String dataStr) {
        System.debug('------------' + dataStr);
        List<Object> data = (List<Object>) JSON.deserializeUntyped(dataStr);
        Map<String, Object> result = new Map<String, Object>();
        List<Product_Detail__c> contractItems = new List<Product_Detail__c>();
        for (Object temp : data) {
            System.debug(temp);
            ItemWrapper itemWrapper = (ItemWrapper) JSON.deserialize(JSON.serialize(temp, true), ItemWrapper.class);
            contractItems.addAll(itemWrapper.transfer());
        }

        Map<Id, Product_Detail__c> itemIdContractItemMap = new Map<Id, Product_Detail__c>();
        for (Product_Detail__c item : contractItems) {
            System.debug('contract Item: ' + item);
            itemIdContractItemMap.put(item.OppProductID__c, item);
        }

        List<OpportunityLineItem> items = [
            SELECT Id,
                   Free_Power_W__c,
                   Third_Party_Test_Cost__c,
                   Transfer_Stock_Rate__c,
                   CurrencyIsoCode,
                   Special_Material_Cost_Per_W__c,
                   Special_Material_Type__c,
                   MX_Cost_Per_W__c,
                   Special_Material__c
            FROM OpportunityLineItem
            WHERE Id IN :itemIdContractItemMap.keySet()];

        for (OpportunityLineItem item : items) {
            System.debug('item: ' + item);
            Product_Detail__c contractItem = itemIdContractItemMap.get(item.Id);
            item.Free_Power_W__c = contractItem.Free_Power_W__c;item.Third_Party_Test_Cost__c = contractItem.Third_Party_Test_Cost__c;
            item.Transfer_Stock_Rate__c = contractItem.Transfer_Stock_Rate__c;item.Special_Material_Cost_Per_W__c = contractItem.Special_Material_Cost_Per_W__c;
            item.Special_Material_Type__c = contractItem.Special_Material_Type__c;item.Special_Material__c = contractItem.Special_Material__c;     
            
        }

        System.debug('------------' + contractItems);
        update contractItems;
        OpportunityLineItemGrossMarginHandler.skipTrigger = true;
        if (items != null && items.size() > 0) update items;
        // Database.update(items, false);

        result.put('code', 'success');

        return result;
    }

    public class ItemWrapper {
        public String ids;
        public String parentIds;
        public String isoCode;
        public String productId;
        public String productName;
        public Decimal totalPower;
        public Decimal unitPower;
        public Decimal quantity;
        public Decimal unitPrice;
        public Decimal estimatedGrossMargin;
        public Decimal freePower;
        public Decimal testCost;
        public Decimal testCostPerW;
        public Decimal transferStock;
        public Decimal specialMaterialCostPerW;
        public String specialMaterials;
        public String specialMaterialTypes;

        public ItemWrapper (Product_Detail__c item) {
            System.debug('item :' + item);
            this.ids = item.Id;
            this.parentIds = item.OppProductID__c;
            this.isoCode = item.CurrencyIsoCode;
            this.productId = item.Product__c;
            this.productName = item.Product__r.Name;
            this.totalPower = item.Total_W__c;
            this.unitPower = item.Unit_WM__c != null ? item.Unit_WM__c : 0;
            this.quantity = item.Quantity__c != null ? item.Quantity__c : 0;
            this.unitPrice = item.Unit_Price__c != null ? item.Unit_Price__c : 0;
            // this.estimatedGrossMargin = item.Estimated_Gross_Margin__c != null ? item.Estimated_Gross_Margin__c : 0;
            this.freePower = item.Free_Power_W__c;
            this.testCost = item.Third_Party_Test_Cost__c;
            this.transferStock = item.Transfer_Stock_Rate__c;
            this.specialMaterialCostPerW = item.Special_Material_Cost_Per_W__c;
            this.specialMaterials = item.Special_Material__c;
            this.specialMaterialTypes = item.Special_Material_Type__c;
        }

        public ItemWrapper add (Product_Detail__c item) {
            this.ids += ',' + item.Id; this.parentIds += ',' + item.OppProductID__c; this.totalPower += item.Total_W__c;  return this;
        }

        public List<Product_Detail__c> transfer () {
            List<Product_Detail__c> items = new List<Product_Detail__c>();
            OpportunityLineItemGrossMarginHandler handler = new OpportunityLineItemGrossMarginHandler();
            System.debug('Contract item :' + this);
            List<String> ids = this.ids.split(',');
            List<String> parentIds = new List<String>();
            if (String.isNotBlank(this.parentIds)) parentIds = this.parentIds.split(',');
            for (Integer i = 0; i < ids.size(); i ++) {
                Product_Detail__c item = new Product_Detail__c();
                Double rate = handler.getCodeRateMap().containsKey(this.isoCode) ? handler.getCodeRateMap().get(this.isoCode) : 1;
                item.Id = ids[i];
                if (parentIds.size() > i) item.OppProductID__c = parentIds[i];
                item.Free_Power_W__c = this.freePower != null ? this.freePower : 0;
                item.Third_Party_Test_Cost__c = this.testCost != null ? this.testCost * rate : 0;
                item.Transfer_Stock_Rate__c = this.transferStock != null ? this.transferStock : 0;
                item.Special_Material_Cost_Per_W__c = this.specialMaterialCostPerW != null ? this.specialMaterialCostPerW * rate : 0;
                item.Special_Material__c = this.specialMaterials;
                item.Special_Material_Type__c = this.specialMaterialTypes;
                items.add(item);
            }

            return items;
        }
    }

    public Decimal getTechnologyCostByContractItem (Contract contract, Product_Detail__c item) {
        Double rate = getCodeRateMap().containsKey(item.CurrencyIsoCode) ? getCodeRateMap().get(item.CurrencyIsoCode) : 1;
        Decimal technologyCost = 0;
        Decimal totalPower = getContractIdPowerMap().containsKey(contract.Id) ? getContractIdPowerMap().get(contract.Id) : 0;
        Decimal unitPrice = item.Unit_Price__c != null ? item.Unit_Price__c : 0;
        Decimal unitPower = item.Unit_WM__c != null ? item.Unit_WM__c : 0;
        Decimal freePower = item.Free_Power_W__c != null ? item.Free_Power_W__c : 0;
        Decimal testCostPerW = item.Third_Party_Test_Cost__c != null && totalPower != 0 ? item.Third_Party_Test_Cost__c * rate / totalPower: 0;
        Decimal transferStock = item.Transfer_Stock_Rate__c != null ? item.Transfer_Stock_Rate__c : 0;
        Decimal specialMaterialCostPerW = item.Special_Material_Cost_Per_W__c != null ? item.Special_Material_Cost_Per_W__c : 0;
        technologyCost += unitPower != 0 ? unitPrice * freePower / (unitPower + freePower) : 0;
        technologyCost += testCostPerW;
        technologyCost += transferStock / 100 * unitPrice * 0.15;
        technologyCost += specialMaterialCostPerW * rate;

        return technologyCost;
    }

    // 5. product cost
    public Decimal getProductCostByItem (Opportunity opportunity, OpportunityLineItem item) {
        Double rate = getCodeRateMap().containsKey(item.CurrencyIsoCode) ? getCodeRateMap().get(item.CurrencyIsoCode) : 1;
        opportunity.Rate__c = getCodeRateMap().containsKey(opportunity.CurrencyIsoCode) ? getCodeRateMap().get(opportunity.CurrencyIsoCode) : 1;
        Decimal cost = 0;
        // product cost
        List<Product_Cost_Maintenance__c> productCosts = getProductCostsMap().get(item.Product_Module__c);
        if (productCosts != null){
            for (Product_Cost_Maintenance__c pcm : productCosts) {
                Date deliveryDate = item.Guaranteed_Delivery_Date__c;
                if (deliveryDate > pcm.Q4_End_Date_Next_Year__c || deliveryDate < pcm.Start_Date__c) continue;  
                if (deliveryDate <= pcm.Q1_End_Date_This_Year__c) cost += pcm.Q1_This_Year__c;
                else if (deliveryDate <= pcm.Q2_End_Date_This_Year__c) cost += pcm.Q2_This_Year__c; 
                else if (deliveryDate <= pcm.Q3_End_Date_This_Year__c) cost += pcm.Q3_This_Year__c;
                else if (deliveryDate <= pcm.Q4_End_Date_This_Year__c) cost += pcm.Q4_This_Year__c;
                else if (deliveryDate <= pcm.Q1_End_Date_Next_Year__c) cost += pcm.Q1_Next_Year__c;
                else if (deliveryDate <= pcm.Q2_End_Date_Next_Year__c) cost += pcm.Q2_Next_Year__c; 
                else if (deliveryDate <= pcm.Q3_End_Date_Next_Year__c) cost += pcm.Q3_Next_Year__c;
                else cost += pcm.Q4_Next_Year__c; 
                break;
            }
        }

        // region cost
        List<Product_Cost_Maintenance__c> regionCosts = getRegionCostsMap().get(opportunity.Region__c);
        if (regionCosts != null){
            for (Product_Cost_Maintenance__c pcm : regionCosts) {
                Date deliveryDate = item.Guaranteed_Delivery_Date__c;
                if (deliveryDate > pcm.Q4_End_Date_Next_Year__c || deliveryDate < pcm.Start_Date__c) continue;  
                if (deliveryDate <= pcm.Q1_End_Date_This_Year__c) cost += pcm.Q1_This_Year__c;
                else if (deliveryDate <= pcm.Q2_End_Date_This_Year__c) cost += pcm.Q2_This_Year__c; 
                else if (deliveryDate <= pcm.Q3_End_Date_This_Year__c) cost += pcm.Q3_This_Year__c;
                else if (deliveryDate <= pcm.Q4_End_Date_This_Year__c) cost += pcm.Q4_This_Year__c; 
                else if (deliveryDate <= pcm.Q1_End_Date_Next_Year__c) cost += pcm.Q1_Next_Year__c;
                else if (deliveryDate <= pcm.Q2_End_Date_Next_Year__c) cost += pcm.Q2_Next_Year__c; 
                else if (deliveryDate <= pcm.Q3_End_Date_Next_Year__c) cost += pcm.Q3_Next_Year__c;
                else cost += pcm.Q4_Next_Year__c;
                break;
                
            }
        }
         /*if (item.Product_name__c!=null && item.Product_name__c.contains('-B') && !item.Product_name__c.contains('-BD')){
             cost +=0.025;
             }*/

        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return cost * rate;
    }
        //Snake
        
    public Decimal getProductCostByOrderItem (Order order, OrderItem item) {
        Double rate = getCodeRateMap().containsKey(item.CurrencyIsoCode) ? getCodeRateMap().get(item.CurrencyIsoCode) : 1;
        order.Rate__c = getCodeRateMap().containsKey(order.CurrencyIsoCode) ? getCodeRateMap().get(order.CurrencyIsoCode) : 1;
        Decimal cost = 0;
        // product cost
        List<Product_Cost_Maintenance__c> productCosts = getProductCostsMap().get(item.Product_Module__c);
        if (productCosts != null){
            for (Product_Cost_Maintenance__c pcm : productCosts) {
                Date deliveryDate = item.Guaranteed_Delivery_Date__c;
                if (deliveryDate > pcm.Q4_End_Date_Next_Year__c || deliveryDate < pcm.Start_Date__c) continue;if (deliveryDate <= pcm.Q1_End_Date_This_Year__c) cost += pcm.Q1_This_Year__c;
                
                else if (deliveryDate <= pcm.Q2_End_Date_This_Year__c) cost += pcm.Q2_This_Year__c;else if (deliveryDate <= pcm.Q3_End_Date_This_Year__c) cost += pcm.Q3_This_Year__c;
    
                else if (deliveryDate <= pcm.Q4_End_Date_This_Year__c) cost += pcm.Q4_This_Year__c;else if (deliveryDate <= pcm.Q1_End_Date_Next_Year__c) cost += pcm.Q1_Next_Year__c;

                else if (deliveryDate <= pcm.Q2_End_Date_Next_Year__c) cost += pcm.Q2_Next_Year__c;  else if (deliveryDate <= pcm.Q3_End_Date_Next_Year__c) cost += pcm.Q3_Next_Year__c;
              
                else cost += pcm.Q4_Next_Year__c; break;
                
               
            }
        }

        // region cost
        List<Product_Cost_Maintenance__c> regionCosts = getRegionCostsMap().get(Order.Region__c);
        if (regionCosts != null){
            for (Product_Cost_Maintenance__c pcm : regionCosts) {
                Date deliveryDate = item.Guaranteed_Delivery_Date__c;
                if (deliveryDate > pcm.Q4_End_Date_Next_Year__c || deliveryDate < pcm.Start_Date__c) continue; if (deliveryDate <= pcm.Q1_End_Date_This_Year__c) cost += pcm.Q1_This_Year__c;
               
                else if (deliveryDate <= pcm.Q2_End_Date_This_Year__c) cost += pcm.Q2_This_Year__c; else if (deliveryDate <= pcm.Q3_End_Date_This_Year__c) cost += pcm.Q3_This_Year__c;
               
                else if (deliveryDate <= pcm.Q4_End_Date_This_Year__c) cost += pcm.Q4_This_Year__c; else if (deliveryDate <= pcm.Q1_End_Date_Next_Year__c) cost += pcm.Q1_Next_Year__c;

                else if (deliveryDate <= pcm.Q2_End_Date_Next_Year__c) cost += pcm.Q2_Next_Year__c; else if (deliveryDate <= pcm.Q3_End_Date_Next_Year__c) cost += pcm.Q3_Next_Year__c;

                else cost += pcm.Q4_Next_Year__c;  break;   
                
           
            }
        }/*
         if (item.Product_Name__c!=null && item.Product_Name__c.contains('-B') && !item.Product_Name__c.contains('-BD')){
             cost +=0.025;
             }*/

        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return cost * rate;
    }

    // Get Product Costs
    public Map<String, List<Product_Cost_Maintenance__c>> productCostsMap;
    public Map<String, List<Product_Cost_Maintenance__c>> getProductCostsMap() {
        if (this.productCostsMap == null) {
            this.productCostsMap = new Map<String, List<Product_Cost_Maintenance__c>>();
            for (Product_Cost_Maintenance__c cost : [SELECT Id,
                                                            Name,
                                                            Start_Date__c,
                                                            Q1_End_Date_This_Year__c,
                                                            Q1_This_Year__c,
                                                            Q2_End_Date_This_Year__c,
                                                            Q2_This_Year__c,
                                                            Q3_End_Date_This_Year__c,
                                                            Q3_This_Year__c,
                                                            Q4_End_Date_This_Year__c,
                                                            Q4_This_Year__c,
                                                            Q1_End_Date_Next_Year__c,
                                                            Q1_Next_Year__c,
                                                            Q2_End_Date_Next_Year__c,
                                                            Q2_Next_Year__c,
                                                            Q3_End_Date_Next_Year__c,
                                                            Q3_Next_Year__c,
                                                            Q4_End_Date_Next_Year__c,
                                                            Q4_Next_Year__c,
                                                            Cost_Type__c
                                                     FROM Product_Cost_Maintenance__c 
                                                     WHERE Name IN :this.productModules
                                                     AND Cost_Type__c = 'Product']){
                if (this.productCostsMap.containsKey(cost.Name)) this.productCostsMap.get(cost.Name).add(cost);
                else this.productCostsMap.put(cost.Name, new List<Product_Cost_Maintenance__c>{cost});
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.productCostsMap;
    }

    // Get Region Costs
    public Map<String, List<Product_Cost_Maintenance__c>> regionCostsMap;
    public Map<String, List<Product_Cost_Maintenance__c>> getRegionCostsMap() {
        if (this.regionCostsMap == null) {
            regionCostsMap = new Map<String, List<Product_Cost_Maintenance__c>>();
            for (Product_Cost_Maintenance__c cost : [SELECT Id,
                                                            Name,
                                                            Start_Date__c,
                                                            Q1_End_Date_This_Year__c,
                                                            Q1_This_Year__c,
                                                            Q2_End_Date_This_Year__c,
                                                            Q2_This_Year__c,
                                                            Q3_End_Date_This_Year__c,
                                                            Q3_This_Year__c,
                                                            Q4_End_Date_This_Year__c,
                                                            Q4_This_Year__c,
                                                            Q1_End_Date_Next_Year__c,
                                                            Q1_Next_Year__c,
                                                            Q2_End_Date_Next_Year__c,
                                                            Q2_Next_Year__c,
                                                            Q3_End_Date_Next_Year__c,
                                                            Q3_Next_Year__c,
                                                            Q4_End_Date_Next_Year__c,
                                                            Q4_Next_Year__c
                                                     FROM Product_Cost_Maintenance__c 
                                                     WHERE Cost_Type__c = 'Region']){
                if (this.regionCostsMap.containsKey(cost.Name)) this.regionCostsMap.get(cost.Name).add(cost);
                else this.regionCostsMap.put(cost.Name, new List<Product_Cost_Maintenance__c>{cost});
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.regionCostsMap;
    }

    // 6. commission & rebate
    public Decimal getCommisionRebateByOpportunity (Opportunity opportunity, OpportunityLineItem item) {
        Decimal commisionRebateCost = 0;
        Decimal totalPower = getOppIdPowerMap().containsKey(opportunity.Id) ? getOppIdPowerMap().get(opportunity.Id) : opportunity.Total_Power__c;
        Decimal commision = opportunity.Commision__c != null ? opportunity.Commision__c : 0;
        Decimal rebate = opportunity.Rebate_new__c != null ? opportunity.Rebate_new__c : 0;
        Decimal discount = opportunity.Discount_new__c != null ? opportunity.Discount_new__c : 0;
        if (opportunity.Commission_Type__c == 'Per/W') commisionRebateCost += commision;
        else if (opportunity.Commission_Type__c == 'Total Amount') commisionRebateCost += commision / totalPower;
        if (opportunity.Rebate_Type_new__c == 'Per/W') commisionRebateCost += rebate;
        else if (opportunity.Rebate_Type_new__c == 'Total Amount') commisionRebateCost += rebate / totalPower;
        else if (opportunity.Rebate_Type_new__c == '%') commisionRebateCost += rebate / 100 * item.UnitPrice;
        if (opportunity.Discount_Type__c == 'Per/W') commisionRebateCost += discount;
        else if (opportunity.Discount_Type__c == 'Total Amount') commisionRebateCost += discount / totalPower;
        else if (opportunity.Discount_Type__c == '%') commisionRebateCost += discount / 100 * item.UnitPrice;
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return commisionRebateCost;
    }
        //Snake
        
    public Decimal getCommisionRebateByOrder (Order order, OrderItem item) {
        Decimal commisionRebateCost = 0;
        Decimal totalPower = getOppIdPowerMap().containsKey(order.Id) ? getOppIdPowerMap().get(order.Id) : order.Total_MW__c;
        Decimal commision = order.Commission__c != null ? order.Commission__c : 0;
        Decimal rebate = order.Rebate_new__c != null ? order.Rebate_new__c : 0;
        Decimal discount = order.Discount_new__c != null ? order.Discount_new__c : 0;
        if (order.Commission_Type__c == 'Per/W') commisionRebateCost += commision;
        else if (order.Commission_Type__c == 'Total Amount') commisionRebateCost += commision / totalPower;
        if (order.Rebate_Type__c == 'Per/W') commisionRebateCost += rebate;
        else if (order.Rebate_Type__c == 'Total Amount') commisionRebateCost += rebate / totalPower;
        else if (order.Rebate_Type__c == '%') commisionRebateCost += rebate / 100 * item.UnitPrice;
        if (order.Discount_Type__c == 'Per/W') commisionRebateCost += discount;
        else if (order.Discount_Type__c == 'Total Amount') commisionRebateCost += discount / totalPower;
        else if (order.Discount_Type__c == '%') commisionRebateCost += discount / 100 * item.UnitPrice;
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return commisionRebateCost;
    }

    // opportunity item cost $ /W
    public void calculateGrossMargin () {
        System.debug('----calculateGrossMargin----');
        Opportunity opportunity =new Opportunity();
          for (OpportunityLineItem item : this.items) {
                opportunity = getOpportunityIdMap().get(item.OpportunityId);
          }
        Decimal freightCost =0;
        if (opportunity != null ){
               freightCost=getFreightCostByOpportunity(opportunity, true, false);
             freightCost = freightCost * getCodeRateMap().get(opportunity.CurrencyIsoCode);
        }
        for (OpportunityLineItem item : this.items) {
            if (opportunity == null || item.UnitPrice == null) continue;
            // 1. payment term
            Decimal paymentCost = getPaymentCostByOpportunity(opportunity, item);
            item.Payment_Cost_Per_W__c = paymentCost;
            // 2. insurence (if need) 
            //modify by Miller on 2021-04-09, remove Insurence_Cost_Per_W__c when calculate Estimated_Gross_Margin__c
            // Decimal insurenceCost = getInsurenceCostByItem(opportunity, item);
            // item.Insurence_Cost_Per_W__c = insurenceCost;
            // 3. freight
      
            system.debug('202012/16freightCost'+freightCost);
           
            item.Freight_Cost_Per_W__c = freightCost;
            // 4. technology
            // Decimal technologyCost = getTechnologyCostByOpportunity(opportunity);
            // 5. product cost
            item.Product_Cost__c = getProductCostByItem(opportunity, item);
            // 6. commission & rebate
            Decimal commisionRebateCost = getCommisionRebateByOpportunity(opportunity, item);
            item.Commision_Rebate_Cost_Per_W__c = commisionRebateCost;

            System.debug('item: ' + item);
            System.debug('-------- SOQL Count------- :' + Limits.getQueries());
            item.Estimated_Gross_Margin__c =
                item.UnitPrice - 
                paymentCost -
                // insurenceCost - modify by Miller on 2021-04-09, remove Insurence_Cost_Per_W__c when calculate Estimated_Gross_Margin__c 
                freightCost -
                // technologyCost -
                item.Product_Cost__c -
                commisionRebateCost -
                (item.MX_Cost_Per_W__c != null?item.MX_Cost_Per_W__c:0) -
                (item.Back_Sheet_Color_Additional_Cost_Per_W__c != null?item.Back_Sheet_Color_Additional_Cost_Per_W__c:0) -
                (item.Frame_Color_Additional_Cost_Per_W__c != null?item.Frame_Color_Additional_Cost_Per_W__c:0);
            item.Total_Gross_Margin__c = item.Estimated_Gross_Margin__c * item.Quantity * item.Power_W__c;
        }

        if (this.existItems != null && this.existItems.size() > 0) update this.existItems;
        update getOpportunityIdMap().values();
        System.debug('----calculateGrossMargin out----');
    }
  // Order item cost $ /W
          //Snake
        
    public void calculateOrderGrossMargin () {
        System.debug('----calculateOrderGrossMargin----');
        for (OrderItem item : this.orderitems) {
            Order order = getOrderIdMap().get(item.OrderId);
            if (order == null || item.UnitPrice == null) continue;
            // 1. payment term
            Decimal paymentCost = getPaymentCostByorder(order, item);
            item.Payment_Cost_Per_W__c = paymentCost;
            // 2. insurence (if need)
            // modify by Miller on 2021-04-09, remove Insurence_Cost_Per_W__c when calculate Estimated_Gross_Margin__c
            // Decimal insurenceCost = getInsurenceCostByorderItem(order, item);
            // item.Insurence_Cost_Per_W__c = insurenceCost;
            // 3. freight
            Decimal freightCost = getFreightCostByOrder(order, true);
            item.Freight_Cost_Per_W__c = freightCost*getCodeRateMap().get(order.CurrencyIsoCode);
            // 4. technology
            // Decimal technologyCost = getTechnologyCostByOpportunity(opportunity);
            // 5. product cost
            item.Product_Cost__c = getProductCostByorderItem(order, item);
            // 6. commission & rebate
            Decimal commisionRebateCost = getCommisionRebateByOrder(order, item);
            item.Commision_Rebate_Cost_Per_W__c = commisionRebateCost;

            System.debug('item: ' + item);
            System.debug('-------- SOQL Count------- :' + Limits.getQueries());
            item.Estimated_Gross_Margin__c =
                item.UnitPrice - 
                paymentCost -
                // insurenceCost - modify by Miller on 2021-04-09, remove Insurence_Cost_Per_W__c when calculate Estimated_Gross_Margin__c
                freightCost -
                // technologyCost -
                item.Product_Cost__c -
                commisionRebateCost -
                (item.MX_Cost_Per_W__c != null?item.MX_Cost_Per_W__c:0);
            item.Total_Gross_Margin__c = item.Estimated_Gross_Margin__c * item.Quantity * item.Power_W__c;
        }

        if (this.existItems != null && this.existItems.size() > 0) update this.existItems;
        update getOrderIdMap().values();
        System.debug('----calculateGrossMargin out----');
    }

    // contract item cost $ /W
    public void calculateContractGrossMargin () {
        System.debug('----calculateContractGrossMargin----');
        for (Product_Detail__c item : this.contractItems) {
            Contract contract = getContractIdMap().get(item.Contract_PO_PI__c);
            if (contract == null || item.Unit_Price__c == null) continue;
            // 1. payment term
            Decimal paymentCost = item.Payment_Cost_Per_W__c != null ? item.Payment_Cost_Per_W__c : 0; // getPaymentCostByOpportunity(opportunity, item);
            // 2. insurence (if need)
            // Decimal insurenceCost = item.Insurence_Cost_Per_W__c != null ? item.Insurence_Cost_Per_W__c : 0; // getInsurenceCostByItem(opportunity, item);
            // 3. freight
            Decimal freightCost = getFreightCostByContract(contract);
            freightCost = freightCost * getCodeRateMap().get(contract.CurrencyIsoCode);
            item.Freight_Cost_Per_W__c = freightCost;
            // 4. technology
            Decimal technologyCost = getTechnologyCostByContractItem(contract, item);
            item.Technology_Cost_Per_W__c = technologyCost;
            // 5. product cost
            Decimal productCost = item.Product_Cost__c != null ? item.Product_Cost__c : 0;
            // 6. commission & rebate
            Decimal commisionRebateCost = item.Commision_Rebate_Cost_Per_W__c != null ? item.Commision_Rebate_Cost_Per_W__c : 0;

            System.debug('item: ' + item);
            System.debug('-------- SOQL Count------- :' + Limits.getQueries());
            item.Estimated_Gross_Margin__c = 
                                                item.Unit_Price__c - 
                                                paymentCost -
                                                // insurenceCost -
                                                freightCost -
                                                // technologyCost -
                                                productCost -
                                                commisionRebateCost -
                                                (item.MX_Cost_Per_W__c != null?item.MX_Cost_Per_W__c:0);
            item.Confirmed_Gross_Margin__c = (item.Estimated_Gross_Margin__c != null ? item.Estimated_Gross_Margin__c : 0) 
                                                - technologyCost 
                                                - (item.Additional_Cost_Per_W__c != null?item.Additional_Cost_Per_W__c:0);
            item.Total_Gross_Margin__c = item.Confirmed_Gross_Margin__c * item.Total_W__c;
        }

        if (this.existContractItems != null && this.existContractItems.size() > 0) update this.existContractItems;
        update getContractIdMap().values();
        System.debug('----calculateContractGrossMargin out----');
    }
}