global with sharing class ExecuteProductionScheduleDetailsInsert {
    public Contract con{get;set;}
    public Production_Schedule_Detail__c pdop  {get;set;}
    public List<Production_Schedule_Detail__c> prodList  {get;set;}
    public String ProductEditID{get;set;}
  /**
     * for Contract Insert Data button
     */
    webService static string clickNewButton(  String id  ){
        Production_Schedule_Detail__c pdop = new Production_Schedule_Detail__c();
        system.debug('----------------id:'+id);
        Contract cont = [Select id,Approval_Status__c,Factory__c,Supply_by__c,Owner.Name,OwnerId,ContractNumber,StartDate, SELLER__c, EndDate, Destination__c, BuyerAccount__c,BUYER__c,BuyerAccount__r.Name,ETD__c From Contract  where ID=:id limit 1];
        System.debug('---------------cont:'+cont);
      
        set<id> contractId = new set<id>();
        contractId.add(cont.id);
        system.debug('----------------contractId:'+contractId);
      
      List<Production_Schedule_Detail__c> prodList = new  List<Production_Schedule_Detail__c>();  
      //Contract_PO_PI__r.ETD__c,
      List<Product_Detail__c> prodDetList=[Select Id,Name,Contract_PO_PI__c,Total_MW__c,Product_Name__c,Contract_PO_PI__r.ETD__c,
                  Contract_PO_PI__r.Expected_EXW_Date__c,Product__r.Maximum_Power_at_STC_Pmax__c,
                    Total_Price__c,Unit_Price__c,ETD__c,Delivery_Date__c,Unit_WM__c,Product__c,Quantity__c  
                      From Product_Detail__c where Contract_PO_PI__c IN:contractId];
        
        system.debug('-------------------prodDetList:'+prodDetList);
          for(Product_Detail__c prodDetail:prodDetList){
                    pdop = new Production_Schedule_Detail__c();
                    pdop.Product_Detail__c = prodDetail.id;
                    pdop.Contract__c = prodDetail.Contract_PO_PI__r.id;
                    pdop.Total_Price__c=prodDetail.Total_Price__c;
                    pdop.Expected_ETD__c=prodDetail.ETD__c;
                    pdop.Expected_Delivery_Date__c=String.valueOf(prodDetail.Delivery_Date__c);
                    pdop.Total_MW__c = prodDetail.Total_MW__c;
                    pdop.Unit_Price__c= prodDetail.Unit_Price__c;
                    pdop.Quantity__c = prodDetail.Quantity__c;
                    pdop.Expected_ex_Work_Date__c = prodDetail.Contract_PO_PI__r.Expected_EXW_Date__c;
                    prodList.add(pdop);
                }
        if(prodList.size()>0){
            insert prodList;
          }
        return cont.id;          
    }
    
    public void runTest(){
        String runTest = 'run';
    }
}