public class PowerbookHeaderCtrl {    
    public boolean flag{get;set;}
     public boolean approve{get;set;}
     public Decimal  MW{get;set;}
      public String  powerbookid{get;set;}
        public PowerbookHeaderCtrl(apexpages.StandardController std){
             powerbookid=std.getid();
              
            CapacityReservation__c cr=[select id,area__c,change__c,Opportunity__c,Price_Approval_Status__c,wattage__c,contract__c from CapacityReservation__c where id=:powerbookid];
           MW=cr.wattage__c;
            approve=false;
            if(cr.Price_Approval_Status__c==true){
                approve=true;
            }
            List<PowerProduct__c> pplst=[select id,Product__r.name,Quantity__c,Unit_Price__c,Guaranteed_Delivery_Date__c from PowerProduct__c where Powerbooked__c =:cr.id];
           
        String oppid =cr.Opportunity__c;
        Opportunity opp=[select Region__c,Total_MW__c from Opportunity where id=:oppid];
                List<OpportunityLineItem> pdLst =[select id,Product2.name,Quantity,UnitPrice,Total_Power_W__c,
                                            Cheetah__c,Total_Price__c,
                                            Back_Sheet__c,Frame_Color__c,Cell_Appearance__c,
                                            Cable_Length__c,Connector__c,MP__c,Solar_Cell__c,EVA__c,
                                            Ribbon__c,Others__c,Tolerance__c,Junction_Box__c,
                                            Frame__c,Serial_No__c,Package__c,Label__c,
                                            Unit_Price_Without_Commission__c,Commission_Per_W__c
                                            ,Certification__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                                            Guaranteed_Delivery_Date_japan__c  from OpportunityLineItem where Opportunityid=:oppid];
                    flag=false;
                if(opp.Region__c!=cr.area__c || opp.Total_MW__c!=cr.wattage__c){
        flag=true;
                }else{
                   if(pplst.size()!=pdlst.size()){
                       flag=true;
                   }else{
                       String Tf;
                       for(OpportunityLineItem new2:pdLst){
                    for(PowerProduct__c old :ppLst){

                        if(new2.Product2.name==old.Product__r.name && new2.Quantity==old.Quantity__c && new2.UnitPrice==old.Unit_Price__c && new2.Guaranteed_Delivery_Date__c==old.Guaranteed_Delivery_Date__c){
                            system.debug('找到没有修改交期的');
                            Tf='0';
                            break;
                        }else{
                            Tf='1';
                        }
                    } 
                           if(Tf=='1'){
                               system.debug('测试');
                               flag=true;
                               return;
                           }

                }
                   } 
                    
                }
        }
        public void update2(){
      CapacityReservation__c cr=[select id,area__c,change__c,Price_Approval_Status__c,wattage__c,contract__c from CapacityReservation__c where id=:powerbookid];
     cr.change__c=flag;
            update cr;
 }
    }