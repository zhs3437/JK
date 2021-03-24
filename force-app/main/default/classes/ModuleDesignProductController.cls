public class ModuleDesignProductController {
    public String currentId {get;set;} 
    public Product_Detail__c orderItem1  {get;set;}  
    public Product_Detail__c orderItem2  {get;set;}
    public Product_Detail__c orderItem3  {get;set;}
    public List<Product_Detail__c> pdItemList{get;set;}
    public List<Product_Detail__c> pdList{get;set;}
    public Product_Detail__c pdItem1 {get;set;}
    public Product_Detail__c pdItem2 {get;set;}
    public Product_Detail__c pdItem3 {get;set;}
    public String conId{get;set;}
    public String conNumber{get;set;}
    public String pageId{get;set;}
    public String ordName{get;set;}
    public String ordId{get;set;}
    public String productName1{get;set;}
    public String productId1{get;set;}
    public String productName2{get;set;}
    public String productId2{get;set;}
    public String productName3{get;set;}
    public String productId3{get;set;}
    public String MandatoryCertification{get;set;}
    public String quantityId1{get;set;}
    public String quantityId2{get;set;}
    public String cellquantity{get;set;}
    public String cellquantity2{get;set;}
    public String cellquantity3{get;set;}
    public String quantityId3{get;set;}
    public String cableLength{get;set;}
    public String powertolerance{get;set;}
    public String warranty{get;set;}
    public list<string> ids {get;set;}
    public string id1 {get;set;}
    public string id2 {get;set;}
    public string id3 {get;set;}
    public string ProductCertificate{get;set;}
    public string JunctionBoxConnector{get;set;}
    public string SystemVoltage{get;set;}
    public string CurrentSortingStyle{get;set;}
    public string ColorSortingstyle{get;set;}
    public String tranStyle{get;set;}   
    public string ShippingMark{get;set;}
    public String Mandatorycerti{get;set;}   
    public String JunctionBoxType{get;set;}   
    public String JunctionBoxCableLength{get;set;}
    public String Regionalcustomsclearancerequest{get;set;}
    public String StringRibbon{get;set;}
    public String StringFrameType{get;set;}
    public String StringSeries1{get;set;}
    public String StringSeries2{get;set;}
    public String StringSeries3{get;set;}
    public String CellColor{get;set;}
    public String Rearcover{get;set;}
    public String EVA{get;set;}
    public String FrontGlass{get;set;}	
    public String FrameBsideHeight{get;set;}
    public String LRF{get;set;}
    public String Package1{get;set;}
    
    
    
    
    
    
    public ModuleDesignProductController(){
        
    }
    public ModuleDesignProductController(ApexPages.StandardSetController controller){
        currentId = ApexPages.currentPage().getParameters().get('conId');
        id1 = ApexPages.currentPage().getParameters().get('p1');
        id2 = ApexPages.currentPage().getParameters().get('p2');
        id3 = ApexPages.currentPage().getParameters().get('p3');        
        system.debug('====currentId: ' + currentId);
        system.debug('====id1: ' + id1);
        system.debug('====id2: ' + id2);
        system.debug('====id3: ' + id3);       
        
        ModuleDesignParam__c mdp = ModuleDesignParam__c.getOrgDefaults();
        pageId      = mdp.Module_Design_Id__c;
        ordName     = mdp.Module_Design_Order_Name__c;
        ordId      = mdp.Module_Design_Order_Id__c;
        productName1  = mdp.Module_Design_Product_Name__c;
        productId1    = mdp.Module_Design_Product_Id__c;
        productName2  = mdp.Module_Design_Product_Name2__c;      
        productId2    = mdp.Module_Design_Product_Id2__c;
        cellquantity    = mdp.Module_Design_Product_Cell_Quantity__c;
        cellquantity2    = mdp.Module_Design_Product_Cell_Quantity2__c;
        cellquantity3    = mdp.Module_Design_Product_Cell_Quantity3__c;
        productName3  = mdp.Module_Design_Product_Name3__c;
        productId3    = mdp.Module_Design_Product_Id3__c;
        quantityId1    = mdp.Module_Design_Product_Quantity__c;
        quantityId2    = mdp.Module_Design_Product_Quantity2__c;
        quantityId3    = mdp.Module_Design_Product_Quantity3__c;
        conNumber       = mdp.Module_Design_ContractNumber__c;
        conId           = mdp.Module_Design_Contract_Id__c;
        cableLength     = mdp.Module_Design_Cable_Length__c;
        powertolerance  = mdp.Module_Design_Power_tolerance__c;
        warranty     = mdp.Module_Design_Warranty__c;
        //新增
        tranStyle       = mdp.Module_Design_Transportation_style__c;//旧
        ProductCertificate = mdp.ProductCertificate__c;
        JunctionBoxConnector = mdp.Junction_Box_Connector__c;
        SystemVoltage = mdp.System_Voltage__c;
        CurrentSortingStyle = mdp.Current_Sorting_Style__c;
        ColorSortingstyle = mdp.Color_Sorting_style__c;
        ShippingMark = mdp.Shipping_Mark__c;
        JunctionBoxType = mdp.Junction_Box_Type__c;
        JunctionBoxCableLength = mdp.Junction_Box_Cable_Length__c;
        Regionalcustomsclearancerequest = mdp.Regional_customs_clearance_request__c;
        StringFrameType = mdp.Frame_Type__c;
        StringSeries1 = mdp.module_Series1__c;
        StringSeries2 = mdp.module_Series2__c;
        StringSeries3 = mdp.module_Series3__c;
		CellColor = mdp.Cell_Color__c;
            //增加根据交货地址来初始化默认值
            MandatoryCertification = mdp.Mandatory_certification__c;
        
        StringRibbon = mdp.String_Ribbon__c;
        system.debug('----cableLength'+pageId);
        system.debug('----ProductCertificate'+ProductCertificate);
        // 2020/10/12 增加根据产品名字 添加默认值的设置
        Rearcover =mdp.Rear_cover__c;
   		EVA =mdp.EVA__c;
   		FrontGlass =mdp.Front_Glass__c;
    	FrameBsideHeight =mdp.Frame_B_side_Height__c;
    	LRF =mdp.LRF__c;
    	Package1 =mdp.Package__c;
    }
    public PageReference goto(){
        
        List<Product_Detail__c> orderItemList = [select id,Name,
                                                 Contract_PO_PI__c,
                                                 Product_Name__c,
                                                 Product__c,
                                                 Product__r.name,
                                                 Quantity__c,
                                                 Length_of_Junction_Box_wiring__c,
                                                 Cable_Length__c,
                                                 Tolerance__c 
                                                 From Product_Detail__c 
                                                 Where id =: id1 Or id =: id2 Or id =: id3];
        
        Contract con = [select Id,ContractNumber,Warranty_On_Material_and_Workmanship__c,Shipping_type__c,Region__c,Total_MW__c,Destination_Country__c  From Contract Where id =: orderItemList[0].Contract_PO_PI__c ];
      
      //  try{
                      
            if(orderItemList.size()==1){
                orderItem1 = orderItemList[0];
            }
            if(orderItemList.size()==2){
                orderItem1 = orderItemList[0];
                orderItem2 = orderItemList[1];
            }
            if(orderItemList.size()==3){
                orderItem1 = orderItemList[0];
                orderItem2 = orderItemList[1];
                orderItem3 = orderItemList[2];
            }
            PageReference newPage = new PageReference(pageId);
            if(con!=null){//Mandatory certification根据国家
                if(con.Destination_Country__c=='India'){
                    newPage.getParameters().put(MandatoryCertification,'BIS');
                }else if(con.Destination_Country__c=='Saudi Arabia'){     
                    newPage.getParameters().put(MandatoryCertification,'IECEE');                    
                }else if(con.Destination_Country__c=='Brazil'){
                    newPage.getParameters().put(MandatoryCertification,'Inmetro');
                }else if(con.Destination_Country__c=='Colombia'){
                    newPage.getParameters().put(MandatoryCertification,'RETIE');
                }else if(con.Destination_Country__c=='Australia'){
                    newPage.getParameters().put(MandatoryCertification,'CEC');
                }else if(con.Destination_Country__c=='South Korea'){
                    newPage.getParameters().put(MandatoryCertification,'KS');
                }else if(con.Destination_Country__c=='Israel'){
                    newPage.getParameters().put(MandatoryCertification,'SII');
                }else if(con.Destination_Country__c=='United States' || con.Destination_Country__c=='Canada'){
                    newPage.getParameters().put(MandatoryCertification,'PQP');
                }else {
                    newPage.getParameters().put(MandatoryCertification,'No Need'); 
                }
                if(con.Destination_Country__c=='Pakistan'){
                    newPage.getParameters().put(Regionalcustomsclearancerequest,'COC+PSI'); 
                }else{
                    newPage.getParameters().put(Regionalcustomsclearancerequest,'No Need'); 
                }

                   
            }
        
        
        
        
        
            
            if(orderItemList.size()>=1){ 
                newPage.getParameters().put(conNumber,con.ContractNumber);  
                newPage.getParameters().put(productName1,orderItem1.Product_Name__c);
                if(orderItem1.Product__r.name.contains('JKM')){
                    
                
                if(orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('-60H')){
                    newPage.getParameters().put(cellquantity,'120');
                }
                if(orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('-60') && !orderItem1.Product__r.name.contains('-60H')){
                    newPage.getParameters().put(cellquantity,'60');
                }
                if(orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('-72H')){
                    newPage.getParameters().put(cellquantity,'144');
                }
                if(orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('-72') && !orderItem1.Product__r.name.contains('-72H')){
                    newPage.getParameters().put(cellquantity,'72');
                }
                    //2020-6-23新增
                    if(orderItem1.Product__r.name.contains('JKM') && (orderItem1.Product__r.name.contains('-78H') || orderItem1.Product__r.name.contains('7R'))){
                        newPage.getParameters().put(cellquantity,'156');
                    }
                    if(orderItem1.Product__r.name.contains('JKM') && (orderItem1.Product__r.name.contains('-66H') || orderItem1.Product__r.name.contains('6R'))){
                        newPage.getParameters().put(cellquantity,'132');
                    }
                    if(orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('7T')){
                        newPage.getParameters().put(cellquantity,'144');
                    }
                    if(orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('6T')){
                        newPage.getParameters().put(cellquantity,'120');
                    }
                newPage.getParameters().put(productId1,orderItem1.Product__c);
                
                newPage.getParameters().put(quantityId1,String.valueOf(orderItem1.Quantity__c).substring(0, String.valueOf(orderItem1.Quantity__c).indexOf('.')));
              
                system.debug('Cable_Length__c-------------->'+orderItem1.Cable_Length__c);
                    //  String_Ribbon__c
                    if(orderItem1.Product__r.name.contains('B') && !orderItem1.Product__r.name.contains('BD') && !orderItem1.Product__r.name.contains('MBB')){
                        newPage.getParameters().put(StringRibbon,'Black ribbon for All-Black modules');
                        newPage.getParameters().put(CellColor,'Dark blue for All-Black modules');
                        
                        
                    }else{
                        newPage.getParameters().put(StringRibbon,'Silver ribbon');
                       newPage.getParameters().put(CellColor,'Decide by factory');
                    }
                    //frame type
                if((orderItem1.Product__r.name.contains('-72') || orderItem1.Product__r.name.contains('78') || orderItem1.Product__r.name.contains('7RL3')|| orderItem1.Product__r.name.contains('7RL4')|| orderItem1.Product__r.name.contains('7TL4') )&&!orderItem1.Product__r.name.contains('B-')){
                        newPage.getParameters().put(StringFrameType,'Std.Nextracker Frame');
                    }
                    ////Module Series 2020-07-14
                if(orderItem1.Product__r.name.contains('L4')){
                        newPage.getParameters().put(StringSeries1,'Tiger Pro Series(182)');
                    }
                 
                if(orderItem1.Cable_Length__c=='900mm'||orderItem1.Cable_Length__c=='1200mm'){
                    newPage.getParameters().put(cableLength,orderItem1.Cable_Length__c);
                }else{
                    newPage.getParameters().put(cableLength,'other');
                }
               /** if(con.Warranty_On_Material_and_Workmanship__c == '10 linear warranty'){
                    newPage.getParameters().put(warranty,'Linear');
                }else if(con.Warranty_On_Material_and_Workmanship__c == '10 standard warranty'){
                    newPage.getParameters().put(warranty,'Standard');
                }else {
                    newPage.getParameters().put(warranty,'Customized');
                }*/
                if(con.Shipping_type__c=='Ocean transportation'){//Transportation style
                    newPage.getParameters().put(tranStyle,'Sea');
                }else if(con.Shipping_type__c=='Land transportation'){
                    newPage.getParameters().put(tranStyle,'Land');
                }else if(con.Shipping_type__c=='Railway transportation'){
                    newPage.getParameters().put(tranStyle,'Railway');
                }else if(con.Shipping_type__c=='Air transportation'){
                    newPage.getParameters().put(tranStyle,'  Air');
                }else if(con.Shipping_type__c=='Express delivery'){
                    newPage.getParameters().put(tranStyle,'Express delivery');
                }
                
                if(con.Destination_Country__c=='Australia'){
                     newPage.getParameters().put(ProductCertificate,'IEC61215:2016 (TUV certified)');
                  
                    }else if(con.Destination_Country__c=='United States' || con.Destination_Country__c=='Canada' ){//美国和加拿大
                        newPage.getParameters().put(ProductCertificate,'Dual IEC61215 & UL');
                        
                    }else{//其它国家
                         newPage.getParameters().put(ProductCertificate,'IEC61215: 2005 (TUV certified)');
                       
                    }
                
                
                 //Junction Box Connector
                    if(con.Region__c=='EU(Union)' || con.Region__c=='EU(Non-Eu)'){
                        newPage.getParameters().put(JunctionBoxConnector,'Other');
                       
                    }else{
                        newPage.getParameters().put(JunctionBoxConnector,'Standard');
                       
                    }
                
                
                
                if(con.Total_MW__c >7){
                      newPage.getParameters().put(CurrentSortingStyle,'Yes, Mixed current sorting allowed for the balance modules of every 7MW ');
                     newPage.getParameters().put(ColorSortingstyle,'Yes, Mixed color sorting allowed for the balance modules of every 7MW ');
                }else{
                     newPage.getParameters().put(CurrentSortingStyle,'Yes, Mixed current sorting allowed for the balance modules ');
                    newPage.getParameters().put(ColorSortingstyle,'Yes, Mixed color sorting allowed for the balance modules');
                }
                
                
                if(con.Destination_Country__c=='Thailand'){
                    newPage.getParameters().put(ShippingMark,'Jinko Solar');
                }else{
                    newPage.getParameters().put(ShippingMark,'Jinko Standard');
                }
                
                
                
                  if((orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('V'))){
                    newPage.getParameters().put(SystemVoltage,'1500V');
                  }else if((orderItem1.Product__r.name.contains('JKM') && !(orderItem1.Product__r.name.contains('V')))){
                      newPage.getParameters().put(SystemVoltage,'1000V');
                  }else {
                      newPage.getParameters().put(SystemVoltage,'Others');
                  }
                
                           
                  if((orderItem1.Product__r.name.contains('-72H') || orderItem1.Product__r.name.contains('-60H') || orderItem1.Product__r.name.contains('TV')|| 
                     orderItem1.Product__r.name.contains('BDVP')|| orderItem1.Product__r.name.contains('BDV')|| orderItem1.Product__r.name.contains('DV') ||
                     orderItem1.Product__r.name.contains('-78H')|| orderItem1.Product__r.name.contains('-66H')|| orderItem1.Product__r.name.contains('7RL3') ||
                     orderItem1.Product__r.name.contains('6RL3')|| orderItem1.Product__r.name.contains('6TL3'))){
                    newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                  }else if(orderItem1.Product__r.name.contains('JKMS')){
                      newPage.getParameters().put(JunctionBoxType,'Other');
                  }else {
                      newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                  }
                
                
                
                 if(con.Destination_Country__c=='Australia'||con.Region__c=='EU(Union)' || con.Region__c=='EU(Non-Eu)' ||
                  (con.Destination_Country__c=='Japan' && (orderItem1.Product__r.name.contains('72') )) ||
                  (con.Destination_Country__c=='United States' && (orderItem1.Product__r.name.contains('-72-') ||orderItem1.Product__r.name.contains('-72L-') ))
                  ){
                      newPage.getParameters().put(JunctionBoxCableLength,'1200mm');
                  }else if((con.Destination_Country__c=='Japan' && (orderItem1.Product__r.name.contains('60')))||
                  (con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-60-') ||orderItem1.Product__r.name.contains('-60L-') ))
                 ){
                       newPage.getParameters().put(JunctionBoxCableLength,'1000mm');
    
                  }else if(
                  con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-72HL')||orderItem1.Product__r.name.contains('-72H'))){
                      newPage.getParameters().put(JunctionBoxCableLength,'1400mm for US');
                  }else if(
                   con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-60HL')|| orderItem1.Product__r.name.contains('-60H'))){
               newPage.getParameters().put(JunctionBoxCableLength,'1825mm for US');
                  }
                
                
                }
                /*
                //2020/10/12
                //JKMXXXM-60(-V)
                if(orderItem1.Product__r.name.contains('M-60')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                  //JKMXXXM-60H(-V)
                if(orderItem1.Product__r.name.contains('M-60H')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                 //JKMXXXM-72(-V)
                if(orderItem1.Product__r.name.contains('M-72')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                //JKMXXXM-72H(-V)
                if(orderItem1.Product__r.name.contains('M-72H')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                //JKMXXXM-60B
                if(orderItem1.Product__r.name.contains('M-60B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Black');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                 //JKMXXXM-60HB
                if(orderItem1.Product__r.name.contains('M-60HB')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Black');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                 //JKMXXXM-72B
                if(orderItem1.Product__r.name.contains('M-72B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Black Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                //JKMXXXM-72HB
                if(orderItem1.Product__r.name.contains('M-72HB')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Black Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                //JKMXXXM-66H
                if(orderItem1.Product__r.name.contains('M-66H')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                //JKMXXXM-78H
                if(orderItem1.Product__r.name.contains('M-78H')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for 60pcs&66pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules');
                }
                
                //JKMXXXM-72H-TV
                if(orderItem1.Product__r.name.contains('M-72H-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                }
                
                //JKMXXXM-78H-TV
                if(orderItem1.Product__r.name.contains('M-78H-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for 60pcs&66pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules');
                   
                }
                
               
                
                //JKMXXXM-6TL3
                if(orderItem1.Product__r.name.contains('M-6TL3')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                   
                }
                
                //JKMXXXM-6RL3
                if(orderItem1.Product__r.name.contains('M-6RL3')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                   
                }

                //JKMXXXM-7RL3
                if(orderItem1.Product__r.name.contains('M-7RL3')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for 60pcs&66pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules');
                   
                }

                //JKMXXXM-6TL3-TV
                if(orderItem1.Product__r.name.contains('M-6TL3-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                   
                }
                
                 //JKMXXXM-6RL3-TV
                if(orderItem1.Product__r.name.contains('M-6RL3-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                   
                }

                //JKMXXXM-7RL3-TV
                if(orderItem1.Product__r.name.contains('M-7RL3-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Silver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for 60pcs&66pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules');
                   
                } 
                //JKMXXXM-6TL3-B
                 if(orderItem1.Product__r.name.contains('M-6TL3-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Black');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                   
                } 
                
                //JKMXXXM-6RL3-B
                 if(orderItem1.Product__r.name.contains('M-6RL3-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Black');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products');
                   
                }
                
                 //JKMXXXM-7RL3-B
                 if(orderItem1.Product__r.name.contains('M-7RL3-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Black Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for 60pcs&66pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                //JKMXXXN-6TL3-B
                 if(orderItem1.Product__r.name.contains('N-6TL3-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black+Black backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Black');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXN-6RL3-B
                 if(orderItem1.Product__r.name.contains('N-6RL3-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black+Black backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Standard Black');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXN-7RL3-B
                 if(orderItem1.Product__r.name.contains('N-7RL3-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black+Black backsheet');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass module');
                    newPage.getParameters().put(StringFrameType,'Black Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for 60pcs&66pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Black ribbon for All-black modules');
                    newPage.getParameters().put(LRF,'Shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                //JKMXXXM-72H-BDVP
                 if(orderItem1.Product__r.name.contains('M-72H-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Ceramic grid glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-78H-BDVP
                 if(orderItem1.Product__r.name.contains('M-78H-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Ceramic grid glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'Decided by factory');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-72HL3-BDVP
                 if(orderItem1.Product__r.name.contains('M-72HL3-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Ceramic grid glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-78HL3-BDVP
                 if(orderItem1.Product__r.name.contains('M-78HL3-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Ceramic grid glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Framet');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-7RL3-BDVP
                 if(orderItem1.Product__r.name.contains('M-7RL3-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent Glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-72H-MBB-BDVP
                 if(orderItem1.Product__r.name.contains('M-72H-MBB-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Ceramic grid glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-78H-MBB-BDVP
                 if(orderItem1.Product__r.name.contains('M-78H-MBB-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Ceramic grid glass for DV');
                    newPage.getParameters().put(EVA,'Transparent');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                //JKMXXXM-7TL4
                 if(orderItem1.Product__r.name.contains('M-7TL4')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for Tiger Pro 72pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                
                 //JKMXXXM-7RL4
                 if(orderItem1.Product__r.name.contains('M-7RL4')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for Tiger Pro 72pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                //JKMXXXM-72HL4
                 if(orderItem1.Product__r.name.contains('M-72HL4')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for Tiger Pro 72pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                 //JKMXXXM-7TL4-TV
                 if(orderItem1.Product__r.name.contains('M-7TL4-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for Tiger Pro 72pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                
                //JKMXXXM-7RL4-TV
                 if(orderItem1.Product__r.name.contains('M-7RL4-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for Tiger Pro 72pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                //JKMXXXM-72HL4-TV
                 if(orderItem1.Product__r.name.contains('M-72HL4-TV')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent backsheet for Bifacial Module');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'35mm for Tiger Pro 72pcs&78pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 31pcs/pallet for 35mm frame modules'); 
                }
                
                 //JKMXXXM-7TL4-BDVP
                 if(orderItem1.Product__r.name.contains('M-7TL4-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent Glass for DV');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                
                  //JKMXXXM-7RL4-BDVP
                 if(orderItem1.Product__r.name.contains('M-7RL4-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent Glass for DV');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                
                 //JKMXXXM-7RL4-BDVP
                 if(orderItem1.Product__r.name.contains('M-7RL4-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent Glass for DV');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                
                
                 //JKMXXXM-72HL4-BDVP
                 if(orderItem1.Product__r.name.contains('M-72HL4-BDVP')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Transparent Glass for DV');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-2.0mm for dual-glass module');
                    newPage.getParameters().put(StringFrameType,'Sliver Nextracker Frame');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for dual-glass modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                 //JKMXXXM-6TL4
                 if(orderItem1.Product__r.name.contains('M-6TL4')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Std. white');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                
                 //JKMXXXM-6TL4-B
                 if(orderItem1.Product__r.name.contains('M-6TL4-B')){
                     newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                    newPage.getParameters().put(JunctionBoxConnector,'Standard_JK03M');
                    newPage.getParameters().put(Rearcover,'Black(inside)+White(air side) backsheet');
                    newPage.getParameters().put(EVA,'Decided by factory');
                    newPage.getParameters().put(FrontGlass,'ARC-3.2mm for single-glass modules');
                    newPage.getParameters().put(StringFrameType,'Standard Silver');
                    newPage.getParameters().put(FrameBsideHeight,'30mm for 60pcs&66pcs&72pcs modules');
                    newPage.getParameters().put(StringRibbon,'Silver ribbon');
                    newPage.getParameters().put(LRF,'shall not use');
                    newPage.getParameters().put(Package1,'New: 5-layer wrapping carton + 35pcs/pallet for 30mm frame products'); 
                }
                */
            }
            
            
            
            
            
            if(orderItemList.size()>=2){  
                
                newPage.getParameters().put(productName2,orderItem2.Product_Name__c);
                 
                if(orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('-60H')){
                    newPage.getParameters().put(cellquantity2,'120');
                }
                if(orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('-60') && !orderItem2.Product__r.name.contains('-60H')){
                    newPage.getParameters().put(cellquantity2,'60');
                }
                if(orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('-72H')){
                    newPage.getParameters().put(cellquantity2,'144');
                }
                if(orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('-72') && !orderItem2.Product__r.name.contains('-72H')){
                    newPage.getParameters().put(cellquantity2,'72');
                }
                //2020-6-23新增
                if(orderItem2.Product__r.name.contains('JKM') && (orderItem2.Product__r.name.contains('-78H') || orderItem2.Product__r.name.contains('7R'))){
                    newPage.getParameters().put(cellquantity2,'156');
                }
                if(orderItem2.Product__r.name.contains('JKM') && (orderItem2.Product__r.name.contains('-66H') || orderItem2.Product__r.name.contains('6R'))){
                    newPage.getParameters().put(cellquantity2,'132');
                }
                if(orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('7T')){
                    newPage.getParameters().put(cellquantity2,'144');
                }
                if(orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('6T')){
                    newPage.getParameters().put(cellquantity2,'120');
                }
                newPage.getParameters().put(productId2,orderItem2.Product__c);
                newPage.getParameters().put(quantityId2,String.valueOf(orderItem2.Quantity__c).substring(0, String.valueOf(orderItem2.Quantity__c).indexOf('.')));
                
                
                                 if((orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('V'))||
                    (orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('V'))){
                    newPage.getParameters().put(SystemVoltage,'1500V');
                  }else if((orderItem1.Product__r.name.contains('JKM') && !(orderItem1.Product__r.name.contains('V'))) ||
                          (orderItem2.Product__r.name.contains('JKM') && !(orderItem2.Product__r.name.contains('V')))
                          ){
                      newPage.getParameters().put(SystemVoltage,'1000V');
                  }else {
                      newPage.getParameters().put(SystemVoltage,'Others');
                  }
                //Module Series 2020-07-14
        if(orderItem1.Product__r.name.contains('L4')){
                        newPage.getParameters().put(StringSeries1,'Tiger Pro Series(182)');
                    }
                 if(orderItem2.Product__r.name.contains('L4')){
                        newPage.getParameters().put(StringSeries2,'Tiger Pro Series(182)');
                    }
                                  
                  if((orderItem1.Product__r.name.contains('-72H') || orderItem1.Product__r.name.contains('-60H') || orderItem1.Product__r.name.contains('TV')|| 
                     orderItem1.Product__r.name.contains('BDVP')|| orderItem1.Product__r.name.contains('BDV')|| orderItem1.Product__r.name.contains('DV') ||
                     orderItem1.Product__r.name.contains('-78H')|| orderItem1.Product__r.name.contains('-66H')|| orderItem1.Product__r.name.contains('7RL3') ||
                     orderItem1.Product__r.name.contains('6RL3')|| orderItem1.Product__r.name.contains('6TL3'))||     
                    (orderItem2.Product__r.name.contains('-72H') || orderItem2.Product__r.name.contains('-60H') || orderItem2.Product__r.name.contains('TV')|| 
                     orderItem2.Product__r.name.contains('BDVP')|| orderItem2.Product__r.name.contains('BDV')|| orderItem2.Product__r.name.contains('DV')) ||
                     orderItem2.Product__r.name.contains('-78H')|| orderItem2.Product__r.name.contains('-66H')|| orderItem2.Product__r.name.contains('7RL3') ||
                     orderItem2.Product__r.name.contains('6RL3')|| orderItem2.Product__r.name.contains('6TL3')
                   ){
                    newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                  }else if(orderItem1.Product__r.name.contains('JKMS') ||
                          orderItem2.Product__r.name.contains('JKMS')  
                        
                          ){
                      newPage.getParameters().put(JunctionBoxType,'Other');
                  }else {
                      newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                  }
                
                
                
                 if(con.Destination_Country__c=='Australia'||con.Region__c=='EU(Union)' || con.Region__c=='EU(Non-Eu)' ||
                  (con.Destination_Country__c=='Japan' && (orderItem1.Product__r.name.contains('72')||orderItem2.Product__r.name.contains('72')))||
                  (con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-72-')||orderItem2.Product__r.name.contains('-72-')|| 
                  orderItem1.Product__r.name.contains('-72L-')||orderItem2.Product__r.name.contains('-72L-')))
                  ){
                      newPage.getParameters().put(JunctionBoxCableLength,'1200mm');
                  }else if((con.Destination_Country__c=='Japan' && (orderItem1.Product__r.name.contains('60')||orderItem2.Product__r.name.contains('60')))||
                  (con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-60-')||orderItem2.Product__r.name.contains('-60-')||
                                                                   orderItem1.Product__r.name.contains('-60L-')||orderItem2.Product__r.name.contains('-60L-')))      
               ){
                       newPage.getParameters().put(JunctionBoxCableLength,'1000mm');
    
                  }else if(
                  con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-72HL')||orderItem2.Product__r.name.contains('-72HL')||
                  orderItem1.Product__r.name.contains('-72H')||orderItem2.Product__r.name.contains('-72H'))
                  ){
                      newPage.getParameters().put(JunctionBoxCableLength,'1400mm for US');
                  }else if(
                   con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-60HL')||orderItem2.Product__r.name.contains('-60HL')||
                  orderItem1.Product__r.name.contains('-60H')||orderItem2.Product__r.name.contains('-60H'))
                  ){
               newPage.getParameters().put(JunctionBoxCableLength,'1825mm for US');
                  }
                     
            }
            
            
            if(orderItemList.size()>=3){
                newPage.getParameters().put(productName3,orderItem3.Product_Name__c);
                if(orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('-60H')){
                    newPage.getParameters().put(cellquantity3,'120');
                }
                if(orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('-60') && !orderItem3.Product__r.name.contains('-60H')){
                    newPage.getParameters().put(cellquantity3,'60');
                }
                if(orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('-72H')){
                    newPage.getParameters().put(cellquantity3,'144');
                }
                if(orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('-72') && !orderItem3.Product__r.name.contains('-72H')){
                    newPage.getParameters().put(cellquantity3,'72');
                }
                //2020-6-23新增
                if(orderItem3.Product__r.name.contains('JKM') && (orderItem3.Product__r.name.contains('-78H') || orderItem3.Product__r.name.contains('7R'))){
                    newPage.getParameters().put(cellquantity3,'156');
                }
                if(orderItem3.Product__r.name.contains('JKM') && (orderItem3.Product__r.name.contains('-66H') || orderItem3.Product__r.name.contains('6R'))){
                    newPage.getParameters().put(cellquantity3,'132');
                }
                if(orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('7T')){
                    newPage.getParameters().put(cellquantity3,'144');
                }
                if(orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('6T')){
                    newPage.getParameters().put(cellquantity3,'120');
                }
                //Module Series 2020-07-14
                if(orderItem1.Product__r.name.contains('L4')){
                        newPage.getParameters().put(StringSeries1,'Tiger Pro Series(182)');
                    }
                 if(orderItem2.Product__r.name.contains('L4')){
                        newPage.getParameters().put(StringSeries2,'Tiger Pro Series(182)');
                    }
                 if(orderItem3.Product__r.name.contains('L4')){
                        newPage.getParameters().put(StringSeries3,'Tiger Pro Series(182)');
                    }
                newPage.getParameters().put(productId3,orderItem3.Product__c);
newPage.getParameters().put(quantityId3,String.valueOf(orderItem3.Quantity__c).substring(0, String.valueOf(orderItem3.Quantity__c).indexOf('.')));
                
                                 if((orderItem1.Product__r.name.contains('JKM') && orderItem1.Product__r.name.contains('V'))||
                    (orderItem2.Product__r.name.contains('JKM') && orderItem2.Product__r.name.contains('V'))||
                    (orderItem3.Product__r.name.contains('JKM') && orderItem3.Product__r.name.contains('V'))){
                    newPage.getParameters().put(SystemVoltage,'1500V');
                  }else if((orderItem1.Product__r.name.contains('JKM') && !(orderItem1.Product__r.name.contains('V'))) ||
                          (orderItem2.Product__r.name.contains('JKM') && !(orderItem2.Product__r.name.contains('V')))||
                          (orderItem3.Product__r.name.contains('JKM') && !(orderItem3.Product__r.name.contains('V')))  
                          ){
                      newPage.getParameters().put(SystemVoltage,'1000V');
                  }else {
                      newPage.getParameters().put(SystemVoltage,'Others');
                  }
                
                           
                  if((orderItem1.Product__r.name.contains('-72H') || orderItem1.Product__r.name.contains('-60H') || orderItem1.Product__r.name.contains('TV')|| 
                     orderItem1.Product__r.name.contains('BDVP')|| orderItem1.Product__r.name.contains('BDV')|| orderItem1.Product__r.name.contains('DV')||
                     orderItem1.Product__r.name.contains('-78H')|| orderItem1.Product__r.name.contains('-66H')|| orderItem1.Product__r.name.contains('7RL3') ||
                     orderItem1.Product__r.name.contains('6RL3')|| orderItem1.Product__r.name.contains('6TL3'))||     
                    (orderItem2.Product__r.name.contains('-72H') || orderItem2.Product__r.name.contains('-60H') || orderItem2.Product__r.name.contains('TV')|| 
                     orderItem2.Product__r.name.contains('BDVP')|| orderItem2.Product__r.name.contains('BDV')|| orderItem2.Product__r.name.contains('DV')||
                     orderItem2.Product__r.name.contains('-78H')|| orderItem2.Product__r.name.contains('-66H')|| orderItem2.Product__r.name.contains('7RL3') ||
                     orderItem2.Product__r.name.contains('6RL3')|| orderItem2.Product__r.name.contains('6TL3'))||
                    (orderItem3.Product__r.name.contains('-72H') || orderItem3.Product__r.name.contains('-60H') || orderItem3.Product__r.name.contains('TV')|| 
                     orderItem3.Product__r.name.contains('BDVP')|| orderItem3.Product__r.name.contains('BDV')|| orderItem3.Product__r.name.contains('DV')||
                     orderItem3.Product__r.name.contains('-78H')|| orderItem3.Product__r.name.contains('-66H')|| orderItem3.Product__r.name.contains('7RL3') ||
                     orderItem3.Product__r.name.contains('6RL3')|| orderItem3.Product__r.name.contains('6TL3'))){
                    newPage.getParameters().put(JunctionBoxType,'Jinko Split');
                  }else if(orderItem1.Product__r.name.contains('JKMS') ||
                          orderItem2.Product__r.name.contains('JKMS')  ||
                          orderItem3.Product__r.name.contains('JKMS')    
                          ){
                      newPage.getParameters().put(JunctionBoxType,'Other');
                  }else {
                      newPage.getParameters().put(JunctionBoxType,'Jinko Integrate');
                  }
                
                
                
                 if(con.Destination_Country__c=='Australia'||con.Region__c=='EU(Union)' || con.Region__c=='EU(Non-Eu)' ||
                  (con.Destination_Country__c=='Japan' && (orderItem1.Product__r.name.contains('72')||orderItem2.Product__r.name.contains('72')||
                  orderItem3.Product__r.name.contains('72'))) ||
                  (con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-72-')||orderItem2.Product__r.name.contains('-72-')||orderItem3.Product__r.name.contains('-72-')||
                    orderItem1.Product__r.name.contains('-72L-')||orderItem2.Product__r.name.contains('-72L-')||orderItem3.Product__r.name.contains('-72L-')))
                  ){
                      newPage.getParameters().put(JunctionBoxCableLength,'1200mm');
                  }else if((con.Destination_Country__c=='Japan' && (orderItem1.Product__r.name.contains('60')||orderItem2.Product__r.name.contains('60')||orderItem3.Product__r.name.contains('60')))||
                  (con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-60-')||orderItem2.Product__r.name.contains('-60-')||orderItem3.Product__r.name.contains('-60-')||
                                                                   orderItem1.Product__r.name.contains('-60L-')||orderItem2.Product__r.name.contains('-60L-')||orderItem3.Product__r.name.contains('-60L-')
                                                                   ))      
                  ){
                       newPage.getParameters().put(JunctionBoxCableLength,'1000mm');
    
                  }else if(
                  con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-72HL')||orderItem2.Product__r.name.contains('-72HL')||orderItem3.Product__r.name.contains('-72HL')||
                  orderItem1.Product__r.name.contains('-72H')||orderItem2.Product__r.name.contains('-72H')||orderItem3.Product__r.name.contains('-72H'))
                  ){
                      newPage.getParameters().put(JunctionBoxCableLength,'1400mm for US');
                  }else if(
                   con.Destination_Country__c=='United States' &&  (orderItem1.Product__r.name.contains('-60HL')||orderItem2.Product__r.name.contains('-60HL')||orderItem3.Product__r.name.contains('-60HL')||
                  orderItem1.Product__r.name.contains('-60H')||orderItem2.Product__r.name.contains('-60H')||orderItem3.Product__r.name.contains('-60H'))
                  ){
               newPage.getParameters().put(JunctionBoxCableLength,'1825mm for US');
                  }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }

            return newPage;
            
       // }catch(Exception e){return null; }  
        return null;
    }
}