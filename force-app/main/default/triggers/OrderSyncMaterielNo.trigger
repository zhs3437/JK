trigger OrderSyncMaterielNo on OrderItem (before insert, before update) {
    if(Trigger.isBefore){        
		if(Trigger.isInsert || Trigger.isUpdate){
            Boolean hasSync = false;
            Set<String> nameset =new set<String>();
             for(OrderItem ordProd :trigger.new){
                 nameset.add(ordProd.Product_Name__c);
                 }
            List<SAP_Product__c> sapList = [select id, 
                                            Certification__c,
                                            Color_of_Module__c,
                                            Type_of_module__c,
                                            Grade__c,
                                            Special_required__c,
                                            Bus_bars_of_cell__c,
                                            Product_Code__c,
                                            Product_Name__c,
                                            Product_Description__c 
                                            from SAP_Product__c
                                           where Product_Name__c in:nameset
                                           ];
             
            for(OrderItem ordProd :trigger.new){
                for(SAP_Product__c sapProd : sapList){
                    if(ordProd.Product_Name__c == 'TBD'){
                        ordProd.SAP_Product_Materiel_No__c = sapProd.Id;
                    }else if(ordProd.Certification__c						== sapProd.Certification__c 
                            && ordProd.Color_of_frame_and_backsheet__c	== sapProd.Color_of_Module__c
                            && ordProd.Type_of_module__c 				== sapProd.Type_of_module__c 
                            && ordProd.Grade__c 						== sapProd.Grade__c
                            && ordProd.Special_required__c 				== sapProd.Special_required__c 
                            && ordProd.Bus_bars_of_cell__c 				== sapProd.Bus_bars_of_cell__c
                            && ordProd.Product_Name__c 					== sapProd.Product_Name__c)
                            {
                                ordProd.SAP_Product_Materiel_No__c = sapProd.Id;
                                hasSync = true;
                                break;
                            }else{
                                hasSync = false;
                            }
                   /*
                    if(!hasSync){
                        if(Sapmap.getPickListValue(ordProd.Certification__c)					== sapProd.Certification__c 
                            && Sapmap.getPickListValue(ordProd.Color_of_frame_and_backsheet__c)	== sapProd.Color_of_Module__c
                            && Sapmap.getPickListValue(ordProd.Type_of_module__c) 				== sapProd.Type_of_module__c 
                            && Sapmap.getPickListValue(ordProd.Grade__c )						== sapProd.Grade__c
                            && Sapmap.getPickListValue(ordProd.Special_required__c) 			== sapProd.Special_required__c 
                            && Sapmap.getPickListValue(ordProd.Bus_bars_of_cell__c) 			== sapProd.Bus_bars_of_cell__c
                            && ordProd.Product_Name__c				== sapProd.Product_Name__c)
                            {
                                ordProd.SAP_Product_Materiel_No__c = sapProd.Id;
                                hasSync = true;
                                break;
                            }else{
                                hasSync = false;
                            }
                    }
                    */
                    //当物料号取不到时将其字段置为1，用于同步按钮时的控制
                    if(String.isEmpty(ordProd.SAP_Product_Materiel_No__c)){
                        ordProd.MaterielNo__c = '1';
                    }else{
                        ordProd.MaterielNo__c = '0';
                    }
                    //物料号为TBD时将字段IS_TBD__c置为1
                    if(ordProd.SAP_Product_Materiel_No__c == 'a0Q6F00000HNJyi'   ){  //  a0QN0000005WStK
                        ordProd.IS_TBD__c = '1';
                      //  system.debug('---->IS_TBD__c:'+ordProd.IS_TBD__c);
                    }else{
                        ordProd.IS_TBD__c = '0';
                      //  system.debug('---->IS_TBD__c:'+ordProd.IS_TBD__c);
                    }
                }
                List<OrderItem> items = new  List<OrderItem>();
                for(OrderItem item :trigger.new){
                    if(item.RowNo__c == null){
                        items.add(item);
                     //   system.debug('--------->RowNo__c:' + item);
                      //  system.debug('--------->RowNo__c:' + item.RowNo__c);
                    }
                }
                if(items.size()>0){
                    OrderItemHelper.setRowNo(items);
                }
            }
        }
    }     
}