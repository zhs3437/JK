public class InventoryHelper{
    
    //Warehouse
    //Materiel Number
    //product count
    //return ture/false
    
    public static boolean checkInventory(string warehouse,
                                         string Materiel_no,
                                         Decimal quantity){
                                             list<Inventory__c> lst = [select id
                                                                       from Inventory__c
                                                                       where Warehouse2__c =: warehouse 
                                                                       and SAP_Materiel_No__c =: Materiel_no 
                                                                       and Quantity__c  >=: quantity];
                                             return lst.size()>0;
                                         }
    
    public static boolean checkTranist(string warehouse,
                                       string Materiel_no,
                                       Decimal quantity){
                                           list<Inventory__c> lst = [select id,Special_Stock_No__c
                                                                     from Inventory__c 
                                                                     where Warehouse2__c =: warehouse
                                                                     and SAP_Materiel_No__c =: Materiel_no 
                                                                     and Quantity__c  >=: quantity
                                                                     and Special_Stock_No__c like 'T%'];
                                           return  lst.size()>0;                             
                                       }
    
    //create by jason   
    public static boolean getSAPproductCode(string oppId){
        List<SAP_Product__c> sapList = new List<SAP_Product__c>();
        if(oppId != null){
            OpportunityLineItem item = null;
            List<OpportunityLineItem> items =  [select id
                                                ,Opportunity.Local_Warehouse__c
                                                ,SAP_Materiel_No__c
                                                ,Quantity
                                                ,Opportunity.Region__c
                                                from OpportunityLineItem
                                                where Opportunityid =: oppId];
            if(items != null && items.size()>0){
                item = items[0];
            }
            sapList = [select id, Certification__c
                       ,Color_of_Module__c
                       ,Type_of_module__c,Grade__c
                       ,Special_required__c
                       ,Bus_bars_of_cell__c
                       ,Product_Code__c
                       ,Product_Name__c
                       ,Product_Description__c 
                       from SAP_Product__c 
                       where Product_Code__c =: item.SAP_Materiel_No__c];
            
        }
        return sapList.size()>0;
    }
    public static boolean getSAPproductCodeOrder(string ordId){
        List<SAP_Product__c> sapList = new List<SAP_Product__c>();
        if(ordId != null){
            OrderItem item = null;
            List<OrderItem> items =  [select id
                                      ,SAP_Materiel_No__c
                                      ,Quantity
                                      from OrderItem
                                      where Orderid =: ordId];
            if(items != null && items.size()>0){
                item = items[0];
            }
            sapList = [select id, Certification__c
                       ,Color_of_Module__c
                       ,Type_of_module__c,Grade__c
                       ,Special_required__c
                       ,Bus_bars_of_cell__c
                       ,Product_Code__c
                       ,Product_Name__c
                       ,Product_Description__c 
                       from SAP_Product__c 
                       where Product_Code__c =: item.SAP_Materiel_No__c];
            
        }
        return sapList.size()>0;
    }
    
    
    
    public static boolean autoBookInventory(string oppId){
        //ApplyInventoryGenerater.generate(oppId);
        
        List<Apply_Inventory__c> invList = new List<Apply_Inventory__c>();
        if(oppId != null){
            invList = [select id, Status__c from Apply_Inventory__c where id =: oppId];
            for(Apply_Inventory__c ai : invList ){
                ai.Status__c = 'Book';
            }
            
            System.debug('*********oppid'+oppId);
            
            List<OpportunityLineItem> items =  [select id, 
                                                Opportunity.Local_Warehouse__c,
                                                SAP_Materiel_No__c,
                                                Quantity,
                                                Opportunity.Region__c
                                                from OpportunityLineItem
                                                where Opportunityid =: oppId];
            
            System.debug('*********items '+items );
            for(OpportunityLineItem item : items){
                InventoryInfo__c info = InventoryInfo__c.getValues(item.Opportunity.Region__c);
                Apply_Inventory__c inv = new Apply_Inventory__c();
                inv.Quantity__c           = item.Quantity;
                inv.Opportunity__c        = oppId;
                inv.Product__c            = item.Opportunityid;
                inv.Warehouse__c          = item.Opportunity.Local_Warehouse__c;
                inv.Inventory__c          = item.SAP_Materiel_No__c + item.Opportunity.Local_Warehouse__c;
                inv.Due_Date__c           = Date.today().addDays(integer.valueOf(info.KeepDay__c));
                inv.Reminder_Date__c      = Date.today().addDays(integer.valueOf(info.KeepDay__c) - 1);
                invList.add(inv);
                
                System.debug('*********inv'+inv);
            }
        }
        
        List<Opportunity> inventoryApprovals = [select id, Inventory_Approval_Status__c from Opportunity ];     
        for(Opportunity inventoryApproval : inventoryApprovals){
            inventoryApproval.Inventory_Approval_Status__c = 'Approved';
        }
        if(invList.size()>0){
            try{
                System.debug('*********invList'+invList);
                insert invList;
                return true;
            }catch(Exception e){
                System.debug('*********error'+e);
            }
        }
        return false;
    }     
    public void runTest(){
        String run = 'run Test';
        run = 'run Test';
    }
}