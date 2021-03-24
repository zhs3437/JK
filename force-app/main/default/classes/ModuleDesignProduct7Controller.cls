public without sharing class ModuleDesignProduct7Controller {   
    public String pageId{get;set;}
    public String OppId{get;set;}
    public String OpportunityId{get;set;}
    public String ConNNId{get;set;}
    public String OrderId{get;set;}
    public String ModuleDesignProductName{get;set;}
    public String CellType1{get;set;}
    public String ModuleSeries1{get;set;}
    public String ModuleDesignProductCellQuantity{get;set;}
    public String ProductCertificate{get;set;}
    public String AdditionalCertificate{get;set;}
    public String Mandatorycertification{get;set;}
    public String PowerTolerance{get;set;}
    public String SystemVoltage{get;set;}
    public String Additionalpower{get;set;}
    public String ModuleDesignWarranty{get;set;}
    public String ModuleDesignProductQuantity3{get;set;}
    public String Packages{get;set;}
    public String JunctionBoxType{get;set;}
    public String JunctionBoxCableLength{get;set;}
    public String JunctionBoxConnector{get;set;}
    public String Rearcover{get;set;}
    public String FrameB_sideHeight{get;set;}
    public String FrameType	{get;set;}
    public String EVA	{get;set;}
    public String LRF	{get;set;}
    public String ProjectType	{get;set;}
    public String  Ribbon	{get;set;}
    public String  CellColor	{get;set;}
    public String  CurrentSorting	{get;set;}
    public String  CurrentSortingStyle		{get;set;}
    public String  ColorSortingstyle		{get;set;}
    public String  ProductionsupervisionbyClientor3rd		{get;set;}
    public String  Pre_shippingInspectionfactory		{get;set;}
     public String SpecialApprovalfororderproduction		{get;set;}
     public String  Nameplate	{get;set;}
     public String  ShippingMark		{get;set;}
     public String  Barcodeencodingprinciple		{get;set;}
    public String  Transportationstyle		{get;set;}
    public String  Labtests		{get;set;}
    public String  Regionalcustomsclearancerequest		{get;set;}
    public String  FrontGlass		{get;set;}
     public String ProductId{get;set;}
    
    public List<Component_Task_Book__c> MDA{get;set;}
    
    
    public ModuleDesignProduct7Controller(ApexPages.StandardSetController controller) {
         OpportunityId = ApexPages.currentPage().getParameters().get('OppId');
         ProductId = ApexPages.currentPage().getParameters().get('p1');
        system.debug('OpportunityId'+'       '+OpportunityId);
        ModuleDesignParam__c mdp = ModuleDesignParam__c.getOrgDefaults();
        pageId			                  = mdp.Module_Design_Id__c;
        OppId                             = mdp.OppId__c;
        ConNNId                           = mdp.Module_Design_Contract_Id__c;
        OrderId                           = mdp.Module_Design_Order_Id__c;
        ModuleDesignProductName           = mdp.Module_Design_Product_Name__c; 
        CellType1           = mdp.CellType1__c; 
        ModuleSeries1           = mdp.Module_Series1__c; 
        ModuleDesignProductCellQuantity           = mdp.Module_Design_Product_Cell_Quantity__c; 
        ProductCertificate           = mdp.ProductCertificate__c;
        AdditionalCertificate           = mdp.Additional_Certificate__c; 
        Mandatorycertification           = mdp.Mandatory_certification__c; 
        PowerTolerance           = mdp.Power_Tolerance__c; 
        SystemVoltage           = mdp.System_Voltage__c; 
        Additionalpower           = mdp.Additional_power__c; 
        ModuleDesignWarranty           = mdp.Module_Design_Warranty__c;
       // ModuleDesignProductQuantity3           = mdp.Module_Design_Product_Quantity3__c;
        Packages           = mdp.Package__c;
        JunctionBoxType           = mdp.Junction_Box_Type__c;
        JunctionBoxCableLength           = mdp.Junction_Box_Cable_Length__c;
        JunctionBoxConnector           = mdp.Junction_Box_Connector__c;
        Rearcover           = mdp.Rear_cover__c;
        FrameB_sideHeight           = mdp.Frame_B_side_Height__c;
        FrameType           = mdp.Frame_Type__c;
        EVA           = mdp.EVA__c;
        LRF           = mdp.LRF__c;
        ProjectType           = mdp.Project_Type__c;
        Ribbon           = mdp.String_Ribbon__c;
        CellColor           = mdp.Cell_Color__c;
        CurrentSorting           = mdp.Current_Sorting__c;
        CurrentSortingStyle           = mdp.Current_Sorting_Style__c;
        ColorSortingstyle           = mdp.Color_Sorting_style__c;
        ProductionsupervisionbyClientor3rd           = mdp.Production_supervision_by_Client_or_3rd__c;
        Pre_shippingInspectionfactory           = mdp.Pre_shipping_Inspection_factory__c;
        SpecialApprovalfororderproduction           = mdp.Special_Approval_for_order_production__c;
        Nameplate           = mdp.Nameplate__c;
        ShippingMark           = mdp.Shipping_Mark__c;
        Barcodeencodingprinciple           = mdp.Barcode_encoding_principle__c;
        Transportationstyle           = mdp.Transportation_style__c;
        Labtests           = mdp.Lab_tests__c;
        Regionalcustomsclearancerequest           = mdp.Regional_customs_clearance_request__c;
        FrontGlass = mdp.Front_Glass__c;
        
        
        
            //增加根据交货地址来初始化默认值
            MandatoryCertification = mdp.Mandatory_certification__c;
        system.debug('----cableLength'+pageId);
    }

    public PageReference goto(){
        Map<String, Schema.SObjectField> MDAfieldMap = Component_Task_Book__c.sObjectType.getDescribe().fields.getMap();
        Set<String> fieldNames = MDAfieldMap.keySet();    
        String SQLstring = '';
        for(String str : fieldNames){
            if(SQLstring==''){
                SQLstring = ' '+str;
            }else{
                SQLstring = SQLstring+', '+str;
                }
        }
        
        MDA = new List<Component_Task_Book__c>();
        String TypeId= '0126F000001j8QD';
        MDA = Database.query('select'+SQLstring+',ModuleType1__r.Name,Opportunity__r.Name'+' from Component_Task_Book__c where RecordTypeId =:TypeId limit 20');
        Opportunity opp =[Select id,Name from Opportunity where id =:OpportunityId];
        OpportunityLineItem oppItem =[Select id,Name,Product2Id,Product2.Name from OpportunityLineItem where Id =:ProductId limit 1];
        system.debug('MDA' + MDA);
        system.debug('pageID-->'+pageID);
        PageReference newPage = new PageReference(pageId);
        newPage.getParameters().put(OppId,opp.Name);
        newPage.getParameters().put(ModuleDesignProductName,oppItem.Product2.Name);
        List<Contract> contracts =[Select id,Name,Opportunity__c,ContractNumber,Opportunity__r.Name from Contract where Opportunity__c =: opp.Id]; 
        if (contracts.size() > 0) {
            system.debug('ConNNId-->'+ConNNId);
            system.debug('contracts[0].Name-->'+ contracts[0].ContractNumber);
            newPage.getParameters().put(ConNNId, contracts[0].ContractNumber);
        }
        List<Order> ord =[Select Id,Name,ContractId,OrderNumber from Order where Opportunity__c =: opp.Id];
        if(ord.size()>0){
            system.debug('OrderId-->'+OrderId);
            system.debug('ord[0].Name-->'+ord[0].OrderNumber);
            newPage.getParameters().put(OrderId,ord[0].OrderNumber);
        }
        for(Component_Task_Book__c M : MDA){
        
            
            newPage.getParameters().put(CellType1,M.Cell_Type1__c);
            newPage.getParameters().put(ModuleSeries1,M.Module_Series1__c);
            newPage.getParameters().put(ModuleDesignProductCellQuantity,M.Cell_Quantity1__c);
            newPage.getParameters().put(ProductCertificate,M.Product_Certificate__c);
            newPage.getParameters().put(AdditionalCertificate,M.Additional_Certificate__c);
            newPage.getParameters().put(Mandatorycertification,M.Mandatory_certification__c);
            newPage.getParameters().put(PowerTolerance,M.Power_Tolerance__c);
            newPage.getParameters().put(SystemVoltage,M.System_Voltage__c);
            newPage.getParameters().put(Additionalpower,M.Additional_power__c);
            newPage.getParameters().put(ModuleDesignWarranty,M.Warranty__c);
            //newPage.getParameters().put(ModuleDesignProductQuantity3,M.BOM__c);
            
            newPage.getParameters().put(JunctionBoxType,M.Junction_Box_brand__c);
            newPage.getParameters().put(JunctionBoxCableLength,M.Junction_Box_Cable_Length__c);
            newPage.getParameters().put(JunctionBoxConnector,M.Junction_Box_Connector__c);
            newPage.getParameters().put(Rearcover,M.Rear_cover__c);
            newPage.getParameters().put(FrameType,M.Frame_Type__c);
            newPage.getParameters().put(FrameB_sideHeight,M.Frame_B_side_Height__c);
            
            newPage.getParameters().put(EVA,M.EVA__c);
            newPage.getParameters().put(LRF,M.LRF__c);
            
            newPage.getParameters().put(Ribbon,M.String_Ribbon__c);
            newPage.getParameters().put(CellColor,M.Cell_Color__c);
            newPage.getParameters().put(CurrentSorting,M.Current_Sorting__c);
            newPage.getParameters().put(CurrentSortingStyle,M.Current_Sorting_Style__c);
            newPage.getParameters().put(ProductionsupervisionbyClientor3rd,M.On_site_monitor_by_Client_or_3rd_party__c);
            newPage.getParameters().put(Pre_shippingInspectionfactory,M.Pre_shipping_Inspection_factory__c);
            newPage.getParameters().put(SpecialApprovalfororderproduction,M.Special_Approval_for_order_production__c);
            newPage.getParameters().put(Nameplate,M.Nameplate__c);
            newPage.getParameters().put(ShippingMark,M.Shipping_Mark__c);
            newPage.getParameters().put(Barcodeencodingprinciple,M.Barcode_encoding_principle__c);
            newPage.getParameters().put(Transportationstyle,M.Transportation_style__c);
            newPage.getParameters().put(Labtests,M.Lab_tests__c);
            newPage.getParameters().put(Regionalcustomsclearancerequest,M.Regional_customs_clearance_request__c);
            newPage.getParameters().put(FrontGlass,M.Front_Glass__c);
            newPage.getParameters().put(Packages,M.Package__c);
            newPage.getParameters().put(ProjectType,M.Project_Type__c);
            newPage.getParameters().put(ColorSortingstyle,M.Color_Sorting_style__c);
            newPage.getParameters().put(ColorSortingstyle,'0126F000001j8QD');
  
            
            
            
            
            
        }
       
        return newPage;
    }
}