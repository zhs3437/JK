global without sharing class CapacityReservationUtils{
    
    //点击按钮生成 产能预留和产能产品
    webservice static String CreatePro (string conid){
        Contract cot=[select Region__c,Total_MW__c,Cross_Region__c,Opportunity__c,Trade_term__c from Contract where id=:conid];
        
        CapacityReservation__c cr =new CapacityReservation__c();
        
        List<CapacityReservation__c> count=[select id,state__c,ValidityTerm__c from CapacityReservation__c where contract__c=:conid];//合同下产能预留表


        if(count.size()==0 || (count.size()==1 && (count[0].state__c=='Overdue'|| (count[0].state__c=='Approved' && count[0].ValidityTerm__c<date.today()) ||count[0].state__c=='Rejected'))){
            //产能预留表的生成
            cr.contract__c=conid;
            cr.Opportunity__c=cot.Opportunity__c;
            cr.Trade_term__c=cot.Trade_term__c;
            cr.area__c=cot.Region__c;
            cr.wattage__c=cot.Total_MW__c;
            cr.Number_of_applications__c=count.size()+1;
            cr.state__c='Preparing';

            insert cr;
              CapacityReservation__c cr2 =[select ownerid,contract__r.ownerid from CapacityReservation__c where id=:cr.id];
            system.debug('cr.ownerid'+cr2.ownerid);
             User u = [Select Id,Name,
                                   ManagerId,
                                   BMO_specialist__c ,
                                   Country__c, 
                                   Contract_Approver__c,
                                   Contract_Review__c
                                   From User where isActive = true and Id =:cr2.contract__r.ownerid];
            if(cot.Cross_Region__c==false){
            cr.BMO__c=u.BMO_specialist__c;
                }
            if(cot.Cross_Region__c==true){
            cr.BMO__c='0059000000126Fm';
                }
            cr.GM__c=u.Contract_Approver__c;
            update cr;
            //产能产品生成
            List<Product_Detail__c> pdLst =[select id,Product__c,Spec__c,Cheetah__c,Total_Price__c,Battery_Type__c,
                                            FOB_Unit_Price__c,Back_Sheet__c,Frame_Color__c,Cell_Appearance__c,
                                            Cable_Length__c,Connector__c,MP__c,Solar_Cell__c,EVA__c,Tempered_glass__c,
                                            Ribbon__c,Others__c,Technical_Requirement__c,currencyisocode,Tolerance__c,Junction_Box__c,
                                            Frame__c,Serial_No__c,Package__c,Label__c,Production_Description__c,Unit_Price__c,
                                            Unit_Price_Without_Commission__c,Commission_Per_W__c,Time_Region__c, Quantity__c,
                                            Total_W__c,Certification__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                                            Guaranteed_Delivery_Date_japan__c from Product_Detail__c where Contract_PO_PI__c=:conid];
            if(pdLst.size()>0){
                List<PowerProduct__c> powpLst=new  List<PowerProduct__c>();
                for(Product_Detail__c pd:pdlst){
                    PowerProduct__c powp=new PowerProduct__c();
                     powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product__c;
                    powp.Spec__c=pd.Spec__c;
                    powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Tempered_glass__c=pd.Tempered_glass__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    powp.Technical_Requirement__c=pd.Technical_Requirement__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    powp.Production_Description__c=pd.Production_Description__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.Unit_Price__c;
                    powp.Quantity__c=pd.Quantity__c;
                    powp.Total_W__c=pd.Total_W__c;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                    powpLst.add(powp);                 
                }
                insert powpLst;
                
            }
            return '1';
        }else{
            if(count.size()==1 && (count[0].state__c=='Preparing' || count[0].state__c=='Pending'|| (count[0].state__c=='Approved' && count[0].ValidityTerm__c>date.today()) )){
        return'you can not create capacity booking until last one finished.';
                }
           
            if(count.size()==2){
        return'Capacity booking is exceed, maximum 2 times.';
                }
            return '';
            }
    }    
        webservice static String getid (string conid){
            List<CapacityReservation__c> cr=[select contract__c,area__c,wattage__c from CapacityReservation__c where contract__c=:conid];
            if(cr.size()==1){
                return cr[0].id;
                }else{
                     return cr[1].id;
                }
            }
    webservice static String UpdatePro (string powerbookid){
       CapacityReservation__c cr=[select contract__c,area__c,wattage__c from CapacityReservation__c where id=:powerbookid];
        String conid=cr.contract__c;
        contract con=[select id,Opportunity__c from contract where id=:conid];
        String oppid =con.Opportunity__c;
        Opportunity opp=[select Region__c,Total_MW__c,Trade_term__c from Opportunity where id=:oppid];

            cr.area__c=opp.Region__c;
            cr.wattage__c=opp.Total_MW__c;
        cr.Trade_term__c=opp.Trade_term__c;
              update cr;    
    List<PowerProduct__c> pplst=[select id from PowerProduct__c where Powerbooked__c =:powerbookid];
    delete pplst;
    List<OpportunityLineItem> pdLst =[select id,Product2id,Quantity,UnitPrice,Total_Power_W__c,
                                            Cheetah__c,Total_Price__c,
                                            Back_Sheet__c,Frame_Color__c,currencyisocode,Cell_Appearance__c,
                                            Cable_Length__c,Connector__c,MP__c,Solar_Cell__c,EVA__c,
                                            Ribbon__c,Others__c,Tolerance__c,Junction_Box__c,
                                            Frame__c,Serial_No__c,Package__c,Label__c,
                                            Unit_Price_Without_Commission__c,Commission_Per_W__c
                                            ,Certification__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                                            Guaranteed_Delivery_Date_japan__c  from OpportunityLineItem where Opportunityid=:oppid];
            if(pdLst.size()>0){
                List<PowerProduct__c> powpLst=new  List<PowerProduct__c>();
                for(OpportunityLineItem pd:pdlst){
                    PowerProduct__c powp=new PowerProduct__c();
                     powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2id;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.UnitPrice;
                    powp.Quantity__c=pd.Quantity;
                    powp.Total_W__c=pd.Total_Power_W__c;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                    powpLst.add(powp);                 
                }
                insert powpLst;
    }
        return '1';
        }
    
    //点击按钮生成 在业务机会中的产能预留和产能产品
    webservice static String CreateProInOpp (string oppid){
        Opportunity opp = [select id,Region__c,Total_MW__c,Cross_Region__c,Contract__c,Trade_term__c from Opportunity where id=:oppid];
        //Contract cot=[select Region__c,Total_MW__c,Cross_Region__c,Opportunity__c,Trade_term__c from Contract where id=:conid];
        
        CapacityReservation__c cr =new CapacityReservation__c();
        
        List<CapacityReservation__c> count=[select id,state__c,ValidityTerm__c,contract__c,Opportunity__c from CapacityReservation__c where Opportunity__c=:oppid];//业务机会下产能预留表


        if(count.size()==0 || (count.size()==1 && (count[0].state__c=='Overdue'|| (count[0].state__c=='Approved' && count[0].ValidityTerm__c<date.today()) ||count[0].state__c=='Rejected'))){
            //产能预留表的生成
            cr.contract__c=opp.Contract__c;//
            cr.Opportunity__c=opp.id;
            cr.Trade_term__c=opp.Trade_term__c;
            cr.area__c=opp.Region__c;
            cr.wattage__c=opp.Total_MW__c;
            cr.Number_of_applications__c=count.size()+1;
            cr.state__c='Preparing';

            insert cr;
              CapacityReservation__c cr2 =[select ownerid,Opportunity__r.ownerid from CapacityReservation__c where id=:cr.id];
            system.debug('cr.ownerid'+cr2.ownerid);
             User u = [Select Id,Name,
                                   ManagerId,
                                   BMO_specialist__c ,
                                   Country__c, 
                                   Contract_Approver__c,
                                   Contract_Review__c
                                   From User where isActive = true and Id =:cr2.Opportunity__r.ownerid];
            if(opp.Cross_Region__c==false){
            cr.BMO__c=u.BMO_specialist__c;
                }
            if(opp.Cross_Region__c==true){
            cr.BMO__c='0059000000126Fm';
                }
            cr.GM__c=u.Contract_Approver__c;
            update cr;
            //产能产品生成
            List<OpportunityLineItem> pdLst =[select id,Product__c,Product2.Id,Cheetah__c,Total_Price__c,Battery_Type__c,
                                            Back_Sheet__c,Frame_Color__c,Cell_Appearance__c,
                                            Cable_Length__c,Connector__c,MP__c,Solar_Cell__c,EVA__c,
                                            Ribbon__c,Others__c,currencyisocode,Tolerance__c,Junction_Box__c,
                                            Frame__c,Serial_No__c,Package__c,Label__c,Unit_Price__c,
                                            Unit_Price_Without_Commission__c,Commission_Per_W__c,Quantity,
                                            Total_MW__c,Certification__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                                            Guaranteed_Delivery_Date_japan__c from OpportunityLineItem where OpportunityId=:oppid];
            if(pdLst.size()>0){
                List<PowerProduct__c> powpLst=new  List<PowerProduct__c>();
                for(OpportunityLineItem pd:pdlst){
                    PowerProduct__c powp=new PowerProduct__c();
                     powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    //powp.Tempered_glass__c=pd.Tempered_glass__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    //powp.Technical_Requirement__c=pd.Technical_Requirement__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    //powp.Production_Description__c=pd.Production_Description__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.Unit_Price__c;
                    powp.Quantity__c=pd.Quantity;
                    powp.Total_W__c=pd.Total_MW__c*1000000;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                     powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    //powp.Tempered_glass__c=pd.Tempered_glass__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    //powp.Technical_Requirement__c=pd.Technical_Requirement__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    //powp.Production_Description__c=pd.Production_Description__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.Unit_Price__c;
                    powp.Quantity__c=pd.Quantity;
                    powp.Total_W__c=pd.Total_MW__c*1000000;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                     powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    //powp.Tempered_glass__c=pd.Tempered_glass__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    //powp.Technical_Requirement__c=pd.Technical_Requirement__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    //powp.Production_Description__c=pd.Production_Description__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.Unit_Price__c;
                    powp.Quantity__c=pd.Quantity;
                    powp.Total_W__c=pd.Total_MW__c*1000000;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                     powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    //powp.Tempered_glass__c=pd.Tempered_glass__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    //powp.Technical_Requirement__c=pd.Technical_Requirement__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    //powp.Production_Description__c=pd.Production_Description__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.Unit_Price__c;
                    powp.Quantity__c=pd.Quantity;
                    powp.Total_W__c=pd.Total_MW__c*1000000;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                     powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    powp.Cell_Type__c=pd.Battery_Type__c;
                    powp.currencyisocode=pd.currencyisocode;
                    powp.Product__c=pd.Product2.Id;
                    //powp.Spec__c=pd.Spec__c;
                    //powp.Time_Region__c=pd.Time_Region__c;
                    powp.Unit_Price_Without_Commission__c=pd.Unit_Price_Without_Commission__c;
                    powp.Commission_Per_W__c=pd.Commission_Per_W__c;
                    powp.Cheetah__c=pd.Cheetah__c;
                    powp.Total_Price__c=pd.Total_Price__c;
                    //powp.FOB_Unit_Price__c=pd.FOB_Unit_Price__c;
                    powp.Back_Sheet__c=pd.Back_Sheet__c;
                    powp.Frame_Color__c=pd.Frame_Color__c;
                    powp.Cell_Appearance__c=pd.Cell_Appearance__c;
                    powp.Cable_Length__c=pd.Cable_Length__c;
                    powp.Connector__c=pd.Connector__c;
                    powp.MP__c=pd.MP__c;
                    powp.Solar_Cell__c=pd.Solar_Cell__c;
                    powp.EVA__c=pd.EVA__c;
                    //powp.Tempered_glass__c=pd.Tempered_glass__c;
                    powp.Ribbon__c=pd.Ribbon__c;
                    powp.Others__c=pd.Others__c;
                    //powp.Technical_Requirement__c=pd.Technical_Requirement__c;
                    powp.Tolerance__c=pd.Tolerance__c;
                    powp.Junction_Box__c=pd.Junction_Box__c;
                    powp.Frame_Material__c=pd.Frame__c;
                    powp.Serial_No__c=pd.Serial_No__c;
                    powp.Package__c=pd.Package__c;
                    powp.Label__c=pd.Label__c;
                    //powp.Production_Description__c=pd.Production_Description__c;
                    powp.Powerbooked__c=cr.id;
                     powp.Unit_Price__c=pd.Unit_Price__c;
                    powp.Quantity__c=pd.Quantity;
                    powp.Total_W__c=pd.Total_MW__c*1000000;
                    powp.Certification__c=pd.Certification__c;
                    powp.Junction_Box_Type__c=pd.Junction_Box_Type__c;
                    powp.Guaranteed_Delivery_Date__c=pd.Guaranteed_Delivery_Date__c;
                    powp.Guaranteed_Delivery_Date_japan__c=pd.Guaranteed_Delivery_Date_japan__c;
                    powpLst.add(powp);                 
                }
                insert powpLst;
                
            }
            return '1';
        }else{
            if(count.size()==1 && (count[0].state__c=='Preparing' || count[0].state__c=='Pending'|| (count[0].state__c=='Approved' && count[0].ValidityTerm__c>date.today()) )){
        return'you can not create capacity booking until last one finished.';
                }
           
            if(count.size()==2){
        return'Capacity booking is exceed, maximum 2 times.';
                }
            return 'Capacity booking is exceed, maximum 2 times.';
            }
    }  
    webservice static String getid2 (string oppid){
            List<CapacityReservation__c> cr=[select contract__c,area__c,wattage__c from CapacityReservation__c where Opportunity__c=:oppid];
            if(cr.size()==1){
                return cr[0].id;
                }else{
                     return cr[1].id;
                }
            }
      webservice static String resandemailtoCEO(String oppid){
     Opportunity opp=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                               'Where  id=:oppid ');  
        ID mainid    = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        List<Commission_Application__c> calst=new List<Commission_Application__c>();
          calst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: oppid and RecordTypeid =:mainid order by CreatedDate DESC');
            if(calst.size()>0){
                Commission_Application__c ca =calst[0];
                 User us=[select id from User where id=:'0056F000007apFw'];//CFO固定
                User us2=[select id from User where id=:'00590000002rC82'];//CMO固定
                User us3=[select id from User where id=:'0059000000126GN'];//VP固定
               /*
                if(opp.CFO_Approval_Status__c!='Approved'){
                   SendEmailUtils2.sendToSomeOneId(ca.ID,us.id,'CommissionApplicationEmail');//CFO邮件
                     opp.CFO_Commission_Email__c=true;
                opp.CFO_Commission_Email_Time__c=datetime.now();
               
                }
*/
                if(opp.CEO_Approval_Status__c!='Approved'){
                   SendEmailUtils2.sendToSomeOneId(ca.ID,us2.id,'CommissionApplicationEmail');//CFO邮件
                 
                opp.CMO_Commission_Email__c=true;
                opp.CMO_Commission_Email_Time__c=datetime.now();
                
                }
                if(opp.VP_Approval_Status__c!='Approved'){
                  SendEmailUtils2.sendToSomeOneId(ca.ID,us3.id,'CommissionApplicationEmail');//CFO邮件
                   
                opp.VP_Commission_Email__c=true;
                opp.VP_Commission_Email_Time__c=datetime.now();
                }
                 update opp;
            }
                
             return '1'; 
                
               
               
              

        
    }
     webservice static String resandemailtoMOU(String oppid){
     Opportunity opp=[select id,Destination_Country__c,Account.Sales_Region__c,Owner.BMO_specialist__c,Owner.Contract_Approver__c,SOC_Dept__c,Finance_Approval_Status__c,GM_approval_Status__c,Technical_Dept_Status__c,Legal_Dept__c,VP_Approval_Status__c from Opportunity Where  id=:oppid];   
List<String> emailList = new List<String>();
         User user = [select id, Email, Name, LastName, FirstName from User where Name ='Alex jiang'];
          
		//SOC BMO specialist
		User SOC = [select id, Email, Name, LastName, FirstName, BMO_specialist__r.Email, BMO_specialist__c from User where id =:opp.Owner.BMO_specialist__c];

		//GM
		User GM = [select id, Email, Name, LastName, FirstName from User where id =:opp.Owner.Contract_Approver__c];
                if(opp.SOC_Dept__c=='Pending'){
                   
		emailList.add(SOC.Email);
                 }
         
               if(opp.Finance_Approval_Status__c=='Pending'){
                   emailList.add(user.Email);
                 }
             
                   if(opp.GM_approval_Status__c=='Pending'){
		emailList.add(GM.Email);
                 }
             	
                   if(opp.Technical_Dept_Status__c=='Pending'){
                       if (opp.Account.Sales_Region__c != null){
			if (opp.Account.Sales_Region__c == 'Middle East&Africa' || opp.Account.Sales_Region__c == 'MENA' || opp.Account.Sales_Region__c == 'SSA' || opp.Account.Sales_Region__c == 'Latin America&Italy' || opp.Account.Sales_Region__c == 'South Asia') {
				List<User> technicalUser01 = [SELECT Id, Name, Email, UserRole.Name, Alias FROM USER WHERE Alias =: 'technic2'];
				emailList.add(technicalUser01[0].Email);

			} else if (opp.Account.Sales_Region__c.contains('EU') || opp.Account.Sales_Region__c == 'ROA' || opp.Account.Sales_Region__c == 'North America' || opp.Account.Sales_Region__c == 'North Asia' || opp.Account.Sales_Region__c == 'Central Asia') {
				List<User> technicalUser02 = [SELECT Id, Name, Email, UserRole.Name, Alias FROM USER WHERE Alias =: 'tech'];
				emailList.add(technicalUser02[0].Email);
			}
		}
                 }
             
                   if(opp.Legal_Dept__c=='Pending' && opp.Technical_Dept_Status__c=='Approved' && opp.GM_approval_Status__c=='Approved' && opp.SOC_Dept__c=='Approved' && opp.Finance_Approval_Status__c=='Approved'){
                       if(opp.Destination_Country__c=='Japan'){
                           User legalJP = [select id, Email, Name, LastName, FirstName from User where Name ='Legal Japan'];
                           emailList.add(legalJP.Email);
                       }
                       else{
                        User legal = [select id, Email, Name, LastName, FirstName from User where Name ='Legal Public'];
                           emailList.add(legal.Email);
                       }
                 }
             
                   if(opp.VP_Approval_Status__c=='Pending'&& opp.Legal_Dept__c=='Approved'){
                        User VP = [select id, Email, Name, LastName, FirstName from User where Name ='Wang Jeffrey'];
                           emailList.add(VP.Email);
                 }
            
                MOUApprovalController.sendApprovalEmail(oppid, emailList);
             return '1'; 
                
               
               
              

        
    }
    webservice static String Checkpayment100(String oppid){
   List<Payment__c> payLst = [select id,Amount__c,Percentage__c,Down_Balance_Payment__c,PaymentDescription__c,payment_Method__c,Days__c,Payment_Term__c,Opportunity__c from Payment__c where Opportunity__c =:oppid ];
        Decimal i = 0;
        for(Payment__c p:paylst){
            i = i+p.Percentage__c;
        }
        if( String.valueOf(i) =='100' || String.valueOf(i) =='100.00'){
        return   '1';
        }else{
              return   '0';   
            }
    }
      webservice static String checkfreight(String oppid){
          opportunity opp =[select id,Trade_Term__c,Warehouse_or_Factory__c,Local_Warehouse__c,Ocean_Freight_Oversea__c,Ocean_Freight__c,Land_Freight_Oversea__c from opportunity where id=:oppid];
          if((opp.Trade_Term__c.startswith('C') && (opp.Ocean_Freight__c==0 || opp.Ocean_Freight__c==null)) 
             ||((opp.Trade_Term__c=='FOB'||opp.Trade_Term__c=='FCA' ||opp.Trade_Term__c=='EXW')&& opp.Warehouse_or_Factory__c =='Warehouse' && opp.Local_Warehouse__c!=null && (opp.Ocean_Freight__c==0 || opp.Ocean_Freight__c==null))
             || (opp.Trade_Term__c.startswith('D') && (opp.Ocean_Freight__c==0 || opp.Ocean_Freight__c ==null ||( opp.Land_Freight_Oversea__c==0 || opp.Land_Freight_Oversea__c==null)) )){
                      return   '1';
              
          }else{
                      return   '0';
          }
          }
}