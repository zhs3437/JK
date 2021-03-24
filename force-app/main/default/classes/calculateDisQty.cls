public class calculateDisQty {
    
    //此方法用于获取T仓总数量
    public Map<String,Decimal> totalNunberMethod(string d_stauts,string s_lgort){
        system.debug('==============calculateDisQty.totalNunberMethod================');
        Map<String,Decimal> blNo_sapM_NumMap = new Map<String,Decimal>();
        try{
            list<Distribution_Stock__c> dStockLst = [select Distribution_Quantity__c,Status__c,BL_No__c,SAP_Materiel_No__c,SAP_LGORT__c,SAP_W_H__c from Distribution_Stock__c
                                                     where Status__c =: d_stauts and SAP_W_H__c =: s_lgort];
            for(Distribution_Stock__c dStock :dStockLst){
                Decimal totalNum = 0;
                String bl_sapMNo = '';
                bl_sapMNo = dStock.SAP_W_H__c + '_'+ SapMap.InventoryStatusValue(dStock.Status__c) +'_'+ dStock.BL_No__c + '_'+ dStock.SAP_Materiel_No__c;
                if(blNo_sapM_NumMap.containsKey(bl_sapMNo)){
                    totalNum = dStock.Distribution_Quantity__c + blNo_sapM_NumMap.get(bl_sapMNo);
                    blNo_sapM_NumMap.put(bl_sapMNo,totalNum);
                }else{
                    blNo_sapM_NumMap.put(bl_sapMNo,dStock.Distribution_Quantity__c);
                }
            }
        }catch(Exception e){
            system.debug('Message:'+e.getMessage());
        }
        return blNo_sapM_NumMap;
    }
    
    //此方法用于获取F仓总数量
    public Map<String,Decimal> F_totalNunberMethod(string d_stauts,string s_lgort){
        system.debug('==============calculateDisQty.totalNunberMethod================');
        Map<String,Decimal> f_blNo_sapM_NumMap = new Map<String,Decimal>();
        try{
            list<Distribution_Stock__c> dStockLst = [select Distribution_Quantity__c,Status__c,BL_No__c,SAP_Materiel_No__c,SAP_LGORT__c,SAP_W_H__c from Distribution_Stock__c
                                                     where Status__c =: d_stauts and SAP_W_H__c !=: s_lgort];
           // system.debug('dStockLst============:'+dStockLst);
            for(Distribution_Stock__c dStock :dStockLst){
                Decimal totalNum = 0;
                String f_bl_sapMNo = '';
                f_bl_sapMNo = dStock.SAP_W_H__c + '_'+ dStock.Status__c +'_'+ dStock.BL_No__c + '_'+ dStock.SAP_Materiel_No__c;
                if(f_blNo_sapM_NumMap.containsKey(f_bl_sapMNo)){
                    totalNum = dStock.Distribution_Quantity__c + f_blNo_sapM_NumMap.get(f_bl_sapMNo);
                    f_blNo_sapM_NumMap.put(f_bl_sapMNo,totalNum);
                }else{
                    f_blNo_sapM_NumMap.put(f_bl_sapMNo,dStock.Distribution_Quantity__c);
                }
            }
        }catch(Exception e){
            system.debug('Message:'+e.getMessage());
        }
        return f_blNo_sapM_NumMap;
    }
    
    
    public void calDisMethod(list<SapEccCompleteStatus.CompleteStatusReturn_element> returnList,string sap_wh,string sap_status,Map<string,Decimal> blNo_sapM_NumMap,Map<string,Decimal> f_blNo_sapM_NumMap){
        system.debug('==============calculateDisQty.calDisMethod================');
        try{
            Double diffNum = 0;   //各仓库各状态的总差异数量
            string reStr = SapMap.InventoryStatusValue(sap_status); 
            //找出CRM 中T仓各状态的记录
            list<Distribution_Stock__c> T_dStockLst = [select id,Distribution_Quantity__c,Status__c,BL_No__c,SAP_Materiel_No__c,SAP_LGORT__c,SAP_W_H__c,Total_Quantity__c,
                                                       Apply_Inventory__c,Inventory__c,T_WH_Id__c,Contract_PO_PI__c,Product_Type__c,SAP_TYPE__c,SAP_TYPES__c,Total_MW__c,
                                                       Payment_Term__c,Date_of_delivery__c,Status_Old__c,SAP_WERKS__c,SAP_BLNO__c,Order__c,syncNumber__c,SAP_Short_Materiel_No__c
                                                       from Distribution_Stock__c WHERE SAP_W_H__c =:sap_wh and Status__c =: sap_status ORDER BY Distribution_Quantity__c DESC];
            //找出CRM 中F仓各状态的记录
            list<Distribution_Stock__c> F_dStockLst = [select id,Distribution_Quantity__c,Status__c,BL_No__c,SAP_Materiel_No__c,SAP_LGORT__c,SAP_W_H__c,Total_Quantity__c,SAP_Delivery_order_no__c,
                                                       Apply_Inventory__c,Inventory__c,T_WH_Id__c,Contract_PO_PI__c,Product_Type__c,SAP_TYPE__c,SAP_TYPES__c,Total_MW__c,
                                                       Payment_Term__c,Date_of_delivery__c,Status_Old__c,SAP_WERKS__c,SAP_BLNO__c,Order__c,syncNumber__c,SAP_Short_Materiel_No__c
                                                       from Distribution_Stock__c WHERE SAP_W_H__c !=:sap_wh and Status__c =: sap_status and T_WH_Id__c != null and SAP_Delivery_order_no__c=:null
                                                       ORDER BY Distribution_Quantity__c DESC];
            List<String> F_WHLst = new List<String>();
            for(Distribution_Stock__c f_WH : F_dStockLst){
                if(F_WHLst ==null){
                    F_WHLst.add(f_WH.SAP_W_H__c);
                }else{
                    if(!F_WHLst.contains(f_WH.SAP_W_H__c)){
                        F_WHLst.add(f_WH.SAP_W_H__c);
                    }
                }
                
                
            }
         List<String> keyStringLst = new List<String>();
          system.debug('F_WHLst--->'+F_WHLst);            
            //需要更新的T仓记录列表
            list<Distribution_Stock__c> update_tdStockLst = new list<Distribution_Stock__c>();
            //F仓的Map
            map<string,Decimal> wh_s_bl_sapmDiffMap = new map<string,Decimal>();
            //找出存在数量差异的各状态的仓库
          //  system.debug('returnList======:'+returnList.size()+'----'+returnList);
            if(returnList.size()>0 && returnList != null){
                for(SapEccCompleteStatus.CompleteStatusReturn_element sEcc_CSR : returnList){
                    
                    if(sEcc_CSR.LGORT == sap_wh){
                        if(sEcc_CSR.STATUS == reStr){
                            string bl_Mnum = sEcc_CSR.LGORT+'_'+sEcc_CSR.STATUS+'_'+sEcc_CSR.BLNO+'_'+sEcc_CSR.MATNR;
                          system.debug('bl_Mnum===:'+bl_Mnum);
                            for(String ct_Map_key : blNo_sapM_NumMap.keySet()){
                                if(ct_Map_key == bl_Mnum){
                                    Decimal n = blNo_sapM_NumMap.get(ct_Map_key);
                                    diffNum =Double.valueOf(n) - Double.valueOf(sEcc_CSR.QYP_PC);
                                }
                            }
                            system.debug('diffNum======:'+diffNum);
                            //对T仓进行处理
                            if(diffNum >0){
                                system.debug('sEcc_CSR====:'+sEcc_CSR.LGORT+'-'+sEcc_CSR.STATUS+'-'+sEcc_CSR.BLNO+'-'+sEcc_CSR.MATNR);
                                for(Distribution_Stock__c tdStock: T_dStockLst){
                                    if(tdStock.SAP_W_H__c == sEcc_CSR.LGORT && SapMap.InventoryStatusValue(tdStock.Status__c) == sEcc_CSR.STATUS && tdStock.BL_No__c ==sEcc_CSR.BLNO && tdStock.SAP_Materiel_No__c == sEcc_CSR.MATNR){
                                       system.debug('tdStock====:'+tdStock.SAP_W_H__c+'-'+SapMap.InventoryStatusValue(tdStock.Status__c)+'-'+tdStock.BL_No__c+'-'+tdStock.SAP_Materiel_No__c);
                                        Decimal num = tdStock.Distribution_Quantity__c - diffNum;
                                       system.debug('num====:'+num);
                                        if(num >=0){
                                           system.debug('tdStockId===========:'+tdStock.Id);
                                            if(tdStock.Total_Quantity__c == null){
                                                tdStock.Total_Quantity__c = tdStock.Distribution_Quantity__c;
                                            }
                                            tdStock.Distribution_Quantity__c = num;
                                            update_tdStockLst.add(tdStock);
                                            break;
                                        }else{
                                            system.debug('tdStockId===========:'+tdStock.Id);
                                            diffNum = Math.abs(num);
                                            if(tdStock.Total_Quantity__c == null){
                                                tdStock.Total_Quantity__c = tdStock.Distribution_Quantity__c;
                                            }
                                            tdStock.Distribution_Quantity__c = 0;
                                            update_tdStockLst.add(tdStock);
                                            break;
                                        }
                                    }
                             
                                }
                            }
                        }
                    }
                    else{
                        //得到F仓的总差异数量
                        string wh_s_bl_sapm = sEcc_CSR.LGORT+'_'+sEcc_CSR.STATUS+'_'+sEcc_CSR.BLNO+'_'+sEcc_CSR.MATNR;
                    //    system.debug('wh_s_bl_sapm==========:'+wh_s_bl_sapm);
                        for(String ct_Map_key : f_blNo_sapM_NumMap.keySet()){
                            if(ct_Map_key == wh_s_bl_sapm){
                                Decimal n = f_blNo_sapM_NumMap.get(ct_Map_key);
                                diffNum =Double.valueOf(n) - Double.valueOf(sEcc_CSR.QYP_PC);
                                //diffNum = Math.abs(diffNum);
                                wh_s_bl_sapmDiffMap.put(wh_s_bl_sapm,diffNum);
                                keyStringLst.add(wh_s_bl_sapm);
                            }
                            
                            if(!F_WHLst.contains(sEcc_CSR.LGORT)){
                                if(sEcc_CSR.LGORT !='T005' && sEcc_CSR.LGORT !='T006'){
                                    diffNum = Double.valueOf(sEcc_CSR.QYP_PC);
                                    //diffNum = Math.abs(diffNum);                        
                                    wh_s_bl_sapmDiffMap.put(wh_s_bl_sapm,diffNum);
                                     keyStringLst.add(wh_s_bl_sapm);
                                }
                            }
                        }
                    }
                }
                
                if(update_tdStockLst.size() >0 && update_tdStockLst != null){
                //    system.debug('update_tdStockLst.size()=====:'+update_tdStockLst.size()+'--'+update_tdStockLst);
                    update update_tdStockLst;
                }
            }
            
            system.debug('wh_s_bl_sapmDiffMap----->'+wh_s_bl_sapmDiffMap);            
            //这些T仓分为两种：1.存在F仓的更新F仓　2 不存在F的新建F仓
            if(update_tdStockLst != null  && update_tdStockLst.size()>0){
                //已存在F的T仓
               // system.debug('update_tdStockLst====:'+update_tdStockLst);
                list<Distribution_Stock__c> existF = new list<Distribution_Stock__c>();
                if(F_dStockLst.size() >0 && F_dStockLst != null){
                    for(Distribution_Stock__c update_tdStock :update_tdStockLst){
                        for(Distribution_Stock__c fdStock:F_dStockLst){
                            if(fdStock.T_WH_Id__c ==update_tdStock.Id){
                                string f_diffNumMap = fdStock.SAP_W_H__c+'_'+SapMap.InventoryStatusValue(fdStock.Status__c) +'_'+fdStock.BL_No__c+'_'+fdStock.SAP_Materiel_No__c;
                                if(wh_s_bl_sapmDiffMap.containsKey(f_diffNumMap)){
                                    Decimal d = wh_s_bl_sapmDiffMap.get(f_diffNumMap);
                                    d = Math.abs(d);
                               //     system.debug('d==========:'+d);
                                    for(SapEccCompleteStatus.CompleteStatusReturn_element sEcc_CSR : returnList){
                                        if(SapMap.InventoryStatusValue(fdStock.Status__c) == sEcc_CSR.STATUS && fdStock.BL_No__c ==sEcc_CSR.BLNO && fdStock.SAP_Materiel_No__c == sEcc_CSR.MATNR && fdStock.SAP_W_H__c == sEcc_CSR.LGORT){
                                            //string f_diffNumMap = sEcc_CSR.LGORT+'-'+sEcc_CSR.STATUS+'-'+sEcc_CSR.BLNO+'-'+sEcc_CSR.MATNR;
                                            
                                            Decimal fdNum= fdStock.Total_Quantity__c - fdStock.Distribution_Quantity__c;
                                       //     system.debug('fdNum==========:'+fdNum);
                                            if(d >fdNum){
                                                d=d- fdNum;
                                                fdStock.Distribution_Quantity__c = fdStock.Total_Quantity__c;
                                            }else{
                                                fdStock.Distribution_Quantity__c = fdStock.Distribution_Quantity__c + d;
                                                d=0;
                                            }
                                            existF.add(fdStock);
                                            
                                        }
                                        if(d== 0){
                                            break;
                                        }
                                        
                                    }
                                }else{
                                    
                                }
                            }
                        }
                    }
                 //   system.debug('existF=========:'+existF);
                    update existF;
                }
                else{
                               List<Distribution_Stock__c> newDSLst = new List<Distribution_Stock__c>();
            if(!wh_s_bl_sapmDiffMap.isEmpty()){
             
                list<Distribution_Stock__c> update_f_dStockLst = new list<Distribution_Stock__c>();
                list<Distribution_Stock__c> update_t_dStockLst = new list<Distribution_Stock__c>();
                
                //更新F仓
                for(Distribution_Stock__c f_dStock :F_dStockLst){
                    string fd_str = f_dStock.SAP_W_H__c+'_'+SapMap.InventoryStatusValue(f_dStock.Status__c) +'_'+f_dStock.BL_No__c+'_'+f_dStock.SAP_Materiel_No__c;
                     // system.debug('fd_str--->'+fd_str);
                    if(wh_s_bl_sapmDiffMap.containsKey(fd_str)){
       
                        //更新T仓
                        for(Distribution_Stock__c t_dStock:T_dStockLst){
                            if(t_dStock.id == f_dStock.T_WH_Id__c){
                                String td_str = t_dStock.SAP_W_H__c+'_'+SapMap.InventoryStatusValue(t_dStock.Status__c) +'_'+t_dStock.BL_No__c+'_'+t_dStock.SAP_Materiel_No__c;
                                decimal dnum = blNo_sapM_NumMap.get(td_str);
                                if(dnum != 0){
                                  //  system.debug('dnum========:'+dnum);
                                    //F----->T
                                    //更新T 仓
                                    if(!update_t_dStockLst.contains(t_dStock)){
                                        t_dStock.Distribution_Quantity__c = t_dStock.Distribution_Quantity__c + wh_s_bl_sapmDiffMap.get(fd_str);
                                        if(wh_s_bl_sapmDiffMap.get(fd_str)>0){
                                            update_t_dStockLst.add(t_dStock);
                                        }
                                    }
                                    else{
                                        t_dStock.Distribution_Quantity__c = t_dStock.Distribution_Quantity__c + wh_s_bl_sapmDiffMap.get(fd_str);
                                    }
                                    //更新F 仓
                                    System.debug('f_dStock.Distribution_Quantity__c-->'+f_dStock.Distribution_Quantity__c);
                                      System.debug(' wh_s_bl_sapmDiffMap.get(fd_str)-->'+ wh_s_bl_sapmDiffMap.get(fd_str));
                                    Decimal f_diffNum = f_dStock.Distribution_Quantity__c - wh_s_bl_sapmDiffMap.get(fd_str);
                                    if(f_diffNum >=0){
                                        
                                        f_dStock.Distribution_Quantity__c = f_diffNum;
                                        if(f_dStock.Distribution_Quantity__c <= f_dStock.Total_Quantity__c && wh_s_bl_sapmDiffMap.get(fd_str) !=0){
                                             system.debug('td_str======================:'+fd_str);
                                    system.debug('wh_s_bl_sapmDiffMap.get(fd_str=======:'+wh_s_bl_sapmDiffMap.get(fd_str));
                                    system.debug('f_dStock.Distribution_Quantity__c=======:'+f_dStock.Distribution_Quantity__c);
                                            update_f_dStockLst.add(f_dStock);
                                        }
                                      
                                    }else{
                                        
                                        wh_s_bl_sapmDiffMap.put(fd_str,Math.abs(f_diffNum));
                                        f_dStock.Distribution_Quantity__c = 0;
                                        if(f_dStock.Distribution_Quantity__c <= f_dStock.Total_Quantity__c && wh_s_bl_sapmDiffMap.get(fd_str) !=0){
                                             system.debug('td_str======================:'+fd_str);
                                    system.debug('wh_s_bl_sapmDiffMap.get(fd_str=======:'+wh_s_bl_sapmDiffMap.get(fd_str));
                                    system.debug('f_dStock.Distribution_Quantity__c=======:'+f_dStock.Distribution_Quantity__c);
                                          //  update_f_dStockLst.add(f_dStock);
                                          
                                        }
                               
                                    }
                                    
                                }else{
                                    //F----->F
                                 //   system.debug('wh_s_bl_sapmDiffMap.get(fd_str=======:'+wh_s_bl_sapmDiffMap.get(fd_str));
                                //    system.debug('f_dStock.Distribution_Quantity__c=======:'+f_dStock.Distribution_Quantity__c);
                                    f_dStock.Distribution_Quantity__c = f_dStock.Distribution_Quantity__c - wh_s_bl_sapmDiffMap.get(fd_str);
                                   
                                    if(f_dStock.Distribution_Quantity__c <= f_dStock.Total_Quantity__c && wh_s_bl_sapmDiffMap.get(fd_str) !=0){
                                         system.debug('td_str======================:'+fd_str);
                                    system.debug('wh_s_bl_sapmDiffMap.get(fd_str=======:'+wh_s_bl_sapmDiffMap.get(fd_str));
                                    system.debug('f_dStock.Distribution_Quantity__c=======:'+f_dStock.Distribution_Quantity__c);
                                        update_f_dStockLst.add(f_dStock);
                              newDSLst.add(f_dStock);
                                    }
                                }
                            
                            }
                        }
                        
                    }
                    
                      
                }
                system.debug('update_f_dStockLst==========:'+update_f_dStockLst);
                if(update_f_dStockLst.size() >0 && update_f_dStockLst != null){
                    update update_f_dStockLst;
                }
                system.debug('update_t_dStockLst=========:'+update_t_dStockLst);
                if(update_t_dStockLst.size() >0 && update_t_dStockLst != null){
                    update update_t_dStockLst;
                    system.debug('111111');
                }
                List<Distribution_Stock__c> newCreateDistributionLst = new  List<Distribution_Stock__c>();
                system.debug('newDSLst--->'+newDSLst);
                for(Distribution_Stock__c Reduce :newDSLst){
                    Decimal FD_Exist =0;
                    for(Distribution_Stock__c TDSLst : F_dStockLst){
                        if(Reduce.Status__c == TDSLst.Status__c && Reduce.BL_No__c == TDSLst.BL_No__c && Reduce.SAP_Materiel_No__c == TDSLst.SAP_Materiel_No__c && Reduce.SAP_W_H__c != TDSLst.SAP_W_H__c){
                            if(TDSLst.SAP_W_H__c !='T005' && TDSLst.SAP_W_H__c !='T006'){
                               FD_Exist = 1; 
                            }
                        }
                    }
                    if(FD_Exist==0){
                      String bl_sapMNo = Reduce.SAP_W_H__c + '_'+ SapMap.InventoryStatusValue(Reduce.Status__c) +'_'+ Reduce.BL_No__c + '_'+ Reduce.SAP_Materiel_No__c;
                      Set<String> keys = wh_s_bl_sapmDiffMap.keySet();
                        for(String key : keys){
                            if(key != bl_sapMNo){
                                String newbl_sapMNo = SapMap.InventoryStatusValue(Reduce.Status__c) +'_'+ Reduce.BL_No__c + '_'+ Reduce.SAP_Materiel_No__c;
                                if(key.indexof(newbl_sapMNo)>-1){
                                      Distribution_Stock__c new_dStock = new Distribution_Stock__c();
                            new_dStock = Reduce.clone();
                            new_dStock.T_WH_Id__c = Reduce.id;
                            new_dStock.Distribution_Quantity__c =0;
                            new_dStock.Contract_PO_PI__c = Reduce.Contract_PO_PI__c;
                            new_dStock.Product_Type__c = Reduce.Product_Type__c;
                            new_dStock.SAP_TYPE__c = Reduce.SAP_TYPE__c;
                            new_dStock.SAP_TYPES__c = Reduce.SAP_TYPES__c;
                           // new_dStock.Total_MW__c = new_Dbs.Total_MW__c;
                            new_dStock.Payment_Term__c = Reduce.Payment_Term__c;
                            new_dStock.Date_of_delivery__c = Reduce.Date_of_delivery__c;
                            new_dStock.Status_Old__c = Reduce.Status_Old__c;
                            new_dStock.SAP_WERKS__c = Reduce.SAP_WERKS__c;
                            new_dStock.SAP_BLNO__c = Reduce.SAP_BLNO__c;
                            new_dStock.Order__c = Reduce.Order__c;
                            new_dStock.syncNumber__c = Reduce.syncNumber__c;
                            new_dStock.SAP_Short_Materiel_No__c = Reduce.SAP_Short_Materiel_No__c;
                               List<String> FkeyLst = Key.split('_');
                              new_dStock.Distribution_Quantity__c = wh_s_bl_sapmDiffMap.get(key);
                                new_dStock.SAP_W_H__c = FkeyLst[0];
                                    new_dStock.SAP_LGORT__c = SapMap.getWH_Opposite(new_dStock.SAP_W_H__c);
                                    newCreateDistributionLst.add(new_dStock);
                                }
                            }
                        }
                    }
                }
                  if(newCreateDistributionLst.size() >0 && newCreateDistributionLst != null){
                      system.debug('newCreateDistributionLst----->'+newCreateDistributionLst);
                 //   insert newCreateDistributionLst;
                         system.debug('newCreateDistributionLst----->'+newCreateDistributionLst);
                    system.debug('111111');
                }
            }
            
                }
                
                //新建F仓
                system.debug('existF.Size()======:'+existF.size()+'--'+ existF);
                system.debug('update_tdStockLst.size()=========:'+update_tdStockLst.size()+'--'+ update_tdStockLst);
                list<Distribution_Stock__c> not_exist_F = getDisLst(update_tdStockLst,existF);
                system.debug('not_exist_F.Size()======:'+not_exist_F.isEmpty()+'--'+not_exist_F);
                list<Distribution_Stock__c> create_dStockLst = new list<Distribution_Stock__c>();
                if(not_exist_F.size() >0 && not_exist_F != null){
                    for(Distribution_Stock__c new_Dbs : not_exist_F){
                     //   system.debug('new_Dbs=============:'+new_Dbs);
                        
                        for(SapEccCompleteStatus.CompleteStatusReturn_element sEcc_CSR : returnList){
                            Distribution_Stock__c new_dStock = new Distribution_Stock__c();
                            new_dStock = new_Dbs.clone();
                            new_dStock.T_WH_Id__c = new_Dbs.id;
                            new_dStock.Distribution_Quantity__c =0;
                            new_dStock.Contract_PO_PI__c = new_Dbs.Contract_PO_PI__c;
                            new_dStock.Product_Type__c = new_Dbs.Product_Type__c;
                            new_dStock.SAP_TYPE__c = new_Dbs.SAP_TYPE__c;
                            new_dStock.SAP_TYPES__c = new_Dbs.SAP_TYPES__c;
                            new_dStock.Total_MW__c = new_Dbs.Total_MW__c;
                            new_dStock.Payment_Term__c = new_Dbs.Payment_Term__c;
                            new_dStock.Date_of_delivery__c = new_Dbs.Date_of_delivery__c;
                            new_dStock.Status_Old__c = new_Dbs.Status_Old__c;
                            new_dStock.SAP_WERKS__c = new_Dbs.SAP_WERKS__c;
                            new_dStock.SAP_BLNO__c = new_Dbs.SAP_BLNO__c;
                            new_dStock.Order__c = new_Dbs.Order__c;
                            new_dStock.syncNumber__c = new_Dbs.syncNumber__c;
                            new_dStock.SAP_Short_Materiel_No__c = new_Dbs.SAP_Short_Materiel_No__c;
                            if(sEcc_CSR.LGORT != sap_wh){
                               
                                if(SapMap.InventoryStatusValue(new_dStock.Status__c) == sEcc_CSR.STATUS && new_dStock.BL_No__c ==sEcc_CSR.BLNO && new_dStock.SAP_Materiel_No__c == sEcc_CSR.MATNR){
                                    string f_diffNumMap = sEcc_CSR.LGORT+'_'+SapMap.InventoryStatusValue(new_dStock.Status__c) +'_'+new_dStock.BL_No__c+'_'+new_dStock.SAP_Materiel_No__c;
                                      
                                    if(wh_s_bl_sapmDiffMap.containsKey(f_diffNumMap)){
                                      Decimal d = wh_s_bl_sapmDiffMap.get(f_diffNumMap);
                                        d = Math.abs(d);
                                        system.debug('d==========:'+d);
                                        Decimal fdNum= new_dStock.Total_Quantity__c - new_dStock.Distribution_Quantity__c;
                                        system.debug('fdNum==========:'+fdNum);
                                        if(d >fdNum){
                                            d=d- fdNum;
                                            new_dStock.Distribution_Quantity__c = new_dStock.Total_Quantity__c;
                                        }else{
                                            new_dStock.Distribution_Quantity__c = new_dStock.Distribution_Quantity__c + d;
                                            d=0;
                                        }
                                         
                                 
                                    
                                    new_dStock.SAP_W_H__c = sEcc_CSR.LGORT;
                                  //  system.debug('new_dStock.SAP_W_H__c=======：'+new_dStock.SAP_W_H__c);
                                    new_dStock.SAP_LGORT__c = SapMap.getWH_Opposite(new_dStock.SAP_W_H__c);
                                  //  system.debug('new_dStock.SAP_LGORT__c=======：'+new_dStock.SAP_LGORT__c);
                                  //  system.debug('create_dStockLst===========:'+create_dStockLst);
                                        if(new_dStock.Distribution_Quantity__c >0){
                                              create_dStockLst.add(new_dStock);
                                        }
                                  
                                      
                                  //  system.debug('create_dStockLst===========:'+create_dStockLst);
                                      }
                                }
                            }
                        }
                    }
                    system.debug('create_dStockLst---->'+create_dStockLst);
                    if(create_dStockLst != null && create_dStockLst.size() >0){
                        system.debug('create_dStockLst=====:'+create_dStockLst.size()+'--'+create_dStockLst);
                        insert create_dStockLst;
                    }
                }
            }
            
            
            //F----->T
            //或者F---->F

            
          //  System.debug('newStringLst.size()------------------>'+newStringLst.size());
          //   System.debug('keyStringLst.size()------------------>'+keyStringLst.size());
        }catch(Exception e){
            system.debug('Message=====:'+e.getMessage());
        }
        
    }
    
    public list<Distribution_Stock__c> getDisLst(list<Distribution_Stock__c> mostLst,list<Distribution_Stock__c> littleLst){
       system.debug('==============calculateDisQty.getDisLst================');
        list<Distribution_Stock__c> disLst = new list<Distribution_Stock__c>();
        Map<string,Distribution_Stock__c> mostLstMap = new Map<string,Distribution_Stock__c>();
        Map<string,Distribution_Stock__c> littleLstMap = new Map<string,Distribution_Stock__c>();
        for(Distribution_Stock__c m_dStock:mostLst){
            if(mostLstMap.containsKey(m_dStock.Id)){
                mostLstMap.put(m_dStock.Id, m_dStock);
            }else{
                mostLstMap.put(m_dStock.Id, m_dStock);
            }
        }
        system.debug('littleLst----->'+littleLst);
        if(littleLst.size() >0 && littleLst != null){
            for(Distribution_Stock__c l_dStock:littleLst){
                if(littleLstMap.containsKey(l_dStock.T_WH_Id__c)){
                    littleLstMap.put(l_dStock.T_WH_Id__c, l_dStock);
                }else{
                    littleLstMap.put(l_dStock.T_WH_Id__c, l_dStock);
                }
            }
        }
         system.debug('littleLst----->'+littleLst);
        for(string dstockId: mostLstMap.keySet()){
            if(littleLstMap !=null){
               if(!littleLstMap.containsKey(dstockId)){
                disLst.add(mostLstMap.get(dstockId));
               }
                
            }else{
                disLst.add(mostLstMap.get(dstockId));
            }
            
        }
        system.debug('disLst=====:'+disLst);
        return disLst;
    }
}