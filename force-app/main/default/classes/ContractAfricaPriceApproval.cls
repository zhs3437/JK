global class ContractAfricaPriceApproval {
    public Contract con  {get;set;}
    webservice static boolean submit(String conId){
        if(string.isEmpty(conId))return false;
        system.debug('----1111');
        Contract con = [select Id,Region__c,OwnerId,RecordType.name,Opportunity__r.Excluding_VAT__c from Contract where id=:conId];
        system.debug('----2222');
        boolean flag =false;
        if((con.Region__c == 'Middle East&Africa'||con.Region__c == 'MENA'||con.Region__c == 'SSA') && con.RecordType.Name == '1MW Global Standard Contract'){
            system.debug('----3333');
            if(con.Opportunity__r.Excluding_VAT__c == true){
                flag= true;
                
            }else{
                flag = false;
                system.debug('----flag:'+flag);
            }
        }else{
            flag = false;
            system.debug('----flag:'+flag);
        }
        return  flag;
    }
     webservice static void SendEmail(String conId){
        
        Contract con = [select Id,Region__c,OwnerId,RecordType.name,Opportunity__r.Excluding_VAT__c from Contract where id=:conId];
        //boolean flag = ContractAfricaPriceApproval.submit(con.Id);
        //if(flag){
            SendEmailUtils.sendToSomeOne(con.Id,'Joanna Zhuona','Contract_Africa_Send_Email');
            system.debug('------>1:'+con.Id);
            SendEmailUtils.sendToSomeOne(con.Id,'Andrew gilbert ','Contract_Africa_Send_Email');
            system.debug('------>2:'+con.Id);
            SendEmailUtils.sendToConOwner(con.Id,con.OwnerId);
            system.debug('------>3:'+con.OwnerId);
            SendEmailUtils.sendToConBMO(con.Id,con.OwnerId);
            system.debug('------>4:'+con.OwnerId);
        //   system.debug('----flag:'+flag);
        //}
    }
    
    
}