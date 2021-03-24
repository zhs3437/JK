public without sharing class RC_ProjectComponentController {

    // TODO : field mapping
    public class ItemWrapper {
        public Id id;
        public Id productId;
        public Id projectId;
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
        public String goodsDescription;
        public Boolean isDelete;

        public ItemWrapper () {}

        public ItemWrapper (leanx__pm_ProjectMember__c item) {
            this.id = item.Id;
            this.productId = item.Product__c;
            this.projectId = item.leanx__Project__c;
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
            this.goodsDescription = item.Goods_Description__c;
            this.isDelete = false;
        }

        public ItemWrapper (leanx__hr_Resource__c product) {
            this.productId = product.Id;
            this.productName = product.Name;
            this.productSeries = product.Series__c;
            this.productSeriesType = product.Series_Type__c;
            this.isDelete = false;
        }

        public leanx__pm_ProjectMember__c transfer () {
            return new leanx__pm_ProjectMember__c(
                Id = this.id,
                leanx__Project__c = this.projectId,
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
                Goods_Description__c = this.goodsDescription
            );
        }
    }

    @RemoteAction
    public static Object getComponentsByProjectId(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        String projectId = (String)data.get('projectId');
        Map<String, Object> result = new Map<String, Object>();
        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();

        for (leanx__pm_Project__c project : [SELECT Id, 
                                                    Name, 
                                                    CurrencyIsoCode, 
                                                    RecordType.Name 
                                             FROM leanx__pm_Project__c 
                                             WHERE Id = :projectId]) {
            result.put('project', project);
        }
        
        // TODO : field polishing
        for (leanx__pm_ProjectMember__c item : [SELECT Id,
                                                       Name,
                                                       Quantity__c,
                                                       Power_W_Manual__c,
                                                       Sales_Price__c,
                                                       CurrencyIsoCode,
                                                       leanx__Project__c,
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
                                                FROM leanx__pm_ProjectMember__c 
                                                WHERE leanx__Project__c = :projectId]){
            itemWrappers.add(new ItemWrapper(item));
        }

        result.put('items', itemWrappers);
        result.put('batteryType', leanx__pm_ProjectMember__c.Battery_Type__c.getDescribe().getPicklistValues());
        result.put('frameHeight', leanx__pm_ProjectMember__c.Frame_B_side_Height__c.getDescribe().getPicklistValues());
        result.put('mp', leanx__pm_ProjectMember__c.MP__c.getDescribe().getPicklistValues());
        result.put('productGrade', leanx__pm_ProjectMember__c.Product_Grade__c.getDescribe().getPicklistValues());
       
        return result;
    }

    @RemoteAction
    public static Object setComponentsByProjectId(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> result = new Map<String, Object>();
        try {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
            List<leanx__pm_ProjectMember__c> upsertItems = new List<leanx__pm_ProjectMember__c>();
            List<leanx__pm_ProjectMember__c> deleteItems = new List<leanx__pm_ProjectMember__c>();

            for (Object o : (List<Object>)JSON.deserializeUntyped(JSON.serialize(data.get('items')))) {
                ItemWrapper wrapper = (ItemWrapper)JSON.deserialize(JSON.serialize(o), ItemWrapper.class);
                leanx__pm_ProjectMember__c item = wrapper.transfer();
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
        List<leanx__hr_Resource__c> items = [
            SELECT Id,
                   Name,
                   Series__c,
                   Series_Type__c
            FROM leanx__hr_Resource__c
            WHERE Name LIKE :'%' + query + '%'
            ORDER BY Name
            LIMIT 15];

        for (leanx__hr_Resource__c product : items){
            itemWrappers.add(new ItemWrapper(product));
        }

        result.put('data', itemWrappers);
        return result;
    }

    // 163 78TR 单面  'JKMxxxM-7RL3, JKMxxxM-7RL3-V'
    // 182 72HC 单面  'JKMxxxM-72HL4, JKMxxxM-72HL4-V'
    // 182 72HC 双面双玻  'JKMxxxM-72HL4-BDVP'
    // 182 72HC 双面透明背板  'JKMxxxM-72HL4-TV'
    // N型 163 60TR 单面  'JKMxxxN-6TL3, JKMxxxN-6TL3-V'
    // N型 163 66TR 单面  'JKMxxxN-6RL3, JKMxxxN-6RL3-V'
    static List<List<String>> producable = new List<List<String>>{
        new List<String>{'JKM', 'M-7RL3'},
        new List<String>{'JKM', 'M-7RL3-V'},
        new List<String>{'JKM', 'M-72HL4'},
        new List<String>{'JKM', 'M-72HL4-V'},
        new List<String>{'JKM', 'M-72HL4-BDVP'},
        new List<String>{'JKM', 'M-72HL4-TV'},
        new List<String>{'JKM', 'N-6TL3'},
        new List<String>{'JKM', 'N-6TL3-V'},
        new List<String>{'JKM', 'N-6RL3'},
        new List<String>{'JKM', 'N-6RL3-V'}
    };

    @RemoteAction
    public static Object checkProducts(String dataStr) {
        System.debug('------------' + dataStr);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(dataStr);
        Map<String, Object> project = (Map<String, Object>) data.get('project');
        List<Object> products = (List<Object>) data.get('products');
        List<String> productIds = new List<String>();
        for (Object o : products) {
            Map<String, Object> product = (Map<String, Object>)o;
            String productId = (String)product.get('productId');
            productIds.add(productId);
        }
        Map<String, Object> result = new Map<String, Object>();
        String projectId = (String)project.get('Id');
        List<Product_Application_Detail__c> padNews = [
            SELECT Id,
                   Name
            FROM Product_Application_Detail__c 
            WHERE (Product_Application__r.Project__c = :projectId AND Product_Application__r.Stage__c = 'Approved')];
            // OR Kucun__c = 'New Product'
        List<Product_Application_Detail__c> padStocks = [
            SELECT Id,
                   Name
            FROM Product_Application_Detail__c 
            WHERE Kucun__c = 'Stock'];
        Map<Id, leanx__hr_Resource__c> productMap = new Map<Id, leanx__hr_Resource__c>(
            [SELECT Id, IsMainstream__c FROM leanx__hr_Resource__c WHERE Id IN :productIds]
        );
        Map<String, Object> productConfig = new Map<String, Object>();
        for (Object o : products) {
            Map<String, Object> product = (Map<String, Object>)o;
            String productName = (String)product.get('productName');
            String productId = (String)product.get('productId');
            Boolean flag_New = false;
            Boolean flag_Stock = false;
            if (String.isBlank(productName)) continue;
            if (productMap.containsKey(productId) && productMap.get(productId).IsMainstream__c) flag_New = true;
            for (List<String> r : producable) {
                if (!productName.startsWith(r[0]) || !productName.endsWith(r[1])) continue;
                flag_New = true;
                break;
            }

            for (Product_Application_Detail__c pad : padNews) {
                String prefixName = pad.Name.split('xxx')[0];
                String suffixName = pad.Name.split('xxx')[1];
                Decimal power = pad.W__c;
                if (!productName.startsWith(prefixName) || !productName.endsWith(suffixName) || power != (Decimal)product.get('power')) continue;
                flag_New = true;
                break;
            }
            
            for (Product_Application_Detail__c pad : padStocks) {
                if (productName != pad.Name) continue;
                flag_Stock = true;
                break;
            }

            productConfig.put(productName, new Map<String, Object>{
                'isNewable' => flag_New,
                'isStockable' => flag_Stock
            });
        }

        result.put('productConfig', productConfig);
        return result;
    }
}