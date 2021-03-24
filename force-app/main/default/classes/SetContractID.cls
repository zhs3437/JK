public class SetContractID {
    public static void UpdateConID(Set<String> oppId,String conId){
        List<String> bookstockIdLst= new List<String>();
        if(oppId !=null){
            List<Apply_Inventory__c> bookStockLst =[Select Id,Name,Opportunity__c from Apply_Inventory__c where Opportunity__c in: oppId];
            for(Apply_Inventory__c book : bookStockLst){
            bookstockIdLst.add(book.Id);
             }
            
            System.debug('oppId-->'+oppId);
             System.debug('conId-->'+conId);
            if(bookStockLst !=null){
                 List<Distribution_Stock__c> DisStockLst =[Select Id,Name,Contract_PO_PI__c,Apply_Inventory__c from Distribution_Stock__c where Apply_Inventory__c in:bookstockIdLst];
            List<Distribution_Stock__c> UpdateDisStockLst = new List<Distribution_Stock__c>();
            for(Distribution_Stock__c DisStock :DisStockLst){
                DisStock.Contract_PO_PI__c = conId;
                UpdateDisStockLst.add(DisStock);
            }
            
            if(UpdateDisStockLst !=null){
               update  UpdateDisStockLst;
            }
            }
            
        }
      
        
    }

}