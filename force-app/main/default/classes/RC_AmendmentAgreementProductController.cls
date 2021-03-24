public without sharing class RC_AmendmentAgreementProductController {

    // TODO : field mapping
    public class ItemWrapper {
        public Id id;
        public Id productId;
        public Id orderId;
        public String name;
        public String productName;
        public String productSeries;
        public String productSeriesType;
        public String productGrade;
        public String productContractName;
        public Decimal quantity;
        public Decimal power;
        public Decimal price;
        public String isoCode;
        public String batteryType;
        public String frameHeight;
        public String mp;
        public String expectedDeliveryDate;
        public String guaranteedDeliveryDate;
        public String deliveryDateDescription;
        public String goodsDecription;
        public Boolean isDelete;

        public ItemWrapper () {}

        public ItemWrapper (Amendment_Agreement_Product__c item) {
            this.id = item.Id;
            this.productId = item.Product__c;
            this.orderId = item.Amendment_Agreement__c;
            this.name = item.Name;
            this.productName = item.Product__r.Name;
            this.productSeries = item.Product_Series__c;
            this.productSeriesType = item.Main_Type__c;
            this.productGrade = item.Product_Grade__c;
            this.productContractName = item.Product_Name__c;
            this.quantity = item.Quantity__c;
            this.power = item.Power_W_Manual__c;
            this.price = item.Sales_Price__c;
            this.isoCode = item.CurrencyIsoCode;
            this.batteryType = item.Battery_Type__c != null ? item.Battery_Type__c : '';
            this.frameHeight = item.Frame_B_side_Height__c != null ? item.Frame_B_side_Height__c : '';
            this.mp = item.MP__c != null ? item.MP__c : '';
            this.expectedDeliveryDate = QW_Utils.dateToString(item.Expected_Delivery_Date__c);
            this.guaranteedDeliveryDate = QW_Utils.dateToString(item.Guaranteed_Delivery_Date__c);
            this.deliveryDateDescription = item.Delivery_Date_Description__c;
            this.goodsDecription = item.Goods_Description__c;
            this.isDelete = false;
        }

        public ItemWrapper (leanx__hr_Resource__c product) {
            this.productId = product.Id;
            this.productName = product.Name;
            this.productSeries = product.Series__c;
            this.productSeriesType = product.Series_Type__c;
            this.isDelete = false;
        }

        public Amendment_Agreement_Product__c transfer () {
            return new Amendment_Agreement_Product__c(
                Id = this.id,
                Amendment_Agreement__c = this.orderId,
                Name = this.name,
                Quantity__c = this.quantity,
                Power_W_Manual__c = this.power,
                Sales_Price__c = this.price,
                CurrencyIsoCode = this.isoCode,
                Product__c = this.productId,
                Product_Series__c = this.productSeries,
                Product_Name__c = this.productContractName,
                Main_Type__c = this.productSeriesType,
                Product_Grade__c = this.productGrade,
                Battery_Type__c = this.batteryType,
                Frame_B_side_Height__c = this.frameHeight,
                MP__c = this.mp,
                Expected_Delivery_Date__c = String.isNotBlank(this.expectedDeliveryDate) ? Date.parse(this.expectedDeliveryDate) : null,
                Guaranteed_Delivery_Date__c = String.isNotBlank(this.guaranteedDeliveryDate) ? Date.parse(this.guaranteedDeliveryDate) : null,
                Delivery_Date_Description__c = this.deliveryDateDescription,
                Goods_Description__c = this.goodsDecription
            );
        }
    }

    @RemoteAction
    public static Object getComponentsByProjectId(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String orderId = (String)data.get('orderId');
        Map<String, Object> result = new Map<String, Object>();
        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();

        for (Amendment_Agreement__c order : [SELECT Id, Name, CurrencyIsoCode FROM Amendment_Agreement__c WHERE Id = :orderId]) {
            result.put('order', order);
        }

        // TODO : field polishing
        for (Amendment_Agreement_Product__c item : [SELECT Id,
                                                           Name,
                                                           Quantity__c,
                                                           Power_W_Manual__c,
                                                           Sales_Price__c,
                                                           CurrencyIsoCode,
                                                           Amendment_Agreement__c,
                                                           Product__c,
                                                           Product__r.Name,
                                                           Product_Series__c,
                                                           Main_Type__c,
                                                           Product_Grade__c,
                                                           Product_Name__c,
                                                           Battery_Type__c,
                                                           Frame_B_side_Height__c,
                                                           MP__c,
                                                           Expected_Delivery_Date__c,
                                                           Guaranteed_Delivery_Date__c,
                                                           Delivery_Date_Description__c,
                                                           Goods_Description__c
                                                    FROM Amendment_Agreement_Product__c 
                                                    WHERE Amendment_Agreement__c = :orderId]){
            itemWrappers.add(new ItemWrapper(item));
        }

        result.put('items', itemWrappers);
        result.put('batteryType', Amendment_Agreement_Product__c.Battery_Type__c.getDescribe().getPicklistValues());
        result.put('frameHeight', Amendment_Agreement_Product__c.Frame_B_Side_Height__c.getDescribe().getPicklistValues());
        result.put('mp', Amendment_Agreement_Product__c.MP__c.getDescribe().getPicklistValues());
        result.put('productGrade', leanx__pm_ProjectMember__c.Product_Grade__c.getDescribe().getPicklistValues());
       
        return result;
    }

    @RemoteAction
    public static Object setComponentsByProjectId(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> result = new Map<String, Object>();
        try {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
            List<Amendment_Agreement_Product__c> upsertItems = new List<Amendment_Agreement_Product__c>();
            List<Amendment_Agreement_Product__c> deleteItems = new List<Amendment_Agreement_Product__c>();

            for (Object o : (List<Object>)JSON.deserializeUntyped(JSON.serialize(data.get('items')))) {
                ItemWrapper wrapper = (ItemWrapper)JSON.deserialize(JSON.serialize(o), ItemWrapper.class);
                Amendment_Agreement_Product__c item = wrapper.transfer();
                if (wrapper.isDelete && String.isNotBlank(wrapper.id)) deleteItems.add(item);
                else if (!wrapper.isDelete) upsertItems.add(item);
            }

            if (upsertItems.size() > 0) upsert upsertItems;
            if (deleteItems.size() > 0) delete deleteItems;
            result.put('code', 'success');
        } catch (Exception e) {
            result.put('code', 'error');
            result.put('msg', e.getMessage());
        }

        return result;
    }

    @RemoteAction
    public static Object getProducts(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String query = (String)data.get('query');
        Map<String, Object> result = new Map<String, Object>();
        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();
        for (leanx__hr_Resource__c product : [SELECT Id,
                                                     Name,
                                                     Series__c,
                                                     Series_Type__c
                                              FROM leanx__hr_Resource__c
                                              WHERE Name LIKE :'%' + query + '%'
                                            //   AND Active__c = true
                                              ORDER BY Name
                                              LIMIT 15]){
            itemWrappers.add(new ItemWrapper(product));
        }

        result.put('data', itemWrappers);
        return result;
    }
}