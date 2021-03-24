global class SapAsyncToMDAPickList {
   @Future(callout=true)
    webservice static void SendOrderNo(String MDANumber){
        try{
        List<Component_Task_Book__c> Ctb =[SELECT Id,Name,
                                           adderr__c,Additional_Certificate__c,Additional_Certificate_other__c,Additional_Certificate_Text__c,Additional_power__c,
                                           Additional_power_Text__c,	
                                           Barcode_encoding_principle__c,
                                           BMO_SH__c,
                                           BOM__c,
                                           BOM_Fixed_Text__c,
                                           BOM_Material_Fixed_Text__c,
                                           Cell__c,
                                           Cell_Quantity1__c,
                                           Cell_Quantity1_Text__c,
                                           Cell_Quantity2__c,
                                           Cell_Quantity2_Text__c,
                                           Cell_Quantity3__c,
                                           Cell_Quantity3_Text__c,
                                           Cell_Type1__c,
                                           Cell_Type1_Text__c,
                                           Cell_Type2__c,
                                           Cell_Type2_Text__c,
                                           Cell_Type3__c,
                                           Cell_Type3_Text__c,
                                           Client_Name__c,
                                           Client_Name_and_Order_Quantities__c,
                                           Color_Sorting_style__c,
                                           Comments1__c,
                                           Comments2__c,
                                           Comments3__c,
                                           Current_Sorting__c,
                                           Current_Sorting_Style__c,
                                           Current_Sorting_Style_Text__c,
                                           Current_Sorting_Text__c,
                                           Designer__c,
                                           Designing_dead_line__c,
                                           Deviation_sheet__c,
                                           Director_Signature__c,
                                           EVA__c,
                                           EVA_Text__c,
                                           Frame__c,
                                           Front_Glass__c,
                                           Front_Glass_Text__c,
                                           IsBecomeConMDA__c,
                                           Junction_Box_brand__c,
                                           Junction_Box_brand_Text__c,
                                           Junction_Box_Cable_Length__c,
                                           Junction_Box_Cable_Length_Text__c,
                                           Junction_Box_Connector__c,
                                           Junction_Box_Connector_Text__c,
                                           Lab_tests__c,
                                           LRF__c,
                                           ModuleType1__c,
                                           Module_Type2__c,
                                           Module_Type3__c,
                                           ModuleType1__r.Name,
                                           Module_Type2__r.Name,
                                           Module_Type3__r.Name,                                       
                                           Nameplate__c,
                                           Note__c,
                                           On_line_Audit__c,
                                           Opportunity__c,
                                           OpportunityAccName__c,
                                           Order__c,
                                           Order_Quantities__c,
                                           Package__c,
                                           Package_Text__c	,
                                           PCS1__c,
                                           PCS2__c,
                                           PCS3__c,
                                           pdIds__c,
                                           Power_Tolerance__c	,
                                           Power_Tolerance_Text__c,
                                           Pre_shipping_Inspection_by_Client__c,
                                           Pre_shipping_Inspection_by_Client_Text__c,
                                           Pre_shipping_Inspection_factory__c,	
                                           Product_Certificate__c,	
                                           Product_Certificate_Text__c,
                                           On_site_monitor_by_Client_text__c,	
                                           On_site_monitor_by_Client_or_3rd_party__c,	
                                           Rear_cover__c,	
                                           Rear_cover_Text__c,	
                                           Regional_customs_clearance_request__c,	
                                           Regional_Mandatory_Certification_List_T__c,	
                                           Mandatory_certification__c,	
                                           Sales_director_opinions__c,	
                                           Sales_representative__c,
                                           Shipping_Mark__c,
                                           Signature__c,
                                           Special_Approval_for_order_production__c,	
                                           System_Voltage__c,	
                                           System_Voltage_Text__c,	
                                           Technical_manager_Shanghai__c,	
                                           Technical_manager_Shanghai_Comments__c,	
                                           Technical_manager_assigns_tasks__c,	
                                           The_current_classification_standard__c,	
                                           Total__c,	
                                           Transportation_style__c,
                                           Transportation_style_Text__c,	
                                           Virtual_Product_Account__c,	
                                           Warranty__c,
                                           Contract__c,
                                           Contract__r.Contract_NO__c,
                                           Project_Type_Text__c,
                                           Project_Type__c,
                                           Planning_Note__c,
                                           Module_Series1__c,
                                           Module_Category1_Text__c,
                                           Module_Series2__c,
                                           Module_Category2_Text__c,
                                           Module_Series3__c,
                                           Module_Category3_Text__c
                                           FROM Component_Task_Book__c 
                                           WHERE Name = :MDANumber];
        
        jinkosolarComEccGetMda.T_CRMDATA_element MDAV = new jinkosolarComEccGetMda.T_CRMDATA_element();
        system.debug(Ctb.size());
        MDAV.ZCRMID = Ctb[0].Id;
        MDAV.ZBX1 = Ctb[0].ModuleType1__r.Name;
        MDAV.ZBXSL1 = String.valueOf(Ctb[0].PCS1__c);
        MDAV.ZDCSL1 = Cell_Quantity1Value(Ctb[0].Cell_Quantity1__c);
        MDAV.ZDCSL1T = String.valueOf(Ctb[0].Cell_Quantity1_Text__c);
        MDAV.ZBX2 = Ctb[0].Module_Type2__r.Name;
        MDAV.ZBXSL2 = String.valueOf(Ctb[0].PCS2__c);
        MDAV.ZDCSL2 = Cell_Quantity2Value(Ctb[0].Cell_Quantity2__c);
        MDAV.ZDCSL2T = String.valueOf(Ctb[0].Cell_Quantity2_Text__c);
        MDAV.ZBX3 = Ctb[0].Module_Type3__r.Name;
        MDAV.ZBXSL3 = String.valueOf(Ctb[0].PCS3__c);
        MDAV.ZDCSL3 = Cell_Quantity3Value(Ctb[0].Cell_Quantity3__c);
        MDAV.ZDCSL3T = String.valueOf(Ctb[0].Cell_Quantity3_Text__c);
        MDAV.ZDCZL1 = Cell_Type1Value(Ctb[0].Cell_Type1__c);                                                                                                                      
        MDAV.ZDCZL1T = Ctb[0].Cell_Type1_Text__c;
        MDAV.ZDCZL2 = Cell_Type2Value(Ctb[0].Cell_Type2__c);
        MDAV.ZDCZL2T = Ctb[0].Cell_Type2_Text__c;
        MDAV.ZDCZL3 = Cell_Type3Value(Ctb[0].Cell_Type3__c);
        MDAV.ZDCZL3T = Ctb[0].Cell_Type3_Text__c;
        MDAV.ZCPHGZ = Product_CertificateValue(Ctb[0].Product_Certificate__c);
        System.debug('MDAV.ZCPHGZ---------------'+MDAV.ZCPHGZ);
        MDAV.ZFJZS = Additional_CertificateValue(Ctb[0].Additional_Certificate__c);
        MDAV.ZQYQZXRZ = Mandatory_certificationValue(Ctb[0].Mandatory_certification__c);
        MDAV.ZZB = WarrantyValue(Ctb[0].Warranty__c);
        MDAV.ZGLRX = Power_ToleranceValue(Ctb[0].Power_Tolerance__c);
        MDAV.ZXTDY = System_VoltageValue(Ctb[0].System_Voltage__c);
        MDAV.ZFJGL = Additional_powerValue(Ctb[0].Additional_power__c);
        MDAV.ZCNOQ = Ctb[0].Client_Name_and_Order_Quantities__c;
        MDAV.ZMKRWSJS = Ctb[0].Name;
        MDAV.ZCPZST = Ctb[0].Product_Certificate_Text__c;
        MDAV.ZFJZST = Ctb[0].Additional_Certificate_Text__c;
        MDAV.ZQYQZXRZT = Ctb[0].Regional_Mandatory_Certification_List_T__c;
        MDAV.ZGLRXT = Ctb[0].Power_Tolerance_Text__c;
        MDAV.ZXTDYT = Ctb[0].System_Voltage_Text__c;
        MDAV.ZFJGLT = String.valueOf(Ctb[0].Additional_power_Text__c);
        MDAV.ZWLQD = BOMValue(Ctb[0].BOM__c);
        MDAV.ZDCSY = CellValue(Ctb[0].Cell__c);
        MDAV.ZJXHPP = Junction_Box_brandValue(Ctb[0].Junction_Box_brand__c);
        MDAV.ZJXHDLCD = Junction_Box_Cable_LengthValue(Ctb[0].Junction_Box_Cable_Length__c);
        MDAV.ZJXHJT = Junction_Box_ConnectorValue(Ctb[0].Junction_Box_Connector__c);
        MDAV.ZBB = Rear_coverValue(Ctb[0].Rear_cover__c);
        MDAV.ZEVA = EVAValue(Ctb[0].EVA__c);
        MDAV.ZLRF = LRFValue(Ctb[0].LRF__c);
        MDAV.ZZJ = FrameValue(Ctb[0].Frame__c);
        MDAV.ZBL = Front_GlassValue(Ctb[0].Front_Glass__c);
        MDAV.ZBZ = PackageValue(Ctb[0].Package__c);
        MDAV.ZYSBZ = Shipping_MarkValue(Ctb[0].Shipping_Mark__c);
        MDAV.ZTMBMYL = Barcode_encoding_principleValue(Ctb[0].Barcode_encoding_principle__c);
        MDAV.ZMP = NameplateValue(Ctb[0].Nameplate__c);
        MDAV.ZCPLX = Project_TypeValue(Ctb[0].Project_Type__c);
        MDAV.ZWLQDT = Ctb[0].BOM_Fixed_Text__c;
        MDAV.ZWLQDCLT = Ctb[0].BOM_Material_Fixed_Text__c;
        MDAV.ZJXHPPT = Ctb[0].Junction_Box_brand_Text__c;
        MDAV.ZJXHDLCDT = Ctb[0].Junction_Box_Cable_Length_Text__c;
        MDAV.ZJXHJTT = Ctb[0].Junction_Box_Connector_Text__c;
        MDAV.ZBBT = Ctb[0].Rear_cover_Text__c;
        MDAV.ZBLT = Ctb[0].Front_Glass_Text__c;
        MDAV.ZEVAT = Ctb[0].EVA_Text__c;
        MDAV.ZBZT = Ctb[0].Package_Text__c;
        MDAV.ZCPLXT = Ctb[0].Project_Type_Text__c;
        MDAV.ZDQPX = Current_SortingValue(Ctb[0].Current_Sorting__c);
        MDAV.ZDQPXYS = Current_Sorting_StyleValue(Ctb[0].Current_Sorting_Style__c);
        MDAV.ZYSPXYS = Color_Sorting_styleValue(Ctb[0].Color_Sorting_style__c);
        MDAV.ZYSFS = Transportation_styleValue(Ctb[0].Transportation_style__c);
	    MDAV.ZSCJD = On_site_monitor_by_Client_or_3rd_partyValue(Ctb[0].On_site_monitor_by_Client_or_3rd_party__c);
        MDAV.ZSYSCS = Lab_testsValue(Ctb[0].Lab_tests__c);
        MDAV.ZZYQJYC = Pre_shipping_Inspection_factoryValue(Ctb[0].Pre_shipping_Inspection_factory__c);
        MDAV.ZDDSCZXSP = Special_Approval_for_order_productionValue(Ctb[0].Special_Approval_for_order_production__c);
        MDAV.ZBZHU = Ctb[0].Note__c;
        MDAV.ZSYSCST = Ctb[0].On_site_monitor_by_Client_text__c;
        MDAV.ZQYTGSQ = Regional_customs_clearance_requestValue(Ctb[0].Regional_customs_clearance_request__c);
        MDAV.ZDQPXT = Ctb[0].Current_Sorting_Style_Text__c;
        MDAV.ZDQPXYST = Ctb[0].Current_Sorting_Text__c;
        MDAV.ZGHSM = Ctb[0].Planning_Note__c;
        MDAV.BSTKD = Ctb[0].Contract__r.Contract_NO__c;
        MDAV.ZOPID = Ctb[0].Opportunity__c;
        MDAV.VBELN  = Ctb[0].Order__c;
		MDAV.ZMS1 = Module_Series1Value(Ctb[0].Module_Series1__c);
		MDAV.ZMS1T = Ctb[0].Module_Category1_Text__c;
		MDAV.ZMS2 = Module_Series2Value(Ctb[0].Module_Series2__c);
		MDAV.ZMS2T = Ctb[0].Module_Category2_Text__c;
		MDAV.ZMS3 = Module_Series3Value(Ctb[0].Module_Series3__c);
		MDAV.ZMS3T = Ctb[0].Module_Category3_Text__c;
       
        jinkosolarComEccGetMda.DT_GetMDA_Request Req = new jinkosolarComEccGetMda.DT_GetMDA_Request();
        Req.T_CRMDATA = new jinkosolarComEccGetMda.T_CRMDATA_element[0];
        Req.T_CRMDATA.add(MDAV);
         
        jinkosolarComEccGetMda.DT_GetMDA_Response result = new jinkosolarComEccGetMda.DT_GetMDA_Response();
        jinkosolarComCrmGetMda.HTTPS_Port HttpPort = new jinkosolarComCrmGetMda.HTTPS_Port();
        result=HttpPort.SI_CRM2ECC_GetMDA_Out(Req.T_CRMDATA);
        system.debug('result1------'+result);
       }catch (Exception e){
           
        }
        
        //    return result.E_MSGTXT;
    }
    
    //Module_Series1__c ZMS1
     public static Map<String,String> Module_Series1Value_Map = new Map<String,String>{
        	'Eagle series（156 / 157mm）'       =>'001',
            'Cheetah series（158 / 159mm）'  =>'002',
            'Swan series (158 bifacial)'    =>'003',  
            'Tiger series (163 TR)'      =>'004',
            'Smart series'       =>'005',
            'Other'       =>'999'
			};
  
      public static String Module_Series1Value(String Module_Series1){
             return Module_Series1Value_Map.get(Module_Series1);
      }
    
    //Module_Series2__c ZMS2
     public static Map<String,String> Module_Series2Value_Map = new Map<String,String>{
        	'Eagle series（156 / 157mm）'       =>'001',
            'Cheetah series（158 / 159mm）'  =>'002',
            'Swan series (158 bifacial)'    =>'003',  
            'Tiger series (163 TR)'      =>'004',
            'Smart series'       =>'005',
            'Other'       =>'999'
			};
  
      public static String Module_Series2Value(String Module_Series2){
             return Module_Series2Value_Map.get(Module_Series2);
      }
    
    //Module_Series3__c ZMS3
     public static Map<String,String> Module_Series3Value_Map = new Map<String,String>{
        	'Eagle series（156 / 157mm）'       =>'001',
            'Cheetah series（158 / 159mm）'  =>'002',
            'Swan series (158 bifacial)'    =>'003',  
            'Tiger series (163 TR)'      =>'004',
            'Smart series'       =>'005',
            'Other'       =>'999'
			};
  
      public static String Module_Series3Value(String Module_Series3){
             return Module_Series3Value_Map.get(Module_Series3);
      }
    
    
    
    //Cell_Quantity1__c ZDCSL1   A
    public static Map<String,String> Cell_Quantity1Value_Map = new Map<String,String>{
        	'60'       =>'001',
            '120'  =>'002',
            '144'    =>'003',
            'Other'       =>'999',
            '72'      =>'004',
            '78'       =>'005',
            '156'    =>'006'
			};
  
                public static String Cell_Quantity1Value(String Cell_Quantity1){
                    return Cell_Quantity1Value_Map.get(Cell_Quantity1);
                }
    
    //Cell_Quantity2__c ZDCSL2     A
    public static Map<String,String> Cell_Quantity2Value_Map = new Map<String,String>{
        	'60'       =>'001',
            '120'  =>'002',
            '144'    =>'003',
            'Other'       =>'999',
            '72'      =>'004',
            '78'       =>'005',
            '156'    =>'006'
			};
                public static String Cell_Quantity2Value(String Cell_Quantity2){
                    return Cell_Quantity2Value_Map.get(Cell_Quantity2);
                }
    
    //Cell_Quantity3__c ZDCSL3    A
    public static Map<String,String> Cell_Quantity3Value_Map = new Map<String,String>{
        	'60'       =>'001',
            '120'  =>'002',
            '144'    =>'003',
            'Other'       =>'999',
            '72'      =>'004',
            '78'       =>'005',
            '156'    =>'006'
			};
                public static String Cell_Quantity3Value(String Cell_Quantity3){
                    return Cell_Quantity3Value_Map.get(Cell_Quantity3);
                }
    
    //Project_Type__c  ZCPLX
    public static Map<String,String> Project_TypeValue_Map = new Map<String,String>{
        	'Utility'       =>'001',
            'Distributed Generation'  =>'002',           
            'Others'       =>'999'                
			};
                public static String Project_TypeValue(String Project_Type){
                    return Project_TypeValue_Map.get(Project_Type);
                }

	//Cell_Type3__c ZDCZL3    A
     public static Map<String,String> Cell_Type3Value_Map = new Map<String,String>{
        	'P-type Perc'       =>'001',
            'N-type Pert'  =>'002',
            'Std. Mono'       =>'005',
            'Std. Poly'  =>'006',
            'Other'       =>'999'
 
			};
                

                public static String Cell_Type3Value(String Cell_Type3){
                    return Cell_Type3Value_Map.get(Cell_Type3);
                }
    //Cell_Type2__c ZDCZL2   A
    public static Map<String,String> Cell_Type2Value_Map = new Map<String,String>{
        	'P-type Perc'       =>'001',
            'N-type Pert'  =>'002',
            'Std. Mono'       =>'005',
            'Std. Poly'  =>'006',
            'Other'       =>'999'
 
			};
                public static String Cell_Type2Value(String Cell_Type2){
                    return Cell_Type2Value_Map.get(Cell_Type2);
                }
    //Cell_Type1__c   ZDCZL1    A
    public static Map<String,String> Cell_Type1Value_Map = new Map<String,String>{
        	'P-type Perc'       =>'001',
            'N-type Pert'  =>'002',
            'Std. Mono'       =>'005',
            'Std. Poly'  =>'006',
            'Other'       =>'999'
 
			};
                public static String Cell_Type1Value(String Cell_Type1){
                    return Cell_Type1Value_Map.get(Cell_Type1);
                }
    
    
    
    //On_site_monitor_by_Client_or_3rd_party__c   ZSCJD
     public static Map<String,String> On_site_monitor_by_Client_or_3rd_partyValue_Map = new Map<String,String>{
        	'No Need'       =>'888',
            'Yes, Consignee'  =>'001'
			};
                public static String On_site_monitor_by_Client_or_3rd_partyValue(String On_site_monitor_by_Client_or_3rd_party){
                    return On_site_monitor_by_Client_or_3rd_partyValue_Map.get(On_site_monitor_by_Client_or_3rd_party);
                }
    
   	//Transportation_style__c  ZYSFS    A
   	 public static Map<String,String> Transportation_styleValue_Map = new Map<String,String>{
        	'Air'       =>'001',
            'Sea'  =>'002',
            'Railway'         =>'003',
			'Express delivery'       =>'004',
            'Land'               =>'005'
			};
                public static String Transportation_styleValue(String Transportation_style){
                    return Transportation_styleValue_Map.get(Transportation_style);
                }
    
    //Color_Sorting_style__c    ZYSPXYS
    public static Map<String,String> Color_Sorting_styleValue_Map = new Map<String,String>{
        	'Yes, Mixed color sorting allowed for the balance modules'       =>'001',
            'Yes, Mixed color sorting allowed for the balance modules of every 7MW'  =>'002',
            'Not acceptable'         =>'003',
			'No Need'       =>'888'           
            };
                public static String Color_Sorting_styleValue(String Color_Sorting_style){
                    return Color_Sorting_styleValue_Map.get(Color_Sorting_style);
                }
    
    
    //Current_Sorting_Style__c   ZDQPXYS
			public static Map<String,String> Current_Sorting_StyleValue_Map = new Map<String,String>{
        	'Yes, Mixed current sorting allowed for the balance modules'       =>'001',
            'Yes, Mixed current sorting allowed for the balance modules of every 7MW'  =>'002',
            'Not acceptable'         =>'003',
			'No Need'       =>'888'           
            };
                public static String Current_Sorting_StyleValue(String Current_Sorting_Style){
                    return Current_Sorting_StyleValue_Map.get(Current_Sorting_Style);
                }
    
    
    //ZDQPX Current_Sorting__c
public static Map<String,String> Current_SortingValue_Map = new Map<String,String>{
        	'No Need'       =>'888',
            'Jinko Standard'  =>'001',
            'Customer Standard'         =>'002'
           
            };
                public static String Current_SortingValue(String Current_Sorting){
                    return Current_SortingValue_Map.get(Current_Sorting);
                }
    
    //Product_Certificate__c   A
    public static Map<String,String> Product_CertificateValue_Map = new Map<String,String>{
        	'IEC61215: 2005 (TUV certified)'       =>'001',
            'IEC61215:2016 (TUV certified)'  =>'002',
            'UL(UL certified)'         =>'003',
            'Dual IEC61215 & UL'              =>'004',
            'Other'                    =>'999'        
            };
                public static String Product_CertificateValue(String Product_Certificate){
                    return Product_CertificateValue_Map.get(Product_Certificate);
                }
    //Additional_Certificate__c
    public static Map<String,String> Additional_CertificateValue_Map = new Map<String,String>{
        	'PID60&85'                   =>'001',
            'IEC62716(Ammonia)'          =>'002',
            'IEC61701(Salt Mist)'        =>'003',
            'Other'                      =>'999',
            'PID85&85&96'                =>'004',
            'EC60068-2-68(Sand dust)'    =>'005',
            'No need'                    =>'888'  
            };
    public static String Additional_CertificateValue(String Additional_Certificate){
       return Additional_CertificateValue_Map.get(Additional_Certificate);
    }
    //	Mandatory_certification__c    A
     public static Map<String,String> Mandatory_certificationValue_Map = new Map<String,String>{
        	'BIS'          =>'001',
            'Inmetro'      =>'002',
            'RETIE'        =>'003',
            'CEC'          =>'004',
            'KS'           =>'005',
            'No Need'      =>'888',
            'Other'        =>'999',
            'SII'          =>'006',
            'PQP'          =>'007',
            'IECEE'        =>'008'
            };
    public static String Mandatory_certificationValue(String Mandatory_certification){
       return Mandatory_certificationValue_Map.get(Mandatory_certification);
    }
    //Warranty__c
    public static Map<String,String> WarrantyValue_Map = new Map<String,String>{
        	'Standard'          =>'001',
            'Linear'            =>'002',
            'Customized'        =>'003'                 
            };
    public static String WarrantyValue(String Warranty){
       return WarrantyValue_Map.get(Warranty);
    }
	//Power_Tolerance__c
	public static Map<String,String> Power_ToleranceValue_Map = new Map<String,String>{
        	'Each module: 0~+3%'          =>'001',
            'Other'                       =>'999'                          
    };
    public static String Power_ToleranceValue(String Power_Tolerance){
       return Power_ToleranceValue_Map.get(Power_Tolerance);
    }
    //System_Voltage__c
    public static Map<String,String> System_VoltageValue_Map = new Map<String,String>{
        	'1000V'          =>'001',
            '1500V'          =>'002',
            'Other'          =>'999'     
    };
    public static String System_VoltageValue(String System_Voltage){
       return System_VoltageValue_Map.get(System_Voltage);
    }
    //Additional_power__c
    public static Map<String,String> Additional_powerValue_Map = new Map<String,String>{
        	'No'          =>'001',
            'Yes'         =>'002'              
    };
    public static String Additional_powerValue(String Additional_power){
       return Additional_powerValue_Map.get(Additional_power);
    }
    //	BOM__c
    public static Map<String,String> BOMValue_Map = new Map<String,String>{
        	'Standard Certified BOM'          =>'001',
            'Material Fixed'         =>'002',
            'BOM Fixed'         =>'003'
    };
    public static String BOMValue(String BOM){
       return BOMValue_Map.get(BOM);
    }
    //Cell__c
    public static Map<String,String> CellValue_Map = new Map<String,String>{
        	'Acceptable, Mixed cell not allowed in the balance quantity'          =>'001',
            'Acceptable, Mixed cell allowed in the balance quantity'         =>'002',
            'No Acceptance'         =>'003'
    };
    public static String CellValue(String Cell){
       return CellValue_Map.get(Cell);
    }
    //	Junction_Box_brand__c
    public static Map<String,String> Junction_Box_brandValue_Map = new Map<String,String>{
        	'Jinko Integrate' =>'001',
            'Jinko Split'     =>'002',
            'Other'           =>'999'
    };
    public static String Junction_Box_brandValue(String Junction_Box_brand){
       return Junction_Box_brandValue_Map.get(Junction_Box_brand);
    }
    //Junction_Box_Cable_Length   A
	 public static Map<String,String> Junction_Box_Cable_LengthValue_Map = new Map<String,String>{
        	'900mm' =>'001',
            '1000mm'     =>'002',
            '1200mm'           =>'003',
            '1400mm For US' =>'004',
            '1825mm For US'     =>'005',
            '(+) 250mm&(-) 150mm for Dual-glass modules or Swan modules'           =>'006',
            '( + ) 290mm & ( - ) 145mm for HC' =>'007',
            'Other'     =>'999',
            '700mm'    =>'008'    
    };
    public static String Junction_Box_Cable_LengthValue(String Junction_Box_Cable_Length){
       return Junction_Box_Cable_LengthValue_Map.get(Junction_Box_Cable_Length);
    }
    //Junction_Box_Connector__c   A
    public static Map<String,String> Junction_Box_ConnectorValue_Map = new Map<String,String>{
        	'Standard_JK03M' =>'001',
            'MC4_ for specific regions/orders' =>'002',   
            'MC4-EVO2_ for specific regions/orders' =>'003',   
            'Other'     =>'999'
           };
    public static String Junction_Box_ConnectorValue(String Junction_Box_Connector){
       return Junction_Box_ConnectorValue_Map.get(Junction_Box_Connector);
    }
    //Rear_cover__c  A
    public static Map<String,String> Rear_coverValue_Map = new Map<String,String>{
        	'standard white' =>'001',
            'TPT'     =>'002',
            'Other' =>'999',
            'Std. Black'     =>'003',
            'Transparent glass for DV' =>'004',
            'Ceramic grid glass for DV'     =>'005',
            'Transparent backsheet for Bifacial Module' =>'006',
            'Transparent Mesh Backsheet for Bifacial Module'     =>'007',
            'T-based Backsheet'             =>'008'
           };
    public static String Rear_coverValue(String Rear_cover){
       return Rear_coverValue_Map.get(Rear_cover);
    }
    //EVA__c   A
    public static Map<String,String> EVAValue_Map = new Map<String,String>{
        	'Decide by factory' =>'001',
            'Transparent'     =>'002',
            'Other' =>'999',
            'White'     =>'003',
                'encapsulation material for bifacial products'    =>'004'
           };
    public static String EVAValue(String EVA){
       return EVAValue_Map.get(EVA);
    }
    //LRF__c   A
     public static Map<String,String> LRFValue_Map = new Map<String,String>{
        	'Optional _ For DG project (Keep LRF in one order / Keep without LRF in one order)' =>'001',
            'Optional _ For Utility project (Keep LRF in one batch / Keep without LRF in one batch)'     =>'002',
            'Shall not use' =>'003',
            'Shall use'     =>'004'                        
           };
    public static String LRFValue(String LRF){
       return LRFValue_Map.get(LRF);
    }
    //Frame__c
     public static Map<String,String> FrameValue_Map = new Map<String,String>{
        	'Standard Silver' =>'001',
            'Standard Black'     =>'002',
            'US Universal(Nextracker)' =>'003',
            'Customized'     =>'004', 
            'without Frame' =>'005',
            '40mm frame for 60s\' module'     =>'006'               
           };
    public static String FrameValue(String Frame){
       return FrameValue_Map.get(Frame);
    }
    //Front_Glass__c   A
     public static Map<String,String> Front_GlassValue_Map = new Map<String,String>{
        	'ARC-3.2mm for single-glass module' =>'001',
            'ARC-2.5mm for dual-glass module'     =>'002',
            'Other' =>'999'                     
           };
    public static String Front_GlassValue(String Front_Glass){
       return Front_GlassValue_Map.get(Front_Glass);
    }
    //Package__c   A
    public static Map<String,String> PackageValue_Map = new Map<String,String>{
        	'Standard' =>'001',
            'Old: 7-layer flap carton + 26Pcs/pallet for 72s\' modules'     =>'002',
            'Other' =>'999',
            'Old : 7-layer flap carton + 30Pcs/pallet for 60s\' modules' =>'003' ,
            'New: 5-layer wrapping carton+ 27pcs/pallet for 72s\' modules'=>'004',
			'New: 5-layer wrapping carton+ 31pcs/pallet for 60s\' modules'=>'005',
			'Standard packing method for Dual-glass frameless modules'=>'006' 
           };
               
              

               
    public static String PackageValue(String Package1){
       return PackageValue_Map.get(Package1);
    }
    //Shipping_Mark__c
    public static Map<String,String> Shipping_MarkValue_Map = new Map<String,String>{
        	'Jinko Standard' =>'001',
            'Customer Standard'     =>'002',
            'Jinko Solar' =>'003'          
           };
    public static String Shipping_MarkValue(String Shipping_Mark){
       return Shipping_MarkValue_Map.get(Shipping_Mark);
    }
    //Barcode_encoding_principle__c
    public static Map<String,String> Barcode_encoding_principleValue_Map = new Map<String,String>{
        	'Standard' =>'001',
            'Customized'     =>'002'                 
           };
    public static String Barcode_encoding_principleValue(String Barcode_encoding_principle){
       return Barcode_encoding_principleValue_Map.get(Barcode_encoding_principle);
    }
    //Nameplate__c
    public static Map<String,String> NameplateValue_Map = new Map<String,String>{
        	'Standard' 		 =>'001',
            'Customized'     =>'002'                 
           };
    public static String NameplateValue(String Nameplate){
       return NameplateValue_Map.get(Nameplate);
    }
    //Lab_tests__c
    public static Map<String,String> Lab_testsValue_Map = new Map<String,String>{
        	'No Need' 		 =>'888',
            'Jinko laboratory'     =>'001',
			'3rd Party lab'     =>'002'
           };
    public static String Lab_testsValue(String Lab_tests){
       return Lab_testsValue_Map.get(Lab_tests);
    }
    //Pre_shipping_Inspection_factory__c
    public static Map<String,String> Pre_shipping_Inspection_factoryValue_Map = new Map<String,String>{
        	'No Need' 		 =>'888',
            'Need'     =>'001'			
           };
    public static String Pre_shipping_Inspection_factoryValue(String Pre_shipping_Inspection_factory){
       return Pre_shipping_Inspection_factoryValue_Map.get(Pre_shipping_Inspection_factory);
    }
    //	Special_Approval_for_order_production__c
    public static Map<String,String> Special_Approval_for_order_productionValue_Map = new Map<String,String>{
        	'Yes' 		 =>'001',
            'No'     =>'002'			
           };
    public static String Special_Approval_for_order_productionValue(String Special_Approval_for_order_production){
       return Special_Approval_for_order_productionValue_Map.get(Special_Approval_for_order_production);
    }
    //Regional_customs_clearance_request__c
    public static Map<String,String> Regional_customs_clearance_requestValue_Map = new Map<String,String>{
        	'No Need' 		 =>'888',
            'COC'     =>'002',
            'COC+PSI'     =>'003'    
           };
    public static String Regional_customs_clearance_requestValue(String Regional_customs_clearance_request){
       return Regional_customs_clearance_requestValue_Map.get(Regional_customs_clearance_request);
    }

}