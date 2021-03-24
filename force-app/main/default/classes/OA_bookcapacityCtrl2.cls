global class OA_bookcapacityCtrl2 {
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
                                          Contract__r.owner.Name,
                                           Contract__r.Name,
                                           Contract__r.region__c,
                                           Contract__r.ownerId,
											Opportunity__r.Name
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
        //OA_bookcapacity.BookCapacityMainInfo BookCapacityMain =new  OA_bookcapacity.BookCapacityMainInfo();
            bookcapacityponWebservices.BookCapacityPonMainInfo BookCapacityMain2=new bookcapacityponWebservices.BookCapacityPonMainInfo();
            if(crcs.size()>0){
                List<Contract> con =new List<Contract>();
                con=[SELECT ID,NAME,Cross_Region__c FROM Contract WHERE ID=:crcs[0].contract__c];
                System.debug('0.con------------>'+con.size());
                if(con.size()>0){
                    System.debug('1.con[0]------------>'+con[0].Cross_Region__c);
                    if(con[0].Cross_Region__c==true){                        
                       BookCapacityMain2.sfkq='0'; 
                        System.debug('2.con[0]------------>'+BookCapacityMain2.sfkq);
                    }else{                       
                        BookCapacityMain2.sfkq='1'; 
                        System.debug('3.con[0]------------>'+BookCapacityMain2.sfkq);
                    }
                    
                }
                
            }
            
            BookCapacityMain2.bm='';
            BookCapacityMain2.gs='';
            BookCapacityMain2.hth=crcs[0].Contract__r.Name;
            BookCapacityMain2.mddqy=  crcs[0].area__c;
            BookCapacityMain2.mytk1=  crcs[0].Trade_term__c;
			BookCapacityMain2.sqr= String.valueOf(crcs[0].OA_Contact__c);            
            BookCapacityMain2.sqrq=String.valueOf(crcs[0].ApplicationDate__c);
            System.debug('crcs[0].Contract__r.ownerId---->'+crcs[0].Contract__r.ownerId);
            if(crcs[0].Contract__r.ownerId!=null){
				List<User> u=[SELECT ID,Name,OA_Use_Id__c from User where id=:crcs[0].Contract__r.ownerId ];
                System.debug('u.size----'+u.size());
                BookCapacityMain2.xdr=u[0].OA_Use_Id__c;  
                 System.debug('u.OA_Use_Id__c-------------->'+u[0].OA_Use_Id__c);
                System.debug('BookCapacityMain2.xdr-------------->'+BookCapacityMain2.xdr);
            }
			         
			BookCapacityMain2.xdsj	=	String.valueOf(crcs[0].ApplicationDate__c);
            BookCapacityMain2.yldmc = crcs[0].Name;
            BookCapacityMain2.zt=crcs[0].state__c;
           
            
        
        
        //OA_bookcapacity.ArrayOfBookCapacityDetailInfo obao =new OA_bookcapacity.ArrayOfBookCapacityDetailInfo();
            bookcapacityponWebservices.ArrayOfBookCapacityPonDetailInfo obao2 =new bookcapacityponWebservices.ArrayOfBookCapacityPonDetailInfo();
                   
         obao2.BookCapacityPonDetailInfo =new bookcapacityponWebservices.BookCapacityPonDetailInfo[0];   
   
        for(Integer i=0; i<ppcs.size(); i++){
        	
            bookcapacityponWebservices.BookCapacityPonDetailInfo BookCapacityDetail2 =new bookcapacityponWebservices.BookCapacityPonDetailInfo();
            BookCapacityDetail2.EDATU = String.valueOf(ppcs[i].Guaranteed_Delivery_Date__c);
			BookCapacityDetail2.EDATUJAP = String.valueOf(ppcs[i].Guaranteed_Delivery_Date_japan__c);
            BookCapacityDetail2.PCS = String.valueOf(ppcs[i].Quantity__c);
            BookCapacityDetail2.MW = String.valueOf(ppcs[i].Total_W__c/1000000);
            BookCapacityDetail2.cpms = ppcs[i].Production_Description__c;
            BookCapacityDetail2.ggxh = ppcs[i].Spec__c;
            BookCapacityDetail2.product = ppcs[i].Product__r.Name;
			BookCapacityDetail2.xsdj = String.valueOf(ppcs[i].Unit_Price__c);                               
        	BookCapacityDetail2.ylcp = ppcs[i].Name;
			obao2.BookCapacityPonDetailInfo.add(BookCapacityDetail2);
        }
       
          bookcapacityponserviceServices.createBookCapacityWorkflow_element oce = new bookcapacityponserviceServices.createBookCapacityWorkflow_element();
            
        oce.in0 = BookCapacityMain2;
        
        oce.in1 = obao2;
         
		bookcapacityponserviceServices.BookCapacityPonServiceHttpPort obbp = new bookcapacityponserviceServices.BookCapacityPonServiceHttpPort();
            //bookcapacityponserviceServices.createBookCapacityWorkflowResponse_element result = new bookcapacityponserviceServices.createBookCapacityWorkflowResponse_element();
		result = obbp.createBookCapacityWorkflow(oce.in0,oce.in1);
        crcs[0].OA_Book_Capacity_No__c = result;
        update crcs[0];
        return result;
    }
}