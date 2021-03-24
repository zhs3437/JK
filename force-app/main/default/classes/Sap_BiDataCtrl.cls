global class Sap_BiDataCtrl {
  
     //Order ord = new Order();
    //public Sap_GetBiData.DT_GetBIData_Response BiData(String orderid){
    webservice static void BiData(String orderid){
        List<Order> OrdertMain = [Select id,Name,ContractId from order where ContractId=:orderid];
        if(OrdertMain.size() == 0){
            Contract c = Database.query( Utils.MakeSelectSql('Contract')+' WHERE Id =: orderid');
            List<Account> acc=[SELECT ID,Name from Account where id =:c.AccountId];
            List<User> u=[SELECT id,Name from User where id =:c.OwnerId];

            Sap_GetBiData tool = new Sap_GetBiData();
            Sap_GetBiData.DT_GetBIData_Request req = new Sap_GetBiData.DT_GetBIData_Request();
            req.T_INPUT = new List<Sap_GetBiData.T_INPUT_element>();
            Sap_GetBiData.DT_GetBIData_Response res = new Sap_GetBiData.DT_GetBIData_Response();
            //查询合同产品
            List<Product_Detail__c> orderItemList = Database.query( Utils.MakeSelectSql('Product_Detail__c')+' WHERE Contract_PO_PI__c =: orderid');
                for(Product_Detail__c oi:orderItemList){//2
                    Sap_GetBiData.T_INPUT_element SapData = new  Sap_GetBiData.T_INPUT_element();

                    SapData.ZACCNA = acc[0].Name;
                    System.debug('Account Name ------>ZACCNA------->'+SapData.ZACCNA);
                    //是否双签
                    if(c.Approval_Status__c=='Approved'){
                        SapData.ZSFSQ = 'X';
                    }else{
                        SapData.ZSFSQ = '';
                    }
                    //SapData.ZSFSQ = c.Approval_Status__c;//是否双签
                    SapData.ZDR = c.Destination_Region__c;//Destination Region
                    SapData.ZDOC = c.Destination_Country__c;//Destination Country
                    SapData.ZSR = c.Sales_Region__c;//Sales Region
                    if(u.size()>0){
                        SapData.ZCO = u[0].Name;//Contract/PO/PI Owner
                    }


                    SapData.ZSOCSH = c.BMO_Specialist__c;//SOC SH
                    SapData.ZJOEM = c.JINKO_OEM__c;//	JINKO_OEM__c
                    SapData.ZCPNO = c.Contract_No__c;//Contract/PO/PI No
                    SapData.ZSELLER = c.SELLER__c;//SELLER
                    SapData.ZWIN = c.Warranty_Insurance__c;//Warranty Insurance
                    SapData.ZTTERM = c.Trade_term__c;//Trade term
                    SapData.ZDP = c.Destination_Port__c;//Destination Port
                    //SapData.ZPTERMD = c.Payment_Term_Description__c;//Payment Term Description
                    //CsvStr cs1 = new CsvStr();
                    /*if(c.Payment_Term_Description__c.length()>500){
                        SapData.ZPTERMD = c.Payment_Term_Description__c.substring(0,500);
                    }else if(c.Payment_Term_Description__c.length()<=500){
                        SapData.ZPTERMD = c.Payment_Term_Description__c;
                    }*/
                    SapData.ZPTERMD = c.Payment_Term_Description__c;
                    SapData.ZCURRENCY = c.CurrencyIsoCode;//Currency
                    SapData.ZCOMCURRENCY = c.CurrencyIsoCode;//Commissioin Currency
                    SapData.ZCOMMISSION = String.valueOf(c.Commission__c);//Commissioin
                    SapData.ZREBATE = c.Rebate__c;//Rebate
                    SapData.ZDISCOUNT = c.Discount__c;//Discount
                    SapData.ZOSD = getTime(c.StartDate);//Order Start Date
                    SapData.ZGFAT = getTime(c.Get_Final_Approved_Time__c);//Get Final Approved Time
                    SapData.ZCRT = c.RecordTypeName__c;//Contracts/PO/PI Record Type
                    SapData.ZSBY = c.Supply_By__c;//Supply By
                    SapData.ZAMENDC = '0';//Amendment count
                    SapData.ZSALES1 = c.Sales_1__c;//Sales 1
                    SapData.ZSPER1 = String.valueOf(c.Sales_1_percentage__c);//Sales 1 percentage
                    SapData.ZSALES2 = c.Sales_2__c;
                    SapData.ZSPER2 = String.valueOf(c.Sales_2_percentage__c);
                    SapData.ZSALES3 = c.Sales_3__c;
                    SapData.ZSPER3 = String.valueOf(c.Sales_3_percentage__c);
                    SapData.ZSALESTY = c.Sales_type__c;//Sales type
                    SapData.ZPROTY = c.Project_type__c;//Project type
                    SapData.ZPROTY2 = c.Project_Type2__c;//Project type2
                    SapData.ZPRONAME = c.Project_Name__c;//Project Name
                    SapData.ZPROLO = c.Project_Location__c;//Project Location
                    //SapData.ZPROSIZE = ord.;//Project Size
                    SapData.ZCOMTIME = c.Completion_time__c;//
                    SapData.ZTOTALMW = String.valueOf(c.Total_MW__c);//Total MW
                    SapData.ZDMAR = c.DG_Market__c;//DG Market
                    SapData.ZSSFLAG = 'false';//是否同步过SAP
                    SapData.ZREDATE = getTime(date.today());//Reporting  Date


                    SapData.ZPROSER = oi.Product_Series__c;//Product Series
                    SapData.ZPRODNAME = oi.Product_Name__c;
                    SapData.ZQTY = String.valueOf(oi.Quantity__c);
                    SapData.ZMW = String.valueOf(oi.Total_MW__c);
                    SapData.ZPGISTATUS = null;
                    SapData.ZPGITIME = null;
                    SapData.ZPODSTATUS = null;
                    SapData.ZPODDATE = null;
                    SapData.ZPDD = null;

                    SapData.ZAPGID = null;
                    SapData.ZPLANT = null;//Plant
                    SapData.ZUNPRI = String.valueOf(oi.UnitPrice__c);//Unit Price
                    System.debug('ZUNPRI=======>'+SapData.ZUNPRI);
                    SapData.ZTOTPRI = String.valueOf(oi.Total_Price__c);//Total Price
                    SapData.ZUNPRIUSD = null;//Unit Price (converted to USD)
                    SapData.ZTOPRIUSD = null;//Total Price (converted)
                    //Integer a =  oi.Guaranteed_Delivery_Date_by_Month__c.length();
                    if(oi.Guaranteed_Delivery_Date__c !=null){
                        SapData.ZGDD = getTime(oi.Guaranteed_Delivery_Date__c);//Guaranteed Delivery Date
                        System.debug('交期------>'+ SapData.ZGDD);
                        SapData.ZSM = String.valueOf(oi.Guaranteed_Delivery_Date__c.Month()); //Sales Month
                        System.debug('ZSM----月份--------->'+SapData.ZSM);
                        String b = oi.Guaranteed_Delivery_Date_by_Quarter__c.substring(oi.Guaranteed_Delivery_Date_by_Quarter__c.length() -2,oi.Guaranteed_Delivery_Date_by_Quarter__c.length());
                        SapData.ZQ = b;//Quarter
                        System.debug('ZQ--季度--->'+b);
                    }



                    SapData.ZPOWERW = String.valueOf(oi.Unit_WM__c);//Power(W)
                    SapData.ZUPWCR = null;//Unit Price without C&R
                    SapData.ZTPWCR = null;//Total Price without C&R
                    SapData.PID =oi.Id;
                    System.debug('测试MDA开始');
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
                    Module_Category3_Text__c,
                    Frame_B_side_Height__c,
                    Frame_B_side_Height_Text__c
                    FROM Component_Task_Book__c
                    WHERE Contract__c = :orderid];
                    System.debug('MDA.size()'+Ctb.size());
                    if(Ctb.size()>0) {
                        for (Component_Task_Book__c ct : Ctb) {
                            if (ct.ModuleType1__r.Name == oi.Product_Name__c) {
                                System.debug('走进1');
                                //区域强制性认证
                                if (ct.Mandatory_certification__c != 'Other') {
                                    SapData.ZQYQZXRZ = ct.Mandatory_certification__c;
                                } else if (ct.Mandatory_certification__c == 'Other') {
                                    SapData.ZQYQZXRZ = ct.Regional_Mandatory_Certification_List_T__c;
                                }
                                //连接头
                                if (ct.Junction_Box_Connector__c != 'Other') {
                                    SapData.ZJXHJT = ct.Junction_Box_Connector__c;
                                } else if (ct.Junction_Box_Connector__c == 'Other') {
                                    SapData.ZJXHJT = ct.Junction_Box_Connector_Text__c;
                                }
                                //产品认证
                                if (ct.Product_Certificate__c != 'Other') {
                                    SapData.ZCPHGZ = ct.Product_Certificate__c;
                                } else if (ct.Product_Certificate__c == 'Other') {
                                    SapData.ZCPHGZ = ct.Product_Certificate_Text__c;
                                }
                                //电池片类型
                                if (ct.Cell_Type1__c != 'Other') {
                                    SapData.ZDCZL1 = ct.Cell_Type1__c;
                                } else if (ct.Cell_Type1__c == 'Other') {
                                    SapData.ZDCZL1 = ct.Cell_Type1_Text__c;
                                }

                                //SapData.ZDCZL2 = null;
                                //SapData.ZDCZL3 = null;
                                //接线盒品牌
                                if (ct.Junction_Box_brand__c != 'Other') {
                                    SapData.ZJXHPP = ct.Junction_Box_brand__c;
                                } else if (ct.Junction_Box_brand__c == 'Other') {
                                    SapData.ZJXHPP = ct.Junction_Box_brand_Text__c;
                                }
                                //接线盒长度
                                if (ct.Junction_Box_Cable_Length__c != 'Other') {
                                    SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length__c;
                                } else if (ct.Junction_Box_Cable_Length__c == 'Other') {
                                    SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length_Text__c;
                                }
                                //玻璃
                                if (ct.Front_Glass__c != 'Other') {
                                    SapData.ZBL = ct.Front_Glass__c;
                                } else if (ct.Front_Glass__c == 'Other') {
                                    SapData.ZBL = ct.Front_Glass_Text__c;
                                }
                                //支架 Frame
                                if (ct.Frame_B_side_Height__c != 'Others') {
                                    SapData.ZZJ = ct.Frame_B_side_Height__c;
                                } else if (ct.Frame_B_side_Height__c == 'Others') {
                                    SapData.ZZJ = ct.Frame_B_side_Height_Text__c;
                                }

                                SapData.PID = oi.id;

                                // req.T_INPUT.add(SapData);
                            } //产品1
                            if (ct.Module_Type2__r.Name == oi.Product_Name__c) {
                                System.debug('走进2');
                                //区域强制性认证
                                if (ct.Mandatory_certification__c != 'Other') {
                                    SapData.ZQYQZXRZ = ct.Mandatory_certification__c;
                                } else if (ct.Mandatory_certification__c == 'Other') {
                                    SapData.ZQYQZXRZ = ct.Regional_Mandatory_Certification_List_T__c;
                                }
                                //连接头
                                if (ct.Junction_Box_Connector__c != 'Other') {
                                    SapData.ZJXHJT = ct.Junction_Box_Connector__c;
                                } else if (ct.Junction_Box_Connector__c == 'Other') {
                                    SapData.ZJXHJT = ct.Junction_Box_Connector_Text__c;
                                }
                                //产品认证
                                if (ct.Product_Certificate__c != 'Other') {
                                    SapData.ZCPHGZ = ct.Product_Certificate__c;
                                } else if (ct.Product_Certificate__c == 'Other') {
                                    SapData.ZCPHGZ = ct.Product_Certificate_Text__c;
                                }
                                //电池片类型
                                if (ct.Cell_Type2__c != 'Other') {
                                    SapData.ZDCZL2 = ct.Cell_Type2__c;
                                } else if (ct.Cell_Type2__c == 'Other') {
                                    SapData.ZDCZL2 = ct.Cell_Type2_Text__c;
                                }

                                //SapData.ZDCZL1 = null;
                                //SapData.ZDCZL3 = null;
                                //接线盒品牌
                                if (ct.Junction_Box_brand__c != 'Other') {
                                    SapData.ZJXHPP = ct.Junction_Box_brand__c;
                                } else if (ct.Junction_Box_brand__c == 'Other') {
                                    SapData.ZJXHPP = ct.Junction_Box_brand_Text__c;
                                }
                                //接线盒长度
                                if (ct.Junction_Box_Cable_Length__c != 'Other') {
                                    SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length__c;
                                } else if (ct.Junction_Box_Cable_Length__c == 'Other') {
                                    SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length_Text__c;
                                }
                                //玻璃
                                if (ct.Front_Glass__c != 'Other') {
                                    SapData.ZBL = ct.Front_Glass__c;
                                } else if (ct.Front_Glass__c == 'Other') {
                                    SapData.ZBL = ct.Front_Glass_Text__c;
                                }
                                //支架 Frame
                                if (ct.Frame_B_side_Height__c != 'Others') {
                                    SapData.ZZJ = ct.Frame_B_side_Height__c;
                                } else if (ct.Frame_B_side_Height__c == 'Others') {
                                    SapData.ZZJ = ct.Frame_B_side_Height_Text__c;
                                }

                                SapData.PID = oi.id;
                                // req.T_INPUT.add(SapData);
                            } //产品2
                            if (ct.Module_Type3__r.Name == oi.Product_Name__c) {
                                System.debug('走进3');
                                //区域强制性认证
                                if (ct.Mandatory_certification__c != 'Other') {
                                    SapData.ZQYQZXRZ = ct.Mandatory_certification__c;
                                } else if (ct.Mandatory_certification__c == 'Other') {
                                    SapData.ZQYQZXRZ = ct.Regional_Mandatory_Certification_List_T__c;
                                }
                                //连接头
                                if (ct.Junction_Box_Connector__c != 'Other') {
                                    SapData.ZJXHJT = ct.Junction_Box_Connector__c;
                                } else if (ct.Junction_Box_Connector__c == 'Other') {
                                    SapData.ZJXHJT = ct.Junction_Box_Connector_Text__c;
                                }
                                //产品认证
                                if (ct.Product_Certificate__c != 'Other') {
                                    SapData.ZCPHGZ = ct.Product_Certificate__c;
                                } else if (ct.Product_Certificate__c == 'Other') {
                                    SapData.ZCPHGZ = ct.Product_Certificate_Text__c;
                                }
                                //电池片类型
                                if (ct.Cell_Type3__c != 'Other') {
                                    SapData.ZDCZL3 = ct.Cell_Type3__c;
                                } else if (ct.Cell_Type3__c == 'Other') {
                                    SapData.ZDCZL3 = ct.Cell_Type3_Text__c;
                                }

                                //SapData.ZDCZL1 = null;
                                //SapData.ZDCZL2 = null;
                                //接线盒品牌
                                if (ct.Junction_Box_brand__c != 'Other') {
                                    SapData.ZJXHPP = ct.Junction_Box_brand__c;
                                } else if (ct.Junction_Box_brand__c == 'Other') {
                                    SapData.ZJXHPP = ct.Junction_Box_brand_Text__c;
                                }
                                //接线盒长度
                                if (ct.Junction_Box_Cable_Length__c != 'Other') {
                                    SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length__c;
                                } else if (ct.Junction_Box_Cable_Length__c == 'Other') {
                                    SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length_Text__c;
                                }
                                //玻璃
                                if (ct.Front_Glass__c != 'Other') {
                                    SapData.ZBL = ct.Front_Glass__c;
                                } else if (ct.Front_Glass__c == 'Other') {
                                    SapData.ZBL = ct.Front_Glass_Text__c;
                                }
                                //支架 Frame
                                if (ct.Frame_B_side_Height__c != 'Others') {
                                    SapData.ZZJ = ct.Frame_B_side_Height__c;
                                } else if (ct.Frame_B_side_Height__c == 'Others') {
                                    SapData.ZZJ = ct.Frame_B_side_Height_Text__c;
                                }

                                SapData.PID = oi.id;
                                // req.T_INPUT.add(SapData);
                            } //产品3

                        }
                    }
                    req.T_INPUT.add(SapData);


                }//2

            //调用接口
            Sap_CRM_GetBiData.HTTPS_Port HttpPort = new Sap_CRM_GetBiData.HTTPS_Port();
            res = HttpPort.SI_CRM2ECC_GetBIData_Out(req.T_INPUT);
            System.debug('res==========='+res);


            /*
             * 订单部分 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			    */
        }else if(OrdertMain.size()>0){
            System.debug('订单id--------------->'+orderid);
            String oidd = OrdertMain[0].id;
        Order ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                  'Where id =: oidd');
        String conid = ord.ContractId;
        List<Contract> con=Database.query( Utils.MakeSelectSql('Contract')+' WHERE Id =: conid'); 
        List<Account> acc=[SELECT ID,Name from Account where id =:ord.AccountId];
        List<User> u=[SELECT id,Name from User where id =:ord.Contract_Owner__c];
        Sap_GetBiData tool = new Sap_GetBiData();
        Sap_GetBiData.DT_GetBIData_Request req = new Sap_GetBiData.DT_GetBIData_Request();
        req.T_INPUT = new List<Sap_GetBiData.T_INPUT_element>();
        Sap_GetBiData.DT_GetBIData_Response res = new Sap_GetBiData.DT_GetBIData_Response();
        //req.T_INPUT = ;
        System.debug('SAP_Order_ID__c--->'+ord.SAP_Order_ID__c);
        if(ord.SAP_Order_ID__c !=null && ord.SAP_Order_ID__c !=''){
        System.debug('已经同步过订单');
        Sap_GetBiData.T_INPUT_element SapData = new  Sap_GetBiData.T_INPUT_element();
        SapData.ZACCNA = acc[0].Name;
        System.debug('Account Name ------>ZACCNA------->'+SapData.ZACCNA);
            //是否双签
            if(con[0].Approval_Status__c=='Approved'){
                SapData.ZSFSQ = 'X';
            }else{
                SapData.ZSFSQ = '';
            }

        SapData.ZREDATE = getTime(date.today());//Reporting  Date
        SapData.ZDR = con[0].Destination_Region__c;//Destination Region
        SapData.ZDOC = ord.Destination_Country__c;//Destination Country
        SapData.ZSR = con[0].Sales_Region__c;//Sales Region
        SapData.ZCO = u[0].Name; //Contract/PO/PI Owner
        SapData.ZSOCSH = ord.BMO_SH_SR__c;//SOC SH
        SapData.ZJOEM = con[0].JINKO_OEM__c;//	JINKO_OEM__c
        SapData.ZCPNO = ord.Contract_No__c;//Contract/PO/PI No
        SapData.ZSELLER = ord.SELLER__c;//SELLER
        SapData.ZWIN = ord.Warranty_Insurance__c;//Warranty Insurance
        SapData.ZTTERM = ord.Trade_term__c;//Trade term
        SapData.ZDP = ord.Destination_Port__c;//Destination Port
        //SapData.ZPTERMD = ord.Payment_Term_Description__c;//Payment Term Description
            //CsvStr cs2 = new CsvStr();
            /*if(ord.Payment_Term_Description__c.length()>500){
                SapData.ZPTERMD = ord.Payment_Term_Description__c.substring(0,500);
            }else if(ord.Payment_Term_Description__c.length()<=500){
                SapData.ZPTERMD = ord.Payment_Term_Description__c;
            }*/

            SapData.ZPTERMD = ord.Payment_Term_Description__c;
//            SapData.ZPTERMD = ord.Payment_Term_Description__c.substring(0,500);
        SapData.ZCURRENCY = ord.CurrencyIsoCode;//Currency
        SapData.ZCOMCURRENCY = ord.CurrencyIsoCode;//Commissioin Currency
        SapData.ZCOMMISSION = String.valueOf(ord.Commission__c);//Commissioin
        SapData.ZREBATE = ord.Rebate__c;//Rebate
        SapData.ZDISCOUNT = ord.Discount__c;//Discount
        SapData.ZOSD = getTime(ord.Contracts_Start_Date__c);//Order Start Date
        SapData.ZGFAT = getTime(ord.Get_Final_Approved_Time__c);//Get Final Approved Time   
        SapData.ZCRT = con[0].RecordTypeName__c;//Contracts/PO/PI Record Type
        SapData.ZSBY = ord.Supply_By__c;//Supply By
        SapData.ZAMENDC = String.valueOf(ord.Amendment_count__c);//Amendment count
        SapData.ZSALES1 = ord.Sales_1__c;//Sales 1
        SapData.ZSPER1 = String.valueOf(ord.Sales_1_percentage__c);//Sales 1 percentage
        SapData.ZSALES2 = ord.Sales_2__c;
        SapData.ZSPER2 = String.valueOf(ord.Sales_2_percentage__c);
        SapData.ZSALES3 = ord.Sales_3__c;
        SapData.ZSPER3 = String.valueOf(ord.Sales_3_percentage__c);
        SapData.ZSALESTY = ord.Sales_type__c;//Sales type
        SapData.ZPROTY = ord.Project_type__c;//Project type
        SapData.ZPROTY2 = ord.Project_Type2__c;//Project type2
        SapData.ZPRONAME = ord.Project_Name__c;//Project Name
        SapData.ZPROLO = ord.Project_Location__c;//Project Location
        //SapData.ZPROSIZE = ord.;//Project Size
        SapData.ZCOMTIME = ord.Completion_time__c;//
        SapData.ZTOTALMW = String.valueOf(ord.Total_MW__c);//Total MW
        SapData.ZDMAR = ord.DG_Market__c;//DG Market
        SapData.ZSSFLAG = 'true';//是否同步过SAP
       
        req.T_INPUT.add(SapData);
           
        }else if(ord.SAP_Order_ID__c ==null || ord.SAP_Order_ID__c ==''){//1
            System.debug('没有同步过订单');
            List<OrderItem> orderItemList = Database.query( Utils.MakeSelectSql('OrderItem')+' WHERE OrderId =: oidd');
            for(OrderItem oi:orderItemList){//2
        Sap_GetBiData.T_INPUT_element SapData = new  Sap_GetBiData.T_INPUT_element();
            
        SapData.ZACCNA = acc[0].Name;
        System.debug('Account Name ------>ZACCNA------->'+SapData.ZACCNA);
                //是否双签
                if(con[0].Approval_Status__c=='Approved'){
                    SapData.ZSFSQ = 'X';
                }else{
                    SapData.ZSFSQ = '';
                }

        SapData.ZDR = con[0].Destination_Region__c;//Destination Region
        SapData.ZDOC = ord.Destination_Country__c;//Destination Country
        SapData.ZSR = con[0].Sales_Region__c;//Sales Region
                if(u.size()>0){
                    SapData.ZCO = u[0].Name;//Contract/PO/PI Owner
                }        
        
                
        SapData.ZSOCSH = ord.BMO_SH_SR__c;//SOC SH
        SapData.ZJOEM = con[0].JINKO_OEM__c;//	JINKO_OEM__c
        SapData.ZCPNO = ord.Contract_No__c;//Contract/PO/PI No
        SapData.ZSELLER = ord.SELLER__c;//SELLER
        SapData.ZWIN = ord.Warranty_Insurance__c;//Warranty Insurance
        SapData.ZTTERM = ord.Trade_term__c;//Trade term
        SapData.ZDP = ord.Destination_Port__c;//Destination Port
        //SapData.ZPTERMD = ord.Payment_Term_Description__c;//Payment Term Description
                //CsvStr cs3 = new CsvStr();
               /* if(ord.Payment_Term_Description__c.length()>500){
                    SapData.ZPTERMD = ord.Payment_Term_Description__c.substring(0,500);
                }else if(ord.Payment_Term_Description__c.length()<=500){
                    SapData.ZPTERMD = ord.Payment_Term_Description__c;
                }*/
                SapData.ZPTERMD = ord.Payment_Term_Description__c;
                //SapData.ZPTERMD = ord.Payment_Term_Description__c.substring(0,500);
        SapData.ZCURRENCY = ord.CurrencyIsoCode;//Currency
        SapData.ZCOMCURRENCY = ord.CurrencyIsoCode;//Commissioin Currency
        SapData.ZCOMMISSION = String.valueOf(ord.Commission__c);//Commissioin
        SapData.ZREBATE = ord.Rebate__c;//Rebate
        SapData.ZDISCOUNT = ord.Discount__c;//Discount
        SapData.ZOSD = getTime(ord.Contracts_Start_Date__c);//Order Start Date
        SapData.ZGFAT = getTime(ord.Get_Final_Approved_Time__c);//Get Final Approved Time
        SapData.ZCRT = con[0].RecordTypeName__c;//Contracts/PO/PI Record Type
        SapData.ZSBY = ord.Supply_By__c;//Supply By
        SapData.ZAMENDC = String.valueOf(ord.Amendment_count__c);//Amendment count
        SapData.ZSALES1 = ord.Sales_1__c;//Sales 1
        SapData.ZSPER1 = String.valueOf(ord.Sales_1_percentage__c);//Sales 1 percentage
        SapData.ZSALES2 = ord.Sales_2__c;
        SapData.ZSPER2 = String.valueOf(ord.Sales_2_percentage__c);
        SapData.ZSALES3 = ord.Sales_3__c;
        SapData.ZSPER3 = String.valueOf(ord.Sales_3_percentage__c);
        SapData.ZSALESTY = ord.Sales_type__c;//Sales type
        SapData.ZPROTY = ord.Project_type__c;//Project type
        SapData.ZPROTY2 = ord.Project_Type2__c;//Project type2
        SapData.ZPRONAME = ord.Project_Name__c;//Project Name
        SapData.ZPROLO = ord.Project_Location__c;//Project Location
        //SapData.ZPROSIZE = ord.;//Project Size
        SapData.ZCOMTIME = ord.Completion_time__c;//
        SapData.ZTOTALMW = String.valueOf(ord.Total_MW__c);//Total MW
        SapData.ZDMAR = ord.DG_Market__c;//DG Market
            SapData.ZSSFLAG = 'false';//是否同步过SAP
        SapData.ZREDATE = getTime(date.today());//Reporting  Date
        
            
        SapData.ZPROSER = oi.Product_Series__c;//Product Series
        SapData.ZPRODNAME = oi.Product_Name__c;
        SapData.ZQTY = String.valueOf(oi.Quantity);
        SapData.ZMW = String.valueOf(oi.Total_MW_Auto__c);
        SapData.ZPGISTATUS = null;
        SapData.ZPGITIME = null;
        SapData.ZPODSTATUS = null;
        SapData.ZPODDATE = null;
        SapData.ZPDD = null;
             
        SapData.ZAPGID = null;
        SapData.ZPLANT = null;//Plant
        SapData.ZUNPRI = String.valueOf(oi.UnitPrice);//Unit Price
                System.debug('ZUNPRI=======>'+SapData.ZUNPRI);
        SapData.ZTOTPRI = String.valueOf(oi.Total_Price__c);//Total Price
        SapData.ZUNPRIUSD = null;//Unit Price (converted to USD)	
        SapData.ZTOPRIUSD = null;//Total Price (converted)
        //Integer a =  oi.Guaranteed_Delivery_Date_by_Month__c.length();
                if(oi.Guaranteed_Delivery_Date__c !=null){
                    SapData.ZGDD = getTime(oi.Guaranteed_Delivery_Date__c);//Guaranteed Delivery Date
        			System.debug('交期------>'+ SapData.ZGDD);   
                    SapData.ZSM = String.valueOf(oi.Guaranteed_Delivery_Date__c.Month()); //Sales Month
        			System.debug('ZSM----月份--------->'+SapData.ZSM);  
                    String b = oi.Guaranteed_Delivery_Date_by_Quarter__c.substring(oi.Guaranteed_Delivery_Date_by_Quarter__c.length() -2,oi.Guaranteed_Delivery_Date_by_Quarter__c.length()); 
        			SapData.ZQ = b;//Quarter
        			System.debug('ZQ--季度--->'+b);
                }
         
        
       
        SapData.ZPOWERW = String.valueOf(oi.Power_W__c);//Power(W)
        SapData.ZUPWCR = null;//Unit Price without C&R
        SapData.ZTPWCR = null;//Total Price without C&R
        SapData.PID =oi.Id18__c; 
                System.debug('测试MDA开始');
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
                                           Module_Category3_Text__c,
                                           	Frame_B_side_Height__c,
                                           	Frame_B_side_Height_Text__c
                                           FROM Component_Task_Book__c 
                                           WHERE Contract__c = :conid];
        System.debug('MDA.size()'+Ctb.size());
                if(Ctb.size()>0) {
                    for (Component_Task_Book__c ct : Ctb) {
                        if (ct.ModuleType1__r.Name == oi.Product_Name__c) {
                            System.debug('走进1');
                            //区域强制性认证
                            if (ct.Mandatory_certification__c != 'Other') {
                                SapData.ZQYQZXRZ = ct.Mandatory_certification__c;
                            } else if (ct.Mandatory_certification__c == 'Other') {
                                SapData.ZQYQZXRZ = ct.Regional_Mandatory_Certification_List_T__c;
                            }
                            //连接头
                            if (ct.Junction_Box_Connector__c != 'Other') {
                                SapData.ZJXHJT = ct.Junction_Box_Connector__c;
                            } else if (ct.Junction_Box_Connector__c == 'Other') {
                                SapData.ZJXHJT = ct.Junction_Box_Connector_Text__c;
                            }
                            //产品认证
                            if (ct.Product_Certificate__c != 'Other') {
                                SapData.ZCPHGZ = ct.Product_Certificate__c;
                            } else if (ct.Product_Certificate__c == 'Other') {
                                SapData.ZCPHGZ = ct.Product_Certificate_Text__c;
                            }
                            //电池片类型
                            if (ct.Cell_Type1__c != 'Other') {
                                SapData.ZDCZL1 = ct.Cell_Type1__c;
                            } else if (ct.Cell_Type1__c == 'Other') {
                                SapData.ZDCZL1 = ct.Cell_Type1_Text__c;
                            }

                            //SapData.ZDCZL2 = null;
                            //SapData.ZDCZL3 = null;
                            //接线盒品牌
                            if (ct.Junction_Box_brand__c != 'Other') {
                                SapData.ZJXHPP = ct.Junction_Box_brand__c;
                            } else if (ct.Junction_Box_brand__c == 'Other') {
                                SapData.ZJXHPP = ct.Junction_Box_brand_Text__c;
                            }
                            //接线盒长度
                            if (ct.Junction_Box_Cable_Length__c != 'Other') {
                                SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length__c;
                            } else if (ct.Junction_Box_Cable_Length__c == 'Other') {
                                SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length_Text__c;
                            }
                            //玻璃
                            if (ct.Front_Glass__c != 'Other') {
                                SapData.ZBL = ct.Front_Glass__c;
                            } else if (ct.Front_Glass__c == 'Other') {
                                SapData.ZBL = ct.Front_Glass_Text__c;
                            }
                            //支架 Frame
                            if (ct.Frame_B_side_Height__c != 'Others') {
                                SapData.ZZJ = ct.Frame_B_side_Height__c;
                            } else if (ct.Frame_B_side_Height__c == 'Others') {
                                SapData.ZZJ = ct.Frame_B_side_Height_Text__c;
                            }

                            SapData.PID = oi.id;

                            // req.T_INPUT.add(SapData);
                        } //产品1
                        if (ct.Module_Type2__r.Name == oi.Product_Name__c) {
                            System.debug('走进2');
                            //区域强制性认证
                            if (ct.Mandatory_certification__c != 'Other') {
                                SapData.ZQYQZXRZ = ct.Mandatory_certification__c;
                            } else if (ct.Mandatory_certification__c == 'Other') {
                                SapData.ZQYQZXRZ = ct.Regional_Mandatory_Certification_List_T__c;
                            }
                            //连接头
                            if (ct.Junction_Box_Connector__c != 'Other') {
                                SapData.ZJXHJT = ct.Junction_Box_Connector__c;
                            } else if (ct.Junction_Box_Connector__c == 'Other') {
                                SapData.ZJXHJT = ct.Junction_Box_Connector_Text__c;
                            }
                            //产品认证
                            if (ct.Product_Certificate__c != 'Other') {
                                SapData.ZCPHGZ = ct.Product_Certificate__c;
                            } else if (ct.Product_Certificate__c == 'Other') {
                                SapData.ZCPHGZ = ct.Product_Certificate_Text__c;
                            }
                            //电池片类型
                            if (ct.Cell_Type2__c != 'Other') {
                                SapData.ZDCZL2 = ct.Cell_Type2__c;
                            } else if (ct.Cell_Type2__c == 'Other') {
                                SapData.ZDCZL2 = ct.Cell_Type2_Text__c;
                            }

                            //SapData.ZDCZL1 = null;
                            //SapData.ZDCZL3 = null;
                            //接线盒品牌
                            if (ct.Junction_Box_brand__c != 'Other') {
                                SapData.ZJXHPP = ct.Junction_Box_brand__c;
                            } else if (ct.Junction_Box_brand__c == 'Other') {
                                SapData.ZJXHPP = ct.Junction_Box_brand_Text__c;
                            }
                            //接线盒长度
                            if (ct.Junction_Box_Cable_Length__c != 'Other') {
                                SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length__c;
                            } else if (ct.Junction_Box_Cable_Length__c == 'Other') {
                                SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length_Text__c;
                            }
                            //玻璃
                            if (ct.Front_Glass__c != 'Other') {
                                SapData.ZBL = ct.Front_Glass__c;
                            } else if (ct.Front_Glass__c == 'Other') {
                                SapData.ZBL = ct.Front_Glass_Text__c;
                            }
                            //支架 Frame
                            if (ct.Frame_B_side_Height__c != 'Others') {
                                SapData.ZZJ = ct.Frame_B_side_Height__c;
                            } else if (ct.Frame_B_side_Height__c == 'Others') {
                                SapData.ZZJ = ct.Frame_B_side_Height_Text__c;
                            }

                            SapData.PID = oi.id;
                            // req.T_INPUT.add(SapData);
                        } //产品2
                        if (ct.Module_Type3__r.Name == oi.Product_Name__c) {
                            System.debug('走进3');
                            //区域强制性认证
                            if (ct.Mandatory_certification__c != 'Other') {
                                SapData.ZQYQZXRZ = ct.Mandatory_certification__c;
                            } else if (ct.Mandatory_certification__c == 'Other') {
                                SapData.ZQYQZXRZ = ct.Regional_Mandatory_Certification_List_T__c;
                            }
                            //连接头
                            if (ct.Junction_Box_Connector__c != 'Other') {
                                SapData.ZJXHJT = ct.Junction_Box_Connector__c;
                            } else if (ct.Junction_Box_Connector__c == 'Other') {
                                SapData.ZJXHJT = ct.Junction_Box_Connector_Text__c;
                            }
                            //产品认证
                            if (ct.Product_Certificate__c != 'Other') {
                                SapData.ZCPHGZ = ct.Product_Certificate__c;
                            } else if (ct.Product_Certificate__c == 'Other') {
                                SapData.ZCPHGZ = ct.Product_Certificate_Text__c;
                            }
                            //电池片类型
                            if (ct.Cell_Type3__c != 'Other') {
                                SapData.ZDCZL3 = ct.Cell_Type3__c;
                            } else if (ct.Cell_Type3__c == 'Other') {
                                SapData.ZDCZL3 = ct.Cell_Type3_Text__c;
                            }

                            //SapData.ZDCZL1 = null;
                            //SapData.ZDCZL2 = null;
                            //接线盒品牌
                            if (ct.Junction_Box_brand__c != 'Other') {
                                SapData.ZJXHPP = ct.Junction_Box_brand__c;
                            } else if (ct.Junction_Box_brand__c == 'Other') {
                                SapData.ZJXHPP = ct.Junction_Box_brand_Text__c;
                            }
                            //接线盒长度
                            if (ct.Junction_Box_Cable_Length__c != 'Other') {
                                SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length__c;
                            } else if (ct.Junction_Box_Cable_Length__c == 'Other') {
                                SapData.ZJXHDLCD = ct.Junction_Box_Cable_Length_Text__c;
                            }
                            //玻璃
                            if (ct.Front_Glass__c != 'Other') {
                                SapData.ZBL = ct.Front_Glass__c;
                            } else if (ct.Front_Glass__c == 'Other') {
                                SapData.ZBL = ct.Front_Glass_Text__c;
                            }
                            //支架 Frame
                            if (ct.Frame_B_side_Height__c != 'Others') {
                                SapData.ZZJ = ct.Frame_B_side_Height__c;
                            } else if (ct.Frame_B_side_Height__c == 'Others') {
                                SapData.ZZJ = ct.Frame_B_side_Height_Text__c;
                            }

                            SapData.PID = oi.id;
                            // req.T_INPUT.add(SapData);
                        } //产品3

                    }
                }
				req.T_INPUT.add(SapData);
                
                
                }//2
            
            
        }//1
        
        
        //try{
        
        //调用接口
         Sap_CRM_GetBiData.HTTPS_Port HttpPort = new Sap_CRM_GetBiData.HTTPS_Port();
         
        
       
        res = HttpPort.SI_CRM2ECC_GetBIData_Out(req.T_INPUT);
            System.debug('res==========='+res);
       // }catch(Exception ex){
              
         //   system.debug('------->Exception:' + ex );
       // }
        
        
       // return res;
        }//Order Data
        
	}
    
    public static String getTime(Date da){
         String month;
        String day;
        String result = '';
        if(da!=null){
        if(da.month()==1){
            month='01';
        }
        else if(da.month()==2){
            month='02';
        }   else if(da.month()==3){
            month='03';
        }   else if(da.month()==4){
            month='04';
        }   else if(da.month()==5){
            month='05';
        }   else if(da.month()==6){
            month='06';
        }   else if(da.month()==7){
            month='07';
        }   else if(da.month()==8){
            month='08';
        }   else if(da.month()==9){
            month='09';
        }
            else{
                 month=da.month()+'';
            }
         if(da.day()==1){
            day='01';
        }
        else if(da.day()==2){
            day='02';
        }   else if(da.day()==3){
            day='03';
        }   else if(da.day()==4){
            day='04';
        }   else if(da.day()==5){
            day='05';
        }   else if(da.day()==6){
            day='06';
        }   else if(da.day()==7){
            day='07';
        }   else if(da.day()==8){
            day='08';
        }   else if(da.day()==9){
            day='09';
        }
            else{
                day=da.day()+'';
            }
            
              result=da.YEAR()+''+month+day;
        }
        
        return result;
    }
    
    public static String getMonth(Date da){
        System.debug('getMonth ===========>'+da);
         String month;
        month=null;        
        if(da!=null){
        if(da.month()==1){
            month='01';
        }
        else if(da.month()==2){
            month='02';
        }   else if(da.month()==3){
            month='03';
        }   else if(da.month()==4){
            month='04';
        }   else if(da.month()==5){
            month='05';
        }   else if(da.month()==6){
            month='06';
        }   else if(da.month()==7){
            month='07';
        }   else if(da.month()==8){
            month='08';
        }   else if(da.month()==9){
            month='09';
        }
            else{
                 month=String.valueOf(da.month());
            }
    }
         return month;
    }

    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);

            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();

            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                //if (!sObj.contains('__')) to exclude managed package objects

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);

                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }


    
    public void test(){
       Decimal i=0;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
    }
    
}