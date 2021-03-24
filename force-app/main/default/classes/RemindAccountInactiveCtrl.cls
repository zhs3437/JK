public class RemindAccountInactiveCtrl {
    public String requestId {get;set;}
    Public boolean flag {get;set;}
     public RemindAccountInactiveCtrl(ApexPages.StandardController sd){
        flag=false;
        requestId = ApexPages.currentPage().getParameters().get('id');
         Opportunity opp = [Select id,name,AccountId from opportunity where id=:requestId];
         system.debug(opp);
        Account acc = [select id,name,Customer_Status__c from Account where id=:opp.AccountId ];
        if(acc.Customer_Status__c=='Indirect'||acc.Customer_Status__c=='Inactive'){
         flag=true;
        }
         system.debug('flag'+flag);
            }
}