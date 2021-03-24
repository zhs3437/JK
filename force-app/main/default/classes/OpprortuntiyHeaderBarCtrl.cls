public class OpprortuntiyHeaderBarCtrl {
    public boolean AddProductInfo {get;set;}
    public boolean PaymentTermIsNull {get;set;}
    public boolean WarehouseIsNull {get;set;}
    public boolean ApplyInventory {get;set;}
    public boolean ApplyTransit {get;set;}
    public boolean WarehouseIsNullAndApplyInventory {get;set;}
    public boolean getSapProductCode {get;set;}
    public boolean PriceEqual{get;set;}
    public boolean MWEqual{get;set;}
    public boolean QuantityEqual{get;set;}
    public boolean PowerEqual{get;set;}    
    
    public Decimal keep_day{get{InventoryInfo__c ii = InventoryInfo__c.getValues(opp.Region__c);return ii.KeepDay__c;}set;}
    public Opportunity opp{get;set;}
    public OpprortuntiyHeaderBarCtrl(){
        initHeaderBar();
    }
    public OpprortuntiyHeaderBarCtrl(apexpages.StandardController std){
        opp = [select id,
               RecordType.Name,
               Total_Price__c,
               Green_Channel_Approval__c,
               Payment_Term_Description__c,
               Local_Warehouse__c,
               Region__c,
               ownerid,
               Total_MW__c,
               Total_Power__c,
               BMO_specialist__r.name,
               Total_Quantity__c,
               Total_Opp_MW__c,
               Total_Opp_Power__c,
               Total_Opp_Price__c,
               Total_Opp_Quantity__c,
               faOpportunity__c,
               Opportunity_Type__c,
               Inventory_Approval_Status__c
               from Opportunity 
               where id =: std.getId()];
        initHeaderBar();
    }
    
    private void initHeaderBar(){
        System.debug('-------->chushihua');
        AddProductInfo = false;
        PaymentTermIsNull = false;
        WarehouseIsNull = false;
        ApplyTransit = false;
        PriceEqual   =false;
        WarehouseIsNullAndApplyInventory = false;
        //getSapProductCode = false;
        System.debug('-------->oppID' + opp);
        //System.debug('-------->hasNoProductCode' + hasNoProductCode());
        //System.debug('########Total_Price__c' + opp.Total_Price__c);
        //System.debug('########Green_Channel_Approval__c' + opp.Green_Channel_Approval__c);
        if(opp != null){
            try{
                getSapProductCode = false;
                System.debug('-------->getSapProductCode' + getSapProductCode);
                if(hasNoProductCode()){
                    getSapProductCode = true;
                    System.debug('----->getSapProductCode:'+ getSapProductCode);
                }
                if(opp.Total_Price__c == 0 && opp.Green_Channel_Approval__c==false){
                    AddProductInfo = true;
                }
                else if(string.isEmpty(opp.Payment_Term_Description__c)){
                    PaymentTermIsNull = true;
                }
                else if(string.isEmpty(opp.Local_Warehouse__c)){
                    WarehouseIsNull = true;
                    System.debug('-------->cankuxinxi:' + WarehouseIsNull);
                }
                else if(hasInventory()){ 
                    ApplyInventory = true;
                    System.debug('-------->ApplyInventory:' + ApplyInventory);
                }else if(hasNotInventory()){
                    WarehouseIsNullAndApplyInventory = true;
                    System.debug('-------->WarehouseIsNullAndApplyInventory:' + WarehouseIsNullAndApplyInventory);
                }else if(hasTransit()){
                    ApplyTransit = true;
                    System.debug('-------->ApplyTransit:' + ApplyTransit);
                }
                  System.debug('-------->Total_Opp_Price__c:---->' + opp.Total_Opp_Price__c);
                  System.debug('-------->Total_Price__c:--->' + opp.Total_Price__c );
                if(opp.Total_Price__c != 0 && opp.Total_Opp_Price__c !=0 && opp.Total_Opp_Price__c !=null && opp.Total_Opp_Price__c !=opp.Total_Price__c  && opp.RecordType.Name=='Europe' &&  opp.Opportunity_Type__c=='Frame' ){
                    PriceEqual =true;
                     System.debug('-------->PriceEqual:' + PriceEqual);
                }
                 if(opp.Total_MW__c != 0 && opp.Total_Opp_MW__c !=0 && opp.Total_Opp_MW__c !=null && opp.Total_Opp_MW__c !=opp.Total_MW__c  && opp.RecordType.Name=='Europe' &&  opp.Opportunity_Type__c=='Frame' ){
                    MWEqual =true;
                     System.debug('-------->PriceEqual:' + PriceEqual);
                }
                 if(opp.Total_Quantity__c != 0 && opp.Total_Opp_Quantity__c !=0 && opp.Total_Opp_Quantity__c !=null && opp.Total_Opp_Quantity__c !=opp.Total_Quantity__c  && opp.RecordType.Name=='Europe' &&  opp.Opportunity_Type__c=='Frame' ){
                    QuantityEqual =true;
                     System.debug('-------->PriceEqual:' + PriceEqual);
                }
                 if(opp.Total_Power__c != 0 && opp.Total_Opp_Power__c !=0 && opp.Total_Opp_Power__c !=null && opp.Total_Opp_Power__c !=opp.Total_Power__c  && opp.RecordType.Name=='Europe' &&  opp.Opportunity_Type__c=='Frame' ){
                    PowerEqual =true;
                     System.debug('-------->PriceEqual:' + PriceEqual);
                }                
            }catch(exception e){
                System.debug('########e: ' + String.valueOf(e));
                System.debug('########Total_Price__c' + opp.Total_Price__c);
            }
        }
    }
    /*
List<OpportunityLineItem>  itemList = [select id, 
Opportunity.Local_Warehouse__c,
SAP_Materiel_No__c,
Quantity
from OpportunityLineItem
where Opportunityid =: opp.id];
*/
    public boolean hasInventory(){
        //1取得 业务机会的 仓库名称，取得每一条产品的 物料号码和 数量。
        List<OpportunityLineItem>  itemList = [select id, 
                                               Opportunity.Local_Warehouse__c,
                                               SAP_Materiel_No__c,
                                               Quantity
                                               from OpportunityLineItem
                                               where Opportunityid =: opp.id];
        //2循环调用 Inventory Helper的CheckInventory方法，参数。
        for(OpportunityLineItem item : itemList){
            //都存在，提示：可以进行预留，并显示OK按钮。
            if(!InventoryHelper.checkInventory(item.Opportunity.Local_Warehouse__c, item.SAP_Materiel_No__c, item.Quantity)){
                return false;
            }
        }
        return true;
    }    
    
    /*
*WarehouseIsNull and has not Inventory  create by jason  
*/
    public boolean hasNotInventory(){
        List<OpportunityLineItem>  itemList = [select id, 
                                               Opportunity.Local_Warehouse__c,
                                               SAP_Materiel_No__c,
                                               Quantity
                                               from OpportunityLineItem
                                               where Opportunityid =: opp.id];
        for(OpportunityLineItem item : itemList){
            
            if(InventoryHelper.checkInventory(item.Opportunity.Local_Warehouse__c, item.SAP_Materiel_No__c, item.Quantity)){
                opp.Inventory_Approval_Status__c = 'Rejected';
                return false;
            }
        }
        return true;
        
    }
    
    /*
*Apply Transit   create by jason
*/
    public boolean hasTransit(){
        List<OpportunityLineItem>  itemList = [select id, 
                                               Opportunity.Local_Warehouse__c,
                                               SAP_Materiel_No__c,
                                               Quantity
                                               from OpportunityLineItem
                                               where Opportunityid =: opp.id];
        for(OpportunityLineItem item : itemList){
            if(!InventoryHelper.checkTranist(item.Opportunity.Local_Warehouse__c, item.SAP_Materiel_No__c, item.Quantity)){
                return false;
            }
        }
        return true;
    }
    
    /*
*create by jason 
*获取不到物料号提示错误信息
*/
    
    public boolean hasNoProductCode(){
        List<OpportunityLineItem>  itemList = [select id, 
                                               Opportunity.Local_Warehouse__c,
                                               SAP_Materiel_No__c,
                                               Quantity
                                               from OpportunityLineItem
                                               where Opportunityid =: opp.id];
        //2循环调用 Inventory Helper的CheckInventory方法，参数。
        for(OpportunityLineItem item : itemList){
            if(!InventoryHelper.getSAPproductCode(opp.Id)){
                return true;
            }
        }
        return false;
    }
    /* auto book inventory. */
    public void bookInventory(){
        InventoryHelper.autoBookInventory(opp.Id);
    }
    
    /* auto book inventory. */
    public void submitTransit(){
        //Logistics
        //PMC
        //BMO
        SendEmailUtils.sendTransitToLogistics(opp.id);
        SendEmailUtils.sendTransitToBMO(opp.id,Opp.ownerid);
        SendEmailUtils.sendTransitToPMC(opp.id);
    }
    public void runTest(){
        String run = 'run Test';
        run = 'run Test';
    }
}