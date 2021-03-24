public class ContractNorthAisabookStock {
    public static void SendEmail(String ConID,List<String> disIDLst){
        User us =[Select id,Name,IsActive from User where Name =:System.Label.Japan_BMO and IsActive=true limit 1];
        SendEmailUtils2.sendToSomeOneId(ConID,us.id,'Contract_bookstock_UnEqual');
        Contract con = [Select ID,IFSendEmail__c from Contract where ID =:ConID];
        con.IFSendEmail__c = true;
        update con;
        
        ContractNorthAisabookStock.updateDistribution(disIDLst);
    }
        public static void updateDistribution(List<String> disIDLst){
            try{
                system.debug('1111');
                system.debug('disIDLst-->'+disIDLst);
                  List<Distribution_Stock__c> updateDisLst = new List<Distribution_Stock__c>();
   
                 if(disIDLst !=null && disIDLst.size()>0){
                                  updateDisLst =[Select Id,Status__c,SAP_TYPE__c from Distribution_Stock__c where Id in:disIDLst];
                    List<Distribution_Stock__c> dsLst = new List<Distribution_Stock__c>();  
                     for(Distribution_Stock__c diss : updateDisLst){
                           if(diss.Status__c=='Booked' && diss.SAP_TYPE__c =='Booked同步成功' ){
                            diss.Status__c ='Confirmed';
                            dsLst.add(diss);
                        }
                     }
                     if(dsLst !=null && disIDLst.size()>0){
                          update dsLst;
                     }
            
                  if(disIDLst !=null && disIDLst.size()>0){
                 ContractNorthAisabookStock.getDisStockAlone(disIDLst);
                  }
            }
            }catch(Exception e){
                
            }
           
    }
    
    


    @Future(callout=true)
     public static void getDisStockAlone(List<String> IDList){
         
          List<Distribution_Stock__c> DisStockList = new List<Distribution_Stock__c>();
             if(IDList != null){
           
            
            System.debug('Start Sysnc');
            DisStockList =[Select id,Account__c,Name,Apply_Inventory__c,BL_No__c,Contract_No__c,Contract_PO_PI__c,Date_of_delivery__c,SAP_BLNO__c,Distribution_Quantity__c,ETA__c,ETD__c,Factory__c,Inventory__c,Payment_Term__c,SAP_W_H__c,SAP_LGORT__c,
                           Product__c,InputNumber__c,Sales__c,SAP_Materiel_No__c,SAP_Message__c,SAP_TYPE__c,Status__c,Status_Old__c,Total_MW__c,WERKS__c from Distribution_Stock__c where  ID in:IDList];
            if(DisStockList!=null){
                SAPPassTest.getDisStockAlone(DisStockList);
            }
        }
        String DisStatus = null;//判断状态是否同步成功
        if(DisStockList != null && DisStockList.size()>0){
            
            Date test = Date.today();
            system.debug('testDate-->'+test);
            String str = String.valueof(test);
            
            System.debug('Start Sysnc');
            
            List<Inventory__c> invList  = new  List<Inventory__c>();
            SapSync_Inventory delivery_tool = new SapSync_Inventory();
            SapSync_StatusChange StatusChange_tool = new SapSync_StatusChange();
            List<SapNewEccStatusChange.StatusChangeReturn_element> SapNewReturn = new  List<SapNewEccStatusChange.StatusChangeReturn_element>();
            System.debug('Start generateData');
            system.debug('DisStockList.size()-->'+DisStockList.size());
            StatusChange_tool.generateData(DisStockList);
            System.debug('Start sync');
            SapNewReturn=StatusChange_tool.sync();
            system.debug('SapNewReturn========:'+SapNewReturn);
            system.debug('stop sync');
            
            List<Distribution_Stock__c> updateDisStockList =new List<Distribution_Stock__c>();
            if(SapNewReturn !=null){
                
                system.debug('111');
                for(SapNewEccStatusChange.StatusChangeReturn_element snesc : SapNewReturn){
                    for(Distribution_Stock__c dis : DisStockList){
                        system.debug('snesc.TYPE_x-->'+snesc.TYPE_x);
                        system.debug('snesc.ZCRMNO-->'+snesc.ZCRMNO);
                        system.debug('snesc.MSG-->'+snesc.MSG);
                        if(dis.Id == snesc.ZCRMNO){
                            system.debug('snesc.TYPE_x-->'+snesc.TYPE_x);
                            dis.SAP_TYPES__c = snesc.TYPE_x;
                            dis.SAP_Message__c = snesc.MSG;
                            //dis.syncNumber__c = 1;
                            dis.isSelect_c__c = false;
                            if(snesc.TYPE_x =='E'){
                                dis.SAP_TYPE__c =dis.Status__c+'同步失败'; 
                            }
                            
                            else if( snesc.TYPE_x =='S'){
                                dis.SAP_TYPE__c =dis.Status__c+'同步成功'; 
                                dis.Status_Old__c = dis.Status__c;
                                DisStatus = 'true';
                            }
                            
                            updateDisStockList.add(dis);
                        }
                    }
                }
                if(updateDisStockList.size()>0){
                    update updateDisStockList; 
                }
                List<Distribution_Stock__c> deleteDisStockList = new  List<Distribution_Stock__c>();
                for(Distribution_Stock__c dis: updateDisStockList){
                    System.debug('dis.Status__c-->'+dis.Status__c);
                    if(dis.Status__c=='Cancel' &&  dis.SAP_TYPE__c =='Cancel同步成功'){
                        deleteDisStockList.add(dis);
                    }
                }
                delete deleteDisStockList; 
            }
            
            if(SapNewReturn ==null){
                system.debug('222');
                for(Distribution_Stock__c dis : DisStockList){
                    dis.SAP_TYPES__c = 'E';
                    dis.SAP_TYPE__c ='同步失败'; 
                    
                    updateDisStockList.add(dis);
                }
                if(updateDisStockList.size()>0){
                    // update updateDisStockList; 
                }
                
            }
            
            system.debug('-------->fanhuichenggong:');
            // upload log
            //  uploadList();
        }
    }

}