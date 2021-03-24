public with sharing class ContractProductDetailBasicInfoCtrl {
	public Production_Schedule_Detail__c pdop{get;set;}
    public List<Production_Schedule_Detail__c> prodList  {get;set;}
    public Set<String> ConId{get;set;}
    public List<Product_Detail__c> prodDet  {get;set;}
    public Contract con {get;set;}
    public String ProductEditID{get;set;}
    public String PmcEditID{get;set;}
    public boolean PmcView{get;set;}  
    public boolean SubmitStatus{get;set;}
    public String editStatus{get;set;}
    public boolean scheduleStatus{get;set;}
    public boolean BoxStatus{get;set;}
    public String profile {get;set;}
    
    public ContractProductDetailBasicInfoCtrl(){
    	
    }
    
    public ContractProductDetailBasicInfoCtrl(ApexPages.StandardController controller) {
		try{
            ID id = controller.getId();
            system.debug('-------------id:'+id);
			prodList = [Select Id,Name,Total_MW__c,Contract__c,Expected_Delivery_Date__c,Expected_ETD__c,Expected_ex_Work_Date__c,
                            Product_Detail__c,Production_Schedule_Detail__c.Product_Detail__r.name,Total_Price__c,Unit_Price__c,Product__c,Remarks__c,Quantity__c
                                    From Production_Schedule_Detail__c where Contract__c =:id order by CreatedDate desc];
           	List<Product_Detail__c> prodDetList=[Select Id,Name,Contract_PO_PI__c,Total_MW__c,Product_Name__c,Contract_PO_PI__r.ETD__c,
                  Contract_PO_PI__r.Expected_EXW_Date__c,Product__r.Maximum_Power_at_STC_Pmax__c,
                    Total_Price__c,Unit_Price__c,Unit_WM__c,Product__c,Quantity__c  
                      From Product_Detail__c where Contract_PO_PI__c =:id];
	            for(Production_Schedule_Detail__c psd:prodList){
	            	 ConId = new Set<String>();
	            	 ConId.add(psd.Contract__c);
	            
	            }
            con = [SELECT ID,ETD__c FROM Contract WHERE ID IN:ConId];
            system.debug(con.id);
            
            prodDet=[SELECT ID,Contract_PO_PI__c,Product__r.Maximum_Power_at_STC_Pmax__c FROM Product_Detail__c WHERE Contract_PO_PI__c IN:ConId];
             
    	}catch(Exception ex){
            String exe =ex.getMessage();
            exe = '请先初始化数据';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exe));
        }
    	
    }
    
    // Called from Production Grid "Edit" Link
    public PageReference editTheProduction () {
        editStatus = 'OK';
        return null;

    }
    // Called from Production Grid "Save" Button 
    public PageReference saveTheProduction () {
	try{
        List<Production_Schedule_Detail__c> OldprodList =[Select Id,Name,Total_MW__c,Contract__c,Expected_Delivery_Date__c,Expected_ETD__c,Expected_ex_Work_Date__c,
                            Product_Detail__c,Total_Price__c,Unit_Price__c,Product__c,Remarks__c,Quantity__c,Product__r.name,Product_Detail__r.Product__r.Maximum_Power_at_STC_Pmax__c
                                    From Production_Schedule_Detail__c where Contract__c =:con.id and ID=:ProductEditID];
        
        system.debug('-----------OldprodList:'+OldprodList[0]);
        system.debug('---------------ProductEditID:'+ProductEditID);
        for(Production_Schedule_Detail__c newProd:prodList){
            for(Production_Schedule_Detail__c oldProd:OldprodList){
                if(newProd.Id==ProductEditID){  
                    newProd.Total_MW__c=newProd.Quantity__c*oldProd.Product_Detail__r.Product__r.Maximum_Power_at_STC_Pmax__c/1000000;
                    system.debug('----------oldProd.Quantity__c:'+oldProd.Quantity__c);
                    system.debug('----------newProd.Quantity__c:'+newProd.Quantity__c);
                    system.debug((oldProd.Quantity__c-newProd.Quantity__c)>0 || (oldProd.Quantity__c-newProd.Quantity__c)==0);
                    if((oldProd.Quantity__c-newProd.Quantity__c)>0 || (oldProd.Quantity__c-newProd.Quantity__c)==0){
                        update newProd;
                    }else{
                			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'数量不能大于等于原值'));
                			return null;
                
                }
                }
            }
        }
        }catch(Exception ex){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
                system.debug('-----------prodList:'+prodList);
                return null;
    } 
    
    
    
    // Called from Production Grid "Delete" Button
    public PageReference deleteTheProduction () {
        system.debug('-------------ProductEditID:'+ProductEditID);
        Production_Schedule_Detail__c prod = [select Id FROM Production_Schedule_Detail__c WHERE Id = :ProductEditID];
                delete prod;
                return null; 
    }
    
    
       // Called from Production Grid "Cancel" Button
    public PageReference cancelTheProduction () {
            return null;
    }
    
    public void runTest(){
    	String runTest = 'run';
        runTest = 'run';
    }
    
}