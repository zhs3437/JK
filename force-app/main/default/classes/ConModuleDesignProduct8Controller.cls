public without sharing class ConModuleDesignProduct8Controller {
       public String MDAId1{get;set;}
    public String MDAId2{get;set;}
    public String query{get;set;}
   
     public String pageId{get;set;}
    public String OppId{get;set;}
     public String OpportunityId{get;set;}
     public String ConId{get;set;}
     public String ContractId{get;set;}
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
    
     public String  FrameColor	{get;set;}
     public String  GlassThickness			{get;set;}
     public String  ModuleLevel			{get;set;}
    public String  RearCoverMaterial			{get;set;}
    public String  Csidetypeofshortframe			{get;set;}
    public String  ColorLabel			{get;set;}
    public String  AdditionalShippingMark		{get;set;}
    
    
    public List<Component_Task_Book__c> MDA{get;set;}
    
    
    public ConModuleDesignProduct8Controller(ApexPages.StandardSetController controller) {
        ConId = ApexPages.currentPage().getParameters().get('ConId');
        MDAId1 = ApexPages.currentPage().getParameters().get('Id');
        MDAId2 = MDAId1.remove('\'');
        query='\''+String.escapeSingleQuotes(MDAId2)+'\'';
          system.debug('ConId-->'+ConId);
        system.debug('MDAId2'+'          '+MDAId2);
        system.debug('query'+'          '+query);
        ModuleDesignParam__c mdp = ModuleDesignParam__c.getOrgDefaults();
        pageId			                  = mdp.Module_Design_Id__c;
        OppId                             = mdp.OppId__c;
        ContractId                         = mdp.Module_Design_Contract_Id__c;
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
        FrameColor     =mdp.Frame_Color__c;
        GlassThickness =mdp.Glass_Thickness__c;
        ModuleLevel  =mdp.Module_Level__c;
        RearCoverMaterial =mdp.Rear_Cover_Material__c;
        Csidetypeofshortframe =mdp.C_side_type_of_short_frame__c;
        ColorLabel =mdp.Color_Label__c;
        AdditionalShippingMark =mdp.Additional_Shipping_Mark_Color_Label__c;
        
        
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
        MDA = Database.query('select'+SQLstring+',ModuleType1__r.Name,Opportunity__r.Name'+' from Component_Task_Book__c Where Id =  '+query+' Limit 1');
        system.debug('ContractId-->'+ContractId);
        Contract con =[Select id,Name,Opportunity__c from Contract where id =:ConId];
        List<Order> ord =[Select Id,ContractId from Order where ContractId =:con.Id];
        Component_Task_Book__c cloneMDA = new Component_Task_Book__c();
        cloneMDA = MDA[0];
        cloneMDA.Id = null;
        cloneMDA.Opportunity__c = con.Opportunity__c;
        cloneMDA.Contract__c = ConId;
        cloneMDA.Order__c = null;
        cloneMDA.iOrder__c = null;
        cloneMDA.iProject__c = null;
        cloneMDA.IsMDATemplate__c = false;
        cloneMDA.Technical_manager_Shanghai__c = null;
        if(ord.size()>0){
            cloneMDA.Order__c = ord[0].Id;
        }
        insert cloneMDA;
        pageId ='/'+cloneMDA.Id+'/e?retURL='+cloneMDA.Id;
        system.debug('MDA'+'        '+MDA);
        System.debug('pageId-->'+pageId);
        PageReference newPage = new PageReference(pageId);
        return newPage;
    }

}