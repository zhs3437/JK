/**
 * @author Miller Zhao
 * @date 2021-04-14
 * @description This class is used to update Contract Product Non_Mainstream_Product__c
 */
public without sharing class JK_NoMainstreamContractProductHandler {
    private List<Product_Detail__c> lstContractItem;

    /**
     * @param lstContractItem list of Product_Detail__c
     * @description Constructor
     */
    public JK_NoMainstreamContractProductHandler(List<Product_Detail__c> lstContractItem) {
        this.lstContractItem = lstContractItem;
    }

    //Trigger.isExecuting
    public void handle(){
        Set<Id> setProductId = new Set<Id>();
        if(lstContractItem == null) return;
        for(Product_Detail__c objContractItem : lstContractItem){
            if(objContractItem.Product__c != null){
                setProductId.add(objContractItem.Product__c);
            }
        }
        Map<Id, Product2> mapProduct = new Map<Id, Product2> ([select Id from Product2 where Id IN: setProductId and Non_Mainstream_Product__c = true]);

        for(Product_Detail__c objContractItem : lstContractItem){
            //Product is No Mainstream
            if(objContractItem.Product__c != null && mapProduct.containsKey(objContractItem.Product__c)){
                objContractItem.Non_Mainstream_Product__c = true;
            }
        }
    }
}