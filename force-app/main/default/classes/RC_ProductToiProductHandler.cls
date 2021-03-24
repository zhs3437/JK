public without sharing class RC_ProductToiProductHandler extends TriggerHandler {
    
    public override void afterInsert() {
        updateProduct();
    }
    
    public override void afterUpdate() {
        updateProduct();
    }

    void updateProduct() {
        Map<String, leanx__hr_Resource__c> exterIdProductMap = new Map<String, leanx__hr_Resource__c>();
        for (Id productId : Trigger.newMap.keySet()) {
            Product2 product = (Product2)(Trigger.newMap.get(productId));
            leanx__hr_Resource__c iproduct = (leanx__hr_Resource__c)JSON.deserialize(JSON.serialize(product), leanx__hr_Resource__c.class);
            iproduct.Id = null;
            iproduct.Product__c = productId;
            iproduct.IsActive__c = product.IsActive;
            iproduct.ExterId__c = product.Name;
            if (!exterIdProductMap.containsKey(iproduct.ExterId__c)) exterIdProductMap.put(iproduct.ExterId__c, iproduct);
        }
        upsert exterIdProductMap.values() Schema.leanx__hr_Resource__c.Fields.ExterId__c;
    }
}