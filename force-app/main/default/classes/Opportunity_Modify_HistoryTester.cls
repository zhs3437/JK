@isTest(SeeAllData=true)
private class Opportunity_Modify_HistoryTester {

	
    static testMethod void myUnitTest() {
        SAP_Product__c  SapProduct = new SAP_Product__c();
        SapProduct.Certification__c ='0-NO';
        SapProduct.Color_of_Module__c ='1-Black';
        SapProduct.Type_of_module__c ='MCS-MAXIM_C module';
        SapProduct.Grade__c ='A-Grade A';
        SapProduct.Special_required__c ='0-commonly';
        SapProduct.Bus_bars_of_cell__c ='5-5BB';
        SapProduct.Product_Code__c ='24000014';
        SapProduct.Product_Name__c ='24000014';
        SapProduct.Product_Description__c ='';
        insert SapProduct;
        
       Account acc = new Account();
        acc = new Account(Name = 'JinkoFullNamefortest',Customer_Grading__c='VIP',Sinosure_Buyer_s_Code__c='SN0000X',Cooperation_method__c='OEM',User__c=UserInfo.getUserId());
        acc.Company_Email__c = 'winhunter@qq.com';
       // insert acc;
    //	testPrepare test = new testPrepare();
    	acc.Country__c='China';
        insert acc;
        Opportunity o1 = new Opportunity();
     
        o1.name='2MW-JKM180-20120101';
        o1.CloseDate = Date.today();
        o1.AccountId=acc.id;
        o1.Probability=100;
    	o1.Amount = 909090;
    	o1.StageName = 'Close Win';
    	o1.Credit_Days__c = 999;
    	o1.Balance_Payment__c = 'At Sight';
    	o1.Payment_Method__c = '100% L/C';
    	o1.Trade_Term__c = 'CIF';
    	o1.Confirmed_ETA__c = Date.valueOf('2010-01-02');
        o1.Confirmed_ETA2__c =Date.valueOf('2010-01-02');
        o1.Confirmed_ETA3__c =Date.valueOf('2010-01-02');
    	o1.Confirmed_ETD__c = Date.valueOf('2010-01-02');
        o1.Confirmed_ETD2__c = Date.valueOf('2010-01-02');
    	o1.Customer_Delivery_Date__c = Date.valueOf('2010-01-02');
        o1.CloseDate=Date.valueOf('2010-01-02');
    	insert o1;

        Contract co=new Contract();
        co.AccountId=acc.Id;
        co.Opportunity__c=o1.Id;
        co.Contract_NO__c='MCXXXX13Qtest20180912';
        co.Status='Draft';
        co.Destination_Country__c='Japan';
        co.Destination__c='xxxxxxxxx';
        co.Warranty_Insurance__c='PG';
        insert co;

        list<Opportunity_History__c> list_oh=new list<Opportunity_History__c>();
        Opportunity_History__c oh=new Opportunity_History__c();
		
        o1.Amount=89999;
        update o1;
         /**
        oh.After_Modify__c=String.valueOf(o1.Amount);
        oh.Change_Field__c='Amount';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Credit_Days__c=899;
        update o1;
        oh.After_Modify__c=String.valueOf(o1.Credit_Days__c);
        oh.Change_Field__c='Balapayment Credit Days';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Balance_Payment__c='After sight';
        update o1;
        oh.After_Modify__c=o1.Balance_Payment__c;
        oh.Change_Field__c='Balapayment';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Payment_Method__c='100% O/A';
        update o1;
        oh.After_Modify__c=o1.Payment_Method__c;
        oh.Change_Field__c='Payment Method';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);list_oh.add(oh);

        o1.Trade_Term__c = 'EXW';
        update o1;
        oh.After_Modify__c=o1.Trade_Term__c;
        oh.Change_Field__c='Trader Term';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Confirmed_ETA__c=Date.valueOf('2010-01-03');
        update o1;
        oh.After_Modify__c=String.valueOf(o1.Confirmed_ETA__c);
        oh.Change_Field__c='Confirmed ETA';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);
        
        o1.Confirmed_ETA2__c=Date.valueOf('2010-01-03');
        update o1;
     
        oh.After_Modify__c=String.valueOf(o1.Confirmed_ETA2__c);
        oh.Change_Field__c='Confirmed ETA2';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Confirmed_ETA3__c=Date.valueOf('2010-01-03');
        update o1;
        oh.After_Modify__c=String.valueOf(o1.Confirmed_ETA3__c);
        oh.Change_Field__c='Confirmed ETA3';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Confirmed_ETD__c=Date.valueOf('2010-01-03');
        update o1;
        oh.After_Modify__c=String.valueOf(o1.Confirmed_ETD__c);
        oh.Change_Field__c='Confirmed ETD';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Customer_Delivery_Date__c=Date.valueOf('2010-01-03');
        update o1;
        oh.After_Modify__c=String.valueOf(o1.Customer_Delivery_Date__c);
        oh.Change_Field__c='Customer Delivery Date';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.CloseDate=Date.valueOf('2010-01-03');
        update o1;
        oh.After_Modify__c=String.valueOf(o1.CloseDate);
        oh.Change_Field__c='CloseDate';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);

        o1.Confirmed_ETD2__c=Date.valueOf('2010-01-03');
        update o1;
        oh.After_Modify__c=String.valueOf(o1.Confirmed_ETD2__c);
        oh.Change_Field__c='Confirmed ETD2';
        oh.Opportunity__c=o1.Id;
        oh.Contract__c=co.Id;
        list_oh.add(oh);
       */
        insert list_oh;

     //   Opportunity_Modify_History omh = new Opportunity_Modify_History();
       // omh.runtest();

	//	List<Opportunity_History__c> lstTest = [SELECT ID FROM Opportunity_History__c 
														//	Where Opportunity__c=:o1.Id];
    	
    //	system.assert( lstTest.size() == 5 );
    }
}