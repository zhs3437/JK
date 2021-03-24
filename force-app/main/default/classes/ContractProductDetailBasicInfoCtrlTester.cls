@isTest
public class ContractProductDetailBasicInfoCtrlTester {
    private static testMethod void contractProduct(){
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id, false);
        insert con;
        Product2 p = TestHelper.createProduct2();
        
        Product_Detail__c pd = TestHelper.createProductDetail(false);
        pd.Contract_PO_PI__c = con.Id;
        insert pd;
        
        List<Product_Detail__c> pds = new List<Product_Detail__c>();
        pds.add(pd);
        
        Production_Schedule_Detail__c psd = new Production_Schedule_Detail__c();
        psd.Expected_Delivery_Date__c								= 'q';
        psd.Expected_ETD__c											= Date.today();
        psd.Expected_ex_Work_Date__c								= Date.today();
        psd.Product_Detail__c										= pd.Id;
        //psd.Production_Schedule_Detail__c.Product_Detail__r.name	= pd.Name;
        psd.Total_Price__c											= 2;
        psd.Unit_Price__c											= 1;
        psd.Product__c												= p.Id;
        psd.Remarks__c												= 'e';
        psd.Quantity__c												= 5;
        psd.Contract__c = con.Id;
        insert psd;
        
        List<Production_Schedule_Detail__c> psds = new List<Production_Schedule_Detail__c>();
        psds.add(psd);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        ContractProductDetailBasicInfoCtrl cpdbic = new ContractProductDetailBasicInfoCtrl(sc);
        cpdbic.editTheProduction();
        cpdbic.cancelTheProduction();
        //cpdbic.deleteTheProduction();
        cpdbic.saveTheProduction();
        cpdbic.runTest();
        //TODO 
        
    }

}