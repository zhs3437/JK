public class ModuleDesignProduct2Controller {
	   public String currentId {get;set;} 
    public OpportunityLineItem orderItem1  {get;set;}  
    public OpportunityLineItem orderItem2  {get;set;}
    public OpportunityLineItem orderItem3  {get;set;}
    public List<OpportunityLineItem> pdItemList{get;set;}
    public List<OpportunityLineItem> pdList{get;set;}
    public OpportunityLineItem pdItem1 {get;set;}
    public OpportunityLineItem pdItem2 {get;set;}
    public OpportunityLineItem pdItem3 {get;set;}
    public String conId{get;set;}
    public String conNumber{get;set;}
    public String pageId{get;set;}
    public String ordName{get;set;}
    public String ordId{get;set;}
    public String productName1{get;set;}
    public String productId1{get;set;}
    public String productName2{get;set;}
    public String productId2{get;set;}
    public String productName3{get;set;}
    public String productId3{get;set;}
    public String MandatoryCertification{get;set;}
    public String quantityId1{get;set;}
    public String quantityId2{get;set;}
    public String cellquantity{get;set;}
    public String cellquantity2{get;set;}
    public String cellquantity3{get;set;}
    public String quantityId3{get;set;}
    public String cableLength{get;set;}
    public String powertolerance{get;set;}
    public String warranty{get;set;}
    public list<string> ids {get;set;}
    public string id1 {get;set;}
    public string id2 {get;set;}
    public string id3 {get;set;}
    public string ProductCertificate{get;set;}
    public string JunctionBoxConnector{get;set;}
    public string SystemVoltage{get;set;}
    public string CurrentSortingStyle{get;set;}
    public string ColorSortingstyle{get;set;}
    public String tranStyle{get;set;}   
    public string ShippingMark{get;set;}
    public String Mandatorycerti{get;set;}   
    public String JunctionBoxType{get;set;}   
    public String JunctionBoxCableLength{get;set;}
    
    
   
    public ModuleDesignProduct2Controller(ApexPages.StandardSetController controller){
        currentId = ApexPages.currentPage().getParameters().get('opportunityId');
        id1 = ApexPages.currentPage().getParameters().get('p1');
        id2 = ApexPages.currentPage().getParameters().get('p2');
        id3 = ApexPages.currentPage().getParameters().get('p3');        
        system.debug('====currentId: ' + currentId);
        system.debug('====id1: ' + id1);
        system.debug('====id2: ' + id2);
        system.debug('====id3: ' + id3);       
        
        ModuleDesignParam__c mdp = ModuleDesignParam__c.getOrgDefaults();
        pageId			= mdp.Module_Design_Id__c;
        ordName 		= mdp.Module_Design_Order_Name__c;
        ordId			= mdp.Module_Design_Order_Id__c;
        productName1	= mdp.Module_Design_Product_Name__c;
        productId1		= mdp.Module_Design_Product_Id__c;
        productName2	= mdp.Module_Design_Product_Name2__c;			
        productId2		= mdp.Module_Design_Product_Id2__c;
        cellquantity    = mdp.Module_Design_Product_Cell_Quantity__c;
        cellquantity2    = mdp.Module_Design_Product_Cell_Quantity2__c;
        cellquantity3    = mdp.Module_Design_Product_Cell_Quantity3__c;
        productName3	= mdp.Module_Design_Product_Name3__c;
        productId3		= mdp.Module_Design_Product_Id3__c;
        quantityId1		= mdp.Module_Design_Product_Quantity__c;
        quantityId2		= mdp.Module_Design_Product_Quantity2__c;
        quantityId3		= mdp.Module_Design_Product_Quantity3__c;
        conNumber       = mdp.Module_Design_ContractNumber__c;
        conId           = mdp.Module_Design_Contract_Id__c;
        cableLength     = mdp.Module_Design_Cable_Length__c;
        powertolerance  = mdp.Module_Design_Power_tolerance__c;
        warranty 		= mdp.Module_Design_Warranty__c;
        //新增
        tranStyle       = mdp.Module_Design_Transportation_style__c;//旧
        ProductCertificate = mdp.ProductCertificate__c;
        JunctionBoxConnector = mdp.Junction_Box_Connector__c;
        SystemVoltage = mdp.System_Voltage__c;
        CurrentSortingStyle = mdp.Current_Sorting_Style__c;
        ColorSortingstyle = mdp.Color_Sorting_style__c;
        ShippingMark = mdp.Shipping_Mark__c;
        JunctionBoxType = mdp.Junction_Box_Type__c;
        JunctionBoxCableLength = mdp.Junction_Box_Cable_Length__c;
            //增加根据交货地址来初始化默认值
            MandatoryCertification = mdp.Mandatory_certification__c;
        system.debug('----cableLength'+pageId);
    }
    public PageReference goto(){
              
        List<OpportunityLineItem> orderItemList = [select id,Name,                                             
                                                 OpportunityId,
                                                 product2Id,
                                                 Product2.Name,
                                                 Quantity
                                                 From OpportunityLineItem  
                                                 Where id =: id1 Or id =: id2 Or id =: id3];
        
        //Contract con = [select Id,ContractNumber,Warranty_On_Material_and_Workmanship__c,Shipping_type__c,Region__c,Total_MW__c,Destination_Country__c  From Contract Where id =: orderItemList[0].Contract_PO_PI__c ];
        Opportunity opp =[select Id,Name From Opportunity Where id =:orderItemList[0].OpportunityId];
      		
       		system.debug('orderItemList长度'+orderItemList.size());	               
            if(orderItemList.size()==1){
                orderItem1 = orderItemList[0];
            }
            if(orderItemList.size()==2){
                orderItem1 = orderItemList[0];
                orderItem2 = orderItemList[1];
            }
            if(orderItemList.size()==3){
                orderItem1 = orderItemList[0];
                system.debug('orderItem1-------------------------->'+orderItemList[0]);
                orderItem2 = orderItemList[1];
                
                orderItem3 = orderItemList[2];
            }
            PageReference newPage = new PageReference(pageId);
         
     
            if(orderItemList.size()>=1){ 
                //业务机会
                newPage.getParameters().put('CF00N6F00000Ua2PA',opp.Name);  
                newPage.getParameters().put(productName1,orderItem1.Product2.Name);
                if(orderItem1.Product2.Name.contains('JKM')){
                    
                
                if(orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('-60H')){
                    newPage.getParameters().put(cellquantity,'120');
                }
                if(orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('-60') && !orderItem1.Product2.Name.contains('-60H')){
                    newPage.getParameters().put(cellquantity,'60');
                }
                if(orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('-72H')){
                    newPage.getParameters().put(cellquantity,'144');
                }
                if(orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('-72') && !orderItem1.Product2.Name.contains('-72H')){
                    newPage.getParameters().put(cellquantity,'72');
                }
                newPage.getParameters().put(productId1,orderItem1.product2Id);
                
                newPage.getParameters().put(quantityId1,String.valueOf(orderItem1.Quantity).substring(0, String.valueOf(orderItem1.Quantity).indexOf('.')));
              
              

                  if((orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('V'))){
                    newPage.getParameters().put(SystemVoltage,'1500V');
                  }else if((orderItem1.Product2.Name.contains('JKM') && !(orderItem1.Product2.Name.contains('V')))){
                      newPage.getParameters().put(SystemVoltage,'1000V');
                  }else {
                      newPage.getParameters().put(SystemVoltage,'Others');
                  }
                
					                 
                  if((orderItem1.Product2.Name.contains('-72H') || orderItem1.Product2.Name.contains('-60H') || orderItem1.Product2.Name.contains('TV')|| 
                     orderItem1.Product2.Name.contains('BDVP')|| orderItem1.Product2.Name.contains('BDV')|| orderItem1.Product2.Name.contains('DV'))){
                    newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                  }else if(orderItem1.Product2.Name.contains('JKMS')){
                      newPage.getParameters().put(JunctionBoxType,'Other');
                  }else {
                      newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                  }
                
                
                
          
                
                
                }

            }
            
            
            
            
            
            if(orderItemList.size()>=2){  
                
                newPage.getParameters().put(productName2,orderItem2.Product2.Name);
                 
                if(orderItem2.Product2.Name.contains('JKM') && orderItem2.Product2.Name.contains('-60H')){
                    newPage.getParameters().put(cellquantity2,'120');
                }
                if(orderItem2.Product2.Name.contains('JKM') && orderItem2.Product2.Name.contains('-60') && !orderItem2.Product2.Name.contains('-60H')){
                    newPage.getParameters().put(cellquantity2,'60');
                }
                if(orderItem2.Product2.Name.contains('JKM') && orderItem2.Product2.Name.contains('-72H')){
                    newPage.getParameters().put(cellquantity2,'144');
                }
                if(orderItem2.Product2.Name.contains('JKM') && orderItem2.Product2.Name.contains('-72') && !orderItem2.Product2.Name.contains('-72H')){
                    newPage.getParameters().put(cellquantity2,'72');
                }
                newPage.getParameters().put(productId2,orderItem2.product2Id);
                    newPage.getParameters().put(quantityId2,String.valueOf(orderItem2.Quantity).substring(0, String.valueOf(orderItem2.Quantity).indexOf('.')));
                
                                 if((orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('V'))||
                    (orderItem2.Product2.Name.contains('JKM') && orderItem2.Product2.Name.contains('V'))){
                    newPage.getParameters().put(SystemVoltage,'1500V');
                  }else if((orderItem1.Product2.Name.contains('JKM') && !(orderItem1.Product2.Name.contains('V'))) ||
                          (orderItem2.Product2.Name.contains('JKM') && !(orderItem2.Product2.Name.contains('V')))
                          ){
                      newPage.getParameters().put(SystemVoltage,'1000V');
                  }else {
                      newPage.getParameters().put(SystemVoltage,'Others');
                  }
                
					                 
                  if((orderItem1.Product2.Name.contains('-72H') || orderItem1.Product2.Name.contains('-60H') || orderItem1.Product2.Name.contains('TV')|| 
                     orderItem1.Product2.Name.contains('BDVP')|| orderItem1.Product2.Name.contains('BDV')|| orderItem1.Product2.Name.contains('DV'))||     
                    (orderItem2.Product2.Name.contains('-72H') || orderItem2.Product2.Name.contains('-60H') || orderItem2.Product2.Name.contains('TV')|| 
                     orderItem2.Product2.Name.contains('BDVP')|| orderItem2.Product2.Name.contains('BDV')|| orderItem2.Product2.Name.contains('DV'))
                   ){
                    newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                  }else if(orderItem1.Product2.Name.contains('JKMS') ||
                          orderItem2.Product2.Name.contains('JKMS')   
                          ){
                      newPage.getParameters().put(JunctionBoxType,'Other');
                  }else {
                      newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                  }
                
        
            }
            
            
            if(orderItemList.size()>=3){
                newPage.getParameters().put(productName3,orderItem3.Product2.Name);
                if(orderItem3.Product2.Name.contains('JKM') && orderItem3.Product2.Name.contains('-60H')){
                    newPage.getParameters().put(cellquantity3,'120');
                }
                if(orderItem3.Product2.Name.contains('JKM') && orderItem3.Product2.Name.contains('-60') && !orderItem3.Product2.Name.contains('-60H')){
                    newPage.getParameters().put(cellquantity3,'60');
                }
                if(orderItem3.Product2.Name.contains('JKM') && orderItem3.Product2.Name.contains('-72H')){
                    newPage.getParameters().put(cellquantity3,'144');
                }
                if(orderItem3.Product2.Name.contains('JKM') && orderItem3.Product2.Name.contains('-72') && !orderItem3.Product2.Name.contains('-72H')){
                    newPage.getParameters().put(cellquantity3,'72');
                }
                newPage.getParameters().put(productId3,orderItem3.product2Id);
                    newPage.getParameters().put(quantityId3,String.valueOf(orderItem3.Quantity).substring(0, String.valueOf(orderItem3.Quantity).indexOf('.')));
                                 if((orderItem1.Product2.Name.contains('JKM') && orderItem1.Product2.Name.contains('V'))||
                    (orderItem2.Product2.Name.contains('JKM') && orderItem2.Product2.Name.contains('V'))||
                    (orderItem3.Product2.Name.contains('JKM') && orderItem3.Product2.Name.contains('V'))){
                    newPage.getParameters().put(SystemVoltage,'1500V');
                  }else if((orderItem1.Product2.Name.contains('JKM') && !(orderItem1.Product2.Name.contains('V'))) ||
                          (orderItem2.Product2.Name.contains('JKM') && !(orderItem2.Product2.Name.contains('V')))||
                          (orderItem3.Product2.Name.contains('JKM') && !(orderItem3.Product2.Name.contains('V')))  
                          ){
                      newPage.getParameters().put(SystemVoltage,'1000V');
                  }else {
                      newPage.getParameters().put(SystemVoltage,'Others');
                  }
                
					                 
                  if((orderItem1.Product2.Name.contains('-72H') || orderItem1.Product2.Name.contains('-60H') || orderItem1.Product2.Name.contains('TV')|| 
                     orderItem1.Product2.Name.contains('BDVP')|| orderItem1.Product2.Name.contains('BDV')|| orderItem1.Product2.Name.contains('DV'))||     
                    (orderItem2.Product2.Name.contains('-72H') || orderItem2.Product2.Name.contains('-60H') || orderItem2.Product2.Name.contains('TV')|| 
                     orderItem2.Product2.Name.contains('BDVP')|| orderItem2.Product2.Name.contains('BDV')|| orderItem2.Product2.Name.contains('DV'))||
                    (orderItem3.Product2.Name.contains('-72H') || orderItem3.Product2.Name.contains('-60H') || orderItem3.Product2.Name.contains('TV')|| 
                     orderItem3.Product2.Name.contains('BDVP')|| orderItem3.Product2.Name.contains('BDV')|| orderItem3.Product2.Name.contains('DV'))){
                    newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                  }else if(orderItem1.Product2.Name.contains('JKMS') ||
                          orderItem2.Product2.Name.contains('JKMS')  ||
                          orderItem3.Product2.Name.contains('JKMS')    
                          ){
                      newPage.getParameters().put(JunctionBoxType,'Other');
                  }else {
                      newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                  }
                
                

                
            }
            return newPage;
            
      
       
    }

    
    
    
}