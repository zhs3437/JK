public without sharing class ModuleDesignProduct5Controller {
    public String OppId{get;set;}
    public List<Component_Task_Book__c> MDA{get;set;}
    public boolean isSelect{set;get;}
    public boolean isNew{set;get;}
    public String OppRegion{get;set;}
    public String ProductId{get;set;}
    
    
    public ModuleDesignProduct5Controller(ApexPages.StandardSetController controller) {
        OppId = ApexPages.currentPage().getParameters().get('opportunityId');
        ProductId = ApexPages.currentPage().getParameters().get('p1');
        system.debug('OppId'+'       '+OppId);
        
        
    }
    
    public void goto(){
        
        List<Opportunity> Opps = [SELECT Id,Destination_Country__c,Name, Region__c FROM Opportunity WHERE id =: OppId];
        system.debug('Opps'+'       '+Opps);
        List<OpportunityLineItem> orderItemList = [SELECT Id, Name,OpportunityId,Product2ID,Product2.Name FROM OpportunityLineItem WHERE Id =:ProductId];
        system.debug('orderItemList'+'       '+orderItemList);
     
        MDA = new List<Component_Task_Book__c>();
        for (Opportunity opp : Opps) {
            OppRegion =opp.Region__c;
            //ROA-非澳洲
            if (opp.Destination_Country__c != 'Australia' && opp.Region__c == 'ROA') {
                // String ProductName =Label.MDA_ROA;
                // for (OpportunityLineItem orderItem : orderItemList) {
                //     system.debug('orderItem.Name'+'       '+orderItem.Name);
                //     //产品名是否与版型一致
                //     if(ProductName.contains(orderItem.Product2.Name)){
                //        Set<String> MDAId1 = new Set<String>();
                //        MDAId1.add(orderItem.Product2.Name);
                //        MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c,MDA_Region__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId1 AND IsMDATemplate__c = true AND MDA_Region__c=:'ROA'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c,MDA_Region__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved' 
                       AND MDA_Region__c = 'ROA'];
            }
            //ROA-澳洲
            if (opp.Destination_Country__c == 'Australia' && opp.Region__c == 'ROA') {
                // String ProductName =Label.MDA_Australia;
                // for (OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
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
            if (opp.Region__c == 'North Asia') {
                // String ProductName =Label.MDA_North_Asia;
                // for (OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);    
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
            if (opp.Region__c == 'MENA') {
                // String ProductName =Label.MDA_MEA;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
                //         MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE   ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'Middle East&Africa'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,Module_Type2__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c 
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved' 
                       AND MDA_Region__c = 'MENA'];
            }
            if (opp.Region__c == 'SSA') {
                // String ProductName =Label.MDA_MEA;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
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
            if (opp.Region__c == 'North America') {
                // String ProductName =Label.MDA_North_America;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
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
            if (opp.Region__c == 'CN') {
                // String ProductName =Label.MDA_CN;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
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
            if (opp.Region__c == 'Latin America&Italy') {
                // String ProductName =Label.MDA_Latin_America_Italy;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)){
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
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
            if (opp.Region__c == 'South Asia') {
                // String ProductName =Label.MDA_South_Asia;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
                //         MDA = [SELECT Id,ModuleType1__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c FROM Component_Task_Book__c WHERE ModuleType1__r.Name IN: MDAId2 AND IsMDATemplate__c = true AND MDA_Region__c=:'South Asia'];
                //     }
                // }
                MDA = [SELECT Id,ModuleType1__r.Name,isSelect__c,Name,TemplateName__c, Technical_manager_Shanghai__c 
                       FROM Component_Task_Book__c
                       WHERE IsMDATemplate__c = true
                       AND Technical_manager_Shanghai__c = 'Approved'
                       AND MDA_Region__c = 'South Asia'];
            }
            //欧洲 EU(Union)
            if (opp.Region__c == 'EU(Union)' || opp.Region__c == 'EU(Non-Eu)'){
                // String ProductName =Label.MDA_EU;
                // for(OpportunityLineItem orderItem : orderItemList){
                //     if (ProductName.contains(orderItem.Product2.Name)) {
                //         Set<String> MDAId2 = new Set<String>();
                //         MDAId2.add(orderItem.Product2.Name);
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