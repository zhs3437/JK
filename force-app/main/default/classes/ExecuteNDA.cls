global with sharing class ExecuteNDA {
	global static Account con{get;set;}
     global static Requested_NDA__c RNDA{get;set;}
       
     webService static  string clickNewButton(  String id  ){
    
    Account acc = [select id from Account where ID =:id];
    RNDA = new Requested_NDA__c();
    RNDA.Account_Name__c = acc.Id;
    insert RNDA;
    return RNDA.Id;
  }
}