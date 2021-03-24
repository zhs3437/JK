/*
 *create By Jason
 */

public class ContractHelper {
    public static void  refreshRecord(Contract c){
       // c.CMO_Dept__c = '';
       // c.CMO_Dept_Comments__c = '';
       // c.Sales_Dept__c = '';
       // c.Sales_Dept_Comments__c = '';
       // c.BMO_Dept_New__c = '';
       // c.BMO_Dept_Comments2__c = '';
        //c.Finance_Dept__c = '';
        //c.Finance_Dept_Comments__c = '';
    }
	
	// update kane
	public static ID getContractRecordTypeId(Opportunity opp){  
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID USARecordTypeId          = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('inventory(USA)').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
    	ID InventoryRecordTypeId 	= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Inventory Contract').getRecordTypeId();
          Opportunity  opp2 = [SELECT ID,AccountId,
                                 StageName,
                                 RecordType.Name,
                                 Payment_1MW_Approve__c,
                                 Total_MW__c,
                                 Trade_Term__c,
                                 Total_Quantity__c,
                                 Payment_Term_Description__c,
                                 whether_pick_up_batch__c,
                                 Price_Approval_Status__c,
                                 Sales_manager_approval__c,
                                 Customer_Type__c,
                                 Allow_new_process_for_Japan_picklist__c,
                                 Seller__c,
                                 Special_Terms__c,
                                 Region__c,
                                 Price_Approval_Trigger_Time__c,
                                 Contract__c,
                                 Contract_No__c,
                               Vn_fast__c,
                                 Account.credit_good__c,
                                 Owner.Name
                                 FROM Opportunity 
                                 WHERE id =:opp.id];
        if(opp != null){
            if((opp.Destination_Country__c == 'Australia'||opp.Destination_Country__c == 'New Zealand') && opp.Payment_Term_Description__c != null  && (opp.Total_MW__c <= 1 ||(opp2.Account.credit_good__c==true && opp.Total_MW__c<1.5)) && opp.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                if((opp.Trade_term__c == 'DDP' &&
                    opp.whether_pick_up_batch__c == 'True' && opp.Destination_Country__c !='New Zealand') || opp.Trade_term__c == 'EXW'){
                    // 满足 Australia Standard Contract 条件
                  //  system.debug('-------- Australia1mw' + AustraliaRecordTypeId);
                    return AustraliaRecordTypeId;
                }
            }
            else if(opp.RecordType.Name == 'USA' && opp.Total_MW__c < 2){
                return Standard1MWRecordTypeId;
            }
             else if(opp.RecordType.Name == 'USA' && opp.Total_MW__c > 2){
                return USARecordTypeId;
            }
             else if(opp.Region__c.contains('EU') && opp.Payment_1MW_Approve__c == true && opp.Destination_Country__c!='Ukraine'){
                return Standard1MWRecordTypeId;
            }

            else if(opp.Total_MW__c < 1 && opp.Region__c!='Middle East&Africa'&&opp.Region__c!='MENA'&&opp.Region__c!='SSA'&& opp.Region__c!='ROA'){
                 //   system.debug('-------- Total_MW__c' + opp.Total_MW__c + opp.RecordType);
                //    system.debug('------opp.Payment_Term_Description__c' + opp.Payment_Term_Description__c);
//                    system.debug('------opp.pp.Total_Quantity__c' + opp.Total_Quantity__c);
               //     system.debug('------opp.pp.Total_Quantity__opp.SELLER__c' + opp.SELLER__c + opp.Trade_term__c + opp.whether_pick_up_batch__c );
                    
                    // 1.Total MW < 1
                    if(opp.Trade_Term__c == 'CIF' || opp.Trade_Term__c == 'CIP'|| opp.Trade_Term__c == 'EXW' || opp.Trade_Term__c == 'FOB' || opp.Trade_Term__c == 'DAP' || opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'CFR'|| opp.Trade_Term__c == 'CPT'){
                        // 2.Trade Term = CIF / EXW / FOB / DAP / CFR
                       // system.debug('---- Trade Term');
                        if(opp.Special_Terms__c =='' || opp.Special_Terms__c == null){
                        //    system.debug('---- Special_Terms__c');
                            if(opp.Payment_1MW_Approve__c == true &&
                                (opp.Sales_manager_approval__c == 'Approved' || opp.Price_Approval_Status__c == 'Approved') &&
                                opp.RecordType.Name != 'Japan' && opp.Region__c != 'North America' && (opp.Destination_Country__c != 'Australia'&& opp.Destination_Country__c != 'New Zealand' && opp.Destination_Country__c!='Ukraine')){
                                   // system.debug('-------- Standard1MWRecordTypeId' + Standard1MWRecordTypeId);
                                // 全球 1MW
                                return Standard1MWRecordTypeId;
                            }else if(opp.Allow_new_process_for_Japan_picklist__c == 'allow' && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                               //    system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return Japan1MWRecordTypeId;
                            }
                            
                            //当业务机会小于1MW，并且业务机会类型时JApan时，并且字段Allow_new_process_for_Japan_picklist__c 为Not Allow时 返回普通的合同类型
                          /**
                            else if((opp.Allow_new_process_for_Japan_picklist__c == 'Not allow'|| opp.Allow_new_process_for_Japan_picklist__c == 'pending') && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                                   system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return InventoryRecordTypeId;
                            }
                         */
                        }
                    }
            }
             else if((opp.Total_MW__c < 5 && (opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA'))||(opp.Total_MW__c < 5 && opp.Region__c=='ROA')){
               if(opp.Total_MW__c < 2 && (opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp2.Account.credit_good__c==true){
                   return Standard1MWRecordTypeId;
                   }
                  if(opp.Total_MW__c < 3 && opp2.vn_fast__c==true){
                   return Standard1MWRecordTypeId;
                   }
                 else if(opp.Trade_Term__c == 'CIF' || opp.Trade_Term__c == 'CIP'|| opp.Trade_Term__c == 'EXW' || opp.Trade_Term__c == 'FOB' || opp.Trade_Term__c == 'DAP' || opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'CFR'|| opp.Trade_Term__c == 'CPT'){
                        // 2.Trade Term = CIF / EXW / FOB / DAP / CFR
                       // system.debug('---- Trade Term');
                        if(opp.Special_Terms__c =='' || opp.Special_Terms__c == null){
                        //    system.debug('---- Special_Terms__c');
                            if(opp.Payment_1MW_Approve__c == true &&
                                (opp.Sales_manager_approval__c == 'Approved' || opp.Price_Approval_Status__c == 'Approved') &&
                                opp.RecordType.Name != 'Japan' && opp.Region__c != 'North America' && (opp.Destination_Country__c != 'Australia'&& opp.Destination_Country__c != 'New Zealand')){
                                   // system.debug('-------- Standard1MWRecordTypeId' + Standard1MWRecordTypeId);
                                // 全球 1MW
                                return Standard1MWRecordTypeId;
                            }else if(opp.Allow_new_process_for_Japan_picklist__c == 'allow' && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                               //    system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return Japan1MWRecordTypeId;
                            }
                            
                            //当业务机会小于1MW，并且业务机会类型时JApan时，并且字段Allow_new_process_for_Japan_picklist__c 为Not Allow时 返回普通的合同类型
                          /**
                            else if((opp.Allow_new_process_for_Japan_picklist__c == 'Not allow'|| opp.Allow_new_process_for_Japan_picklist__c == 'pending') && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                                   system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return InventoryRecordTypeId;
                            }
                         */
                        }
                    }
             }
           /**
             //当业务机会大于1MW，并且业务机会类型时JApan时，并且字段Allow_new_process_for_Japan_picklist__c 为Not Allow时 返回普通的合同类型
            else if(opp.Total_MW__c > 1){
                if( opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                 
                                    
                                    return InventoryRecordTypeId;
                }
            }
           */
        }
        
    
	return null;
}

    //	Refresh Data 专用
    // start
    
    public static ID refreshDateRecordTypeId(Opportunity opp){  
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        ID InventoryRecordTypeId 	= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Inventory Contract').getRecordTypeId();
        ID InventoryUSARecordTypeId 	= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('inventory(USA)').getRecordTypeId();
   Opportunity  opp2 = [SELECT ID,AccountId,
                                 StageName,
                                 RecordType.Name,
                                 Payment_1MW_Approve__c,
                                 Total_MW__c,
                                 Trade_Term__c,
                                 Total_Quantity__c,
                                 Payment_Term_Description__c,
                                 whether_pick_up_batch__c,
                                 Price_Approval_Status__c,
                                 Sales_manager_approval__c,
                                 Customer_Type__c,
                                 Allow_new_process_for_Japan_picklist__c,
                                 Seller__c,
                                 Special_Terms__c,
                                 Region__c,
                        vn_fast__c,
                                 Price_Approval_Trigger_Time__c,
                                 Contract__c,
                                 Contract_No__c,
                                 Account.credit_good__c,
                                 Owner.Name
                                 FROM Opportunity 
                                 WHERE id =:opp.id];
        if(opp != null){
            system.debug('到这里');
            system.debug(opp.Destination_Country__c == 'Australia');
            //system.debug(opp.Payment_Term_Description__c.contains('T/T'));
            //system.debug(opp.Payment_Term_Description__c.contains('the last day'));
            system.debug(opp.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD');
            system.debug(opp.Payment_Term_Description__c != null);
            system.debug(opp.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD');
            if((opp.Destination_Country__c == 'Australia'||opp.Destination_Country__c == 'New Zealand') && opp.Payment_Term_Description__c != null && opp.Payment_Term_Description__c.contains('T/T')  && (opp.Total_MW__c <= 1 ||(opp2.Account.credit_good__c==true && opp.Total_MW__c<1.5) ) && opp.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
                if((opp.Trade_term__c == 'DDP' &&
                    opp.whether_pick_up_batch__c == 'True' && opp.Destination_Country__c !='New Zealand') || opp.Trade_term__c == 'EXW'){
                    // 满足 Australia Standard Contract 条件
                    system.debug('-------- Australia1mw' + AustraliaRecordTypeId);
                    return AustraliaRecordTypeId;
                }
            }
                        else if(opp.RecordType.Name == 'USA' && opp.Total_MW__c < 2){
                return Standard1MWRecordTypeId;
            }
            else if(opp.Region__c.contains('EU') && opp.Payment_1MW_Approve__c == true && opp.Destination_Country__c!='Ukraine'){
                return Standard1MWRecordTypeId;
            }
            else if(opp.Total_MW__c < 1 && opp.Region__c!='Middle East&Africa'&&opp.Region__c!='MENA'&&opp.Region__c!='SSA' && opp.Region__c!='ROA'){
                 //   system.debug('-------- Total_MW__c' + opp.Total_MW__c + opp.RecordType);
                //    system.debug('------opp.Payment_Term_Description__c' + opp.Payment_Term_Description__c);
//                    system.debug('------opp.pp.Total_Quantity__c' + opp.Total_Quantity__c);
               //     system.debug('------opp.pp.Total_Quantity__opp.SELLER__c' + opp.SELLER__c + opp.Trade_term__c + opp.whether_pick_up_batch__c );
                    
                    // 1.Total MW < 1
                    if(opp.Trade_Term__c == 'CIF' || opp.Trade_Term__c == 'EXW' || opp.Trade_Term__c == 'FOB' || opp.Trade_Term__c == 'DAP' || opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'CFR'|| opp.Trade_Term__c == 'CPT'){
                        // 2.Trade Term = CIF / EXW / FOB / DAP / CFR
                       // system.debug('---- Trade Term');
                        if(opp.Special_Terms__c =='' || opp.Special_Terms__c == null){
                        //    system.debug('---- Special_Terms__c');
                            if(opp.Payment_1MW_Approve__c == true &&
                                (opp.Sales_manager_approval__c == 'Approved' || opp.Price_Approval_Status__c == 'Approved') &&
                                opp.RecordType.Name != 'Japan' && opp.Region__c != 'North America' && (opp.Destination_Country__c != 'Australia' && opp.Destination_Country__c != 'New Zealand' && opp.Destination_Country__c!='Ukraine')){
                                   // system.debug('-------- Standard1MWRecordTypeId' + Standard1MWRecordTypeId);
                                // 全球 1MW
                                return Standard1MWRecordTypeId;
                            }else if(opp.Allow_new_process_for_Japan_picklist__c == 'allow' && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                               //    system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return Japan1MWRecordTypeId;
                            }
                            
                            //当业务机会小于1MW，并且业务机会类型时JApan时，并且字段Allow_new_process_for_Japan_picklist__c 为Not Allow时 返回普通的合同类型
                          /**
                            else if((opp.Allow_new_process_for_Japan_picklist__c == 'Not allow'|| opp.Allow_new_process_for_Japan_picklist__c == 'pending') && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                                   system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return InventoryRecordTypeId;
                            }
                         */
                        }
                    }
            }
             else if((opp.Total_MW__c < 5 && (opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA'))||(opp.Total_MW__c < 5 && opp.Region__c=='ROA')){
               if(opp.Total_MW__c < 2 && (opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA') && opp2.Account.credit_good__c==true && opp.Trade_Term__c != 'CPT' && opp.Trade_Term__c != 'DDU'){
                   return Standard1MWRecordTypeId;
                   }
                   if(opp.Total_MW__c < 3 && opp2.vn_fast__c==true){
                   return Standard1MWRecordTypeId;
                   }
                 else if(opp.Trade_Term__c == 'CIF' || opp.Trade_Term__c == 'CIP'|| opp.Trade_Term__c == 'EXW' || opp.Trade_Term__c == 'FOB' || opp.Trade_Term__c == 'DAP' || opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'CFR'|| opp.Trade_Term__c == 'CPT'){
                        // 2.Trade Term = CIF / EXW / FOB / DAP / CFR
                       // system.debug('---- Trade Term');
                        if(opp.Special_Terms__c =='' || opp.Special_Terms__c == null){
                        //    system.debug('---- Special_Terms__c');
                            if(opp.Payment_1MW_Approve__c == true &&
                                (opp.Sales_manager_approval__c == 'Approved' || opp.Price_Approval_Status__c == 'Approved') &&
                                opp.RecordType.Name != 'Japan' && opp.Region__c != 'North America' && (opp.Destination_Country__c != 'Australia'||opp.Destination_Country__c != 'New Zealand')){
                                   // system.debug('-------- Standard1MWRecordTypeId' + Standard1MWRecordTypeId);
                                // 全球 1MW
                                return Standard1MWRecordTypeId;
                            }else if(opp.Allow_new_process_for_Japan_picklist__c == 'allow' && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                               //    system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return Japan1MWRecordTypeId;
                            }
                            
                            //当业务机会小于1MW，并且业务机会类型时JApan时，并且字段Allow_new_process_for_Japan_picklist__c 为Not Allow时 返回普通的合同类型
                          /**
                            else if((opp.Allow_new_process_for_Japan_picklist__c == 'Not allow'|| opp.Allow_new_process_for_Japan_picklist__c == 'pending') && opp.Region__c == 'North Asia' && opp.RecordType.Name == 'Japan' &&
                                (opp.SELLER__c == 'ジンコソーラージャパン株式会社' || opp.SELLER__c == 'Jinko Solar Co., Ltd.' || opp.SELLER__c == 'ZHEJIANG JINKO SOLAR CO.,LTD')){
                                // Japan 1MW
                                   system.debug('-------- Japan1MWRecordTypeId' + Japan1MWRecordTypeId);
                                    return InventoryRecordTypeId;
                            }
                         */
                        }
                    }
             }
        } 
        
   //     system.debug('---- 普通流程' + opp.RecordType.Name );
  //      system.debug('---- 普通流程' +opp.Payment_Term_Description__c );
//        system.debug('---- 普通流程' + opp.Allow_new_process_for_Japan_picklist__c);
//        system.debug('---- 普通流程'  + opp.Region__c );
//        system.debug('---- 普通流程'  + opp.Payment_1MW_Approve__c);
//        system.debug('---- 普通流程'  + opp.Special_Terms__c );
//        system.debug('---- 普通流程'  + opp.Total_MW__c );
 //       system.debug('---- 普通流程'  + opp.whether_pick_up_batch__c );
 //       system.debug('---- 普通流程'  +  opp.Trade_term__c );
  //      system.debug('---- 普通流程'  + opp.SELLER__c);
//        system.debug('---- 普通流程'  + opp.Total_Quantity__c);
   //     system.debug('---- 普通流程'  + opp.Payment_Term_Description__c);
   //     system.debug('-------- InventoryRecordTypeId ' + InventoryRecordTypeId);
	if(opp.RecordType.Name == 'USA'){
        return InventoryUSARecordTypeId;
    }
        return InventoryRecordTypeId;
        
}
    
    //end
    /**
    *	设置银行信息 
    */
	public static ID setBankInfo(Contract c,Map<string,BackInfo__c> BackInfoMap){
		ID bankInfoId = null;
		String shortName = null;
        system.debug('在这里');
        system.debug('在这里c'+c);
        system.debug('在这里c'+c.seller__c);
        system.debug('在这里c'+c.CurrencyIsoCode);
		if(c.SELLER__c == 'ジンコソーラージャパン株式会社'){
			if(c.CurrencyIsoCode == 'USD'){
				 shortName = '三井晶科日本美元账户';	
			}else if(c.CurrencyIsoCode == 'JPY'){
				 shortName = '三井晶科日本日元账户';		
			
			}
		//晶科瑞士
		}
        else if(c.SELLER__c == 'Jinkosolar Middle East DMCC'){
            if(c.CurrencyIsoCode == 'EUR'){
				 shortName = '晶科迪拜汇丰银行欧元';		
			}else if(c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科迪拜汇丰银行美金';		
			}
            else if(c.CurrencyIsoCode == 'AUD'){
				 shortName = '晶科迪拜汇丰银行澳元';		
			}
            else if(c.CurrencyIsoCode == 'GBP'){
				 shortName = '晶科迪拜汇丰银行英镑';		
			}
            else if(c.CurrencyIsoCode == 'JPG'){
				 shortName = '晶科迪拜花旗银行日币';		
			}
             else if(c.CurrencyIsoCode == 'CNY'){
				 shortName = '晶科迪拜花旗银行人民币';		
			}
            }
        else if(c.SELLER__c == 'JinkoSolar (Switzerland) AG'){
			if(c.CurrencyIsoCode == 'EUR'){
				 shortName = '晶科瑞士瑞信银行欧元';		
			}else if(c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科瑞士瑞信银行美元';		
			}
            else if(c.CurrencyIsoCode == 'GBP'){
				 shortName = '晶科瑞士瑞信银行马克';		
			}
		//晶科丹麦花旗银行户
		}
        else if(c.SELLER__c == 'Jinko Solar Denmark Aps'){
			if(c.CurrencyIsoCode == 'EUR'){
				 shortName = '晶科丹麦花旗银行欧元';		
			}else if(c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科丹麦花旗银行美元';		
			}
		//晶科印度户
		}
        else if(c.SELLER__c=='JINKOSOLAR TRADING PRIVATE LIMITED')
        {
            if(c.CurrencyIsoCode =='INR')
            {
                shortName ='印度晶科花旗卢比户';
            }
            //晶科澳大利亚
        } 
        else if(c.SELLER__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
            if(c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科澳大利亚中行美元';		
			}else if(c.CurrencyIsoCode == 'AUD'){
				 shortName = '晶科澳洲NAB澳元';		
			}
            /*  原来的取值
			if(c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科澳大利亚中行美元';		
			}else if(c.CurrencyIsoCode == 'AUD'){
				 shortName = '晶科澳洲NAB澳元';		
			}
			*/
		//晶科德国
		}
        else if(c.SELLER__c == 'JinkoSolar GmbH'){
			if(c.CurrencyIsoCode == 'EUR'){
				 shortName = '晶科德国欧元';		
			}
            if(c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科德国美元';		
			}

			
		}
        else if(c.SELLER__c =='JINKO SOLAR（CHUZHOU）CO.,LTD.'){
            if(c.CurrencyIsoCode == 'EUR'){
				 shortName = '滁州晶科建设银行欧元';		
			}
            if(c.CurrencyIsoCode == 'USD'){
				 shortName = '滁州晶科建设银行美元';		
			}
        }
        else{
                    system.debug('在这里d');
			//BankInfo自动赋值
			if(c.SELLER__c == 'JINKO SOLAR (U.S.) INDUSTRIES INC.' && c.CurrencyIsoCode == 'USD'){
                system.debug('在这里sa');
				 shortName = '晶科美国工厂美元';		
			}if(c.SELLER__c != null && c.SELLER__c == 'Jinkosolar Technology Limited' && c.CurrencyIsoCode == 'USD'){
				 shortName = '科技汇丰美元';		
			}if(c.SELLER__c != null && c.SELLER__c == 'Jinkosolar Technology Limited' && c.CurrencyIsoCode == 'EUR'){
				 shortName = '科技汇丰欧元';		
			}
            if(c.SELLER__c != null && c.SELLER__c == 'Jinkosolar Technology Limited' && c.CurrencyIsoCode == 'AUD'){
				 shortName = '科技花旗澳元';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA' && c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科葡萄牙BCP美元户';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA' && c.CurrencyIsoCode == 'EUR'){
				 shortName = '晶科葡萄牙BCP欧元户';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA' && c.CurrencyIsoCode == 'GBP'){
				 shortName = '晶科葡萄牙BCP英镑户';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'JinkoSolar (U.S.) Inc' && c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科美国美元';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'JINKOSOLAR (PTY) LTD' && c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科南非美元';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'JINKOSOLAR (PTY) LTD' && c.CurrencyIsoCode == 'EUR'){
			
				 shortName = '晶科南非欧元';		
			}
			if(c.SELLER__c != null && c.SELLER__c == 'JINKOSOLAR (PTY) LTD' && c.CurrencyIsoCode == 'ZAR'){
			
				 shortName = '晶科南非兰特';		
			}
            /**
			if(c.SELLER__c != null && c.SELLER__c == 'Jinkosolar Technology Limited' && c.CurrencyIsoCode == 'USD'){
			
				 shortName = '浦发晶科科技美元';		
			}	
*/
			if(c.SELLER__c != null && c.SELLER__c == 'JinkoSolar Canada Co., Ltd.' && c.CurrencyIsoCode == 'CAD'){
				 shortName = '晶科加拿大加元';		
			}
			
			if(c.SELLER__c != null && c.SELLER__c == 'JinkoSolar Canada Co., Ltd.' && c.CurrencyIsoCode == 'USD'){
				 shortName = '晶科加拿大美元';		
			}
		}
        system.debug('shortName********'+shortName);
		if(BackInfoMap.containsKey(shortName)){
			bankInfoId = BackInfoMap.get(shortName).Id;
		}
    	return bankInfoId;
    }
    
	/*
	* Trade term / Seller 有变化即需要变动Record Type
	*
	*/
	
	public static Boolean contractChanged(Contract con_new,Contract con_old){

		// Trade term / Seller 有变化即需要变动Record Type
		return (con_new.Trade_term__c != con_old.Trade_term__c || con_new.SELLER__c != con_old.SELLER__c || con_new.Total_Quantity__c != con_old.Total_Quantity__c);
	}
	
	/*
	* Trade term / Warranty On Material / Sinosure Confirmed / Seller 有变化即需变更模版
	*
	*/
	
	public static Boolean contractChanged2(Contract con_new,Contract con_old){
		
		return (con_new.Trade_term__c != con_old.Trade_term__c || con_new.SELLER__c != con_old.SELLER__c || con_new.IS_GTAC_Formula__c != con_old.IS_GTAC_Formula__c || con_new.Warranty_On_Material_and_Workmanship__c != con_old.Warranty_On_Material_and_Workmanship__c || con_new.GTAC_No__c != con_old.GTAC_No__c || con_new.Sinosure_Confirmed__c != con_old.Sinosure_Confirmed__c || con_new.Payment_Term_Description__c != con_old.Payment_Term_Description__c);
	}
	
	/*
	* Trade term / Warranty On Material / Sinosure Confirmed / Seller 有变化即需变更模版  条件1
	*
	*/
	
	public static void contractChangedRemarks(Contract con_new){
		
		RemarkExchangeUtils tools = new RemarkExchangeUtils();
		if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - DDP + Standard + Sino  
           tools.GTAC_DDP_Standard_Sino(con_new);
        }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - DDP + Linear + Sino
            tools.GTAC_DDP_Linear_Sino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - EXW + Standard + Sino
            tools.GTAC_EXW_Standard_Sino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - EXW + Linear + Sino
            tools.GTAC_EXW_Linear_Sino(con_new);
        }
        
        // No Sinosure
        if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - DDP + Standard + Not Sino
            tools.GTAC_DDP_Standard_NoSino(con_new);
        }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - DDP + Linear + Not Sino
            tools.GTAC_DDP_Linear_NoSino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - EXW + Standard + Not Sino
            tools.GTAC_EXW_Standard_NoSino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - EXW + Linear + Not Sino
            tools.GTAC_EXW_Linear_NoSino(con_new);
        }
	}
	/*
	* Trade term / Warranty On Material / Sinosure Confirmed / Seller 有变化即需变更模版  条件2
	*
	*/
	
	public static void contractChangedRemarks2(Contract con_new){
		
		RemarkExchangeUtils tools = new RemarkExchangeUtils();
	                                    
        // Sinosure
        if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - DDP + Standard + Sino
            tools.DDP_Standard_Sino(con_new);
        }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - DDP + Linear + Sino
            tools.DDP_Linear_Sino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - EXW + Standard + Sino
            tools.EXW_Standard_Sino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && con_new.Sinosure_Confirmed__c == 'True'){
            // 条件 - EXW + Linear + Sino
            tools.EXW_Linear_Sino(con_new);
        }
        
        // No Sinosure
        if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - DDP + Standard + Not Sino
            tools.DDP_Standard_NoSino(con_new);
        }else if(con_new.Trade_term__c == 'DDP' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - DDP + Linear + Not Sino
            tools.DDP_Linear_NoSino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 standard warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - EXW + Standard + Not Sino
            tools.EXW_Standard_NoSino(con_new);
        }else if(con_new.Trade_term__c == 'EXW' && con_new.Warranty_On_Material_and_Workmanship__c == '10 linear warranty' && (con_new.Sinosure_Confirmed__c == 'False'|| con_new.Sinosure_Confirmed__c == null)){
            // 条件 - EXW + Linear + Not Sino
            tools.EXW_Linear_NoSino(con_new);
        }
	}
	
}