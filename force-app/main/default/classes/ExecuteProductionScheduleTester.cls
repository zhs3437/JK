/**
 *Create By jason 20160923
 */
@isTest
private class ExecuteProductionScheduleTester {
    @isTest(SeeAllData=true)
    private static void clickNewButton() {
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '999';
        insert con;
        Product2 p = TestHelper.createProduct2();
        Product_Detail__c pd = TestHelper.createProductDetail(false);
        pd.Contract_PO_PI__c = con.Id;
        insert pd;
        Production_Schedule_Detail__c psd = new Production_Schedule_Detail__c();
        psd.Confirmed_ex_Work_Date__c		= Date.Today();
        psd.Contract__c						= con.Id;
        psd.Expected_Delivery_Date__c		= '';
        psd.Expected_ETD__c					= Date.Today();
        psd.Expected_ex_Work_Date__c		= Date.Today();
        psd.Product__c						= p.Id;
        psd.Product_Detail__c				= pd.Id;
        psd.Quantity__c						= 100;
        psd.Remarks__c						= 'aa';
        psd.Total_MW__c						= 10;
        psd.Total_Price__c					= 20;
        psd.Unit_Price__c					= 1;
        insert psd;
        ExecuteProductionScheduleDetailsInsert.clickNewButton(con.Id);
        ExecuteProductionScheduleDetailsInsert epsdi = new ExecuteProductionScheduleDetailsInsert();
		epsdi.runTest();        
    }
}