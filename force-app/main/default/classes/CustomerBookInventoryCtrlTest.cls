@isTest
public class CustomerBookInventoryCtrlTest {
     static testMethod void test_History() {

        // PageReference pageRef = Page.TestInventoryProductCtrl.History;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		CustomerBookInventoryCtrl.History history = new CustomerBookInventoryCtrl.History();


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for hac
     */
    static testMethod void test_hac() {

        // PageReference pageRef = Page.TestInventoryProductCtrl.History;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		Inventory__c tip = null;
		CustomerBookInventoryCtrl.History history = new CustomerBookInventoryCtrl.History();
		history.hac(tip);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }

    
      static testMethod void myTest(){
           Product2 p          = TestHelper.createProduct2();
           Inventory__c ic = new Inventory__c();
        ic.Product_Type__c = p.id;
        ic.Warehouse2__c = 'Kobe';
        ic.BL_NO__c = null;
        ic.Quantity__c = 1;
        ic.MAKTX__c = null;
        ic.InputNumber__c = '2';
        ic.isSelect_c__c = true;
        insert ic;
        Inventory__c ics = new Inventory__c();
        ics.Product_Type__c = p.id;
        ics.Warehouse2__c = 'Kobe';
        ics.BL_NO__c = null;
        ics.Quantity__c = 10;
        ics.MAKTX__c = null;
        ics.InputNumber__c = '2';
        ics.isSelect_c__c = true;
        insert ics;
         List<Inventory__c> invLst = new List<Inventory__c>();
            invLst.add(ic);
            invLst.add(ics);        
        system.debug('invLst'+invLst.size());
        String editID = null;
        List<String> keyID = new List<id>();
        String deleteID = null;
        String saveID = null;
        String bookID = null;
          ApexPages.currentPage().getParameters().put('id', ics.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
         CustomerBookInventoryCtrl IPS = new CustomerBookInventoryCtrl(sc);   
            IPS.productName = 'JK250P-60';
        IPS.warehouse = 'Transit';
     sapEccUnbook.UnbookReturn_element t_re_SECC_CSR = new sapEccUnbook.UnbookReturn_element();
        t_re_SECC_CSR.BISMT='JK250P-60';
        t_re_SECC_CSR.BLNO='EGLV050610';
        t_re_SECC_CSR.LGORT='T006';
        t_re_SECC_CSR.MATNR='000000000024000014';
        t_re_SECC_CSR.QYP_PC='250';
        t_re_SECC_CSR.STATUS='BOOK';
        t_re_SECC_CSR.WERKS='1250';
        
        sapEccUnbook.UnbookReturn_element f_re_SECC_CSR = new sapEccUnbook.UnbookReturn_element();
        f_re_SECC_CSR.BISMT='JK250P-60';
        f_re_SECC_CSR.BLNO='EGLV050610';
        f_re_SECC_CSR.LGORT='T006';
        f_re_SECC_CSR.MATNR='000000000024000014';
        f_re_SECC_CSR.QYP_PC='350';
        f_re_SECC_CSR.STATUS='BOOK';
        f_re_SECC_CSR.WERKS='1250';
        List<sapEccUnbook.UnbookReturn_element> returnList = new List<sapEccUnbook.UnbookReturn_element>();
        returnList.add(t_re_SECC_CSR);
        returnList.add(f_re_SECC_CSR);
          IPS.SearchProduct();
        //  IPS.saveEditPayment();
      }

}