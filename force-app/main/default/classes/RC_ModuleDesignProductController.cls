public class RC_ModuleDesignProductController {
    public String conId = ''; 
    public String conNumber = ''; 
    public String pageId = ''; 
    public String ordName = ''; 
    public String ordId = ''; 
    public String productName1 = ''; 
    public String productId1 = ''; 
    public String productName2 = ''; 
    public String productId2 = ''; 
    public String productName3 = ''; 
    public String productId3 = ''; 
    public String MandatoryCertification = ''; 
    public String quantityId1 = ''; 
    public String quantityId2 = ''; 
    public String cellquantity = ''; 
    public String cellquantity2 = ''; 
    public String cellquantity3 = ''; 
    public String quantityId3 = ''; 
    public String cableLength = ''; 
    public String powertolerance = ''; 
    public String warranty = ''; 
    public String id1 = ''; 
    public String id2 = ''; 
    public String id3 = ''; 
    public String ProductCertificate = ''; 
    public String JunctionBoxConnector = ''; 
    public String SystemVoltage = ''; 
    public String CurrentSortingStyle = ''; 
    public String ColorSortingstyle = ''; 
    public String tranStyle = ''; 
    public String ShippingMark = ''; 
    public String Mandatorycerti = ''; 
    public String JunctionBoxType = ''; 
    public String JunctionBoxCableLength = ''; 
    public String iContract = ''; 
    public String ItemId = ''; 
    public String ItemName = ''; 

    public RC_ModuleDesignProductController (ApexPages.StandardSetController controller) {
        id1 = ApexPages.currentPage().getParameters().get('p1'); 
        id2 = ApexPages.currentPage().getParameters().get('p2'); 
        id3 = ApexPages.currentPage().getParameters().get('p3'); 
        System.debug('====id1: ' + id1); 
        System.debug('====id2: ' + id2); 
        System.debug('====id3: ' + id3); 

        ModuleDesignParam__c mdp = ModuleDesignParam__c.getOrgDefaults(); 
        if (mdp.Module_Design_Id__c != null)pageId = mdp.Module_Design_Id__c; 
        if (mdp.Module_Design_Order_Name__c != null)ordName = mdp.Module_Design_Order_Name__c; 
        if (mdp.Module_Design_Order_Id__c != null)ordId = mdp.Module_Design_Order_Id__c; 
        if (mdp.Module_Design_Product_Name__c != null)productName1 = mdp.Module_Design_Product_Name__c; 
        if (mdp.Module_Design_Product_Id__c != null)productId1 = mdp.Module_Design_Product_Id__c; 
        if (mdp.Module_Design_Product_Name2__c != null)productName2 = mdp.Module_Design_Product_Name2__c; 
        if (mdp.Module_Design_Product_Id2__c != null)productId2 = mdp.Module_Design_Product_Id2__c; 
        if (mdp.Module_Design_Product_Cell_Quantity__c != null)cellquantity = mdp.Module_Design_Product_Cell_Quantity__c; 
        if (mdp.Module_Design_Product_Cell_Quantity2__c != null)cellquantity2 = mdp.Module_Design_Product_Cell_Quantity2__c; 
        if (mdp.Module_Design_Product_Cell_Quantity3__c != null)cellquantity3 = mdp.Module_Design_Product_Cell_Quantity3__c; 
        if (mdp.Module_Design_Product_Name3__c != null)productName3 = mdp.Module_Design_Product_Name3__c; 
        if (mdp.Module_Design_Product_Id3__c != null)productId3 = mdp.Module_Design_Product_Id3__c; 
        if (mdp.Module_Design_Product_Quantity__c != null)quantityId1 = mdp.Module_Design_Product_Quantity__c; 
        if (mdp.Module_Design_Product_Quantity2__c != null)quantityId2 = mdp.Module_Design_Product_Quantity2__c; 
        if (mdp.Module_Design_Product_Quantity3__c != null)quantityId3 = mdp.Module_Design_Product_Quantity3__c; 
        if (mdp.Module_Design_ContractNumber__c != null)conNumber = mdp.Module_Design_ContractNumber__c; 
        if (mdp.Module_Design_Contract_Id__c != null)conId = mdp.Module_Design_Contract_Id__c; 
        if (mdp.Module_Design_Cable_Length__c != null)cableLength = mdp.Module_Design_Cable_Length__c; 
        if (mdp.Module_Design_Power_tolerance__c != null)powertolerance = mdp.Module_Design_Power_tolerance__c; 
        if (mdp.Module_Design_Warranty__c != null)warranty = mdp.Module_Design_Warranty__c; 
        //新增
        if (mdp.Module_Design_Transportation_style__c != null)tranStyle = mdp.Module_Design_Transportation_style__c; //旧
        if (mdp.ProductCertificate__c != null)ProductCertificate = mdp.ProductCertificate__c; 
        if (mdp.Junction_Box_Connector__c != null)JunctionBoxConnector = mdp.Junction_Box_Connector__c; 
        if (mdp.System_Voltage__c != null)SystemVoltage = mdp.System_Voltage__c; 
        if (mdp.Current_Sorting_Style__c != null)CurrentSortingStyle = mdp.Current_Sorting_Style__c; 
        if (mdp.Color_Sorting_style__c != null)ColorSortingstyle = mdp.Color_Sorting_style__c; 
        if (mdp.Shipping_Mark__c != null)ShippingMark = mdp.Shipping_Mark__c; 
        if (mdp.Junction_Box_Type__c != null)JunctionBoxType = mdp.Junction_Box_Type__c; 
        if (mdp.Junction_Box_Cable_Length__c != null)JunctionBoxCableLength = mdp.Junction_Box_Cable_Length__c; 

        if (mdp.Module_Design_Product_Item_Id__c != null)ItemId = mdp.Module_Design_Product_Item_Id__c; 
        if (mdp.Module_Design_Product_Item_Name__c != null)ItemName = mdp.Module_Design_Product_Item_Name__c; 
        //增加根据交货地址来初始化默认值
        if (mdp.Mandatory_certification__c != null)MandatoryCertification = mdp.Mandatory_certification__c; 
        if (mdp.iContract__c != null)iContract = mdp.iContract__c; 
        System.debug('----cableLength' + pageId); 
    }

    public PageReference goto() {
        String itemObject = ApexPages.currentPage().getParameters().get('itemObject'); 
        List<SObject> items = Database.query(
            QW_Utils.getQueryBySObjectType(itemObject, new List<String>{'Product__r.Name'}) + 
            ' WHERE Id = \'' + id1 + '\'' + 
            ' OR Id = \'' + id2 + '\'' + 
            ' OR Id = \'' + id3 + '\''); 
        PageReference newPage = new PageReference(pageId); 

        List<String> cellQuantityIds = new List<String>{cellquantity, cellquantity2, cellquantity3}; 
        List<String> productIds = new List<String>{productId1, productId2, productId3}; 
        List<String> quantityIds = new List<String>{quantityId1, quantityId2, quantityId3}; 
        List<String> systemVoltages = new List<String>{'1000V', '1500V'}; 
        List<String> junctionBoxTypes = new List<String>{'晶科标准-一体', '晶科标准-分体'}; 

        for (Integer index = 0; index < items.size(); index++) {
            String productName = items[index].getSObject('Product__r') != null?((String)items[index].getSObject('Product__r').get('Name')):(String)items[index].get('Name'); 
            if (productName.contains('JKM') && productName.contains('-60H'))newPage.getParameters().put(cellQuantityIds[index], '120'); 
            else if (productName.contains('JKM') && productName.contains('-60'))newPage.getParameters().put(cellQuantityIds[index], '60'); 
            else if (productName.contains('JKM') && productName.contains('-72H'))newPage.getParameters().put(cellQuantityIds[index], '144'); 
            else if (productName.contains('JKM') && productName.contains('-72'))newPage.getParameters().put(cellQuantityIds[index], '72'); 

            // TODO - MDA
            newPage.getParameters().put(productIds[index], (String)items[index].get('Product__c')); 
            newPage.getParameters().put(quantityIds[index], String.valueOf(items[index].get('Quantity__c'))); 

            String systemVoltageValue = newPage.getParameters().get(SystemVoltage) != null?newPage.getParameters().get(SystemVoltage):''; 
            if (productName.contains('JKM') && productName.contains('V') && systemVoltages.indexOf(systemVoltageValue) < systemVoltageValue.indexOf('1500V')) {
                newPage.getParameters().put(SystemVoltage, '1500V'); 
            } else if (productName.contains('JKM') && systemVoltages.indexOf(systemVoltageValue) < systemVoltageValue.indexOf('1000V')) {
                newPage.getParameters().put(SystemVoltage, '1000V'); 
            }

            String junctionBoxTypeValue = newPage.getParameters().get(JunctionBoxType) != null?newPage.getParameters().get(JunctionBoxType):''; 
            if ((productName.contains('-72H') || productName.contains('-60H') || productName.contains('TV') || 
                productName.contains('BDVP') || productName.contains('BDV') || productName.contains('DV')) && junctionBoxTypes.indexOf(junctionBoxTypeValue) < junctionBoxTypes.indexOf('晶科标准-分体')) {
                newPage.getParameters().put(JunctionBoxType, '晶科标准-分体'); 
            }
            // else if (productName.contains('JKMS') && junctionBoxTypes.indexOf(junctionBoxTypeValue) < junctionBoxTypes.indexOf('Other')) newPage.getParameters().put(JunctionBoxType, 'Other'); 
            else newPage.getParameters().put(JunctionBoxType, '晶科标准-一体'); 
        }
        return newPage; 
    }
}