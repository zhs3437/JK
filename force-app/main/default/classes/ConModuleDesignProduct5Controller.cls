public without sharing class ConModuleDesignProduct5Controller {
    public String ConId{get;set;}
    public List<Component_Task_Book__c> MDA{get;set;}
    public boolean isSelect{set;get;}
    public boolean isNew{set;get;}
    public String OppRegion{get;set;}
    public String ProductId{get;set;}
    
    
    public ConModuleDesignProduct5Controller(ApexPages.StandardSetController controller) {
        ConId = ApexPages.currentPage().getParameters().get('ConId');
         ProductId = ApexPages.currentPage().getParameters().get('p1');
        system.debug('ConId'+'       '+ConId);
        
        
    }
    
    public void goto(){
        
        List<Contract> Cons = [SELECT Id,Destination_Region__c,Name,Destination_Country__c FROM Contract WHERE id =: ConId];
        system.debug('Cons'+'       '+Cons);
        List<Product_Detail__c> orderItemList = [SELECT Id, Name,Contract_PO_PI__c,Product__c,Product__r.Name FROM Product_Detail__c WHERE Id =:ProductId];
        system.debug('orderItemList'+'       '+orderItemList);
        MDA = new List<Component_Task_Book__c>();
        for (Contract opp : Cons) {
            OppRegion =opp.Destination_Region__c;
            //ROA-非澳洲
            if (opp.Destination_Country__c != 'Australia' && OppRegion == 'ROA') {
                // String ProductName =Label.MDA_ROA;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     system.debug('orderItem.Name'+'       '+orderItem.Name);
                //     //产品名是否与版型一致
                //     if(ProductName.contains(orderItem.Product__r.Name)){
                //        Set<String> MDAId1 = new Set<String>();
                //        MDAId1.add(orderItem.Product__r.Name);
                //        MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId1 AND IsMDATemplate__c = true AND MDA_Region__c=:'ROA'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true 
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'ROA'];
            }
            //ROA-澳洲
            if (opp.Destination_Country__c == 'Australia' && OppRegion == 'ROA') {
                // String ProductName =Label.MDA_Australia;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                       
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);
                     
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'ROA-Australia'];
                       
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true 
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'ROA-Australia'];
            }
            //北亚 North Asia
            if (OppRegion == 'North Asia') {
                // String ProductName =Label.MDA_North_Asia;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                       
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);   
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'North Asia'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true 
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'North Asia'];
            }
            //中东非 Middle East&Africa
            if (OppRegion == 'MENA') {
                // String ProductName =Label.MDA_MEA;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);                     
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'Middle East&Africa'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true 
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'MENA'];
            }
            if (OppRegion == 'SSA') {
                // String ProductName =Label.MDA_MEA;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);                     
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'Middle East&Africa'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true 
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'SSA'];
            }
            //北美 North America
            if (OppRegion == 'North America') {
                // String ProductName =Label.MDA_North_America;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);                     
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'North America'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c
                       WHERE IsMDATemplate__c = true 
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'North America'];
            }
            //中国区 CN
            if (OppRegion == 'CN') {
                // String ProductName =Label.MDA_CN;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);                     
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'CN'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'CN'];
            }
            //拉美&意大利 Latin America&Italy
            if (OppRegion == 'Latin America&Italy') {
                // String ProductName =Label.MDA_Latin_America_Italy;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);   
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND (MDA_Region__c=:'Italy' OR MDA_Region__c=:'Latin America')];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND (MDA_Region__c = 'Italy' OR MDA_Region__c = 'Latin America')];
            }
            //南亚 South Asia
            if (OppRegion == 'South Asia') {
                // String ProductName =Label.MDA_South_Asia;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);
                //         MDA = [SELECT Id,ModuleType1__r.Name,isSelect__c,Name FROM Component_Task_Book__c WHERE ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'South Asia'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,isSelect__c,Name 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved' 
                       AND MDA_Region__c = 'South Asia'];
            }
            //欧洲 EU(Union)
            if (OppRegion == 'EU(Union)' || OppRegion == 'EU(Non-Eu)'){
                // String ProductName =Label.MDA_EU;
                // for (Product_Detail__c orderItem : orderItemList) {
                //     if (ProductName.contains(orderItem.Product__r.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product__r.Name);     
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'EU'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved' 
                       AND MDA_Region__c = 'EU'];
            }
        }
        system.debug('MDA.size()'+'           '+MDA.size());
        if(MDA.size()==0){
            isNew = true;
        }
    }

}