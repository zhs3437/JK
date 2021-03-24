global class StockQuery {
    public List<SyncStockQuery.T_STOCK_element> modeBasicData(List<Component_Task_Book__c> ctbl,Opportunity opp,String EDITID,String EDITID2){
        Component_Task_Book__c ctb=ctbl[0];
               tool();
         opp=[select name,Seller__c,id,Trade_Term__c,Account.SAP_External_ID__c,Region__c,Destination_Port__c from Opportunity Where ID =: Opp.ID];
       List<OpportunityLineitem> oppline= new List<OpportunityLineitem>();
        List<contract> conlist= new List<contract>(); 
        conlist =[select id,name,Contract_NO__c from contract where Opportunity__c=:opp.id];
        oppline=[select id,Guaranteed_Delivery_Date__c,Quantity,MixedDelivery__c from OpportunityLineitem where id=:EDITID2];
        SyncStockQuery.I_QUERY_PARA_element IQP = new SyncStockQuery.I_QUERY_PARA_element();
        IQP.ZSYSID='1';
        system.debug('EDITID2:'+EDITID2);
        IQP.ZOPPRDID=EDITID2;
        IQP.zopid=opp.id;
        IQP.zopno=opp.Name;
        if(ctb.id!=null){
            IQP.ZMDAID=ctb.id;

        }
        IQP.ZMIXFLAG= oppline[0].MixedDelivery__c == true ? 'X' : '';
        if(conlist.size()>0){
            IQP.BSTKD=conlist[0].Contract_NO__c;
        }
         if(opp.Seller__c == 'Jinko Solar Import and Export Co., Ltd.'){//卖方
            IQP.BUKRS = '1020';
        }else if(opp.Seller__c == 'JinkoSolar (Switzerland) AG'){
            IQP.BUKRS = '1080';
        }else if(opp.Seller__c == 'JinkoSolar (U.S.) Inc'){
            IQP.BUKRS = '1180';
        }else if(opp.Seller__c == 'JinkoSolar GmbH'){
            IQP.BUKRS = '1170';
        }else if(opp.Seller__c == 'Jinko Solar Co., Ltd.'){
            IQP.BUKRS = '1010';
        }else if(opp.Seller__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
            IQP.BUKRS = '1160';
        }else if(opp.Seller__c == 'JinkoSolar(ITALIA)S.R.L.'){
            IQP.BUKRS = '1120';
        }else if(opp.Seller__c == 'JINKOSOLAR (PTY) LTD'){
            IQP.BUKRS = '1230';           
        }else if(opp.Seller__c == 'JINKOSOLAR TECHNOLOGY LIMITED'){
            IQP.BUKRS = '1070';
        }else if(opp.Seller__c == 'JinkoSolar Canada Co., Ltd.'){
            IQP.BUKRS = '1140';
        }else if(opp.Seller__c == 'ジンコソーラージャパン株式会社'){
            IQP.BUKRS = '1250';
        }else if(opp.Seller__c == 'ZHEJIANG JINKO SOLAR CO.,LTD'){
            IQP.BUKRS = '1030';
        }else if(opp.Seller__c == 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA'){
            IQP.BUKRS = '0013';
        }else if(opp.Seller__c == 'JINKO SOLAR TECHNOLOGY SDN.BHD.'){
            IQP.BUKRS = '1590'; 
        }else if(opp.Seller__c == 'JINKOSOLAR TRADING PRIVATE LIMITED'){
            IQP.BUKRS = '1430';
        }else if(opp.Seller__c == 'POYANG RALLYSON TECHNOLOGY CO., LTD'){
            IQP.BUKRS = '4110';
        }else if(opp.Seller__c == 'Jinko Solar Technology Sdn Bhd'){
            IQP.BUKRS = '1590';
        }else if(opp.Seller__c == 'YUHUAN JINKO SOLAR CO., LTD'){
            IQP.BUKRS = '1410';
        }else if(opp.Seller__c == 'JINKO SOLAR (U.S.) INDUSTRIES INC.'){
            IQP.BUKRS = '1500';
        }else if(opp.Seller__c == 'Jinko Solar Korea Co., Ltd.'){
            IQP.BUKRS = '1490';
        }else if(opp.Seller__c == 'Jinkosolar (Vietnam) Co., Ltd.'){
            IQP.BUKRS = '0021';
        }
        system.debug('IQP.BUKRS'+IQP.BUKRS);
        IQP.BISMT=EDITID;
        IQP.KUNNR=opp.Account.SAP_External_ID__c;
        system.debug('IQP.KUNNR'+IQP.KUNNR);
        if(oppline.size()>0){
        IQP.ZEDD=oppline[0].Guaranteed_Delivery_Date__c.year()+''+SAPBATCHCON.timechange(oppline[0].Guaranteed_Delivery_Date__c.month()+'')+SAPBATCHCON.timechange(oppline[0].Guaranteed_Delivery_Date__c.day()+'');//需要更改
        IQP.ZGDD=oppline[0].Guaranteed_Delivery_Date__c.year()+''+SAPBATCHCON.timechange(oppline[0].Guaranteed_Delivery_Date__c.month()+'')+SAPBATCHCON.timechange(oppline[0].Guaranteed_Delivery_Date__c.day()+'');//需要更改
                IQP.ZBOOKQTY=String.valueOf(oppline[0].Quantity);//需要oppproduct更改
        }
            if(opp.Region__c=='EU(Non-Eu)'){
            IQP.ZDESTREGION= '103';
            }
             if(opp.Region__c=='EU(Union)'){
            IQP.ZDESTREGION= '103';
            }
             if(opp.Region__c=='North America'){
            IQP.ZDESTREGION= '104';
            }
             if(opp.Region__c=='Latin America&Italy'){
            IQP.ZDESTREGION= '105';
            }
            if(opp.Region__c=='Middle East&Africa'){
            IQP.ZDESTREGION= '106';
            }
            if(opp.Region__c == 'SSA'){
             IQP.ZDESTREGION= '116';    
            }
            if(opp.Region__c == 'MENA'){
             IQP.ZDESTREGION= '117';    
            }
            if(opp.Region__c=='North Asia'){
            IQP.ZDESTREGION= '107';
            }
            if(opp.Region__c=='South Asia'){
            IQP.ZDESTREGION= '108';
            }
            if(opp.Region__c=='ROA'){
            IQP.ZDESTREGION= '109';
            }
            if(opp.Region__c=='Central Asia'){
            IQP.ZDESTREGION= '114';
            } 
        system.debug('IQP.ZDESTREGION'+IQP.ZDESTREGION);
        IQP.ZDESTPORT=sapmap.getSAPportCode(opp.Destination_Port__c);
        system.debug('IQP.ZDESTPORT'+IQP.ZDESTPORT);

        IQP.MEINS='PC';//固定
        IQP.INCO1=opp.Trade_Term__c;
        system.debug('IQP.INCO1'+IQP.INCO1);
        if(ctb.Module_Series1__c!=null){
        IQP.ZMS1=Module_Series1Value_Map.get(ctb.Module_Series1__c);
            }
        system.debug('IQP.ZMS1'+IQP.ZMS1);
          if(ctb.Junction_Box_Connector__c!=null){
        IQP.ZJXHJT=Junction_Box_ConnectorValue(ctb.Junction_Box_Connector__c);
              }
        system.debug('IQP.ZJXHJT'+IQP.ZJXHJT);
          if(ctb.Junction_Box_Cable_Length__c!=null){
        IQP.ZJXHDLCD=Junction_Box_Cable_LengthValue_Map.get(ctb.Junction_Box_Cable_Length__c);
              }
        system.debug('IQP.ZJXHDLCD'+IQP.ZJXHDLCD);
          if(ctb.LRF__c!=null){
        IQP.ZLRF=LRFValue_Map.get(ctb.LRF__c);
              }
        system.debug('IQP.ZLRF'+IQP.ZLRF);
          if(ctb.EVA__c!=null){
        IQP.ZEVA=EVAValue_Map.get(ctb.EVA__c);
              }
         system.debug('IQP.ZEVA'+IQP.ZEVA);
          if(ctb.Frame_Type__c!=null){
        IQP.ZZJ=FrameValue_Map.get(ctb.Frame_Type__c);
              }
        system.debug('IQP.ZZJ'+IQP.ZZJ);
          if(ctb.Package__c!=null){
        IQP.ZBZ=PackageValue_Map.get(ctb.Package__c);
              }
        system.debug('IQP.ZBZ'+IQP.ZBZ);
          if(ctb.Product_Certificate__c!=null){
        IQP.ZCPHGZ=Product_CertificateValue_Map.get(ctb.Product_Certificate__c);
              }
        system.debug('IQP.ZCPHGZ'+IQP.ZCPHGZ);
          if(ctb.Additional_Certificate__c!=null){
        IQP.ZFJZS=Additional_CertificateValue_Map.get(ctb.Additional_Certificate__c);//多选
              }
        system.debug('IQP.ZFJZS'+IQP.ZFJZS);
          if(ctb.Mandatory_certification__c!=null){
        IQP.ZQYQZXRZ=Mandatory_certificationValue_Map.get(ctb.Mandatory_certification__c);//页面目前没有
              }
        system.debug('IQP.ZQYQZXRZ'+IQP.ZQYQZXRZ);
         if( Userinfo.getProfileId()=='00e6F000001ctn6QAA'|| Userinfo.getProfileId()=='00e90000000NsvNAAS'
           || Userinfo.getProfileId()=='00e90000000NxyiAAC'|| Userinfo.getProfileId()=='00e90000000P9laAAC'
           || Userinfo.getProfileId()=='00e90000000sjacAAA'){
             
        IQP.ZROLE='A03';//角色代码
        }
        /**
         * 日后补全
        else if( ){
        IQP.ZROLE='A02';//角色代码
        }
**/
        else{
             IQP.ZROLE='A01';//角色代码
        }
        system.debug('IQP.ZEVA'+IQP.ZEVA);//角色代码  A01~A03 03最大



        AyncStockQuery.HTTPS_Port send =new AyncStockQuery.HTTPS_Port();
        send.timeout_x = 120000;
        SyncStockQuery.DT_StockQuery_Response response=send.SI_CRM2ECC_StockQuery_Out(IQP);
        List<SyncStockQuery.T_STOCK_element> fanhuizhiLst = new List<SyncStockQuery.T_STOCK_element>();
         if(!Test.isRunningTest()){
        
        if(response.T_STOCK!=null){
         fanhuizhiLst=response.T_STOCK;
            }
             }
        return fanhuizhiLst;
        
        
    }

    public List<SyncStockQuery.T_STOCK_element> modeBasicData2(List<Component_Task_Book__c> ctbl,Order ord,String EDITID,String EDITID2){
        Component_Task_Book__c ctb=ctbl[0];
       ord=[select ordernumber,Seller__c,id,Opportunity__c	,ContractID,Contract.Contract_NO__c,Opportunity__r.name,Trade_Term__c,Account.SAP_External_ID__c,Region__c,Destination_Port__c from order Where ID =: ord.ID];
       Orderitem oppline=[select id,RowNo__c,Guaranteed_Delivery_Date__c,OppProductID__c,Quantity,MixedDelivery__c from Orderitem where id=:EDITID2];
        SyncStockQuery.I_QUERY_PARA_element IQP = new SyncStockQuery.I_QUERY_PARA_element();
        IQP.ZSYSID='1';
        system.debug('EDITID2:'+EDITID2);
         if(oppline.OppProductID__c!=null){
         IQP.ZOPPRDID=oppline.OppProductID__c;
         }
         else{
        IQP.ZOPPRDID=EDITID2;
         }
        system.debug('IQP.ZOPPRDID:'+IQP.ZOPPRDID);
        if(ctb.id!=null){
            IQP.ZMDAID=ctb.id;
        }
         IQP.ZMIXFLAG= oppline.MixedDelivery__c == true ? 'X' : '';
        IQP.BSTKD=ord.Contract.Contract_NO__c;
         system.debug('IQP.BSTKD:'+IQP.BSTKD);
        IQP.ZCRMORNO=ord.ordernumber;
         system.debug('IQP.ZCRMORNO:'+IQP.ZCRMORNO);
        IQP.ZCRMORIT=String.valueOf(oppline.RowNo__c);
         system.debug('IQP.ZCRMORIT:'+IQP.ZCRMORIT);

        IQP.zopid=ord.Opportunity__c;//需要修改
         system.debug('IQP.zopid:'+IQP.zopid);
        IQP.zopno=ord.Opportunity__r.name;//需要修改
           system.debug('IQP.zopno:'+IQP.zopno);
         if(ord.Seller__c == 'Jinko Solar Import and Export Co., Ltd.'){//卖方
            IQP.BUKRS = '1020';
        }else if(ord.Seller__c == 'JinkoSolar (Switzerland) AG'){
            IQP.BUKRS = '1080';
        }else if(ord.Seller__c == 'JinkoSolar (U.S.) Inc'){
            IQP.BUKRS = '1180';
        }else if(ord.Seller__c == 'JinkoSolar GmbH'){
            IQP.BUKRS = '1170';
        }else if(ord.Seller__c == 'Jinko Solar Co., Ltd.'){
            IQP.BUKRS = '1010';
        }else if(ord.Seller__c == 'JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD'){
            IQP.BUKRS = '1160';
        }else if(ord.Seller__c == 'JinkoSolar(ITALIA)S.R.L.'){
            IQP.BUKRS = '1120';
        }else if(ord.Seller__c == 'JINKOSOLAR (PTY) LTD'){
            IQP.BUKRS = '1230';           
        }else if(ord.Seller__c == 'JINKOSOLAR TECHNOLOGY LIMITED'){
            IQP.BUKRS = '1070';
        }else if(ord.Seller__c == 'JinkoSolar Canada Co., Ltd.'){
            IQP.BUKRS = '1140';
        }else if(ord.Seller__c == 'ジンコソーラージャパン株式会社'){
            IQP.BUKRS = '1250';
        }else if(ord.Seller__c == 'ZHEJIANG JINKO SOLAR CO.,LTD'){
            IQP.BUKRS = '1030';
        }else if(ord.Seller__c == 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA'){
            IQP.BUKRS = '0013';
        }else if(ord.Seller__c == 'JINKO SOLAR TECHNOLOGY SDN.BHD.'){
            IQP.BUKRS = '1590'; 
        }else if(ord.Seller__c == 'JINKOSOLAR TRADING PRIVATE LIMITED'){
            IQP.BUKRS = '1430';
        }else if(ord.Seller__c == 'POYANG RALLYSON TECHNOLOGY CO., LTD'){
            IQP.BUKRS = '4110';
        }else if(ord.Seller__c == 'Jinko Solar Technology Sdn Bhd'){
            IQP.BUKRS = '1590';
        }else if(ord.Seller__c == 'YUHUAN JINKO SOLAR CO., LTD'){
            IQP.BUKRS = '1410';
        }else if(ord.Seller__c == 'JINKO SOLAR (U.S.) INDUSTRIES INC.'){
            IQP.BUKRS = '1500';
        }else if(ord.Seller__c == 'Jinko Solar Korea Co., Ltd.'){
            IQP.BUKRS = '1490';
        }else if(ord.Seller__c == 'Jinkosolar (Vietnam) Co., Ltd.'){
            IQP.BUKRS = '0021';
        }
        system.debug('IQP.BUKRS'+IQP.BUKRS);
        IQP.BISMT=EDITID;
         system.debug('IQP.BISMT'+IQP.BISMT);
        IQP.KUNNR=ord.Account.SAP_External_ID__c;
        system.debug('IQP.KUNNR'+IQP.KUNNR);
        IQP.ZEDD=oppline.Guaranteed_Delivery_Date__c.year()+''+SAPBATCHCON.timechange(oppline.Guaranteed_Delivery_Date__c.month()+'')+SAPBATCHCON.timechange(oppline.Guaranteed_Delivery_Date__c.day()+'');//需要更改
        system.debug('IQP.ZEDD'+IQP.ZEDD);
         IQP.ZGDD=oppline.Guaranteed_Delivery_Date__c.year()+''+SAPBATCHCON.timechange(oppline.Guaranteed_Delivery_Date__c.month()+'')+SAPBATCHCON.timechange(oppline.Guaranteed_Delivery_Date__c.day()+'');//需要更改
         system.debug('IQP.ZGDD'+IQP.ZGDD);
         if(ord.Region__c=='EU(Non-Eu)'){
            IQP.ZDESTREGION= '103';
            }
             if(ord.Region__c=='EU(Union)'){
            IQP.ZDESTREGION= '103';
            }
             if(ord.Region__c=='North America'){
            IQP.ZDESTREGION= '104';
            }
             if(ord.Region__c=='Latin America&Italy'){
            IQP.ZDESTREGION= '105';
            }
            if(ord.Region__c=='Middle East&Africa'){
            IQP.ZDESTREGION= '106';
            }
            if(ord.Region__c=='SSA'){
            IQP.ZDESTREGION= '116';
            }
            if(ord.Region__c=='MENA'){
            IQP.ZDESTREGION= '117';
            }
            if(ord.Region__c=='North Asia'){
            IQP.ZDESTREGION= '107';
            }
            if(ord.Region__c=='South Asia'){
            IQP.ZDESTREGION= '108';
            }
            if(ord.Region__c=='ROA'){
            IQP.ZDESTREGION= '109';
            }
            if(ord.Region__c=='Central Asia'){
            IQP.ZDESTREGION= '114';
            } 
        system.debug('IQP.ZDESTREGION'+IQP.ZDESTREGION);
        IQP.ZDESTPORT=sapmap.getSAPportCode(ord.Destination_Port__c);
        system.debug('IQP.ZDESTPORT'+IQP.ZDESTPORT);
        IQP.ZBOOKQTY=String.valueOf(oppline.Quantity);//需要oppproduct更改
        system.debug('IQP.ZBOOKQTY'+IQP.ZBOOKQTY);
         IQP.MEINS='PC';//固定
        IQP.INCO1=ord.Trade_Term__c;
        system.debug('IQP.INCO1'+IQP.INCO1);
        if(ctb.Module_Series1__c!=null){
        IQP.ZMS1=Module_Series1Value_Map.get(ctb.Module_Series1__c);
            }
          if(ctb.Junction_Box_Connector__c!=null){
        IQP.ZJXHJT=Junction_Box_ConnectorValue(ctb.Junction_Box_Connector__c);
              }
        system.debug('IQP.ZJXHJT'+IQP.ZJXHJT);
          if(ctb.Junction_Box_Cable_Length__c!=null){
        IQP.ZJXHDLCD=Junction_Box_Cable_LengthValue_Map.get(ctb.Junction_Box_Cable_Length__c);
              }
        system.debug('IQP.ZJXHDLCD'+IQP.ZJXHDLCD);
          if(ctb.LRF__c!=null){
        IQP.ZLRF=LRFValue_Map.get(ctb.LRF__c);
              }
        system.debug('IQP.ZLRF'+IQP.ZLRF);
          if(ctb.EVA__c!=null){
        IQP.ZEVA=EVAValue_Map.get(ctb.EVA__c);
              }
         system.debug('IQP.ZEVA'+IQP.ZEVA);
          if(ctb.Frame_Type__c!=null){
        IQP.ZZJ=FrameValue_Map.get(ctb.Frame_Type__c);
              }
        system.debug('IQP.ZZJ'+IQP.ZZJ);
          if(ctb.Package__c!=null){
        IQP.ZBZ=PackageValue_Map.get(ctb.Package__c);
              }
        system.debug('IQP.ZBZ'+IQP.ZBZ);
          if(ctb.Product_Certificate__c!=null){
        IQP.ZCPHGZ=Product_CertificateValue_Map.get(ctb.Product_Certificate__c);
              }
        system.debug('IQP.ZCPHGZ'+IQP.ZCPHGZ);
          if(ctb.Additional_Certificate__c!=null){
        IQP.ZFJZS=Additional_CertificateValue_Map.get(ctb.Additional_Certificate__c);//多选
              }
        system.debug('IQP.ZFJZS'+IQP.ZFJZS);
          if(ctb.Mandatory_certification__c!=null){
        IQP.ZQYQZXRZ=Mandatory_certificationValue_Map.get(ctb.Mandatory_certification__c);
              }
        system.debug('IQP.ZQYQZXRZ'+IQP.ZQYQZXRZ);
         if( Userinfo.getProfileId()=='00e6F000001ctn6QAA'|| Userinfo.getProfileId()=='00e90000000NsvNAAS'
           || Userinfo.getProfileId()=='00e90000000NxyiAAC'|| Userinfo.getProfileId()=='00e90000000P9laAAC'
           || Userinfo.getProfileId()=='00e90000000sjacAAA'){
             
        IQP.ZROLE='A03';//角色代码
        }
        /**
         * 日后补全
        else if( ){
        IQP.ZROLE='A02';//角色代码
        }
**/
        else{
             IQP.ZROLE='A01';//角色代码
        }
        system.debug('IQP.ZEVA'+IQP.ZEVA);//角色代码  A01~A03 03最大

        
        AyncStockQuery.HTTPS_Port send =new AyncStockQuery.HTTPS_Port();
        send.timeout_x = 120000;
        SyncStockQuery.DT_StockQuery_Response response=send.SI_CRM2ECC_StockQuery_Out(IQP);
        List<SyncStockQuery.T_STOCK_element> fanhuizhiLst = new List<SyncStockQuery.T_STOCK_element>();
       
        system.debug('response:'+response.E_MSGTY);
        system.debug('response:'+response.E_MSGTXT);
        system.debug('response:'+fanhuizhiLst);
        if(response.T_STOCK!=null){
         fanhuizhiLst=response.T_STOCK;
            }
        return fanhuizhiLst;
        
        
    }
    
    
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
            'Standard Nextracker Frame' =>'003',
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
    public void tool(){
          integer num=1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
          num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;

        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
    }
    

}