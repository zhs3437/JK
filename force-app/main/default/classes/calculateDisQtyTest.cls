@isTest
public class calculateDisQtyTest {
    
    static testMethod void myTest(){
        
        Product2 prod = TestHelper.createProduct2();
		PricebookEntry entry = TestHelper.createPriceBookEntry(prod.Id);
        
        Account acc = TestHelper.createAccount();
    	
    	Contract con = TestHelper.createContract(acc.Id);
        
        Order aOrder= TestHelper.createOrder(false);   
	    aOrder.Buyer__c = acc.Id;
	    aOrder.BillingCountry = 'aaa';
	    aOrder.BillingPostalCode = 'bbb';
	    aOrder.BillingState = 'ccc';
	    aOrder.BillingCity = 'ddd';
	    aOrder.BillingStreet = 'eee';
	    aOrder.Contract_No__c = 'MCXXXX13QXtest';
	    aOrder.SELLER__c = 'ジンコソーラージャパン株式会社';
	    aOrder.AccountId = acc.Id;
	    aOrder.EffectiveDate = Date.today();
	    aOrder.Status = 'Draft';
	    aOrder.Pricebook2Id = entry.Pricebook2Id;
	    aOrder.ContractId = con.Id;
	    aOrder.Trade_term__c = 'EXW';
        aOrder.SAP_Order_ID__c = 'test0001';
		insert aOrder;
        
        Apply_Inventory__c aInventory = new Apply_Inventory__c();
        aInventory.Product_Type__c = prod.Id;
        insert aInventory;
        
        Inventory__c inven = new Inventory__c();
        inven.Product_Type__c = prod.id;
        insert inven;  
        
        Distribution_Stock__c tdStock = new Distribution_Stock__c();
        tdStock.Apply_Inventory__c = aInventory.Id;
        tdStock.Inventory__c = inven.id;
        tdStock.Distribution_Quantity__c = 300;
        tdStock.Order__c = aOrder.id;
        tdStock.Product_Type__c =  prod.Id;
        tdStock.SAP_LGORT__c = 'Transit';
        tdStock.SAP_W_H__c = 'T005';
        tdStock.SAP_Materiel_No__c = '000000000024000014';
        tdStock.Status__c = 'Booked';
        insert tdStock;
        tdStock.BL_No__c = 'EGLV050610';
        update tdStock;
        
         Distribution_Stock__c fdStock = new Distribution_Stock__c();
        fdStock.Apply_Inventory__c = aInventory.Id;
        fdStock.Inventory__c = inven.id;
        fdStock.Distribution_Quantity__c = 300;
        fdStock.Order__c = aOrder.id;
        fdStock.BL_No__c = 'EGLV050610';
        fdStock.Product_Type__c =  prod.Id;
        fdStock.SAP_LGORT__c = 'Fukuoka';
        fdStock.SAP_W_H__c = 'F016';
        fdStock.SAP_Materiel_No__c = '000000000024000014';
        fdStock.Status__c = 'Booked';
       
        insert fdStock;
       
       // update tdStock;
        
        SapEccCompleteStatus.CompleteStatusReturn_element t_re_SECC_CSR = new SapEccCompleteStatus.CompleteStatusReturn_element();
        t_re_SECC_CSR.BISMT='JK250P-60';
        t_re_SECC_CSR.BLNO='EGLV050610';
        t_re_SECC_CSR.COMPLETE_DATE='00000000';
        t_re_SECC_CSR.Item=null;
        t_re_SECC_CSR.LGORT='T005';
        t_re_SECC_CSR.MATNR='000000000024000014';
        t_re_SECC_CSR.MSG=null;
        t_re_SECC_CSR.QYP_PC='250';
        t_re_SECC_CSR.STATUS='BOOK';
        t_re_SECC_CSR.TYPE_x=null;
        t_re_SECC_CSR.WERKS='1250';
        t_re_SECC_CSR.ZCRMNO='a0C0l000001h6XPEAY';
        
        SapEccCompleteStatus.CompleteStatusReturn_element f_re_SECC_CSR = new SapEccCompleteStatus.CompleteStatusReturn_element();
        f_re_SECC_CSR.BISMT='JK250P-60';
        f_re_SECC_CSR.BLNO='EGLV050610';
        f_re_SECC_CSR.COMPLETE_DATE='00000000';
        f_re_SECC_CSR.Item=null;
        f_re_SECC_CSR.LGORT='F018';
        f_re_SECC_CSR.MATNR='000000000024000014';
        f_re_SECC_CSR.MSG=null;
        f_re_SECC_CSR.QYP_PC='350';
        f_re_SECC_CSR.STATUS='BOOK';
        f_re_SECC_CSR.TYPE_x=null;
        f_re_SECC_CSR.WERKS='1250';
        f_re_SECC_CSR.ZCRMNO='a0C0l000001h6XPEAY';
        List<SapEccCompleteStatus.CompleteStatusReturn_element> returnList = new List<SapEccCompleteStatus.CompleteStatusReturn_element>();
        returnList.add(t_re_SECC_CSR);
        returnList.add(f_re_SECC_CSR);
        system.debug('returnList===:'+returnList);
        
        calculateDisQty cDQ = new calculateDisQty();
        
        Map<string,Decimal> bt_blNo_sapM_NumMap = cDQ.totalNunberMethod('Booked','T005');
        Map<string,Decimal> bf_blNo_sapM_NumMap = cDQ.F_totalNunberMethod('Booked','T005');
        cDQ.calDisMethod(returnList,'T005','Booked',bt_blNo_sapM_NumMap,bf_blNo_sapM_NumMap);
        
         SapEccCompleteStatus.CompleteStatusReturn_element t1_re_SECC_CSR = new SapEccCompleteStatus.CompleteStatusReturn_element();
        t1_re_SECC_CSR.BISMT='JK250P-60';
        t1_re_SECC_CSR.BLNO='EGLV050610';
        t1_re_SECC_CSR.COMPLETE_DATE='00000000';
        t1_re_SECC_CSR.Item=null;
        t1_re_SECC_CSR.LGORT='T005';
        t1_re_SECC_CSR.MATNR='000000000024000014';
        t1_re_SECC_CSR.MSG=null;
        t1_re_SECC_CSR.QYP_PC='250';
        t1_re_SECC_CSR.STATUS='BOOK';
        t1_re_SECC_CSR.TYPE_x=null;
        t1_re_SECC_CSR.WERKS='1250';
        t1_re_SECC_CSR.ZCRMNO='a0C0l000001h6XPEAY';
        
        SapEccCompleteStatus.CompleteStatusReturn_element f1_re_SECC_CSR = new SapEccCompleteStatus.CompleteStatusReturn_element();
        f1_re_SECC_CSR.BISMT='JK250P-60';
        f1_re_SECC_CSR.BLNO='EGLV050610';
        f1_re_SECC_CSR.COMPLETE_DATE='00000000';
        f1_re_SECC_CSR.Item=null;
        f1_re_SECC_CSR.LGORT='F018';
        f1_re_SECC_CSR.MATNR='000000000024000014';
        f1_re_SECC_CSR.MSG=null;
        f1_re_SECC_CSR.QYP_PC='300';
        f1_re_SECC_CSR.STATUS='BOOK';
        f1_re_SECC_CSR.TYPE_x=null;
        f1_re_SECC_CSR.WERKS='1250';
        f1_re_SECC_CSR.ZCRMNO='a0C0l000001h6XPEAY';
             SapEccCompleteStatus.CompleteStatusReturn_element f2_re_SECC_CSR = new SapEccCompleteStatus.CompleteStatusReturn_element();
        f2_re_SECC_CSR.BISMT='JK250P-60';
        f2_re_SECC_CSR.BLNO='EGLV050610';
        f2_re_SECC_CSR.COMPLETE_DATE='00000000';
        f2_re_SECC_CSR.Item=null;
        f2_re_SECC_CSR.LGORT='F015';
        f2_re_SECC_CSR.MATNR='000000000024000014';
        f2_re_SECC_CSR.MSG=null;
        f2_re_SECC_CSR.QYP_PC='300';
        f2_re_SECC_CSR.STATUS='BOOK';
        f2_re_SECC_CSR.TYPE_x=null;
        f2_re_SECC_CSR.WERKS='1250';
        f2_re_SECC_CSR.ZCRMNO='a0C0l000001h6XPEAY';
        List<SapEccCompleteStatus.CompleteStatusReturn_element> returnList1 = new List<SapEccCompleteStatus.CompleteStatusReturn_element>();
        returnList1.add(t1_re_SECC_CSR);
        returnList1.add(f1_re_SECC_CSR);
        returnList1.add(f2_re_SECC_CSR);        
          calculateDisQty cDQ1 = new calculateDisQty();
        
        Map<string,Decimal> bt1_blNo_sapM_NumMap = cDQ1.totalNunberMethod('Booked','T005');
       Map<string,Decimal> bf1_blNo_sapM_NumMap = cDQ1.F_totalNunberMethod('Booked','T005');
       cDQ1.calDisMethod(returnList1,'T005','Booked',bt1_blNo_sapM_NumMap,bf1_blNo_sapM_NumMap);
        
        
        //  List<Distribution_Stock__c>  syncDisStockLst = new  List<Distribution_Stock__c>();
      //  syncDisStockLst.add(tdStock);
     //    syncDisStockLst.add(fdStock);
        
    }
}