trigger SAPIDTrigger on SAPID__c (after insert) {
    try{
        List<Order> ordLst = [select id,OA_External_ID__c,SAP_External_ID__c,SAP_Describe__c 
                                from Order 
                                where OA_External_ID__c != null And SAP_External_ID__c =: null 
                                 And OA_External_ID__c != '-7' 
                                And OA_External_ID__c != '-4' And OA_External_ID__c != '-2'
                                order by createdDate Desc Limit 25]; 
        List<Account> accLst  = [select id,OA_External_ID__c,SAP_External_ID__c,SAP_Describe__c 
                           from Account 
                           where OA_External_ID__c != null And SAP_External_ID__c =: null 
                           And OA_External_ID__c != '-7' 
                           And OA_External_ID__c != '-4' And OA_External_ID__c != '-2'
                           order by createdDate Desc Limit 25];

        for(SAPID__c o: trigger.new){
            if (ordLst.size() > 0) {
                for (Order ord :  ordLst) {
                    if (ord.OA_External_ID__c == o.Name) {
                        ord.SAP_External_ID__c = o.SFID__c;
                        ord.SAP_Describe__c =o.sapde__c;
                        system.debug('----- OAID ' + o.Name);
                        system.debug('----- SAPID ' + o.SFID__c);
                        system.debug('----- SAP miaoshu  ' + o.sapde__c);
                        update ord;
                    }
                }
            }
            if (accLst.size() > 0) {
                for (Account acc : accLst) {
                    if (acc.OA_External_ID__c == o.Name) {
                     acc.SAP_Describe__c = o.sapde__c;
                     acc.SAP_External_ID__c = o.SFID__c;
                     system.debug('-----Account OAID ' + o.Name);
                     system.debug('-----Account SAPID ' + o.SFID__c);
                     system.debug('-----Account SAP miaoshu  ' + o.sapde__c);
                     update acc; 
                    }
                }
            }            
        }
    }catch(Exception e){
        System.debug('-----> '+e.getMessage());
    }
    
}