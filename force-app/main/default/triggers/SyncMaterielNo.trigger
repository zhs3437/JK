trigger SyncMaterielNo on OpportunityLineItem (before insert, before update) {
     /*
	List<SAP_Product__c> sapList = [select id
                                    		,Certification__c
                                    		,Color_of_Module__c
                                    		,Type_of_module__c
                                    		,Grade__c
                                    		,Special_required__c
                                    		,Bus_bars_of_cell__c
                                    		,Product_Code__c
                                    		,Product_Name__c
                                    		,Product_Description__c 
                                    		from SAP_Product__c];
	
	//List<User> admin = [SELECT ID,Name,Email FROM User WHERE Email =: 'david.wei@jinkosolar.com'];
	//List<User> admin = [SELECT ID,Name,Email FROM User WHERE Email =: ' '];
	
	for(OpportunityLineItem oppProd :trigger.new){
		
		// TODO : 当该产品没有同步到任何物料号时，给管理员发送一份邮件
		Boolean hasSync = false;
		
		for(SAP_Product__c sapProd : sapList){
            if(oppProd.Product_Name__c == sapProd.Product_Name__c){
				system.debug('=========oppProd.Certification__c  : ' + oppProd.Certification__c + '\t' + sapProd.Certification__c );
                system.debug('=========oppProd.Color_of_Module__c : ' + oppProd.Color_of_Module__c + '\t' + sapProd.Color_of_Module__c);
                system.debug('=========oppProd.Type_of_module__c : ' + oppProd.Type_of_module__c + '\t' + sapProd.Type_of_module__c);
                system.debug('=========oppProd.Grade__c : ' + oppProd.Grade__c + '\t' + sapProd.Grade__c);
                system.debug('=========oppProd.Special_required__c : ' + oppProd.Special_required__c + '\t' + sapProd.Special_required__c);
                system.debug('=========oppProd.Bus_bars_of_cell__c : ' + oppProd.Bus_bars_of_cell__c + '\t' + sapProd.Bus_bars_of_cell__c);
                system.debug('=========oppProd.Product_Name__c : ' + oppProd.Product_Name__c + '\t' + sapProd.Product_Name__c);                
            }		
            
			if(oppProd.Certification__c == sapProd.Certification__c && oppProd.Color_of_Module__c == sapProd.Color_of_Module__c
			   && oppProd.Type_of_module__c == sapProd.Type_of_module__c && oppProd.Grade__c == sapProd.Grade__c
			   && oppProd.Special_required__c == sapProd.Special_required__c && oppProd.Bus_bars_of_cell__c == sapProd.Bus_bars_of_cell__c
			   && oppProd.Product_Name__c == sapProd.Product_Name__c){
			   	
				oppProd.Description        = sapProd.Product_Description__c;
	            oppProd.SAP_Product_Materiel_No__c = sapProd.Id;
                
				hasSync = true;
				break;
			}else{
				hasSync = false;
            }
           
            if(!hasSync){
                if(SapMap.getPickListValue(oppProd.Certification__c) == sapProd.Certification__c && SapMap.getPickListValue(oppProd.Color_of_Module__c) == sapProd.Color_of_Module__c
			   && SapMap.getPickListValue(oppProd.Type_of_module__c) == sapProd.Type_of_module__c && SapMap.getPickListValue(oppProd.Grade__c) == sapProd.Grade__c
			   && SapMap.getPickListValue(oppProd.Special_required__c) == sapProd.Special_required__c && SapMap.getPickListValue(oppProd.Bus_bars_of_cell__c) == sapProd.Bus_bars_of_cell__c
			   && oppProd.Product_Name__c == sapProd.Product_Name__c){
                    oppProd.Description        = sapProd.Product_Description__c;
	            	oppProd.SAP_Product_Materiel_No__c = sapProd.Id;
                   
                    hasSync = true;
					break;
                }else{
					hasSync = false;
            	}
            }
            
		}
		
		if(!hasSync){
			// send email to admin
			Utils.sendEmailWithTemplate(admin, oppProd.Id, 'MaterialNumNotify');
		}
		
	}
*/
}