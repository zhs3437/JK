global class OA_bookcapacityCtrl {
    webservice static String generateData(String bookCapacityid){
        String result ;
        List<CapacityReservation__c> crcs=[select id,
                                          Name,
                                          state__c,
                                          ValidityTerm__c,
                                          ifdelay__c,
                                          BMO__c,
                                          change__c,
                                          contract__c,
                                          contract__r.ContractNumber,
                                          Contracts_Status__c,
                                          Email__c,
                                          GM__c,
                                          no__c,
                                          Number_of_applications__c,
                                          OA_Contact__c,
                                          Opportunity__c,
                                          Price_Approval_Status__c,
                                          area__c,
                                          RegionNo__c,
                                          ApplicationDate__c,
                                          wattage__c,
                                          Trade_term__c,
                                          OwnerId,
                                          OA_Book_Capacity_No__c,
                                          Buyer__c,
                                          Contract_PO_PI_NO__c,                                           	
										  Contract__r.SELLER__c,
                                          Contract__r.owner.Name
                                          from CapacityReservation__c 
                                          where id=:bookCapacityid];
		//List<User> user =[SELECT ID,NAME FROM User WHERE ID=:crcs[0].OwnerId];
        List<PowerProduct__c> ppcs = [SELECT ID,
        								Name,
        								Product__r.Name,
        								Unit_WM__c,
        								Production_Description__c,
        								Spec__c,
        								Guaranteed_Delivery_Date__c,
        								Guaranteed_Delivery_Date_japan__c,
        								Unit_Price_Without_Commission__c,
        								Commission_Per_W__c,
        								Guaranteed_Delivery_Date_by_Month__c,
        								Guaranteed_Delivery_Date_by_quarter__c,
        								Cheetah__c,
        								Powerbooked__c,
        								Powerbooked__r.Name,
        								Quantity__c,
        								Unit_Price__c,
        								Total_Price__c,
        								Total_W__c,
                                      Cell_Type__c,
        								Time_Region__c,
        								FOB_Unit_Price__c                                      	
        								FROM PowerProduct__c
        								WHERE Powerbooked__c =:bookCapacityid];
        System.debug('ppcs'+ppcs.size());
        OA_bookcapacity.BookCapacityMainInfo BookCapacityMain =new  OA_bookcapacity.BookCapacityMainInfo();
        BookCapacityMain.xsry=crcs[0].Contract__r.owner.Name;
        BookCapacityMain.seller=crcs[0].Contract__r.SELLER__c;
        system.debug('seller==================='+BookCapacityMain.seller);
        BookCapacityMain.buyer = crcs[0].Buyer__c;
        BookCapacityMain.contractNO = crcs[0].Contract_PO_PI_NO__c;
        System.debug('contractNO------------'+BookCapacityMain.contractNO);
        BookCapacityMain.yldmc = crcs[0].Name;
        BookCapacityMain.quyu = crcs[0].area__c;
        BookCapacityMain.mytk = crcs[0].Trade_term__c;
        BookCapacityMain.zws = String.valueOf(crcs[0].wattage__c);
        BookCapacityMain.sqrq = String.valueOf(crcs[0].ApplicationDate__c);
        BookCapacityMain.dqr = String.valueOf(crcs[0].ValidityTerm__c);   
        BookCapacityMain.zt = crcs[0].state__c;     
		/*if(crcs[0].state__c=='Preparing'){
            BookCapacityMain.zt = '0';
        }else if(crcs[0].state__c=='Approved'){
			BookCapacityMain.zt = '1';            
        }else if(crcs[0].state__c=='Rejected'){
            BookCapacityMain.zt = '2';
        }else if(crcs[0].state__c=='Pending'){
            BookCapacityMain.zt = '3';
        }else if(crcs[0].state__c=='Overdue'){
            BookCapacityMain.zt = '4';
        }  */      
        BookCapacityMain.jgzt = String.valueOf(crcs[0].Price_Approval_Status__c);
        BookCapacityMain.jh = crcs[0].Opportunity__c;
        BookCapacityMain.ht = crcs[0].contract__r.ContractNumber;
                system.debug('打桩:'+crcs[0].contract__r.ContractNumber);
        BookCapacityMain.htzt = crcs[0].Contracts_Status__c;
        BookCapacityMain.sqr = String.valueOf(crcs[0].OA_Contact__c);
        BookCapacityMain.sqcs = String.valueOf(crcs[0].Number_of_applications__c);
        
        OA_bookcapacity.ArrayOfBookCapacityDetailInfo obao =new OA_bookcapacity.ArrayOfBookCapacityDetailInfo();
        obao.BookCapacityDetailInfo =new OA_bookcapacity.BookCapacityDetailInfo[0];
        for(Integer i=0; i<ppcs.size(); i++){
        	OA_bookcapacity.BookCapacityDetailInfo BookCapacityDetail = new  OA_bookcapacity.BookCapacityDetailInfo();
        	BookCapacityDetail.ylcp = ppcs[i].Name;
			BookCapacityDetail.cpmc = ppcs[i].Product__r.Name;
			BookCapacityDetail.unitWM = String.valueOf(ppcs[i].Unit_WM__c);
			BookCapacityDetail.cpms = ppcs[i].Production_Description__c;
			BookCapacityDetail.ggxh = ppcs[i].Spec__c;
			BookCapacityDetail.bzjhrq = String.valueOf(ppcs[i].Guaranteed_Delivery_Date__c);
			BookCapacityDetail.bzjhrqrb = String.valueOf(ppcs[i].Guaranteed_Delivery_Date_japan__c);
			BookCapacityDetail.unitPriceNC = String.valueOf(ppcs[i].Unit_Price_Without_Commission__c);
			BookCapacityDetail.commission = String.valueOf(ppcs[i]. Commission_Per_W__c);
			BookCapacityDetail.ybzjhrq = ppcs[i].Guaranteed_Delivery_Date_by_Month__c;
			BookCapacityDetail.jdbzjhrq = ppcs[i].Guaranteed_Delivery_Date_by_quarter__c;
			BookCapacityDetail.Cheetah = String.valueOf(ppcs[i].Cheetah__c);
			BookCapacityDetail.bookCapacity = ppcs[i].Powerbooked__r.Name;
			BookCapacityDetail.sl = String.valueOf(ppcs[i].Quantity__c);
			BookCapacityDetail.xsdj = String.valueOf(ppcs[i].Unit_Price__c);
			BookCapacityDetail.zj = String.valueOf(ppcs[i].Total_Price__c);
			BookCapacityDetail.zws = String.valueOf(ppcs[i].Total_W__c);
			BookCapacityDetail.sq = ppcs[i].Time_Region__c;
			BookCapacityDetail.fobdj = String.valueOf(ppcs[i].FOB_Unit_Price__c);
            BookCapacityDetail.dcplx = String.valueOf(ppcs[i].Cell_Type__c);
			obao.BookCapacityDetailInfo.add(BookCapacityDetail);
        }
        OA_bookcapacityService.createBookCapacityWorkflow_element oce =new OA_bookcapacityService.createBookCapacityWorkflow_element();
        oce.in0 = BookCapacityMain;
        system.debug('打桩:'+BookCapacityMain.ht);
        oce.in1 = obao;
         system.debug('打桩2:'+ oce.in1.BookCapacityDetailInfo[0].dcplx );
		OA_bookcapacityService.BookCapacityServiceHttpPort obbp = new OA_bookcapacityService.BookCapacityServiceHttpPort();
		result = obbp.createBookCapacityWorkflow(oce.in0,oce.in1);
        crcs[0].OA_Book_Capacity_No__c = result;
        update crcs[0];
        return result;
    }
}