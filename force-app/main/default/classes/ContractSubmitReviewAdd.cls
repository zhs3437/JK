global class ContractSubmitReviewAdd {
    webservice static String HaveUnLockAmend(String requestId){    
        Contract con = [SELECT ID,OWNERID,RecordTypeId,RecordType.Name,Send_Remind_Mail_First_Time__c,Region__c,InventoryArea__c,Sales_type__c  FROM Contract WHERE ID=:requestId]; 
        system.debug('con'+con);
        List<Component_Task_Book__c> mda = [SELECT ID,name,ModuleType1__r.name,Contract__c,Module_Type2__r.name,Module_Type3__r.name,Technical_manager_Shanghai__c  FROM Component_Task_Book__c WHERE Contract__c=:con.Id];
        system.debug('mda'+mda);
        List<Product_Detail__c> pro = [SELECT ID,name,Product__r.name,Contract_PO_PI__c  FROM Product_Detail__c WHERE Contract_PO_PI__c=:con.Id and Product__r.Maximum_Power_at_STC_Pmax__c!=null and Product__r.Maximum_Power_at_STC_Pmax__c>10];
        system.debug('pro'+pro);
        system.debug('1'+con.Region__c);
        system.debug('2'+con.Sales_type__c);
        system.debug('3'+con.InventoryArea__c);
        Set<String> proName = new Set<String>();
        if(con.RecordType.Name =='Inventory Contract'&&con.InventoryArea__c==null){
            system.debug('con.InventoryArea__c'+con.InventoryArea__c);
            return '3';
        }
        else if(con.InventoryArea__c == 'Own inventory'){
            return '1';
        }else if(con.InventoryArea__c == 'Other regions'|| con.InventoryArea__c == 'Production'){
          for(Product_Detail__c p:pro){ 
              if(p.Product__r.name!=null){
                  proName.add(p.Product__r.name);
              }
        }
        Set<String> mdaName = new Set<String>();
        for(Component_Task_Book__c c:mda){
            if(c.ModuleType1__r.name!=null){
                mdaName.add(c.ModuleType1__r.name);
            }
            if(c.Module_Type2__r.name!=null){
                mdaName.add(c.Module_Type2__r.name);
            }
            if(c.Module_Type3__r.name!=null){
                mdaName.add(c.Module_Type3__r.name);
            }
                
           
        }
        Integer i = proName.size();
        Integer ii = mdaName.size();
        if(i!=ii){
            return '2';
        }  
        }
       /*   if(con.RecordType.Name =='Inventory Contract'&&con.InventoryArea__c==null){
            system.debug('con.InventoryArea__c'+con.InventoryArea__c);
            return '6';
        }
         else if(con.Region__c=='North America' && con.Sales_type__c.contains('DG')&&con.InventoryArea__c!='Other regions'){
            return '5';
        }
        else if(con.Region__c=='North America' && con.Sales_type__c.contains('DG')&& con.InventoryArea__c=='Other regions' ){
             for(Product_Detail__c p:pro){ 
              if(p.Product__r.name!=null){
                  proName.add(p.Product__r.name);
              }
        }
        Set<String> mdaName = new Set<String>();
        for(Component_Task_Book__c c:mda){
            if(c.ModuleType1__r.name!=null){
                mdaName.add(c.ModuleType1__r.name);
            }
            if(c.Module_Type2__r.name!=null){
                mdaName.add(c.Module_Type2__r.name);
            }
            if(c.Module_Type3__r.name!=null){
                mdaName.add(c.Module_Type3__r.name);
            }
        }
        Integer i = proName.size();
        Integer ii = mdaName.size();
        if(i!=ii){
            return '7';
        }
        }
        else if((con.RecordType.Name =='1MW Australia Contract'||con.RecordType.Name =='1MW Global Standard Contract'||con.RecordType.Name =='1MW Japan Contract')&&con.InventoryArea__c!='Own inventory'){
          for(Product_Detail__c p:pro){ 
              if(p.Product__r.name!=null){
                  proName.add(p.Product__r.name);
              }
        }
        Set<String> mdaName = new Set<String>();
        for(Component_Task_Book__c c:mda){
            if(c.ModuleType1__r.name!=null){
                mdaName.add(c.ModuleType1__r.name);
            }
            if(c.Module_Type2__r.name!=null){
                mdaName.add(c.Module_Type2__r.name);
            }
            if(c.Module_Type3__r.name!=null){
                mdaName.add(c.Module_Type3__r.name);
            }
                
           /* if(c.Technical_manager_Shanghai__c !='Approved'){
                return '1';
            }
        }
        Integer i = proName.size();
        Integer ii = mdaName.size();
        if(i!=ii){
            return '1';
        }  
        }else if(con.RecordType.Name =='Inventory Contract'&&con.InventoryArea__c=='Other regions'){
            for(Product_Detail__c p:pro){ 
                if(p.Product__r.name!=null){
            proName.add(p.Product__r.name);
                }
        }
        Set<String> mdaName = new Set<String>();
        for(Component_Task_Book__c c:mda){
            if(c.ModuleType1__r.name!=null){
                mdaName.add(c.ModuleType1__r.name);
            }
            if(c.Module_Type2__r.name!=null){
                mdaName.add(c.Module_Type2__r.name);
            }
            if(c.Module_Type3__r.name!=null){
                mdaName.add(c.Module_Type3__r.name);
            }
           
        }
            system.debug('mdaName'+mdaName);
            system.debug('proNam'+proName);
            
        Integer i = proName.size();
        Integer ii = mdaName.size();
            
            system.debug('i'+i);
            system.debug('i'+ii);
        if(i!=ii){
            return '2';
        }
        }else if(con.RecordType.Name !='1MW Australia Contract'&&con.RecordType.Name !='1MW Global Standard Contract'&&con.RecordType.Name !='1MW Japan Contract'&&con.RecordType.Name !='Inventory Contract'){
             for(Product_Detail__c p:pro){ 
                if(p.Product__r.name!=null){
            proName.add(p.Product__r.name);
                }
        }
        Set<String> mdaName = new Set<String>();
        for(Component_Task_Book__c c:mda){
            if(c.ModuleType1__r.name!=null){
                mdaName.add(c.ModuleType1__r.name);
            }
            if(c.Module_Type2__r.name!=null){
                mdaName.add(c.Module_Type2__r.name);
            }
            if(c.Module_Type3__r.name!=null){
                mdaName.add(c.Module_Type3__r.name);
            }
           
        }
        Integer i = proName.size();
        Integer ii = mdaName.size();
        if(i!=ii){
            return '3';
        }
        }
        if(con.Region__c=='North America' && !con.Sales_type__c.contains('DG')&&con.InventoryArea__c!='Own inventory'){
            for(Product_Detail__c p:pro){ 
                if(p.Product__r.name!=null){
            proName.add(p.Product__r.name);
                }
        }
        Set<String> mdaName = new Set<String>();
        for(Component_Task_Book__c c:mda){
            if(c.ModuleType1__r.name!=null){
                mdaName.add(c.ModuleType1__r.name);
            }
            if(c.Module_Type2__r.name!=null){
                mdaName.add(c.Module_Type2__r.name);
            }
            if(c.Module_Type3__r.name!=null){
                mdaName.add(c.Module_Type3__r.name);
            }
           
        }
        Integer i = proName.size();
        Integer ii = mdaName.size();
        if(i!=ii){
            return '4';
        }
        }*/
        
       
        return '0';
    }
}