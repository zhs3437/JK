public without sharing class RC_CostCenter {
    public List<leanx__pm_ProjectMember__c> items;
    public List<leanx__pm_ProjectMember__c> existItems;
    public List<Contract_Component__c> contractItems;
    public List<Contract_Component__c> existContractItems;
    Set<String> headerIds = new Set<String>();
    public Map<Id, leanx__pm_Project__c> opportunityIdMap;
    public Map<String, List<leanx__pm_ProjectMember__c>> oppIdItemsMap = new Map<String, List<leanx__pm_ProjectMember__c>>();
    public Map<String, List<Contract_Component__c>> contractIdItemsMap = new Map<String, List<Contract_Component__c>>();
    public Map<Id, leanx__lg_Contract__c> contractIdMap;
    public Map<Id, List<Payment__c>> opportunityIdPaymentsMap;
    public Set<String> productModules = new Set<String>();
    public Map<String, Double> codeRateMap;
    public Map<String, Port_freight_maintenance__c> portFreightNameMap;
    public Map<String, Port_freight_maintenance__c> countryFreightNameMap;

    public static Boolean skipTrigger = false;
    public static Set<Id> containerNeedChangeIds = new Set<Id>();
    public static Set<Id> oceanNeedChangeIds = new Set<Id>();
    public static Set<Id> landNeedChangeIds = new Set<Id>();

    public RC_CostCenter () {}

    public RC_CostCenter (Map<Id, leanx__pm_Project__c> opportunityIdMap) {
        // CostCenter.skipTrigger = true;
        Set<Id> opportunityId = new Set<Id>();
        for (leanx__pm_Project__c o : opportunityIdMap.values()){
            // if (o.MOU_Type_Judgment__c == false) {
                opportunityId.add(o.Id);
            // }
        }
        this.items = [
            SELECT Id
            FROM leanx__pm_ProjectMember__c
            WHERE leanx__Project__c IN :opportunityId];
        if (this.items.size() == 0) return;
        update this.items;
    }

    public RC_CostCenter (Map<Id, leanx__lg_Contract__c> contractIdMap) {
        // CostCenter.skipTrigger = true;
        this.contractItems = [
            SELECT Name
            FROM Contract_Component__c
            WHERE Contract__c IN :contractIdMap.keySet()];
        if (this.contractItems.size() == 0) return;
        update this.contractItems;
    }

    public RC_CostCenter (List<leanx__pm_ProjectMember__c> items) {
        RC_CostCenter.skipTrigger = true;
        this.items = new List<leanx__pm_ProjectMember__c>();
        this.items.addAll(items);
        Set<String> oppItemsExistIds = new Set<String>();
        for (leanx__pm_ProjectMember__c item : items) {
            oppItemsExistIds.add(item.Id);
            headerIds.add(item.leanx__Project__c);
        }
        this.existItems = [
            SELECT Id,
                   leanx__Project__c,
                   Sales_Price__c,
                   CurrencyIsoCode,
                   Quantity__c,
                   Guaranteed_Delivery_Date__c,
                   Product_Series__c,
                   Product_Module__c,
                   Power_W__c
            FROM leanx__pm_ProjectMember__c 
            WHERE leanx__Project__c IN :headerIds
            AND Id NOT IN :oppItemsExistIds];

        if (this.existItems != null) this.items.addAll(this.existItems);
        for (leanx__pm_ProjectMember__c item : this.items) {
            this.productModules.add(item.Product_Module__c);
            if (oppIdItemsMap.containsKey(item.leanx__Project__c)) oppIdItemsMap.get(item.leanx__Project__c).add(item);
            else oppIdItemsMap.put(item.leanx__Project__c, new List<leanx__pm_ProjectMember__c>{item});
        }
        calculateGrossMargin();
    }

    public RC_CostCenter (List<Contract_Component__c> items) {
        RC_CostCenter.skipTrigger = true;
        this.contractItems = new List<Contract_Component__c>();
        this.contractItems.addAll(items);
        Set<String> contractItemsExistIds = new Set<String>();
        for (Contract_Component__c item : items) {
            contractItemsExistIds.add(item.Id);
            headerIds.add(item.Contract__c);
        }
        this.existContractItems = [
            SELECT Id,
                   Contract__c,
                   Payment_Cost_Per_W__c,
                   Insurence_Cost_Per_W__c,
                   Freight_Cost_Per_W__c,
                   Technology_Cost_Per_W__c,
                   Product_Cost__c,
                   Commision_Rebate_Cost_Per_W__c,
                   Estimated_Gross_Margin__c,
                   Confirmed_Gross_Margin__c,
                   Total_Gross_Margin__c,
                   Sales_Price__c,
                   CurrencyIsoCode,
                   Power_W__c,
                   Quantity__c,
                   Free_Power_W__c,
                   Third_Party_Test_Cost__c,
                   Transfer_Stock_Rate__c,
                   Special_Material_Cost_Per_W__c,
                   Total_Power_W__c
            FROM Contract_Component__c 
            WHERE Contract__c IN :headerIds
            AND Id NOT IN :contractItemsExistIds];

        if (this.existContractItems != null) this.contractItems.addAll(this.existContractItems);
        for (Contract_Component__c item : this.contractItems) {
            if (contractIdItemsMap.containsKey(item.Contract__c)) contractIdItemsMap.get(item.Contract__c).add(item);
            else contractIdItemsMap.put(item.Contract__c, new List<Contract_Component__c>{item});
        }
        calculateContractGrossMargin();
    }

    // Get leanx__pm_Project__c's insurence, freight, commission
    public Map<Id, leanx__pm_Project__c> getOpportunityIdMap () {
        if (this.opportunityIdMap == null){
            this.opportunityIdMap = new Map<Id, leanx__pm_Project__c>([
                SELECT Id,
                       Land_Freight_China__c,
                       Ocean_Freight_China__c,
                       Ocean_Freight_Oversea__c,
                       Land_Freight_Oversea__c,
                       Destination_Region__c,
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
                       Discount__c,
                       Total_Power_W__c,
                       Rebate__c,
                       Rebate_Type__c,
                    //    MOU_Type_Judgment__c,
                       Rate__c,
                       CurrencyIsoCode,
                       OwnerId,
                       Total_Price__c
                FROM leanx__pm_Project__c 
                WHERE Id IN :headerIds]);
                // AND MOU_Type_Judgment__c = false]);
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.opportunityIdMap;
    }

    public Map<Id, leanx__lg_Contract__c> getContractIdMap () {
        Set<String> contractIds = new Set<String>();
        for(Contract_Component__c item : this.contractItems){
            contractIds.add(item.Contract__c);
        }
        if (this.contractIdMap == null){
            this.contractIdMap = new Map<Id, leanx__lg_Contract__c>([
                SELECT Id,
                       Land_Freight_China__c,
                       Ocean_Freight_China__c,
                       Ocean_Freight_Oversea__c,
                       Land_Freight_Oversea__c,
                       Destination_Region__c,
                       Destination_Port__c,
                       Destination_Country__c,
                       Trade_term__c,
                       CurrencyIsoCode,
                       Warehouse_Premium__c,
                       Logistic_Special_Cost_Per_W__c,
                       Local_Warehouse__c,
                       Total_Price__c
                FROM leanx__lg_Contract__c 
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

    // TODO
    public Map<Id, List<Payment__c>> getOpportunityIdPaymentsMap() {
        if (this.opportunityIdPaymentsMap == null){
            this.opportunityIdPaymentsMap = new Map<Id, List<Payment__c>>();
            for (Payment__c payment : [SELECT Id,
                                              Down_Balance_Payment__c,
                                              Percentage__c,
                                              Payment_Stage_China__c,
                                              Payment_Method__c,
                                              Payment_Method_China__c,
                                              Days__c,
                                              China_Project__c
                                       FROM Payment__c
                                       WHERE China_Project__c IN :headerIds]) {
                if (this.opportunityIdPaymentsMap.containsKey(payment.China_Project__c)) this.opportunityIdPaymentsMap.get(payment.China_Project__c).add(payment);
                else this.opportunityIdPaymentsMap.put(payment.China_Project__c, new List<Payment__c>{payment});
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return this.opportunityIdPaymentsMap;
    }

    // 1. payment term
    // Total $ * % * rate (1.2% / 3%/ 5%) / 365 * days / W
    public Decimal getPaymentCostByOpportunity (leanx__pm_Project__c opportunity, leanx__pm_ProjectMember__c item) {
        Decimal paymentCost = 0;
        List<Payment__c> payments = getOpportunityIdPaymentsMap().get(opportunity.Id);
        if (payments != null) {
            for (Payment__c payment : payments) {
                if (payment.Down_Balance_Payment__c == 'Down Payment') continue;
                if (payment.Percentage__c == null) continue;
                if (payment.Days__c == null) continue;
                // Decimal term = payment.Percentage__c / 100 * opportunity.Total_Price__c * payment.Days__c / 365 / opportunity.Total_Power__c;
                Decimal term = payment.Percentage__c / 100 * item.Sales_Price__c * payment.Days__c / 365;
                if (payment.Payment_Method__c == 'L/C') paymentCost += term * 0.03;
                else if (payment.Payment_Stage_China__c != null && payment.Payment_Stage_China__c != '预付款' && 
                         payment.Payment_Method_China__c != null && payment.Payment_Method_China__c.contains('承兑汇票')) paymentCost += term * 0.012;
                else if (payment.Payment_Method__c != null) paymentCost += term * 0.05;
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return paymentCost;
    }

    // 2. insurence
    // 0.001
    public Decimal getInsurenceCostByItem (leanx__pm_Project__c opportunity, leanx__pm_ProjectMember__c item) {
        Decimal insurenceCost = 0;
        insurenceCost = item.Sales_Price__c * 0.01;
        return insurenceCost;
    }

    public Map<String, Port_freight_maintenance__c> getPortNameMap (String type) {
        if (this.portFreightNameMap == null || this.countryFreightNameMap == null) {
            this.portFreightNameMap = new Map<String, Port_freight_maintenance__c>();
            this.countryFreightNameMap = new Map<String, Port_freight_maintenance__c>();
            for (Port_freight_maintenance__c port : [SELECT Name, 
                                                            Warehouse_Premium__c,
                                                            Type__c,
                                                            Land_Freight_Oversea__c
                                                     FROM Port_freight_maintenance__c]) {
                // Decimal containerPrice = port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
                if (port.Type__c == 'Port') this.portFreightNameMap.put(port.Name, port);
                else if (port.Type__c == 'Country') this.countryFreightNameMap.put(port.Name, port);
            }
        }
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        if (type == 'Port') return this.portFreightNameMap;
        else if (type == 'Country') return this.countryFreightNameMap;
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
        'Latin America&Italy' => 218400,
        'Central Asia' => 207495
    };

    // 3. freight
    //  a. freight
    //  b. warehouse
    //  c. special
    public Decimal getFreightCostByOpportunity (leanx__pm_Project__c opportunity, Boolean itemFlag) {
        System.debug('----getFreightCostByOpportunity----');
        Double rate = getCodeRateMap().containsKey(opportunity.CurrencyIsoCode) ? getCodeRateMap().get(opportunity.CurrencyIsoCode) : 1;
        Decimal freightCost = 0;
        Boolean Emailflag = false;
        Decimal totalPower = getOppIdPowerMap().containsKey(opportunity.Id) ? getOppIdPowerMap().get(opportunity.Id) : opportunity.Total_Power_W__c;
        if (totalPower == null || totalPower == 0) return 0;
        Integer regionContainerPower;
        System.debug('----containerNeedChangeIds: ' + containerNeedChangeIds);
        if (containerNeedChangeIds.contains(opportunity.Id) && regionContainerPowerMap.containsKey(opportunity.Destination_Region__c)){
            regionContainerPower = regionContainerPowerMap.get(opportunity.Destination_Region__c);
            Integer containerCount = Math.round(totalPower / regionContainerPower);
            if (containerCount < 1) containerCount = 1;
            opportunity.Number_of_Containers__c = containerCount;
        }

        // land China
        Decimal landChina = opportunity.Land_Freight_China__c != null ? opportunity.Land_Freight_China__c : 0;
        // ocean China
        Port_freight_maintenance__c port = getPortNameMap('Port').get(opportunity.Destination_Port__c);
        Decimal containerPrice = port != null && port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
        Decimal oceanChina = opportunity.Ocean_Freight_China__c != null ? opportunity.Ocean_Freight_China__c : 0;
        if (oceanNeedChangeIds.contains(opportunity.Id)) {
            if (regionContainerPower != null) oceanChina = containerPrice / regionContainerPower * rate;
            else oceanChina = 0;
        }
        System.debug('--------oceanChina : ' + oceanChina);

        // ocean Oversea
        Decimal oceanOversea = opportunity.Ocean_Freight_Oversea__c != null ? opportunity.Ocean_Freight_Oversea__c : 0;
        // land Oversea
        Port_freight_maintenance__c countryFreight = getPortNameMap('Country').get(opportunity.Destination_Country__c);
        Decimal landOversea = opportunity.Land_Freight_Oversea__c != null ? opportunity.Land_Freight_Oversea__c : 0;
        if (landNeedChangeIds.contains(opportunity.Id)) {
            if (countryFreight != null && countryFreight.Land_Freight_Oversea__c != null) landOversea = countryFreight.Land_Freight_Oversea__c * rate;
            else landOversea = 0;
        }
        System.debug('--------landOversea : ' + landOversea);

        if (new List<String>{'CFR', 'CIF', 'CIP', 'CPT', 'DAT'}.contains(opportunity.Trade_Term__c)) {
            System.debug('CFR, CIF, CIP, CPT, DAT');
            freightCost += landChina + oceanChina + oceanOversea;
            opportunity.Land_Freight_China__c = landChina;
            opportunity.Ocean_Freight_China__c = oceanChina;
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;
            opportunity.Land_Freight_Oversea__c = null;
            if ((oceanChina == 0 || oceanOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'DAP', 'DDP', 'DPU', 'DDU'}.contains(opportunity.Trade_Term__c)) {
            System.debug('DAP, DDP, DPU, DDU');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            opportunity.Land_Freight_China__c = landChina;
            opportunity.Ocean_Freight_China__c = oceanChina;
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;
            opportunity.Land_Freight_Oversea__c = landOversea;
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'FCA'}.contains(opportunity.Trade_Term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(opportunity.Local_Warehouse__c)) {
            System.debug('FCA Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            opportunity.Land_Freight_China__c = landChina;
            opportunity.Ocean_Freight_China__c = oceanChina;
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;
            opportunity.Land_Freight_Oversea__c = landOversea;
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'EXW'}.contains(opportunity.Trade_Term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(opportunity.Local_Warehouse__c)) {
            System.debug('EXW Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            opportunity.Land_Freight_China__c = null;
            opportunity.Ocean_Freight_China__c = oceanChina;
            opportunity.Ocean_Freight_Oversea__c = oceanOversea;
            opportunity.Land_Freight_Oversea__c = landOversea;
            if ((oceanChina == 0 || oceanOversea == 0 || landOversea == 0) && totalPower > 0) Emailflag = true;
        } else if (new List<String>{'FOB', 'FCA'}.contains(opportunity.Trade_Term__c)) {
            System.debug('FOB, FCA');
            freightCost += landChina;
            opportunity.Land_Freight_China__c = landChina;
            opportunity.Ocean_Freight_China__c = null;
            opportunity.Ocean_Freight_Oversea__c = null;
            opportunity.Land_Freight_Oversea__c = null;
        } else if (new List<String>{'EXW'}.contains(opportunity.Trade_Term__c)){
            System.debug('other(EXW)');
            opportunity.Land_Freight_China__c = null;
            opportunity.Ocean_Freight_China__c = null;
            opportunity.Ocean_Freight_Oversea__c = null;
            opportunity.Land_Freight_Oversea__c = null;
        }

        Decimal warehouseCost = opportunity.Warehouse_Premium__c != null ? opportunity.Warehouse_Premium__c : 0;
        freightCost += warehouseCost;  // totalPower;

        Decimal specialCost = opportunity.Logistic_Special_Cost_Per_W__c != null ? opportunity.Logistic_Special_Cost_Per_W__c : 0;
        freightCost += specialCost;

        // TODO :
        if(EmailFlag && !itemFlag){
            // if(opportunity.MOU_Type_Judgment__c == false){
            //     checkRecursive.EmailSend(1, opportunity);
            //      opportunity.IsOrNotRemindEmail__c = true;
            // }
        }
        return freightCost;
    }

    public Decimal getFreightCostByContract (leanx__lg_Contract__c contract) {
        System.debug('----getFreightCostByContract----');
        Double rate = getCodeRateMap().containsKey(contract.CurrencyIsoCode) ? getCodeRateMap().get(contract.CurrencyIsoCode) : 1;
        Decimal freightCost = 0;
        Decimal totalPower = getContractIdPowerMap().containsKey(contract.Id) ? getContractIdPowerMap().get(contract.Id) : contract.Total_Power_W__c;
        if (totalPower == null || totalPower == 0) return 0;

        Integer regionContainerPower;
        if (regionContainerPowerMap.containsKey(contract.Destination_Region__c)){
            regionContainerPower = regionContainerPowerMap.get(contract.Destination_Region__c);
            Integer containerCount = Math.round(totalPower / regionContainerPower);
            if (containerCount < 1) containerCount = 1;
            contract.Number_of_Containers__c = containerCount;
        }

        // land China
        Decimal landChina = contract.Land_Freight_China__c != null ? contract.Land_Freight_China__c : 0;
        // ocean
        Port_freight_maintenance__c port = getPortNameMap('Port').get(contract.Destination_Port__c);
        Decimal containerPrice = port != null && port.Warehouse_Premium__c != null ? port.Warehouse_Premium__c : 0;
        Decimal oceanChina = contract.Ocean_Freight_China__c != null ? contract.Ocean_Freight_China__c : 0;
        Decimal oceanOversea = contract.Ocean_Freight_Oversea__c != null ? contract.Ocean_Freight_Oversea__c : 0;
        if (oceanNeedChangeIds.contains(contract.Id)) {
            if (regionContainerPower != null) oceanChina = containerPrice / regionContainerPower * rate;
            else oceanChina = 0;
        }
        System.debug('--------oceanChina : ' + oceanChina);

        // land Oversea
        Port_freight_maintenance__c countryFreight = getPortNameMap('Country').get(contract.Destination_Country__c);
        Decimal landOversea = contract.Land_Freight_Oversea__c != null ? contract.Land_Freight_Oversea__c : 0;
        if (landNeedChangeIds.contains(contract.Id)) {
            if (countryFreight != null && countryFreight.Land_Freight_Oversea__c != null) landOversea = countryFreight.Land_Freight_Oversea__c * rate;
            else landOversea = 0;
        }
        System.debug('--------landOversea : ' + landOversea);

        if (new List<String>{'CFR', 'CIF', 'CIP', 'CPT', 'DAT'}.contains(contract.Trade_term__c)) {
            System.debug('CFR, CIF, CIP, CPT, DAT');
            freightCost += landChina + oceanChina + oceanOversea;
            contract.Land_Freight_China__c = landChina;
            contract.Ocean_Freight_China__c = oceanChina;
            contract.Ocean_Freight_Oversea__c = oceanOversea;
            contract.Land_Freight_Oversea__c = null;
        } else if (new List<String>{'DAP', 'DDP', 'DPU', 'DDU'}.contains(contract.Trade_term__c)) {
            System.debug('DAP, DDP, DPU, DDU');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            contract.Land_Freight_China__c = landChina;
            contract.Ocean_Freight_China__c = oceanChina;
            contract.Ocean_Freight_Oversea__c = oceanOversea;
            contract.Land_Freight_Oversea__c = landOversea;
        } else if (new List<String>{'FCA'}.contains(contract.Trade_term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(contract.Local_Warehouse__c)) {
            System.debug('FCA Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            contract.Land_Freight_China__c = landChina;
            contract.Ocean_Freight_China__c = oceanChina;
            contract.Ocean_Freight_Oversea__c = oceanOversea;
            contract.Land_Freight_Oversea__c = landOversea;
        } else if (new List<String>{'EXW'}.contains(contract.Trade_term__c) && 
                  !new List<String>{'Shang Rao Warehouse', 'Hai Ning Warehouse', 'N/A', null}.contains(contract.Local_Warehouse__c)) {
            System.debug('EXW Oversea Warehouse');
            freightCost += landChina + oceanChina + oceanOversea + landOversea;
            contract.Land_Freight_China__c = null;
            contract.Ocean_Freight_China__c = oceanChina;
            contract.Ocean_Freight_Oversea__c = oceanOversea;
            contract.Land_Freight_Oversea__c = landOversea;
        } else if (new List<String>{'FOB', 'FCA'}.contains(contract.Trade_term__c)) {
            System.debug('FOB, FCA');
            freightCost += landChina;
            contract.Land_Freight_China__c = landChina;
            contract.Ocean_Freight_China__c = null;
            contract.Ocean_Freight_Oversea__c = null;
            contract.Land_Freight_Oversea__c = null;
        } else if (new List<String>{'EXW'}.contains(contract.Trade_term__c)){
            System.debug('other(EXW)');
            contract.Land_Freight_China__c = null;
            contract.Ocean_Freight_China__c = null;
            contract.Ocean_Freight_Oversea__c = null;
            contract.Land_Freight_Oversea__c = null;
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
                for (leanx__pm_ProjectMember__c item : this.oppIdItemsMap.get(id)) {
                    power += item.Quantity__c * item.Power_W__c;
                }
                this.oppIdPowerMap.put(id, power);
            }
        }
        return oppIdPowerMap;
    }

    Map<String, Decimal> contractIdPowerMap;
    public Map<String, Decimal> getContractIdPowerMap () {
        if (contractIdPowerMap == null) {
            contractIdPowerMap = new Map<String, Decimal>();
            for (String id : this.contractIdItemsMap.keySet()) {
                Decimal power = 0;
                for (Contract_Component__c item : this.contractIdItemsMap.get(id)) {
                    if (item.Quantity__c != null && item.Power_W__c != null) power += item.Quantity__c * item.Power_W__c;
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

        for (Contract_Component__c item : [SELECT Id,
                                              Name,
                                              Product__c,
                                              Product__r.Name,
                                              Project_Product__c,
                                              Total_Power_W__c,
                                              Quantity__c,
                                              Power_W__c,
                                              Sales_Price__c,
                                              Estimated_Gross_Margin__c,
                                              Free_Power_W__c,
                                              Third_Party_Test_Cost__c,
                                              Transfer_Stock_Rate__c,
                                              CurrencyIsoCode,
                                              Special_Material_Cost_Per_W__c,
                                              Special_Material_Type__c,
                                              Special_Material__c
                                       FROM Contract_Component__c 
                                       WHERE Contract__c = :contractId]){
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
        List<Contract_Component__c> contractItems = new List<Contract_Component__c>();
        for (Object temp : data) {
            System.debug(temp);
            ItemWrapper itemWrapper = (ItemWrapper) JSON.deserialize(JSON.serialize(temp, true), ItemWrapper.class);
            contractItems.addAll(itemWrapper.transfer());
        }

        Map<Id, Contract_Component__c> itemIdContractItemMap = new Map<Id, Contract_Component__c>();
        for (Contract_Component__c item : contractItems) {
            System.debug('contract Item: ' + item);
            itemIdContractItemMap.put(item.Project_Product__c, item);
        }

        List<leanx__pm_ProjectMember__c> items = [
            SELECT Id,
                   Free_Power_W__c,
                   Third_Party_Test_Cost__c,
                   Transfer_Stock_Rate__c,
                   CurrencyIsoCode,
                   Special_Material_Cost_Per_W__c,
                   Special_Material_Type__c,
                   Special_Material__c
            FROM leanx__pm_ProjectMember__c
            WHERE Id IN :itemIdContractItemMap.keySet()];

        for (leanx__pm_ProjectMember__c item : items) {
            System.debug('item: ' + item);
            Contract_Component__c contractItem = itemIdContractItemMap.get(item.Id);
            item.Free_Power_W__c = contractItem.Free_Power_W__c;
            item.Third_Party_Test_Cost__c = contractItem.Third_Party_Test_Cost__c;
            item.Transfer_Stock_Rate__c = contractItem.Transfer_Stock_Rate__c;
            item.Special_Material_Cost_Per_W__c = contractItem.Special_Material_Cost_Per_W__c;
            item.Special_Material_Type__c = contractItem.Special_Material_Type__c;
            item.Special_Material__c = contractItem.Special_Material__c;     
        }

        System.debug('------------' + contractItems);
        update contractItems;
        RC_CostCenter.skipTrigger = true;
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

        public ItemWrapper (Contract_Component__c item) {
            System.debug('item :' + item);
            this.ids = item.Id;
            if (item.Project_Product__c != null) this.parentIds = item.Project_Product__c;
            this.isoCode = item.CurrencyIsoCode;
            this.productId = item.Product__c;
            this.productName = item.Name;
            // this.productName = item.Product__r.Name;
            this.totalPower = item.Total_Power_W__c;
            this.unitPower = item.Power_W__c != null ? item.Power_W__c : 0;
            this.quantity = item.Quantity__c != null ? item.Quantity__c : 0;
            this.unitPrice = item.Sales_Price__c != null ? item.Sales_Price__c : 0;
            // this.estimatedGrossMargin = item.Estimated_Gross_Margin__c != null ? item.Estimated_Gross_Margin__c : 0;
            this.freePower = item.Free_Power_W__c;
            this.testCost = item.Third_Party_Test_Cost__c;
            this.transferStock = item.Transfer_Stock_Rate__c;
            this.specialMaterialCostPerW = item.Special_Material_Cost_Per_W__c;
            this.specialMaterials = item.Special_Material__c;
            this.specialMaterialTypes = item.Special_Material_Type__c;
        }

        public ItemWrapper add (Contract_Component__c item) {
            this.ids += ',' + item.Id;
            if (item.Project_Product__c != null && this.parentIds != null) this.parentIds += ',' + item.Project_Product__c;
            else if (item.Project_Product__c != null) this.parentIds = item.Project_Product__c;
            this.totalPower += item.Total_Power_W__c;
            return this;
        }

        public List<Contract_Component__c> transfer () {
            List<Contract_Component__c> items = new List<Contract_Component__c>();
            RC_CostCenter handler = new RC_CostCenter();
            System.debug('leanx__lg_Contract__c item :' + this);
            List<String> ids = this.ids.split(',');
            List<String> parentIds = new List<String>();
            if (String.isNotBlank(this.parentIds)) parentIds = this.parentIds.split(',');
            for (Integer i = 0; i < ids.size(); i ++) {
                Contract_Component__c item = new Contract_Component__c();
                // Double rate = handler.getCodeRateMap().containsKey(this.isoCode) ? handler.getCodeRateMap().get(this.isoCode) : 1;
                item.Id = ids[i];
                if (parentIds.size() > i) item.Project_Product__c = parentIds[i];
                item.Free_Power_W__c = this.freePower != null ? this.freePower : 0;
                item.Third_Party_Test_Cost__c = this.testCost != null ? this.testCost : 0;
                // item.Third_Party_Test_Cost__c = this.testCost != null ? this.testCost * rate : 0;
                item.Transfer_Stock_Rate__c = this.transferStock != null ? this.transferStock : 0;
                item.Special_Material_Cost_Per_W__c = this.specialMaterialCostPerW != null ? this.specialMaterialCostPerW : 0;
                // item.Special_Material_Cost_Per_W__c = this.specialMaterialCostPerW != null ? this.specialMaterialCostPerW * rate : 0;
                item.Special_Material__c = this.specialMaterials;
                item.Special_Material_Type__c = this.specialMaterialTypes;
                items.add(item);
            }

            return items;
        }
    }

    public Decimal getTechnologyCostByContractItem (leanx__lg_Contract__c contract, Contract_Component__c item) {
        // Double rate = getCodeRateMap().containsKey(item.CurrencyIsoCode) ? getCodeRateMap().get(item.CurrencyIsoCode) : 1;
        Decimal technologyCost = 0;
        Decimal totalPower = getContractIdPowerMap().containsKey(contract.Id) ? getContractIdPowerMap().get(contract.Id) : 0;
        Decimal unitPrice = item.Sales_Price__c != null ? item.Sales_Price__c : 0;
        Decimal unitPower = item.Power_W__c != null ? item.Power_W__c : 0;
        Decimal freePower = item.Free_Power_W__c != null ? item.Free_Power_W__c : 0;
        Decimal testCostPerW = item.Third_Party_Test_Cost__c != null && totalPower != 0 ? item.Third_Party_Test_Cost__c / totalPower: 0;
        // Decimal testCostPerW = item.Third_Party_Test_Cost__c != null && totalPower != 0 ? item.Third_Party_Test_Cost__c * rate / totalPower: 0;
        Decimal transferStock = item.Transfer_Stock_Rate__c != null ? item.Transfer_Stock_Rate__c : 0;
        Decimal specialMaterialCostPerW = item.Special_Material_Cost_Per_W__c != null ? item.Special_Material_Cost_Per_W__c : 0;
        technologyCost += unitPower != 0 ? unitPrice * freePower / (unitPower + freePower) : 0;
        technologyCost += testCostPerW;
        technologyCost += transferStock / 100 * unitPrice * 0.15;
        technologyCost += specialMaterialCostPerW;
        // technologyCost += specialMaterialCostPerW * rate;

        return technologyCost;
    }

    // 5. product cost
    public Decimal getProductCostByItem (leanx__pm_Project__c opportunity, leanx__pm_ProjectMember__c item) {
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
        List<Product_Cost_Maintenance__c> regionCosts = getRegionCostsMap().get(opportunity.Destination_Region__c);
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
    public Decimal getCommisionRebateByOpportunity (leanx__pm_Project__c opportunity, leanx__pm_ProjectMember__c item) {
        Decimal commisionRebateCost = 0;
        Decimal totalPower = getOppIdPowerMap().containsKey(opportunity.Id) ? getOppIdPowerMap().get(opportunity.Id) : opportunity.Total_Power_W__c;
        Decimal commision = opportunity.Commission__c != null ? opportunity.Commission__c : 0;
        Decimal rebate = opportunity.Rebate__c != null ? opportunity.Rebate__c : 0;
        Decimal discount = opportunity.Discount__c != null ? opportunity.Discount__c : 0;
        if (opportunity.Commission_Type__c == 'Per/W') commisionRebateCost += commision;
        else if (opportunity.Commission_Type__c == 'Total Amount') commisionRebateCost += commision / totalPower;
        if (opportunity.Rebate_Type__c == 'Per/W') commisionRebateCost += rebate;
        else if (opportunity.Rebate_Type__c == 'Total Amount') commisionRebateCost += rebate / totalPower;
        else if (opportunity.Rebate_Type__c == '%') commisionRebateCost += rebate / 100 * item.Sales_Price__c;
        if (opportunity.Discount_Type__c == 'Per/W') commisionRebateCost += discount;
        else if (opportunity.Discount_Type__c == 'Total Amount') commisionRebateCost += discount / totalPower;
        else if (opportunity.Discount_Type__c == '%') commisionRebateCost += discount / 100 * item.Sales_Price__c;
        System.debug('-------- SOQL Count------- :' + Limits.getQueries());
        return commisionRebateCost;
    }

    // opportunity item cost $ /W
    public void calculateGrossMargin () {
        System.debug('----calculateGrossMargin----');
        for (leanx__pm_ProjectMember__c item : this.items) {
            leanx__pm_Project__c opportunity = getOpportunityIdMap().get(item.leanx__Project__c);
            if (opportunity == null || item.Sales_Price__c == null) continue;
            // 1. payment term
            Decimal paymentCost = getPaymentCostByOpportunity(opportunity, item);
            item.Payment_Cost_Per_W__c = paymentCost;
            // 2. insurence (if need)
            Decimal insurenceCost = getInsurenceCostByItem(opportunity, item);
            item.Insurence_Cost_Per_W__c = insurenceCost;
            // 3. freight
            Decimal freightCost = getFreightCostByOpportunity(opportunity, true);
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
                item.Sales_Price__c - 
                paymentCost -
                insurenceCost -
                freightCost -
                // technologyCost -
                item.Product_Cost__c -
                commisionRebateCost;
            item.Total_Gross_Margin__c = item.Estimated_Gross_Margin__c * item.Quantity__c * item.Power_W__c;
        }

        if (this.existItems != null && this.existItems.size() > 0) update this.existItems;
        update getOpportunityIdMap().values();
        System.debug('----calculateGrossMargin out----');
    }

    // contract item cost $ /W
    public void calculateContractGrossMargin () {
        System.debug('----calculateContractGrossMargin----');
        for (Contract_Component__c item : this.contractItems) {
            leanx__lg_Contract__c contract = getContractIdMap().get(item.Contract__c);
            if (contract == null || item.Sales_Price__c == null) continue;
            // 1. payment term
            Decimal paymentCost = item.Payment_Cost_Per_W__c != null ? item.Payment_Cost_Per_W__c : 0; // getPaymentCostByOpportunity(opportunity, item);
            // 2. insurence (if need)
            Decimal insurenceCost = item.Insurence_Cost_Per_W__c != null ? item.Insurence_Cost_Per_W__c : 0; // getInsurenceCostByItem(opportunity, item);
            // 3. freight
            Decimal freightCost = getFreightCostByContract(contract);
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
                item.Sales_Price__c - 
                paymentCost -
                insurenceCost -
                freightCost -
                // technologyCost -
                productCost -
                commisionRebateCost;
            item.Confirmed_Gross_Margin__c = 
                (item.Estimated_Gross_Margin__c != null ? item.Estimated_Gross_Margin__c : 0) - 
                technologyCost;
            item.Total_Gross_Margin__c = item.Confirmed_Gross_Margin__c * item.Quantity__c * item.Power_W__c;
        }

        if (this.existContractItems != null && this.existContractItems.size() > 0) update this.existContractItems;
        update getContractIdMap().values();
        System.debug('----calculateContractGrossMargin out----');
    }
}